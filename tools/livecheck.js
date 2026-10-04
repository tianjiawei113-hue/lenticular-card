const fs = require("fs");

(async () => {
  const r = await fetch("https://tianjiawei113-hue.github.io/lenticular-card/");
  const t = await r.text();
  fs.writeFileSync("build/live_index.html", t, "utf8");
  console.log("live bytes", Buffer.byteLength(t));
  console.log("has drawRain:", t.includes("function drawRain"));
  console.log("has rainDiag:", t.includes("function rainDiag"));
  console.log("has rfxTick:", t.includes("rfxTick"));
  console.log("script srcs:", (t.match(/<script[^>]*src="[^"]+"/g) || []).join(" | "));
  console.log("version markers:", (t.match(/v\d+/g) || []).join(","));
})();
