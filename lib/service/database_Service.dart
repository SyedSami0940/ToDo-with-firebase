// The ref is firebace cloud fireStore name that u created
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_with_fb/model/todo.dart';

const String TODO_COLLECTION_REF = "todos";

class DatabaseService {
  final _firestore = FirebaseFirestore.instance;

  late final CollectionReference _todosref;

  DatabaseService() {
    _todosref = _firestore.collection(TODO_COLLECTION_REF).withConverter<Todo>(
        fromFirestore: (snapshots, _) => Todo.fromJson(
              snapshots.data()!,
            ),
        toFirestore: (todo, _) => todo.tojson());
  }
  // function allow to get todo database
  Stream<QuerySnapshot> getTodos() {
    return _todosref.snapshots();
  }

  void addTodo(Todo todo) async {
    _todosref.add(todo);
  }

  void updateTodo(String todoid, Todo todo) {
    _todosref.doc(todoid).update(todo.tojson());
  }

  void deletedTodo(String todoid) {
    _todosref.doc(todoid).delete();
  }
}
