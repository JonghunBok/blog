<template>
  <div class="mx-auto my-0">
    <Nav class="float-right clearfix mr-4
      md:mr-24" />
    <div class="py-16">
      <component :is="type" />
    </div>

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

