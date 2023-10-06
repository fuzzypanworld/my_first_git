import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class Todo {
  final int id;
  final int userId;
  final String title;
  final bool completed;

  Todo({
    required this.id,
    required this.userId,
    required this.title,
    required this.completed,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      completed: json['completed'],
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HTTP REQUEST',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Todo> todos = [];
  int currentPage = 1;
  int pageSize = 10; // Number of todos to load per page

  @override
  void initState() {
    super.initState();
    fetchTodos(currentPage);
  }

  Future<void> fetchTodos(int page) async {
    var url = Uri.http("jsonplaceholder.typicode.com", "/todos", {
      "_page": page.toString(),
      "_limit": pageSize.toString(),
    });
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var responseList = jsonDecode(response.body) as List<dynamic>;
      setState(() {
        todos.addAll(
          responseList.map((json) => Todo.fromJson(json)).toList(),
        );
      });
    } else {
      setState(() {
        todos = [];
      });
    }
  }

  void loadMore() {
    currentPage++;
    fetchTodos(currentPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HTTP Request Example'),
      ),
      body: ListView.builder(
        itemCount: todos.length + 1, // +1 for the "Read More" button
        itemBuilder: (context, index) {
          if (index == todos.length) {
            // Display "Read More" button at the end
            return Center(
              child: ElevatedButton(
                onPressed: loadMore,
                child: const Text('Read More'),
              ),
            );
          } else {
            final todo = todos[index];
            return ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TodoDetailsPage(todo: todo),
                  ),
                );
              },
              title: Text('Todo ${todo.id}', style: const TextStyle(color: Colors.black)),
            );
          }
        },
      ),
    );
  }
}

class TodoDetailsPage extends StatelessWidget {
  final Todo todo;

  TodoDetailsPage({required this.todo});

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
              'Title: ${todo.title}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('ID: ${todo.id}'),
            Text('User ID: ${todo.userId}'),
            Text('Completed: ${todo.completed ? 'Yes' : 'No'}'),
          ],
        ),
      ),
    );
  }
}
