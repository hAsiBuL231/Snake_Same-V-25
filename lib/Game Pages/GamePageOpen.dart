import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:snake_game_v_25/UI%20Page/HomePage.dart';
import '../Database/globals.dart';
import '../All Functions Page/FirebaseFunction.dart';
import '../All Functions Page/Functions.dart';

enum Direction { up, down, left, right }

class GamePageOpen extends StatefulWidget {
  const GamePageOpen({super.key});
  @override
  State<GamePageOpen> createState() => GamePageOpenState();
}

class GamePageOpenState extends State<GamePageOpen> {
  Direction direction = Direction.down;
  var random = Random();
  int fruit = 150;
  int score = 0;
  var snakePosition = [0, 20, 40];
  bool _shouldRunCallback = true;

  startGame() {
    Future.delayed(Duration(milliseconds: gLevel), () {
      if (_shouldRunCallback) {
        setState(() {
          snakeMovement();
          if (snakePosition.contains(fruit)) {
            fruit = random.nextInt(grow * gColumn);
            score++;
          }
          final copyList = List.from(snakePosition);
          if (snakePosition.length > copyList.toSet().length) {
            gameOver();
          }
        });
      }
    });
  }

  resetGame() {
    setState(() {
      direction = Direction.down;
      fruit = 150;
      score = 0;
      snakePosition = [0, 20, 40];
      _shouldRunCallback = true;
    });
    Navigator.pop(context);
    startGame();
  }

  gameOver() {
    setState(() {
      _shouldRunCallback = false;
    });
    addScore(score);
    //var hScore = oldGameScoresState().highestScore;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text("Game Over"),
              content: Text("Your Score is: $score\n"
                  //"Current highest score: $hScore"
                  ),
              actions: [
                TextButton(onPressed: resetGame, child: const Text("Try Again")),
                TextButton(onPressed: () => nextPage(const HomePage(), context), child: const Text("Exit"))
              ]);
        });
  }

  snakeMovement() {
    switch (direction) {
      case Direction.up:
        if (snakePosition.last < grow) {
          snakePosition.add(snakePosition.last + grow * gColumn);
        } else {
          snakePosition.add(snakePosition.last - grow);
        }
        break;
      case Direction.down:
        if (snakePosition.last > grow * gColumn) {
          snakePosition.add(snakePosition.last - grow * gColumn);
        } else {
          snakePosition.add(snakePosition.last + grow);
        }
        break;
      case Direction.left:
        if (snakePosition.last % grow == 0) {
          snakePosition.add(snakePosition.last + grow - 1);
        } else {
          snakePosition.add(snakePosition.last - 1);
        }
        break;
      case Direction.right:
        if ((snakePosition.last + 1) % grow == 0) {
          snakePosition.add(snakePosition.last - grow + 1);
        } else {
          snakePosition.add(snakePosition.last + 1);
        }
        break;
    }
    if (!snakePosition.contains(fruit)) {
      snakePosition.removeAt(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    int profileH = MediaQuery.of(context).size.height.toInt();
    //int profileW = MediaQuery.of(context).size.width.toInt();
    startGame();
    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Column(children: [
                  ElevatedButton.icon(
                      style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                      icon: const Icon(Icons.sports_score_outlined),
                      label: Text("Score: $score", style: const TextStyle(color: Colors.black, fontSize: 18)),
                      onPressed: null),
                  Expanded(
                    child: GestureDetector(
                        onVerticalDragUpdate: (details) {
                          if (direction != Direction.up && details.delta.dy > 0) {
                            direction = Direction.down;
                          }
                          if (direction != Direction.down && details.delta.dy < 0) {
                            direction = Direction.up;
                          }
                        },
                        onHorizontalDragUpdate: (details) {
                          if (direction != Direction.left && details.delta.dx > 0) {
                            direction = Direction.right;
                          }
                          if (direction != Direction.right && details.delta.dx < 0) {
                            direction = Direction.left;
                          }
                        },
                        child: Container(
                            height: profileH.toDouble() - 80,
                            color: Colors.black,
                            child: GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.all(10),
                                itemCount: grow * gColumn,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: grow,
                                  //mainAxisSpacing: 0.5,
                                  //crossAxisSpacing: 0.5,
                                ),
                                itemBuilder: (box, index) {
                                  if (snakePosition.last == index) {
                                    return Container(color: Colors.white);
                                  } else if (snakePosition.first == index) {
                                    return Container(color: Colors.white54);
                                  } else if (snakePosition.contains(index)) {
                                    return Container(color: Colors.white70);
                                  } else if (index == fruit) {
                                    return Container(
                                        decoration: const BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage('Assets/Images/egg.png'), fit: BoxFit.fill),
                                            shape: BoxShape.rectangle,
                                            color: Colors.black));
                                  } else {
                                    return Container(color: Colors.black);
                                  }
                                }))),
                  )
                ]))));
  }
}
