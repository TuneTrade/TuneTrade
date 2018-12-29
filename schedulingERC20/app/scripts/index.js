// Import the page's CSS. Webpack will know what to do with it.
import 'normalize.css'
import 'semantic-ui-css/semantic.min.css'
import '../styles/app.css'

import { default as Web3 } from 'web3'

import controllerArtifact from '../../build/contracts/Controller.json'
import scheduleClientArtifact from '../../build/contracts/ScheduleClient.json'
import ierc20Artifact from '../../build/contracts/IERC20.json'

const $ = window.jQuery

// variables
let etherscan
const gasLimit = 140000
const gasPrice = 17500000000

const mainnet = {
  name: 'Mainnet',
  id: 1,
  url: 'https://etherscan.io',
  controller: '0xf6f897cb10c98921471942a565159097a01dcc0f'
}

const ropsten = {
  name: 'Ropsten',
  id: 3,
  url: 'https://ropsten.etherscan.io',
  controller: '0x930bcb1fc0fe8e00658abb0fa5239e3c7d9d39a0'
}

// web3 state
let networkName
let accounts
let account
let schedulesAmount

// instances
let controllerAddress
let controllerInstance
let clientInstance
let scheduleHashes = []
let fee
let updaterInterval

// APPLICATION
const App = {
  start: async function () {
    const netId = await web3.eth.net.getId()
    switch (netId) {
      case mainnet.id:
        networkName = mainnet.name
        controllerAddress = mainnet.controller
        etherscan = mainnet.url
        break
      case ropsten.id:
        networkName = ropsten.name
        controllerAddress = ropsten.controller
        etherscan = ropsten.url
        break
      case null:
        alert('Seems you have have not connection with web3, please reopen your Metamask/Mist.')
        break
      default:
        alert('Please switch to the Ropsten network for testing')
        return
    }

    // Get the initial account balance so it can be displayed.
    accounts = await web3.eth.getAccounts()

    if (accounts === null) {
      alert('There was an error fetching your accounts.')
      return
    } else if (accounts.length === 0) {
      alert("Couldn't get any accounts! Make sure your Ethereum client is configured correctly.")
      return
    }

    account = accounts[0]
    controllerInstance = this.returnInstance(controllerArtifact.abi, controllerAddress)

    $('#myaccount').attr('href', `${etherscan}/address/${account}`)
    $('#contollerAddress').attr('href', `${etherscan}/address/${controllerAddress}`)
    $('#contollerAddress').text(`dApp smart contract - ${controllerAddress}`)

    this.runSemanticUiStaff()
    await this.updateAccountDetails()
    await this.updateSchedulesList()
    await this.adminAreaInit()
  },

  runAutoUpdater: function () {
    updaterInterval = setInterval(() => {
      this.updateAccountDetails()
      this.updateSchedulesList()
    }, 60000)
  },

  runSemanticUiStaff: function () {
    $('.ui.dropdown').dropdown()
    $('#addSchedule').form({
      fields: {
        receiver: {
          identifier: 'receiver',
          rules: [
            {
              type   : 'exactLength[42]',
              prompt : 'Please enter valid receiver address (42 symbols)'
            }
          ]
        },
        tokenAddr: {
          identifier: 'tokenAddr',
          rules: [
            {
              type   : 'exactLength[42]',
              prompt : 'Please enter valid token contract address (42 symbols)'
            }
          ]
        },
        tokens: {
          identifier: 'tokens',
          rules: [
            {
              type   : 'empty',
              prompt : 'Please enter valid tokens amount'
            }
          ]
        },
        delay: {
          identifier: 'delay',
          rules: [
            {
              type   : 'empty',
              prompt : 'Please enter valid delay'
            }
          ]
        },
        executions: {
          identifier: 'executions',
          rules: [
            {
              type   : 'empty',
              prompt : 'Please enter valid executions amount (should be bigger then 1)'
            }
          ]
        }
      },
      onSuccess: (event) => {
        event.preventDefault()
        this.addScheduleTransaction()
      }
    })
    $('.ui.button.info')
      .popup({
        html: `<p>
        To create a new token transfer schedule
        please fill in all required inputs
        <br/>
        <br/>
        You will be prompted to confirm 2 transactions
        to complete a schedule
        <br/>
        <br/>
        1st to create a schedule
        <br/>
        2nd to transfer tokens
        <br/>
        </p>`
      })
  },

  updateAccountDetails: async function () {
    const r = document.getElementById('accountdetails').rows
    const clientAddr = await controllerInstance.methods.getUserContractAddress(account).call()

    if (clientAddr === '0x0000000000000000000000000000000000000000') {
      r[1].cells[0].innerHTML = 'The account does not exist (create a schedule to start)'
      r[1].cells[1].innerHTML = '-'
      r[1].cells[2].innerHTML = '_'
      r[1].cells[3].innerHTML = networkName
      $('#activeTxs tbody tr').remove()
    } else if (clientAddr.length === 42) {
      clientInstance = this.returnInstance(scheduleClientArtifact.abi, clientAddr)
      const ethBalance = await this.getETHBalance(clientAddr)
      schedulesAmount = await this.getId()

      r[1].cells[0].innerHTML = `<a href="${etherscan}/address/${clientAddr}" target="_blank">${clientAddr}<a/>`
      r[1].cells[1].innerHTML = schedulesAmount
      r[1].cells[2].innerHTML = ethBalance + ' ETH'
      r[1].cells[3].innerHTML = networkName
      $('[id=emergencyExit]')[0].disabled = false
    }
  },

  updateSchedulesList: async function () {
    clearInterval(updaterInterval)
    const table = document.getElementById('activeTxs')
    const row = table.insertRow(1)
    const cell1 = row.insertCell(0)

    row.innerHTML = '<div id="loader"><div class="ui inline active loader"></div> Loading Blockchain Data</div>'
    cell1.innerHTML = '<div class="ui inline active loader"></div> Pending'

    let active = []
    let canceled = []
    let executed = []
    scheduleHashes = []

    for (let i = 0; i < schedulesAmount; i++) {
      const hash = await this.getHash(i)
      const data = await this.getHashInfo(hash)

      if (localStorage.getItem(hash) === null) {
        const tokenInstance = this.returnInstance(ierc20Artifact.abi, data.tokenAddress)
        const schedule = {
          [account] : {
            note: localStorage.getItem(i) !== null ? localStorage.getItem(i) : '-',
            tokensPerDelay: await this.removeDecimalPart(
              data.tokensPerDelay,
              tokenInstance
            ),
            token: {
              name: await tokenInstance.methods.name().call(),
              symbol: await tokenInstance.methods.symbol().call()
            }
          }
        }
        localStorage.setItem(hash, JSON.stringify(schedule))
      }

      const scheduleDetails = JSON.parse(localStorage.getItem(hash))[account]

      data.id = hash
      data.note = scheduleDetails.note
      data.tokenName = scheduleDetails.token.name
      data.tokenSymbol = scheduleDetails.token.symbol
      data.tokensPerDelay = scheduleDetails.tokensPerDelay

      scheduleHashes.push(hash)
      if (data.canceled === true) {
        canceled.push(data)
      } else if (data.executionsAmount === data.executed) {
        executed.push(data)
      } else {
        active.push(data)
      }
    }

    this.showTransactions(active, canceled, executed)
  },

  showTransactions: function (active, canceled, executed) {
    $('#activeTxs tbody tr').remove()
    const table = document.getElementById('activeTxs').getElementsByTagName('tbody')[0]

    // Executed
    for (let i = 0; i < executed.length; i++) {
      let row = table.insertRow(0)
      row.setAttribute('id', executed[i].id)
      row.innerHTML =
      `
      <td class="ui transparent input" title="Click for edit"><input type="text" value="${executed[i].note}" /></td>
      <td><a href="${etherscan}/token/${executed[i].tokenAddress}"
      target="_blank">${executed[i].tokenName} (${executed[i].tokenSymbol})</td>
      <td><a href="${etherscan}/address/${executed[i].receiver}"
      target="_blank">Address</td>
      <td style='color: #767676'>Executed</td>
      <td>${executed[i].tokensPerDelay} ${executed[i].tokenSymbol} / ${executed[i].delay}</td>
      <td>${executed[i].executed} / ${executed[i].executionsAmount}</td>
      <td>${executed[i].creationDate}</td>
      <td>${executed[i].startScheduleLater}</td>
      <td><button class="ui compact mini red button" type="submit"
      onclick="App.cancelTx('${executed[i].hash}')" disabled>Cancel</button></td>`
    }

    // Cancelled
    for (let i = 0; i < canceled.length; i++) {
      let row = table.insertRow(0)
      row.setAttribute('id', canceled[i].hash)
      row.innerHTML =
      `
      <td class="ui transparent input" title="Click for edit"><input type="text" value="${canceled[i].note}" /></td>
      <td><a href="${etherscan}/token/${canceled[i].tokenAddress}"
      target="_blank">${canceled[i].tokenName} (${canceled[i].tokenSymbol})</td>
      <td><a href="${etherscan}/address/${canceled[i].receiver}"
      target="_blank">Address</td>
      <td style='color: #db2828'>Canceled</td>
      <td>${canceled[i].tokensPerDelay} ${canceled[i].tokenSymbol} / ${canceled[i].delay}</td>
      <td>${canceled[i].executed} / ${canceled[i].executionsAmount}</td>
      <td>${canceled[i].creationDate}</td>
      <td>${canceled[i].startScheduleLater}</td>
      <td><button class="ui compact mini red button" type="submit"
      onclick="App.cancelTx('${canceled[i].hash}')" disabled>Cancel</button></td>`
    }

    // active
    for (let i = 0; i < active.length; i++) {
      let row = table.insertRow(0)
      row.setAttribute('id', active[i].hash)
      row.innerHTML =
      `
      <td class="ui transparent input" title="Click for edit"><input type="text" value="${active[i].note}" /></td>
      <td><a href="${etherscan}/token/${active[i].tokenAddress}"
      target="_blank">${active[i].tokenName} (${active[i].tokenSymbol})</td>
      <td><a href="${etherscan}/address/${active[i].receiver}"
      target="_blank">Address</td>
      <td style='color: #21ba45'>Active</td>
      <td>${active[i].tokensPerDelay} ${active[i].tokenSymbol} / ${active[i].delay}</td>
      <td>${active[i].executed} / ${active[i].executionsAmount}</td>
      <td>${active[i].creationDate}</td>
      <td>${active[i].startScheduleLater}</td>
      <td><button class="ui compact mini red button" type="submit"
      onclick="App.cancelTx('${active[i].hash}')">Cancel</button></td>`
    }

    $('#activeTxs #loader').remove()
    $('.transparent.input input').focusout(function () {
      const hash = $(this).closest('tr').attr('id')
      const value = $(this).val()
      const schedule = {
        [account]: {
          ...JSON.parse(localStorage.getItem(hash))[account],
          note: value
        }
      }
      localStorage.setItem(hash, JSON.stringify(schedule))
    })

    this.runAutoUpdater()
  },

  // -----------------------------------------
  // SETTERS FROM CLIENT CONTRACT
  // -----------------------------------------

  addScheduleTransaction: async function () {
    const tokens = $('[name=tokens]').val()
    const tokenAddr = $('[name=tokenAddr]').val()
    const interval = $('[name=interval]').val()
    const delay = $('[name=delay]').val()
    const executions = $('[name=executions]').val()
    const receiver = $('[name=receiver]').val()
    const note = $('[name=note]').val()
    const fsInterval = $('[name=fsinterval]').val()
    const fsDelay = $('[name=fsdelay]').val()

    // Making instance for this token
    const tokenInstance = this.returnInstance(ierc20Artifact.abi, tokenAddr)

    // Fetching decimal of this token
    const decimals = web3.utils.toBN(await this.getDecimals(tokenInstance))

    if (!this.userHasTokens(tokenInstance)) {
      return false
    }

    // Receiver address
    const to = web3.utils.toChecksumAddress(receiver)

    // Calculating tokens amount (bigNumber)
    const tokensPerDelay = web3.utils.toBN(tokens).mul(web3.utils.toBN(10).pow(decimals))

    // Caclulating total supply of tokens
    const totalTokensForTransfer = tokensPerDelay.mul(web3.utils.toBN(executions))
    const executionsUNIX = this.normalToUnixDate(interval, delay)

    // detect if user selects the first schedule date
    const firstScheduleUNIX = fsDelay !== '' ? this.normalToUnixDate(fsInterval, fsDelay) : 0

    await this.callScheduleCalls(to, executionsUNIX, executions, tokensPerDelay, note, firstScheduleUNIX, tokenInstance)
    await this.tokensTransfer(totalTokensForTransfer, tokenInstance)
  },

  callScheduleCalls: async function (to, executionsUNIX, executions, tokensPerDelay,
    note, firstScheduleUNIX, tokenInstance) {
    // disabling reloading until transaction success
    this.toggleAlertInReload(true)

    const value = ((firstScheduleUNIX === 0 ? executions : parseInt(executions) + 1) *
    gasLimit * gasPrice) + parseInt(fee)

    tokensPerDelay = tokensPerDelay.toString()

    let txHash
    await controllerInstance.methods.scheduleCall(to, executionsUNIX, executions,
      tokensPerDelay, firstScheduleUNIX, tokenInstance._address)
      .send({
        from: account,
        value: value
      })
      .on('transactionHash', (hash) => {
        txHash = hash
        this.showPendingTx(txHash)
      })
      .on('receipt', () => console.log('new schedule call created!'))
      .on('error', console.error)
      .then(async () => {
        $(`#${txHash}`).remove()
        await this.updateAccountDetails()
        const id = await this.getId()
        localStorage.setItem(id - 1, note)
        await this.updateSchedulesList()
      })
  },

  tokensTransfer: async function (amount, tokenInstance) {
    amount = amount.toString()

    let txHash
    await tokenInstance.methods.transfer(clientInstance._address, amount)
      .send({
        from: account
      })
      .on('transactionHash', (hash) => {
        txHash = hash
        this.showPendingTx(txHash)
      })
      .on('receipt', () => console.log('tokens transfered!'))
      .on('error', console.error)
      .then(async () => {
        $(`#${txHash}`).remove()
        this.toggleAlertInReload(false)
      })
  },

  cancelTx: async function (hash) {
    const data = await this.getHashInfo(hash)
    const createdAtUnix = (new Date(data.creationDate).getTime() / 1000)
    const delay = parseInt(data.delay) * 60
    const executed = data.executed
    const executionsAmount = data.executionsAmount
    const now = await web3.eth.getBlock('latest').then(res => res.timestamp)

    if (
      (
        now < createdAtUnix + ((executed + 1) * delay) - 120 ||
        now > createdAtUnix + ((executed + 1) * delay) + 120
      ) && (
        executionsAmount > executed
      )
    ) {
      let txHash
      await clientInstance.methods.cancel(hash)
        .send({ from: account })
        .on('transactionHash', (hash) => {
          txHash = hash
          this.toggleAlertInReload(true)
          this.showPendingTx(txHash)
        })
        .on('receipt', () => console.log('schedule call canceled!'))
        .on('error', console.error)
        .then(async () => {
          $(`#${txHash}`).remove()
          await this.updateAccountDetails()
          await this.updateSchedulesList()
          this.toggleAlertInReload(false)
        })
    } else if (executionsAmount === executed) {
      alert('The schedule was finished')
    } else {
      alert('Due security reasons You cannot cancel schedule call +- 2 minutes from next scheduled call')
    }
  },

  emergencyExit: async function () {
    if (
      confirm(`
      ATTENTION - WARNING
        If you continue you will:
        - Disable all scheduled transfers
        - Return all unsent tokens and eth to your address
        - Delete your contract account and reset everything
        Are you sure you want to do this?
      `)
    ) {
      let txHash
      await controllerInstance.methods.deleteAccount()
        .send({ from: account })
        .on('transactionHash', (hash) => {
          txHash = hash
          this.toggleAlertInReload(true)
          this.showPendingTx(txHash)
        })
        .on('receipt', () => console.log('emergency exit method called!'))
        .on('error', console.error)
        .then(async () => {
          this.toggleAlertInReload(false)
          $(`#${txHash}`).remove()
          localStorage.clear()
          location.reload()
        })
    }
  },

  changeFee: async function () {
    const fee = web3.utils.toWei($('[name=fee]').val(), 'gwei')

    let txHash
    await controllerInstance.methods.changeFee(fee)
      .send({
        from: account
      })
      .on('transactionHash', (hash) => {
        txHash = hash
        this.toggleAlertInReload(true)
        this.showPendingTx(txHash)
      })
      .on('receipt', () => console.log('fee changed!'))
      .on('error', console.error)
      .then(async () => {
        $(`#${txHash}`).remove()
        await this.adminAreaInit()
        this.toggleAlertInReload(false)
      })
  },

  // -----------------------------------------
  // GETTERS FROM CLIENT CONTRACT
  // -----------------------------------------

  getId: async function () {
    return await clientInstance.methods.getId().call()
  },

  getFee: async function () {
    return await controllerInstance.methods.getFee().call()
  },

  getHash: async function (id) {
    return await clientInstance.methods.schedules(id).call()
  },

  getIsOwner: async function () {
    return await controllerInstance.methods.isOwner(account).call()
  },

  getDecimals: async function (tokenInstance) {
    return await tokenInstance.methods.decimals().call()
  },

  getHashInfo: async function (hash) {
    return await clientInstance.methods.getScheduleDetails(hash).call().then(data => {
      return {
        receiver: web3.utils.toChecksumAddress(data[0]),
        delay: parseInt(data[1] / 60) + ' min',
        executed: parseInt(data[7]) > 0 ? (data[2] === '0' ? 0 : parseInt(data[2]) - 1) : parseInt(data[2]),
        executionsAmount: parseInt(data[7]) > 0 ? parseInt(data[3]) - 1 : parseInt(data[3]),
        tokensPerDelay: data[4],
        canceled: data[5],
        creationDate: this.unixToNormalDate(data[6]),
        startScheduleLater: this.unixToNormalDate(parseInt(data[7]) + parseInt(data[6])),
        tokenAddress: web3.utils.toChecksumAddress(data[8]),
        hash: hash.toString()
      }
    })
  },

  getTokenAmount: async function (tokenInstance, address) {
    return await tokenInstance.methods.balanceOf(address).call()
  },

  getETHBalance: async function (address) {
    return web3.utils.fromWei(await web3.eth.getBalance(web3.utils.toChecksumAddress(address)), 'ether')
  },

  // -----------------------------------------
  // HELPERS
  // -----------------------------------------

  removeDecimalPart: async function (amount, tokenInstance) {
    const decimals = web3.utils.toBN(await this.getDecimals(tokenInstance))
    const amountWithoutDecimal = web3.utils.toBN(amount).div(web3.utils.toBN(10).pow(decimals)).toString()
    return amountWithoutDecimal
  },

  showPendingTx: function (res) {
    const table = document.getElementById('submitedTxs')
    const row = table.insertRow(1)
    const cell1 = row.insertCell(0)
    const cell2 = row.insertCell(1)

    table.style.display = 'table'
    row.setAttribute('id', res)
    cell1.innerHTML = `<a href="${etherscan}/tx/${res}" target="_blank">${res}<a/>`
    cell2.innerHTML = '<div class="ui inline active loader"></div> Pending'
  },

  unixToNormalDate: function (unix) {
    // Months array
    const monthsArr = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']

    // Convert unix to milliseconds
    const date = new Date(unix * 1000)

    // Year
    const year = date.getFullYear()

    // Month
    const month = monthsArr[date.getMonth()]

    // Day
    const day = date.getDate()

    // Hours
    const hours = date.getHours()

    // Minutes
    const minutes = '0' + date.getMinutes()

    // Seconds
    const seconds = '0' + date.getSeconds()

    return month + '-' + day + '-' + year + ' ' + hours + ':' + minutes.substr(-2) + ':' + seconds.substr(-2)
  },

  normalToUnixDate: function (interval, delay) {
    let unix
    switch (interval) {
      case 'min':
        unix = delay * 60
        break
      case 'hour':
        unix = delay * 60 * 60
        break
      case 'day':
        unix = delay * 60 * 60 * 24
        break
      case 'year':
        unix = delay * 60 * 60 * 24 * 30
        break
    }
    return unix
  },

  userHasTokens: async function (tokenInstance) {
    const userTokenBalance = await this.getTokenAmount(tokenInstance, account)
    if (userTokenBalance === '0') {
      alert('You are trying to scheduling tokens which you have not. Please select another ERC20 token.')
      return false
    } else {
      return true
    }
  },

  reloadListener: function (e) {
    e.returnValue = ''
  },

  toggleAlertInReload: function (enable) {
    if (enable) {
      window.addEventListener('beforeunload', this.reloadListener)
    } else {
      window.removeEventListener('beforeunload', this.reloadListener)
    }
  },

  adminAreaInit: async function () {
    fee = await this.getFee()
    if (await this.getIsOwner()) {
      $('#owner_area').show()
      let currentFee = web3.utils.fromWei(fee, 'gwei')
      $('.current-fee').html(`Current fee is <b>${currentFee} gWei</b>`)
      $('#changeFeeForm').form({
        fields: {
          fee: {
            identifier: 'fee',
            rules: [
              {
                type   : 'empty',
                prompt : 'Please enter valid number (from 1 to N)'
              }
            ]
          }
        },
        onSuccess: (e) => {
          e.preventDefault()
          this.changeFee()
        }
      })
    } else {
      $('#owner_area').remove()
    }
  },

  returnInstance: function (abi, address) {
    address = web3.utils.toChecksumAddress(address)
    return new web3.eth.Contract(abi, address)
  }
}

window.App = App

window.addEventListener('load', async () => {
  if (window.ethereum) {
    window.web3 = new Web3(window.ethereum)
    try {
      await window.ethereum.enable()
    } catch (error) {
      alert('Please allow the Metamask to using our platform')
    }
  } else if (window.web3) {
    window.web3 = new Web3(web3.currentProvider)
  } else {
    console.log('Non-Ethereum browser detected. You should consider trying MetaMask!')
  }

  App.start()
})
