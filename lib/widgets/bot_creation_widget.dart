import 'dart:collection';

import 'package:bot_manager_mobile_app/models/bot_property_model.dart';
import 'package:bot_manager_mobile_app/models/game_model.dart';
import 'package:bot_manager_mobile_app/resources/api_provider.dart';
import 'package:bot_manager_mobile_app/widgets/custom/bot_property_detail_widgets.dart';
import 'package:bot_manager_mobile_app/widgets/custom/drawer_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'custom/game_appbar_builder.dart';

class BotCreationWidget extends StatefulWidget {
  final GameInfo game;

  BotCreationWidget({this.game});

  @override
  State<StatefulWidget> createState() {
    return BotCreationState(this.game);
  }
}

class BotCreationState extends State<BotCreationWidget> {
  GameInfo game;
  String login;

  Map<BotProperty, dynamic> props;
  Map<BotProperty, dynamic> loginProps;

  BotPropertiesWidget propsWidget;
  BotPropertiesWidget loginPropsWidget;
  bool loading = true;

  BotCreationState(this.game) {
    update();
  }

  void update() async {
    var gameProperties = await ApiProvider.httpGet(ApiProvider.getGamePropertiesResource(game.id));
    props = Map.fromIterable(gameProperties.botProperties, key: (e) => e, value: (e) => e.defaultValue);
    var gameLoginProperties = await ApiProvider.httpGet(ApiProvider.getGameLoginPropertiesResource(game.id));
    loginProps = Map.fromIterable(gameLoginProperties.botProperties, key: (e) => e, value: (e) => e.defaultValue);
    loginPropsWidget = BotPropertiesWidget(loginProps, setState);
    propsWidget = BotPropertiesWidget(props, setState);
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildDrawer(context, setState),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height / 6),
        child: AppBar(
          flexibleSpace: buildBackground(NetworkImage(game.iconPath), game.name, "Bot creation"),
        ),
      ),
      body: buildBody(context),
      floatingActionButton: loading || login == null || login.isEmpty || !propsWidget.propertiesFilled() || !loginPropsWidget.propertiesFilled() ? null : FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () {
                Map<String, dynamic> body = HashMap();
                body["login"] = login;
                body["login_properties"] = loginPropsWidget.buildPropsAsMapStringString();
                body["params"] = propsWidget.buildPropsAsMapStringString();
                ApiProvider.httpPost(ApiProvider.createBotResource(game.id), body).then((value) {
                  final snackBar = SnackBar(
                    content: Text('Bot created'),
                  );
                  Navigator.pop(context, true);
                  Scaffold.of(context).showSnackBar(snackBar);
                });
              },
      ),
    );
  }

  buildBody(BuildContext context) {
    return loading
        ? LinearProgressIndicator()
        : ListView(
            children: <Widget>[
              ListTile(
                title: new Text("Login"),
                trailing: Container(
                  width: 70,
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        login = value;
                      });
                    },
                    textAlign: TextAlign.center,
                    initialValue: login,
                  ),
                ),
              ),
              loginPropsWidget = BotPropertiesWidget(loginProps, setState),
              Divider(),
              props.isEmpty
                  ? Center(
                  child: Text(
                    "No parameter for this operation.",
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                  ))
                  : propsWidget
            ],
          );
  }

}
