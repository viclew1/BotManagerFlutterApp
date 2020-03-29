import 'package:bot_manager_mobile_app/models/bot_model.dart';
import 'package:bot_manager_mobile_app/models/game_model.dart';
import 'package:flutter/material.dart';

import 'bot_list_element_widget.dart';

class BotsListWidget extends StatefulWidget {
  final GameInfo gameInfo;

  BotsListWidget({this.gameInfo});

  @override
  State<StatefulWidget> createState() {
    return BotsListWidgetState(gameInfo);
  }
}

class BotsListWidgetState extends State<BotsListWidget> {
  final GameInfo gameInfo;
  List<BotInfo> bots = List<BotInfo>();

  BotsListWidgetState(this.gameInfo);

  @override
  void initState() {
    super.initState();
    setState(() {
      bots = gameInfo.botInfoList;
    });
  }

  Widget _buildBotTile(BuildContext context, int index) {
    return new BotListElementWidget(gameInfo, bots[index]);
  }

  @override
  Widget build(BuildContext context) {
    return bots.isEmpty
        ? Text("No bot for this game", style: TextStyle(fontSize: 20),)
        : ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: bots.length,
            itemBuilder: _buildBotTile,
          );
  }
}
