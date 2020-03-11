
import 'dart:collection';

import 'package:bot_manager_mobile_app/models/bot_model.dart';
import 'package:bot_manager_mobile_app/models/bot_property_model.dart';
import 'package:bot_manager_mobile_app/models/game_model.dart';
import 'package:bot_manager_mobile_app/resources/api_provider.dart';
import 'package:bot_manager_mobile_app/theme.dart';
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
      body: BotDetailsCreationWidget(game)
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
          backgroundColor: AppColors.greyColor,
          title: Text("Bot edition : ${troncateStr(bot.login, 15)}"),
        ),
        body: BotDetailsEditionWidget(bot)
    );
  }

  String troncateStr(String str, int size) {
    if (str.length <= size) {
      return str;
    }
    return str.substring(0, size) + "...";
  }

}

abstract class BotDetailsWidget extends StatefulWidget {

  final Map<String, dynamic> Function() propsBuilder;

  BotDetailsWidget({
    this.propsBuilder
  });

}

abstract class BotDetailsState extends State<BotDetailsWidget> {

  Map<String, dynamic> _props = HashMap();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _props.length,
      itemBuilder: ((context, index) {
        String key = _props.keys.elementAt(index);
        return new ListTile(
          title: new Text("$key"),
          subtitle: new Text("${_props[key]}"),
        );
      })
    );
    return Text("Details of bot");
  }

  void refresh();

}

class BotDetailsEditionWidget extends BotDetailsWidget {

  final BotInfo bot;

  BotDetailsEditionWidget(this.bot);

  @override
  State createState() {
    return BotDetailsEditionState(bot);
  }


}

class BotDetailsEditionState extends BotDetailsState {

  final BotInfo bot;

  BotDetailsEditionState(this.bot);

  @override
  void refresh() {
    setState(() {
      _isLoading = true;
    });
    ApiProvider.load(ApiProvider.getBotPropertiesResource(bot.id)).then((botProps) {
      ApiProvider.load(ApiProvider.getGamePropertiesResource(bot.gameId)).then((props) {
        setState(() {
          _props = Map.fromIterable(props.botProperties, key: (e) => e.key,
              value: (e) => botProps[e.key]);
          _isLoading = false;
        });
      });
    });
  }

}

class BotDetailsCreationWidget extends BotDetailsWidget {

  final GameInfo game;

  BotDetailsCreationWidget(this.game);

  @override
  State<StatefulWidget> createState() {
    return BotDetailsCreationState(this.game);
  }

}

class BotDetailsCreationState extends BotDetailsState {

  final GameInfo game;

  BotDetailsCreationState(this.game);

  @override
  void refresh() {
    setState(() {
      _isLoading = true;
    });
    ApiProvider.load(ApiProvider.getGamePropertiesResource(game.id)).then((props) {
      setState(() {
        _props = Map.fromIterable(props.botProperties, key: (e) => e.key, value: (e) => e.defaultValue);
        _isLoading = false;
      });
    });
  }

}