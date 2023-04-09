import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/task_model.dart';
import '../provider/task_provider.dart';

class TaskProvider with ChangeNotifier {
  static const _baseApiUrl = 'http://127.0.0.1:5000';

  List<Task> _items = [];

  List<Task> get items {
    return [..._items];
  }

  Future<void> fetchTasks() async {
    final response = await http.get(Uri.parse('$_baseApiUrl/tasks'));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);

      _items = responseData.map((data) => Task.fromJson(data)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  Future<void> addTask(Task task) async {
    await fetchTasks();
    final response = await http.post(
      Uri.parse('$_baseApiUrl/tasks'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(task.toJson()),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      _items.add(Task.fromJson(responseData));
      notifyListeners();
    } else {
      //throw Exception('Failed to add task');
    }
  }

  Future<void> deleteTask(int id) async {
    final response = await http.delete(Uri.parse('$_baseApiUrl/tasks/$id'));

    if (response.statusCode == 200) {
      _items.removeWhere((task) => task.id == id);
      notifyListeners();
    } else {
      throw Exception('Failed to delete task');
    }
  }

  Future<void> updateTask(int id, Task task) async {
    await fetchTasks();
    final index = _items.indexWhere((task) => task.id == id);
    if (index >= 0) {
      final response = await http.put(
        Uri.parse('$_baseApiUrl/tasks/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(task.toJson()),
      );

      if (response.statusCode == 200) {
        /// _items[index] = task;
        notifyListeners();
      } else {
        throw Exception('Failed to update task');
      }
    } else {
      throw Exception('Could not find task');
    }
  }
}
