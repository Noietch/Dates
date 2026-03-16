import SwiftUI

@main
struct CountdownMenuBarApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var popover: NSPopover?

    func applicationDidFinishLaunching(_ notification: Notification) {
        // 创建状态栏图标
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem?.button {
            updateStatusBarIcon()
            button.action = #selector(togglePopover)
            button.target = self
        }

        // 创建弹出窗口
        popover = NSPopover()
        popover?.contentSize = NSSize(width: 280, height: 320)
        popover?.behavior = .transient
        popover?.contentViewController = NSHostingController(rootView: CountdownView(appDelegate: self))

        // 每小时更新一次图标
        Timer.scheduledTimer(withTimeInterval: 3600, repeats: true) { _ in
            self.updateStatusBarIcon()
        }
    }

    @objc func togglePopover() {
        if let button = statusItem?.button {
            if popover?.isShown == true {
                popover?.performClose(nil)
            } else {
                popover?.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            }
        }
    }

    func updateStatusBarIcon() {
        if let button = statusItem?.button {
            let days = getDaysRemaining()
            let (total, remaining) = getTotalAndRemainingDays()

            // 计算已完成的进度 (已过去的天数 / 总天数)
            let elapsed = total - remaining
            let progress = total > 0 ? Double(elapsed) / Double(total) : 0

            // 创建空心圆圈图标 - 使用 template 模式自动适配主题
            let size = NSSize(width: 22, height: 22)
            let image = NSImage(size: size, flipped: false) { rect in
                let circleRect = rect.insetBy(dx: 2, dy: 2)
                let center = NSPoint(x: circleRect.midX, y: circleRect.midY)
                let radius = circleRect.width / 2

                // 绘制进度圆弧（已过去的部分）
                NSColor.black.setStroke()
                let progressPath = NSBezierPath()
                let startAngle: CGFloat = 90 // 从顶部开始
                let endAngle = startAngle - CGFloat(progress * 360) // 顺时针
                progressPath.appendArc(
                    withCenter: center,
                    radius: radius,
                    startAngle: startAngle,
                    endAngle: endAngle,
                    clockwise: true
                )
                progressPath.lineWidth = 2.5
                progressPath.stroke()

                // 绘制天数文字
                let text = "\(days)"
                let fontSize: CGFloat = days > 99 ? 8 : (days > 9 ? 9 : 10)
                let attributes: [NSAttributedString.Key: Any] = [
                    .font: NSFont.systemFont(ofSize: fontSize, weight: .bold),
                    .foregroundColor: NSColor.black
                ]
                let textSize = text.size(withAttributes: attributes)
                let textRect = NSRect(
                    x: (rect.width - textSize.width) / 2,
                    y: (rect.height - textSize.height) / 2 - 0.5,
                    width: textSize.width,
                    height: textSize.height
                )
                text.draw(in: textRect, withAttributes: attributes)

                return true
            }

            // 设置为 template 图标，系统会自动根据主题调整颜色
            image.isTemplate = true
            button.image = image
        }
    }

    func getTotalAndRemainingDays() -> (total: Int, remaining: Int) {
        let defaults = UserDefaults.standard
        guard let targetDate = defaults.object(forKey: "targetDate") as? Date else {
            return (100, 100)
        }

        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())
        let startOfTarget = calendar.startOfDay(for: targetDate)

        // 获取设置日期
        let createdDate = defaults.object(forKey: "createdDate") as? Date ?? startOfToday
        let startOfCreated = calendar.startOfDay(for: createdDate)

        let totalComponents = calendar.dateComponents([.day], from: startOfCreated, to: startOfTarget)
        let remainingComponents = calendar.dateComponents([.day], from: startOfToday, to: startOfTarget)

        return (totalComponents.day ?? 100, remainingComponents.day ?? 0)
    }

    func getColorForProgress(remaining: Int, total: Int) -> NSColor {
        guard total > 0 else { return NSColor.systemGreen }

        let progress = max(0, min(1, Double(remaining) / Double(total)))

        // 从绿色到红色渐变
        let red = CGFloat(1.0 - progress)
        let green = CGFloat(progress)

        return NSColor(red: red, green: green, blue: 0, alpha: 1.0)
    }

    func getDaysRemaining() -> Int {
        let defaults = UserDefaults.standard
        guard let targetDate = defaults.object(forKey: "targetDate") as? Date else {
            // 默认100天后
            return 100
        }

        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())
        let startOfTarget = calendar.startOfDay(for: targetDate)
        let components = calendar.dateComponents([.day], from: startOfToday, to: startOfTarget)
        return components.day ?? 0
    }
}

struct CountdownView: View {
    weak var appDelegate: AppDelegate?
    @State private var targetDate: Date
    @State private var targetName: String

    init(appDelegate: AppDelegate?) {
        self.appDelegate = appDelegate

        let defaults = UserDefaults.standard
        if let savedDate = defaults.object(forKey: "targetDate") as? Date {
            _targetDate = State(initialValue: savedDate)
        } else {
            _targetDate = State(initialValue: Calendar.current.date(byAdding: .day, value: 100, to: Date()) ?? Date())
        }

        if let savedName = defaults.string(forKey: "targetName") {
            _targetName = State(initialValue: savedName)
        } else {
            _targetName = State(initialValue: "目标日期")
        }
    }

    var daysRemaining: Int {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())
        let startOfTarget = calendar.startOfDay(for: targetDate)
        let components = calendar.dateComponents([.day], from: startOfToday, to: startOfTarget)
        return components.day ?? 0
    }

    var totalDays: Int {
        let defaults = UserDefaults.standard
        let createdDate = defaults.object(forKey: "createdDate") as? Date ?? Date()
        let calendar = Calendar.current
        let startOfCreated = calendar.startOfDay(for: createdDate)
        let startOfTarget = calendar.startOfDay(for: targetDate)
        let components = calendar.dateComponents([.day], from: startOfCreated, to: startOfTarget)
        return components.day ?? 100
    }

    var progress: Double {
        guard totalDays > 0 else { return 1.0 }
        return max(0, min(1, Double(daysRemaining) / Double(totalDays)))
    }

    var circleColor: Color {
        // 使用系统主色调，自动适配浅色/深色模式
        return Color.primary
    }

    var body: some View {
        VStack(spacing: 20) {
            // 大圆圈显示 - 空心圆环
            ZStack {
                // 背景圆环
                Circle()
                    .stroke(circleColor.opacity(0.2), lineWidth: 12)
                    .frame(width: 140, height: 140)

                // 进度圆环
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        circleColor,
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .frame(width: 140, height: 140)
                    .rotationEffect(.degrees(-90))
                    .shadow(color: circleColor.opacity(0.5), radius: 8, x: 0, y: 4)

                VStack(spacing: 4) {
                    Text("\(daysRemaining)")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(circleColor)

                    Text("天")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(circleColor.opacity(0.8))
                }
            }
            .padding(.top, 20)

            // 设置区域
            VStack(spacing: 12) {
                TextField("倒计时名称", text: $targetName)
                    .textFieldStyle(.roundedBorder)
                    .onChange(of: targetName) { newValue in
                        UserDefaults.standard.set(newValue, forKey: "targetName")
                    }

                DatePicker("目标日期", selection: $targetDate, displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .onChange(of: targetDate) { newValue in
                        let defaults = UserDefaults.standard

                        // 如果是第一次设置或更改日期，记录创建日期
                        if defaults.object(forKey: "createdDate") == nil {
                            defaults.set(Date(), forKey: "createdDate")
                        }

                        defaults.set(newValue, forKey: "targetDate")
                        appDelegate?.updateStatusBarIcon()
                    }

                Text(targetName)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 20)

            Divider()

            // 退出按钮
            Button("退出应用") {
                NSApplication.shared.terminate(nil)
            }
            .buttonStyle(.plain)
            .foregroundColor(.red)
            .padding(.bottom, 10)
        }
        .frame(width: 280, height: 320)
    }
}

