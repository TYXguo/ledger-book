# Ledger Book Mobile

家庭记账应用的 Flutter 移动客户端。

## 技术栈

- Flutter 3
- Dart
- Riverpod
- go_router
- fl_chart

## 环境要求

- Flutter 3.x SDK
- Android Studio / Xcode（根据目标平台选择）
- 一台已启动的后端服务（默认 http://localhost:3000）

## 快速启动

### 1. 安装依赖

```bash
flutter pub get
```

### 2. 添加平台支持（首次运行前）

```bash
flutter create .
```

> 这会生成 web、macOS、iOS、Android 等平台目录，不会覆盖现有代码。

### 3. 运行应用

```bash
flutter run -d chrome   # 在 Chrome 浏览器中运行（推荐，最快）
flutter run -d macos    # 在 macOS 桌面运行
flutter run             # 自动检测已连接的设备
```

> 也可在 Android Studio 或 Xcode 中直接选择目标设备运行。

### 4. 连接后端

在 `lib/core/config/api_config.dart` 中配置后端 API 地址：

```dart
const baseUrl = 'http://localhost:3000'; // 或替换为你的服务 IP
```

## 项目结构

```
mobile/
├── lib/
│   ├── main.dart                 # 应用入口
│   ├── core/                     # 核心配置与工具
│   └── features/                 # 功能模块
└── pubspec.yaml
```
