import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/ui_kit/navigation/uzman_app_bar.dart';
import 'package:mobile/features/admin/presentation/providers/assignment_provider.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile/features/admin/data/models/department_model.dart';

class AssignmentHubPage extends ConsumerStatefulWidget {
  const AssignmentHubPage({super.key});

  @override
  ConsumerState<AssignmentHubPage> createState() => _AssignmentHubPageState();
}

class _AssignmentHubPageState extends ConsumerState<AssignmentHubPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() {
    final user = ref.read(authProvider).value;
    if (user == null) return;
    final notifier = ref.read(assignmentProvider.notifier);

    // 1. Dean Load
    if (user.userType == 'dean' || user.userType == 'rector') {
      notifier.loadFaculties();
    }

    // 2. Dept Head Load
    if (user.isDepartmentHead) {
      notifier.loadDeptHeadData();
    }

    // 3. Advisor Load (Try for all teachers/heads/deans)
    if (user.userType == 'teacher' ||
        user.userType == 'dean' ||
        user.isDepartmentHead) {
      notifier.loadMyStudents();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).value;
    final state = ref.watch(assignmentProvider);

    // Snackbars
    ref.listen(assignmentProvider, (previous, next) {
      if (next.errorMessage != null &&
          next.errorMessage != previous?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppColors.error,
          ),
        );
      }
      if (next.successMessage != null &&
          next.successMessage != previous?.successMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.successMessage!),
            backgroundColor: Colors.green,
          ),
        );
      }
    });

    // DEBUG PRINT
    if (user != null) {
      debugPrint(
        "DEBUG: UserType: ${user.userType}, IsHead: ${user.isDepartmentHead}",
      );
    }

    return Scaffold(
      appBar: const UzmanAppBar(title: "Atamalar V2 [DEBUG MODE]"),
      body: state.isLoading && user == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- DEBUG HEADER (X-RAY) ---
                  if (user != null)
                    Container(
                      width: double.infinity,
                      color: Colors.red.shade100,
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "DEBUG INFO (REMOVE LATER)",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          Text("User Type: ${user.userType}"),
                          Text("Is Dept Head: ${user.isDepartmentHead}"),
                          Text("User ID: ${user.id}"),
                          Text("State Loading: ${state.isLoading}"),
                          Text("State Error: ${state.errorMessage}"),
                          Text("Faculties Count: ${state.faculties.length}"),
                          Text("Class Terms Count: ${state.classTerms.length}"),
                          Text("Students Count: ${state.students.length}"),
                        ],
                      ),
                    ),

                  if (state.isLoading) const LinearProgressIndicator(),

                  // 1. DEAN SECTION
                  if (user?.userType == 'dean' ||
                      user?.userType == 'rector') ...[
                    _buildSectionHeader("Bölüm Yönetimi (Dekan/Rektör)"),
                    _buildDeanSection(state),
                    const Divider(thickness: 1, height: 30),
                  ],

                  // 2. DEPT HEAD SECTION
                  if (user?.isDepartmentHead == true) ...[
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "--- ENTERED HEAD SECTION ---",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _buildSectionHeader("Danışman Atamaları (Bölüm Başkanı)"),
                    _buildDeptHeadSection(state),
                    const Divider(thickness: 1, height: 30),
                  ] else ...[
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "--- SKIPPED HEAD SECTION (Condition Failed) ---",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],

                  // 3. ADVISOR SECTION
                  // Note: Logic allows Dean/Head/Teacher to see this
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "--- ENTERED ADVISOR SECTION ---",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (user?.userType == 'teacher' ||
                      user?.isDepartmentHead == true ||
                      user?.userType == 'dean') ...[
                    _buildSectionHeader("Sınıf Temsilcisi Seçimi (Danışman)"),
                    _buildAdvisorSection(state),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.navy,
        ),
      ),
    );
  }

  // --- VIEW 1: DEAN ---
  Widget _buildDeanSection(AssignmentState state) {
    final departments = state.faculties.expand((f) => f.departments).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: DropdownButtonFormField<int>(
            value: state.selectedDepartmentId,
            decoration: const InputDecoration(
              labelText: "Bölüm Seçin",
              border: OutlineInputBorder(),
              filled: true,
              fillColor: AppColors.surfaceLight,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
            items: departments.map((DepartmentModel dept) {
              return DropdownMenuItem<int>(
                value: dept.id,
                child: Text(dept.name),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) {
                ref.read(assignmentProvider.notifier).selectDepartment(val);
              }
            },
          ),
        ),

        if (state.teachers.isNotEmpty || state.selectedDepartmentId != null)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: state.teachers.isEmpty ? 1 : state.teachers.length,
            itemBuilder: (context, index) {
              if (state.teachers.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Bu bölümde eğitmen bulunamadı."),
                  ),
                );
              }

              final teacher = state.teachers[index];
              final isHead = teacher.isDepartmentHead;

              return Card(
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isHead
                        ? AppColors.orange
                        : AppColors.cyan.withOpacity(0.2),
                    child: Text(
                      teacher.firstName?[0] ?? 'T',
                      style: TextStyle(
                        color: isHead ? Colors.white : AppColors.navy,
                      ),
                    ),
                  ),
                  title: Text("${teacher.firstName} ${teacher.lastName}"),
                  subtitle: Text(isHead ? "Bölüm Başkanı" : "Eğitmen"),
                  trailing: Switch(
                    value: isHead,
                    activeTrackColor: AppColors.orange.withOpacity(0.5),
                    activeColor: AppColors.orange,
                    onChanged: (val) {
                      ref
                          .read(assignmentProvider.notifier)
                          .toggleDeptHead(teacher.id);
                    },
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  // --- VIEW 2: DEPT HEAD ---
  Widget _buildDeptHeadSection(AssignmentState state) {
    if (state.classTerms.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text("Yönetilecek sınıf/dönem bulunamadı."),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: state.classTerms.length,
      itemBuilder: (context, index) {
        final term = state.classTerms[index];
        // Find advisor name Logic
        String advisorName = "Atanmadı";
        if (term.advisorId != null) {
          final found = state.teachers.where((t) => t.id == term.advisorId);
          if (found.isNotEmpty) {
            advisorName = "${found.first.firstName} ${found.first.lastName}";
          }
        }

        return Card(
          elevation: 1,
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Text(
              term.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("Danışman: $advisorName"),
            trailing: const Icon(Icons.edit, color: AppColors.cyan, size: 20),
            onTap: () {
              _showAdvisorDialog(term.id, state.teachers);
            },
          ),
        );
      },
    );
  }

  void _showAdvisorDialog(int classId, List<dynamic> teachers) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Danışman Seç"),
        content: SizedBox(
          width: double.maxFinite,
          child: teachers.isEmpty
              ? const Text("Bölümde eğitmen bulunamadı.")
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: teachers.length,
                  itemBuilder: (ctx, idx) {
                    final t = teachers[idx];
                    return ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: Text("${t.firstName} ${t.lastName}"),
                      onTap: () {
                        ref
                            .read(assignmentProvider.notifier)
                            .assignAdvisor(classId, t.id);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
        ),
      ),
    );
  }

  // --- VIEW 3: ADVISOR ---
  Widget _buildAdvisorSection(AssignmentState state) {
    if (state.students.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: const [
            Icon(Icons.info_outline, color: Colors.grey),
            SizedBox(width: 12),
            Expanded(
              child: Text("Danışmanı olduğunuz bir sınıf bulunmamaktadır."),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: state.students.length,
      itemBuilder: (context, index) {
        final student = state.students[index];
        final isRep = student.userType == 'r_student';

        return Card(
          color: isRep ? AppColors.cyan.withOpacity(0.05) : null,
          elevation: 1,
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: const Icon(Icons.person),
            title: Text("${student.firstName} ${student.lastName}"),
            subtitle: Text(student.username),
            trailing: isRep
                ? const Chip(
                    label: Text("Temsilci", style: TextStyle(fontSize: 12)),
                    backgroundColor: AppColors.cyan,
                    labelStyle: TextStyle(color: Colors.white),
                  )
                : OutlinedButton(
                    onPressed: () {
                      ref
                          .read(assignmentProvider.notifier)
                          .setRepresentative(student.id);
                    },
                    child: const Text("Seç"),
                  ),
          ),
        );
      },
    );
  }
}
