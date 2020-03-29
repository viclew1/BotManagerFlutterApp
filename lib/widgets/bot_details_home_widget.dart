import 'dart:async';
import 'dart:collection';

import 'package:bot_manager_mobile_app/models/bot_log_model.dart';
import 'package:bot_manager_mobile_app/models/bot_model.dart';
import 'package:bot_manager_mobile_app/models/bot_task_model.dart';
import 'package:bot_manager_mobile_app/resources/api_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'custom/bot_utils.dart';

class BotDetailsHomeWidget extends StatefulWidget {
  final BotInfo bot;

  BotDetailsHomeWidget(this.bot);

  @override
  State<StatefulWidget> createState() {
    return BotDetailsHomeState(bot);
  }
}

class BotDetailsHomeState extends State<BotDetailsHomeWidget> {
  final BotInfo bot;
  bool loading = false;
  BotTaskList botTaskList = BotTaskList(serverTime: 0, botTasks: List());
  Map<BotTask, int> remainingSecondsByTask = HashMap();
  Timer countdownTimer;
  Timer refreshTimer;

  BotDetailsHomeState(this.bot) {
    refreshTasks();
    countdownTimer = new Timer.periodic(Duration(seconds: 1), (Timer timer) {
      for (BotTask task in remainingSecondsByTask.keys) {
        remainingSecondsByTask[task] -= 1;
      }
      setState(() {});
    });
    refreshTimer = new Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (remainingSecondsByTask.entries.where((e) => e.value < 0).isNotEmpty) {
        refreshTasks();
      }
    });
  }

  @override
  void dispose() {
    countdownTimer.cancel();
    refreshTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            loading ? LinearProgressIndicator() : Container(),
            ListTile(
              leading: buildStateIcon(bot.state),
              title: Text(bot.state),
              trailing: buildBotPopupMenuButton(bot, refreshBot),
            ),
            Divider(thickness: 3,),
            Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: botTaskList.botTasks.length,
                    itemBuilder: (context, index) {
                      return buildTaskWidget(botTaskList.serverTime, botTaskList.botTasks[index]);
                    })),
          ],
        ),
      ),
    );
  }

  void refreshBot(BotInfo newBot) {
    setState(() {
      this.bot.state = newBot.state;
      this.bot.availableTransitions = newBot.availableTransitions;
    });
    refreshTasks();
  }

  void refreshTasks() async {
    loading = true;
    var newBotTaskList = await ApiProvider.httpGet(ApiProvider.getBotTasksResource(bot.id));
    newBotTaskList.botTasks.sort((a, b) => a.executionTime.compareTo(b.executionTime));
    Map<BotTask, int> newRemainingSecondsByTask = HashMap();
    newBotTaskList.botTasks.forEach((t) {
      newRemainingSecondsByTask[t] = (t.executionTime - newBotTaskList.serverTime) ~/ 1000;
    });
    setState(() {
      loading = false;
      remainingSecondsByTask = newRemainingSecondsByTask;
      botTaskList = newBotTaskList;
    });
  }

  Widget buildTaskWidget(int serverTime, BotTask task) {
    return ListTile(
      title: Text(task.name),
      subtitle: Text(remainingLbl(task)),
    );
  }

  String remainingLbl(BotTask task) {
    int remaining = remainingSecondsByTask[task];
    if (remaining == null) {
      return "";
    }
    if (remaining < 0) {
      return "Processing...";
    }
    return "$remaining sec.";
  }
}
