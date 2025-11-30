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

  Stream<List<Moment>> listenToMoments() async* {
    final isar = await db;
    yield* isar.moments.where().sortByDateDesc().watch(fireImmediately: true);
  }
}
