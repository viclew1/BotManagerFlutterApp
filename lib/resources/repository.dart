import 'package:bot_manager_mobile_app/models/game_model.dart';

import 'api_provider.dart';

class Repository {
  final apiProvider = new ApiProvider();
  GameInfoList gameInfoList = new GameInfoList();

  Future<GameInfoList> fetchGameInfoList() {
    gameInfoList.isError = false;
    gameInfoList.errorMessage = '';
    return apiProvider.fetchGameInfoList().then((GameInfoList response) {
      return response;
    }).catchError((e) {
      print(e);
      gameInfoList.isError = true;
      gameInfoList.errorMessage = e.toString();
      return gameInfoList;
    });
  }

}