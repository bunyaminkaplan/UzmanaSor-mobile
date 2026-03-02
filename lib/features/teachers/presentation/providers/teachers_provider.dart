import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile/core/constants/api_endpoints.dart';
import 'package:mobile/core/data/models/simple_user_model.dart';
import 'package:mobile/core/domain/entities/simple_user_entity.dart';
import 'package:mobile/core/network/api_client.dart';

/// Teachers provider'ı.
///
/// Backend: GET core/teachers/ → UserSerializer listesi
/// Teachers ayrı bir entity gerektirmez — SimpleUserEntity ile yeterli.
/// Opsiyonel: `?department=<id>` ile filtre yapılabilir.

final teachersProvider = FutureProvider.autoDispose
    .family<List<SimpleUserEntity>, int?>((ref, departmentId) async {
      final apiClient = ref.watch(apiClientProvider);

      String url = ApiEndpoints.teachers;
      if (departmentId != null) {
        url = '${ApiEndpoints.teachers}?department=$departmentId';
      }

      final response = await apiClient.get(url);

      // Paginated veya düz liste
      final List<dynamic> data;
      if (response.data is List) {
        data = response.data as List;
      } else if (response.data is Map &&
          (response.data as Map).containsKey('results')) {
        data = response.data['results'] as List;
      } else {
        data = [];
      }

      return data
          .map(
            (json) => SimpleUserModel.fromJson(
              json as Map<String, dynamic>,
            ).toEntity(),
          )
          .toList();
    });
