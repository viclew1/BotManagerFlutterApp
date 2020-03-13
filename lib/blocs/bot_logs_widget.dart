import 'package:bot_manager_mobile_app/models/bot_model.dart';
import 'package:flutter/cupertino.dart';

class BotLogsWidget extends StatefulWidget {

  final BotInfo bot;

  BotLogsWidget(this.bot);

  @override
  State<StatefulWidget> createState() {
    return BotLogsState(bot);
  }

}

class BotLogsState extends State<BotLogsWidget> {

  final BotInfo bot;

  BotLogsState(this.bot);


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }

}