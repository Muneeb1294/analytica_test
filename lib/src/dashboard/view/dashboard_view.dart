import 'package:analytica_test/src/dashboard/chat/chat_view.dart';
import 'package:analytica_test/src/dashboard/post_view.dart/post_view.dart';
import 'package:analytica_test/src/dashboard/view_model/dashboard_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DashboardViewModel>(context, listen: false).getPosts();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Analytica Test'),
          bottom: TabBar(
            physics: const NeverScrollableScrollPhysics(),
            tabs: [
              Tab(icon: Icon(Icons.view_list), text: 'Posts'),
              Tab(icon: Icon(Icons.chat), text: 'Chats'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            PostView(),
            ChatView(),
          ],
        ),
      ),
    );
  }
}
