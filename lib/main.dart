import 'package:flutter/material.dart';

import 'package:getx_test/theme.dart';

import 'package:getx_test/screens/screens.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Taskist());
}

// class Taskist extends StatefulWidget {
//   const Taskist({Key? key}) : super(key: key);

//   @override
//   State<Taskist> createState() => _TaskistState();
// }

// class _TaskistState extends State<Taskist> {
  
//   }
// }

class Taskist extends StatelessWidget {
  Taskist({Key? key}) : super(key: key);
  ThemeData theme = TaskistTheme.light();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      title: 'Darkist',
      home: const Homepage(index: 0,),
    );
  }
}