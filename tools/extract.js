// 把 index.html 里我们自己那段内联 <script> 抽成 build/app.js，
// 这样 eslint 能静态检查它（vendor 那段不检查）。
const fs = require("fs");
const path = require("path");
const ROOT = path.join(__dirname, "..");
const html = fs.readFileSync(path.join(ROOT, "index.html"), "utf8");

// 取「最后一个」script 块 = 我们自己的代码
const blocks = [...html.matchAll(/<script(?![^>]*\bsrc=)[^>]*>([\s\S]*?)<\/script>/g)];
if (!blocks.length) { console.error("没找到内联 script"); process.exit(1); }
const code = blocks[blocks.length - 1][1];

fs.mkdirSync(path.join(ROOT, "build"), { recursive: true });
fs.writeFileSync(path.join(ROOT, "build", "app.js"), code, "utf8");
console.log("抽出 build/app.js：" + code.split("\n").length + " 行");
