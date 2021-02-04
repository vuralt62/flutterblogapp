import 'package:flutter/material.dart';
import 'package:fular_blog_app/pages/splash_page_widget.dart';
import 'package:fular_blog_app/services/authentication_service.dart';
import 'package:fular_blog_app/services/post_service.dart';
import 'package:provider/provider.dart';
import 'services/router.dart';
import 'services/user_service.dart';

void main() => runApp(MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (_) => AuthenticationService(),
      ),
      ChangeNotifierProvider(
        create: (_) => PostService(),
      ),
      ChangeNotifierProvider(
        create: (_) => UserService(),
      ),
    ], child: MainPage()));

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fular Blog App',
      home: SplashScreenPage(),
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: splashRoute,
    );
  }
}
