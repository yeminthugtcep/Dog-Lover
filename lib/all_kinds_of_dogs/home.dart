import 'dart:io';

import 'package:all_kinds_of_dog/all_kinds_of_dogs/detail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NameList {
  final List<String> nameList;
  NameList(this.nameList);
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String typeDogApi = "https://dog.ceo/api/breeds/list/all";

  Future<NameList> getDogType() async {
    try {
      final typeDog = await http.get(Uri.parse(typeDogApi));
      final Map nameDog = json.decode(typeDog.body)["message"];
      final NameList dognameList =
          NameList(nameDog.keys.map((e) => e.toString()).toList());
      return dognameList;
    } on SocketException {
      throw "no internet connection";
    } catch (error) {
      throw "unknown error";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white54,
      appBar: AppBar(
        title: const Text("All kinds of dogs"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: getDogType(),
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
              return ListView.builder(
                itemCount: snapshot.data!.nameList.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundImage: NetworkImage(
                            "https://img.favpng.com/7/12/6/dog-puppy-pet-shop-logo-png-favpng-dk33zJJS2LkzWpgZMH5nf9Hp0.jpg"),
                      ),
                      title: Text(snapshot.data!.nameList[index]),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ImageDetail();
                              },
                              settings: RouteSettings(
                                  arguments: snapshot.data!.nameList[index]),
                            ));
                      },
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
