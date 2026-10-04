// 给构建产物打点：记录"当前正在初始化的模块名"，用来定位裸 TypeError 的来源。
const fs = require("fs");
const path = require("path");
const ROOT = path.join(__dirname, "..");
const src = fs.readFileSync(path.join(ROOT, "vendor/raindrop-fx.custom.js"), "utf8");

const needles = [
  "      return fn && (res = (0, fn[__getOwnPropNames(fn)[0]])(fn = 0)), res;",
  "      return mod || (0, cb[__getOwnPropNames(cb)[0]])((mod = { exports: {} }).exports, mod), mod.exports;",
];
let out = src;
let hits = 0;
for (const n of needles) {
  if (out.includes(n)) {
    hits++;
    const mod = n.includes("cb[") ? "cb" : "fn";
    out = out.replace(n, `      globalThis.__mod = __getOwnPropNames(${mod})[0];\n${n}`);
  }
}
fs.writeFileSync(path.join(ROOT, "build/raindrop.instrumented.js"), out, "utf8");
console.log("patched sites:", hits, "bytes:", out.length);
