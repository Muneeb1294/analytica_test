import 'package:analytica_test/constants/enums.dart';
import 'package:analytica_test/src/task/model/llm_model.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../src/task/model/task_model.dart';

class LLMService {
  final GenerativeModel _model;
  static const String _apiKey = 'AIzaSyDfXg-ePePaz57G9Fh4rvcSlqpsaNnsM_E';

  LLMService()
      : _model = GenerativeModel(
          model: 'gemini-1.5-pro',
          apiKey: _apiKey,
        );

  Future<LLMResponse> processCommand(
      String command, List<TaskModel> existingTasks) async {
    try {
      final prompt = '''
      Process the following command and extract task information:
      Command: $command
      
      Current Tasks:
      ${existingTasks.map((task) => '- ${task.title}').join('\n')}
      
      Extract the following information if present:
      - Operation (create, update, delete, or read)
      - Task Title (if updating or deleting)
      - New Title (if updating)
      - Description
      - Date and time
      
      Return the information only in this exact JSON format:
      {
        "operation": "create|update|delete|read",
        "taskTitle": "existing_task_title",
        "newTitle": "new_task_title",
        "description": "task_description",
        "scheduledTime": "YYYY-MM-DD HH:MM"
      }
      ''';

      final response = await _model.generateContent([Content.text(prompt)]);
      final text = response.text;
      debugPrint(text);
      if (text == null) {
        debugPrint('No response from LLM');
        return LLMResponse(error: 'No response from LLM');
      }

      try {
        final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(text);
        if (jsonMatch == null) {
          return LLMResponse(error: 'Could not parse response');
        }

        final jsonStr = jsonMatch.group(0);
        final operation = _extractValue(jsonStr, 'operation');
        final taskTitle = _extractValue(jsonStr, 'taskTitle');
        final newTitle = _extractValue(jsonStr, 'newTitle');
        final description = _extractValue(jsonStr, 'description');
        final scheduledTimeStr = _extractValue(jsonStr, 'scheduledTime');

        DateTime? scheduledTime;
        if (scheduledTimeStr != null) {
          try {
            scheduledTime = DateTime.parse(scheduledTimeStr);
          } catch (e) {
            debugPrint('Error parsing date: $e');
          }
        }

        switch (operation?.toLowerCase()) {
          case 'create':
            return LLMResponse(
              operation: Operation.create,
              task: TaskModel(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                title: newTitle ?? 'New Task',
                description: description ?? command,
                scheduledTime: scheduledTime ??
                    DateTime.now().add(const Duration(hours: 1)),
              ),
            );
          case 'update':
            if (taskTitle == null) {
              return LLMResponse(
                  error: 'Task title is required for update operation');
            }
            final index = existingTasks.indexWhere(
              (task) => task.title.toLowerCase() == taskTitle.toLowerCase(),
            );
            if (index != -1) {
              return LLMResponse(
                operation: Operation.update,
                task: existingTasks[index].copyWith(
                  title: newTitle ?? existingTasks[index].title,
                  description: description ?? existingTasks[index].description,
                  scheduledTime:
                      scheduledTime ?? existingTasks[index].scheduledTime,
                ),
              );
            }
            return LLMResponse(
                error: 'Task not found, please create a new task');
          case 'delete':
            if (taskTitle == null) {
              return LLMResponse(
                  error: 'Task title is required for delete operation');
            }
            final index = existingTasks.indexWhere(
              (task) => task.title.toLowerCase() == taskTitle.toLowerCase(),
            );
            if (index != -1) {
              return LLMResponse(
                operation: Operation.delete,
                task: existingTasks[index],
              );
            }
            return LLMResponse(
                error: 'Task not found, please create a new task');
          case 'read':
            return LLMResponse(
              operation: Operation.read,
              tasks: existingTasks,
            );
          default:
            return LLMResponse(error: 'Invalid operation: $operation');
        }
      } catch (e) {
        debugPrint('Error parsing response: $e');
        return LLMResponse(error: 'Error parsing response: $e');
      }
    } catch (e) {
      debugPrint('Error processing command: $e');
      return LLMResponse(error: 'Error processing command: $e');
    }
  }

  String? _extractValue(String? jsonStr, String key) {
    if (jsonStr == null) return null;
    final pattern = '"$key":\\s*"([^"]*)"';
    final match = RegExp(pattern).firstMatch(jsonStr);
    return match?.group(1);
  }
}
