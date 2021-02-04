import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'bookmark_page_widget.dart';
import 'post/postediting_page.dart';
import 'profile_page_widget.dart';
import 'search_page_widget.dart';
import 'timeline_page_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  //static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List<Widget> _widgetOptions = <Widget>[
    //TestP(),
    TimelinePage(),
    SearchPage(),
    PostEditingPage(),
    BookmarkPage(),
    ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white, 
          boxShadow: [
          BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1)),
        ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
                gap: 8,
                activeColor: Colors.white,
                iconSize: 24,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                duration: Duration(milliseconds: 800),
                tabBackgroundColor: Colors.grey[800],
                tabs: [
                  GButton(
                    backgroundColor: Colors.amber[100],
                    iconActiveColor: Colors.amber,
                    textColor: Colors.amber,
                    icon: Icons.home,
                    text: 'Home',
                  ),
                  GButton(
                    backgroundColor: Colors.purple[100],
                    iconActiveColor: Colors.purple,
                    textColor: Colors.purple,
                    icon: Icons.search,
                    text: 'Search',
                  ),
                  GButton(
                    backgroundColor: Colors.blue[100],
                    iconActiveColor: Colors.blue,
                    textColor: Colors.blue,
                    icon: Icons.add,
                    text: 'Add',
                  ),
                  GButton(
                    backgroundColor: Colors.pink[100],
                    iconActiveColor: Colors.pink,
                    textColor: Colors.pink,
                    icon: Icons.bookmark,
                    text: 'Bookmark',
                  ),
                  GButton(
                    backgroundColor: Colors.green[100],
                    iconActiveColor: Colors.green,
                    textColor: Colors.green,
                    icon: Icons.person,
                    text: 'Profile',
                  ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                }),
          ),
        ),
      ),
    );
  }
}