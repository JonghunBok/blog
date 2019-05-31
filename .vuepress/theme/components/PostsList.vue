<template>
  <div class="a4 mx-auto shadow-md bg-white">
    <h1 text-center>글</h1>
    <ul>
      <li v-for="post in posts" >
        <router-link :to="post.path">
          {{ post.title }}
        </router-link>
        <span>
          {{ localeDate(post) }}
        </span>
      </li>
    </ul>
  </div>
</template>

<script>
// TODO: mins
// TODO: style


export default {
  name: "PostList",
  computed: {
    posts() {
      return this.$site.pages
        .filter(x => x.path.startsWith("/posts/") && (x.frontmatter.type !== "PostsList"))
        .sort(
          (a, b) => new Date(b.frontmatter.date) - new Date(a.frontmatter.date)
        )
    }
  },
  methods: {
    localeDate(post) {
      let option = {
        year: "numeric",
        month: "2-digit",
        day: "2-digit"
      }
      return new Date(post.frontmatter.date).toLocaleString("default", option);
    }
  }
  
}
</script>

<style scoped lang="stylus">
a
  font-size 1.3em
  color black
  
</style>
