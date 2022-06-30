import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:localstore/localstore.dart';



class Tasks {
  String name;
  List<dynamic> items;
  int curcolor;
  bool status;

  Tasks(
      {
        required this.name,
        required this.items,
        required this.status,
        required this.curcolor
      });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'items': items,
      'status': status,
      'curcolor': curcolor
    };
  }

  factory Tasks.fromMap(Map<String, dynamic> map) {
    return Tasks(
        name: map['name'],
        items: map['items'],
        status: map['status'],
        curcolor: map['curcolor']
      );
  }
}

extension ExtTasks on Tasks  {
  static final _db= Localstore.instance;
  Future save() async {
    return _db.collection('TaskLists').doc(name).set(toMap());
  }

  Future delete() async {
    return _db.collection('TaskLists').doc(name).delete();
  }

  Future setTask() async {
    final item =
        Tasks(
          name: name, 
          items: items, 
          status: status,
          curcolor: curcolor
        );
    return _db.collection('TaskLists').doc(name).set(item.toMap());
  }

  Future removeItems(int index) async{
    items.remove(items[index]);

    bool stt = true;
    
    if (items.isEmpty) {
      stt = false;
    } else     
    {  
      for (var task in items) {
        if (task.values.toList().first == false) {
          stt = false;
          break;
        }
      }
    }
    final item =
    Tasks(
      name: name, 
      items: items, 
      status: stt, 
      curcolor: curcolor
      );
    return _db.collection('TaskLists').doc(name).set(item.toMap());
  }

}
