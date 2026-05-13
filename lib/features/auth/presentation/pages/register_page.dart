import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile/core/constants/user_roles.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile/features/auth/presentation/widgets/register_form_fields.dart';

/// Register sayfası — Rol seçimi, fakülte/bölüm, kişisel bilgiler.
///
/// Form section'ları `register_form_fields.dart`'a ayrılmıştır (SRP).
class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _studentNumberCtrl = TextEditingController();

  String _selectedRole = UserRoles.student;
  String? _selectedTerm;
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  int? _selectedFacultyId;
  int? _selectedDepartmentId;

  bool get _needsFaculty => [
    UserRoles.student,
    UserRoles.teacher,
    UserRoles.dean,
  ].contains(_selectedRole);
  bool get _needsDepartment =>
      [UserRoles.student, UserRoles.teacher].contains(_selectedRole);
  bool get _needsStudentFields => _selectedRole == UserRoles.student;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _phoneCtrl.dispose();
    _studentNumberCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    await ref
        .read(authProvider.notifier)
        .register(
          email: _emailCtrl.text.trim(),
          password: _passwordCtrl.text,
          firstName: _firstNameCtrl.text.trim(),
          lastName: _lastNameCtrl.text.trim(),
          activeDashboard: _selectedRole,
          phone: _phoneCtrl.text.trim(),
          studentNumber: _needsStudentFields
              ? _studentNumberCtrl.text.trim()
              : null,
          studentTerm: _needsStudentFields ? _selectedTerm : null,
          facultyId: _selectedFacultyId,
          departmentId: _selectedDepartmentId,
        );

    if (!mounted) return;

    final authState = ref.read(authProvider);
    if (authState.hasError) {
      setState(() {
        _isLoading = false;
        _errorMessage = authState.error.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kayıt Ol')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Ad Soyad
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _firstNameCtrl,
                        decoration: const InputDecoration(labelText: 'Ad'),
                        textInputAction: TextInputAction.next,
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Zorunlu' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _lastNameCtrl,
                        decoration: const InputDecoration(labelText: 'Soyad'),
                        textInputAction: TextInputAction.next,
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Zorunlu' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // E-posta
                TextFormField(
                  controller: _emailCtrl,
                  decoration: const InputDecoration(
                    labelText: 'E-posta',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Zorunlu';
                    if (!v.contains('@')) return 'Geçerli bir e-posta girin';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Şifre
                TextFormField(
                  controller: _passwordCtrl,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Şifre',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Zorunlu';
                    if (v.length < 6) return 'En az 6 karakter';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Telefon
                TextFormField(
                  controller: _phoneCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Telefon (opsiyonel)',
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 24),

                // Rol seçimi (widget)
                RoleSelector(
                  selectedRole: _selectedRole,
                  onChanged: (role) => setState(() {
                    _selectedRole = role;
                    _selectedFacultyId = null;
                    _selectedDepartmentId = null;
                    _selectedTerm = null;
                  }),
                ),
                const SizedBox(height: 16),

                // Fakülte/Bölüm dropdown (backend'den dinamik)
                AcademicFields(
                  showFaculty: _needsFaculty,
                  showDepartment: _needsDepartment,
                  selectedFacultyId: _selectedFacultyId,
                  selectedDepartmentId: _selectedDepartmentId,
                  onFacultyChanged: (id) => setState(() {
                    _selectedFacultyId = id;
                  }),
                  onDepartmentChanged: (id) => setState(() {
                    _selectedDepartmentId = id;
                  }),
                ),

                // Öğrenci alanları (widget)
                if (_needsStudentFields)
                  StudentFields(
                    studentNumberCtrl: _studentNumberCtrl,
                    selectedTerm: _selectedTerm,
                    onTermChanged: (v) => setState(() => _selectedTerm = v),
                  ),

                const SizedBox(height: 16),

                // Hata mesajı
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      _errorMessage!,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: AppColors.error),
                      textAlign: TextAlign.center,
                    ),
                  ),

                // Kayıt Butonu
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleRegister,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Kayıt Ol'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
