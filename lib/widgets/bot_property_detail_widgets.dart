import 'dart:collection';
import 'dart:convert';

import 'package:bot_manager_mobile_app/models/bot_model.dart';
import 'package:bot_manager_mobile_app/models/bot_operation_model.dart';
import 'package:bot_manager_mobile_app/models/bot_property_model.dart';
import 'package:bot_manager_mobile_app/models/game_model.dart';
import 'package:bot_manager_mobile_app/resources/api_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'custom/game_appbar_builder.dart';

class BotCreationWidget extends StatelessWidget {
  final GameInfo game;

  BotCreationWidget({this.game});

  @override
  Widget build(BuildContext context) {
    return BotDetailsCreationWidget(game);
  }
}

class BotEditionWidget extends StatelessWidget {
  final BotInfo bot;

  BotEditionWidget({this.bot});

  @override
  Widget build(BuildContext context) {
    return BotDetailsEditionWidget(bot);
  }
}

abstract class BotDetailsWidget extends StatefulWidget {
  final Map<String, dynamic> Function() propsBuilder;

  BotDetailsWidget({this.propsBuilder});
}

abstract class BotDetailsState extends State<BotDetailsWidget> {
  Map<BotProperty, dynamic> initialProps;
  Map<BotProperty, dynamic> props;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getProperties().then((value) {
      setState(() {
        isLoading = false;
        this.initialProps = value.map((k, v) => MapEntry(k, v));
        this.props = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Builder(builder: buildBody),
      floatingActionButton: Builder(builder: buildFab),
    );
  }

  Widget buildBody(BuildContext context) {
    return isLoading ? LinearProgressIndicator() : _buildPageContentWidget(props);
  }

  Widget buildFab(BuildContext context) {
    if (!isLoading) {
      return buildValidButton(context);
    }
    return Container();
  }

  PreferredSizeWidget buildAppBar(BuildContext context);

  Widget buildValidButton(BuildContext context);

  Future<Map<BotProperty, dynamic>> getProperties();

  bool propertiesFilled() {
    return props.keys.where((e) => e.needed && !e.nullable).where((e) => props[e] == null || props[e].toString().isEmpty).isEmpty;
  }

  bool valueChanged() {
    return initialProps.entries.where((e) => initialProps[e.key].toString() != props[e.key].toString()).isNotEmpty;
  }

  Map<String, String> buildPropsAsMapStringString() {
    Map<String, String> propsStrStr = HashMap();
    props.entries.where((e) => e.value != null).forEach((e) => propsStrStr[e.key.key] = e.value.toString());
    return propsStrStr;
  }

  Widget _buildPageContentWidget(Map<BotProperty, dynamic> props);

  Widget _buildPropertyTile(Map<BotProperty, dynamic> props, BotProperty key) {
    if (key.acceptedValues.isNotEmpty) {}
    switch (key.type) {
      case "BOOLEAN":
        return SwitchListTile(
          activeColor: Theme.of(context).primaryColor,
          activeTrackColor: Theme.of(context).accentColor,
          title: new Text(
            "${key.key}",
          ),
          value: props[key],
          onChanged: (value) {
            setState(() {
              props[key] = value;
            });
          },
        );
      case "INTEGER":
      case "FLOAT":
        return ListTile(
          title: new Text(
            "${key.key}",
          ),
          trailing: Container(
            width: 70,
            child: TextFormField(
              onChanged: (value) {
                setState(() {
                  props[key] = value;
                });
              },
              initialValue: props[key]?.toString(),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly], // Only numbers can be entered
            ),
          ),
        );
      default:
        return ListTile(
          title: new Text(
            "${key.key}",
          ),
          trailing: Container(
            width: 70,
            child: TextFormField(
              onChanged: (value) {
                setState(() {
                  props[key] = value;
                });
              },
              initialValue: props[key]?.toString(),
            ),
          ),
        );
    }
  }
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
  Future<Map<BotProperty, dynamic>> getProperties() async {
    Map<String, dynamic> botPropsMap = await ApiProvider.httpGet(ApiProvider.getBotPropertiesResource(bot.id));
    BotPropertyList botPropertyList = await ApiProvider.httpGet(ApiProvider.getGamePropertiesResource(bot.gameId));
    return Map.fromIterable(botPropertyList.botProperties, key: (e) => e, value: (e) => botPropsMap[e.key]);
  }

  @override
  Widget buildValidButton(BuildContext context) {
    return !valueChanged()
        ? Container()
        : FloatingActionButton(
            child: Icon(Icons.save),
            onPressed: valueChanged() ? () => updateBot(context) : null,
          );
  }

  void updateBot(BuildContext context) {
    ApiProvider.httpPost(ApiProvider.updateBotPropertiesResource(bot.id), buildPropsAsMapStringString()).then((value) {
      final snackBar = SnackBar(
        content: Text('Bot updated'),
      );
      setState(() {
        initialProps.keys.forEach((k) {
          initialProps[k] = value[k.key];
          props[k] = value[k.key];
        });
        Scaffold.of(context).showSnackBar(snackBar);
      });
    });
  }

  @override
  PreferredSizeWidget buildAppBar(BuildContext context) {
    return null;
  }

  @override
  Widget _buildPageContentWidget(Map<BotProperty, dynamic> props) {
    if (props.isEmpty) {
      return Center(
        child: Text(
          "No bot properties.",
        ),
      );
    }
    return ListView.builder(
        itemCount: props.length,
        itemBuilder: (context, index) {
          return _buildPropertyTile(props, props.keys.elementAt(index));
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
  String login = "a@b.c";
  String password = "secret";

  BotDetailsCreationState(this.game);

  @override
  Future<Map<BotProperty, dynamic>> getProperties() async {
    BotPropertyList botPropertyList = await ApiProvider.httpGet(ApiProvider.getGamePropertiesResource(game.id));
    return Map.fromIterable(botPropertyList.botProperties, key: (e) => e, value: (e) => e.defaultValue);
  }

  @override
  Widget buildValidButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.check),
      onPressed: () {
        Map<String, dynamic> body = HashMap();
        body["login"] = login;
        body["password"] = password;
        body["params"] = buildPropsAsMapStringString();
        ApiProvider.httpPost(ApiProvider.createBotResource(game.id), body).then((value) {
          final snackBar = SnackBar(
            content: Text('Bot created'),
          );
          Navigator.pop(context, true);
          Scaffold.of(context).showSnackBar(snackBar);
        });
      },
    );
  }

  @override
  PreferredSizeWidget buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(MediaQuery.of(context).size.height / 6),
      child: AppBar(
        flexibleSpace: buildBackground(NetworkImage(game.iconPath), game.name, "Bot creation"),
      ),
    );
  }

  @override
  Widget _buildPageContentWidget(Map<BotProperty, dynamic> props) {
    List<Widget> widgets = List();
    widgets.add(buildTextEditionTile("Login", login, (value) {
      setState(() {
        this.login = value;
      });
    }));
    widgets.add(buildTextEditionTile("Password", password, (value) {
      setState(() {
        this.password = value;
      });
    }));
    for (BotProperty bp in props.keys) {
      widgets.add(_buildPropertyTile(props, bp));
    }
    return ListView(
      children: widgets,
    );
  }

  Widget buildTextEditionTile(String text, String initialValue, Function(String) onChanged) {
    return ListTile(
      title: new Text(
        text,
      ),
      trailing: Container(
        width: 70,
        child: TextFormField(
          onChanged: onChanged,
          initialValue: initialValue,
        ),
      ),
    );
  }
}

class BotOperationProcessWidget extends BotDetailsWidget {
  final BotInfo bot;
  final BotOperation botOperation;

  BotOperationProcessWidget({this.bot, this.botOperation});

  @override
  State<StatefulWidget> createState() {
    return BotOperationProcessState(this.bot, this.botOperation);
  }
}

class BotOperationProcessState extends BotDetailsState {
  final BotInfo bot;
  final BotOperation botOperation;
  OperationResult result;

  BotOperationProcessState(this.bot, this.botOperation);

  @override
  Future<Map<BotProperty, dynamic>> getProperties() async {
    List<BotProperty> botProperties = botOperation.params;
    return Map.fromIterable(botProperties, key: (e) => e, value: (e) => e.defaultValue);
  }

  @override
  Widget buildValidButton(BuildContext context) {
    return !propertiesFilled()
        ? Container()
        : FloatingActionButton(
            child: Icon(Icons.play_arrow),
            onPressed: () {
              ApiProvider.httpPost(ApiProvider.postCallOperationResource(bot.id, botOperation.id), buildPropsAsMapStringString())
                ..then((value) {
                  final snackBar = SnackBar(
                    content: Text("Operation processed"),
                  );
                  Scaffold.of(context).showSnackBar(snackBar);
                  setState(() {
                    result = value;
                  });
                })
                ..catchError((error) {
                  final snackBar = SnackBar(
                    content: Text("Operation processed"),
                  );
                  Scaffold.of(context).showSnackBar(snackBar);
                  setState(() {
                    result = OperationResult(isSuccess: false, message: "Error", content: error.message);
                  });
                });
            },
          );
  }

  @override
  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(botOperation.label),
    );
  }

  @override
  Widget _buildPageContentWidget(Map<BotProperty, dynamic> props) {
    return Column(
      children: List()
        ..add(Expanded(
            flex: 6,
            child: props.isEmpty
                ? Center(
                    child: Text(
                    "No parameter for this operation.",
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                  ))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: props.length,
                    itemBuilder: (context, index) {
                      return _buildPropertyTile(props, props.keys.elementAt(index));
                    })))
        ..add(Divider(indent: 30, endIndent: 30, thickness: 5))
        ..add(Text("Result :", style: TextStyle(fontSize: 25)))
        ..add(
          Expanded(
            flex: 4,
            child: result == null
                ? Container()
                : ListTile(
                    title: Text(
                      result.message,
                      style: TextStyle(
                        fontSize: 25,
                        color: result.isSuccess ? Colors.green : Colors.red,
                      ),
                    ),
                    subtitle: buildResultWidget(),
                  ),
          ),
        ),
    );
  }

  Widget buildResultWidget() {
    if (result.content == null) {
      return Container();
    }
    switch (result.resultType) {
      case "OBJECT":
        return buildObjectResult(result.content);
      default:
        return Text(result.content.toString());
    }
  }

  Widget buildObjectResult(Map<String, dynamic> contentObj, [bool scrollable = true]) {
    List<MapEntry<String, dynamic>> jsonEntries = contentObj.entries.toList();
    return ListView.builder(
      physics: scrollable ? null : NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: jsonEntries.length,
      itemBuilder: (context, index) {
        if (jsonEntries[index].value is List) {
          List valueList = jsonEntries[index].value as List;
          return Column(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(jsonEntries[index].key),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: valueList.length,
                  itemBuilder: (context, index) {
                    if (valueList[index] is Map<String, dynamic>) {
                      return buildObjectResult(valueList[index] as Map<String, dynamic>, false);
                    }
                    return TextFormField(
                      enabled: false,
                      initialValue: valueList[index].toString(),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider();
                  },
                ),
              ),
            ],
          );
        }
        if (jsonEntries[index].value is Map<String, dynamic>) {
          return Column(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(jsonEntries[index].key),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: buildObjectResult(jsonEntries[index].value as Map<String, dynamic>, false),
              ),
            ],
          );
        }
        if (jsonEntries[index].value == null) {
          return Container();
        }
        return Row(
          children: <Widget>[
            Flexible(
              flex: 1,
              child: new Text(
                jsonEntries[index].key,
              ),
              fit: FlexFit.tight,
            ),
            Flexible(
              flex: 1,
              child: TextFormField(
                enabled: false,
                initialValue: jsonEntries[index].value.toString(),
              ),
              fit: FlexFit.tight,
            ),
          ],
        );
      },
    );
  }
}
