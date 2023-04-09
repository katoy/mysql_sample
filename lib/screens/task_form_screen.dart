import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/task_model.dart';
import '../provider/task_provider.dart';

class TaskFormScreen extends StatefulWidget {
  static const routeName = '/task-form';

  const TaskFormScreen({super.key});

  @override
  TaskFormScreenState createState() => TaskFormScreenState();
}

class TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  late Task _task;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args != null) {
      _task = args as Task;
    } else {
      _task = Task(id: 0, title: '', description: '', isCompleted: false);
    }
    _titleController.text = _task.title;
    _descriptionController.text = _task.description;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();

    _task.title = _titleController.text;
    _task.description = _descriptionController.text;

    if (_task.id == 0) {
      await TaskProvider().addTask(_task);
    } else {
      await TaskProvider().updateTask(_task.id, _task);
    }

    Navigator.pop(context);

    await Provider.of<TaskProvider>(context, listen: false).fetchTasks();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = _task.id != 0; // 編集画面かどうか判定する

    return Scaffold(
      appBar: AppBar(
          // 編集画面かどうかによってタイトルを変更する
          title: Text(isEditing ? 'Edit List' : 'Add List')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  controller: _titleController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  controller: _descriptionController,
                  maxLines: 4,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveForm,
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
