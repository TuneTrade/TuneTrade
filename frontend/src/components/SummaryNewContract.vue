<template>
  <div>
    <h4>Contract Summary</h4>
    <b-button type="submit" variant="primary">Create Contract</b-button>
    <b-button type="reset" variant="danger">Reset All</b-button>
          <b-card no-body class="mb-1">
            <b-card-header header-tag="header" class="p-1" role="tab" style="padding:10px;">
              <b-btn block href="#" v-b-toggle.accordion1 variant="info">General</b-btn>
            </b-card-header>
            <b-collapse id="accordion1" visible accordions="my-accordion" role="tabpanel">
              <b-card-body class="summaryContainer contractTab">

                <div class="summaryElement">
                  <div class="summaryTitle">Type:</div>
                  <div class="summaryContent">{{lorem}}</div>
                </div>


                <div class="summaryElement">
                  <div class="summaryTitle">Name:</div>
                  <div class="summaryContent">{{lorem}}</div>
                </div>


                <div class="summaryElement">
                  <div class="summaryTitle">Author:</div>
                  <div class="summaryContent">{{lorem}}</div>
                </div>

                <div class="summaryElement">
                  <div class="summaryTitle">Website:</div>
                  <div class="summaryContent">{{lorem}}</div>
                </div>


                <div class="summaryElement">
                  <div class="summaryTitle">Token symbol:</div>
                  <div class="summaryContent">{{lorem}}</div>
                </div>

                <div class="summaryElement">
                  <div class="summaryTitle">Image:</div>
                  <div class="summaryContent">{{lorem}}</div>
                </div>

                <div class="summaryElement">
                  <div class="summaryTitle">Genre:</div>
                  <div class="summaryContent">{{lorem}}</div>
                </div>
              </b-card-body>
            </b-collapse>
          </b-card>
          <b-card no-body class="mb-1">
            <b-card-header header-tag="header" class="p-1" role="tab">
              <b-btn block href="#" v-b-toggle.accordion2 variant="info">ICO Contract</b-btn>
            </b-card-header>
      <b-collapse id="accordion2" visible accordions="my-accordion" role="tabpanel">
        <b-card-body  class="summaryContainer contractTab">


          <div class="summaryElement">
            <div class="summaryTitle">Contribution Wallet Address:</div>
            <div class="summaryContent">{{lorem}}</div>
          </div>

          <div class="summaryElement">
            <div class="summaryTitle">Tokens for a team:</div>
            <div class="summaryContent">{{lorem}}</div>
          </div>

          <div class="summaryElement">
            <div class="summaryTitle">Minimum Contribution PreSale:</div>
            <div class="summaryContent">{{lorem}}</div>
          </div>

          <div class="summaryElement">
            <div class="summaryTitle">Minimum Contribution MainSale:</div>
            <div class="summaryContent">{{lorem}}</div>
          </div>

          <div class="summaryElement">
            <div class="summaryTitle">Maximum Contribution Ether:</div>
            <div class="summaryContent">{{lorem}}</div>
          </div>

          <div class="summaryElement">
            <div class="summaryTitle">Maximum Cap:</div>
            <div class="summaryContent">{{lorem}}</div>
          </div>

          <div class="summaryElement">
            <div class="summaryTitle">Minimum Cap:</div>
            <div class="summaryContent">{{lorem}}</div>
          </div>

          <div class="summaryElement">
            <div class="summaryTitle">Token Price ETH:</div>
            <div class="summaryContent">{{lorem}}</div>
          </div>
          <div class="summaryElement">
            <div class="summaryTitle">Campaign Duration Days:</div>
            <div class="summaryContent">{{lorem}}</div>
          </div>


        </b-card-body>
      </b-collapse>
      </b-card>
          <b-card no-body class="mb-1">
            <b-card-header header-tag="header" class="p-1" role="tab">
              <b-btn block href="#" v-b-toggle.accordion3 variant="info">Bonuses</b-btn>
            </b-card-header>
      <b-collapse id="accordion3" visible accordions="my-accordion" role="tabpanel">
        <b-card-body   class="summaryContainer contractTab">
          <div class="summaryElement">
            <div class="summaryTitle">Presale Period [days]:</div>
            <div class="summaryContent">{{form.presalePeriod}}</div>
          </div>
          <div class="summaryElement">
            <div class="summaryTitle">Presale Period Bonus [%]:</div>
            <div class="summaryContent">{{form.presalePeriodBonus}}</div>
          </div>
          <div class="summaryElement">
            <div class="summaryTitle">First Period [days]:</div>
            <div class="summaryContent">{{form.firstPeriod}}</div>
          </div>
          <div class="summaryElement">
            <div class="summaryTitle">First Period Bonus [%]:</div>
            <div class="summaryContent">{{form.firstPeriodBonus}}</div>
          </div>
          <div class="summaryElement">
            <div class="summaryTitle">Second Period [days]:</div>
            <div class="summaryContent">{{form.secondPeriod}}</div>
          </div>
          <div class="summaryElement">
            <div class="summaryTitle">Second Period Bonus [%]:</div>
            <div class="summaryContent">{{form.secondPeriodBonus}}</div>
          </div>
          <div class="summaryElement">
            <div class="summaryTitle">Third Period [days]:</div>
            <div class="summaryContent">{{form.thirdPeriod}}</div>
          </div>
          <div class="summaryElement">
            <div class="summaryTitle">Third Period Bonus[%]:</div>
            <div class="summaryContent">{{form.thirdPeriodBonus}}</div>
          </div>

        </b-card-body>
      </b-collapse>
      </b-card>

<!-- </b-card-group> -->

      <p>
        Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
      </p>

  </div>
</template>

<script>
// import musicGenres from '../musicGenres'
import ICOContract from './ICOContract'
import Bonuses from './Bonuses'
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
      show: true,
      genres: musicGenres,
      lorem: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit.'
    }
  },
  components: {
    ICOContract,
    Bonuses
  },
  created: function () {
    /* global musicGenres */
    this.genres = musicGenres
    console.log('Music Genres:', this.genres)
  },
  destroyed: function () {
    console.log('Destroyed')
  },
  computed: {
    form: function () {
      return this.$store.state.form
    }
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
