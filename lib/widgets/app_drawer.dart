import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/add_attendance_screen.dart';
import 'package:flutter_complete_guide/screens/add_lab_service.dart';
import 'package:provider/provider.dart';

import '../screens/attendance_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';
import '../providers/auth.dart';
import '../helpers/custom_route.dart';
import '../screens/lab_services_screen.dart';
import '../screens/manage_labs_screen.dart';
import '../screens/chatbot_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Hello Friend!'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Pharmacy'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/overview');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
              //Navigator.of(context).pushReplacement(CustomRoute(builder: (ctx) => OrdersScreen(),));
            },
          ),
          Divider(),
          // ListTile(
          //   leading: Icon(Icons.edit),
          //   title: Text('Manage Products'),
          //   onTap: () {
          //     Navigator.of(context)
          //         .pushReplacementNamed(UserProductsScreen.routeName);
          //   },
          // ),
          //  Divider(),
          // ListTile(
          //     leading: Icon(Icons.water_drop),
          //     title: Text('Request Laboratory Test'),
          //     onTap: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(builder: (context) => LabScreen()),
          //       );
          //     }),
          // Divider(),
          // ListTile(
          //   leading: Icon(Icons.add_box),
          //   title: Text("Add Lab Service"),
          //   onTap: (){
          //     Navigator.of(context).pushReplacementNamed(AddLabService.routeName);
          //   },
          // ),
          // Divider(),
          // ListTile(
          //   leading: Icon(Icons.science_outlined),
          //   title: Text("Manage Lab Services"),
          //   onTap: (){
          //     Navigator.of(context).pushReplacementNamed(ManageLabs.routeName);
          //   }
          // ),
          Divider(),
          ListTile(
              leading: Icon(Icons.chat_bubble_rounded),
              title: Text("Chat Us"),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(ChatBotScreen.routeName);
              }),
          // Divider(),
          // ListTile(
          //   leading: Icon(Icons.add_alert),
          //   title: Text("Add Attendance"),
          //   onTap: (){Navigator.of(context).pushReplacementNamed(AddAttendancePage.routeName);},
          // ),
          // Divider(),
          // ListTile(
          //   leading: Icon(Icons.check_box),
          //   title: Text("Attendance"),
          //   onTap: (){
          //     Navigator.of(context).pushReplacementNamed(AttendanceScreen.routeName);
          //   },
          // ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed("/");
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
