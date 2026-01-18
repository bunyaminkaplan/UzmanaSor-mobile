import 'dart:io';

class AppConstants {
  // CONFIGURATION FLAGS
  static const bool useLocalWifi =
      false; // Set TRUE for Wi-Fi (requires localWifiIp)
  static const bool usePhysicalUSB = true; // SET THIS TO TRUE FOR ADB REVERSE

  // YOUR PC'S LOCAL IP (UPDATE THIS WHEN IP CHANGES)
  static const String localWifiIp = "192.168.1.35"; // Your PC IP

  static String get baseUrl {
    // 1. Priority: Wi-Fi
    if (useLocalWifi) {
      return "http://$localWifiIp:8000/api/v1/";
    }

    // 2. Priority: Physical Device via USB (ADB Reverse)
    if (usePhysicalUSB) {
      return "http://127.0.0.1:8000/api/v1/"; // Phone thinks PC is localhost
    }

    // 3. Fallback: Emulator (Standard Android Emulator IP)
    if (Platform.isAndroid) {
      return "http://10.0.2.2:8000/api/v1/";
    }

    // 4. Fallback: iOS Simulator / Web
    return "http://127.0.0.1:8000/api/v1/";
  }
}
