import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Innerlog/db/isar_service.dart';
import 'package:Innerlog/models/moment.dart';

final isarServiceProvider = Provider<IsarService>((ref) {
  return IsarService();
});

final searchQueryProvider = StateProvider<String>((ref) => '');
final happinessFilterProvider = StateProvider<int?>((ref) => null);

final momentsStreamProvider = StreamProvider<List<Moment>>((ref) async* {
  final isarService = ref.watch(isarServiceProvider);
  final query = ref.watch(searchQueryProvider);
  final happinessScore = ref.watch(happinessFilterProvider);

  yield* isarService.listenToMoments(query: query, happinessScore: happinessScore);
});
