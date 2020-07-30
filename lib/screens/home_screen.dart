import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:money2/money2.dart';
import 'package:provider/provider.dart';
import 'package:seller/constants/vars.dart';

import '../models/ProductView.dart';
import '../providers/products.dart';
import '../widgets/custom_loading.dart';
import 'product_entry.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentSelection = 0;
  var _isInit = true;
  var _isLoading = false;

  String title = productsMM;

  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).getProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _fetchAllProduct() async {
    setState(() {
      _isLoading = true;
    });
    Provider.of<Products>(context, listen: false)
        .getAllProducts()
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> _fetchPromoProduct() async {
    setState(() {
      _isLoading = true;
    });
    Provider.of<Products>(context, listen: false)
        .getPromoProducts()
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> _fetchOfsProduct() async {
    setState(() {
      _isLoading = true;
    });
    Provider.of<Products>(context, listen: false)
        .getOfsProducts()
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final deviceSize = MediaQuery.of(context).size;
    final products = Provider.of<Products>(context);

    Map<int, Widget> _children = {
      0: SegmentedControlText(text: 'All'),
      1: SegmentedControlText(text: 'Promotions'),
      2: SegmentedControlText(text: 'Out of Stock'),
    };

    return DefaultTabController(
      length: 4,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: deviceSize.width * mainMargin,vertical: deviceSize.height * 0.02),
        child: Column(
          children: <Widget>[
            Center(
              child: MaterialSegmentedControl(
                children: _children,
                selectionIndex: _currentSelection,
                borderColor: Theme.of(context).primaryColor,
                selectedColor: Theme.of(context).primaryColor,
                unselectedColor: Colors.white,
                borderRadius: 8.0,
                onSegmentChosen: (index) {
                  setState(() {
                    _currentSelection = index;
                    switch (index) {
                      case 0:
                        title = productsMM;
                        break;
                      case 1:
                        title = promotionsMM;
                        break;
                      case 2:
                        title = outOfStockMM;
                        break;
                    }
                  });
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: media.height * 0.01),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(title,style: TextStyle(fontSize: 20,color: Theme.of(context).primaryColor),),
                  Container(
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.search,
                            size: 25,
                            color: Colors.black54,
                          ),
                          onPressed: () {},
                        ),
                        Visibility(
                          visible: _currentSelection == 2 ? false : true,
                          child: IconButton(
                            icon: Icon(Icons.add,
                                size: 25, color: Colors.black54),
                            onPressed: () => {Navigator.pushNamed(
                              context,
                              ProductEntryPage.routeName,
                            )},
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _isLoading
                ? Expanded(child: LoadingWidget())
                : _currentSelection == 0 ?
            Expanded(
                    child: products.allProducts.isNotEmpty
                        ? RefreshIndicator(
                            onRefresh: _fetchAllProduct,
                            child: ListView.builder(
                              itemCount: products.allProducts.length,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return ListCard(
                                  media: media,
                                  product: products.allProducts[index],
                                );
                              },
                            ),
                          )
                        : Center(
                            child: Text('No Data Found'),
                          ),
                  )
            : _currentSelection == 1 ? Expanded(
              child: products.promoProducts.isNotEmpty
                  ? RefreshIndicator(
                onRefresh: _fetchPromoProduct,
                child: ListView.builder(
                  itemCount: products.promoProducts.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return ListCard(
                      media: media,
                      product: products.promoProducts[index],
                    );
                  },
                ),
              )
                  : Center(
                child: Text('No Data Found'),
              ),
            ) : Expanded(
              child: products.outOfStockProducts.isNotEmpty
                  ? RefreshIndicator(
                onRefresh: _fetchAllProduct,
                child: ListView.builder(
                  itemCount: products.outOfStockProducts.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return ListCard(
                      media: media,
                      product: products.outOfStockProducts[index],
                    );
                  },
                ),
              )
                  : Center(
                child: Text('No Data Found'),
              ),
            )
            ,
          ],
        ),
      ),
    );
  }
}

class ListCard extends StatelessWidget {
  const ListCard({
    Key key,
    @required this.media,
    @required this.product,
  }) : super(key: key);

  final Size media;
  final ProductView product;

  @override
  Widget build(BuildContext context) {
    final mmk = Currency.create('MMK', 0, symbol: 'Ks', pattern: '###,### S');
    final promo = Currency.create('MMK', 0, symbol: 'Ks', pattern: '###,###');

    return new Card(
      elevation: 0,
      child: Container(
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: IntrinsicHeight(
                child: Row(
                  children: <Widget>[
                    ColorFiltered(
                      colorFilter: product.qty == 0
                          ? ColorFilter.matrix(<double>[
                              0.2126,
                              0.7152,
                              0.0722,
                              0,
                              0,
                              0.2126,
                              0.7152,
                              0.0722,
                              0,
                              0,
                              0.2126,
                              0.7152,
                              0.0722,
                              0,
                              0,
                              0,
                              0,
                              0,
                              1,
                              0,
                            ])
                          : ColorFilter.mode(
                              Colors.transparent,
                              BlendMode.saturation,
                            ),
                      child: Image.network(
                        product.url,
                        height: media.height * 0.12,
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(
                      width: media.width * 0.04,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            product.name,
                            style: TextStyle(fontSize: 16),
                          ),
                          Row(
                            children: <Widget>[
                              product.promotePercent != null
                                  ? Text(
                                      Money.fromInt(
                                              product.promotePrice.toInt(), mmk)
                                          .toString(),
                                style: TextStyle(color: Theme.of(context).primaryColor),
                                    )
                                  : Text(
                                      Money.fromInt(
                                              product.originalPrice.toInt(),
                                              mmk)
                                          .toString(),
                                    ),
                              SizedBox(
                                width: media.width * 0.01,
                              ),
                              Visibility(
                                visible: product.promotePercent != null ?? true,
                                child: Text(
                                  Money.fromInt(
                                          product.originalPrice.toInt(), promo)
                                      .toString(),
                                  style: TextStyle(
                                      decoration: TextDecoration.lineThrough),
                                ),
                              ),
                            ],
                          ),
                          Container(
                              padding: EdgeInsets.fromLTRB(
                                  media.width * 0.03,
                                  media.height * 0.005,
                                  media.width * 0.03,
                                  media.height * 0.005),
                              decoration: BoxDecoration(
                                  color: product.qty == 0
                                      ? Colors.black12
                                      : product.qty < 10
                                          ? Colors.red
                                          : Colors.green,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(7.5))),
                              child: Text(
                                product.qty.toString() + ' stock left',
                                style: TextStyle(
                                    color: product.qty == 0
                                        ? Colors.grey
                                        : Colors.white),
                              )),
                          SizedBox(
                            width: media.width * 0.02,
                          ),
                        ],
                      ),
                    ),
                    Container(
                        alignment: Alignment.topCenter,
                        child: PopupMenuButton(
                          onSelected: (int result) {
                            switch (result) {
                              case 0:
                                print(product.name);
                                break;
                              case 1:
                                break;
                            }
                          },
                          itemBuilder: (BuildContext context) => [
                            const PopupMenuItem(
                              value: 0,
                              child: Text('Edit'),
                            ),
                            const PopupMenuItem(
                              value: 1,
                              child: Text('Delete'),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ),
            Visibility(
              visible:  product.promotePercent != null ? true : false,
              child: Container(
                padding: EdgeInsets.all(media.width * 0.02),
                color: Theme.of(context).primaryColor,
                child: Text(product.promotePercent.toString() + '% Off',style: TextStyle(color: Colors.white),),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SegmentedControlText extends StatelessWidget {
  const SegmentedControlText({
    Key key,
    @required this.text,
  }) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: media.width * 0.02),
      child: Text(
        text,
        style: TextStyle(fontSize: 12),
      ),
    );
  }
}
