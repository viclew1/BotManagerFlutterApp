class BotTask {
  int id;
  String name;
  String state;
  int executionTime;

  BotTask({this.id, this.name, this.state, this.executionTime});

  factory BotTask.fromJson(Map<String, dynamic> json) {
    return new BotTask(
      id: json["id"],
      name: json["name"],
      state: json["state"],
      executionTime: json["execution_time"],
    );
  }
}

class BotTaskList {
  int serverTime;
  List<BotTask> botTasks;

  BotTaskList({this.serverTime, this.botTasks});

  factory BotTaskList.fromJson(Map<String, dynamic> json) {
    return BotTaskList(
      serverTime: json["server_time"],
      botTasks: (json["bot_tasks"] as List).map((i) => BotTask.fromJson(i)).toList(),
    );
  }
}
