import globals from "globals";

export default [
  {
    files: ["build/app.js"],
    languageOptions: {
      ecmaVersion: 2022,
      sourceType: "script",
      globals: {
        ...globals.browser,
        RaindropFX: "readonly",      // vendor/raindrop-fx.bundle.js 提供的全局
      },
    },
    rules: {
      "no-undef": "error",           // 用了但没声明 —— 就是 flowFill 那类 bug
      "no-redeclare": "error",
      "no-unused-vars": "warn",
      "no-dupe-keys": "error",
      "no-dupe-args": "error",
      "no-cond-assign": "error",
      "no-constant-condition": "warn",
      "no-fallthrough": "error",
      "no-self-assign": "error",
      "no-unreachable": "error",
      "valid-typeof": "error",
      "use-isnan": "error",
    },
  },
];
