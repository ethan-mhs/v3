import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:money2/money2.dart';
import 'package:provider/provider.dart';
import 'package:seller/constants/vars.dart';
import 'package:seller/models/http_exception.dart';
import 'package:seller/models/order_details.dart';
import 'package:seller/providers/orders.dart';
import 'package:seller/widgets/custom_appbar.dart';
import 'package:seller/widgets/custom_loading.dart';

import '../constants/vars.dart';

class OrderDetailsScreen extends StatefulWidget {
  static const routeName = '/orderDetails';
  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  var _isInit = true;
  var _isLoading = false;
  var _id;

  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      _id = ModalRoute.of(context).settings.arguments as int;

      Provider.of<Orders>(context).getOrderDetails(id: _id).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  List<Widget> _buildItemList(OrderDetails order, deviceSize) {
    List<Widget> lines = []; // this will hold Rows according to available lines
    for (var image in order.orderItem) {
      var widget = ListItem(
        order: image,
      );
      lines.add(widget);
    }
    return lines;
  }

  List<Widget> _buildBank(OrderDetails order, deviceSize) {
    List<Widget> lines = []; // this will hold Rows according to available lines
    lines.add(new Container(
      height: 1,
      width: double.infinity,
      color: Colors.grey,
    ));
    for (var payment in order.paymentInfo) {
      var widget;
      if (payment == order.paymentInfo.last)
        widget = BankList(
          payment: payment,
          isLast: true,
        );
      else
        widget = BankList(payment: payment);
      lines.add(widget);
    }
    return lines;
  }

  @override
  Widget build(BuildContext context) {
    final mmk = Currency.create('MMK', 0, symbol: 'Ks', pattern: '###,### S');

    final order = Provider.of<Orders>(context);
    final deviceSize = MediaQuery.of(context).size;
    final customSizedBox = SizedBox(
      height: deviceSize.height * mainSpace,
    );
    final hr = Container(
      height: 1,
      width: double.infinity,
      color: Colors.grey,
    );

    void _showDialogRespond({String errorMessage}) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(errorMessage == null ? order.response : errorMessage),
          content: Text('Tap Anywhere to close'),
        ),
      );
    }

    Future<void> _showDialog() async{
      var text;
      var status;
      if(order.orderDetails.orderStatus.id == 1){
        text = 'ထုပ်ပိုးပြီးအဆင့်သို့ပြောင်းလဲမည်';
       status = 2;
      }else if(order.orderDetails.orderStatus.id == 2){
        text = 'ပို့နေသည်အဆင့်သို့ပြောင်းလဲမည်';
        status = 3;
      }else if(order.orderDetails.orderStatus.id == 3){
        text = 'ပို့ပြီးအဆင့်သို့ပြောင်းလဲမည်';
        status = 4;
      }else{
        text = 'This Order is Complete';
        status =0;
      }

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          content: Text(text),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: ()  async{
                setState(() {
                  _isLoading = true;
                });
                if (status == 0){
                  setState(() {
                    _isLoading = false;
                  });
                  Navigator.of(ctx).pop();
                }
                else{
                  try {
                    Navigator.of(ctx).pop();
                    await Provider.of<Orders>(context,listen: false).updateOrderStatus(orderId: order.orderDetails.orderId,orderStatusId: status);
                    setState(() {
                      _isLoading = false;
                    });
                    _showDialogRespond();
                  } on HttpException catch (error) {
                    var errorMessage = 'Could not authenticate you. Please try again later.';
                    _showDialogRespond(errorMessage: errorMessage);
                    return;
                  } catch (error) {
                    _showDialogRespond(errorMessage: error.toString());
                    return;
                  }
                  setState(() {
                    _isLoading = false;
                  });
                }
              },
            )
          ],
        ),
      );
    }

    Future<void> _showDialogCancel() async{
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          content: Text('Are you sure do you want to cancel the Order'),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: ()  async{
                setState(() {
                  _isLoading = true;
                });
                  try {
                    Navigator.of(ctx).pop();
                    await Provider.of<Orders>(context,listen: false).cancelOrder(orderId: order.orderDetails.orderId);
                    setState(() {
                      _isLoading = false;
                    });
                    _showDialogRespond();
                  } on HttpException catch (error) {
                    var errorMessage = 'Could not authenticate you. Please try again later.';
                    _showDialogRespond(errorMessage: errorMessage);
                    return;
                  } catch (error) {
                    _showDialogRespond(errorMessage: error.toString());
                    return;
                  }
                setState(() {
                  _isLoading = false;
                });
              },
            )
          ],
        ),
      );
    }

    Future<void> _submitOrderStatus() async {
     await _showDialog();
     if(order.response.isNotEmpty){
       setState(() {
         _isLoading = true;
       });

       Provider.of<Orders>(context,listen: false).getOrderDetails(id: _id).then((_) {
         setState(() {
           _isLoading = false;
         });
       });
     }
    }

    Future<void> _submitOrderCancel() async {
      await _showDialogCancel();
      if(order.response.isNotEmpty){
        setState(() {
          _isLoading = true;
        });

        Provider.of<Orders>(context,listen: false).getOrderDetails(id: _id).then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: deviceSize.width * mainMargin),
        child: _isLoading
            ? LoadingWidget()
            : Column(
                children: <Widget>[
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Visibility(visible: order.orderDetails.orderStatus.id == 5 ? true:false,
                            child: Container(padding: EdgeInsets.all(deviceSize.width * mainSpace),
                              color: Colors.red,
                              child: Text('ဤ အော်ဒါအားဖျက်သိမ်းထားသည်',style: TextStyle(color: Colors.white),),
                            ),),
                          Card(child: Container(
                            padding: EdgeInsets.all(deviceSize.width * mainSpace),
                            width: double.infinity,
                            child: ExpandablePanel(
                              headerAlignment: ExpandablePanelHeaderAlignment.center,
                              header: Text(orderDetailsMM,),
                              expanded: Column(
                                children: <Widget>[
                                  hr,
                                  customSizedBox,
                                  Row(
                                    children: <Widget>[
                                      Text(voucherNoMM + ' : ',
                                          style: TextStyle(color: Colors.grey)),
                                      Text(order.orderDetails.voucherNo),
                                    ],
                                  ),
                                  SizedBox(height: deviceSize.height * 0.02),
                                  InkWell(
                                    onTap: _submitOrderStatus,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Column(children: <Widget>[
                                          Container(
                                            child: CircleAvatar(
                                              backgroundColor: Colors.black12,
                                              child: Icon(
                                                Icons.shopping_basket,
                                                color: order.orderDetails.orderStatus.id == 1 ? Colors.pink : Colors.grey,
                                              ),
                                              radius: 25,
                                            ),
                                          ),
                                          customSizedBox,
                                          Text(orderedMM),
                                        ],),
                                        Column(children: <Widget>[
                                          CircleAvatar(
                                            backgroundColor: Colors.black12,
                                            child: Icon(
                                              Icons.card_giftcard,
                                              color: order.orderDetails.orderStatus.id == 2 ? Colors.pink : Colors.grey,
                                            ),
                                            radius: 25,
                                          ),
                                          customSizedBox,
                                          Text(packedMM),
                                        ],),
                                        Column(children: <Widget>[
                                          CircleAvatar(
                                            backgroundColor: Colors.black12,
                                            child: Icon(
                                              Icons.directions_car,
                                              color: order.orderDetails.orderStatus.id == 3 ? Colors.pink : Colors.grey,
                                            ),
                                            radius: 25,
                                          ),
                                          customSizedBox,
                                          Text(transportingMM),
                                        ],),
                                        Column(children: <Widget>[
                                          CircleAvatar(
                                            backgroundColor: Colors.black12,
                                            child: Icon(
                                              Icons.star,
                                              color: order.orderDetails.orderStatus.id == 4 ? Colors.pink : Colors.grey,
                                            ),
                                            radius: 25,
                                          ),
                                          customSizedBox,
                                          Text(transportedMM),
                                        ],),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: deviceSize.height * 0.02),
                                  Column(
                                    children: _buildItemList(
                                        order.orderDetails, deviceSize),
                                  ),
                                ],
                              ),
                            ),
                          ),),
                          Card(
                            child: Container(
                              padding: EdgeInsets.all(deviceSize.width * mainSpace),
                              child: ExpandablePanel(
                                headerAlignment: ExpandablePanelHeaderAlignment.center,
                                header: Text(toDeliverMM),
                                expanded: Column(
                                  children: <Widget>[
                                    hr,
                                    customSizedBox,
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.location_on,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        Expanded(
                                          child: Text(order.orderDetails
                                                  .deliveryInfo.townshipName +
                                              ' ' +
                                              order.orderDetails.deliveryInfo
                                                  .cityName),
                                        ),
                                      ],
                                    ),
                                    Text(order.orderDetails.deliveryInfo.phNo),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.black12,
                                      ),
                                      child: Text(
                                          order.orderDetails.deliveryInfo.remark),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Card(
                            child: Container(
                              padding: EdgeInsets.all(deviceSize.width * mainSpace),
                              child: ExpandablePanel(
                                headerAlignment: ExpandablePanelHeaderAlignment.center,
                                header: Text(paymentHistoryMM),
                                expanded: Column(
                                  children:
                                      _buildBank(order.orderDetails, deviceSize),
                                ),
                              ),
                            ),
                          ),
                          Card(child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(deviceSize.width * mainSpace),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[Text(deliveryDateAndTimeMM,style: TextStyle(fontSize: 16),),
                                Text(order.orderDetails.deliveryInfo.deliveryDate,style: TextStyle(fontSize: 16,color: Theme.of(context).primaryColor)),],),),),
                          Card(child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(deviceSize.width * mainSpace),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(deliveryTimeMM,style: TextStyle(fontSize: 16),),
                                    ),
                                    Text(order.orderDetails.deliveryInfo
                                        .deliveryService.fromEstDeliveryDay
                                        .toString() +
                                        " ရက် - " +
                                        order.orderDetails.deliveryInfo.deliveryService
                                            .toEstDeliveryDay
                                            .toString() +
                                        " ရက်",style: TextStyle(fontSize: 16,color: Theme.of(context).primaryColor))
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(deliveryFeesMM,style: TextStyle(fontSize: 16)),
                                    ),
                                    Text(Money.fromInt(
                                        order.orderDetails.deliveryInfo.deliveryService
                                            .serviceAmount
                                            .toInt(),
                                        mmk)
                                        .toString(),style: TextStyle(fontSize: 16,color: Theme.of(context).primaryColor))
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(totalFeesMM,style: TextStyle(fontSize: 16,)),
                                    ),
                                    Text(Money.fromInt(
                                        order.orderDetails.netAmt.toInt(), mmk)
                                        .toString(),style: TextStyle(fontSize: 16,color: Theme.of(context).primaryColor))
                                  ],
                                ),
                                ],),),),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: FlatButton(
                      padding: EdgeInsets.symmetric(
                          vertical: deviceSize.height * 0.01),
                      child: Text(
                        deleteOrderMM,
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: _submitOrderCancel,
                      color: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7.5),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: deviceSize.height * 0.01,
                  )
                ],
              ),
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  const ListItem({
    Key key,
    @required this.order,
  }) : super(key: key);

  final OrderItem order;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final mmk = Currency.create('MMK', 0, symbol: 'Ks', pattern: '###,### S');

    return Container(
      padding: EdgeInsets.symmetric(vertical: deviceSize.height * 0.01),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Image.network(
                order.url,
                height: deviceSize.height * 0.075,
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
                      order.name,
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      Money.fromInt(order.price.toInt(), mmk).toString() +
                          ' / ' +
                          order.qty.toString() +
                          " pc",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BankList extends StatelessWidget {
  const BankList({
    Key key,
    @required this.payment,
    this.isLast = false,
  }) : super(key: key);

  final PaymentInfo payment;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    DateTime createdDate = DateTime.parse(payment.transactionDate);
    final DateFormat formatter = DateFormat('dd MMMM yyyy');
    final String formatted = formatter.format(createdDate);

    final deviceSize = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(vertical: deviceSize.height * 0.01),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.network(
                payment.paymentService.imgPath,
                height: deviceSize.height * 0.05,
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
                    Row(
                      children: <Widget>[
                        Text(
                          paymentTypeNameMM + ' : ',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        Text(
                          payment.paymentService.bankName == null
                              ? payment.paymentService.name
                              : payment.paymentService.bankName,
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          phNoMM + ' : ',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        Text(
                          payment.phoneNo.toString(),
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          dateMM + ' : ',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        Text(
                          formatted,
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          orderStatusMM + ' : ',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        Text(
                          payment.paymentStatus.name,
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    payment.paymentStatus.name == isComplete
                        ? Text('Rejected', style: TextStyle(color: Colors.red))
                        : SizedBox.shrink(),
                    payment.remark == null
                        ? SizedBox.shrink()
                        : Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.black12,
                            ),
                            child: Text(payment.remark),
                          ),
                    SizedBox(
                      height: deviceSize.height * 0.01,
                    ),
                    isLast
                        ? Row(
                            children: <Widget>[
                              Expanded(
                                child: FlatButton(
                                  padding: EdgeInsets.symmetric(
                                      vertical: deviceSize.height * 0.01),
                                  child: Text(
                                    confirmMM,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () => {},
                                  color: Theme.of(context).primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7.5),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: deviceSize.width * 0.01,
                              ),
                              Expanded(
                                child: OutlineButton(
                                  padding: EdgeInsets.symmetric(
                                      vertical: deviceSize.height * 0.01),
                                  child: Text(isComplete),
                                  onPressed: () => {},
                                  color: Theme.of(context).primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7.5),
                                  ),
                                ),
                              )
                            ],
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
