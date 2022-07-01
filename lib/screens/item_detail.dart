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

  final Tasks curtask=_getx.list[_getx.currentIndex.value];

  final myController = TextEditingController();

  void changeColor(Color color) {
     _getx.pickerColor.value = color;
  }

  void onGoBack(BuildContext context){
    _getx.updateColor();
    _getx.getData();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    _getx.pickerColor.value= Color(curtask.curcolor);
    _getx.currentColor.value= Color(curtask.curcolor);
    _getx.count();   
    _getx.set_itemstt();
    return
      Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: Obx(() => colorButton(context),),
          actions: [
            cancelButton(context),          
          ],
        ),
        body: bodyView(context),
        floatingActionButton: Obx( () =>
          FloatingActionButton(
            onPressed: () => showDialog(
              context: context,
              builder: (BuildContext context) => addItem(context),
            ),
            child: const Icon(Icons.add),
            backgroundColor: _getx.currentColor.value,
          ),
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
                    _getx.saveColor();
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
          onPressed: () => onGoBack(context),
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
                Obx(() => Text('${_getx.countdone.value} of ${curtask.items.length} tasks', style: const TextStyle(fontSize: 20,color: Colors.grey),))
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
        Text(curtask.name, style: const TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.w600
        )),
        Obx(()=>deleteButton(context),),
      ]
    );
  }

  Widget deleteButton(BuildContext context){
    return IconButton(
      onPressed: () => showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Delete: ${curtask.name}'),
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
            color: _getx.currentColor.value,
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
      child:
        ListView.builder(
          itemCount: curtask.items.length,
          itemBuilder: (BuildContext context, index) {
            return builderItemlist(index);
          }, 
        ),
    );
  }

  Widget builderItemlist(int index){
    Color getColor(Set<MaterialState> states) {
      return _getx.currentColor.value;
    }
    
    return Obx( () =>
      Dismissible(
      background: Container(
        color: _getx.currentColor.value,
      ),
        key: ValueKey<dynamic>(curtask.items[index].keys),
        onDismissed: (DismissDirection direction) {
            _getx.removeItem(index);
        },
        child:
          Row(
            children: <Widget> [
                Checkbox(
                  checkColor: Colors.white,
                  fillColor: MaterialStateProperty.resolveWith(getColor),
                  value: _getx.item_stt[index], 
                  onChanged: (bool? value) {
                      _getx.updateTask(index, !_getx.item_stt[index]);
                  }
                ),
              Text(
                curtask.items[index].keys.toList().first,
                style: TextStyle(
                  fontSize: 20,
                  color: curtask.items[index].values.toList().first ? _getx.currentColor.value : Colors.black,
                  decoration: curtask.items[index].values.toList().first ? TextDecoration.lineThrough: null
                )
              ),
            ],
          ),
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
            myController.clear();
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
  
}