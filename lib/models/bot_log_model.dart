class BotLog {
  String message;
  DateTime time;
  String level;

  BotLog({this.message, this.time, this.level});

  factory BotLog.fromJson(Map<String, dynamic> json) {
    return BotLog(
      message: json["message"],
      time: DateTime.fromMillisecondsSinceEpoch(json["time"]),
      level: json["level"],
    );
  }
}
