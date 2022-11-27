import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:share/share.dart';

import '../../ad_helper.dart';

class QrCodeGenerator extends StatefulWidget {


  @override
  _QrCodeGeneratorState createState() => _QrCodeGeneratorState();
}

class _QrCodeGeneratorState extends State<QrCodeGenerator> {
  BannerAd? _bannerAd;
 final controller =TextEditingController();

  @override
  void initState() {

    // TODO: Load a banner ad
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitIdA,
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF313131),
      appBar: AppBar(
        backgroundColor: Colors.black12,
        title: Text("QR Code Generator",
        style: TextStyle(fontFamily: "Sofia",color: Colors.pink),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
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
            Padding(
              padding:  EdgeInsets.only(top: 20.0),
              child: QrImage(
                  data: controller.text,
                size: math.min(
                    MediaQuery.of(context).size.width/1.3,
                    MediaQuery.of(context).size.height)/1.8,
                backgroundColor: Colors.white,

              ),
            ),
            SizedBox(
              height: 40,
            ),

            buildTextField(context),
            SizedBox(
              height: 40,
            ),
            Padding(
              padding:  EdgeInsets.only(left: 8.0,right: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(onPressed: (){
                    _qrDownload();
                  },
                    minWidth: 150.0,
                    height: 45,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                    color: Colors.pink[800],
                   child: Text("Download",style: TextStyle(
                     color: Colors.white
                   ),),
                  ),
                  MaterialButton(onPressed: (){
                    _share();
                  },
                    minWidth: 150.0,
                    height: 45,

                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                    color: Colors.pink[800],
                    child: Text("Share",style: TextStyle(
                        color: Colors.white
                    ),),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

 buildTextField(BuildContext context) {
   return Container(
     child: Padding(
       padding:  EdgeInsets.all(20),
       child: TextField(
         controller: controller,
         style: TextStyle(
           color: Colors.white,
           fontWeight: FontWeight.bold,
           fontSize: 20
         ),
         decoration: InputDecoration(
           hintText: "Enter Data",
               hintStyle: TextStyle(
                color: Colors.white
         ),
           enabledBorder: OutlineInputBorder(
             borderRadius: BorderRadius.circular(16),
             borderSide: BorderSide(
               color:Colors.pink,
             )
           ),
           focusedBorder: OutlineInputBorder(
               borderRadius: BorderRadius.circular(16),
               borderSide: BorderSide(
                 color:Colors.pink,
               )
           ),
           suffixIcon: (IconButton(
             color: Colors.pink,
             icon: Icon(
               Icons.done,
               size:30
             ),
             onPressed: (){
               setState(() {

               });
             },
           ))
         ),

       ),
     ),
   );
 }
 late String qr;
 qrcode(String qr) async {

   final qrValidationResult = QrValidator.validate(
     data: qr,
     version: QrVersions.auto,
     errorCorrectionLevel: QrErrorCorrectLevel.L,
   );
    qrValidationResult.status == QrValidationStatus.valid;
    final qrCode = qrValidationResult.qrCode;
   final painter = QrPainter.withQr(
     qr: qrCode!,
     color: const Color(0xFF000000),

     gapless: true,
     embeddedImageStyle: null,
     embeddedImage: null,
   );Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    final ts = DateTime.now().millisecondsSinceEpoch.toString();
    String path = '$tempPath/$ts.png';
    final picData = await painter.toImageData(2048, format: ui.ImageByteFormat.png);
    await writeToFile(picData!, path);


    return path;
 }
 _share() async {
   String path = await qrcode(controller.text);

   await Share.shareFiles(
       [path],
       mimeTypes: ["image/png"],
       subject: 'My QR code',
       text: 'Please scan me'
   );
 }



 Future<String> createQrPicture(String qr) async {

   final qrValidationResult = QrValidator.validate(
     data: controller.text,
     version: QrVersions.auto,
     errorCorrectionLevel: QrErrorCorrectLevel.L,
   );
   final qrCode = qrValidationResult.qrCode;
   final painter = QrPainter.withQr(
     qr: qrCode!,
     color: const Color(0xFF000000),
     gapless: true,
     embeddedImageStyle: null,
     embeddedImage: null,
   );
   Directory tempDir = await getTemporaryDirectory();
   String tempPath = tempDir.path;
   final ts = DateTime.now().millisecondsSinceEpoch.toString();
   String path = '$tempPath/$ts.png';


   final picData = await painter.toImageData(2048, format: ui.ImageByteFormat.png);
   await writeToFile(picData!, path);


   return path;


 }
 Future<String?> writeToFile(ByteData data, String path) async {
   final buffer = data.buffer;
   await File(path).writeAsBytes(
       buffer.asUint8List(data.offsetInBytes, data.lengthInBytes)
   );

 }
 _qrDownload() async {
   String path = await qrcode(controller.text);

   final success = await GallerySaver.saveImage(path);
  if(success!=null){
    EasyLoading.showSuccess('Download Complete!');
    //  Scaffold.of(context).showSnackBar(SnackBar(
    //    content: success? Text('Image saved to Gallery') : Text('Error saving image'),
    // ));

  }


 }
  @override
  void dispose() {
    // TODO: Dispose a BannerAd object
    _bannerAd?.dispose();


    super.dispose();
  }

}


