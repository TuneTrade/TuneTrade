<template>
  <div>
    <b-tabs  card class="contractTabs">
      <b-tab title="General" class="contractTab">
    <b-form @submit="onSubmit" @reset="onReset" v-if="show" class="newContractForm">
      <div class="newContractFormContainer">
      <b-form-group id="typeGroup"
                    label="Type:"
                    label-for="typeGroup"
                    description="Decide if you are adding a song or a band contract.">
        <b-form-radio-group id="typeGroup"
                    buttons
                    button-variant="outline-primary"
                    size="sm"
                    required
                    v-model="form.type"
                    :options="['Song', 'Band']"
                    name="radioBtnOutline" />
      </b-form-group>
      <b-form-group id="nameInputGroup"
                    label="Name:"
                    label-for="nameInput">
        <b-form-input id="nameInput"
                      type="text"
                      v-model="form.name"
                      required
                      size="sm"
                      placeholder="Enter name">
        </b-form-input>
      </b-form-group>
      <b-form-group id="authorNameGroup"
                    label="Author:"
                    label-for="authorName">
        <b-form-input size="sm" id="authorName"
                      type="text"
                      v-model="form.author"
                      required
                      placeholder="Enter author's name">
        </b-form-input>
      </b-form-group>
      <b-form-group id="websiteLink"
                    label="Website:"
                    label-for="website">
        <b-form-input id="website"
                      type="text"
                      v-model="form.website"
                      required
                      size="sm"
                      placeholder="Enter website link">
        </b-form-input>
      </b-form-group>

      <b-form-group id="symbolGroup"
                    label="Token Symbol:"
                    label-for="symbol">
        <b-form-input id="symbol"
                      type="text"
                      v-model="form.symbol"
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
                      style="font-size:12px; font-weight:600;height:30px"
                      placeholder="Please provide album image">
        </b-form-file>
      </b-form-group>

      <b-form-group id="exampleInputGroup3"
                    label="Genre:"
                    label-for="exampleInput3">
        <b-form-select id="exampleInput3"
                      :options="genres"
                      required
                      v-model="form.genre"
                      size="sm"
                      select-size=8
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
      <b-button type="submit" variant="primary">Save</b-button>
      <b-button type="reset" variant="danger">Reset</b-button>
    </b-form>
  </b-tab>
  <b-tab title="ICO Contract"  class="contractTab">
    <ICOContract/>
  </b-tab>
  <b-tab title="Bonuses"  class="contractTab">
    <Bonuses/>
  </b-tab>
  <b-tab title="Summary & Create"  class="contractTab">
    <SummaryNewContract/>
  </b-tab>
</b-tabs>
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
        email: '',
        name: '',
        food: null,
        checked: [],
        genre: null,
        author: null,
        website: null,
        type: null
      },
      show: true,
      genres: musicGenres
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
  methods: {
    onSubmit (evt) {
      evt.preventDefault()
      alert(JSON.stringify(this.form))
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
      this.form.checked = []
      /* Trick to reset/clear native browser form validation state */
      this.show = false
      this.$nextTick(() => { this.show = true })
    }
  }
}
</script>

<!-- b-form-1.vue -->
