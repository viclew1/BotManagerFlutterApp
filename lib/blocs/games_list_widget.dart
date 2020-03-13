import 'dart:async';

import 'package:bot_manager_mobile_app/blocs/bots_list_widget.dart';
import 'package:bot_manager_mobile_app/models/game_model.dart';
import 'package:bot_manager_mobile_app/resources/api_provider.dart';
import 'package:bot_manager_mobile_app/theme.dart';
import 'package:flutter/material.dart';

class GamesListWidget extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return GamesListWidgetState();
  }

}

class GamesListWidgetState extends State<GamesListWidget> {

  List<GameInfo> _games = List<GameInfo>();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _populateNewGames();
  }

  Future<void> _populateNewGames() async {
    setState(() {
      _isLoading = true;
    });
    ApiProvider.httpGet(ApiProvider.gameInfoListResource).then((games) {
      setState(() {
        _games = games.gameInfoList;
        _isLoading = false;
      });
    });
  }

  List<GameInfo> get  games => _games;
  bool get isLoading => _isLoading;

  ExpansionTile _buildGameTile(BuildContext context, int index) {
    return ExpansionTile(
      leading: _games[index].iconPath == null ? Icons.games :
      AspectRatio(
        aspectRatio: 1.5,
        child: new Container(
          decoration: new BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(15.0),
              topRight: const Radius.circular(15.0),
              bottomLeft: const Radius.circular(15.0),
              bottomRight: const Radius.circular(15.0),
            ),
            border: Border.all(color: AppColors.greyColor),
            image: new DecorationImage(
              fit: BoxFit.fitHeight,
              image: NetworkImage(
                _games[index].iconPath
              ),
            )
          ),
        ),
      ),
      title: Text(_games[index].name, style: TextStyle(fontSize: 18)),
      subtitle: Text('Running bots : ${_games[index].botInfoList.length} (active : ${
        _games[index].botInfoList.where((e) => e.state == "ACTIVE").length
      })'),
      children: <Widget>[
        BotsListWidget(
          gameInfo: _games[index],
          gameListUpdateCallback: () {
            setState(() => {});
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _populateNewGames,
        child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.greyColor,
          title: Text('Games'),
        ),
        body: Stack(
          children: <Widget>[
            ListView.builder(
              itemCount: _games.length,
              itemBuilder: _buildGameTile,
            ),
            if (_isLoading)
              Center(
                  child: CircularProgressIndicator()
              ),
          ],
        )
        )
    );
  }

}