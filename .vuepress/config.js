module.exports = {
  title: "갈무리곳",
  description: "just blog",
  themeConfig: {
    nav: [
      { text: "Posts", link: "/posts/" },
      { text: "About", link: "/" },
    ],
  },
  postcss: {
    plugins: [
      require("tailwindcss")("./tailwind.config.js"),
      require("autoprefixer")
    ],
  },
  markdown: {
    extendMarkdown: md => {
      md.use(require('markdown-it-sup'));
      md.use(require('markdown-it-sub'));
      md.use(require('markdown-it-footnote'));
      md.use(require('markdown-it-figure-caption'));
    }
  }
}
