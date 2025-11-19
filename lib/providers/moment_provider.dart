import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_sanctuary/db/isar_service.dart';
import 'package:my_sanctuary/models/moment.dart';

final isarServiceProvider = Provider<IsarService>((ref) {
  return IsarService();
});

final momentsStreamProvider = StreamProvider<List<Moment>>((ref) async* {
  final isarService = ref.watch(isarServiceProvider);
  yield* isarService.listenToMoments();
});
