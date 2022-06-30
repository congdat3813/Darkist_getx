import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'dart:async';

import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:getx_test/controller/controllerlib.dart';
import 'package:localstore/localstore.dart';
import 'package:getx_test/models/task_model.dart';

class AddList extends StatelessWidget {
  AddList({Key? key}) : super(key: key);


  static final TaskGetx _getx =Get.find();
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Obx(() => 
      Scaffold(
        body: SafeArea(
            child: Stack(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(left: 10.0, top: 10.0),
              child: const BackButton(color: Colors.black),
            ),
            Container(
              child: Column(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          color: Colors.grey,
                          height: 1.5,
                        ),
                      ),
                      Expanded(
                          flex: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const <Widget>[
                              Text(
                                'New',
                                style: TextStyle(
                                    fontSize: 30.0, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'List',
                                style:
                                    TextStyle(fontSize: 28.0, color: Colors.grey),
                              )
                            ],
                          )),
                      Expanded(
                        flex: 1,
                        child: Container(
                          color: Colors.grey,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Add the name of your list',
                        style: TextStyle(fontSize: 20, color: Colors.grey),
                      ),
                      TextField(
                        controller: myController,
                        decoration: const InputDecoration(
                          hintText: 'Your List...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(fontSize: 35, color: Colors.grey),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                      ),
                      Row(children: <Widget>[
                        MaterialButton(
                          color: _getx.currentColor.value,
                          shape: const CircleBorder(),
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
                          child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: SizedBox.shrink(),
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
              ]),
            )
          ],
        )),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            _getx.addTask(myController.text, [], false);
            Navigator.pop(context);
          },
          label: const Text('Create Task'),
          icon: const Icon(Icons.add),
          backgroundColor: _getx.currentColor.value,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      )
    );
  }

  changeColor(Color color) {
    _getx.pickerColor.value = color;
  }


}
