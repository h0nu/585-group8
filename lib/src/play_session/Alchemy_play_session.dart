import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AlchemyGame extends StatefulWidget {
  const AlchemyGame({super.key});

  @override
  _AlchemyGameState createState() => _AlchemyGameState();
}

class _AlchemyGameState extends State<AlchemyGame> {
  List<String> inventory = [];
  List<String> combinationSequence = [];

  void combineElements(String element) {
    combinationSequence.add(element);

    if (combinationSequence.length == 2) {
      if (combinationSequence.contains("fire") &&
          combinationSequence.contains("water")) {
        if (!inventory.contains("steam")) {
          inventory.add("steam");
        }
      } else if (combinationSequence.contains("air") &&
          combinationSequence.contains("earth")) {
        if (!inventory.contains("dust")) {
          inventory.add("dust");
        }
      } else if (combinationSequence.contains("steam") &&
          combinationSequence.contains("earth")) {
        if (!inventory.contains("dust")) {
          inventory.add("dust");
        }
      }
      // Clear the combination sequence
      combinationSequence.clear();
      notifyListeners(); // Notify listeners when the state changes
    }
  }
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null, // Remove the AppBar
      body: SafeArea(
        child: ChangeNotifierProvider(
          create: (context) => AlchemyGameState(inventory, combinationSequence),
          child: Column(
            children: [
              Expanded(
                flex: 4,
                child: _AlchemyGameContent(),
              ),
              Container(
                color: Color.fromRGBO(255,232,215,1), // Color from figma
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround, // Adjusted to space around icons
                    children: [
                      IconButton(
                        onPressed: () {
                          GoRouter.of(context).go('/play');
                        },
                        icon: Icon(Icons.home),
                      ),
                      IconButton(
                        onPressed: () {
                          GoRouter.of(context).push('/hints');
                        },
                        icon: Icon(Icons.lightbulb),
                      ),
                      IconButton(
                        onPressed: () => GoRouter.of(context).push('/encyclopedia'),
                        icon: Icon(Icons.book),
                      ),
                      IconButton(
                        onPressed: () => GoRouter.of(context).push('/settings'),
                        icon: Icon(Icons.settings),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  
  void notifyListeners() {}
}

class _AlchemyGameContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<AlchemyGameState>(context);

    return Row(
      children: <Widget>[
        Expanded(
          flex: 4,
          child: DragTarget<String>(
            builder: (context, candidateData, rejectedData) {
              return Container(
                color: Colors.white,
              );
            },
            onAccept: (element) {
              gameState.combineElements(element);
            },
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 10),
              Expanded(
                child: ListView(
                  children: <Widget>[
                    Draggable<String>(
                      data: "fire",
                      feedback: Image.asset("assets/images/fire.png",
                          width: 40, height: 40),
                      child: Image.asset("assets/images/fire.png",
                          width: 40, height: 40),
                    ),
                    Draggable<String>(
                      data: "water",
                      feedback: Image.asset("assets/images/water.png",
                          width: 40, height: 40),
                      child: Image.asset("assets/images/water.png",
                          width: 40, height: 40),
                    ),
                    Draggable<String>(
                      data: "air",
                      feedback: Image.asset("assets/images/air.png",
                          width: 40, height: 40),
                      child: Image.asset("assets/images/air.png",
                          width: 40, height: 40),
                    ),
                    Draggable<String>(
                      data: "earth",
                      feedback: Image.asset("assets/images/earth.png",
                          width: 40, height: 40),
                      child: Image.asset("assets/images/earth.png",
                          width: 40, height: 40),
                    ),
                    for (var item in gameState.inventory)
                      Image.asset("assets/images/$item.png",
                          width: 40, height: 40),
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }
}

class AlchemyGameState extends ChangeNotifier {
  List<String> inventory;
  List<String> combinationSequence;

  AlchemyGameState(this.inventory, this.combinationSequence);

  void combineElements(String element) {
    combinationSequence.add(element);

    if (combinationSequence.length == 2) {
      if (combinationSequence.contains("fire") &&
          combinationSequence.contains("water")) {
        if (!inventory.contains("steam")) {
          inventory.add("steam");
        }
      } else if (combinationSequence.contains("air") &&
          combinationSequence.contains("earth")) {
        if (!inventory.contains("dust")) {
          inventory.add("dust");
        }
      } else if (combinationSequence.contains("steam") &&
          combinationSequence.contains("earth")) {
        if (!inventory.contains("dust")) {
          inventory.add("dust");
        }
      }
      // Clear the combination sequence
      combinationSequence.clear();
      notifyListeners(); // Notify listeners when the state changes
    }
  }
}