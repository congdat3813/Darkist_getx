import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_test/controller/controller.dart';

import 'package:getx_test/theme.dart';

import 'package:getx_test/screens/screens.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Taskist());
}


class Taskist extends StatelessWidget {
  Taskist({Key? key}) : super(key: key);
  ThemeData theme = TaskistTheme.dark();
  static ThemeGetx themeObx= Get.put(ThemeGetx());
  @override
  Widget build(BuildContext context) {
    return Obx( () =>
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: themeObx.theme.value,
        title: 'Darkist',
        home: const Homepage(index: 0,),
      ),
    );
  }
}