import 'package:bot_manager_mobile_app/models/game_model.dart';
import 'package:bot_manager_mobile_app/widgets/bot_detail_main_widget.dart';
import 'package:bot_manager_mobile_app/models/bot_model.dart';
import 'package:flutter/material.dart';

import 'custom/bot_utils.dart';

class BotListElementWidget extends StatefulWidget {
  final BotInfo bot;
  final GameInfo game;

  BotListElementWidget(this.game, this.bot);

  @override
  State<StatefulWidget> createState() {
    return new BotListElementState(game, bot);
  }
}

class BotListElementState extends State<BotListElementWidget> with SingleTickerProviderStateMixin {
  GameInfo game;
  BotInfo bot;

  BotListElementState(this.game, this.bot);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(
          bot.login,
        ),
        leading: buildStateIcon(bot.state),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => BotDetailMainWidget(game, bot)));
        },
        trailing: buildBotPopupMenuButton(bot, refreshBot));
  }

  void refreshBot(BotInfo newBot) {
    setState(() {
      this.bot.state = newBot.state;
      this.bot.availableTransitions = newBot.availableTransitions;
    });
  }

}
