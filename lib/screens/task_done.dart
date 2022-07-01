import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_test/controller/controllerlib.dart';
import 'package:intl/intl.dart';

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:localstore/localstore.dart';

import 'package:getx_test/screens/screens.dart';

import 'package:getx_test/models/task_model.dart';


class TaskDone extends StatelessWidget {
  const TaskDone({Key? key}) : super(key: key);

  static final TaskGetx _getx = Get.find();



  FutureOr onGoBack(BuildContext context ) {
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (BuildContext context) {
        return const Homepage(index: 1);
      })
    );
  }

  @override
  Widget build(BuildContext context) {
    return 
      Scaffold(
        body: SizedBox(
        width: double.infinity,
        child: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Obx(() => buildDatetime(),),
            const SizedBox(
              height: 20,
            ),
            buildTaskDone(),
            const SizedBox(
              height: 20,
            ),
            Obx(() => buildListView(context),),
          ],
        )),
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

  Widget buildTaskDone() {
    return Row(
      children: const <Widget>[
        Flexible(
            child: Divider(
          color: Colors.black45,
        )),
        SizedBox(
          width: 30,
        ),
        Text(
          'Task',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        Text('Done',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            )),
        SizedBox(
          width: 30,
        ),
        Flexible(
            child: Divider(
          color: Colors.black45,
        )),
      ],
    );
  }

  Widget buildListView(BuildContext context) {
    return Expanded(
      child: Container(
        height: 200,
        margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: ListView.separated(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          separatorBuilder: (context, index) => const SizedBox(width: 20),
          itemBuilder: (BuildContext context, index) {
            final item = _getx.list.elementAt(index);
            if (item.status == false) {
              return const SizedBox.shrink();
            }
            return InkWell(
              onTap: () {
                _getx.currentIndex.value= index;
                Route route = MaterialPageRoute(builder: (context) => ItemDetail());
                Navigator.push(context, route);
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
                      taskName(item),
                      const Divider(
                        indent: 50,
                        thickness: 3,
                        color: Colors.white,
                      ),
                      itemList(item),
                    ],
                  ),
                )
              )
            );
          },
          itemCount: _getx.list.length,
          
        ),
      ),
    );
  }

  Widget taskName(Tasks item){
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 20, horizontal: 0),
      child: Text(item.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          )
        )
      );
  }

  Widget itemList(Tasks item){
    return SizedBox(
      child: Column(
        children: item.items.map((tsk) {
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
                        : null
                    )
                ),
            ],
          );
        }).toList(),
      )
    );
  }

}
