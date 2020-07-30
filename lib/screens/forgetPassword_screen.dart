import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:seller/constants/vars.dart';
import 'package:seller/providers/auth.dart';
import 'package:seller/widgets/custom_appbar.dart';

class ForgetScreen extends StatefulWidget {
  static const routeName = '/forgetPassword';

  @override
  _ForgetScreenState createState() => _ForgetScreenState();
}

class _ForgetScreenState extends State<ForgetScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  Map<String, String> _authData = {
    'phone': null,
  };

  var _isLoading = false;

  final _phNumberController = TextEditingController();

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
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });

    try {
      // Log user in
      await Provider.of<Auth>(context, listen: false).forgetPassword(
        _authData['phone'],
      );
    } on HttpException catch (error) {
      var errorMessage = 'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    } catch (error) {
      _showErrorDialog(error);
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final deviceSize = MediaQuery.of(context).size;
    final title = Text(
      getOTPCodeMM,
      style: TextStyle(
          fontSize: 18,
          color: Theme.of(context).primaryColor),
    );
    final textFormFieldPhone = TextFormField(
      decoration: InputDecoration(
        labelText: phNumberMM,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      controller: _phNumberController,
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (!value.startsWith('09')) {
          return 'Invalid Phone Number!';
        }
        return null;
      },
      onSaved: (value) {
        _authData['phone'] = value;
      },
    );
    final customSizedBox = SizedBox(
      height: deviceSize.height * mainSpace,
    );
    final getOTPButton = FlatButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _isLoading ? CircularProgressIndicator() : SizedBox.shrink(),
          Text(loginMM),
        ],
      ),
      onPressed: (_phNumberController.text == '' )
          ? null
          : _submit,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      padding: EdgeInsets.symmetric(
          vertical: deviceSize.height *
              mainSpace),
      color: Theme.of(context).primaryColor,
      textColor: Theme.of(context)
          .primaryTextTheme
          .button
          .color,
      disabledColor:
      Theme.of(context).disabledColor,
      disabledTextColor: Theme.of(context)
          .primaryTextTheme
          .bodyText1
          .color,
    );

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: deviceSize.width * mainMargin),
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                title,
                customSizedBox,
                textFormFieldPhone,
                customSizedBox,
                getOTPButton,
              ],
            )
        ),
      ),
    );
  }
}


