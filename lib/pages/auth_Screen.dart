import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppo/modal/httpException.dart';
import 'package:shoppo/pages/products_overview_screen.dart';
import 'package:shoppo/providers/auth.dart';

enum AuthMode { SignUp, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = "/";

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context);
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.purple.shade100,
              Colors.amber.shade100,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 250.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //!head Rotated Box
                Container(
                    height: 120,
                    alignment: Alignment.center,
                    width: screenSize.size.width - 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(colors: [
                        Colors.red.shade400,
                        Colors.red.shade200,
                      ]),
                    ),
                    transform: Matrix4.rotationZ(-8 * pi / 180)..translate(-40),
                    child: Text("Shopoo",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 50,
                        ))),
                //*Text Fieds Box
                Auth(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Auth extends StatefulWidget {
  const Auth({
    Key? key,
  }) : super(key: key);

  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> with SingleTickerProviderStateMixin {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final comfirmPaswordCoontroller = TextEditingController();
  final _form = GlobalKey<FormState>();
  bool _isLoading = false;
  AuthMode _authState = AuthMode.Login;
  AnimationController? controller;
  Animation<Offset>? _slideAnimation;
  Animation<double>? _opacityAnimation;
  Map<String, dynamic> _authData = {
    "email": "",
    "password": "",
  };

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _slideAnimation = Tween<Offset>(
            begin: Offset(0.0, 0.0),
            end:Offset(0.0,0.1) )
        .animate(CurvedAnimation(parent: controller!, curve: Curves.elasticIn));
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller!, curve: Curves.fastOutSlowIn));
    

    super.initState();
  }

  _showerrorDialog(String message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("WARNING !",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  )),
              content: Text(message),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("OKAY"))
              ],
            ));
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) {
      // Invalid!
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authState == AuthMode.Login) {
        await Provider.of<AuthService>(context, listen: false)
            .signIn(_authData["email"], _authData["password"]);
      } else {
        await Provider.of<AuthService>(context, listen: false)
            .signUp(_authData["email"], _authData["password"]);
      }
    } on HttpException catch (e) {
      var errorMessage = "Authentication failed!";
      if (e.toString().contains("EMAIL_EXISTS")) {
        errorMessage = "This email already in Use";
      } else if (e.toString().contains("INVALID_EMAIL")) {
        errorMessage = "This is a invalid email";
      } else if (e.toString().contains("WEAK_PASSWORD")) {
        errorMessage = "This Password is to weak";
      } else if (e.toString().contains("EMAIL_NOT_FOUND")) {
        errorMessage = "This email is not exists";
      } else if (e.toString().contains("INVALID_PASSWORD")) {
        errorMessage = "Please enter a valid password";
      } else if (e.toString().contains("TOO_MANY_ATTEMPTS_TRY_LATER ")) {
        errorMessage =
            "We have blocked all requests from this device due to unusual activity. Try again later.";
      }
      _showerrorDialog(errorMessage);
    } catch (e) {
      var errorMessage = "Couldn\'t authenticate.Please try again later!";
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuth() {
    if (_authState == AuthMode.Login) {
      setState(() {
        _authState = AuthMode.SignUp;
      });
      controller!.forward();
    } else {
      setState(() {
        _authState = AuthMode.Login;
      });
      controller!.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context);
    //! Container
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.only(top: 50.0),
      color: Colors.grey.shade300,
      height: _authState == AuthMode.SignUp ? 320 : 260,

      // height:_heightAnimation!.value.height,
      //     constraints:
      //         BoxConstraints(minHeight:_heightAnimation!.value.height,),

      width: screenSize.size.width * 0.75,
      padding: EdgeInsets.all(16.0),
      child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "email",
                    labelText: "email",
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "enter a valid email" : null,
                  controller: emailController,
                  onSaved: (value) {
                    _authData["email"] = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "password",
                    labelText: "password",
                  ),
                  obscureText: true,
                  controller: passwordController,
                  validator: (value) =>
                      value!.length <= 6 ? "enter a 6+ chars password" : null,
                  onSaved: (value) {
                    _authData["password"] = value;
                  },
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds:300),
                  curve: Curves.easeInOut,
                  constraints:BoxConstraints(
                    minHeight:_authState==AuthMode.SignUp?60:0 ,
                    maxHeight: _authState==AuthMode.SignUp?120:0,
                  ),

                  child: FadeTransition(
                    opacity: _opacityAnimation!,
                    child: SlideTransition(
                      position: _slideAnimation!,
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: "Confirm password",
                          labelText: "Confirm password",
                        ),
                        obscureText: true,
                        controller: comfirmPaswordCoontroller,
                        validator: (value) => _authState == AuthMode.SignUp
                            ? value != passwordController.text
                                ? "password do not matched"
                                : null
                            : null,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(100, 50),
                    onSurface: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  onPressed: _submit,
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : Text(
                          "${_authState == AuthMode.Login ? "Login" : "SignUp"}"),
                ),
                SizedBox(height: 20),
                TextButton(
                    onPressed: _switchAuth,
                    child: Text(
                      "${_authState == AuthMode.Login ? "SignUp" : "Login"} Instead",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 18,
                      ),
                    ))
              ],
            ),
          )),
    );
  }
}
