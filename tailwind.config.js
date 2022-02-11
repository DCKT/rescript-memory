const plugin = require("tailwindcss/plugin");

module.exports = {
  content: ["./index.html", "./src/**/*.{vue,js,ts,jsx,tsx}"],
  theme: {
    extend: {
      fontFamily: {
        shizuru: ["Shizuru", "cursive"],
      },
    },
  },
  plugins: [
    plugin(function ({ addUtilities }) {
      addUtilities({
        ".backface-hidden": {
          "backface-visibility": "hidden",
        },
        ".transform-preserve-3d": {
          "transform-style": "preserve-3d",
        },
      });
    }),
  ],
};
