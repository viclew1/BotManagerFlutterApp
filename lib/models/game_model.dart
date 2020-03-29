import 'package:bot_manager_mobile_app/resources/api_provider.dart';

import 'bot_model.dart';

class GameInfo {
  int id;
  String name;
  List<BotInfo> botInfoList;
  String iconPath;

  GameInfo({this.id, this.name, this.iconPath, this.botInfoList});

  factory GameInfo.fromJson(Map<String, dynamic> json) {
    return GameInfo(
        id: json["id"],
        name: json["name"],
        iconPath: '${ApiProvider.BASE_URL}/bots/${json['id']}/icons',
        botInfoList: (json["bot_info_list"] as List).map((i) => BotInfo.fromJson(i)).toList());
  }
}

class GameInfoList {
  List<GameInfo> gameInfoList;

  GameInfoList({this.gameInfoList});

  factory GameInfoList.fromJson(Map<String, dynamic> json) {
    return GameInfoList(gameInfoList: (json["game_info_list"] as List).map((i) => GameInfo.fromJson(i)).toList());
  }
}
