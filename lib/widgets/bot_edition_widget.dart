import 'package:bot_manager_mobile_app/models/bot_model.dart';
import 'package:bot_manager_mobile_app/models/bot_property_model.dart';
import 'package:bot_manager_mobile_app/resources/api_provider.dart';
import 'package:bot_manager_mobile_app/widgets/custom/bot_property_detail_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BotEditionWidget extends StatefulWidget {
  final BotInfo bot;

  BotEditionWidget(this.bot);

  @override
  State createState() {
    return BotEditionState(bot);
  }
}

class BotEditionState extends State<BotEditionWidget> {
  final BotInfo bot;

  Map<BotProperty, dynamic> props;
  BotPropertiesWidget propsWidget;

  bool loading = true;

  BotEditionState(this.bot) {
    update();
  }

  void update() async {
    Map<String, dynamic> botPropsMap = await ApiProvider.httpGet(ApiProvider.getBotPropertiesResource(bot.id));
    BotPropertyList botPropertyList = await ApiProvider.httpGet(ApiProvider.getGamePropertiesResource(bot.gameId));
    props = Map.fromIterable(botPropertyList.botProperties, key: (e) => e, value: (e) => botPropsMap[e.key]);
    propsWidget = BotPropertiesWidget(props, setState);
    setState(() {
      loading = false;
    });
  }

  Widget buildValidButton(BuildContext context) {
    return loading || !propsWidget.valueChanged() || !propsWidget.propertiesFilled()
        ? null
        : FloatingActionButton(
            child: Icon(Icons.save),
            onPressed: () => updateBot(context),
          );
  }

  void updateBot(BuildContext context) {
    ApiProvider.httpPost(ApiProvider.updateBotPropertiesResource(bot.id), propsWidget.buildPropsAsMapStringString()).then((value) {
      final snackBar = SnackBar(
        content: Text('Bot updated'),
      );
      setState(() {
        propsWidget.updateInitialProps(value);
        Scaffold.of(context).showSnackBar(snackBar);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading ? LinearProgressIndicator() : buildBody(),
      floatingActionButton: buildValidButton(context),
    );
  }

  Widget buildBody() {
    if (props.isEmpty) {
      return Center(
        child: Text(
          "No parameter for this operation.",
          style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
        ),
      );
    }
    return propsWidget;
  }
}
