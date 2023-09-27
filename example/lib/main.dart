import 'dart:io';
import 'dart:js_interop';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

double textSize = 20;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String firstButtonText = 'Take photo';
  String secondButtonText = 'Record video';

  String albumName = 'Media';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Container(
                  child: SizedBox.expand(
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                      ),
                      onPressed: _takePhoto,
                      child: Text(firstButtonText,
                          style: TextStyle(
                              fontSize: textSize, color: Colors.white)),
                    ),
                  ),
                ),
              ),
              ScreenshotWidget(),
              Flexible(
                child: Container(
                    child: SizedBox.expand(
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                    onPressed: _recordVideo,
                    child: Text(secondButtonText,
                        style: TextStyle(
                            fontSize: textSize, color: Colors.blueGrey)),
                  ),
                )),
                flex: 1,
              )
            ],
          ),
        ),
      ),
    ));
  }

  void _takePhoto() async {
    final ImagePicker picker = ImagePicker();
// Capture a photo.
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo.isDefinedAndNotNull) {
      setState(() {
        firstButtonText = 'saving in progress...';
      });
      await GallerySaver.saveImage(photo!.path, albumName: albumName);
      setState(() {
        firstButtonText = 'image saved!';
      });
    }
  }

  void _recordVideo() async {
    final ImagePicker picker = ImagePicker();
    final video = await picker.pickVideo(source: ImageSource.camera);
    if (video.isDefinedAndNotNull) {
      setState(() {
        secondButtonText = 'saving in progress...';
      });
      await GallerySaver.saveVideo(video!.path, albumName: albumName);

      setState(() {
        secondButtonText = 'video saved!';
      });
    }
  }

  // ignore: unused_element
  void _saveNetworkVideo() async {
    String path =
        'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4';
    await GallerySaver.saveVideo(path, albumName: albumName);
    setState(() {
      print('Video is saved');
    });
  }

  // ignore: unused_element
  void _saveNetworkImage() async {
    String path =
        'https://image.shutterstock.com/image-photo/montreal-canada-july-11-2019-600w-1450023539.jpg';
    await GallerySaver.saveImage(path, albumName: albumName);
    setState(() {
      print('Image is saved');
    });
  }
}

class ScreenshotWidget extends StatefulWidget {
  @override
  _ScreenshotWidgetState createState() => _ScreenshotWidgetState();
}

class _ScreenshotWidgetState extends State<ScreenshotWidget> {
  final GlobalKey _globalKey = GlobalKey();
  String screenshotButtonText = 'Save screenshot';

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: RepaintBoundary(
        key: _globalKey,
        child: Container(
          child: SizedBox.expand(
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.pink),
              ),
              onPressed: _saveScreenshot,
              child: Text(screenshotButtonText,
                  style: TextStyle(fontSize: textSize, color: Colors.white)),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveScreenshot() async {
    setState(() {
      screenshotButtonText = 'saving in progress...';
    });
    try {
      /*
      //extract bytes
      final RenderRepaintBoundary boundary =
          _globalKey.currentContext.findRenderObject();
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List pngBytes = byteData.buffer.asUint8List();

      //create file
      final String dir = (await getApplicationDocumentsDirectory()).path;
      final String fullPath = '$dir/${DateTime.now().millisecond}.png';
      File capturedFile = File(fullPath);
      await capturedFile.writeAsBytes(pngBytes);
      print(capturedFile.path);

      await GallerySaver.saveImage(capturedFile.path).then((value) {
        setState(() {
          screenshotButtonText = 'screenshot saved!';
        });
      });
      */
    } catch (e) {
      print(e);
    }
  }
}
