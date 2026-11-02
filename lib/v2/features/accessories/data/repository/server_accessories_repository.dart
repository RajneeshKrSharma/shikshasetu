import '../../../../core/server/json.dart';
import '../../../../core/server/server_client.dart';
import '../../domain/entities/accessory.dart';
import '../../domain/repository/accessories_repository.dart';
import '../models/accessory_models.dart';

class ServerAccessoriesRepository implements AccessoriesRepository {
  ServerAccessoriesRepository(this._client);

  final ServerClient _client;

  @override
  Future<List<AccessoryItem>> items({
    AccessoryKind? kind,
    String? classId,
  }) async => [
    for (final i in jsonObjects(
      await _client.send(
        'GET',
        '/accessories/items/',
        query: {'kind': kind?.code, 'class_id': classId},
      ),
    ))
      AccessoryItemModel.fromJson(i),
  ];

  @override
  Future<AccessoryItem> save(AccessoryItemDraft d) async {
    final body = {
      'name': d.name,
      'price': d.price.wire,
      'class_id': d.classId,
      if (d.id == null) 'kind': d.kind.code,
    };
    final saved = d.id == null
        ? await _client.send('POST', '/accessories/items/', body: body)
        : await _client.send(
            'PATCH',
            '/accessories/items/${d.id}/',
            body: body,
          );
    return AccessoryItemModel.fromJson(jsonObject(saved));
  }

  @override
  Future<void> remove(String id) =>
      _client.send('DELETE', '/accessories/items/$id/');

  @override
  Future<void> sell(AccessorySale s) => _client.send(
    'POST',
    '/accessories/issues/',
    body: {
      'student_id': s.studentId,
      'item_id': s.itemId,
      'quantity': s.quantity,
    },
  );
}
