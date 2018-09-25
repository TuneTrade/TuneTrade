<template>
  <div>
    <b-tabs card class="contractTabs"   v-model="index">
      <b-tab title="General" class="contractTab">
    <b-form @submit="onSubmit" @reset="onReset" v-if="show" class="newContractForm">
      <div class="newContractFormContainer">
      <b-form-group id="typeGroup"
                    label="Type:"
                    label-for="typeGroup"
                    description="Song, Band or Influencer ?">
        <b-form-radio-group id="typeGroup"
                    buttons
                    button-variant="outline-primary"
                    size="sm"
                    optional
                    @change="UnSave()"
                    v-model="form.type"
                    :options="entryTypeOptions"
                    name="radioBtnOutline" />
      </b-form-group>
      <b-form-group id="nameInputGroup"
                    label="Name:"
                    label-for="nameInput">
        <b-form-input id="nameInput"
                      type="text"
                      v-model="form.name"
                      @keydown.native = "UnSave()"
                      optional
                      size="sm"
                      placeholder="Enter name"

                      >
        </b-form-input>
      </b-form-group>
      <b-form-group id="authorNameGroup"
                    label="Author:"
                    label-for="authorName">
        <b-form-input size="sm" id="authorName"
                      type="text"
                      v-model="form.author"
                      @keydown.native = "UnSave()"
                      optional
                      placeholder="Enter author's name">
        </b-form-input>
      </b-form-group>
      <b-form-group id="websiteLink"
                    label="Website:"
                    label-for="website">
        <b-form-input id="website"
                      type="text"
                      v-model="form.website"
                      optional
                      @keydown.native = "UnSave()"
                      size="sm"
                      placeholder="Enter website link">
        </b-form-input>
      </b-form-group>

      <b-form-group id="websiteLink"
                    label="Soundcloud:"
                    label-for="soundcloud">
        <b-form-input id="soudncloud"
                      type="text"
                      v-model="form.soundcloud"
                      optional
                      @keydown.native = "UnSave()"
                      size="sm"
                      placeholder="Enter soundcloud link">
        </b-form-input>
      </b-form-group>

      <b-form-group id="symbolGroup"
                    label="Token Symbol:"
                    label-for="symbol">
        <b-form-input id="symbol"
                      type="text"
                      @keydown.native = "UnSave()"
                      v-model="form.symbol"
                      optional
                      size="sm"
                      placeholder="Enter symbol">
        </b-form-input>
      </b-form-group>
      <b-form-group id="supplyGroup"
                    label="Total Supply [TOKEN]:"
                    label-for="totalSupply"
                    :description="totalSupplyDesc"
                    >
        <b-form-input id="totalSupply"
                      type="text"
                      step="1"
                      min=0
                      @keydown.native = "UnSave()"
                      v-model="form.totalSupply"
                      required
                      size="sm"
                      placeholder="Enter symbol">
        </b-form-input>
      </b-form-group>

      <b-form-group id="decimalsGroup"
                    label="Decimals (Max:18) [NUMBER]:"
                    label-for="decimalsInput">
        <b-form-input id="decimalsInput"
                      type="number"
                      step="1"
                      min=0
                      @keyup.native = "UnSave()"
                      v-model="form.decimals"
                      required
                      size="sm"
                      placeholder="Enter decimals">
        </b-form-input>
      </b-form-group>

      <b-form-group id="pictureGroup"
                    label="Album Image"
                    label-for="picture">
      <b-form-file id="picture"
                      accept=".jpg, .png, .gif"
                      v-model="form.picture"
                      optional
                      ref="picName"
                      @change.native="ReadPicture($event,this)"
                      style="font-size:12px; font-weight:600;height:30px"
                      placeholder="Please provide album image">
        </b-form-file>
      </b-form-group>

      <b-form-group id="exampleInputGroup3" style="grid-row:4"
                    label="Genre:"
                    label-for="exampleInput3">
        <b-form-select id="exampleInput3"
                      :options="genres"
                      optional
                      v-model="form.genre"
                      size="sm"
                      @change="UnSave()"
                      placeholder="Select genre">

        </b-form-select>
      </b-form-group>
      <div style="grid-column:3/4;grid-row:4/6;padding:10px 40px;">
        <img ref="picPreview" style="width:200px;height:200px"></img>

      </div>
      <div style="grid-column:1/3;grid-row:5;">
      <b-form-group  id="descriptionGroup"
                    label="Description:"
                    label-for="description"
                    v-bind:description="numCharacters">
        <b-form-textarea id="description"
                      v-model="form.description"
                      @input="LimitText()"
                      rows=3
                      no-resize
                      wrap
                      max-rows = 6
                      placeholder="Description (Max: 200 characters)">

        </b-form-textarea>

      </b-form-group>
    </div>
      <!-- <b-form-group id="exampleGroup4"> -->
        <!-- <b-form-checkbox-group v-model="form.checked" id="exampleChecks"> -->
          <!-- <b-form-checkbox value="me">Check me out</b-form-checkbox> -->
          <!-- <b-form-checkbox value="that">Check that out</b-form-checkbox> -->
        <!-- </b-form-checkbox-group> -->
      <!-- </b-form-group> -->
    </div>
    </b-form>
  </b-tab>
  <b-tab   :title="ICOTitle"  class="contractTab">
    <ICOContract/>
  </b-tab>
  <b-tab  :disabled="BonusDisabled" :title="'Bonuses ('+ this.BonusYesOrNo +')'"  class="contractTab">
    <Bonuses/>
  </b-tab>
  <b-tab title="Summary & Create" class="contractTab">
    <SummaryNewContract/>
  </b-tab>
</b-tabs>
<!-- {{unsaved}} -->
  </div>
</template>

<script>
var BigNumber = require('bignumber.js')
// import musicGenres from '../musicGenres'
import ICOContract from './ICOContract'
import Bonuses from './Bonuses'
import SummaryNewContract from './SummaryNewContract'
// require('../musicGenres')
var musicGenres = [
  {value: -1, text: 'Please select genre', disabled: true},
  'Alternative',
  'Ambient',
  'Anime',
  'Blues',
  'Children’s Music',
  'Classical',
  'Comedy',
  'Commercial',
  'Country',
  'Dance',
  'Disney',
  'Easy Listening',
  'Electronic',
  'Enka',
  'French Pop',
  'German Folk',
  'German Pop',
  'Fitness & Workout',
  'Hip-Hop/Rap',
  'Holiday',
  'Indie Pop',
  'Industrial',
  'Inspirational – Christian & Gospel',
  'Instrumental',
  'J-Pop',
  'Jazz',
  'K-Pop',
  'Karaoke',
  'Kayokyoku',
  'Latin',
  'New Age',
  'Opera',
  'Polish Folk',
  'Polish Rock',
  'Pop',
  'R&B/Soul',
  'Reggae',
  'Rock',
  'Soundtrack',
  'Tex-Mex',
  'Vocal',
  'World'
]

export default {
  data () {
    return {
      form: {
        name: 'Test Token -Name',
        genre: 'Electronic',
        author: 'Test Author',
        website: 'www.test.com',
        type: '2',
        picture: null,
        symbol: 'SYM',
        displayPic: false,
        totalSupply: 1000,
        description: 'Description',
        decimals: 0,
        soundcloud: '',
        picSrc: ''
      },
      show: true,
      genres: musicGenres,
      unsaved: false,
      index: '',
      entryTypeOptions: [
        {text: 'Song', value: 0},
        {text: 'Band', value: 1},
        {text: 'Influencer', value: 2}
      ]
    }
  },
  components: {
    ICOContract,
    Bonuses,
    SummaryNewContract
  },
  created: function () {
    /* global musicGenres */
    this.genres = musicGenres
    console.log('Music Genres:', this.genres)
    this.UnSave()
  },
  watch: {
    form: function (val) {
      console.log('Form:', val)
    }
  },
  computed: {
    totalSupplyDesc: function () {
      var format = {
        decimalSeparator: '.',
        groupSeparator: ',',
        groupSize: 3,
        secondaryGroupSize: 0,
        fractionGroupSeparator: ' ',
        fractionGroupSize: 0
      }
      BigNumber.config({'FORMAT': format})
      console.log('MAGIER4 ', this.form.decimals, this.form.totalSupply)
      let supply = BigNumber(this.form.totalSupply)
      let decimals = parseInt(this.form.decimals)
      let total = supply.shiftedBy(decimals).toFormat()
      if (this.form.totalSupply.length === 0) total = ''
      return 'Mini tokens (adjusted by decimals places):<br>' + total
    },
    BonusYesOrNo: function () {
      if (this.BonusDisabled) return 'No'
      else return this.$store.state.formB.bonuses
    },
    BonusDisabled: function () {
      if (this.$store.state.formI.ico === 'No') return true
      else return false
    },
    selectSize: function () {
      return parseInt('8')
    },
    ICOTitle: function () {
      var isICO = 'No'
      if (this.$store.state.formI.ico === 'Yes') isICO = 'Yes'
      return 'ICO Contract (' + isICO + ')'
    },
    numCharacters: function () {
      return 'Characters:' + this.form.description.length
    }
  },
  methods: {
    localNumber: function (val) {
      if (isNaN(val)) return 0
      // var entry = parseFloat(val)
      var num = val.toLocaleString()
      return num
    },
    ReadPicture (input) {
      var that = this
      console.log('This is some input:', input)
      if (input.target.files && input.target.files[0]) {
        var reader = new FileReader()
        reader.onload = function (e) {
          console.log(that.$ids)
          console.log(that.$refs)
          that.displayPic = true
          console.log('PicName: ', that.$refs.picName)
          // that.$refs.picPreview.style.width = '100%'
          that.$refs.picPreview.style.height = '8%'
          that.$refs.picPreview.src = '/static/loading.gif'
          that.form.picSrc = e.target.result
          that.$store.state.formG.picSrc = e.target.result
          that.$store.state.formG['picSrc'] = e.target.result
          that.$refs.picPreview.style.border = 'none'
          setTimeout(function () {
            that.$refs.picPreview.style.height = '200px'
            that.$refs.picPreview.src = ''
            that.$refs.picPreview.src = e.target.result
            that.UnSave()
          }, 1300)
        }
        reader.readAsDataURL(input.target.files[0])
      }
    },
    test () {
      console.log('test: ', this.index)
    },
    LimitText () {
      this.form.description = this.form.description.substring(0, 200)
      this.$store.state.formG.description = this.form.description
      this.UnSave()
    },
    UnSave () {
      console.log('Decimals: ', this.form.decimals)
      if (parseInt(this.form.decimals) > 18) this.form.decimals = 18
      if (parseInt(this.form.decimals) === 0) this.form.decimals = 0
      let tmpForm = this.form
      let form = {}
      this.form = form
      form['picSrc'] = tmpForm.picSrc
      for (var key in tmpForm) {
        console.log('12345form[' + key + '] = ' + tmpForm[key])
        form[key] = tmpForm[key]
        this.$store.state.formG[key] = form[key]
      }
      this.$store.state.formG = form
      this.$store.state.formG.picSrc = form['picSrc']
      // this.form = form
      console.log('Stored form: ', this.$store.state.form)
      this.unsaved = true
    },
    onSubmit (evt) {
      this.unsaved = false
      evt.preventDefault()
      // alert(JSON.stringify(this.form))
    },
    onReset (evt) {
      evt.preventDefault()
      /* Reset our form values */
      this.form.email = ''
      this.form.name = ''
      this.form.author = ''
      this.form.symbol = ''
      this.form.genre = ''
      this.form.symbol = ''
      this.form.website = ''
      this.form.type = ''
      this.unsaved = false
      /* Trick to reset/clear native browser form validation state */
      this.show = false
      this.$nextTick(() => { this.show = true })
    }
  }
}
</script>

<!-- b-form-1.vue -->
