import 'package:analytica_test/constants/enums.dart';
import 'package:flutter/material.dart';

import '../model/task_model.dart';
import '../../../services/llm_service.dart';

class TaskViewModel extends ChangeNotifier {
  final List<TaskModel> _tasks = [];
  bool _isListening = false;
  String _currentVoiceText = '';
  final LLMService _llmService = LLMService();

  List<TaskModel> get tasks => List.from(_tasks)
    ..sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));
  bool get isListening => _isListening;
  String get currentVoiceText => _currentVoiceText;

  void addTask(TaskModel task) {
    _tasks.add(task);
    notifyListeners();
  }

  void updateTask(TaskModel updatedTask) {
    final index = _tasks.indexWhere(
        (task) => task.title.toLowerCase() == updatedTask.title.toLowerCase());
    if (index != -1) {
      _tasks[index] = updatedTask;
      notifyListeners();
    }
  }

  void deleteTask(TaskModel taskToDelete) {
    _tasks.removeWhere(
        (task) => task.title.toLowerCase() == taskToDelete.title.toLowerCase());
    notifyListeners();
  }

  void setListening(bool value) {
    _isListening = value;
    notifyListeners();
  }

  void setCurrentVoiceText(String text) {
    _currentVoiceText = text;
    notifyListeners();
  }

  Future<void> processVoiceCommand(String command) async {
    final response = await _llmService.processCommand(command, _tasks);

    if (response.error != null) {
      debugPrint('Error: ${response.error}');
      return;
    }

    switch (response.operation) {
      case Operation.create:
        if (response.task != null) {
          addTask(response.task!);
        }
        break;
      case Operation.update:
        if (response.task != null) {
          updateTask(response.task!);
        }
        break;
      case Operation.delete:
        if (response.task != null) {
          deleteTask(response.task!);
        }
        break;
      case Operation.read:
        break;
      default:
        debugPrint('Unknown operation');
    }
  }
}
