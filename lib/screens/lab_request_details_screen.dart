import 'package:flutter/material.dart';

import './lab_cart_screen.dart';

class LabRequestDetailsScreen extends StatefulWidget {
  static const routeName = "/LabRequestDetails";
  @override
  State<LabRequestDetailsScreen> createState() =>
      _LabRequestDetailsScreenState();
}

class _LabRequestDetailsScreenState extends State<LabRequestDetailsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _dropdownItems1 = ["At Home", "On Premise"];
  final _dropdownItems2 = ["Male", "Female"];
  String _dropdownvalue1 = "At Home";
  String _dropdownValue2 = "Male" ;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    DropdownMenuItem<String> buildMenuItems(String item) =>
        DropdownMenuItem(value: item, child: Text(item, style: TextStyle()));
    return Scaffold(
        appBar: AppBar(
          title: Text("Vigor Gen"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Form(
            key: _formKey,
            child: ListView(
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Almost Done but Provide more details first", style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold
                  ),),
                  Container(
                    padding: EdgeInsets.all(10),
                    width: size.width / 1.5,
                    //height: size.height/6.5,
                    child: TextFormField(
                      validator: ((value) {
                        if (value.isEmpty){
                          return "Please enter your name";
                        }
                      }),
                      decoration: InputDecoration(
                        
                        label: Text("Name"),
                      ),
                      keyboardType: TextInputType.name,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    width: size.width / 1.5,
                    //height: size.height/6.5,
                    child: TextFormField(
                      validator: ((value) {
                        if (value.isEmpty || int.parse(value) > 99 || int.parse(value) < 0){
                          return "Enter a valid Age";
                        }
                      }),
                      decoration: InputDecoration(
                        label: Text("Age"),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    width: size.width / 1.5,
                    //height: size.height/6.5,
                    child: TextFormField(
                      validator: ((value) {
                        if (value.isEmpty || value.length < 11 || !value.startsWith("o")){
                          return "Enter valid Number";
                        }
                      }),
                      decoration: InputDecoration(
                        label: Text("Phone Number"),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  
                    // padding: EdgeInsets.all(10),
                    // width: size.width / 1.5,
                    // //height: size.height/6.5,
                    Column (
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Place of Sample Taking"),
                
                      DropdownButton(
                        //isExpanded: true,
                        value: _dropdownvalue1,
                        items: _dropdownItems1.map(buildMenuItems).toList(),
                        onChanged: (value) {
                          setState(() {
                            _dropdownValue2 = value;
                          });
                        }),
                      ]
                    ),
                
                  Container(
                    padding: EdgeInsets.all(10),
                    width: size.width / 1.5,
                    //height: size.height/6.5,
                    child: Row( 
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text("Sex: ", style: TextStyle(
                            fontSize: 20
                          ),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: DropdownButton(
                      //isExpanded: true,
                      value: _dropdownValue2,
                      items: _dropdownItems2.map(buildMenuItems).toList(),
                      onChanged: (value) {
                          setState(() {
                            _dropdownValue2 = value;
                          },);
                      },
                    ),
                        ),],)
                  ),
                  Row(
                    children: [
                    //width: size.width/3,
                    // shape: Border.all(),
                    // padding: EdgeInsets.all(5),
                    //width: size.width/4,
                    ElevatedButton(
                      //padding: EdgeInsets.all(10),
                      onPressed: () {
                        Navigator.of(context).pushNamed(LabCartScreen.routeName);
                      },
                      style: ButtonStyle(
                        //maximumSize: (100, width/4),
                        shape:  MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18.0),
      
      //side: BorderSide(color: Colors.red)
    )

  )
                      ),
                      child: Text("Proceed To Cart")),
                      SizedBox(
                        width: size.width/3
                      )
                      ],)
                ]),
          ),
        );
  }
}
