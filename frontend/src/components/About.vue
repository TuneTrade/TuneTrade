<template lang="html">
<div class="heroImage" v-bind:style="{ 'background-image': 'url(' + image + ')' }">

  <!-- <img src="../assets/hero/hero1.jpg" style="width:100%;height:100%;z-index=-100;position:absolute"></img> -->
<div class="heroText">
  <!-- <img src="/static/logotext.png"></img> -->
  <img class="logoPicture" src="../assets/logotunetradesmall.png" ></img>

<p class="desc">Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
<p class="desc">Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
<p class="desc">Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
<p class="desc">Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
</div>
</div>
</template>
<script>

var SC = require('soundcloud')
SC.initialize('rZY6FYrMpGVhVDfaKEHdCaY8ALekxd8P')
console.log(SC.oEmbed('http://soundcloud.com/forss/flickermood', {auto_play: true}).then(function (embed) {
  console.log(embed.html)
}))
// SC.initiallize(client_id: 'rZY6FYrMpGVhVDfaKEHdCaY8ALekxd8P', redirect_uri: 'http://127.0.0.1:8080/callback.html')
// var client = SC.new('rZY6FYrMpGVhVDfaKEHdCaY8ALekxd8P')

// var trackUrl = 'https://soundcloud.com/iamcardib/i-like-it'
// var embedInfo = client.get('/oembed', trackUrl)

export default {
  data () {
    return {
      numb: 1
    }
  },
  computed: {
    number: function () {
      return (parseInt(Math.random() * 1000) % 19) + 1
    },

    image: function () {
      return '../static/hero' + this.numb + '.jpg'
    }
  },
  created: function () {
    var that = this
    // console.log(embedInfo['html'])
    that.numb = (parseInt(Math.random() * 1000) % 19) + 1
    // setInterval(function () {
      // that.numb = (parseInt(Math.random() * 1000) % 19) + 1
    // }, 10000)
  }
}
</script>

<style local lang="css">
body {
  /* height: 100%; */

}
.heroImage
{

    /* height: 2000px; */
    height:85%;
    /* background-image: url('../../static/hero1.jpg'); */
    /* width:100%; */
    background-attachment: fixed;
    background-position: left;
    background-repeat: no-repeat;
    /* background-size: 75% 100%; */
    background-size: cover;
    /* position: absolute; */
    /* top:15%; */
    /* left:25%; */
    margin:0px;
    /* padding:21%; */
    border-color:red;
    /* top:100px; */

    z-index:1;
    transition: background-image 1s ease-in-out;
  }

.heroText {
    text-align: center;
    position: relative;
    color:#fafafa;
    /* left:-300px; */
    width:100%;
    height:100%;
    /* margin:2% 0%; */
    /* text-align: justify; */
    line-height: 1.8;
    /* border-style:solid; */
    border-width:1px;
    border-color:grey;
    padding:10% ;
    font-weight:600;
    font-size:64px;
    z-index:2;
    background-color: rgba(0,0,0,0.7);
}
.logoPicture {
      width:400px;
      border-style:solid;
      border-width:1px;
      padding:40px;
      transition: filter 1.2s;
      filter:saturate(8);
      transition-timing-function: gradient;



    }
.logoPicture:hover {
  /* opacity:0.5; */
  filter:saturate(100)  brightness(10);
  /* filter: saturate(100%); */
  transition: filter 1.6s;
  transition-timing-function: ease-in-out;
}

.desc {
  margin:40px 0px;
  font-size:14px;
  text-align: justify;
  font-family:    monospace;

}
</style>
