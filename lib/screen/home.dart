import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_with_fb/content/colors.dart';
import 'package:todo_with_fb/model/todo.dart';
import 'package:todo_with_fb/screen/loginScreen.dart';
import 'package:todo_with_fb/service/database_Service.dart';

class HomeScreenView extends StatefulWidget {
  const HomeScreenView({super.key});

  @override
  State<HomeScreenView> createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<HomeScreenView> {
  var isLogoutLoading = false;
  logOut() async {
    setState(() {
      isLogoutLoading = true;
    });
    await FirebaseAuth.instance.signOut();
    //ye login form open ho rah ahi yaha se
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LoginscreenView(),
      ),
    );
    setState(() {
      isLogoutLoading = false;
    });
  }

  final TextEditingController _TodotextEditingController =
      TextEditingController();
  // final instance
  final DatabaseService _databaseService = DatabaseService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      resizeToAvoidBottomInset: false,
      appBar: _appBar(),
      body: _buildUI(),
      floatingActionButton: FloatingActionButton(
        onPressed: _displayTextInputDialog,
        backgroundColor: Color(td_color.btn_botton),
        child: const Icon(
          Icons.add,
          color: Color(0xffffffff),
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: Color(td_color.header),
      actions: [
        IconButton(
          onPressed: () {
            logOut();
          },
          icon: isLogoutLoading
              ? CircularProgressIndicator()
              : Icon(
                  Icons.exit_to_app,
                  color: Color(0xffffffff),
                ),
          tooltip: 'Log out',
        ),
      ],
      title: Text(
        "Dashboard",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: Column(
        children: [
          _messagesListView(),
        ],
      ),
    );
  }

  Widget _messagesListView() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.80,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder(
        stream: _databaseService.getTodos(),
        builder: (context, snapshot) {
          List todos = snapshot.data?.docs ?? [];
          if (todos.isEmpty) {
            return const Center(
              child: Text("Add a todo!"),
            );
          }
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              Todo todo = todos[index].data();
              // Database ID
              String todoid = todos[index].id;

              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(td_color.list_color),
                    borderRadius: BorderRadius.circular(15), // Adjust as needed
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.6),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3), // Changes position of shadow
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(
                      todo.task,
                      style: TextStyle(
                        color: Color(td_color.black_clr),
                      ),
                    ),
                    subtitle: Text(
                      DateFormat("dd-mm-yyyy h:mm a").format(
                        todo.updatedOn.toDate(),
                      ),
                      style: TextStyle(fontSize: 12),
                    ),
                    trailing: Checkbox(
                      value: todo.isDone,
                      onChanged: (value) {
                        Todo updatedTodo = todo.copywith(
                          isDone: !todo.isDone,
                          updatedOn: Timestamp.now(),
                        );
                        _databaseService.updateTodo(todoid, updatedTodo);
                      },
                    ),
                    onLongPress: () {
                      _databaseService.deletedTodo(todoid);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content: Text('Data deleted!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _displayTextInputDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add a todo'),
          content: TextField(
            controller: _TodotextEditingController,
            decoration: const InputDecoration(hintText: 'Todo....'),
          ),
          actions: <Widget>[
            MaterialButton(
              onPressed: () {
                // Check if the text field is empty
                if (_TodotextEditingController.text.trim().isEmpty) {
                  // Show SnackBar with a message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a todo before adding.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  return; // Stop further execution
                }

                // Proceed to add the todo
                Todo todo = Todo(
                  task: _TodotextEditingController.text.trim(),
                  isDone: false,
                  createdOn: Timestamp.now(),
                  updatedOn: Timestamp.now(),
                );
                _databaseService.addTodo(todo);

                // Close the dialog and clear the text field
                Navigator.pop(context);
                _TodotextEditingController.clear();
              },
              color: Color(td_color.btn_botton),
              textColor: Color(0xffffffff),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
