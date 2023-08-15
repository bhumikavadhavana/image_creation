import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.pink),
      home: HomePage(),
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey repaintkey = GlobalKey();

  void shareimage() async {
    RenderRepaintBoundary repaintBoundary = await repaintkey.currentContext!
        .findRenderObject() as RenderRepaintBoundary;

    var image = await repaintBoundary.toImage(pixelRatio: 6);
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
    Uint8List ulist = await byteData!.buffer.asUint8List();
    Directory directory = await getApplicationSupportDirectory();
    File file = File("${directory.path}.png");
    await file.writeAsBytes(ulist);
    ShareExtend.share(file.path, "image");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image Creation"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RepaintBoundary(
              key: repaintkey,
              child: Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: NetworkImage(
                        "https://upload.wikimedia.org/wikipedia/commons/thumb/4/42/Shaqi_jrvej.jpg/1200px-Shaqi_jrvej.jpg"),fit: BoxFit.cover
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                shareimage();
              },
              child: Text("Share"),
            ),
          ],
        ),
      ),
    );
  }
}
