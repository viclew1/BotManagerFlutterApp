import 'package:bot_manager_mobile_app/blocs/bot_detail_widget.dart';
import 'package:bot_manager_mobile_app/models/bot_model.dart';
import 'package:bot_manager_mobile_app/models/game_model.dart';
import 'package:bot_manager_mobile_app/resources/api_provider.dart';
import 'package:bot_manager_mobile_app/theme.dart';
import 'package:flutter/material.dart';

class BotsListWidget extends StatefulWidget {

  final GameInfo gameInfo;

  BotsListWidget({
    this.gameInfo
  });

  @override
  State<StatefulWidget> createState() {
    return BotsListWidgetState(
      gameInfo: gameInfo
    );
  }

}

class BotsListWidgetState extends State<BotsListWidget> {

  final GameInfo gameInfo;
  List<BotInfo> bots = List<BotInfo>();

  BotsListWidgetState({
    this.gameInfo
  });

  @override
  void initState() {
    super.initState();
    this.bots = gameInfo.botInfoList;
  }

  void refreshBots() {
    bots = gameInfo.botInfoList;
  }

  ListTile _buildBotTile(BuildContext context, int index) {
    return ListTile(
        title: Text(bots[index].login, style: TextStyle(fontSize: 18)),
        subtitle: Text('Bot state : ${bots[index].state}'),
        onTap: () => _openBot(bots[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: <Widget>[
          bots.isEmpty ? Text("No bot to display") :
          ListView.builder(
            itemCount: bots.length,
            itemBuilder: _buildBotTile,
          ),
          RaisedButton(
            child: Text("Create new bot"),
            onPressed: () => _createBot(gameInfo),
          )
        ]
    );
  }

  void _openBot(BotInfo bot) {
    print('open ${bot.login}');
  }

  void _createBot(GameInfo game) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BotCreationWidget(
              game: game
          )
        )
    );
  }

}