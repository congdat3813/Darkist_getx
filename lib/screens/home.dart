import 'package:flutter/material.dart';
import 'package:getx_test/controller/controllerlib.dart';
import 'package:get/get.dart';
import 'package:getx_test/screens/screens.dart';


class Homepage extends StatefulWidget {
  const Homepage({Key? key, required this.index}) : super(key: key);
  final int index;

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;
  static final TaskGetx _getx = Get.put(TaskGetx());

  @override
  void initState() {
    _getx.getData();
    super.initState();
  }
  
  static final List<Widget> _widgetOptions = <Widget>[
    TaskList(),
    TaskDone(),
    TaskSetting(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.add_task_rounded),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task_alt),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '',
          ),
        ],
        selectedItemColor: Colors.purple[400],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
