import 'package:analytica_test/src/task/view_model/task_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:intl/intl.dart';

class TaskView extends StatefulWidget {
  const TaskView({super.key});

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  final SpeechToText _speechToText = SpeechToText();
  final _dateFormat = DateFormat('MMM d, yyyy h:mm a');
  bool _speechEnabled = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    try {
      _speechEnabled = await _speechToText.initialize(
        onError: (error) => _handleError(error),
        onStatus: (status) => _handleStatus(status),
      );
      setState(() {});
    } catch (e) {
      debugPrint('Error initializing speech: $e');
    }
  }

  void _handleError(SpeechRecognitionError error) {
    debugPrint('Error: ${error.errorMsg}, ${error.permanent}');
    setState(() {
      _speechEnabled = false;
    });
  }

  void _handleStatus(String status) {
    debugPrint('Status: $status');
  }

  Future<void> _startListening() async {
    final vm = context.read<TaskViewModel>();
    if (!_speechEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Speech recognition is not available')),
      );
      return;
    }

    if (!_speechToText.isListening) {
      vm.setListening(true);
      await _speechToText.listen(
        onResult: (result) => _onSpeechResult(result, vm),
      );
    }
  }

  void _onSpeechResult(SpeechRecognitionResult result, TaskViewModel vm) {
    vm.setCurrentVoiceText(result.recognizedWords);
    if (result.finalResult) {
      vm.processVoiceCommand(result.recognizedWords);
      vm.setListening(false);
    }
  }

  void _stopListening() {
    _speechToText.stop();
    context.read<TaskViewModel>().setListening(false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskViewModel>(
      builder: (context, vm, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Task Manager'),
          ),
          body: ListView.builder(
            itemCount: vm.tasks.length,
            itemBuilder: (context, index) {
              final task = vm.tasks[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    task.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(task.description),
                      const SizedBox(height: 4),
                      Text(
                        'Scheduled: ${_dateFormat.format(task.scheduledTime)}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => vm.deleteTask(task),
                  ),
                ),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: vm.isListening ? _stopListening : _startListening,
            child: Icon(vm.isListening ? Icons.stop : Icons.mic),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        );
      },
    );
  }
}
