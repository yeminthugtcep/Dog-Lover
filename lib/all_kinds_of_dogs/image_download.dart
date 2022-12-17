import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageDownload extends StatefulWidget {
  const ImageDownload({super.key});

  @override
  State<ImageDownload> createState() => _ImageDownloadState();
}

class _ImageDownloadState extends State<ImageDownload> {
  String showPercentage = "0";
  bool isdownload = false;
  @override
  Widget build(BuildContext context) {
    final dog = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Download"),
        centerTitle: true,
      ),
      body: ListView(padding: const EdgeInsets.all(10), children: [
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          height: 400,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(dog.toString()), fit: BoxFit.cover)),
        ),
        !isdownload
            ? TextButton(
                onPressed: () async {
                  // var status = await Permission.storage.status;
                  // if (status == PermissionStatus.granted) {
                  setState(() {
                    isdownload = true;
                  });
                  var response = await Dio().get(
                    dog.toString(),
                    options: Options(responseType: ResponseType.bytes),
                    onReceiveProgress: (count, total) {
                      final percentage = (count / total) * 100;
                      print(percentage.toStringAsFixed(0));
                      setState(() {
                        showPercentage = percentage.toStringAsFixed(0);
                      });
                      if (percentage == 100) {
                        setState(() {
                          isdownload = false;
                          showPercentage = "0";
                        });
                      }
                    },
                  );
                  final result = await ImageGallerySaver.saveImage(
                      Uint8List.fromList(response.data),
                      quality: 60,
                      name: "yeminthu");
                  // ignore: prefer_const_constructors, use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.red,
                      content: const Text("download successful")));
                  // }
                  //  else {
                  //   await Permission.storage.request();
                  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  //       backgroundColor: Colors.red,
                  //       content: const Text("Permission storage request")));
                  // }
                },
                style: ButtonStyle(
                    side: MaterialStateProperty.all(
                        const BorderSide(color: Colors.blue)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)))),
                child: const Text("Download"),
              )
            : SizedBox(
                height: 22,
                child: LiquidLinearProgressIndicator(
                  value: int.parse(showPercentage) / 100, // Defaults to 0.5.
                  valueColor: const AlwaysStoppedAnimation(Colors
                      .green), // Defaults to the current Theme's accentColor.
                  backgroundColor: Colors
                      .white, // Defaults to the current Theme's backgroundColor.
                  borderColor: Colors.blue,
                  borderWidth: 5.0,
                  borderRadius: 12.0,
                  direction: Axis
                      .horizontal, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.horizontal.
                  center: Text("$showPercentage%"),
                ),
              ),
      ]),
    );
  }
}
