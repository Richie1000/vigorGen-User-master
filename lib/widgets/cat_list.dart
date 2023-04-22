import 'package:flutter/material.dart';

import './category_item.dart';

class ListOfCategories extends StatelessWidget {
  const ListOfCategories({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List imgList = [
    
    "assets/images/antibacterial.jpg",
    "assets/images/aphrodisiac.jpg",
    "assets/images/contraceptives.png",
    "assets/images/cosmetics.png",
    "assets/images/kids_drug.png",
    "assets/images/painkillers.png",
    "assets/images/pregnancy.png",
  ];
  List title =[
    "Anti-Bacterial",
    "Aphrodisiac",
    "Contraceptive",
    "Cosmetics",
    "Kids Drug",
    "PainKillers",
    "Pregnancy",
  ];
  return SizedBox(
     height: MediaQuery.of(context).size.height/13,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          CateItem(title[0], imgList[0]),
          CateItem(title[1], imgList[1]),
          CateItem(title[2], imgList[2]),
          CateItem(title[3], imgList[3]),
          CateItem(title[4], imgList[4]),
          CateItem(title[5], imgList[5]),
          CateItem(title[6], imgList[6]),
        ],
      ),
    );
    
  }
}