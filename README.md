# Dates - macOS 倒计时菜单栏小组件

<p align="center">
  <img src="icon.svg" alt="Dates Icon" width="128" height="128">
</p>

一个简洁优雅的 macOS 菜单栏倒计时小组件，帮助你追踪重要日期。

## ✨ 功能特性

- 📊 **菜单栏显示**：在菜单栏直接显示剩余天数
- 🔄 **进度可视化**：圆环进度条显示已过去时间百分比
- 🌓 **主题适配**：自动适配系统浅色/深色模式
- ⚙️ **自定义设置**：可设置目标日期和倒计时名称
- 💾 **持久化存储**：设置自动保存，重启后保持
- 🎯 **轻量简洁**：原生 Swift 开发，占用资源极少

## 📸 预览

菜单栏图标会显示：
- 剩余天数数字
- 进度圆环（随时间推移逐渐消失）
- 自动适配浅色/深色模式

点击图标后弹出设置面板，可以：
- 查看大号倒计时显示
- 设置目标日期
- 自定义倒计时名称

## 🚀 安装方法

### 方式一：下载预编译版本（推荐）

1. 前往 [Releases](https://github.com/Noietch/Dates/releases) 页面
2. 下载最新版本的 `CountdownWidget.zip`
3. 解压后将 `CountdownWidget.app` 拖到「应用程序」文件夹
4. 打开应用，菜单栏会出现倒计时图标

### 方式二：从源码编译

```bash
# 克隆仓库
git clone git@github.com:Noietch/Dates.git
cd Dates

# 编译（需要 Xcode Command Line Tools）
./build.sh

# 运行
open CountdownWidget.app
```

## 📖 使用说明

1. **首次使用**：打开应用后，菜单栏会显示倒计时图标（默认 100 天）
2. **设置目标日期**：点击菜单栏图标，在弹出窗口中设置目标日期和名称
3. **查看进度**：
   - 菜单栏图标中的数字表示剩余天数
   - 圆环的缺口表示已过去的时间百分比
   - 圆环越短，表示离目标日期越近
4. **退出应用**：在设置面板底部点击「退出应用」

## 🛠️ 技术栈

- **语言**：Swift
- **框架**：SwiftUI, AppKit
- **平台**：macOS 11.0+
- **构建工具**：swiftc

## 📝 开发说明

### 项目结构

```
.
├── CountdownMenuBar.swift    # 主应用和菜单栏逻辑
├── CountdownWidget.swift     # 小组件视图（未使用）
├── build.sh                  # 编译脚本
├── icon.svg                  # 图标源文件
└── AppIcon.icns             # 应用图标
```

### 核心功能

- **进度计算**：从设置日期到目标日期的总天数，以及剩余天数
- **圆环绘制**：使用 `NSBezierPath` 绘制进度圆弧
- **主题适配**：使用 `isTemplate = true` 和 `Color.primary` 自动适配
- **数据持久化**：使用 `UserDefaults` 存储设置

### 编译命令

```bash
swiftc -o CountdownWidget \
  CountdownMenuBar.swift \
  -framework Cocoa \
  -framework SwiftUI
```

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📄 许可证

本项目采用 MIT 许可证 - 详见 [LICENSE](LICENSE) 文件

## 💡 使用场景

- 考试倒计时
- 项目截止日期
- 重要纪念日
- 假期倒计时
- 任何你想追踪的目标日期

---

🤖 Built with [Claude Code](https://claude.ai/claude-code)
