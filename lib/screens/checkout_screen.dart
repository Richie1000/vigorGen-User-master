import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

import './cart_screen.dart';
import '../providers/cart.dart';
import '../providers/orders.dart';

var paymentPlatform = "MTN Mobilemoney";

class CheckOutScreen extends StatefulWidget {
  //const OrderDetailsForm({ Key? key }) : super(key: key);
  static const routeName = "./chekout";

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String address;
  String phoneNumber;
  String email;
  String name;
  //var paymentPlatform =  "MTN MobileMoney";

  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<Cart>(context);

    void _showOrderSuccessful() {
      showModalBottomSheet(
        context: context,
        builder: (context) => Container(
          color: Colors.white70,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              //height: MediaQuery.of(context).size.height / 2.5,
              child: Lottie.asset("assets/images/delivery_animation.json",
                  repeat: true),
            ),
            Row(
              children: [
                Flexible(
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.all(8),
                      child: Text(
                        "Thanks For shopping with us! \nYou will be notified when we are about to Deliver",
                        softWrap: true,
                        style: TextStyle(fontSize: 22),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("OK"))
              ],
            ),
          ]),
        ),
      );
    }

    // void sendmail(String recipientEmail, String subject, String body) async {
    //   String username = 'noreplymekpharmacy@gmail.com';
    //   String password = '';

    //   final smtpServer = gmail(username, password);
    //   final message = Message()
    //     ..from = Address(username, 'MEK Pharmacy')
    //     ..recipients.add(recipientEmail)
    //     ..subject = subject
    //     ..text = body;

    //   try {
    //     final sendReport = await send(message, smtpServer);
    //     //print('Message sent: ${sendReport.sent}');
    //   } catch (error) {
    //     print('Error occurred while sending email: $error');
    //   }
    // }

    Future<void> sendEmail({String email, String name}) async {
      print("started");
      final serviceId = 'service_3wejn9n';
      final templateId = 'template_2zxdw4b';
      final userId = 'oQGBt7w0ye8YZPW1a';

      try {
        final Uri url =
            Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'service_id': serviceId,
            'template_id': templateId,
            'user_id': userId,
            'template_params': {
              'user_name': name,
              'user_email': email,
              'user_subject': 'Order Received Successfully',
              'user_message':
                  'Order Received Successfully. It will be dispatched very soon. Thank you for choosing MEK Pharmacy',
            },
            'accessToken': 'rEcgTI6R_H4Ood8V07lDs'
          }),
        );

        print('Email response status code: ${response.statusCode}');
        print('Email response body: ${response.body}');

        print("ended");
      } catch (error) {
        print('Error occurred while sending email: $error');
      }
    }

    Future<void> _tryOrder() async {
      if (!_formKey.currentState.validate()) {
        // Invalid!
        return;
      }
      _formKey.currentState.save();
      setState(() {
        _isLoading = true;
      });
      // final printedList =(cart.items.values);
      // cart.items.forEach((key, value) {
      //   print('key:  $key  value:  $value');
      //   print(value.id);
      //   print(value.price);
      //   print(value.title);
      //   print(value.quantity);

      // },);
      // print("");

      print(name);
      print(email);
      await Provider.of<Orders>(context, listen: false).addOrder(
          cart.items.values.toList(),
          cart.totalAmount,
          phoneNumber,
          address,
          paymentPlatform);
      await Provider.of<Orders>(context, listen: false).addOrderAdmin(
          cart.items.values.toList(),
          cart.totalAmount,
          phoneNumber,
          address,
          paymentPlatform);
      await sendEmail(email: email, name: name);
      setState(() {
        _isLoading = false;
      });
      cart.clear();
      Navigator.pop(context);

      //sendEmail(email: email, name: name);
      // try {
      //   // sendEmail(email: email, name: name);
      //   final serviceId = 'service_3wejn9n';
      //   final templateId = 'template_2zxdw4b';
      //   final userId = 'oQGBt7w0ye8YZPW1a';
      //   final Uri url =
      //       Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
      //   final response = await http.post(
      //     url,
      //     headers: {'Content-Type': 'application/json'},
      //     body: json.encode({
      //       'service_id': serviceId,
      //       'template_id': templateId,
      //       'user_id': userId,
      //       'template_params': {
      //         'user_name': name,
      //         'user_email': email,
      //         'user_subject': "Order Received Successfuly",
      //         'user_message':
      //             "Order Received Successfully. it will be dispatched very soon. \nThank you for choosing MEK Pharmacy"
      //       }
      //     }),
      //     //response.body
      //   );
      //   // sendmail(email, "Order Received",
      //   //     "Dear $name , \nThank you for choosing MEK Pharmacy and we will Deliver straight to the address provided. \nRegards \nMEK Pharmacy");
      // } catch (error) {
      //   print(error);
      // }
      _showOrderSuccessful();
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Chekout"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(children: [
              Text("Provide Delivery Information",
                  style: TextStyle(fontSize: 20)),

              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value.length < 3) {
                    return "Please provide a valid name";
                  }
                  return null;
                },
                onSaved: (String value) {
                  name = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Phone number'),
                keyboardType: TextInputType.phone,
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Phone number is Required';
                  }
                  if (value.length > 10 || value.length < 10) {
                    return 'Please Enter a valid Phone Number';
                  }

                  return null;
                },
                onSaved: (String value) {
                  phoneNumber = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Address'),
                keyboardType: TextInputType.multiline,
                validator: (value) {
                  if (value.length < 7) {
                    return "Please provide a valid Address";
                  }
                  return null;
                },
                onSaved: (String value) {
                  address = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value.length < 7) {
                    return "Please provide a valid email Address";
                  }
                  return null;
                },
                onSaved: (String value) {
                  email = value;
                },
              ),
              CustomDropDown(),
              // OrderButton(
              //   cart: cart,
              //   contact: phoneNumber,
              //   address: address,
              //   paymentPlatform: paymentPlatform,
              //   )
              TextButton(
                  onPressed: _tryOrder,
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : Text("OrderNow"))
            ]),
          ),
        ));
  }
}

class CustomDropDown extends StatefulWidget {
  //const CustomDropDown({ Key? key }) : super(key: key);

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  String dropdownValue = 'MTN MobileMoney';

  String getImage() {
    if (dropdownValue == "MTN MobileMoney") {
      return "assets/images/momo.jpeg";
    }
    if (dropdownValue == "Vodafone Cash") {
      return "assets/images/vodafonecash.png";
    }
    if (dropdownValue == "AirtelTigo Money") {
      return "assets/images/airteltigo.jpg";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(height: 80, width: 80, child: Image.asset(getImage())),
        DropdownButton<String>(
          value: dropdownValue,
          icon: const Icon(Icons.keyboard_arrow_down),
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String newValue) {
            setState(() {
              dropdownValue = newValue;
              paymentPlatform = dropdownValue;
            });
          },
          items: <String>[
            'MTN MobileMoney',
            'Vodafone Cash',
            'AirtelTigo Money'
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton(
      {Key key,
      @required this.cart,
      @required this.contact,
      @required this.address,
      @required this.paymentPlatform})
      : super(key: key);

  final Cart cart;
  final String contact;
  final String address;
  final String paymentPlatform;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: _isLoading ? CircularProgressIndicator() : Text('ORDER NOW'),
      onPressed: ((widget.cart.totalAmount <= 0 || _isLoading))
          ? null
          : () async {
              //_formKey.currentState.save();
              setState(() {
                _isLoading = true;
              });
              // await Provider.of<Orders>(context, listen: false).addOrder(
              //   widget.cart.items.values.toList(),
              //   widget.cart.totalAmount,
              // );
              setState(() {
                _isLoading = false;
              });
              widget.cart.clear();
              Navigator.of(context).pop();
              showBottomSheet(
                context: context,
                builder: (context) => Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  color: Colors.white70,
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Icon(
                      Icons.check_circle,
                      size: 70,
                      color: Colors.green,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              "Thanks For shopping with us! \nYou will be notified when we are about to Deliver",
                              softWrap: true,
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("OK"))
                      ],
                    ),
                  ]),
                ),
              );
            },
      //textColor: Theme.of(context).primaryColor,
    );
  }
}
