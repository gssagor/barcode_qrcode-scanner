import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_code_scanner_app/screens/pages/QrCodeScanner.dart';

class ScanQr extends StatefulWidget {


  @override
  _ScanQrState createState() => _ScanQrState();
}

class _ScanQrState extends State<ScanQr> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late Size size;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 9, child: _buildQrView(context)),
          Expanded(

            flex: 1,
            child: Container(
              color: Colors.black87,
              width: size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  // if (result != null)
                  //   Text(
                  //       'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                  // else
                  //   const Text('Scan a code'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                          onTap:  () async {
                            await controller?.toggleFlash();
                            setState(() {});
                          },
                          child: Icon(Icons.flash_on,size: 24,color: Colors.white,)),

                      GestureDetector(
                          onTap:  () async {
                            await controller?.flipCamera();
                            setState(() {});
                          },
                          child: Icon(Icons.flip_camera_ios_outlined,size: 24,color: Colors.white,)),

                    ],
                  ),

                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 320.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() async {
        result = scanData;
        await controller?.pauseCamera();
        Navigator.of(context).popUntil((route) => route.isFirst);
        //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => QrCodeScanner(qrData: result)));
        pushNewScreen(
          context,
          screen: QrCodeScanner(qrData: result!),
          withNavBar: true
        );

      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

}
