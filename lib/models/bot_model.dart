class BotInfo {

  int id;
  int gameId;
  String login;
  String state;

  BotInfo({
    this.id,
    this.gameId,
    this.login,
    this.state
  });

  factory BotInfo.fromJson(Map<String, dynamic> json) {
    return BotInfo(
        id: json["id"],
        gameId: json["game_id"],
        login: json["login"],
        state: json["state"]
    );
  }

}