class BotInfo {

  int id;
  int gameId;
  String login;
  String state;
  List<String> availableTransitions;

  BotInfo({
    this.id,
    this.gameId,
    this.login,
    this.state,
    this.availableTransitions
  });

  factory BotInfo.fromJson(Map<String, dynamic> json) {
    return BotInfo(
        id: json["id"],
        gameId: json["game_id"],
        login: json["login"],
        state: json["state"],
        availableTransitions: (json["available_transitions"] as List).map((i) => i?.toString()).toList()
    );
  }

}