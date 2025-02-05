import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:analytica_test/constants/string_constants.dart';
import 'package:analytica_test/services/dio_base_service.dart';
import 'package:analytica_test/src/dashboard/chat/chat_view.dart';
import 'package:analytica_test/src/dashboard/model/post_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DashboardViewModel extends ChangeNotifier {
  final Dio _dio = DioBaseService.dio;
  bool isLoading = false;
  List<PostModel> postsList = [];

  final TextEditingController textController = TextEditingController();
  final List<ChatMessage> messages = [];

  Future<void> handleSubmitted() async {
    String text = textController.text;
    textController.clear();
    ChatMessage message = ChatMessage(
      text: text,
      isMe: true,
      time: DateTime.now(),
    );

    messages.insert(0, message);
    await sendMessage(text);
    text = "";
    update();
  }

  Future<void> getPosts() async {
    try {
      Response response = await _dio.get(
        StringConstants.placeholderUrl,
      );
      List<dynamic> data = response.data;
      postsList = data.map((e) => PostModel.fromJson(e)).toList();
      update();
    } catch (e) {
      debugPrintStack();
    }
  }

  Future<void> sendMessage(String message) async {
    try {
      var response = await http.post(
        Uri.parse(StringConstants.openAIURL),
        headers: {
          'Authorization': 'Bearer ${StringConstants.apiKey}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          {
            "model": 'gpt-3.5-turbo-0125',
            "messages": [
              {"role": "user", "content": message}
            ],
          },
        ),
      );

      Map jsonResponse = jsonDecode(response.body);
      print(response.body);
      if (jsonResponse['error'] != null) {
        throw HttpException(jsonResponse['error']['message']['content']);
      }

      String apiResponse = jsonResponse["choices"][0]['message']['content'];
    } catch (e, stackTrace) {
      debugPrint("Error: $e");
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  void startLoading() {
    isLoading = true;
    update();
  }

  void stopLoading() {
    isLoading = false;
    update();
  }

  void update() {
    notifyListeners();
  }
}
