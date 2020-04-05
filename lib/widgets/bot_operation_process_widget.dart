import 'package:bot_manager_mobile_app/models/bot_model.dart';
import 'package:bot_manager_mobile_app/models/bot_operation_model.dart';
import 'package:bot_manager_mobile_app/models/bot_property_model.dart';
import 'package:bot_manager_mobile_app/resources/api_provider.dart';
import 'package:bot_manager_mobile_app/widgets/custom/bot_property_detail_widgets.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BotOperationProcessWidget extends StatefulWidget {
  final BotInfo bot;
  final BotOperation botOperation;

  BotOperationProcessWidget({this.bot, this.botOperation});

  @override
  State<StatefulWidget> createState() {
    return BotOperationProcessState(this.bot, this.botOperation);
  }
}

class BotOperationProcessState extends State<BotOperationProcessWidget> {
  final BotInfo bot;
  final BotOperation botOperation;
  OperationResult result;

  Map<BotProperty, dynamic> props;
  BotPropertiesWidget propsWidget;

  BotOperationProcessState(this.bot, this.botOperation) {
    List<BotProperty> botProperties = botOperation.params;
    props = Map.fromIterable(botProperties, key: (e) => e, value: (e) => e.defaultValue);
    propsWidget = BotPropertiesWidget(props, setState);
  }

  Widget buildValidButton(BuildContext context) {
    return !propsWidget.propertiesFilled()
        ? Container()
        : FloatingActionButton(
            child: Icon(Icons.play_arrow),
            onPressed: () {
              ApiProvider.httpPost(ApiProvider.postCallOperationResource(bot.id, botOperation.id), propsWidget.buildPropsAsMapStringString())
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

  Widget _buildPageContentWidget() {
    return Column(
      children: List()
        ..add(Expanded(
            flex: 3,
            child: props.isEmpty
                ? Center(
                    child: Text(
                    "No parameter for this operation.",
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                  ))
                : propsWidget))
        ..add(Divider(indent: 30, endIndent: 30, thickness: 5))
        ..add(Text("Result :", style: TextStyle(fontSize: 25)))
        ..add(
          Expanded(
            flex: 7,
            child: result == null
                ? Container()
                : ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      ExpansionTileCard(
                        title: Text(
                          result.message,
                          style: TextStyle(
                            fontSize: 25,
                            color: result.isSuccess ? Theme.of(context).accentColor : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        children: <Widget>[
                          Divider(thickness: 4, indent: 10, endIndent: 10),
                          result.content == null || result.content.toString().isEmpty
                              ? Padding(
                                  padding: EdgeInsets.only(top: 50, bottom: 50),
                                  child: Text(
                                    "Empty result content",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                )
                              : Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: buildResultWidget(),
                                ),
                        ],
                      ),
                    ],
                  ),
          ),
        )
        ..add(Expanded(flex: 1, child: Container())),
    );
  }

  Widget buildResultWidget() {
    switch (result.resultType) {
      case "OBJECT":
        return buildObjectResult(result.content);
      default:
        return Text(result.content.toString());
    }
  }

  Widget buildObjectResult(Map<String, dynamic> contentObj) {
    List<MapEntry<String, dynamic>> jsonEntries = contentObj.entries.toList();
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: jsonEntries.length,
      itemBuilder: (context, index) {
        var item = jsonEntries[index];
        if (item.value is List) {
          var itemList = item.value as List;
          return ExpansionTileCard(
            title: Text(item.key, style: TextStyle(fontWeight: FontWeight.bold)),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: itemList.length,
                  itemBuilder: (subContext, subIndex) => buildObjectResult(itemList[subIndex]),
                  separatorBuilder: (subContext, i) => Divider(thickness: 2),
                ),
              )
            ],
          );
        } else if (item.value is Map<String, dynamic>) {
          return ExpansionTileCard(
            title: Text(item.key, style: TextStyle(fontWeight: FontWeight.bold)),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: buildObjectResult(item.value),
              )
            ],
          );
        } else if (item.value != null) {
          return ListTile(
            title: Text(item.key),
            trailing: Text(item.value.toString()),
          );
        }
        return Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(botOperation.label),
      ),
      body: _buildPageContentWidget(),
      floatingActionButton: Builder(builder: buildValidButton),
    );
  }
}
