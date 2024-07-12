import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../model/task.dart';
import 'package:intl/intl.dart';

class TaskCreationScreen extends StatefulWidget {
  final Task? task;

  TaskCreationScreen({this.task});

  @override
  _TaskCreationScreenState createState() => _TaskCreationScreenState();
}

class _TaskCreationScreenState extends State<TaskCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late DateTime _dueDate;
  late bool _isCompleted;

  @override
  void initState() {
    super.initState();
    _title = widget.task?.title ?? '';
    _description = widget.task?.description ?? '';
    _dueDate = widget.task?.dueDate ?? DateTime.now();
    _isCompleted = widget.task?.isCompleted ?? false;
  }

  _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _dueDate)
      setState(() {
        _dueDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Create Task' : 'Edit Task', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500)),
        backgroundColor: Color(0xFF3C0A44),
        iconTheme: IconThemeData(
          color: Colors.white, // Change this to your desired color
        ),
      ),

      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) {
                  _description = value!;
                },
              ),
              Row(
                children: <Widget>[
                  Text(DateFormat('yyyy-MM-dd').format(_dueDate)),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDueDate(context),
                  ),
                ],
              ),
              ElevatedButton(

                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final taskBox = Hive.box<Task>('tasks');
                    if (widget.task == null) {
                      taskBox.add(
                        Task(
                          title: _title,
                          description: _description,
                          dueDate: _dueDate,
                          isCompleted: _isCompleted,
                        ),
                      );
                    } else {
                      widget.task!.title = _title;
                      widget.task!.description = _description;
                      widget.task!.dueDate = _dueDate;
                      widget.task!.isCompleted = _isCompleted;
                      widget.task!.save();
                    }
                    Navigator.pop(context);
                  }
                },
                child: Text(widget.task == null ? 'Add Task' : 'Save Changes'),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF3C0A44), // Button background color
                  onPrimary: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
