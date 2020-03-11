
import 'package:bot_manager_mobile_app/models/bot_model.dart';
import 'package:bot_manager_mobile_app/models/game_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BotCreationWidget extends StatelessWidget {

  final GameInfo game;

  BotCreationWidget({
    this.game
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bot creation : ${game.name}"),
      ),
      body: _botDetailsWidget()
    );
  }

}

class BotEditionWidget extends StatelessWidget {

  final BotInfo bot;

  BotEditionWidget({
    this.bot
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Bot edition : ${bot.login}"),
        ),
        body: _botDetailsWidget()
    );
  }

}

class BotDetailsWidget extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return null;
  }

}

Widget _botDetailsWidget() {
  return Text("Details of bot");
}