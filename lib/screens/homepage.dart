import 'dart:io';
import 'dart:typed_data';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScreenshotController screenshotController = ScreenshotController(); 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Screenshot(
        controller: screenshotController,
        child: SafeArea(
          child: 
        Center(
          child: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: (){
                  screenshotController
                      .capture(delay:const Duration(milliseconds: 200))
                      .then((capturedImage) async {
                        print(capturedImage);
                        showCupertinoDialog(context: context, builder: (context)=> CupertinoAlertDialog(
                          actions: [
                            CupertinoButton(
                                child: Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                }),
                            CupertinoButton(
                                child:const Text('I agree'),
                                onPressed: () async{

                                   await ImageGallerySaver.saveImage(
                                      Uint8List.fromList(capturedImage!),
                                      quality: 90,
                                      name: 'screenshot-${DateTime.now()}.png');
                                  
                                  Navigator.of(context).pop();
                                  await Flushbar(
                                    backgroundColor: Colors.black,
                                    flushbarPosition: FlushbarPosition.TOP,
                                      message:
                                          'Image is saved to gallery',
                                          messageColor: Colors.white,
                                      duration:const Duration(seconds: 3),
                                    ).show(context);
                                  
                                }),

                          ],
                          content:const  Text("Do you allow that image is saved ?"),
                        ));
                    print("rasm olindiii");
                  }).catchError((onError) {
                    print(onError);
                  });
            },
            child: Container(
              width: 200,
              height: 200,
              child:const Center(
                child: Icon(Icons.camera,size: 80,color: Colors.white,),
              ),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: Colors.white,width: 3),
              ),
            ),
          ),
        )
        ),
      ),
    );
  }
}