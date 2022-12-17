import 'dart:async';

import 'package:all_kinds_of_dog/all_kinds_of_dogs/home.dart';

import 'package:flutter/material.dart';

class AdvertisementPage extends StatefulWidget {
  const AdvertisementPage({super.key});

  @override
  State<AdvertisementPage> createState() => _AdvertisementPageState();
}

class _AdvertisementPageState extends State<AdvertisementPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      return Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) {
        return const HomePage();
      }), (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 200,
          width: 200,
          decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: AssetImage("images/images.png"), fit: BoxFit.cover)),
        ),
      ),
    );
  }
}
