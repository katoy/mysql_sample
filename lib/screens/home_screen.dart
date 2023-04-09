import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task_model.dart';
import '../provider/task_provider.dart';
import '../screens/task_form_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/';

  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  // final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  //    GlobalKey<RefreshIndicatorState>();
  final bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _refreshTasks(context); // 初期化時にタスク一覧を取得する
  }

  Future<void> _refreshTasks(BuildContext context) async {
    try {
      await Provider.of<TaskProvider>(context, listen: false).fetchTasks();
    } catch (error) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('An error occurred!'),
          content: const Text('Something went wrong.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Okay'),
              onPressed: () => Navigator.of(ctx).pop(),
            )
          ],
        ),
      );
    }
  }

  Future<void> _deleteTask(BuildContext context, int id) async {
    try {
      await Provider.of<TaskProvider>(context, listen: false).deleteTask(id);
      //await _refreshTasks(context);
    } catch (error) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('An error occurred!'),
          content: const Text('Something went wrong.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Okay'),
              onPressed: () => Navigator.of(ctx).pop(),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task List'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(TaskFormScreen.routeName, arguments: null);
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () => _refreshTasks(context),
              child: FutureBuilder(
                future: _refreshTasks(context),
                builder: (ctx, snapshot) => snapshot.connectionState ==
                        ConnectionState.waiting
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Consumer<TaskProvider>(
                        builder: (ctx, taskProvider, _) {
                          final tasks = taskProvider.items;
                          return tasks.isEmpty
                              ? const Center(
                                  child: Text('No tasks yet.'),
                                )
                              : ListView.builder(
                                  itemCount: tasks.length,
                                  itemBuilder: (ctx, index) {
                                    final task = tasks[index];
                                    return Card(
                                      margin: const EdgeInsets.all(8),
                                      child: ListTile(
                                        leading: Checkbox(
                                          value: task.isCompleted,
                                          onChanged: (_) {
                                            taskProvider.updateTask(
                                              task.id,
                                              Task(
                                                id: task.id,
                                                title: task.title,
                                                description: task.description,
                                                isCompleted: !task.isCompleted,
                                              ),
                                            );
                                          },
                                        ),
                                        title: Text(task.title),
                                        subtitle: Text(task.description),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.edit),
                                              onPressed: () {
                                                // タスクフォーム画面に遷移する
                                                Navigator.of(context).pushNamed(
                                                    TaskFormScreen.routeName,
                                                    arguments: task);
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete),
                                              onPressed: () {
                                                _deleteTask(context, task.id);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                        },
                      ),
              ),
            ),
    );
  }
}
