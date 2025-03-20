import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FormPage(),
    );
  }
}

class FormPage extends StatefulWidget {
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  DateTime? _selectedDateTime;
  List<TaskTileData> tasks = [];

  void _pickDateTime(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );  
      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, pickedTime.hour, pickedTime.minute);
        });
      }
    }
  }

  void _addTask() {
    if (_formKey.currentState!.validate() && _selectedDateTime != null) {
      setState(() {
        tasks.add(TaskTileData(
          task: _nameController.text,
          deadline: "${_selectedDateTime!.toLocal()}".split('.')[0],
          isDone: false,
        ));
      });
      _nameController.clear();
      _selectedDateTime = null;
    }
  }

  void _toggleTaskDone(int index, bool? value) {
    setState(() {
      tasks[index] = TaskTileData(
        task: tasks[index].task,
        deadline: tasks[index].deadline,
        isDone: value ?? false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Form Page")),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Task Date & Time:", style: TextStyle(fontSize: 16)),
                      Row(
                        children: [
                          Text(_selectedDateTime == null
                              ? "Select date & time"
                              : "${_selectedDateTime!.toLocal()}".split('.')[0]),
                          IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () => _pickDateTime(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (_selectedDateTime == null)
                    Text("Please select a date and time", style: TextStyle(color: Colors.red)),
                  SizedBox(height: 10),
                  Text("First Name", style: TextStyle(fontSize: 16, color: Colors.red)),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            hintText: "Enter your first name",
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter some text";
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: _addTask,
                        child: Text("Submit"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text("List Tasks", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return TaskTile(
                    task: tasks[index].task,
                    deadline: tasks[index].deadline,
                    isDone: tasks[index].isDone,
                    onChanged: (value) => _toggleTaskDone(index, value),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskTileData {
  final String task;
  final String deadline;
  final bool isDone;

  TaskTileData({required this.task, required this.deadline, required this.isDone});
}

class TaskTile extends StatelessWidget {
  final String task;
  final String deadline;
  final bool isDone;
  final ValueChanged<bool?>? onChanged;

  TaskTile({required this.task, required this.deadline, required this.isDone, required this.onChanged});

  