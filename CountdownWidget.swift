import SwiftUI

@main
struct CountdownWidgetApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(.hiddenTitleBar)
        .defaultSize(width: 200, height: 200)
    }
}

struct ContentView: View {
    @State private var targetDate = Calendar.current.date(byAdding: .day, value: 100, to: Date()) ?? Date()
    @State private var showDatePicker = false
    @State private var windowLevel: NSWindow.Level = .floating

    var daysRemaining: Int {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())
        let startOfTarget = calendar.startOfDay(for: targetDate)
        let components = calendar.dateComponents([.day], from: startOfToday, to: startOfTarget)
        return components.day ?? 0
    }

    var body: some View {
        ZStack {
            Color.clear

            VStack(spacing: 0) {
                ZStack {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 160, height: 160)
                        .shadow(color: .green.opacity(0.5), radius: 20, x: 0, y: 10)

                    VStack(spacing: 4) {
                        Text("\(daysRemaining)")
                            .font(.system(size: 56, weight: .bold, design: .rounded))
                            .foregroundColor(.white)

                        Text("天")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.white.opacity(0.9))
                    }
                }
                .onTapGesture {
                    showDatePicker.toggle()
                }

                if showDatePicker {
                    VStack(spacing: 8) {
                        DatePicker("目标日期", selection: $targetDate, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .labelsHidden()
                            .padding(.top, 8)

                        Button("完成") {
                            showDatePicker = false
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                    .background(Color(NSColor.windowBackgroundColor))
                    .cornerRadius(12)
                    .padding(.top, 8)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            setupWindow()
        }
    }

    func setupWindow() {
        DispatchQueue.main.async {
            if let window = NSApplication.shared.windows.first {
                window.level = windowLevel
                window.isMovableByWindowBackground = true
                window.backgroundColor = .clear
                window.isOpaque = false
                window.titlebarAppearsTransparent = true
                window.titleVisibility = .hidden
                window.standardWindowButton(.closeButton)?.isHidden = false
                window.standardWindowButton(.miniaturizeButton)?.isHidden = true
                window.standardWindowButton(.zoomButton)?.isHidden = true
            }
        }
    }
}

#Preview {
    ContentView()
}
