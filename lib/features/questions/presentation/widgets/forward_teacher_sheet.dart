import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/features/questions/data/repositories/question_repository.dart';
import 'package:mobile/features/auth/data/models/user_model.dart';
import 'package:mobile/core/ui_kit/ui_kit.dart';

class ForwardTeacherSheet extends ConsumerStatefulWidget {
  final int? currentHandlerId;
  final Function(UserModel) onTeacherSelected;

  const ForwardTeacherSheet({
    super.key,
    required this.currentHandlerId,
    required this.onTeacherSelected,
  });

  @override
  ConsumerState<ForwardTeacherSheet> createState() =>
      _ForwardTeacherSheetState();
}

class _ForwardTeacherSheetState extends ConsumerState<ForwardTeacherSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<UserModel> _allTeachers = [];
  List<UserModel> _filteredTeachers = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchTeachers();
    _searchController.addListener(_filterTeachers);
  }

  Future<void> _fetchTeachers() async {
    final result = await ref.read(questionRepositoryProvider).getTeachers();
    if (mounted) {
      result.fold(
        (failure) {
          setState(() {
            _error = failure.message;
            _isLoading = false;
          });
        },
        (teachers) {
          setState(() {
            _allTeachers = teachers
                .where((t) => t.id != widget.currentHandlerId)
                .toList();
            _filteredTeachers = _allTeachers;
            _isLoading = false;
          });
        },
      );
    }
  }

  void _filterTeachers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredTeachers = _allTeachers;
      } else {
        _filteredTeachers = _allTeachers.where((teacher) {
          final fullName = "${teacher.firstName} ${teacher.lastName}"
              .toLowerCase();
          return fullName.contains(query);
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            // Modal Handle
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Soruyu Yönlendir",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.navy,
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Eğitmen ara...",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Divider(height: 1),
            // Content
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                  ? Center(child: Text(_error!))
                  : _filteredTeachers.isEmpty
                  ? const Center(child: Text("Eşleşen eğitmen bulunamadı."))
                  : ListView.separated(
                      controller: scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: _filteredTeachers.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        final teacher = _filteredTeachers[index];
                        return ListTile(
                          leading: UzmanAvatar(
                            name: teacher.firstName ?? teacher.username,
                          ),
                          title: Text(
                            "${teacher.firstName} ${teacher.lastName}",
                          ),
                          subtitle: Text(teacher.email ?? ""),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                          onTap: () => widget.onTeacherSelected(teacher),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}
