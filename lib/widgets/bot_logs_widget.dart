import 'dart:async';

import 'package:bot_manager_mobile_app/models/bot_log_model.dart';
import 'package:bot_manager_mobile_app/models/bot_model.dart';
import 'package:bot_manager_mobile_app/resources/api_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BotLogsListWidget extends StatefulWidget {
  final BotInfo bot;

  BotLogsListWidget(this.bot);

  @override
  State<StatefulWidget> createState() {
    return BotLogsListState(bot);
  }
}

class BotLogsListState extends State<BotLogsListWidget> {
  final BotInfo bot;
  final TextEditingController editingController = TextEditingController();

  Timer refreshTimer;
  bool loading = false;
  List<BotLog> logs = List();
  String filter = "";

  BotLogsListState(this.bot) {
    refreshLogs();
    refreshTimer = new Timer.periodic(Duration(seconds: 5), (Timer t) => refreshLogs());
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    refreshTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<BotLog> filteredLogs = filterLogs(filter);
    return new Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            loading ? LinearProgressIndicator() : Container(),
            TextField(
              onChanged: (value) {
                setState(() {
                  filter = value;
                });
              },
              controller: editingController,
              decoration: InputDecoration(
                labelText: "Search",
                hintText: "Search",
                prefixIcon: Icon(
                  Icons.search,
                ),
              ),
            ),
            Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: filteredLogs.length,
                    itemBuilder: (context, index) {
                      return buildLogWidget(filteredLogs[index]);
                    })),
          ],
        ),
      ),
    );
  }

  void refreshLogs() async {
    loading = true;
    List<BotLog> newLogs = await ApiProvider.httpGet(ApiProvider.getBotLogsResource(bot.id));
    setState(() {
      loading = false;
      logs = newLogs;
    });
  }

  Widget buildLogWidget(BotLog log) {
    TextStyle style = TextStyle(
      color: defineLogColor(log.level.toString()),
    );
    return Row(
      children: <Widget>[
        Flexible(
          flex: 2,
          child: Text(
            "${log.time.hour.toString().padLeft(2, '0')}:${log.time.minute.toString().padLeft(2, '0')}:${log.time.second.toString().padLeft(2, '0')}",
            style: style,
          ),
          fit: FlexFit.tight,
        ),
        Flexible(
          flex: 1,
          child: Text(
            log.level.toString(),
            style: style,
          ),
          fit: FlexFit.tight,
        ),
        Flexible(
          flex: 7,
          child: Text(
            log.message.toString(),
            style: style,
          ),
          fit: FlexFit.tight,
        ),
      ],
    );
  }

  Color defineLogColor(String logLevel) {
    switch (logLevel) {
      case "ERROR":
        return Colors.red;
      case "WARN":
        return Colors.amber;
      default:
        return Colors.green;
    }
  }

  List<BotLog> filterLogs(String text) {
    return logs.where((e) => e.message.toUpperCase().contains(text.toUpperCase())).toList();
  }
}
