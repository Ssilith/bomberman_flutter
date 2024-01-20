import 'dart:async';
import 'dart:math';
import 'package:bomberman/button.dart';
import 'package:bomberman/tile.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bomberman',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

enum Directions { up, down, left, right }

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Board variables
  int numberOfSquares = 165;
  int numberOfSquaresInRow = 11;

  //Player variables
  Directions direction = Directions.down;
  int player = 0;

  // Construcion variables
  List<int> walls = [];
  List<int> bricks = [];

  // Bomb variables
  bool setBomb = false;
  int setBombIndex = 0;
  List<int> bomb = [];

  @override
  void initState() {
    startGame();
    super.initState();
  }

  void startGame() {
    walls = [];
    bricks = [];
    direction = Directions.right;
    player = 0;
    generateWalls();
    generateBricks();
  }

  void generateWalls() {
    int startValue = numberOfSquaresInRow + 2;
    int increment = 3;
    int skipValue = 13;

    for (int i = startValue; i <= numberOfSquares; i += skipValue) {
      for (int j = 0; j < 3 && i <= numberOfSquares; j++) {
        walls.add(i);
        i += increment;
      }
    }
  }

  void generateBricks() {
    int randomValue = 0;
    for (int i = 0; i < 70; i++) {
      randomValue = Random().nextInt(numberOfSquares);
      if (randomValue > 5 && !walls.contains(randomValue)) {
        bricks.add(randomValue);
      }
    }
  }

  void move() {
    switch (direction) {
      case Directions.right:
        moveRight();
        break;
      case Directions.up:
        moveUp();
        break;
      case Directions.down:
        moveDown();
        break;
      case Directions.left:
        moveLeft();
        break;
    }
  }

  void moveDown() {
    if (player < numberOfSquares - numberOfSquaresInRow) {
      int moveDown = player + numberOfSquaresInRow;
      if (!walls.contains(moveDown) && !bricks.contains(moveDown)) {
        player = moveDown;
      }
    }
  }

  void moveUp() {
    if (player >= numberOfSquaresInRow) {
      int moveUp = player - numberOfSquaresInRow;
      if (!walls.contains(moveUp) && !bricks.contains(moveUp)) {
        player = moveUp;
      }
    }
  }

  void moveLeft() {
    if (player % numberOfSquaresInRow != 0) {
      int moveLeft = player - 1;
      if (!walls.contains(moveLeft) && !bricks.contains(moveLeft)) {
        player = moveLeft;
      }
    }
  }

  void moveRight() {
    if (player % numberOfSquaresInRow != numberOfSquaresInRow - 1) {
      int moveRight = player + 1;
      if (!walls.contains(moveRight) && !bricks.contains(moveRight)) {
        player = moveRight;
      }
    }
  }

  void placeBomb() {
    setBomb = true;
    setBombIndex = player;
    List<int> bombValues = [setBombIndex];
    if (setBombIndex % numberOfSquaresInRow != numberOfSquaresInRow - 1) {
      bombValues.add(setBombIndex + 1);
    }
    if (setBombIndex % numberOfSquaresInRow != 0) {
      bombValues.add(setBombIndex - 1);
    }
    if (setBombIndex < numberOfSquares - numberOfSquaresInRow) {
      bombValues.add(setBombIndex + numberOfSquaresInRow);
    }
    if (setBombIndex >= numberOfSquaresInRow) {
      bombValues.add(setBombIndex - numberOfSquaresInRow);
    }
    setBombAnimation(bombValues);
  }

  void setBombAnimation(List<int> bombValues) {
    Timer(const Duration(seconds: 2), () {
      setState(() {
        bomb = bombValues;
        setBomb = false;
      });
    });

    Timer(const Duration(seconds: 3), () {
      setState(() {
        destroyBrics(bombValues);
        gameOver(bombValues);
        bomb = [];
      });
    });
  }

  void destroyBrics(List<int> bombValues) {
    List<int> newBricks = List.from(bricks);
    for (int b in bombValues) {
      if (newBricks.contains(b)) {
        newBricks.remove(b);
      }
    }
    setState(() {
      bricks = newBricks;
    });
  }

  void gameOver(List<int> bombValues) {
    if (bombValues.contains(player)) {
      gameOverBaner();
    }
  }

  void gameOverBaner() {
    showDialog(
        context: context,
        builder: (context) => WillPopScope(
              onWillPop: () {
                return Future.value(false);
              },
              child: AlertDialog(
                  elevation: 0,
                  backgroundColor: Colors.grey[900],
                  title: const Center(
                    child: Text('Game Over!',
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                  ),
                  content: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Play again!',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                      const SizedBox(height: 5),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            setState(() {
                              startGame();
                            });
                          },
                          child: const Text('Okay!',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14)))
                    ],
                  )),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
                itemCount: numberOfSquares,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: numberOfSquaresInRow),
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      walls.contains(index)
                          ? const Tile(color: Colors.black)
                          : bomb.contains(index)
                              ? const Tile(color: Colors.green)
                              : player == index
                                  ? const Tile(color: Colors.red)
                                  : bricks.contains(index)
                                      ? const Tile(color: Colors.brown)
                                      : Tile(color: Colors.grey[900]),
                      if (setBomb && index == setBombIndex)
                        const Center(
                          child: Icon(Icons.dangerous,
                              color: Colors.white, size: 30),
                        ),
                    ],
                  );
                }),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MyButton(
                  icon: Icons.arrow_upward,
                  onPressed: () => setState(() {
                        direction = Directions.up;
                        move();
                      })),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyButton(
                      icon: Icons.arrow_back,
                      onPressed: () => setState(() {
                            direction = Directions.left;
                            move();
                          })),
                  MyButton(
                      icon: Icons.dangerous,
                      onPressed: () => setState(() {
                            placeBomb();
                          })),
                  MyButton(
                      icon: Icons.arrow_forward,
                      onPressed: () => setState(() {
                            direction = Directions.right;
                            move();
                          })),
                ],
              ),
              MyButton(
                  icon: Icons.arrow_downward,
                  onPressed: () => setState(() {
                        direction = Directions.down;
                        move();
                      })),
              const SizedBox(height: 25),
            ],
          )
        ],
      ),
    );
  }
}
