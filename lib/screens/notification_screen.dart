import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:money2/money2.dart';
import 'package:provider/provider.dart';
import 'package:seller/constants/vars.dart';
import 'package:seller/models/http_exception.dart';
import 'package:seller/models/notification_model.dart';
import 'package:seller/providers/orders.dart';
import 'package:seller/widgets/custom_loading.dart';

import 'order_details_screen.dart';

class NotificationScreen extends StatefulWidget {
  static const routeName = '/order';
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
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
      Provider.of<Orders>(context).getNotification().then((_) {
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
    final orders = Provider.of<Orders>(context);
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

    Future<void> _fetchProduct() async {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Orders>(context, listen: false).getNotification().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }

    return DefaultTabController(
      length: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              margin: EdgeInsets.fromLTRB(
                  deviceSize.width * mainMargin,
                  deviceSize.height * 0.02,
                  deviceSize.width * mainMargin,
                  deviceSize.height * 0.01),
              child: Text('အသိပေးချက်များ',
                  style: TextStyle(
                      fontSize: 20, color: Theme.of(context).primaryColor))),
          _isLoading
                  ? Expanded(child: LoadingWidget())
                  :  orders.notificationModel.isNotEmpty
              ? Expanded(
                      child: RefreshIndicator(
                        onRefresh: _fetchProduct,
                        child: ListView.builder(
                          itemCount: orders.notificationModel.length,
                          itemBuilder: (ctx, i) {
                            return ListNotification(
                                notificationModel: orders.notificationModel[i]);
                          },
                        ),
                      ),
                    )
              : Expanded(
            child: Center(
              child: Text('No Data Found'),
            ),
          ),
        ],
      ),
    );
  }
}

class ListNotification extends StatelessWidget {
  const ListNotification({
    Key key,
    @required this.notificationModel,
  }) : super(key: key);

  final NotificationModel notificationModel;

  @override
  Widget build(BuildContext context) {
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

    Future<void> _click({@required String id, @required int notiId}) async {
      try {
        print(id);
        await Provider.of<Orders>(context, listen: false)
            .seenNotification(id: notiId);
        Navigator.pushNamed(context, OrderDetailsScreen.routeName,
            arguments: int.parse(id));
      } on HttpException catch (error) {
        var errorMessage =
            'Could not authenticate you. Please try again later.';
        _showErrorDialog(errorMessage);
      } catch (error) {
        _showErrorDialog(error.toString());
      }
    }

    final deviceSize = MediaQuery.of(context).size;
    final customSizedBoxWidth = SizedBox(
      width: deviceSize.width * mainSpace,
    );
    final customSizedBoxHeight = SizedBox(
      height: deviceSize.height * mainSpace,
    );

    DateTime createdDate = DateTime.parse(notificationModel.notificationDate);
    final DateFormat formatter = DateFormat('dd MMMM yyyy');
    final String formatted = formatter.format(createdDate);

    return Container(
      padding: EdgeInsets.all(deviceSize.width * 0.02),
      color: notificationModel.isSeen ? Colors.white : Color(0xffE5F1FD),
      child: InkWell(
        onTap: () => _click(
            id: notificationModel.referenceAttribute,
            notiId: notificationModel.id),
        child: Row(
          children: <Widget>[
            Image.network(
              notificationModel.url,
              width: deviceSize.width * 0.15,
            ),
            customSizedBoxWidth,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: deviceSize.width * 0.7,
                  child: Text(notificationModel.body,
                      overflow: TextOverflow.ellipsis, maxLines: 5),
                ),
                Text(
                  formatted,
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
