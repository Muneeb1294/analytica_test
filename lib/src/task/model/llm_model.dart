import 'package:analytica_test/constants/enums.dart';
import 'package:analytica_test/src/task/model/task_model.dart';

class LLMResponse {
  final Operation? operation;
  final TaskModel? task;
  final List<TaskModel>? tasks;
  final String? error;

  LLMResponse({
    this.operation,
    this.task,
    this.tasks,
    this.error,
  });
}
