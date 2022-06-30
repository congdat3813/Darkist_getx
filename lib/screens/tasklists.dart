import 'package:flutter/material.dart';
import 'package:getx_test/screens/item_detail.dart';
import 'package:intl/intl.dart';

import 'dart:async';

import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:localstore/localstore.dart';
import 'package:getx_test/models/task_model.dart';

import 'package:getx_test/theme.dart';
import 'package:getx_test/screens/screens.dart';

import 'package:getx_test/controller/controllerlib.dart';

class TaskList extends StatelessWidget {

  TaskList({Key? key}) : super(key: key);
  static late TaskGetx _getx;

  @override
  Widget build(BuildContext context) {
    _getx=Get.find();
    _getx.set_taskstt();
    return Scaffold(
      body: SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Obx(()=>buildDatetime(),),
            const SizedBox(height: 20),
            buildVerticalLine(),
            const SizedBox(height: 20),
            buildAddButton(context),
            const SizedBox(height: 20),
            Obx(() => buildListView(context),),
          ],
        ),
      ),
    ));
  }

  Widget buildDatetime() {
    DateTime time= _getx.time.value;
    String dateInWeek = DateFormat('EEEEEE').format(time);
    String date = DateFormat('d MMM').format(time);
    return Container(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: Column(
        children: [
          Text(
            dateInWeek,
          ),
          Text(date)
        ],
      ),
    );
  }

  Widget buildVerticalLine() {
    return Row(
      children: const <Widget>[
        Flexible(
            child: Divider(
          color: Colors.black45,
        )),
        SizedBox(width: 30),
        Text(
          'Task',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        Text(
          'List',
          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 30),
        ),
        SizedBox(width: 30),
        Flexible(
            child: Divider(
          color: Colors.black45,
        ))
      ],
    );
  }

  Widget buildAddButton(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10)),
              child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddList()),
                    );
                  },
                  icon: const Icon(Icons.add))),
          const SizedBox(height: 10),
          const Text('Add List')
        ],
      ),
    );
  }

  Widget buildListView(BuildContext context) {
    // print('length: ${_getx.list.length}');
    return
      Expanded(
        child: Container(
          height: 200,
          margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) => const SizedBox(width: 20),
            itemCount: _getx.list.length,
            itemBuilder: (BuildContext context, index) {
              final item = _getx.list[index];
              print('item: ${item.items}');
              if (!_getx.task_stt.isEmpty && _getx.task_stt[index] == true) {
                return const SizedBox.shrink();
              }
              else{
                return InkWell(
                  onTap: () {
                    _getx.currentIndex.value= index;
                    Route route = MaterialPageRoute(builder: (context) => ItemDetail());
                    Navigator.push(context,route);
                  },
                  child: Container(
                      width: 220,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Color(item.curcolor),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 0),
                              child: Text(item.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                )
                              )
                            ),
                            const Divider(
                              indent: 50,
                              thickness: 3,
                              color: Colors.white,
                            ),
                            SizedBox(
                              // width: 180,
                              // height: 150,
                              child: 
                                Column(
                                  children: _getx.list[index].items.map((tsk) {
                                    return Row(
                                      children: <Widget>[
                                        Checkbox(
                                            checkColor: Colors.white,
                                            shape: const CircleBorder(),
                                            activeColor: Color(item.curcolor),
                                            value: tsk.values.toList().first,
                                            onChanged: (bool? value) {}),
                                        Text(tsk.keys.toList().first,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal,
                                                color: tsk.values.toList().first
                                                    ? const Color(0xFFf7f1e3)
                                                    : Colors.white,
                                                decoration: tsk.values.toList().first
                                                    ? TextDecoration.lineThrough
                                                    : null)),
                                      ],
                                    );
                                  }).toList(),
                                ),
                            )
                          ],
                        ),
                      )
                    )
                );        
              }
            },
            
          ),
        ),
      );
  }
  
}
