import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:new_version/new_version.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'package:qr_code_scanner_app/screens/pages/scan_qr.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../ad_helper.dart';
import '../Widget/ButtonWidget.dart';
import 'QrCodeGenerator.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class QrCodeScanner extends StatefulWidget {
  Barcode? qrData;
  QrCodeScanner({this.qrData});

  @override
  _QrCodeScannerState createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner> {
  BannerAd? _bannerAd;
  int _selectedIndex = 0;
  //List<Widget> _widgetOptions =<Widget>[QrCodeScanner(),QrCodeGenerator()];
  bool _validURL = false;
  late Size size;

  @override
  void initState() {
    _checkVersion();

    // TODO: Load a banner ad
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
  }

  void _checkVersion() {
    final newVersion = NewVersion(
      androidId: 'com.a2zsoftt.qr_code_scanner',
    );

    // You can let the plugin handle fetching the status and showing a dialog,
    // or you can fetch the status and display your own dialog, or no dialog.
    const simpleBehavior = false;

    if (simpleBehavior) {
      basicStatusCheck(newVersion);
    } else {
      advancedStatusCheck(newVersion);
    }
  }

  basicStatusCheck(NewVersion newVersion) {
    newVersion.showAlertIfNecessary(context: context);
  }

  advancedStatusCheck(NewVersion newVersion) async {
    final status = await newVersion.getVersionStatus();
    debugPrint(status!.releaseNotes);
    debugPrint(status.appStoreLink);
    debugPrint(status.localVersion);
    debugPrint(status.storeVersion);
    if (status != null && status.localVersion != status.storeVersion) {
      debugPrint(status.releaseNotes);
      debugPrint(status.appStoreLink);
      debugPrint(status.localVersion);
      debugPrint(status.storeVersion);
      debugPrint(status.canUpdate.toString());
      newVersion.showUpdateDialog(
        context: context,
        versionStatus: status,
        dialogTitle: 'App UPDATE!',
        dialogText: 'New  Version is Available!',
        allowDismissal: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFF313131),
      appBar: AppBar(
        backgroundColor: Colors.black12,
        title: Text(
          "QR Code Scanner",
          style: TextStyle(fontFamily: "Sofia", color: Colors.pink),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Container(
        height: size.height,
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (_bannerAd != null)
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: _bannerAd!.size.width.toDouble(),
                  height: _bannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
                ),
              ),
            SizedBox(
              height: 30,
            ),
            widget.qrData?.code != null
                ? _linkCheck()
                : Center(
                    child: Container(
                      height: 100,
                      width: 100,
                    ),
                  ),
            SizedBox(
              height: 100,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ButtonWidget(
                  text: "Scan QR Code",
                  onclicked: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ScanQr(),
                    ));
                  },
                  color: Colors.black26),
            ),
          ],
        ),
      ),
    );
  }

  Widget _linkCheck() {
    _validURL = Uri.parse(widget.qrData!.code.toString()).isAbsolute;
    return Center(
      child: Container(
        height: 200,
        width: 300,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.pink),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Container(
          height: double.infinity,
          width: double.infinity,
          child: _validURL
              ? Center(
            child: SelectableText.rich(TextSpan(
              text: widget.qrData!.code.toString(),
              style: new TextStyle(color: Colors.pink),
              recognizer: new TapGestureRecognizer()
                ..onTap = () {
                  launch(widget.qrData!.code.toString());
                },
            )),
          )
              : Center(
            child: SelectableText(
              widget.qrData!.code.toString(),
              style: TextStyle(
                color: Colors.white54,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )
      ),
    );
  }

  @override
  void dispose() {
    // TODO: Dispose a BannerAd object
    _bannerAd?.dispose();

    super.dispose();
  }
}
