import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'To-Do List App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<TaskData> tasks = [];

  final TextEditingController titleTextCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: tasks.isNotEmpty
            ? ListView.builder(
                itemBuilder: (context, index) {
                  var item = tasks[index];
                  if (item.title != null && item.title!.isNotEmpty) {
                    return ListTile(
                      title: Text(item.title!),
                      subtitle: Text(item.status),
                      leading: Container(
                          height: 30,
                          width: 30,
                          decoration: const BoxDecoration(
                              color: Colors.green, shape: BoxShape.circle),
                          child: Center(
                            child: Text(
                              "${++index}",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          )),
                      trailing: Checkbox(
                          value: item.status == taskStatus[0] ? false : true,
                          onChanged: (isChecked) {
                            item.status = isChecked ?? false
                                ? taskStatus[1]
                                : taskStatus[0];
                            setState(() {});
                          }),
                    );
                  }
                  return null;
                },
                itemCount: tasks.length,
              )
            : Center(
                child: Text(
                  "Please add a task",
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              showDragHandle: true,
              builder: (context) {
                return Container(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 30,
                    top: 30,
                    left: 30,
                    right: 30,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: titleTextCtrl,
                        decoration: InputDecoration(
                            label: const Text(
                              "Task Title",
                            ),
                            suffixIcon: ElevatedButton(
                              onPressed: () {
                                if (titleTextCtrl.text.isNotEmpty) {
                                  TaskData data = TaskData(
                                      titleTextCtrl.text, taskStatus[0]);
                                  setState(() {
                                    tasks.insert(0, data);
                                  });
                                  titleTextCtrl.clear();
                                  Navigator.pop(context);
                                }
                              },
                              child: const Text("Add"),
                            )),
                      )
                    ],
                  ),
                );
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

const List<String> taskStatus = ["in progress", "completed"];

class TaskData {
  String? title;
  String status = taskStatus[0];

  TaskData(this.title, this.status);
}
