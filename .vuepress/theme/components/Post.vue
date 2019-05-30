<template>
  <div>
    <div class="a4 mx-auto shadow-md bg-white">
      <Content />
    </div>

    <div class="a5-landscape mx-auto my-4 shadow-md bg-white">
      <div id="disqus_thread"></div>
    </div>

  </div>
</template>

<script>
import Vue from 'vue';
import Prism from 'prismjs';

Vue.use(Prism);

export default {
  computed: {
    dataHref() {
      return 'https://developers.facebook.com/docs/plugins/comments#'+this.$page.title;
    }
    
  },
  mounted() {
    var disqus_config = function () {
      this.page.url = window.location.origin;
      this.page.identifier = window.location.pathname;
    };
    
    (function() { 
      var d = document, s = d.createElement('script');
      s.src = 'https://https-jonghunbok-github-io.disqus.com/embed.js';
      s.setAttribute('data-timestamp', +new Date());
      (d.head || d.body).appendChild(s);
    })();
  }
}
</script>

<style lang="stylus">
img 
  width 100%
  display block
  margin auto
  transition 1.5s

figcaption
  margin auto
 
@media (min-width: 768px)
  img 
    width 40%
  img:hover
    width 100%
      
</style>
<style src="prismjs/themes/prism-okaidia.css"></style>
