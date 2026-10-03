# 变画卡工坊（Lenticular Card Studio）

单文件网页，模拟现实中的光栅变画卡。图片全部在浏览器本地处理，不上传。

线上地址：https://tianjiawei113-hue.github.io/lenticular-card/

## 文件

- `index.html` — 主程序，同时也是发布页。**改这一个文件就够了**
- `demo.html` — 内嵌演示版（图已内置，打开即看）
- `upload.html` — 旧地址，自动跳回首页
- `aberritual-1.1.0.apk` — 第三方开源安卓动态壁纸的镜像（见文末）
- `publish.ps1` — 提交并推送到 GitHub Pages

## 功能

- 混合方式三种：**透镜摆动**（按真实光栅模拟，每根透镜内的分割线随角度滑动）/ **细抖动** / **溶解流动**（噪声阈值溶解 + 环流 + 边界发光）
- 可调：画面比例、输出精度、过渡快慢、中心死区、透镜宽度、溶解尺度/柔度/流速/发光
- 导出**交错底图 PNG**（按输出精度出，可拿去印真卡）、录倾斜动画、存 **GIF 动图**（页面自带 GIF89a 编码器，无外部依赖）

## 发布

```powershell
pwsh -File publish.ps1 "这次改了什么"
```

推送后 GitHub Pages 会自动重建，一分钟左右生效。

## 回退历史版本

```powershell
git log --oneline                       # 看历史
git show <commit>:index.html > old.html # 取出某个版本
git checkout <commit> -- index.html     # 直接把某个版本捡回来
```

## 关于那个 APK

`aberritual-1.1.0.apk` 不是本项目的产物，是第三方开源项目
[Aberritual](https://github.com/RVYA/aberritual)（GPL-3.0）官方发布包的镜像，
放这里只是为了让手机能直接下载。不需要了直接删掉即可。
