/// [ApiEndpoints] - Proje genelinde kullanılan API adreslerinin tek doğruluk kaynağıdır.
///
/// React projesindeki `endpoints.js` dosyasının birebir karşılığıdır.
/// Base URL ve tüm path tanımları burada bulunur.
class ApiEndpoints {
  // Private constructor to prevent instantiation
  ApiEndpoints._();

  // TODO: Prod ortamı için bu kısımlar environment variable'dan okunmalı (flutter_dotenv)
  // Şimdilik development ortamı varsayılıyor.
  static const String baseUrl = 'http://10.0.2.2:8000/api/v1/';

  // --- AUTHENTICATION ---
  static const String authMe = 'auth/me/';
  static const String authLogin = 'auth/login/';
  static const String authLogout = 'auth/logout/';
  static const String authRegister = 'auth/register/';
  static const String authPendingApprovals = 'auth/pending-approvals/';

  // --- CORE MODULE ---

  // Academic Units
  static const String academicUnits = 'core/academic-units/';

  // Courses
  static const String courses = 'core/courses/';
  static const String myCourses = 'core/courses/my-courses/';

  // Teachers
  static const String teachers = 'core/teachers/';

  // Questions
  static const String questions = 'core/questions/';

  /// Parametre alan endpointler method olarak tanımlanır.
  static String questionDetail(dynamic id) => 'core/questions/$id/';

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
}
