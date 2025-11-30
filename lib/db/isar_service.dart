import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:Innerlog/models/moment.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      return await Isar.open(
        [MomentSchema],
        directory: dir.path,
        inspector: true,
      );
    }
    return Future.value(Isar.getInstance());
  }

  Future<void> saveMoment(Moment moment) async {
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.moments.putSync(moment));
  }

  Future<void> deleteMoment(Id id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.moments.delete(id);
    });
  }

  Stream<List<Moment>> listenToMoments({
    String query = '',
    int? happinessScore,
  }) async* {
    final isar = await db;
    yield* isar.moments
        .filter()
        .group((q) => query.isEmpty
            ? q.idGreaterThan(-1)
            : q
                .titleContains(query, caseSensitive: false)
                .or()
                .contentContains(query, caseSensitive: false))
        .and()
        .group((q) => happinessScore == null
            ? q.idGreaterThan(-1)
            : q.happinessScoreEqualTo(happinessScore))
        .sortByDateDesc()
        .watch(fireImmediately: true);
  }
}

