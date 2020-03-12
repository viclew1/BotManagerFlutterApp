import 'package:bot_manager_mobile_app/models/bot_model.dart';
import 'package:bot_manager_mobile_app/resources/api_provider.dart';
import 'package:flutter/material.dart';

import '../theme.dart';
import 'bot_detail_widget.dart';

class BotListElementWidget extends StatefulWidget {

  final BotInfo bot;

  BotListElementWidget(this.bot);

  @override
  State<StatefulWidget> createState() {
    return new BotListElementState(bot);
  }

}

class BotListElementState extends State<BotListElementWidget> with SingleTickerProviderStateMixin {

  BotInfo _bot;
  bool _isLoading = false;

  BotListElementState(this._bot);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(_bot.login, style: TextStyle(fontSize: 18)),
      subtitle: Text('Bot state : ${_bot.state}'),
      trailing: Container(
        width: 160,
        child: ButtonBar(
         children: <Widget>[
           if (_bot.availableTransitions.contains("START")) _startFab(_bot),
           if (_bot.availableTransitions.contains("STOP")) _stopFab(_bot),
           _editFab(_bot)
         ],
        )
      )
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
                bot: bot
            )
        )
    );
  }

  void refreshBot(BotInfo bot) {
    ApiProvider.httpGet(ApiProvider.getBotInfoResource(bot.id)).then((bot) {
      setState(() {
        this._bot = bot;
        _isLoading = false;
      });
    });
  }

}