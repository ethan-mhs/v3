import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:money2/money2.dart';
import 'package:provider/provider.dart';
import 'package:seller/constants/vars.dart';
import 'package:seller/models/order_history.dart';
import 'package:seller/models/order_history_product.dart';
import 'package:seller/providers/orders.dart';
import 'package:seller/widgets/custom_loading.dart';

import 'order_details_screen.dart';
import 'order_history_detail_screen.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/order';
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var _isInit = true;
  var _isLoading = false;
  var _isProductSearch = true;

  final _productController = TextEditingController();
  final _voucherController = TextEditingController();

  Future<void> _onSearchByProduct({String text}) async {
    setState(() {
      _isLoading = true;
    });
    if (text == null) {
      Provider.of<Orders>(context, listen: false)
          .getOrderHistoryByProduct()
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    } else {
      Provider.of<Orders>(context, listen: false)
          .getOrderHistoryByProduct(name: text)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  Future<void> _onSearchByVoucher({String text}) async {
    setState(() {
      _isLoading = true;
    });
    if (text == null) {
      Provider.of<Orders>(context, listen: false)
          .getOrderHistoryByCustomer()
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    } else {
      Provider.of<Orders>(context, listen: false)
          .getOrderHistoryByCustomer(voucher: text)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  Future<void> _fetchProduct() async {
    setState(() {
      _productController.text = '';
      _isLoading = true;
    });
    Provider.of<Orders>(context, listen: false)
        .getOrderHistoryByProduct()
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> _fetchCustomer() async {
    _voucherController.text = '';
    setState(() {
      _isLoading = true;
    });
    Provider.of<Orders>(context, listen: false)
        .getOrderHistoryByCustomer()
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _productController.dispose();
    _voucherController.dispose();
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
      Provider.of<Orders>(context).getOrderHistories().then((_) {
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
    final textFieldSearchByProduct = TextField(
      controller: _productController,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.never,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius)),
        labelText: searchWithProduct,
        suffixIcon: Icon(Icons.search),
      ),
      style: TextStyle(
        fontSize: 14.0,
        height: 1.0,
      ),
      onChanged: (text) => {
        if (text == '')
          {_onSearchByProduct()}
        else
          {_onSearchByProduct(text: text)}
      },
    );
    final textFieldSearchByVoucher = TextField(
      controller: _voucherController,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.never,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius)),
        labelText: searchWithOrderId,
        suffixIcon: Icon(Icons.search),
      ),
      style: TextStyle(
        fontSize: 14.0,
        height: 1.0,
      ),
      onChanged: (text) => {
        if (text == '')
          {_onSearchByVoucher()}
        else
          {_onSearchByVoucher(text: text)}
      },
    );

    return DefaultTabController(
      length: 4,
      child: Container(
        margin: EdgeInsets.all(deviceSize.width * mainMargin),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child:
                  Text(orderPageMM,style: TextStyle(fontSize: 20,color: Theme.of(context).primaryColor),),
                ),
                Text(
                  _isProductSearch ? viewByBuyerMM : viewByProductMM,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                IconButton(
                  onPressed: () => {
                    setState(() => {
                          if (_isProductSearch)
                            _isProductSearch = false
                          else
                            _isProductSearch = true
                        })
                  },
                  icon: Image(
                    image: AssetImage(
                      'assets/icons/switch_btn.png',
                    ),
                    fit: BoxFit.cover,
                    width: 25,
                    height: 25,
                  ),
                ),
              ],
            ),
            _isProductSearch
                ? Expanded(
                    child: Column(
                      children: <Widget>[
                        textFieldSearchByProduct,
                        customSizedBoxHeight,
                        _isLoading
                            ? Expanded(child: LoadingWidget())
                            : Expanded(
                                child: orders.orderHistoryByProduct.isNotEmpty
                                    ? RefreshIndicator(
                                        onRefresh: _fetchProduct,
                                        child: ListView.builder(
                                          itemCount: orders
                                              .orderHistoryByProduct.length,
                                          itemBuilder: (ctx, i) {
                                            return ListOrderHistoryByProduct(
                                                orderHistoryByProduct: orders
                                                    .orderHistoryByProduct[i]);
                                          },
                                        ),
                                      )
                                    : Center(
                                        child: Text('No Data Found'),
                                      ),
                              ),
                      ],
                    ),
                  )
                : Expanded(
                    child: Column(
                      children: <Widget>[
//                        textFieldSearchByVoucher,
//                        customSizedBoxHeight,
                        //Todo: Search API Error Fix and add other search according to UI.
                        _isLoading
                            ? Expanded(child: LoadingWidget())
                            : Expanded(
                                child: orders.orderHistoryByCustomer.isNotEmpty
                                    ? RefreshIndicator(
                                        onRefresh: _fetchCustomer,
                                        child: ListView.builder(
                                          itemCount: orders
                                              .orderHistoryByCustomer.length,
                                          itemBuilder: (ctx, i) {
                                            return ListOrderHistoryByCustomer(
                                              order: orders
                                                  .orderHistoryByCustomer[i],
                                            );
                                          },
                                        ),
                                      )
                                    : Center(
                                        child: Text('No Data Found'),
                                      ),
                              ),
                      ],
                    ),
                  )
          ],
        ),
      ),
    );
  }
}

class ListOrderHistoryByProduct extends StatelessWidget {
  const ListOrderHistoryByProduct({
    Key key,
    @required this.orderHistoryByProduct,
  }) : super(key: key);

  final OrderHistoryByProduct orderHistoryByProduct;

  List<Widget> _listImageRow(OrderHistoryByProduct order, deviceSize) {
    List<Widget> lines = []; // this will hold Rows according to available lines
    if (order.userImage.length > 4) {
      for (var i = 0; i < 4; i++) {
        var widget = Container(
          margin: EdgeInsets.symmetric(horizontal: deviceSize.width * 0.01),
          child: CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(order.userImage[i]),
          ),
        );
        lines.add(widget);
      }
      var widgetCount = Container(
        margin: EdgeInsets.symmetric(horizontal: deviceSize.width * 0.01),
        child: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.black87,
          child: Text(
            '+' + (order.userImage.length - 4).toString(),
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
      lines.add(widgetCount);
    } else {
      for (var image in order.userImage) {
        var widget = Container(
          margin: EdgeInsets.symmetric(horizontal: deviceSize.width * 0.01),
          child: CircleAvatar(
            radius: 15,
            backgroundImage: NetworkImage(image),
          ),
        );
        lines.add(widget);
      }
    }
    return lines;
  }

  @override
  Widget build(BuildContext context) {
    double discountPrice = (orderHistoryByProduct.originalPrice -
        orderHistoryByProduct.promotePrice);
    int percent = (orderHistoryByProduct.originalPrice / discountPrice).round();

    final deviceSize = MediaQuery.of(context).size;
    final mmk = Currency.create('MMK', 0, symbol: 'Ks', pattern: '###,### S');
    final promo = Currency.create('MMK', 0, symbol: 'Ks', pattern: '###,###');
    final customSizedBoxWidth = SizedBox(
      width: deviceSize.width * mainSpace,
    );
    final customSizedBoxHeight = SizedBox(
      height: deviceSize.height * mainSpace,
    );
    final image = Image.network(
      orderHistoryByProduct.productUrl,
      height: deviceSize.height * 0.12,
      fit: BoxFit.fill,
    );
    final textName = Text(
      orderHistoryByProduct.productName,
      style: TextStyle(fontSize: 16),
    );
    final promoPrice = Text(
      Money.fromInt(orderHistoryByProduct.promotePrice.toInt(), mmk).toString(),
      style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor),
    );
    final originPrice = Text(
      Money.fromInt(orderHistoryByProduct.originalPrice.toInt(), promo)
          .toString(),
      style: TextStyle(decoration: TextDecoration.lineThrough),
    );
    final stockLeft = Text(
      orderHistoryByProduct.totalQty.toString() + ' stock left',
      style: TextStyle(
        color: orderHistoryByProduct.totalQty == 0 ? Colors.grey : Colors.white,
      ),
    );
    final totalBuyer = Text(
      orderMM +
          orderHistoryByProduct.userImage.length.toString() +
          orderReceivedMM,
      style: TextStyle(color: Colors.black87),
    );
    final percentText = Text(
      '$percent % Off',
      style: TextStyle(color: Colors.white),
    );

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: deviceSize.width * 0.001,
      ),
      child: InkWell(
        onTap: () => Navigator.pushNamed(
            context, OrderHistoryDetailScreen.routeName,
            arguments: orderHistoryByProduct.productId),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: 1,
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(deviceSize.width * mainMargin),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        image,
                        customSizedBoxWidth,
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              textName,
                              Row(
                                children: <Widget>[
                                  promoPrice,
                                  customSizedBoxWidth,
                                  originPrice,
                                ],
                              ),
                              Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: deviceSize.width * mainSpace,
                                  ),
                                  decoration: BoxDecoration(
                                      color: orderHistoryByProduct.totalQty == 0
                                          ? Colors.black12
                                          : orderHistoryByProduct.totalQty < 10
                                              ? Colors.red
                                              : Colors.green,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(borderRadius))),
                                  child: stockLeft),
                            ],
                          ),
                        ),
                      ],
                    ),
                    customSizedBoxHeight,
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(borderRadius),
                        color: Colors.black12,
                      ),
                      padding: EdgeInsets.all(deviceSize.width * 0.03),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          totalBuyer,
                          SizedBox(
                            height: deviceSize.height * 0.01,
                          ),
                          Row(
                            children: _listImageRow(
                                orderHistoryByProduct, deviceSize),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: true,
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.all(
                          Radius.circular(borderRadius))),
                  padding: EdgeInsets.symmetric(horizontal: deviceSize.width * 0.02,vertical: deviceSize.height * 0.005),
                  child: percentText,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ListOrderHistoryByCustomer extends StatelessWidget {
  const ListOrderHistoryByCustomer({
    Key key,
    @required this.order,
  }) : super(key: key);

  final OrderHistoryByCustomer order;

  @override
  Widget build(BuildContext context) {
    final createdDate = DateTime.parse(order.orderDate);
    final DateFormat formatter = DateFormat('dd MMMM yyyy');
    final String formatted = formatter.format(createdDate);
    final mmk = Currency.create('MMK', 0, symbol: 'Ks', pattern: '###,### S');
    final deviceSize = MediaQuery.of(context).size;
    final customSizedBoxWidth = SizedBox(
      width: deviceSize.width * mainSpace,
    );
    final customSizedBoxHeight = SizedBox(
      height: deviceSize.height * mainSpace,
    );
    final image = Image.network(
      order.productUrl,
      height: deviceSize.height * 0.12,
      fit: BoxFit.fill,
    );
    final voucherNo = Text(
      'Order ' + order.voucherNo,
      style: TextStyle(fontSize: 16),
    );
    final orderDate = Text(
      formatted,
      style: TextStyle(fontSize: 14, color: Colors.grey),
    );
    final paymentStatus = Text(order.paymentStatusName);
    final orderStatus = Text(order.orderStatus);
    final totalItems = Text(
      order.qty.toString() + ' items, ',
      style: TextStyle(fontSize: 16),
    );
    final totalAmount = Text(
      'Total ' + Money.fromInt(order.price.toInt(), mmk).toString(),
      style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor),
    );

    return InkWell(
      onTap: () => {
        Navigator.pushNamed(context, OrderDetailsScreen.routeName,
            arguments: order.orderId)
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        elevation: 1,
        child: Container(
          padding: EdgeInsets.all(deviceSize.width * mainMargin),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  image,
                  customSizedBoxWidth,
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        voucherNo,
                        orderDate,
                        Row(
                          children: <Widget>[
                            Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: deviceSize.width * mainSpace,
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(borderRadius))),
                                child: paymentStatus),
                            customSizedBoxWidth,
                            Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: deviceSize.width * mainSpace,
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(borderRadius))),
                                child: orderStatus),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              customSizedBoxHeight,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  totalItems,
                  totalAmount,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
