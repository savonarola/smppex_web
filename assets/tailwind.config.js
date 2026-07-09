module.exports = {
  content: [
    "../lib/**/*.ex",
    "../lib/**/*.heex",
    "./js/**/*.js"
  ],
  theme: {
    extend: {}
  },
  plugins: [
    require("@tailwindcss/forms"),
    require("@tailwindcss/typography"),
    require("daisyui")
  ],
  daisyui: {
    themes: ["light"]
  }
}
