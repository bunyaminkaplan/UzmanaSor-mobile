import 'dart:io';

import 'package:flutter/foundation.dart';

/// [ApiEndpoints] — Proje genelinde kullanılan API adreslerinin tek doğruluk kaynağıdır.
///
/// React projesindeki `endpoints.js` dosyasının birebir karşılığıdır.
/// Base URL ve tüm path tanımları burada bulunur.
///
/// Base URL Seçim Mantığı (öncelik sırasıyla):
///   1. usePhysicalUSB = true → 127.0.0.1 (adb reverse ile fiziksel cihaz)
///   2. Android Emulator → 10.0.2.2 (emulator'ün host alias'ı)
///   3. iOS Simulator → 127.0.0.1 (localhost'a doğrudan erişim)
///   4. Diğer → 127.0.0.1
class ApiEndpoints {
  ApiEndpoints._();

  // --------------- DEVELOPMENT AYARLARI ---------------
  // Fiziksel cihazı USB ile bağlayıp `adb reverse tcp:8000 tcp:8000`
  // çalıştırdığında bunu true yap.
  static const bool usePhysicalUSB = true;

  // WiFi üzerinden test ediyorsan bilgisayarının local IP'sini yaz.
  // Örn: 192.168.1.100
  static const bool useLocalWifi = false;
  static const String localWifiIp = '192.168.1.100';

  static const int _port = 8000;
  static const String _apiPrefix = '/api/v1/';

  /// Runtime'da cihaz tipine göre doğru baseUrl'i döner.
  static String get baseUrl {
    // 1. Fiziksel USB bağlantısı (adb reverse)
    if (usePhysicalUSB) {
      return 'http://127.0.0.1:$_port$_apiPrefix';
    }

    // 2. WiFi bağlantısı
    if (useLocalWifi) {
      return 'http://$localWifiIp:$_port$_apiPrefix';
    }

    // 3. Platform algılama (emulator/simulator)
    if (!kIsWeb) {
      if (Platform.isAndroid) {
        // Android emulator: 10.0.2.2 host bilgisayara yönlendirir
        return 'http://10.0.2.2:$_port$_apiPrefix';
      }
    }
    // iOS simulator veya diğer: localhost
    return 'http://127.0.0.1:$_port$_apiPrefix';
  }

  // --- AUTHENTICATION ---
  static const String authMe = 'auth/me/';
  static const String authLogin = 'auth/login/';
  static const String authLogout = 'auth/logout/';
  static const String authRegister = 'auth/register/';
  static const String authPendingApprovals = 'auth/pending-approvals/';
  static const String authApproveUser = 'auth/approve-user/';

  // --- CORE MODULE ---

  // Academic Units
  static const String academicUnits = 'core/academic-units/';
  static const String academicUnitsClassTerms =
      'core/academic-units/class_terms/';

  // Courses
  static const String courses = 'core/courses/';
  static const String myCourses = 'core/courses/my-courses/';

  // Teachers
  static const String teachers = 'core/teachers/';

  // Questions
  static const String questions = 'core/questions/';

  /// Parametre alan endpointler method olarak tanımlanır.
  static String questionDetail(dynamic id) => 'core/questions/$id/';
  static String questionForward(dynamic id) => 'core/questions/$id/forward/';

  // Answers
  static const String answers = 'core/answers/';

  // Class Terms
  static const String classTerms = 'core/class-terms/';

  // Department Head Specific
  static const String deptHeadClassTerms = 'core/dept-head/class-terms/';
  static const String deptHeadTeachers = 'core/dept-head/teachers/';

  // Statistics
  static const String statsRector = 'core/stats/rector/';
  static const String statsDean = 'core/stats/dean/';

  // --- ASSIGNMENT ENDPOINTS ---
  static const String toggleDeptHead =
      'core/teachers/{id}/toggle-head/'; // Replace {id}
  static const String assignAdvisor = 'core/dept-head/assign-advisor/';
  static const String advisorStudents = 'core/advisor/students/';
  static const String setRepresentative =
      'core/advisor/students/set-representative/';

  // Teacher Busy Mode
  static const String teacherBusyTerms = 'core/teacher-busy-terms/';
  static String teacherBusyTermDetail(int id) => 'core/teacher-busy-terms/$id/';

  // Content Moderation (Reports)
  static const String reports = 'core/reports/';
  static String reportAction(int id, String action) =>
      'core/reports/$id/$action/';
}
