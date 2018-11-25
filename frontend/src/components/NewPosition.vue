<template>
    <div class="newContractFormContainer" >
        <div style="grid-column:2/5; grid-row:1/2;text-align:center;margin:20px;font-family:Roboto">
            Adding new position for {{SongOrBand(item.Type)}}  "{{item.Name}}"

        </div>
        <b-img style="grid-row:1/3" blank-color='#777' v-bind:src='picLink(item.Id)' height='150'/>

      <b-form-group id="typeGroup"
                    label="Type:"
                    label-for="typeGroup"
                    description="Buy or Sell ?"
                    class="newContractLabel"
                    >
        <b-form-radio-group id="typeGroup"
                    buttons
                    button-variant="outline-primary"
                    size="sm"
                    optional
                    @change=""
                    v-model="type"
                    :options="['Buy', 'Sell']"
                    name="radioBtnOutline"
                    style=""
                    />
        </b-form-group>

        <b-form-group
            id="volumeGroup"
            label="Volume:"
            label-for="volumeInput"
            class="newContractLabel"
        >
            <b-form-input
                id="volumeInput"
                type="number"
                step="1"
                min="0"
                v-model = 'volume'
                required
                size="sm"
                placeholder="Enter volume"
                class="newContractInput"
            ></b-form-input>
        </b-form-group>

        <b-form-group
            id="costGroup"
            label="Cost:"
            label-for="costInput"
            class="newContractLabel"
        >
            <b-form-input
                id="costInput"
                type="number"
                step="0.000001"
                min="0"
                v-model = 'cost'
                required
                size="sm"
                placeholder="Enter cost"
                class="newContractInput"
            ></b-form-input>
        </b-form-group>
        <div style="white-space:nowrap">Your balance: {{SongBalance(item.Decimals, item.ownedTokens)}} {{item.Symbol}} </div>
        <b-button @click.stop="AddPosition()" style="grid-column:4/5" size='sm' variant="info"> Add Position </b-button>
    </div>
</template>


<script>
// import axios from 'axios'
var BigNumber = require('bignumber.js')
// var SC = require('soundcloud')
// require('./saleContractdef.js')
// SC.initialize('rZY6FYrMpGVhVDfaKEHdCaY8ALekxd8P')

// SC.initialize('174155989')

// var URI = require('uri-js')

// var Web3 = require('web3')

export default {
    data() {
        return {
            volume: 1,
            cost: 1,
            type:'Buy',
            item: {}
        }
    },
    props: {
        song: String
    },
    created: function () {
    this.item = this.$store.getters.getSong(this.song)
    },
    methods: {
        SongBalance: function(decimals, volume) {
            return BigNumber(volume).shiftedBy(0-decimals).toFormat(6)
        },
        picLink: function (id) {
        console.log('Pic Link:', id)
        if (id === undefined) {
            return null
        }
        return this.$store.state.API + '/getPicture?id=' + id
        console.log('Picture ID')
        // return 'https://source.unsplash.com/random/480x480'
        },
        SongOrBand: function (val) {
            switch (parseInt(val)) {
            case 0:
                return 'Song'
            case 1:
                return 'Band'
            case 2:
                return 'Influencer'
            case 3:
                return 'All'
            default:
                return 'Error'
            }
        },
        AddPosition: function () {
            var that = this
            var cost = web3.toWei(this.cost,"ether")
            var contract = that.$store.state.web3exchangeContract
            var volume = BigNumber(this.volume).shiftedBy(this.item.Decimals).toString()
            
            this.$store.dispatch('AddTransaction', {
                title: 'Add New Position'
            })
            var txind = this.$store.getters.getTransactionIndex
            var type
            if (this.type === 'Buy') {
                type = true 
                var valuecost = cost
            }
            else {
                type = false
                valuecost = 0
            }
            contract.AddPosition(this.item.address, volume, type, cost, {value: valuecost}, 
                function (err, res) {
                if (res !== undefined) {
                    that.$store.dispatch('UpdateTransactionMining', {
                    index: txind,
                    number: res
                    })
                } else {
                    that.$store.dispatch('UpdateTransactionCancelled', {
                    index: txind,
                    msg: err.message
                    })
                }
                }
            )
            },
    }
}

</script>
