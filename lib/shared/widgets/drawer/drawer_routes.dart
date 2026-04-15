import 'package:flutter/material.dart';
import 'package:mobile/features/auth/domain/entities/user_entity.dart';

/// DrawerRouteItem, her bir menü öğesini temsil eden basit bir DTO'dur.
class DrawerRouteItem {
  final String title;
  final String path;
  final IconData icon;
  final bool isAlwaysAllowed;

  const DrawerRouteItem({
    required this.title,
    required this.path,
    required this.icon,
    this.isAlwaysAllowed = false,
  });
}

/// [getDrawerRoutesForUser]
/// Kullanıcının yetki (rol) ve ekstra bayraklarına (isDepartmentHead, isAdvisor)
/// bakarak UI katmanına göstereceği rotaları (DTO listesi) döner.
///
/// Bu sayede UI katmanı sadece "Çizim" yaparken, Karar/İş Mantığı buradadır.
List<DrawerRouteItem> getDrawerRoutesForUser(UserEntity user) {
  final role = user.userType;
  final List<DrawerRouteItem> links = [];

  // 1. Ortak Rotalar (Herkes görebilir ve her zaman Always Allowed - Kilitlenmez)
  links.add(
    const DrawerRouteItem(
      title: 'Genel Akış',
      path: '/active-feed',
      icon: Icons.public,
      isAlwaysAllowed: true,
    ),
  );
  links.add(
    const DrawerRouteItem(
      title: 'Profilim',
      path: '/profile',
      icon: Icons.person_outline,
      isAlwaysAllowed: true,
    ),
  );

  // --- Rol Bazlı Özel Rotalar ---

  // STUDENT & R_STUDENT
  if (role == 'student' || role == 'r_student') {
    links.add(
      const DrawerRouteItem(
        title: 'Öğrenci Paneli',
        path: '/dashboard',
        icon: Icons.dashboard_outlined,
        isAlwaysAllowed: true, // Dashboardlar kilitlenmez
      ),
    );

    if (role == 'r_student') {
      links.add(
        const DrawerRouteItem(
          title: 'Temsilci Paneli',
          path: '/rep-dashboard',
          icon: Icons.fact_check_outlined,
        ),
      );
    }
  }
  // TEACHER
  else if (role == 'teacher' || role == 'department_head') {
    links.add(
      const DrawerRouteItem(
        title: 'Öğretmen Paneli',
        path: '/dashboard',
        icon: Icons.co_present_outlined,
        isAlwaysAllowed: true, // Dashboard kilitlenmez
      ),
    );

    if (user.isDepartmentHead) {
      links.add(
        const DrawerRouteItem(
          title: 'Ders Yönetimi',
          path: '/manage-courses',
          icon: Icons.menu_book_outlined,
          isAlwaysAllowed: true,
        ),
      );
      links.add(
        const DrawerRouteItem(
          title: 'Danışman Yönetimi',
          path: '/manage-advisors',
          icon: Icons.school_outlined,
          isAlwaysAllowed: true,
        ),
      );
      links.add(
        const DrawerRouteItem(
          title: 'Onay İşlemleri',
          path: '/manage-approvals',
          icon: Icons.checklist_rtl_outlined,
          isAlwaysAllowed: true,
        ),
      );
    }
    // Danışman hocalar için Temsilci Seçimi rotası
    if (user.isAdvisor) {
      links.add(
        const DrawerRouteItem(
          title: 'Temsilci Seçimi',
          path: '/manage-class-rep',
          icon: Icons.workspace_premium_outlined,
        ),
      );
    }
  }
  // DEAN
  else if (role == 'dean') {
    links.add(
      const DrawerRouteItem(
        title: 'Dekan Paneli',
        path: '/dashboard',
        icon: Icons.pie_chart_outline,
        isAlwaysAllowed: true,
      ),
    );
    links.add(
      const DrawerRouteItem(
        title: 'Bölüm Yönetimi',
        path: '/manage-heads',
        icon: Icons.groups_outlined,
      ),
    );
    links.add(
      const DrawerRouteItem(
        title: 'Onay İşlemleri',
        path: '/manage-approvals',
        icon: Icons.checklist_rtl_outlined,
      ),
    );
  }
  // RECTOR
  else if (role == 'rector') {
    links.add(
      const DrawerRouteItem(
        title: 'Rektör Paneli',
        path: '/dashboard',
        icon: Icons.account_balance_outlined,
        isAlwaysAllowed: true,
      ),
    );
    links.add(
      const DrawerRouteItem(
        title: 'Onay İşlemleri',
        path: '/manage-approvals',
        icon: Icons.checklist_rtl_outlined,
      ),
    );
  }
  // SCHOOL ADMIN
  else if (role == 'school_admin') {
    links.add(
      const DrawerRouteItem(
        title: 'Yönetici Paneli',
        path: '/dashboard',
        icon: Icons.admin_panel_settings_outlined,
        isAlwaysAllowed: true,
      ),
    );
    links.add(
      const DrawerRouteItem(
        title: 'Ders Yönetimi',
        path: '/admin-courses',
        icon: Icons.book_outlined,
      ),
    );
    links.add(
      const DrawerRouteItem(
        title: 'Dönem Yönetimi',
        path: '/manage-terms',
        icon: Icons.event_note_outlined,
      ),
    );
    links.add(
      const DrawerRouteItem(
        title: 'Onay İşlemleri',
        path: '/manage-approvals',
        icon: Icons.checklist_rtl_outlined,
      ),
    );
    links.add(
      const DrawerRouteItem(
        title: 'İçerik Denetimi',
        path: '/content-moderation',
        icon: Icons.shield_outlined,
      ),
    );
  }

  return links;
}
