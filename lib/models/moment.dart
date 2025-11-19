import 'package:isar/isar.dart';

part 'moment.g.dart';

@collection
class Moment {
  Id id = Isar.autoIncrement; // 자동 증가 ID
  late String title; // (선택 사항: 간단한 제목)
  late String content; // 기록 본문
  late DateTime date; // 기록 날짜 및 시간
  late int happinessScore; // 행복의 온도 (1~5)
  late List<String> secretTags; // 비밀 태그 목록
  late String? photoPath; // 로컬에 저장된 사진 파일 경로 (null 가능)
}
