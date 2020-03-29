import 'dart:ui';

import 'package:background_app_bar/background_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildBackground(ImageProvider background, String title, [String subtitle, double blur = 1.5]) {
  return new BackgroundFlexibleSpaceBar(
    centerTitle: true,
    title: ListTile(
      title: buildImpactText(title, 28),
      subtitle: subtitle == null ? Text("") : buildImpactText(subtitle, 22),
    ),
    background: new ClipRect(
      child: new Container(
        child: new BackdropFilter(
          filter: new ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: new Container(
            decoration: new BoxDecoration(color: Colors.transparent),
          ),
        ),
        decoration:
            new BoxDecoration(image: DecorationImage(alignment: Alignment.topCenter, image: background, fit: BoxFit.fitWidth)),
      ),
    ),
  );
}

Widget buildImpactText(String text, double fontSize) {
  return Stack(
    children: <Widget>[
      Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 6
            ..color = Colors.black,
        ),
      ),
      Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
          foreground: Paint()
            ..style = PaintingStyle.fill
            ..strokeWidth = 6
            ..color = Colors.white,
        ),
      ),
    ],
  );
}
