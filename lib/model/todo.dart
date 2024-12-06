import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  String task;
  bool isDone;
  Timestamp createdOn;
  Timestamp updatedOn;

  Todo({
    required this.task,
    required this.isDone,
    required this.createdOn,
    required this.updatedOn,
  });

  //factory method
  Todo.fromJson(Map<String, Object?> json)
      : this(
          task: json['task']! as String,
          isDone: json['isDone']! as bool,
          createdOn: json['createdOn']! as Timestamp,
          updatedOn: json['updatedOn']! as Timestamp,
        );
  //return of copy to todo to us.
  Todo copywith({
    String? task,
    bool? isDone,
    Timestamp? createdOn,
    Timestamp? updatedOn,
  }) {
    // return instance todo
    return Todo(
        task: task ?? this.task,
        isDone: isDone ?? this.isDone,
        createdOn: createdOn ?? this.createdOn,
        updatedOn: updatedOn ?? this.updatedOn);
  }

  //return json object in class
  Map<String, Object?> tojson() {
    return {
      'task': task,
      'isDone': isDone,
      'createdOn': createdOn,
      'updatedOn': updatedOn,
    };
  }
}
