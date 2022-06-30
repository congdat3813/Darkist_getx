import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';


import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:getx_test/controller/controllerlib.dart';
import 'package:localstore/localstore.dart';

import 'package:getx_test/models/task_model.dart';


class ItemDetail extends StatelessWidget {
  
  ItemDetail({Key? key}) : super(key: key);


  static final TaskGetx _getx =Get.find();

  @override


  final Tasks item=_getx.list[_getx.currentIndex.value];
  bool isChecked = false;

  final myController = TextEditingController();

  // @override
  // void initState() {

  //   _subscription = _db.collection('TaskLists').stream.listen((event) {
  //     setState(() {
  //       final item = Tasks.fromMap(event);
  //       _items.putIfAbsent(item.name, () => item);
  //       if (item.items.isEmpty) {
  //         count=0;
  //         progress = 0;
  //       }
  //       else {
  //         int countDone = 0;
  //         for (var ele in item.items){
  //           if (ele.values.toList().first) countDone++;
  //         }
  //         count= countDone;
  //         progress = countDone / item.items.length;
  //       }

  //     });
  //   });
  //   super.initState();
  // }
  
  @override
  Widget build(BuildContext context) {
    _getx.pickerColor.value= Color(item.curcolor);
    _getx.currentColor.value= Color(item.curcolor);
    _getx.count();   
    _getx.set_itemstt();
    return
      Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: colorButton(context),
          actions: [
            cancelButton(context),          
          ],
        ),
        backgroundColor: Colors.white,
        body: bodyView(context),
        floatingActionButton: FloatingActionButton(
          onPressed: () => showDialog(
            context: context,
            builder: (BuildContext context) => addItem(context),
          ),
          child: const Icon(Icons.add),
          backgroundColor: _getx.currentColor.value,
        ),
      );
  }
  
  Widget colorButton(BuildContext context){
    return IconButton(
          color: _getx.currentColor.value,
          onPressed: () => showDialog(
            context: context, 
            builder: (BuildContext context)=> AlertDialog(
              title: const Text('Pick a color'),
              content: SingleChildScrollView(
                child: ColorPicker(
                  pickerColor: _getx.pickerColor.value,
                  onColorChanged: changeColor,
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  child: const Text('Got it'),
                  onPressed: () {
                    _getx.currentColor.value = _getx.pickerColor.value;
                    Navigator.pop(context);
                  },
                ),
              ],
            )
          ),
          icon: Icon(Icons.circle, color: _getx.currentColor.value, size:35)
        );
  }

  Widget cancelButton(BuildContext context){
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
      child: Obx(()=>
        IconButton(
          onPressed: () {
            _getx.updateColor();
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.cancel_outlined, 
            color: _getx.currentColor.value,
            size: 35
          )
        ),
      )
    );
  }

  Widget bodyView(BuildContext context){
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(40, 10, 10, 10),
        child: Column(
          children:<Widget> [
            taskName(context),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Obx(() => Text('${_getx.countdone.value} of ${item.items.length} tasks', style: const TextStyle(fontSize: 20,color: Colors.grey),))
              ]
            ),
            Obx(() => processBar(),),
            itemList(context),
          ]
        )
      ),
    );
  }

  Widget taskName(BuildContext context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(item.name, style: const TextStyle(
          fontSize: 40,
          color: Colors.black,
          fontWeight: FontWeight.w600
        )),
        deleteButton(context),
      ]
    );
  }

  Widget deleteButton(BuildContext context){
    return IconButton(
      onPressed: () => showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Delete: ${item.name}'),
          content: const Text('Are you sure want to delete this list'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              }, 
              child: const Text('No'),
              style: ElevatedButton.styleFrom(
                primary: _getx.currentColor.value
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _getx.removeTask();
                var nav = Navigator.of(context);
                nav.pop();
                nav.pop(true);
              }, 
              child: const Text('Yes'),
              style: ElevatedButton.styleFrom(
                primary: _getx.currentColor.value
              ),
            )
          ],
        )
      ),
      icon:  Icon(
        Icons.delete,
        color: _getx.currentColor.value,
        size: 40,
      )
    );
  }

  Widget processBar(){
    return Row(
      children: [
        Expanded(
          flex: 11,
          child: LinearProgressIndicator(
            value: _getx.progress.value,
            minHeight: 6,
            backgroundColor: const Color(0xFFecf0f1),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            alignment: Alignment.topRight,
            child: Text(
              '${(_getx.progress.value * 100).round()} %',
              style: const TextStyle(
                fontSize: 14,
              )
            )
          ),
        )
      ]
    );
  }

  Widget itemList(BuildContext context){
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 200,
      alignment: Alignment.topLeft,
      child: ListView.builder(
        itemCount: item.items.length,
        itemBuilder: (BuildContext context, index) {
          Color getColor(Set<MaterialState> states) {
            return _getx.currentColor.value;
          }
          
          return Dismissible(
          background: Container(
            color: Colors.red,
          ),
            key: ValueKey<dynamic>(item.items[index].keys),
            onDismissed: (DismissDirection direction) {
                // item.removeItems(index);
            },
            child: Obx( () =>
              Row(
                children: <Widget> [
                    Checkbox(
                      checkColor: Colors.white,
                      fillColor: MaterialStateProperty.resolveWith(getColor),
                      value: _getx.item_stt[index], 
                      onChanged: (bool? value) {
                          _getx.updateTask(index, !_getx.item_stt[index]);
                          print(value);
                          print(_getx.item_stt.value);
                      }
                    ),
                  Text(
                    _getx.list[_getx.currentIndex.value].items[index].keys.toList().first,
                    style: TextStyle(
                      fontSize: 20,
                      color: item.items[index].values.toList().first ? _getx.currentColor.value : Colors.black,
                      decoration: item.items[index].values.toList().first ? TextDecoration.lineThrough: null
                    )
                  ),
                ],
              ),
            ),
          );
        }, 
      ),
    );
  }

  Widget addItem(BuildContext context){
    return AlertDialog(
      content: TextField(
        controller: myController,
        autofocus: true,
        decoration: const InputDecoration(
          labelText: 'Item',
        ),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Color.fromARGB(255, 114, 130, 131)
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            _getx.addItem({myController.text: false});
            Navigator.pop(context);
          }, 
          child: const Text('Add'),
          style: ElevatedButton.styleFrom(
            primary: _getx.currentColor.value,
          ),
        ),
      ],
    );
  }
  
  void changeColor(Color color) {
     _getx.pickerColor.value = color;
  }
  
}