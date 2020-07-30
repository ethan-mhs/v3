import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:money2/money2.dart';
import 'package:provider/provider.dart';
import 'package:seller/models/category.dart';

import '../constants/vars.dart';
import '../models/notification_model.dart';
import '../providers/products.dart';

class ProductEntryPage extends StatefulWidget {
  static const routeName = '/Entry';

  @override
  _ProductEntryPageState createState() => _ProductEntryPageState();
}

class _ProductEntryPageState extends State<ProductEntryPage> {
  int _current = 0;
  int _promoPrice ;
  List<File> imgList = List<File>();
  bool _keyboardState;
  ImagePicker _imagePicker;

  TextEditingController _name;
  TextEditingController _price;
  TextEditingController _about;

  TextEditingController _promoPercent;

  final _formKey = GlobalKey<FormState>();

  _getPhoto() async {
    var image = await ImagePicker().getImage(source: ImageSource.gallery);
    File file = File(image.path);
    if (image != null) {
      _cropImage(file);
    }
  }

  Future<Null> _cropImage(File image) async {
    File croppedImage = await ImageCropper.cropImage(
        sourcePath: image.path,
        maxWidth: 1080,
        maxHeight: 1080,
        aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0));
    if (croppedImage != null) {
      imgList.add(croppedImage);
      setState(() {});
    }
  }

  _deletePhoto() {
    setState(() {
      imgList.removeAt(_current);
    });
  }

  @override
  void initState() {
    super.initState();

    _promoPercent = TextEditingController(text: "0");
    _name = TextEditingController(text: "");
    _price = TextEditingController(text: "");
    _about = TextEditingController(text: "");

    _keyboardState = KeyboardVisibility.isVisible;
    KeyboardVisibility.onChange.listen((bool visible) {
      setState(() {
        _keyboardState = visible;
      });
    });
  }

  @override
  void dispose() {
    _name.dispose();
    _about.dispose();
    _price.dispose();
    _promoPercent.dispose();
    super.dispose();
  }

  var _isInit = true;
  var _isLoading = false;

  String title = productsMM;

  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).getAllCategories().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  void displayBottomSheet(BuildContext context, String price) {
    final media = MediaQuery.of(context).size;
    final promo = Currency.create('MMK', 0, symbol: 'Ks', pattern: '###,###');
    _promoPrice = _promoPrice ?? int.parse((price));
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0), //(x,y)
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(children: <Widget>[

                        Container(
                          child: Icon(Icons.add),
                          margin: EdgeInsets.symmetric(horizontal: media.width * 0.02),),
                        Text(addPromoMM),],),
                      FlatButton(
                        child: Text(okMM),
                        onPressed: () => {
                          Navigator.pop(context)
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: media.height * 0.02,
                ),
                Container(
                  width: media.width * 0.4,
                  child:TextField(
                      controller: _promoPercent,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(borderRadius)),
                        labelText: searchWithProduct,
                        suffixIcon: Icon(Icons.add),
                      ),
                      style: TextStyle(
                        fontSize: 14.0,
                        height: 1.0,
                      ),
                      onChanged: (text) {
                        setState(() {
                          _promoPrice = (int.parse(price) -
                              (int.parse(price) *
                                  int.parse(_promoPercent.text)) /
                                  100)
                              .round();
                        });
                      }
                  )
                ),
                SizedBox(
                  height: media.height * 0.02,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                         Money.fromInt(int.parse(price), promo).toString(),
                        style: TextStyle(decoration: TextDecoration.lineThrough),
                      ),
                      SizedBox(
                        width: media.width * 0.05,
                      ),
                      Text(
                         Money.fromInt(_promoPrice, promo).toString(),
                        style: TextStyle(color: Theme.of(context).primaryColor) ,
                      ),
                      SizedBox(
                        width: media.width * 0.05,
                      ),
                      Text(
                        'Ks',
                        style: TextStyle(color: Colors.grey) ,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: media.height * 0.02,
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

//    void _settingModalBottomSheet(context){
//
//      List<Widget> _listImageRow(List<Category> categories, deviceSize) {
//        List<Widget> lines = []; // this will hold Rows according to available lines
//          for (var category in categories) {
//            var widget = ExpandablePanel(
//              headerAlignment: ExpandablePanelHeaderAlignment.center,
//              header: Text(category.name),
//              expanded: Column(
//                children: <Widget>[
//                  Expanded(child: ListView.builder(
//                    itemCount: category.subCategory.length,
//                    itemBuilder: (ctx, i) {
//                      return ListOrderHistoryByProduct(
//                          orderHistoryByProduct: orders
//                              .orderHistoryByProduct[i]);
//                    },
//                  ),)
//                ],
//              ),
//            );
//            lines.add(widget);
//          }
//        return lines;
//      }
//
//
//      showModalBottomSheet(
//          context: context,
//          builder: (BuildContext bc){
//            return Column(children: <Widget>[
//              ExpandablePanel(
//                headerAlignment: ExpandablePanelHeaderAlignment.center,
//                header: Text(toDeliverMM),
//                expanded: Column(
//                  children: <Widget>[
//                    hr,
//                    customSizedBox,
//                    Row(
//                      children: <Widget>[
//                        Icon(
//                          Icons.location_on,
//                          color: Theme.of(context).primaryColor,
//                        ),
//                        Expanded(
//                          child: Text(order.orderDetails
//                              .deliveryInfo.townshipName +
//                              ' ' +
//                              order.orderDetails.deliveryInfo
//                                  .cityName),
//                        ),
//                      ],
//                    ),
//                    Text(order.orderDetails.deliveryInfo.phNo),
//                    Container(
//                      decoration: BoxDecoration(
//                        borderRadius: BorderRadius.circular(15),
//                        color: Colors.black12,
//                      ),
//                      child: Text(
//                          order.orderDetails.deliveryInfo.remark),
//                    )
//                  ],
//                ),
//              ),
//            ],);
//          }
//      );
//    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black54, //change your color here
          ),
          backgroundColor: Colors.white,
          elevation: 1,
          actions: <Widget>[
            FlatButton(
              onPressed: () => {},
              textColor: Theme.of(context).primaryColor,
              disabledTextColor: Colors.grey,
              child: Text(createProductMM),
            ),
          ],
        ),
        body: KeyboardVisibilityProvider(
          child: Column(
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Visibility(
                        visible: _keyboardState ? false : true,
                        child: Column(
                          children: <Widget>[
                            imgList.isEmpty
                                ? Container(
                              color: Colors.black12,
                              width: deviceSize.width,
                              height: deviceSize.width,
                              child: FlatButton(
                                child: Text(addPhotoMM),
                                onPressed: _getPhoto,
                              ),
                            )
                                : CarouselSlider(
                              items: imgList
                                  ?.map(
                                    (item) => Stack(
                                  fit: StackFit.expand,
                                  children: <Widget>[
                                    Container(
                                      child: Image.file(
                                        item,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.topCenter,
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                        children: <Widget>[
                                          FlatButton.icon(
                                              color: Color.fromRGBO(
                                                  0, 0, 0, 0.7),
                                              onPressed: _getPhoto,
                                              icon: Icon(
                                                Icons.add,
                                                color: Colors.white,
                                              ),
                                              label: Text(
                                                 'Add',
                                                style: TextStyle(color: Colors.white,fontSize: 14),
                                              )),
                                          FlatButton.icon(
                                              color: Color.fromRGBO(
                                                  0, 0, 0, 0.7),
                                              onPressed: _deletePhoto,
                                              icon: Icon(
                                                Icons.delete,
                                                color: Colors.white,
                                              ),
                                              label: Text(
                                                'delete',
                                                style: TextStyle(color: Colors.white,fontSize: 14),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                                  ?.toList(),
                              options: CarouselOptions(
                                  height: deviceSize.width,
                                  autoPlay: false,
                                  viewportFraction: 1.0,
                                  enlargeCenterPage: true,
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      _current = index;
                                    });
                                  }),
                            ),
                            Visibility(
                              visible: imgList.isEmpty == null ? false : true,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: imgList?.map((url) {
                                  int index = imgList.indexOf(url);
                                  return Container(
                                    width: 8.0,
                                    height: 8.0,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 2.0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _current == index
                                          ? Color.fromRGBO(0, 0, 0, 0.9)
                                          : Color.fromRGBO(0, 0, 0, 0.4),
                                    ),
                                  );
                                })?.toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: deviceSize.width * 0.02),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: deviceSize.height * 0.01,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: nameProductMM,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(borderRadius),
                                  ),
                                ),
                                style: TextStyle(
                                  fontSize: 12.0,
                                  height: 1.0,
                                ),
                                controller: _name,
                                validator: (value) {
                                  if (value.isEmpty) {
                                      return 'Enter Data';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: deviceSize.height * 0.01,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: priceMM,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(borderRadius),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                  fontSize: 12.0,
                                  height: 1.0,
                                ),
                                controller: _price,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Enter Data';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: deviceSize.height * 0.01,
                              ),
                              TextFormField(
                                minLines: 1,
                                maxLines: 5,
                                decoration: InputDecoration(
                                  labelText: detailsMM,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(borderRadius),
                                  ),
                                ),
                                style: TextStyle(
                                  fontSize: 12.0,
                                  height: 1.0,
                                ),
                                controller: _about,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Enter Data';
                                  }
                                  return null;
                                },
                              ),
//                              SizedB
                              SizedBox(
                                height: deviceSize.height * 0.01,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  OutlineButton.icon(
                                    onPressed: () =>
                                        displayBottomSheet(context, _price.text),
                                    borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor, //Color of the border
                                      style: BorderStyle.solid, //Style of the border
                                      width: 0.8, //width of the border
                                    ),
                                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(25.0)),
                                    icon: Icon(Icons.add),
                                    label: Text(
                                        addPromoMM
                                    ),
                                  ),
                                  Visibility(
                                    visible: _promoPrice == null ? false:true,
                                    child: Text(_promoPrice.toString() + " Ks",style: TextStyle(color: Theme.of(context).primaryColor) ,),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: deviceSize.height * 0.01,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              BottomButton(
                text: chooseCategoryMM,
                iconData: Icons.add,
                onPressed: (){
//                  _settingModalBottomSheet(context);
                },
              ),
              BottomButton(
                text: chooseVideoMM,
                iconData: Icons.add,
                onPressed: () => {},
              ),
              BottomButton(
                text: chooseSizeMM,
                iconData: Icons.add,
                onPressed: () => {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomButton extends StatelessWidget {
  const BottomButton({
    Key key,
    @required this.iconData,
    @required this.onPressed,
    @required this.text,
  }) : super(key: key);

  final IconData iconData;
  final Function onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return InkWell(
      onTap: onPressed,
      splashColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(deviceSize.width * 0.025),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: 1.0, color: Colors.black12),
          ),
          color: Colors.white,
        ),
        child: Row(children: <Widget>[
          Icon(iconData),
          Text(text),
        ],),
      ),
    );
  }
}
