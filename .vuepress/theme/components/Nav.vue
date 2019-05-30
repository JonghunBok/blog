<template>
  <div class="inline-block">
    <ul class="list-none flex flex-row p-0 mt-3
               xl:flex-col xl:mt-4">
      <li 
        v-for="item in $site.themeConfig.nav"
        class="w-16 block bg-white py-2 px-2 mb-2 ml-2
               text-center text-black
               overflow-hidden rounded"
        :class="{ shadow: isThisPage(item), 'shadow-md': !isThisPage(item) }"

      >
        <router-link :class="{ 'cursor-default': isThisPage(item) }" :to="item.link">{{item.text}}</router-link>
      </li>
    </ul>
  </div>

</template>

<script>
export default {
  computed: {
  },
  methods: {
    isThisPage(item) {
      if (this.$page.path === item.link)
        return true;
      return false;
    }
  }
}
</script>

<style lang="stylus">
a
  text-decoration: none
  color: #3C366B
</style>
