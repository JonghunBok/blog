<template>
  <div class="a4 mx-auto shadow-md bg-white">
    <ul>
      <li v-for="post in posts" >
        <router-link :to="post.path">
          {{ post.title }}
        </router-link>
      </li>
    </ul>
  </div>
</template>

<script>
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
}
</script>
