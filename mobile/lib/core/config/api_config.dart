import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConfig {
  // 本地开发服务器地址，真机测试时改成你的局域网 IP
  static const String _devHost = '192.168.0.103';
  static const int port = 3000;

  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:$port';
    if (Platform.isAndroid) {
      // Android 模拟器用 10.0.2.2 访问宿主机；真机用局域网 IP
      return 'http://$_devHost:$port';
    }
    // iOS 模拟器 & 真机
    return 'http://localhost:$port';
  }

  static const Duration timeout = Duration(seconds: 30);
}
