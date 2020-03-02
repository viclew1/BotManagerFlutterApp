// Core
import 'package:bot_manager_mobile_app/blocs/games_bloc_widget.dart';
import 'package:bot_manager_mobile_app/models/game_model.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../theme.dart';

// Page Widgets


class GameCard extends StatefulWidget {
  final GameInfo game;
  final double parallaxPercent;

  GameCard({
    this.game,
    this.parallaxPercent
  });

  @override
  State<StatefulWidget> createState() {
    return GameCardState();
  }
}

class GameCardState extends State<GameCard> with TickerProviderStateMixin {
  BuildContext _context;
  GamesBlocWidgetState blocState;
  GlobalKey _posterKey = GlobalKey();
  double startDragY;
  double dragOffset;
  double posterOffsetY = 0.0;
  double posterClampUp = -0.09;
  double posterClampDown = 0.0;
  bool isPosterUp = false;
  AnimationController animationController;
  AnimationController favouriteAnimationController;
  Animation favouriteAnimation;
  double posterWidth = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    initAnimationCard();
    initAnimationFavourite();
  }

  initAnimationCard() {
    animationController = new AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    )
      ..addListener(() {
        setState(() {
          posterOffsetY = dragOffset;
        });
      })
      ..addStatusListener((AnimationStatus status) {});
  }

  initAnimationFavourite() {
    favouriteAnimationController = new AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 500)
    )
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          favouriteAnimationController.reverse();
        }
      })
      ..addListener(() {
        setState(() {});
      });
    favouriteAnimation = Tween(begin: 1.0, end: 1.40).animate(favouriteAnimationController);
  }

  _afterLayout(_) {
    final RenderBox posterBox = _posterKey.currentContext.findRenderObject();
    setState(() {
      posterWidth = posterBox.size.width - 60;
    });
  }


  void _onPanStart(DragStartDetails details) {
    startDragY = details.globalPosition.dy;
    posterClampUp = -50.0;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final currDrag = details.globalPosition;
    final dragDistance = currDrag.dy - startDragY;
    dragOffset = (dragDistance).clamp(posterClampUp, posterClampDown);
    animationController.forward(from: 1.0);
  }

  void _onPanEnd(DragEndDetails details) {
    startDragY = null;
  }

  Widget _gamePosterImage() {
    return new Expanded(
      child: new OverflowBox(
          child: new Hero(
              tag: widget.game.id.toString(),
              child: new Material(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
                clipBehavior: Clip.hardEdge,
                child: new CachedNetworkImage(
//                  placeholder: new Container(
//                    width: posterWidth,
//                    child: new Center(
//                      child: new CircularProgressIndicator(
//                        strokeWidth: 3.0,
//                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
//                      ),
//                    ),
//                  ),
                  width: posterWidth,
                  imageUrl: widget.game.iconPath,
                  fit: BoxFit.cover,
                ),
              )
          )
      ),
    );
  }

  Widget _gamePoster() {
    return new Expanded(
        flex: 1,
        key: _posterKey,
        child: new Stack(
          children: <Widget>[
            new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
            ),
            new Transform.translate(
              offset: Offset(0.0, posterOffsetY),
              child: new GestureDetector(
                onVerticalDragStart: _onPanStart,
                onVerticalDragUpdate: _onPanUpdate,
                onVerticalDragEnd: _onPanEnd,
                child: new Column(
                  children: <Widget>[
                    _gamePosterImage(),
                  ],
                ),
              ),
            )
          ],
        )
    );
  }

  Widget _gameInfo() {
    return new Container(
        margin: EdgeInsets.only(top: 20.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Text(widget.game.name, style: AppTextStyles.gameCardName, textAlign: TextAlign.center),
            new Container(
                margin: EdgeInsets.only(top: 5.0),
                child: new Text(widget.game.botInfoList.length.toString() + " Running bots", style: AppTextStyles.gameCardBots, textAlign: TextAlign.center)
            )
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    blocState = GamesBlocWidget.of(context, false);
    return new Container(
        child: new Column(
          children: <Widget>[
            _gamePoster(),
            _gameInfo()
          ],
        )
    );
  }

  @override
  void dispose() {
    super.dispose();
    favouriteAnimationController.dispose();
    animationController.dispose();
  }
}