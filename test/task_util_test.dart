import 'package:test/test.dart';
import 'package:wuchuheng_task_util/src/multiplex_task_pool.dart';
import 'package:wuchuheng_task_util/src/single_task_pool.dart';

void main() {
  group('Single task group of tests', () {
    setUp(() {
      // Additional setup goes here.
    });
    test('Single task Test', () async {
      SingleTaskPool singleTaskPool = SingleTaskPool.builder();
      List<String> result = [];
      String firstTaskPrint = "foo";
      String secondTaskPrint = "bar";
      DateTime startTime = DateTime.now();
      await singleTaskPool.start(() async {
        await Future.delayed(Duration(seconds: 1));
        result.add(firstTaskPrint);
      });
      await singleTaskPool.start(() async {
        await Future.delayed(Duration(seconds: 1));
        result.add(secondTaskPrint);
      });
      List<String> expectResult = [firstTaskPrint, secondTaskPrint];
      int index = 0;
      for (String item in result) {
        expect(item == expectResult[index], isTrue);
        index++;
      }
      final duration = DateTime.now().microsecondsSinceEpoch - startTime.microsecondsSinceEpoch;
      expect(duration, greaterThanOrEqualTo(2000000));
    });
  });

  group('MultiplexTaskPool group of test', () {
    test('Single task Test', () async {
      final multiplexTaskPool = MultiplexTaskPool.builder();
      List<String> result = await Future.wait([
        multiplexTaskPool.start<String>(() async {
          return "1";
        }),
        multiplexTaskPool.start<String>(() async {
          return "2";
        }),
        multiplexTaskPool.start<String>(() async {
          return "3";
        }),
      ]);
      for (final item in result) {
        expect(item == "1", isTrue);
      }
    });
  });
}
