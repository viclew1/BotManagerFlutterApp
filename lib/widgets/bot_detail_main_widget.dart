import 'dart:ui';

import 'package:bot_manager_mobile_app/models/bot_model.dart';
import 'package:bot_manager_mobile_app/models/game_model.dart';
import 'package:bot_manager_mobile_app/widgets/bot_logs_widget.dart';
import 'package:bot_manager_mobile_app/widgets/bot_operations_widget.dart';
import 'package:bot_manager_mobile_app/widgets/custom/drawer_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'bot_details_home_widget.dart';
import 'bot_edition_widget.dart';
import 'custom/game_appbar_builder.dart';

class BotDetailMainWidget extends StatefulWidget {
  final GameInfo game;
  final BotInfo bot;

  BotDetailMainWidget(this.game, this.bot);

  @override
  State<StatefulWidget> createState() {
    return BotDetailMainState(game, bot);
  }
}

class BotDetailMainState extends State<BotDetailMainWidget> {
  final GameInfo game;
  final BotInfo bot;
  int selectedIndex = 0;

  BotDetailMainState(this.game, this.bot);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: buildDrawer(context, setState),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(MediaQuery.of(context).size.height / 6),
          child: AppBar(
            flexibleSpace: buildBackground(NetworkImage(game.iconPath), game.name, bot.login),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: (item) {
            setState(() {
              selectedIndex = item;
            });
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Home")),
            BottomNavigationBarItem(icon: Icon(Icons.edit), title: Text("Edition")),
            BottomNavigationBarItem(icon: Icon(Icons.message), title: Text("Logs")),
            BottomNavigationBarItem(icon: Icon(Icons.publish), title: Text("Operations")),
          ],
          currentIndex: selectedIndex,
        ),
        body: [
          BotDetailsHomeWidget(bot.id),
          BotEditionWidget(bot),
          BotLogsListWidget(bot),
          BotOperationsWidget(bot, game),
        ].elementAt(selectedIndex),
      ),
    );
  }

}
