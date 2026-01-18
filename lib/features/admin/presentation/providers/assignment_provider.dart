import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/network/dio_client.dart';
import 'package:mobile/features/admin/data/models/class_term_model.dart';
import 'package:mobile/features/admin/data/models/faculty_model.dart';
import 'package:mobile/features/admin/data/repositories/assignment_repository_impl.dart';
import 'package:mobile/features/admin/domain/repositories/assignment_repository.dart';
import 'package:mobile/features/auth/data/models/user_model.dart';

// --- PROVIDER ---
final assignmentRepositoryProvider = Provider<AssignmentRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return AssignmentRepositoryImpl(dio);
});

// --- STATE ---
class AssignmentState {
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  // Data Lists
  final List<FacultyModel> faculties; // Contains Departments
  final int? selectedDepartmentId; // For Dean Selection

  final List<UserModel> teachers; // For Dean/Head
  final List<ClassTermModel> classTerms; // For Head
  final List<UserModel> students; // For Advisor

  AssignmentState({
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
    this.faculties = const [],
    this.selectedDepartmentId,
    this.teachers = const [],
    this.classTerms = const [],
    this.students = const [],
  });

  AssignmentState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
    List<FacultyModel>? faculties,
    int? selectedDepartmentId,
    List<UserModel>? teachers,
    List<ClassTermModel>? classTerms,
    List<UserModel>? students,
  }) {
    return AssignmentState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      successMessage: successMessage,
      faculties: faculties ?? this.faculties,
      selectedDepartmentId: selectedDepartmentId ?? this.selectedDepartmentId,
      teachers: teachers ?? this.teachers,
      classTerms: classTerms ?? this.classTerms,
      students: students ?? this.students,
    );
  }
}

// --- NOTIFIER ---
class AssignmentNotifier extends Notifier<AssignmentState> {
  late final AssignmentRepository _repository;

  @override
  AssignmentState build() {
    _repository = ref.watch(assignmentRepositoryProvider);
    return AssignmentState();
  }

  void clearMessages() {
    state = state.copyWith(errorMessage: null, successMessage: null);
  }

  // --- DEAN ACTIONS ---
  Future<void> loadFaculties() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await _repository.getFaculties();
    result.fold(
      (l) => state = state.copyWith(isLoading: false, errorMessage: l.message),
      (r) => state = state.copyWith(isLoading: false, faculties: r),
    );
  }

  Future<void> selectDepartment(int departmentId) async {
    state = state.copyWith(selectedDepartmentId: departmentId, teachers: []);
    await loadPotentialHeads();
  }

  Future<void> loadPotentialHeads() async {
    if (state.selectedDepartmentId == null) return;

    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await _repository.getPotentialHeads(
      departmentId: state.selectedDepartmentId!,
    );
    result.fold(
      (l) => state = state.copyWith(isLoading: false, errorMessage: l.message),
      (r) => state = state.copyWith(isLoading: false, teachers: r),
    );
  }

  Future<void> toggleDeptHead(int teacherId) async {
    final result = await _repository.toggleDeptHead(teacherId: teacherId);
    result.fold((l) => state = state.copyWith(errorMessage: l.message), (r) {
      state = state.copyWith(successMessage: "Bölüm Başkanlığı güncellendi.");
      loadPotentialHeads(); // Reload
    });
  }

  // --- DEPT HEAD ACTIONS ---
  Future<void> loadDeptHeadData() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final termsRes = await _repository.getDepartmentClassTerms();
    final teachersRes = await _repository.getDepartmentTeachers();

    List<ClassTermModel> terms = [];
    List<UserModel> teachers = [];
    String? error;

    termsRes.fold((l) => error = l.message, (r) => terms = r);
    teachersRes.fold((l) => error = l.message, (r) => teachers = r);

    state = state.copyWith(
      isLoading: false,
      classTerms: terms,
      teachers: teachers,
      errorMessage: error,
    );
  }

  Future<void> assignAdvisor(int classId, int teacherId) async {
    final result = await _repository.assignAdvisor(
      classTermId: classId,
      teacherId: teacherId,
    );
    result.fold((l) => state = state.copyWith(errorMessage: l.message), (r) {
      state = state.copyWith(successMessage: "Danışman atandı.");
      loadDeptHeadData(); // Reload
    });
  }

  // --- ADVISOR ACTIONS ---
  Future<void> loadMyStudents() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await _repository.getMyClassStudents();
    result.fold(
      (l) => state = state.copyWith(isLoading: false, errorMessage: l.message),
      (r) => state = state.copyWith(isLoading: false, students: r),
    );
  }

  Future<void> setRepresentative(int studentId) async {
    final result = await _repository.setClassRepresentative(
      studentId: studentId,
    );
    result.fold((l) => state = state.copyWith(errorMessage: l.message), (r) {
      state = state.copyWith(successMessage: "Temsilci güncellendi.");
      loadMyStudents(); // Reload
    });
  }
}

final assignmentProvider =
    NotifierProvider<AssignmentNotifier, AssignmentState>(() {
      return AssignmentNotifier();
    });
