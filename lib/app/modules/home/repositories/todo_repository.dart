// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:todo_list_firebase_mobx_modular/app/modules/home/models/todo_model.dart';
import 'package:todo_list_firebase_mobx_modular/app/modules/home/repositories/todo_repository_interface.dart';

class TodoRepository implements ITodoRepository {
  FirebaseFirestore firestore;
  TodoRepository({
    required this.firestore,
  });

  @override
  Stream<List<TodoModel>> getTodos() {
    return firestore.collection('todo').snapshots().map((query) {
      return query.docs.map((doc) {
        return TodoModel.fromDocument(doc);
      }).toList();
    });
  }
}
