import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:seller/constants/vars.dart';
import 'package:seller/providers/auth.dart';

import 'forgetPassword_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  Map<String, String> _authData = {
    'phone': null,
    'password': null,
  };

  var _isLoading = false;
  var _isObscureText = true;
  final _phNumberController = TextEditingController();
  final _passwordController = TextEditingController();

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
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
    if (!_formKey.currentState.validate()) return;

    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<Auth>(context, listen: false).login(
        _authData['phone'],
        _authData['password'],
      );
    } on HttpException catch (error) {
      var errorMessage = 'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    } catch (error) {
      _showErrorDialog(error.toString());
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _phNumberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final deviceSize = MediaQuery.of(context).size;
    final logo = Center(
      child: Image(
        image: AssetImage('assets/images/logo.png'),
        width: deviceSize.width * 0.5,
      ),
    );
    final textFormFieldPhone = TextFormField(
      decoration: InputDecoration(
        labelText: phNumberMM,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      controller: _phNumberController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
//                  if (!value.startsWith('09')) {
//                    return 'Invalid Phone Number!';
//                  }
        //Todo : uncomment in production
        return null;
      },
      onSaved: (value) {
        _authData['phone'] = value;
      },
    );
    final textFormFieldPassword =TextFormField(
      decoration: InputDecoration(
          labelText: passwordMM,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          suffixIcon: GestureDetector(
              onTap: () => {
                setState(() {
                  _isObscureText
                      ? _isObscureText = false
                      : _isObscureText = true;
                })
              },
              child: Icon(Icons.remove_red_eye))),
      obscureText: _isObscureText,
      controller: _passwordController,
      validator: (value) {
        if (value.length < 8) {
          return 'Password is too short!';
        }
        return null;
      },
      onSaved: (value) {
        _authData['password'] = value;
      },
    );
    final goToForgetScreen = InkWell(
        child: Text(
          forgetPasswordMM,
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        onTap: () => Navigator.pushNamed(
          context,
          ForgetScreen.routeName,
        ));
    final loginButton = FlatButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Visibility(visible: _isLoading ? true: false, child: Container(
            margin: EdgeInsets.only(right: deviceSize.width * mainSpace),
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
              strokeWidth: 2,
            ),
            height: 25,
            width: 25,
          ),),
          Text(loginMM),
        ],
      ),
      onPressed: (_phNumberController.text.isNotEmpty || _passwordController.text.isNotEmpty)
          ? _submit
          : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      padding: EdgeInsets.symmetric(
          vertical: deviceSize.height * mainSpace),
      color: Theme.of(context).primaryColor,
      textColor: Theme.of(context).primaryTextTheme.button.color,
      disabledColor: Theme.of(context).disabledColor,
      disabledTextColor:
      Theme.of(context).primaryTextTheme.bodyText1.color,
    );
    final customSizedBox = SizedBox(
      height: deviceSize.height * mainSpace,
    );

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: deviceSize.width * mainMargin),
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                logo,
                customSizedBox,
                textFormFieldPhone,
                customSizedBox,
                textFormFieldPassword,
                customSizedBox,
//                goToForgetScreen,
//                customSizedBox,
              //Todo : re-enable after demo.
                loginButton,
              ],
            )),
      ),
    );
  }
}
