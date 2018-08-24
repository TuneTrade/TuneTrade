<template>
  <div>
    <b-form @submit="onSubmit" @reset="onReset" v-if="show" class="newContractForm">
      <div class="newContractFormContainer">
        <b-form-group id="BonusesYesNoGroup"
                      label="Add bonuses ?"
                      label-for="BonusesYesNoGroup"
                      >
          <b-form-radio-group id="BonusesYesNoGroup"
                      button-variant="outline-info"
                      buttons
                      size="sm"
                      required
                      @change="UnSave()"
                      v-model="form.bonuses"
                      v-on:click.native.stop="SwitchRadio"
                      :options="radioOptions"
                      name="" />
        </b-form-group>
      <b-form-group id="presalePeriodGroup"
                    label="Presale Period [days]:"
                    label-for="presalePeriod">
        <b-form-input id="presalePeriod"
                      type="number"
                      v-model="form.presalePeriod"
                      optional
                      min=0
                      @keydown.native = "UnSave()"
                      :disabled="BonusesDisabled"
                      @change = "UnSave()"
                      size="sm"
                      placeholder="Enter presale duration in days">
        </b-form-input>
      </b-form-group>

      <b-form-group id="presalePeriodBonusGroup"
                    label="Presale Period Bonus [%]:"
                    label-for="presalePeriodBonus">
        <b-form-input id="presalePeriodBonus"
                      type="number"
                      v-model="form.presalePeriodBonus"
                      @keydown.native = "UnSave()"
                      @change = "UnSave()"
                      min=0
                      :disabled="BonusesDisabled"
                      optional
                      size="sm"
                      placeholder="Enter presale bonus">
        </b-form-input>
      </b-form-group>

      <b-form-group id="firstPeriodGroup"
                    label="First Period [days]:"
                    label-for="firstPeriod">
        <b-form-input id="firstPeriod"
                      type="number"
                      v-model="form.firstPeriod"
                      @keydown.native = "UnSave()"
                      @change = "UnSave()"
                      :disabled="BonusesDisabled"
                      optional
                      min=0
                      size="sm"
                      placeholder="Enter first period duration in days">
        </b-form-input>
      </b-form-group>

      <b-form-group id="firstPeriodBonusGroup"
                    label="First Period Bonus [%]:"
                    label-for="firstPeriod">
        <b-form-input id="firstPeriodBonus"
                      type="number"
                      v-model="form.firstPeriodBonus"
                      @keydown.native = "UnSave()"
                      @change = "UnSave()"
                      :disabled="BonusesDisabled"
                      optional
                      min=0
                      size="sm"
                      placeholder="Enter first period bonus">
        </b-form-input>
      </b-form-group>

      <b-form-group id="secondPeriodGroup"
                    label="Second Period [days]:"
                    label-for="secondPeriod">
        <b-form-input id="secondPeriod"
                      type="number"
                      v-model="form.secondPeriod"
                      @keydown.native = "UnSave()"
                      @change = "UnSave()"
                      :disabled="BonusesDisabled"
                      optional
                      size="sm"
                      min=0
                      placeholder="Enter second period duration">
        </b-form-input>
      </b-form-group>

      <b-form-group id="secondPeriodBonusGroup"
                    label="Second Period Bonus [%]:"
                    label-for="secondPeriodBonus">
        <b-form-input id="secondPeriodBonus"
                      type="number"
                      v-model="form.secondPeriodBonus"
                      @keydown.native = "UnSave()"
                      @change = "UnSave()"
                      :disabled="BonusesDisabled"
                      optional
                      min=0
                      size="sm"
                      placeholder="Enter second period bonus">
        </b-form-input>
      </b-form-group>

      <b-form-group id="thirdPeriodGroup"
                    label="Third Period [days]:"
                    label-for="thirdPeriod">
        <b-form-input id="thirdPeriod"
                      type="number"
                      v-model="form.thirdPeriod"
                      @keydown.native = "UnSave()"
                      @change = "UnSave()"
                      :disabled="BonusesDisabled"
                      optional
                      min=0
                      size="sm"
                      placeholder="Enter third period duration in days">
        </b-form-input>
      </b-form-group>
      <b-form-group id="thirdPeriodBonusGroup"
                    label="Third Period Bonus[%]:"
                    label-for="thirdPeriodBonus">
        <b-form-input id="thirdPeriodBonus"
                      type="number"
                      v-model="form.thirdPeriodBonus"
                      @keydown.native = "UnSave()"
                      @change = "UnSave()"
                      :disabled="BonusesDisabled"
                      min=0
                      optional
                      size="sm"
                      placeholder="Enter third period bonus value">
        </b-form-input>
      </b-form-group>

    </div>
    </b-form>
  </div>
</template>

<script>
var radioOptions = ['No', 'Yes']

export default {
  data () {
    return {
      form: {
        bonuses: 'No',
        presalePeriod: 0,
        presalePeriodBonus: 0,
        firstPeriod: 0,
        firstPeriodBonus: 0,
        secondPeriod: 0,
        secondPeriodBonus: 0,
        thirdPeriod: 0,
        thirdPeriodBonus: 0
      },
      radioOptions: radioOptions,
      show: true
    }
  },
  created: function () {
    /* global musicGenres */
    this.UnSave()
  },
  computed: {
    BonusesDisabled: function () {
      if (this.form.bonuses === 'Yes') return false
      else return true
    }
  },
  methods: {
    SwitchRadio: function (evt) {
      evt.preventDefault()
      console.log('Switch Radio Magier')
      if (this.form.bonuses === 'No') {
        this.radioOptions = ['No', 'Yes']
        this.form.bonuses = 'Yes'
      } else {
        this.form.bonuses = 'No'
        this.radioOptions = ['No', 'Yes']
      }
      this.UnSave()
    },
    UnSave () {
      for (var key in this.form) {
        console.log('form[' + key + '] = ' + this.form[key])
        this.$store.state.formB[key] = this.form[key]
      }
      this.$store.state.formB = this.form
      this.unsaved = true
    },
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
