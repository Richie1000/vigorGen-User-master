import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/search_button.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  const CustomAppBar({
    Key key,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      bottomOpacity: 0,
      shadowColor: Colors.transparent,
      elevation: 0,
      title: const Text(
        "MEK Pharmacy",
        style: TextStyle(color: Colors.black),
      ),
      actions: [SearchButton()],
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(color: Colors.black),
    );
  }
}
