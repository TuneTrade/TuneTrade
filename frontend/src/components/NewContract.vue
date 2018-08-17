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
                    :options="['Song', 'Band','Influencer']"
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
                    label="Total Supply:"
                    label-for="totalSupply">
        <b-form-input id="totalSupply"
                      type="number"
                      step="1"
                      @keydown.native = "UnSave()"
                      v-model="form.totalSupply"
                      required
                      size="sm"
                      placeholder="Enter symbol">
        </b-form-input>
      </b-form-group>

      <b-form-group id="pictureGroup"
                    label="Album Image"
                    label-for="picture">
      <b-form-file id="picture"
                      v-model="form.picture"
                      optional
                      @change = "UnSave()"
                      style="font-size:12px; font-weight:600;height:30px"
                      placeholder="Please provide album image">
        </b-form-file>
      </b-form-group>

      <b-form-group id="exampleInputGroup3"
                    label="Genre:"
                    label-for="exampleInput3">
        <b-form-select id="exampleInput3"
                      :options="genres"
                      optional
                      v-model="form.genre"
                      size="sm"
                      @change="UnSave()"
                      select-size="selectSize"
                      placeholder="Select genre">

        </b-form-select>
      </b-form-group>
      <!-- <b-form-group id="exampleGroup4"> -->
        <!-- <b-form-checkbox-group v-model="form.checked" id="exampleChecks"> -->
          <!-- <b-form-checkbox value="me">Check me out</b-form-checkbox> -->
          <!-- <b-form-checkbox value="that">Check that out</b-form-checkbox> -->
        <!-- </b-form-checkbox-group> -->
      <!-- </b-form-group> -->
    </div>
      <b-button v-bind:disabled="!unsaved" type="submit" variant="primary">Save</b-button>
      <b-button type="reset" variant="danger">Reset</b-button>
    </b-form>
  </b-tab>
  <b-tab  title="ICO Contract"  class="contractTab">
    <ICOContract/>
  </b-tab>
  <b-tab  title="Bonuses"  class="contractTab">
    <Bonuses/>
  </b-tab>
  <b-tab title="Summary & Create" class="contractTab">
    <SummaryNewContract/>
  </b-tab>
</b-tabs>
{{unsaved}}
  </div>
</template>

<script>
// import musicGenres from '../musicGenres'
import ICOContract from './ICOContract'
import Bonuses from './Bonuses'
import SummaryNewContract from './SummaryNewContract'
// require('../musicGenres')
var musicGenres = [
  {value: null, text: 'Please select genre', disabled: true},
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
        name: 'Test Token',
        genre: 'Electronic',
        author: 'Test Author',
        website: 'www.test.com',
        type: 'Band',
        picture: null,
        symbol: 'TTT',
        totalSupply: 10000
      },
      show: true,
      genres: musicGenres,
      unsaved: false,
      index: ''
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
  },
  watch: {
    form: function (val) {
      console.log('Form:', val)
    }
  },
  computed: {
    selectSize: function () {
      return parseInt('8')
    }
  },
  methods: {
    test () {
      console.log('test: ', this.index)
    },
    UnSave () {
      for (var key in this.form) {
        console.log('form[' + key + '] = ' + this.form[key])
        this.$store.state.form[key] = this.form[key]
      }
      this.$store.state.form = this.form
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
