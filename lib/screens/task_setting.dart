import 'package:flutter/material.dart';
import 'package:getx_test/controller/controllerlib.dart';
import 'package:getx_test/theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class TaskSetting extends StatelessWidget {
  const TaskSetting({ Key? key }) : super(key: key);

  static final ThemeGetx themex = Get.find();
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      
      child: Scaffold(
        body: Column(
          children: <Widget>[
            const SizedBox(height: 40),
            buildVerticalLine(),
            const SizedBox(height: 40),
            Card(
              child: Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                padding: const EdgeInsets.all(15),
                width: MediaQuery.of(context).size.width * 0.95,
                height: 320,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget> [
                    ListTile(
                    leading: const Icon(Icons.dark_mode),
                    title: const Text('Dark mode',
                            style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.normal)),
                    trailing: Obx(() => Switch(
                        onChanged: (value) {
                          themex.changeTheme();
                          },
                        value: (themex.theme.value == TaskistTheme.dark()),
                      )
                    ),
                    onTap: () {},
                  ),
            buildItem(context, const FaIcon(FontAwesomeIcons.gears), 'Version',
                const Text('1.1.0')),
            buildItem(
                context,
                const FaIcon(FontAwesomeIcons.twitter, color: Color(0xFF74b9ff)),
                'Twitter',
                const FaIcon(FontAwesomeIcons.angleRight)),
            buildItem(
                context,
                const FaIcon(FontAwesomeIcons.star, color: Color(0xFF74b9ff)),
                'Rate Takist',
                const FaIcon(FontAwesomeIcons.angleRight)),
            buildItem(
                context,
                const FaIcon(FontAwesomeIcons.share, color: Color(0xFF74b9ff)),
                'Share Taskist',
                const FaIcon(FontAwesomeIcons.angleRight))                    
                  ],
                )
              ),
            ),
          ],
        )
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

  Widget buildItem(BuildContext context, FaIcon leading, String title, Widget trailing) {
    return ListTile(
      leading: leading,
      title: Text(title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
      trailing: trailing,
      onTap: () {},
    );
  }
}