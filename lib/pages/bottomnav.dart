import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:eventify/pages/booking.dart';
import 'package:eventify/pages/home.dart';
import 'package:eventify/pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:eventify/pages/booking.dart';



class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  late List<Widget> pages;
  late Home home;
  late Booking booking;
  late Profile profile;
  int currentTabIndex=0;

  @override
  void initState() {
    home = Home();
    booking = Booking();
    profile = Profile();
    pages = [home, booking, profile];
    super.initState();
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(height: 55,
      backgroundColor: Color(0xff6351ec), color: Colors.black, animationDuration: Duration(milliseconds: 300),
      onTap: (int index){
        setState(() {
          currentTabIndex=index;
        });

      },

        items:[
          Icon(Icons.home_outlined, color: Colors.white, size: 23),
          Icon(Icons.book, color:Colors.white, size:23),
          Icon(Icons.person_outline, color:Colors.white, size:23),
        ]),
        body: pages[currentTabIndex],
    );
  }
}