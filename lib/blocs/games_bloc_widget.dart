import 'package:bot_manager_mobile_app/models/game_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'games_bloc.dart';

class GamesBlocProvider extends InheritedWidget {
  GamesBlocProvider({
    Key key,
    @required Widget child,
    @required this.data
  }) : super(key: key, child: child);


  final GamesBlocWidgetState data;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}

class GamesBlocWidget extends StatefulWidget {

  final Widget child;

  GamesBlocWidget({
    Key key,
    @required this.child
  }) : super(key: key);


  @override
  State<StatefulWidget> createState() {
    return GamesBlocWidgetState();
  }

  static GamesBlocWidgetState of([BuildContext context, bool rebuild = true]) {
    return (rebuild ? context.inheritFromWidgetOfExactType(GamesBlocProvider) as GamesBlocProvider
        : context.ancestorWidgetOfExactType(GamesBlocProvider) as GamesBlocProvider).data;
  }

}

class GamesBlocWidgetState extends State<GamesBlocWidget> {

  final GamesBloc bloc = new GamesBloc();

  List<GameInfo> _games = <GameInfo>[];
  bool _isLoading = true;
  bool _isError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    bloc.fetchGames();
    bloc.gamesStream.listen((GameInfoList response) {
      setState(() {
        _games = response.gameInfoList;
        _isLoading = false;
        _isError = response.isError;
        _errorMessage = response.errorMessage;
      });
    });
  }

  List<GameInfo> get games => _games;
  bool get isLoading => _isLoading;
  bool get isError => _isError;
  String get errorMessage => _errorMessage;

  void refreshGames() {
    bloc.fetchGames();
  }

  @override
  Widget build(BuildContext context) {
    return new GamesBlocProvider(
        child: widget.child,
        data: this
    );
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

}