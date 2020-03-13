import 'package:bot_manager_mobile_app/blocs/bot_detail_widget.dart';
import 'package:bot_manager_mobile_app/models/bot_model.dart';
import 'package:bot_manager_mobile_app/models/game_model.dart';
import 'package:bot_manager_mobile_app/resources/api_provider.dart';
import 'package:bot_manager_mobile_app/theme.dart';
import 'package:flutter/material.dart';

import 'bot_list_element_widget.dart';

class BotsListWidget extends StatefulWidget {

  final GameInfo gameInfo;
  final Function() gameListUpdateCallback;

  BotsListWidget({
    this.gameInfo,
    this.gameListUpdateCallback
  });

  @override
  State<StatefulWidget> createState() {
    return BotsListWidgetState(gameInfo, gameListUpdateCallback);
  }

}

class BotsListWidgetState extends State<BotsListWidget> {

  final GameInfo gameInfo;
  final Function() botListUpdateCallback;
  List<BotInfo> bots = List<BotInfo>();

  BotsListWidgetState(this.gameInfo, this.botListUpdateCallback);

  @override
  void initState() {
    super.initState();
    setState(() {
      bots = gameInfo.botInfoList;
    });
  }

  Widget _buildBotTile(BuildContext context, int index) {
    return new BotListElementWidget(bots[index], (bot) => _updateBot(bot, index));
  }

  void _updateBot(BotInfo bot, int index) {
    setState(() {
      bots[index] = bot;
      botListUpdateCallback();
    });
  }

  void _addBot(BotInfo bot) {
    setState(() {
      bots.add(bot);
      botListUpdateCallback();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      children: <Widget>[
        bots.isEmpty ? Text("No bot to display") :
        Column(
          children: new List.generate(bots.length,
                (index) => _buildBotTile(context, index)).toList(),
        ),
        RaisedButton(
          child: Text("Create new bot"),
          onPressed: () => _createBot(gameInfo),
        )
      ]
    );
  }

  void _createBot(GameInfo game) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BotCreationWidget(
              game: game,
              botListUpdateCallback: (bot) => _addBot(bot),
          )
        )
    );
  }

}