import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'task_creation_screen.dart';
import '../model/task.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List',style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500) ),
        backgroundColor: Color(0xFF3C0A44),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.white,),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskCreationScreen(),
              ),
            ),
          ),
        ],
      ),

      body: ValueListenableBuilder(
        valueListenable: Hive.box<Task>('tasks').listenable(),
        builder: (context, Box<Task> box, _) {
          if (box.values.isEmpty) {
            return Center(
              child: Text('No tasks yet.', style: TextStyle(color: Color(0xFF3C0A44), fontSize: 20, fontWeight: FontWeight.w500),),
            );
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final task = box.getAt(index);

              return Dismissible(
                key: Key(task!.key.toString()),
                background: Container(color: Colors.red),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  task.delete();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Task deleted")),
                  );
                },
                child: ListTile(
                  title: Text(task.title),
                  subtitle: Text(task.description),
                  trailing: Checkbox(
                    value: task.isCompleted,
                    onChanged: (bool? value) {
                      task.isCompleted = value!;
                      task.save();
                    },
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskCreationScreen(task: task),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
