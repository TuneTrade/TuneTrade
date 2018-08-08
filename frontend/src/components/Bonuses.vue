<template>
  <div>
    <b-form @submit="onSubmit" @reset="onReset" v-if="show" class="newContractForm">
      <div class="newContractFormContainer">

      <b-form-group id="presalePeriodGroup"
                    label="Presale Period [days]:"
                    label-for="presalePeriod">
        <b-form-input id="presalePeriod"
                      type="number"
                      v-model="form.presalePeriod"
                      optional
                      size="sm"
                      placeholder="0">
        </b-form-input>
      </b-form-group>

      <b-form-group id="presalePeriodBonusGroup"
                    label="Presale Period Bonus [%]:"
                    label-for="presalePeriodBonus">
        <b-form-input id="presalePeriodBonus"
                      type="number"
                      v-model="form.presalePeriodBonus"
                      optional
                      size="sm"
                      placeholder="0">
        </b-form-input>
      </b-form-group>

      <b-form-group id="firstPeriodGroup"
                    label="First Period [days]:"
                    label-for="firstPeriod">
        <b-form-input id="firstPeriod"
                      type="number"
                      v-model="form.firstPeriod"
                      optional
                      size="sm"
                      placeholder="0">
        </b-form-input>
      </b-form-group>

      <b-form-group id="firstPeriodBonusGroup"
                    label="First Period Bonus [%]:"
                    label-for="firstPeriod">
        <b-form-input id="firstPeriodBonus"
                      type="number"
                      v-model="form.firstPeriodBonus"
                      optional
                      size="sm"
                      placeholder="0">
        </b-form-input>
      </b-form-group>

      <b-form-group id="secondPeriodGroup"
                    label="Second Period [days]:"
                    label-for="secondPeriod">
        <b-form-input id="secondPeriod"
                      type="number"
                      v-model="form.secondPeriod"
                      optional
                      size="sm"
                      placeholder="0">
        </b-form-input>
      </b-form-group>

      <b-form-group id="secondPeriodBonusGroup"
                    label="Second Period Bonus [%]:"
                    label-for="secondPeriodBonus">
        <b-form-input id="secondPeriodBonus"
                      type="number"
                      v-model="form.secondPeriodBonus"
                      optional
                      size="sm"
                      placeholder="0">
        </b-form-input>
      </b-form-group>

      <b-form-group id="thirdPeriodGroup"
                    label="Third Period [days]:"
                    label-for="thirdPeriod">
        <b-form-input id="thirdPeriod"
                      type="number"
                      v-model="form.thirdPeriod"
                      optional
                      size="sm"
                      placeholder="0">
        </b-form-input>
      </b-form-group>
      <b-form-group id="thirdPeriodBonusGroup"
                    label="Third Period Bonus[%]:"
                    label-for="thirdPeriodBonus">
        <b-form-input id="thirdPeriodBonus"
                      type="number"
                      v-model="form.thirdPeriodBonus"
                      optional
                      size="sm"
                      placeholder="0">
        </b-form-input>
      </b-form-group>

    </div>
      <b-button type="submit" variant="primary">Save</b-button>
      <b-button type="reset" variant="danger">Reset</b-button>
    </b-form>
  </div>
</template>

<script>

export default {
  data () {
    return {
      form: {
        presalePeriod: '',
        presalePeriodBonus: '',
        firstPeriod: '',
        firstPeriodBonus: '',
        secondPeriod: '',
        secondPeriodBonus: '',
        thirdPeriod: '',
        thirdPeriodBonus: ''
      },
      show: true
    }
  },
  created: function () {
    /* global musicGenres */
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
