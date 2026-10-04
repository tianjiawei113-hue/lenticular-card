// 用 esbuild 把 raindrop-fx 的自有源码（vendor-src/）构建成浏览器可用的 bundle。
// 配置照搬它仓库的 build/build-browser.js，只是输出到 vendor/ 且不压缩（方便排查）。
const path = require("path");
const ROOT = path.join(__dirname, "..");
const out = process.argv.includes("--min") ? path.join(ROOT, "vendor", "raindrop-fx.custom.min.js")
                                           : path.join(ROOT, "vendor", "raindrop-fx.custom.js");

require("esbuild").build({
  entryPoints: [path.join(ROOT, "vendor-src/raindrop-fx/src/index.ts")],
  absWorkingDir: ROOT,          // 关键：别让它往上层目录找 tsconfig/node_modules（会撞沙箱）
  // experimentalDecorators 必须开：zogra-renderer 的 @shaderProp 返回的是 TS 传统装饰器
  // （(target, key) 签名），若按 TC39 标准装饰器编译，类字段会收到 void 0 → Reflect.metadata 抛裸 TypeError，
  // 整个 bundle 加载失败 → 页面悄悄退回内置 2D 兜底版（珠子大、没物理）。
  tsconfigRaw: { compilerOptions: { target: "es2020", useDefineForClassFields: false, experimentalDecorators: true } },
  bundle: true,
  format: "iife",
  globalName: "RaindropFX",
  target: ["es2020"],
  loader: { ".png": "binary", ".jpg": "binary", ".glsl": "text" },
  minify: process.argv.includes("--min"),
  sourcemap: false,
  outfile: out,
  logLevel: "info",
}).then(() => {
  const fs = require("fs");
  console.log("构建完成：" + path.relative(ROOT, out) + "  " + Math.round(fs.statSync(out).size / 1024) + " KB");
}).catch((e) => { console.error("构建失败：" + e.message); process.exit(1); });
