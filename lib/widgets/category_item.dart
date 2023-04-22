import 'package:flutter/material.dart';

class CateItem extends StatelessWidget {
  String categoryName;
  String imgpath;

  CateItem( this.categoryName,  this.imgpath);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      //padding: EdgeInsets.only(right: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(categoryName, style: TextStyle(
            fontWeight: FontWeight.bold
          ),),
         
          Image(image: AssetImage(imgpath),),
          SizedBox(
            width: 4,
          )
        ],
      ),
    );
  }
}