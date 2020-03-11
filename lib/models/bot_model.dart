class BotInfo {

  int id;
  String login;
  String state;

  BotInfo({
    this.id,
    this.login,
    this.state
  });

  factory BotInfo.fromJson(Map<String, dynamic> json) {
    return BotInfo(
        id: json["id"],
        login: json["login"],
        state: json["state"]
    );
  }

}