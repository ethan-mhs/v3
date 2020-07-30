import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:money2/money2.dart';
import 'package:provider/provider.dart';
import 'package:seller/constants/vars.dart';
import 'package:seller/models/order_history_details.dart';
import 'package:seller/providers/orders.dart';
import 'package:seller/widgets/custom_appbar.dart';
import 'package:seller/widgets/custom_loading.dart';

class OrderHistoryDetailScreen extends StatefulWidget {
  static const routeName = '/orderHistoryDetails';
  @override
  _OrderHistoryDetailScreenState createState() => _OrderHistoryDetailScreenState();
}

class _OrderHistoryDetailScreenState extends State<OrderHistoryDetailScreen> {
  var _isInit = true;
  var _isLoading = false;

  //todo : fix UIs

  void didChangeDependencies() {
    if (_isInit) {
      final id = ModalRoute.of(context).settings.arguments as int;
      setState(() {
        _isLoading = true;
      });
      Provider.of<Orders>(context).getOrderHistoryByProductDetails(id: id).then((_) {
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
    final order = Provider.of<Orders>(context);
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: CustomAppBar(),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: deviceSize.width * mainMargin),
        child: _isLoading
            ? LoadingWidget()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ProductDetail(
                    order: order.orderHistoryByProductDetails,
                  ),
                  Text(
                    orderMM +
                        order.orderHistoryByProductDetails.userList.length.toString() +
                        orderReceivedMM,
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(
                    height: deviceSize.height * 0.025,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: order.orderHistoryByProductDetails.userList.length,
                      shrinkWrap: true,
                      itemBuilder: (ctx, i) {
                        return Customers(
                            user: order.orderHistoryByProductDetails.userList[i]);
                      },
                    ),
                  )
                ],
              ),
      ),
    );
  }
}

class Customers extends StatelessWidget {
  const Customers({
    Key key,
    @required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    DateTime createdDate = DateTime.parse(user.orderCreatedDate);
    final DateFormat formatter = DateFormat('dd MMMM yyyy');
    final String formatted = formatter.format(createdDate);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage(user.userUrl),
        ),
        SizedBox(
          width: deviceSize.width * 0.03,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: (Text(
                      user.userName,
                      style: TextStyle(fontSize: 18),
                    )),
                  ),
                  Text(
                    formatted,
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(
                    width: deviceSize.width * 0.05,
                  ),
                  Icon(
                    Icons.print,
                    color: Colors.grey,
                  ),
                ],
              ),
              Text(
                user.qty.toString() + ' pc',
                style: TextStyle(color: Colors.grey),
              ),
              Row(
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: deviceSize.width * 0.02,
                          vertical: deviceSize.height * 0.005),
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Text(user.paymentStatus)),
                  SizedBox(
                    width: deviceSize.width * 0.01,
                  ),
                  Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: deviceSize.width * 0.02,
                          vertical: deviceSize.height * 0.005),
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Text(user.orderStatus)),
                ],
              ),
              Container(
                margin:
                    EdgeInsets.symmetric(vertical: deviceSize.height * 0.025),
                height: 1.0,
                width: double.infinity,
                color: Colors.black38,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ProductDetail extends StatelessWidget {
  const ProductDetail({
    Key key,
    @required this.order,
  }) : super(key: key);

  final OrderHistoryByProductDetails order;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    final mmk = Currency.create('MMK', 0, symbol: 'Ks', pattern: '###,### S');

    return new Card(
      margin: EdgeInsets.only(bottom: deviceSize.height * 0.02),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(10),
        child: IntrinsicHeight(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Image.network(
                    order.productUrl,
                    height: deviceSize.height * 0.12,
                    fit: BoxFit.fill,
                  ),
                  SizedBox(
                    width: deviceSize.width * 0.05,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          order.productName,
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          Money.fromInt(order.price.toInt(), mmk).toString(),
                          style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).primaryColor),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(
                              deviceSize.width * 0.03,
                              deviceSize.height * 0.005,
                              deviceSize.width * 0.03,
                              deviceSize.height * 0.005),
                          decoration: BoxDecoration(
                              color: order.totalQty == 0
                                  ? Colors.black12
                                  : order.totalQty < 10
                                      ? Colors.red
                                      : Colors.green,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          child: Text(
                            order.totalQty.toString() + ' stock left',
                            style: TextStyle(
                              color: order.totalQty == 0
                                  ? Colors.grey
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
