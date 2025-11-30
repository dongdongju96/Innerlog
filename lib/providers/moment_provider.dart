import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Innerlog/db/isar_service.dart';
import 'package:Innerlog/models/moment.dart';

final isarServiceProvider = Provider<IsarService>((ref) {
  return IsarService();
});

final momentsStreamProvider = StreamProvider<List<Moment>>((ref) async* {
  final isarService = ref.watch(isarServiceProvider);
  yield* isarService.listenToMoments();
});
