import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:seller/constants/vars.dart';
import 'package:seller/models/http_exception.dart';
import 'package:seller/providers/auth.dart';
import 'package:seller/widgets/custom_loading.dart';

class MyProfileScreen extends StatefulWidget {
  static const routeName = '/order';
  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Auth>(context).getProfile().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    final deviceSize = MediaQuery.of(context).size;
    final customSizedBoxHeight = SizedBox(
      height: deviceSize.height * mainSpace,
    );
    final customSizedBoxWidth = SizedBox(
      width: deviceSize.width * mainSpace,
    );
    final hr = Container(
      height: 0.5,
      width: double.infinity,
      color: Colors.grey,
    );

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
      try {
        await Provider.of<Auth>(context, listen: false).logout();
      } on HttpException catch (error) {
        var errorMessage =
            'Could not authenticate you. Please try again later.';
        _showErrorDialog(errorMessage);
      } catch (error) {
        _showErrorDialog(error.toString());
      }
    }

    return DefaultTabController(
      length: 4,
      child: Container(
        margin: EdgeInsets.all(deviceSize.width * mainMargin),
        child: _isLoading
            ? LoadingWidget()
            : Column(
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.only(top: deviceSize.height * 0.025),
                      margin: EdgeInsets.only(left: deviceSize.width * 0.08),
                      child: Row(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(auth.profile.url),
                          ),
                          SizedBox(
                            width: deviceSize.width * 0.05,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  auth.profile.name,
                                  style: TextStyle(fontSize: 20),
                                ),
                                Row(
                                  children: <Widget>[
                                    Image(
                                      image: AssetImage(
                                          'assets/images/confirm.png'),
                                      width: deviceSize.width * 0.05,
                                    ),
                                    Text(
                                      'အချက်အလက်များမှန်ကန်ကြောင်းအတည်ပြုပြီး',
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      )),
                  SizedBox(
                    height: deviceSize.height * 0.035,
                  ),
                  hr,
                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: deviceSize.height * mainSpace),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: deviceSize.width * 0.05,
                        ),
                        Image(
                            image: AssetImage('assets/images/memberpoint.png'),
                            width: deviceSize.width * 0.05),
                        SizedBox(
                          width: deviceSize.width * 0.05,
                        ),
                        Text(
                          'Memberpoint များ',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  hr,
                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: deviceSize.height * mainSpace),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: deviceSize.width * 0.05,
                        ),
                        Image(
                            image: AssetImage('assets/images/category.png'),
                            width: deviceSize.width * 0.05),
                        SizedBox(
                          width: deviceSize.width * 0.05,
                        ),
                        Text(
                          'Category များ',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  hr,
                  Visibility(
                    visible: auth.profile.phoneNo.isEmpty ? false : true,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: deviceSize.height * mainSpace),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            width: deviceSize.width * 0.05,
                          ),
                          Image(
                              image: AssetImage('assets/images/phone.png'),
                              width: deviceSize.width * 0.05),
                          SizedBox(
                            width: deviceSize.width * 0.05,
                          ),
                          Text(
                            auth.profile.phoneNo,
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: auth.profile.phoneNo.isEmpty ? false : true,
                    child: hr,
                  ),
                  Visibility(
                    visible: auth.profile.townName.isEmpty ? false : true,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: deviceSize.height * mainSpace),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            width: deviceSize.width * 0.05,
                          ),
                          Image(
                              image: AssetImage('assets/images/address.png'),
                              width: deviceSize.width * 0.05),
                          SizedBox(
                            width: deviceSize.width * 0.05,
                          ),
                          Text(
                            auth.profile.townName +
                                ' , ' +
                                auth.profile.cityName,
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                  hr,
                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: deviceSize.height * mainSpace),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: deviceSize.width * 0.05,
                        ),
                        Image(
                            image: AssetImage('assets/images/password.png'),
                            width: deviceSize.width * 0.05),
                        SizedBox(
                          width: deviceSize.width * 0.05,
                        ),
                        Text(
                          'Password ပြောင်းလဲမည်',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  hr,
                  InkWell(
                    onTap: _submit,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: deviceSize.height * mainSpace),
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: deviceSize.width * 0.05,
                          ),
                          Image(
                              image: AssetImage('assets/images/logout.png'),
                              width: deviceSize.width * 0.05),
                          SizedBox(
                            width: deviceSize.width * 0.05,
                          ),
                          Text(
                            'အကောင့်ထွက်မည်',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                  hr,
                ],
              ),
      ),
    );
  }
}
