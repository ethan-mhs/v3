import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seller/providers/auth.dart';
import 'package:seller/providers/orders.dart';
import 'package:seller/screens/forgetPassword_screen.dart';
import 'package:seller/screens/login_screen.dart';
import 'package:seller/screens/navigator_screen.dart';
import 'package:seller/screens/order_history_detail_screen.dart';
import 'package:seller/screens/splash_screen.dart';

import 'constants/colors.dart';
import 'providers/products.dart';
import 'screens/order_details_screen.dart';
import 'screens/product_entry.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (ctx, auth, previousProducts) => Products(
            auth.token,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, auth, previousOrders) => Orders(
            auth.token,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'ITBaby Seller',
          theme: ThemeData(
              primarySwatch: myColor,
              accentColor: Colors.pinkAccent,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              disabledColor: Colors.grey,
              fontFamily: 'Pyidaungsu',
          ),
          home: auth.isAuth
              ? NavigatorScreen()
              : FutureBuilder(
            future: auth.tryAutoLogin(),
            builder: (ctx, authResultSnapshot) =>
            authResultSnapshot.connectionState ==
                ConnectionState.waiting
                ? SplashScreen()
                : LoginScreen(),
          ),
          routes: {
            ForgetScreen.routeName: (ctx) => ForgetScreen(),
            OrderHistoryDetailScreen.routeName: (ctx) => OrderHistoryDetailScreen(),
            OrderDetailsScreen.routeName: (ctx) => OrderDetailsScreen(),
            ProductEntryPage.routeName: (ctx) => ProductEntryPage(),
          },
        ),
      ),
    );
  }
}
