import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_code_scanner_app/screens/pages/QrCodeGenerator.dart';
import 'package:qr_code_scanner_app/screens/pages/QrCodeScanner.dart';

class BarcodeScannerScreen extends StatefulWidget {



  @override
  _BarcodeScannerScreenState createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  PersistentTabController _controller = PersistentTabController(initialIndex: 0);



  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.qrcode_viewfinder),
        title: ("QR Code Scanner"),
        activeColorSecondary: Colors.pink,
        activeColorPrimary: Colors.pink,
        inactiveColorPrimary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.qrcode),
        title: ("QR Code Generator"),
        activeColorSecondary: Colors.pink,
        activeColorPrimary: Colors.pink,
        inactiveColorPrimary: Colors.white,
      ),

    ];
  }

  List<Widget> _buildScreens() {
    return [ QrCodeScanner(),QrCodeGenerator()];
  }



  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,

      backgroundColor: Color(0xFF313131) /*appBar2Color*/, // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
         // borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0),topRight:Radius.circular(10.0) ),
          colorBehindNavBar: Colors.white,
          boxShadow: [BoxShadow(
            color: Colors.pink.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 7,
            // offset: Offset(0, 0), // changes position of shadow
          ),]
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties( // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),

      screenTransitionAnimation: ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style6, // Choose the nav bar style with this property.
    );
  }
}
