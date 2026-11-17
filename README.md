# ios-trial — Windows 上做 iOS App 并装到自己手机

一个最小可用的 SwiftUI App + GitHub Actions 云端编译流程。
最终产物：一个 `HelloApp.ipa`，用 Sideloadly 用自己的 Apple ID 签名装进 iPhone。

## 整体流程

```
Windows 改代码 → git push 到 GitHub
      ↓
GitHub Actions 用 macOS 机器编译（免费）
      ↓
下载 Actions 产物 HelloApp.ipa
      ↓
Windows 上用 Sideloadly + 自己的 Apple ID 签名安装
      ↓
iPhone 上出现 App
```

免费 Apple ID 的特点：**每个 App 7 天后过期**，到期后重跑一次 Sideloadly 即可，数据不丢。

---

## 一、推代码到 GitHub

1. 注册 GitHub 账号（如果还没有）：https://github.com/signup
2. 在网页上新建一个仓库，名字随意，比如 `ios-trial`，**选 Public**（公开仓库跑 macOS 编译不消耗私有额度配额），不要勾选任何初始化文件。
3. 在这个文件夹里执行（把 `<你的用户名>` 换成实际用户名）：

```bash
cd /c/ios-trial
git init
git add .
git commit -m "init: hello app"
git branch -M main
git remote add origin https://github.com/<你的用户名>/ios-trial.git
git push -u origin main
```

> 没有 git？先装：https://git-scm.com/download/win

4. push 之后打开仓库的 **Actions** 标签页，会看到 `Build IPA` 正在跑，大约 5~10 分钟（首次要装 xcodegen）。
5. 跑完后点进这次运行，最下面 **Artifacts** 里下载 `HelloApp-ipa.zip`，解压得到 `HelloApp.ipa`。

---

## 二、Windows 侧准备（只做一次）

1. **装 Apple 驱动**：Microsoft Store 搜索安装 “Apple Devices”（或从 Apple 官网装 iTunes）。这是为了让 Windows 能通过 USB 识别 iPhone。
2. **装 Sideloadly**：https://sideloadly.io/ （下载 Windows 版，安装）
3. 数据线连上 iPhone，手机上点 **“信任此电脑”**，输入锁屏密码。

---

## 三、iPhone 侧打开开发者模式（只做一次，iOS 16+）

1. 设置 → 隐私与安全性 → 拉到最底 → **开发者模式** → 打开
2. 会要求**重启手机**，重启后再进来确认一次，输入密码。

（这个开关只有在你用开发证书签名装过东西之后才会出现。如果一开始找不到，先做第四步装一次，再回来开。）

---

## 四、签名并安装

1. 打开 Sideloadly，iPhone 插着
2. **IPA 文件**：拖入 `HelloApp.ipa`
3. **Apple ID**：填你的 Apple ID（普通免费账号就行）
4. 点 **Start**，会弹窗让你输入 Apple ID 密码 → 可能还要输入手机收到的双重验证验证码
5. 装完后手机上如果打不开，去 **设置 → 通用 → VPN 与设备管理 → 开发者 App**，点你的 Apple ID → **信任**

---

## 五、之后怎么用

- **到期重装**：7 天后 App 打不开（闪退/提示不可用），重跑一次 Sideloadly，10 秒搞定，App 里的数据保留。
- **改代码**：改完 `git push`，等 Actions 跑完，重新下载 ipa 覆盖安装。
- **装第二个 App**：免费账号限制同时最多 3 个自签 App，7 天内最多注册 10 个。

---

## 想省掉每周重签

装 **SideStore**（https://sidestore.io/）——在手机上自动续签，不用每周连电脑。原理一样，只是把重签流程放到手机后台跑。

---

## 文件说明

| 文件                            | 作用                                              |
| ----------------------------- | ----------------------------------------------- |
| `project.yml`                 | xcodegen 配置，云端据此生成 Xcode 工程。改 bundle id / 版本号在这 |
| `Sources/HelloAppApp.swift`   | App 入口                                          |
| `Sources/ContentView.swift`   | 界面（现在是个计数器）                                     |
| `.github/workflows/build.yml` | 云端编译并打包 ipa 的脚本                                 |
