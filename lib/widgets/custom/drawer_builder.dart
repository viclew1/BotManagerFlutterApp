import 'package:bot_manager_mobile_app/resources/api_provider.dart';
import 'package:bot_manager_mobile_app/widgets/custom/game_appbar_builder.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          onChanged: (value) {
            setStateFun(() {
              DynamicTheme.of(context).setBrightness(value ? Brightness.dark : Brightness.light);
            });
          },
        ),
        SwitchListTile(
          activeColor: Theme.of(context).primaryColor,
          activeTrackColor: Theme.of(context).accentColor,
          title: Text("Production API"),
          value: ApiProvider.srvPort == ApiProvider.PROD_PORT,
          onChanged: (value) {
            SharedPreferences.getInstance().then((pref) {
              setStateFun(() {
                pref.setBool("isTest", !value);
                ApiProvider.srvPort = value ? ApiProvider.PROD_PORT : ApiProvider.TEST_PORT;
                Navigator.popUntil(context, (route) => route.isFirst);
              });
            });
          },
        )
      ],
    ),
  );
}
