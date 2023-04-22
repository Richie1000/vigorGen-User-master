import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import '../providers/auth.dart';
import '../models/http_exception.dart';
import '../widgets/loading_screen.dart';

enum AuthMode { Signup, Login }

bool forgotPassword = false;

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  //Color
                  Color.fromRGBO(221, 214, 243, 1).withOpacity(0.5),
                  Color.fromRGBO(250, 172, 168, 1).withOpacity(0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 50.0),
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),
                      // ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        'MEK Pharmacy',
                        style: TextStyle(
                          color:
                              Theme.of(context).accentTextTheme.headline6.color,
                          fontSize: 35,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  AnimationController _controller;
  Animation<Offset> _slideAnimation;
  Animation<double> _opacityAnimation;
  final DateTime startTimer = DateTime(2022, 7, 19, 15, 27, 00);
  final DateTime endTimer = DateTime(2022, 7, 23, 00, 35, 00);
  bool is_visible = true;
  bool obscure = true;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _slideAnimation = Tween<Offset>(begin: Offset(0, -1.5), end: Offset(0, 0))
        .animate(
            CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));
    //_heightAnimation.addListener(() =>setState(() {

    //}));
    _opacityAnimation = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  void _showErrorDialog(String message) {
    HapticFeedback.lightImpact();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    // if (endTimer.isBefore(DateTime.now())){
    //   _showErrorDialog("Sorry Mate! Time for Testing is Over");
    //   HapticFeedback.mediumImpact();
    //   return;
    // }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login && forgotPassword == false) {
        // Log user in
        await Provider.of<Auth>(context, listen: false).login(
          _authData['email'],
          _authData['password'],
        );
      } else if (_authMode == AuthMode.Signup && forgotPassword == false) {
        // Sign user up
        await Provider.of<Auth>(context, listen: false).signup(
          _authData['email'],
          _authData['password'],
        );
      } else {
        await Provider.of<Auth>(context, listen: false)
            .resetPassword(_authData['email']);
        print("try");
      }
    } on HttpException catch (error) {
      print(error);
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
      HapticFeedback.lightImpact();
    } catch (error) {
      print(error);
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
      HapticFeedback.lightImpact();
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
        forgotPassword = false;
      });
      _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
        forgotPassword = false;
      });
      _controller.reverse();
    }
  }

  void _switchForgetPasswordMode() {
    if (forgotPassword == false) {
      setState(() {
        forgotPassword = true;
      });
    }
  }

  bool _enablefields() {
    if ((_authMode == AuthMode.Login || _authMode == AuthMode.Signup) &&
        forgotPassword == true) {
      return false;
    } else if ((_authMode == AuthMode.Login || _authMode == AuthMode.Signup) &&
        forgotPassword == false) {
      return true;
    } else {
      return false;
    }
  }

  String _buttonText() {
    if ((_authMode == AuthMode.Login) && forgotPassword == true) {
      print(forgotPassword);
      return "Reset Password";
    }
    if ((_authMode == AuthMode.Signup) && forgotPassword == true) {
      print(forgotPassword);
      return "Reset Password";
    }
    if ((_authMode == AuthMode.Login) && forgotPassword == false) {
      print(forgotPassword);
      return "Login";
    }
    if ((_authMode == AuthMode.Signup) && forgotPassword == false) {
      print(forgotPassword);
      return "SignUp";
    }
  }

  Future<void> _tryPasswordReset() async {
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
      //print("starting again");
    });
    try {
      //print("midway");
      await Provider.of<Auth>(context, listen: false)
          .resetPassword(_authData["email"]);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Password reset Successful, Check Your Email")));
      forgotPassword = false;
      _authMode = AuthMode.Signup;
      _switchAuthMode();
      setState(() {});
      //print("done");
    } catch (error) {
      print(error);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void setVisibility() {
    setState(() {
      is_visible = !is_visible;
    });
  }

  void isVisible() {
    setState(() {
      obscure = !obscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 8.0,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
          height: _authMode == AuthMode.Signup ? 350 : 300,
          //height:_heightAnimation.value.height,
          constraints: BoxConstraints(
              minHeight: _authMode == AuthMode.Signup ? 350 : 300),
          width: deviceSize.width * 0.75,
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: 'E-Mail'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Invalid email!';
                      }
                    },
                    onSaved: (value) {
                      _authData['email'] = value;
                    },
                  ),
                  TextFormField(
                    enabled: _enablefields(),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        onPressed: setVisibility,
                        icon: Icon(is_visible
                            ? Icons.visibility_off
                            : Icons.visibility),
                      ),
                    ),
                    obscureText: is_visible,
                    controller: _passwordController,
                    validator: (value) {
                      if (value.isEmpty || value.length < 5) {
                        return 'Password is too short!';
                      }
                    },
                    onSaved: (value) {
                      _authData['password'] = value;
                    },
                  ),
                  AnimatedContainer(
                    constraints: BoxConstraints(
                        minHeight: _authMode == AuthMode.Signup ? 60 : 0,
                        maxHeight: _authMode == AuthMode.Signup ? 120 : 0),
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                    child: FadeTransition(
                      opacity: _opacityAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: TextFormField(
                          enabled: _enablefields(),
                          decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              suffixIcon: IconButton(
                                  onPressed: isVisible,
                                  icon: Icon(obscure
                                      ? Icons.visibility_off
                                      : Icons.visibility))),
                          obscureText: obscure,
                          validator: _authMode == AuthMode.Signup
                              ? (value) {
                                  if (value != _passwordController.text) {
                                    return 'Passwords do not match!';
                                  }
                                }
                              : null,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextButton(
                      onPressed: _switchForgetPasswordMode,
                      child: Text("Forgot Password")),
                  if (_isLoading)
                    CircularProgressIndicator()
                  else if (forgotPassword == false)
                    ElevatedButton(
                      child: Text(
                          _authMode == AuthMode.Login ? "Login" : "Sign Up"),
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 8.0),
                        primary: Theme.of(context).primaryColor,
                        textStyle: TextStyle(
                          color:
                              Theme.of(context).primaryTextTheme.button.color,
                        ),
                        //textColor: Theme.of(context).primaryTextTheme.button.color,)
                      ),
                    ),
                  if (forgotPassword == true)
                    ElevatedButton(
                      child: Text("Reset Password"),
                      onPressed: _tryPasswordReset,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 8.0),
                        primary: Theme.of(context).primaryColor,
                        textStyle: TextStyle(
                          color:
                              Theme.of(context).primaryTextTheme.button.color,
                        ),
                        //textColor: Theme.of(context).primaryTextTheme.button.color,)
                      ),
                    ),
                  TextButton(
                    child: Text(
                        '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                    onPressed: _switchAuthMode,
                    // padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                    // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    // textColor: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
