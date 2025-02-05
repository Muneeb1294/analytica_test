import 'package:analytica_test/src/dashboard/view_model/dashboard_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardViewModel>(builder: (context, vm, _) {
      return SafeArea(
        bottom: true,
        child: Scaffold(
          body: Column(
            children: <Widget>[
              Flexible(
                child: ListView.builder(
                  padding: EdgeInsets.all(8.0),
                  reverse: true,
                  itemCount: vm.messages.length,
                  itemBuilder: (_, int index) => vm.messages[index],
                ),
              ),
              Divider(height: 1.0),
              Container(
                decoration: BoxDecoration(color: Theme.of(context).cardColor),
                child: _buildTextComposer(context, vm),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildTextComposer(BuildContext context, DashboardViewModel vm) {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).primaryColor),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: vm.textController,
                onSubmitted: (v) => vm.handleSubmitted(),
                decoration: InputDecoration.collapsed(
                  hintText: 'Send a message',
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () => vm.handleSubmitted(),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isMe;
  final DateTime time;

  const ChatMessage(
      {super.key, required this.text, required this.isMe, required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) CircleAvatar(child: Text('U')),
          Container(
            margin: EdgeInsets.only(left: 8.0, right: 8.0),
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: isMe ? Colors.blue : Colors.grey[300],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 200),
                  child: Text(
                    text,
                    style: TextStyle(color: isMe ? Colors.white : Colors.black),
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  DateFormat('hh:mm a').format(time),
                  style: TextStyle(
                    color: isMe ? Colors.white70 : Colors.black54,
                    fontSize: 10.0,
                  ),
                ),
              ],
            ),
          ),
          if (isMe) CircleAvatar(child: Text('Me')),
        ],
      ),
    );
  }
}
