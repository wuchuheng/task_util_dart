import 'package:wuchuheng_task_util/wuchuheng_task_util.dart';

void main() async {
  /// Individual task management.
  SingleTaskPool singleTaskPool = SingleTaskPool.builder();
  List<String> result = [];
  String firstTaskPrint = "foo";
  String secondTaskPrint = "bar";
  DateTime startTime = DateTime.now();
  await Future.wait([
    singleTaskPool.start(() async {
      await Future.delayed(Duration(seconds: 1));
      result.add(firstTaskPrint);
    }),
    singleTaskPool.start(() async {
      await Future.delayed(Duration(seconds: 1));
      result.add(secondTaskPrint);
    }),
  ]);

  /// Took more than 2 seconds.Even though the execution is concurrent, it still becomes a serial execution
  print(DateTime.now().microsecondsSinceEpoch - startTime.microsecondsSinceEpoch);

  /// Multiple task result reuse
  final multiplexTaskPool = MultiplexTaskPool.builder();
  List<String> multipleResult = await Future.wait([
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

  /// print: ['1', '1', '1']。
  /// Although 3 tasks are concurrent, only the first task is executed and the result is returned to the task to be executed later.
  print(multipleResult);
}
