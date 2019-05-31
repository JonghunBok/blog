<template>
  <div class="mx-auto my-0">
    <Nav class="float-right clearfix mr-4
      md:mr-24" />
    <div class="py-16">
      <component :is="type" />
    </div>

    <link href="https://fonts.googleapis.com/css?family=Nanum+Myeongjo&display=swap" rel="stylesheet">
  </div>
</template>

<script>
import Nav from "@theme/components/Nav";
import PostsList from "@theme/components/PostsList";
import Post from "@theme/components/Post";


export default {
  components: { 
    Nav, 
    PostsList,
    Post,
  },
  name: "Layout",
  computed: {
    type() {
      return this.$page.frontmatter.type || 'post'
    }
  }
}
</script>

<style lang="stylus">
@import '../styles/theme.styl';
body
  background url('/roughPaper.svg')
</style>

