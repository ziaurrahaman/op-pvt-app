// import 'package:OpPvt/screens/tab_view/settings_page/tab_view.dart';
import 'package:OpPvt/screens/tab_view/tab_view.dart';
import 'package:flutter/material.dart';
// import 'package:op_pvt/screens/tab_view/tab_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // navigate();
    super.initState();
  }

  Future navigate() async {
    await Future.delayed(Duration(seconds: 2));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => TabView(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          'OP SCIENCES PVT',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
