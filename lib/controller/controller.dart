import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_test/models/task_model.dart';
import 'package:localstore/localstore.dart';

import 'package:flutter/foundation.dart';

class TaskGetx extends GetxController{
  static const tag = 'TaskGetx';
  final _db = Localstore.instance;
  final list = <Tasks>[].obs;

  RxList<String> tasklist_name= <String>[].obs;
  RxList<String> taskdone_name= <String>[].obs;
  RxList<dynamic> itemList= [].obs;
  RxList<dynamic> itemdone=[].obs;
  
  Rx<DateTime> time= DateTime.now().obs;
  Rx<Color> pickerColor = const Color(0xff6633ff).obs;
  Rx<Color> currentColor = const Color(0xff6633ff).obs;
  Rx<int> currentIndex = 0.obs;
  RxList<bool> item_stt= <bool>[].obs;
  RxList<bool> task_stt= <bool>[].obs;
  RxInt countdone =0.obs;
  RxDouble progress = 0.0.obs;

  void getData(){
    print('get data');
    _db.collection('TaskLists').get().then((value) {
      for (var key in value!.keys) {
        // list.map((element) {
        //   print('get');
        //   if (element.name != key) {
        //     print('get sucess');
            list.add(Tasks.fromMap(value[key]));
        //   }
        // });
      }
    });
  }


  void addTask(String name, List<dynamic> items,bool status){
    final task = Tasks(name: name,items: items, status: status, curcolor: currentColor.value.value);
    list.add(task);
    task.save();
  }


  void removeTask(){
    final task = list[currentIndex.value];
    list.removeAt(currentIndex.value);
    task.delete();
  }
  
  void addItem(Map<String, bool> item){
    final task=list[currentIndex.value];
    task.items.add(item);
    task.curcolor= currentColor.value.value;
    task.status=false;
    count();
    task.setTask();
  }


  void updateTask(int index, bool status){
    item_stt[index]=status;
    final tasks=list[currentIndex.value];
    tasks.items[index].values.toList().first= status;
    String taskname = tasks.items[index].keys.toList().first;
    tasks.items[index][taskname] = status;

    bool stt = true;

    if (tasks.items.isEmpty) {
      stt = false;
    } else     
    {  
      for (var item in tasks.items) {
        if (item.values.toList().first == false) {
          stt = false;
          break;
        }
      }
    }

    tasks.status=stt;
    tasks.curcolor=currentColor.value.value;
    count();
    tasks.setTask();
  }

  void updateColor(){
    final tasks=list[currentIndex.value];
    print(currentIndex.value);

    bool stt = true;
    if (tasks.items.isEmpty) {
      stt = false;
    } else     
    {  
      for (var item in tasks.items) {
        if (item.values.toList().first == false) {
          stt = false;
          break;
        }
      }
    }

    tasks.status=stt;
    task_stt[currentIndex.value]=stt;
    tasks.curcolor =currentColor.value.value;
    tasks.setTask();
  }

  void count(){
    final task = list[currentIndex.value];
    countdone.value=0;
    for (var ele in task.items){
      if (ele.values.toList().first) countdone.value++;
    }
    progress.value = (task.items.isEmpty)? 0.0 : countdone/task.items.length;
  }

  void set_itemstt(){
    final task = list[currentIndex.value];
    for (var item in task.items){
      item_stt.value.add(item.values.toList().first);
    }
  }

  void set_taskstt(){
    for (var task in list){
      task_stt.value.add(task.status);
    }
  }
}