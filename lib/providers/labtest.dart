import 'package:flutter/material.dart';

class LabTest with ChangeNotifier{
   String id;
  final String title;
  final double price;
  final String description;
   String labImage;

  LabTest({
    @required this.id,
    @required this.title,
    @required this.price,
    @required this.description,
    @required this.labImage
  });
}