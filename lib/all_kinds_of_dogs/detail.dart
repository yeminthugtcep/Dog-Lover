import 'dart:io';

import 'package:all_kinds_of_dog/all_kinds_of_dogs/image_download.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ImageDetail extends StatelessWidget {
  const ImageDetail({super.key});

  Future<List> getLink(String dogName) async {
    try {
      final response = await http
          .get(Uri.parse("https://dog.ceo/api/breed/$dogName/images"));
      final List photoList = json.decode(response.body)["message"];
      return photoList;
    } on SocketException {
      throw "no internet connection";
    } catch (error) {
      throw "unknown error";
    }
  }

  @override
  Widget build(BuildContext context) {
    final dogName = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(dogName.toString()),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: getLink(dogName.toString()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else {
              return GridView.builder(
                itemCount: snapshot.data!.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return Card(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ImageDownload();
                              },
                              settings: RouteSettings(
                                  arguments: snapshot.data![index]),
                            ));
                      },
                      child: Image.network(
                        snapshot.data![index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              );
            }
          } else {
            return const Center(
              child: Text("version error"),
            );
          }
        },
      ),
    );
  }
}
