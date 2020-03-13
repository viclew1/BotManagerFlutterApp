
import 'dart:collection';

import 'package:bot_manager_mobile_app/models/bot_model.dart';
import 'package:bot_manager_mobile_app/models/bot_property_model.dart';
import 'package:bot_manager_mobile_app/models/game_model.dart';
import 'package:bot_manager_mobile_app/resources/api_provider.dart';
import 'package:bot_manager_mobile_app/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BotCreationWidget extends StatelessWidget {

  final GameInfo game;
  final Function(BotInfo bot) botListUpdateCallback;

  BotCreationWidget({
    this.game,
    this.botListUpdateCallback
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bot creation : ${game.name}"),
      ),
      body: BotDetailsCreationWidget(game, botListUpdateCallback)
    );
  }

}

class BotEditionWidget extends StatelessWidget {

  final BotInfo bot;
  final Function(BotInfo bot) botListUpdateCallback;

  BotEditionWidget({
    this.bot,
    this.botListUpdateCallback
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.greyColor,
          title: Text("Bot edition : ${troncateStr(bot.login, 15)}"),
        ),
        body: BotDetailsEditionWidget(bot, this.botListUpdateCallback)
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

  Map<BotProperty, dynamic> _props = HashMap();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _buildPropertiesEditionWidget(),
        if (_isLoading)
          Center(
            child: CircularProgressIndicator()
          ),
      ]
    );
  }

  void refresh();

  Widget _buildPropertiesEditionWidget() {
    return ListView.builder(
        itemCount: _props.length,
        itemBuilder: ((context, index) {
          BotProperty key = _props.keys.elementAt(index);
          return _buildPropertyTile(key);
        })
    );
  }

  Widget _buildPropertyTile(BotProperty key) {
    if (key.acceptedValues.isNotEmpty) {

    }
    switch (key.type) {
      case "BOOLEAN":
        return SwitchListTile(
            title: new Text("${key.key}"),
            value: _props[key],
            onChanged: (value) {
              setState(() {
                _props[key] = value;
              });
            },
        );
      case "INTEGER":
        return ListTile(
          title: new Text("${key.key}"),
          trailing: Container(
            width: 70,
            child: TextFormField(
              initialValue: _props[key]?.toString(),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              inputFormatters: <TextInputFormatter>[
                WhitelistingTextInputFormatter.digitsOnly
              ], // Only numbers can be entered
            ),
          ),
        );
      case "STRING":
        return ListTile(
          title: new Text("${key.key}"),
          trailing: Container(
            width: 70,
            child: TextFormField(
              initialValue: _props[key]?.toString(),
            ),
          ),
        );
      case "":
        return SwitchListTile(title: new Text("${key.key}"));
    }
    return new ListTile(
      title: new Text("${key.key}"),
      subtitle: new Text("${_props[key]}"),
    );
  }

}

class BotDetailsEditionWidget extends BotDetailsWidget {

  final BotInfo bot;
  final Function(BotInfo bot) botListUpdateCallback;

  BotDetailsEditionWidget(this.bot, this.botListUpdateCallback);

  @override
  State createState() {
    return BotDetailsEditionState(bot, this.botListUpdateCallback);
  }


}

class BotDetailsEditionState extends BotDetailsState {

  final BotInfo bot;
  final Function(BotInfo bot) botListUpdateCallback;

  BotDetailsEditionState(this.bot, this.botListUpdateCallback);

  @override
  void refresh() {
    setState(() {
      _isLoading = true;
    });
    ApiProvider.httpGet(ApiProvider.getBotPropertiesResource(bot.id)).then((botProps) {
      ApiProvider.httpGet(ApiProvider.getGamePropertiesResource(bot.gameId)).then((props) {
        setState(() {
          _props = Map.fromIterable(props.botProperties, key: (e) => e,
              value: (e) => botProps[e.key]);
          _isLoading = false;
        });
      });
    });
  }

}

class BotDetailsCreationWidget extends BotDetailsWidget {

  final GameInfo game;
  final Function(BotInfo bot) botListUpdateCallback;

  BotDetailsCreationWidget(this.game, this.botListUpdateCallback);

  @override
  State<StatefulWidget> createState() {
    return BotDetailsCreationState(this.game, this.botListUpdateCallback);
  }

}

class BotDetailsCreationState extends BotDetailsState {

  final GameInfo game;
  final Function(BotInfo bot) botListUpdateCallback;

  BotDetailsCreationState(this.game, this.botListUpdateCallback);

  @override
  void refresh() {
    setState(() {
      _isLoading = true;
    });
    ApiProvider.httpGet(ApiProvider.getGamePropertiesResource(game.id)).then((props) {
      setState(() {
        _props = Map.fromIterable(props.botProperties, key: (e) => e, value: (e) => e.defaultValue);
        _isLoading = false;
      });
    });
  }

}