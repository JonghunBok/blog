<template>
  <div>
    <div class="a4 mx-auto shadow-md bg-white antialiased">
      <h1 class="text-center"> {{ $page.title }} </h1>
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
p
  text-align justify
img 
  width 100%
  display block
  margin auto
  transition 1.5s

figcaption
  margin auto
  font-size smaller
  font-weight 500
  color #002e
  text-align center

.footnotes-sep
  margin-top 10em

.footnotes-list
  padding 0
  font-size 0.8em
  color rgba(17, 17, 51, 0.8)

.footnote-item p
  margin-bottom 0.4em
  margin-top 0
 
@media (min-width: 768px)
  img 
    width 50%
  img:hover
    width 100%
      
</style>
<style src="prismjs/themes/prism-okaidia.css"></style>
