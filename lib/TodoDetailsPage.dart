// ignore: file_names


import 'package:flutter/material.dart';

class TodoDetailsPage extends StatelessWidget {
  final Map<String, dynamic> todo;

  const TodoDetailsPage({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title: ${todo['title']}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('ID: ${todo['id']}'),
            Text('User ID: ${todo['userId']}'),
            Text('Completed: ${todo['completed'] ? 'Yes' : 'No'}'),
          ],
        ),
      ),
    );
  }
}

