import 'package:bot_manager_mobile_app/models/bot_model.dart';
import 'package:bot_manager_mobile_app/resources/api_provider.dart';
import 'package:flutter/material.dart';

import '../theme.dart';
import 'bot_detail_widget.dart';

class BotListElementWidget extends StatefulWidget {

  final BotInfo bot;
  final Function(BotInfo bot) botListUpdateCallback;

  BotListElementWidget(this.bot, this.botListUpdateCallback);

  @override
  State<StatefulWidget> createState() {
    return new BotListElementState(bot, botListUpdateCallback);
  }

}

class BotListElementState extends State<BotListElementWidget> with SingleTickerProviderStateMixin {

  BotInfo _bot;
  Function(BotInfo bot) botListUpdateCallback;
  bool _isLoading = false;

  BotListElementState(this._bot, this.botListUpdateCallback);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(_bot.login, style: TextStyle(fontSize: 18)),
      subtitle: Text('Bot state : ${_bot.state}'),
      trailing: PopupMenuButton(
        color: AppColors.greyColor,
        onSelected: (value) {
          switch (value) {
            case "EDIT": return _editBot(_bot);
            default:
              return _processBotTransition(_bot, value);
          }
        },
        itemBuilder: (context) {
          return _buildBotPopupMenuItems();
        }
      )
    );
  }

  List<PopupMenuEntry<String>> _buildBotPopupMenuItems() {
    return [
      _buildBotPopupMenuItem("EDIT", "Edit bot", Icons.edit),
      if (_bot.availableTransitions.contains("START")) _buildBotPopupMenuItem("START", "Start bot", Icons.play_arrow),
      if (_bot.availableTransitions.contains("STOP")) _buildBotPopupMenuItem("STOP", "Stop bot", Icons.stop),
    ];
  }

  PopupMenuEntry<String> _buildBotPopupMenuItem(String value, String text, IconData iconData, [Function onTap]) {
    return PopupMenuItem(
      value: value,
      child: ListTile(
        title: Text(
          text,
          style: TextStyle(
              color: AppColors.whiteColor
          ),
        ),
        leading: Icon(
          iconData,
          color: AppColors.whiteColor,
        ),
      ),
    );
  }

  Widget _startFab(BotInfo bot) {
    return FlatButton(
      disabledTextColor: AppColors.blackColor,
      color: AppColors.greyColor,
      disabledColor: AppColors.greyColor,
      textColor: AppColors.whiteColor,
      child: Icon(Icons.play_arrow),
      onPressed: _isLoading ? null : () => _processBotTransition(bot, "START"),
    );
  }

  Widget _stopFab(BotInfo bot) {
    return FlatButton(
      disabledTextColor: AppColors.blackColor,
      color: AppColors.greyColor,
      disabledColor: AppColors.greyColor,
      textColor: AppColors.whiteColor,
      child: Icon(Icons.stop),
      onPressed: _isLoading ? null : () => _processBotTransition(bot, "STOP"),
    );
  }

  Widget _editFab(BotInfo bot) {
    return FlatButton(
      disabledTextColor: AppColors.blackColor,
      color: AppColors.greyColor,
      disabledColor: AppColors.greyColor,
      textColor: AppColors.whiteColor,
      child: Icon(Icons.edit),
      onPressed: _isLoading ? null : () => _editBot(bot),
    );
  }

  void _processBotTransition(BotInfo bot, String transition) {
    setState(() {
      _isLoading = true;
    });
    ApiProvider.httpPost(ApiProvider.postTransition(bot.id, transition)).then((nothing) {
      refreshBot(bot);
    });
  }

  void _editBot(BotInfo bot) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BotEditionWidget(
                bot: bot,
                botListUpdateCallback: refreshBot,
            )
        )
    );
  }

  void refreshBot(BotInfo bot) {
    ApiProvider.httpGet(ApiProvider.getBotInfoResource(bot.id)).then((bot) {
      setState(() {
        botListUpdateCallback(bot);
        this._bot = bot;
        _isLoading = false;
      });
    });
  }

}