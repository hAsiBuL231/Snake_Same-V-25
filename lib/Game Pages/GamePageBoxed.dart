import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../Database/GameScores.dart';
import '../Database/globals.dart';
import '../UI Design Folder/Functions.dart';
import '../UI Design Folder/HomePage.dart';

enum Direction { up, down, left, right }

class GamePageBoxed extends StatefulWidget {
  const GamePageBoxed({super.key});
  @override
  State<GamePageBoxed> createState() => GamePageBoxedState();
}

class GamePageBoxedState extends State<GamePageBoxed> {
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
            score += 2;
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
    var hScore = GameScoresState().highestScore;
    addScore(score);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text("Game Over"),
              content: Text("Your Score is: $score\n"
                  "Current highest score: $hScore"),
              actions: [
                ElevatedButton(
                    onPressed: resetGame, child: const Text("Try Again")),
                ElevatedButton(
                    onPressed: () => nextPage(const HomePage(), context),
                    child: const Text("Exit"))
              ]);
        });
  }

  snakeMovement() {
    switch (direction) {
      case Direction.up:
        if (snakePosition.last < grow) {
          gameOver();
        } else {
          snakePosition.add(snakePosition.last - grow);
        }
        break;
      case Direction.down:
        if (snakePosition.last > grow * gColumn) {
          gameOver();
        } else {
          snakePosition.add(snakePosition.last + grow);
        }
        break;
      case Direction.left:
        if (snakePosition.last % grow == 0) {
          gameOver();
        } else {
          snakePosition.add(snakePosition.last - 1);
        }
        break;
      case Direction.right:
        if ((snakePosition.last + 1) % grow == 0) {
          gameOver();
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
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Column(children: [
              ElevatedButton.icon(
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                  icon: const Icon(Icons.sports_score_outlined),
                  label: Text("Score: $score",
                      style: const TextStyle(color: Colors.black, fontSize: 18)),
                  onPressed: null),
              GestureDetector(
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
                    color: Colors.red,
                    child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(10),
                        itemCount: grow * gColumn,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: grow,
                          //mainAxisSpacing: 0.5,
                          //crossAxisSpacing: 0.5,
                        ),
                        itemBuilder: (box, index) {
                          if (snakePosition.last == index) {
                            return Container(color: Colors.green[900]);
                          } else if (snakePosition.first == index) {
                            return Container(color: Colors.green[300]);
                          } else if (snakePosition.contains(index)) {
                            return Container(color: Colors.green);
                          } else if (index == fruit) {
                            return Container(
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image:
                                            AssetImage('Assets/Images/egg.png'),
                                        fit: BoxFit.fill),
                                    shape: BoxShape.rectangle,
                                    color: Colors.white));
                          } else {
                            return Container(color: Colors.white);
                          }
                        })),
              ),
            ]),
          ),
        ),
        backgroundColor: Colors.blue[100]);
  }
}
