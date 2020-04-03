import 'package:bot_manager_mobile_app/widgets/custom/game_appbar_builder.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

Drawer buildDrawer(BuildContext context, Function setStateFun) {
  return Drawer(
    child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: buildImpactText("Bot Manager", 25),
          ),
          decoration: BoxDecoration(
            image: DecorationImage(alignment: Alignment.topCenter, image: ICON_IMAGE_PROVIDER, fit: BoxFit.contain),
            color: Color.fromRGBO(35, 39, 53, 1),
          ),
        ),
        Divider(
          thickness: 3,
          indent: 10,
          endIndent: 10,
        ),
        SwitchListTile(
          activeColor: Theme.of(context).primaryColor,
          activeTrackColor: Theme.of(context).accentColor,
          title: Text("Dark mode"),
          value: DynamicTheme.of(context).brightness == Brightness.dark,
          onChanged: (bool value) {
            setStateFun(() {
              DynamicTheme.of(context).setBrightness(value ? Brightness.dark : Brightness.light);
            });
          },
        )
      ],
    ),
  );
}
