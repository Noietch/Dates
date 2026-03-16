#!/bin/bash

# 编译Swift文件
swiftc -parse-as-library CountdownMenuBar.swift \
    -o CountdownWidget \
    -framework SwiftUI \
    -framework AppKit \
    -target arm64-apple-macos13.0

# 创建应用包结构
rm -rf CountdownWidget.app
mkdir -p CountdownWidget.app/Contents/MacOS
mkdir -p CountdownWidget.app/Contents/Resources

# 移动可执行文件
mv CountdownWidget CountdownWidget.app/Contents/MacOS/

# 复制图标
if [ -f "AppIcon.icns" ]; then
    cp AppIcon.icns CountdownWidget.app/Contents/Resources/
fi

# 创建Info.plist
cat > CountdownWidget.app/Contents/Info.plist << 'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>CountdownWidget</string>
    <key>CFBundleIdentifier</key>
    <string>com.countdown.widget</string>
    <key>CFBundleName</key>
    <string>Countdown</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSMinimumSystemVersion</key>
    <string>13.0</string>
    <key>LSUIElement</key>
    <true/>
    <key>NSHighResolutionCapable</key>
    <true/>
    <key>CFBundleIconFile</key>
    <string>AppIcon</string>
</dict>
</plist>
PLIST

echo "✅ 构建完成！应用位于 CountdownWidget.app"
echo "运行: open CountdownWidget.app"
