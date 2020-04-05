import 'package:bot_manager_mobile_app/models/bot_model.dart';
import 'package:bot_manager_mobile_app/models/bot_operation_model.dart';
import 'package:bot_manager_mobile_app/models/game_model.dart';
import 'package:bot_manager_mobile_app/resources/api_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'bot_operation_process_widget.dart';

class BotOperationsWidget extends StatefulWidget {
  final BotInfo bot;
  final GameInfo game;

  BotOperationsWidget(this.bot, this.game);

  @override
  State<StatefulWidget> createState() {
    return BotOperationState(bot, game);
  }
}

class BotOperationState extends State<BotOperationsWidget> {
  final BotInfo bot;
  final GameInfo game;

  BotOperationState(this.bot, this.game);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BotOperationList>(
        future: ApiProvider.httpGet(ApiProvider.getBotOperationsResource(bot.id)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data.botOperations.isNotEmpty) {
              return ListView.builder(
                  itemCount: snapshot.data.botOperations.length,
                  itemBuilder: (context, index) {
                    return buildBotOperationTile(context, snapshot.data.botOperations[index]);
                  });
            } else if (snapshot.hasError) {
              return new Text(
                "${snapshot.error}",
              );
            }
            return Center(
              child: Text(
                "No operation for this bot",
              ),
            );
          }
          return Column(
            children: <Widget>[LinearProgressIndicator(), Spacer()],
          );
        });
  }

  Widget buildBotOperationTile(BuildContext context, BotOperation botOperation) {
    return ListTile(
      title: Text(
        botOperation.label,
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BotOperationProcessWidget(
                      bot: bot,
                      botOperation: botOperation,
                    )));
      },
    );
  }
}
