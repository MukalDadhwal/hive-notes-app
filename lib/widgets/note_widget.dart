import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NoteWidget extends StatelessWidget {
  final String noteText;
  final int noteKey;
  final Box box;

  NoteWidget(this.noteText, this.noteKey, this.box);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        leading: Icon(Icons.note),
        trailing: IconButton(
          onPressed: () async {
            await box.delete(noteKey);
          },
          icon: Icon(
            Icons.delete,
            color: Colors.red,
          ),
        ),
        title: Text(
          noteText,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
