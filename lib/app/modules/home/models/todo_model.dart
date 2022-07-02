import 'package:cloud_firestore/cloud_firestore.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class TodoModel {
  String title;
  bool check;
  DocumentReference? reference;

  TodoModel({
    this.title = '',
    this.check = false,
    this.reference,
  });

  factory TodoModel.fromDocument(DocumentSnapshot snapshot) {
    return TodoModel(
      title: snapshot['title'] as String,
      check: snapshot['check'] as bool,
      reference: snapshot.reference,
    );
  }

  Future<void> save() async {
    if (reference == null) {
      if (title.isNotEmpty) {
        reference = await FirebaseFirestore.instance
            .collection('todo')
            .add({'title': title, 'check': check});
      }
    } else {
      reference?.update({'title': title, 'check': check});
    }
  }

  delete() {
    reference!.delete();
  }
}
