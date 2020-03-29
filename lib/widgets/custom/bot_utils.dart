

import 'package:bot_manager_mobile_app/models/bot_model.dart';
import 'package:bot_manager_mobile_app/resources/api_provider.dart';
import 'package:flutter/material.dart';

PopupMenuButton buildBotPopupMenuButton(BotInfo bot, Function(BotInfo) refresh) {
  return PopupMenuButton(
      icon: Icon(
        Icons.more_vert,
      ),
      onSelected: (value) {
        return _processBotTransition(bot, value, refresh);
      },
      itemBuilder: (context) {
        return _buildBotPopupMenuItems(bot);
      });
}

List<PopupMenuEntry<String>> _buildBotPopupMenuItems(BotInfo bot) {
  return [
    if (bot.availableTransitions.contains("START")) _buildBotPopupMenuItem("START", "Start bot", Icons.play_arrow),
    if (bot.availableTransitions.contains("STOP")) _buildBotPopupMenuItem("STOP", "Stop bot", Icons.stop),
  ];
}

PopupMenuEntry<String> _buildBotPopupMenuItem(String value, String text, IconData iconData, [Function onTap]) {
  return PopupMenuItem(
    value: value,
    child: ListTile(
      title: Text(
        text,
      ),
      leading: Icon(
        iconData,
      ),
    ),
  );
}

void _processBotTransition(BotInfo bot, String transition, Function(BotInfo) refresh) {
  ApiProvider.httpPost(ApiProvider.postTransition(bot.id, transition)).then((nothing) {
    ApiProvider.httpGet(ApiProvider.getBotInfoResource(bot.id)).then((newBot) {
      refresh(newBot);
    });
  });
}

Widget buildStateIcon(String state) {
  Color color;
  switch (state) {
    case "ACTIVE":
      color = Colors.green;
      break;
    case "CRASHED":
      color = Colors.amber;
      break;
    case "STOPPED":
      color = Colors.red;
      break;
    default:
      color = Colors.grey;
      break;
  }
  return Icon(
    Icons.computer,
    color: color,
  );
}