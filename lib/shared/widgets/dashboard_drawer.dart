import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';

import 'drawer/drawer_footer.dart';
import 'drawer/drawer_header.dart';
import 'drawer/drawer_link_item.dart';
import 'drawer/drawer_routes.dart';

/// Tüm ana sayfalarda ve dashboard'larda (Student, Teacher, Rep vs.)
/// kullanılan, rol bazlı navigasyon sağlayan ortak Drawer bileşeni.
/// Web'deki Sidebar.jsx mantığıyla birebir aynı.
class DashboardDrawer extends ConsumerWidget {
  const DashboardDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).value;

    // Kullanıcı henüz yüklenmemişse boş/basit drawer
    if (user == null) {
      return const Drawer(child: Center(child: CircularProgressIndicator()));
    }

    final routes = getDrawerRoutesForUser(user);

    return Drawer(
      child: Column(
        children: [
          // 1) Header Bilgileri (İsim, Rol vs.) - Sadece UI
          DashboardDrawerHeader(user: user),

          // 2) Body (Linkler) - Dinamik Route Mantığı
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: routes.length,
              itemBuilder: (context, index) {
                final route = routes[index];
                return DrawerLinkItem(
                  route: route,
                  isApproved: user.isApproved,
                );
              },
            ),
          ),

          // 3) Footer (Çıkış Yap) - Sadece Aksiyon
          const DashboardDrawerFooter(),
        ],
      ),
    );
  }
}
