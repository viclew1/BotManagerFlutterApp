import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'widgets/games_list_widget.dart';

const Color ICON_BACKGROUND_COLOR = Color.fromRGBO(35, 39, 53, 1);
const ImageProvider ICON_IMAGE_PROVIDER = AssetImage('assets/logo.png');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Brightness brightness = (prefs.getBool("isDark") ?? false) ? Brightness.dark : Brightness.light;
  runApp(MyApp(brightness));
}

class MyApp extends StatelessWidget {
  final Brightness brightness;

  MyApp(this.brightness);

  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
        defaultBrightness: Brightness.dark,
        data: (brightness) => new ThemeData(
            brightness: brightness,
            primarySwatch: Colors.blueGrey,
            primaryColor: Colors.blueGrey[800],
            focusColor: Colors.blueGrey,
            accentColor: Colors.blueGrey,
            textSelectionColor: Colors.blueGrey,
            cursorColor: Colors.blueGrey,
            textSelectionHandleColor: Colors.blueGrey),
        themedWidgetBuilder: (context, theme) {
          return MaterialApp(
            title: "Bot Manager",
            theme: theme,
            home: GamesListWidget(),
          );
        });
  }
}
