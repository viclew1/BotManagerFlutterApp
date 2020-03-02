// Core
import 'package:bot_manager_mobile_app/blocs/games_bloc_widget.dart';
import 'package:bot_manager_mobile_app/ui/widgets/games_card_flipper.dart';
import 'package:flutter/material.dart';

// Theme
import 'package:bot_manager_mobile_app/theme.dart';

// UI Widgets

class MoviesList extends StatefulWidget {
  MoviesList();

  @override
  State<StatefulWidget> createState() {
    return GamesListState();
  }
}

class GamesListState extends State<MoviesList> {
  GamesBlocWidgetState blocState;

  @override
  void initState() {
    super.initState();
  }

  Widget _loader() {
    return new Center(
      child:  new CircularProgressIndicator(
        strokeWidth: 3.0,
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
      ),
    );
  }

  Widget _message(String message, [Color color = Colors.redAccent]) {
    return new Container(
      padding: EdgeInsets.only(left: 15.0, right: 15.0),
      child: new Center(
        child: new Text(message, textAlign: TextAlign.center, style: new TextStyle(fontSize: 20.0, color: color)),
      ),
    );
  }

  Widget _gamesScrollList(GamesBlocWidgetState blocState) {
    return (blocState.games.length > 0) ? new GamesCardFlipper(
        games: blocState.games
    ) : _message('No Movies Found');
  }

  Widget _moviesList(GamesBlocWidgetState blocState) {
    return (!blocState.isError) ? _gamesScrollList(blocState) : _message(blocState.errorMessage);
  }

  @override
  Widget build(BuildContext context) {
    blocState = GamesBlocWidget.of(context);
    final double statusbarHeight = MediaQuery.of(context).padding.top;
    final double topPadding = statusbarHeight + 105;

    return new Container(
      alignment: Alignment.topCenter,
      padding: new EdgeInsets.only(top: topPadding, left: 0.0, right: 0.0, bottom: 35.0),
      child: blocState.isLoading ? _loader() : _moviesList(blocState),
    );
  }

  @override
  void dispose() {
    super.dispose();
    blocState.dispose();
  }
}