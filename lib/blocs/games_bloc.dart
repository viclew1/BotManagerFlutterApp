
import 'package:bot_manager_mobile_app/models/game_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bot_manager_mobile_app/resources/repository.dart';

class GamesBloc {
  final repository = new Repository();

  final gameInfoListPublishSubject = new PublishSubject<GameInfoList>();

  Stream<GameInfoList> get gamesStream => gameInfoListPublishSubject.stream;

  fetchGames() async {
    GameInfoList responseModel = await repository.fetchGameInfoList();
    gameInfoListPublishSubject.sink.add(responseModel);
  }

  dispose() {
    gameInfoListPublishSubject.close();
  }
}

final bloc = new GamesBloc();