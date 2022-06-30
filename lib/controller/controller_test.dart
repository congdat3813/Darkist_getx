import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_test/models/task_model.dart';
import 'package:localstore/localstore.dart';

import 'package:flutter/foundation.dart';

class TaskGetx extends GetxController{
  static const tag = 'TaskGetx';
  final _db = Localstore.instance;
  final list = <Rx<Tasks>>[].obs;
  Rx<DateTime> time= DateTime.now().obs;
  Rx<Color> pickerColor = const Color(0xff6633ff).obs;
  Rx<Color> currentColor = const Color(0xff6633ff).obs;
  Rx<int> currentIndex = 0.obs;
  Rx<bool> changed= false.obs;

  void getData(){
    print('get data');
    _db.collection('TaskLists').get().then((value) {
      for (var key in value!.keys) {
        // list.map((element) {
        //   print('get');
        //   if (element.name != key) {
        //     print('get sucess');
            list.add(Tasks.fromMap(value[key]).obs);
        //   }
        // });
      }
    });
  }


  void addTask(String name, List<dynamic> items,bool status){
    final task = Tasks(name: name,items: items, status: status, curcolor: currentColor.value.value);
    list.add(task.obs);
    task.save();
  }


  void removeTask(){
    final task = list[currentIndex.value];
    list.removeAt(currentIndex.value);
  }
  
  void addItem(Map<String, bool> item){
    final task=list[currentIndex.value];
    task.value.items.add(item);
    task.value.curcolor= currentColor.value.value;
    task.value.status=false;
    task.value.setTask();
  }


  void updateTask(int index, bool status){
    final tasks=list[currentIndex.value];

    String taskname = tasks.value.items[index].keys.toList().first;
    tasks.value.items[index][taskname] = status;

    bool stt = true;

    if (tasks.value.items.isEmpty) {
      stt = false;
    } else     
    {  
      for (var item in tasks.value.items) {
        if (item.values.toList().first == false) {
          stt = false;
          break;
        }
      }
    }

    tasks.value.status=stt;
    tasks.value.curcolor=currentColor.value.value;
    tasks.value.setTask();
  }

  void updateColor(){
    final tasks=list[currentIndex.value];
    print(currentIndex.value);

    bool stt = true;
    if (tasks.value.items.isEmpty) {
      stt = false;
    } else     
    {  
      for (var item in tasks.value.items) {
        if (item.values.toList().first == false) {
          stt = false;
          break;
        }
      }
    }

    tasks.value.status=stt;
    tasks.value.curcolor =currentColor.value.value;

    tasks.value.setTask();
    // print('task stt ${tasks.status}');

  }
}