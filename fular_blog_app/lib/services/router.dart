import 'package:flutter/material.dart';
import 'package:fular_blog_app/pages/home_page_widget.dart';
import 'package:fular_blog_app/pages/login_page_widget.dart';
import 'package:fular_blog_app/pages/post/post_page_widget.dart';
import 'package:fular_blog_app/pages/post/postediting_page.dart';
import 'package:fular_blog_app/pages/profile_page_widget.dart';
import 'package:fular_blog_app/pages/search_page_widget.dart';
import 'package:fular_blog_app/pages/settings_page_widget.dart';
import 'package:fular_blog_app/pages/signup_page_widget.dart';
import 'package:fular_blog_app/pages/splash_page_widget.dart';
import 'package:fular_blog_app/pages/timeline_page_widget.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeRoute:
        return MaterialPageRoute(builder: (_) => HomePage());
      case loginRoute:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case signupRoute:
        return MaterialPageRoute(builder: (_) => SignUpPage());
      case timelineRoute:
        return MaterialPageRoute(builder: (_) => TimelinePage());
      case searchRoute:
        return MaterialPageRoute(builder: (_) => SearchPage());
      case postRoute:
        return MaterialPageRoute(
            builder: (_) => PostViewPage(
                  list: settings.arguments,
                ));
      case profileRoute:
        return MaterialPageRoute(
            builder: (_) => ProfilePage(
                  uid: settings.arguments,
                ));
      case settingsRoute:
        return MaterialPageRoute(
            builder: (_) => SettingsPage(
                  userModel: settings.arguments,
                ));
      case postEditingRoute:
        return MaterialPageRoute(
            builder: (_) => PostEditingPage(
                  postModel: settings.arguments,
                ));
      case splashRoute:
        return MaterialPageRoute(builder: (_) => SplashScreenPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text(
                'Not Found',
                style: TextStyle(fontSize: 36),
              ),
            ),
          ),
        );
    }
  }
}

const String homeRoute = '/home';
const String loginRoute = '/login';
const String signupRoute = '/signup';
const String timelineRoute = '/timeline';
const String searchRoute = '/search';
const String postRoute = '/postview';
const String profileRoute = '/profile';
const String settingsRoute = '/settings';
const String postEditingRoute = '/postedit';
const String splashRoute = '/splash';
