import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AlchemyGame extends StatefulWidget {
  @override
  _AlchemyGameState createState() => _AlchemyGameState();
}

class _AlchemyGameState extends State<AlchemyGame> {
  List<String> combinationSequence = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Little Alchemy Game"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              GoRouter.of(context).pop();
            } else {
              GoRouter.of(context).go('/');
            }
          },
        ),
      ),
      body: ChangeNotifierProvider(
        create: (context) => AlchemyGameState(),
        child: _AlchemyGameContent(),
      ),
    );
  }
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
                color: Colors.blue,
                child: Stack(
                  children: [
                    // Display elements on the target area
                    ...gameState.elementPositions.entries.map((entry) {
                      return Positioned(
                        left: entry.value.dx,
                        top: entry.value.dy,
                        child: Draggable<String>(
                          data: entry.key,
                          feedback: Image.asset(
                            "assets/images/${entry.key}.png",
                            width: 40,
                            height: 40,
                          ),
                          child: Image.asset(
                            "assets/images/${entry.key}.png",
                            width: 40,
                            height: 40,
                          ),
                          childWhenDragging:
                              Container(), // Keep an empty container when dragging
                        ),
                      );
                    }).toList(),

                    // Display the generated element
                    if (gameState.generatedElement != null)
                      Positioned(
                        left: gameState.generatedElementPosition?.dx ?? 0,
                        top: gameState.generatedElementPosition?.dy ?? 0,
                        child: Draggable<String>(
                          data: gameState.generatedElement!,
                          feedback: Image.asset(
                            "assets/images/${gameState.generatedElement!}.png",
                            width: 40,
                            height: 40,
                          ),
                          child: Image.asset(
                            "assets/images/${gameState.generatedElement!}.png",
                            width: 40,
                            height: 40,
                          ),
                          childWhenDragging:
                              Container(), // Keep an empty container when dragging
                        ),
                      ),
                  ],
                ),
              );
            },
            onAccept: (element) {
              // Combine the dragged element with the dropped element
              gameState.combineElements(element);

              // Update the position of the dragged element
              WidgetsBinding.instance!.addPostFrameCallback((_) {
                RenderBox renderBox = context.findRenderObject() as RenderBox;
                Offset position = renderBox.localToGlobal(Offset.zero);
                gameState.updateElementPositions(element, position);
              });
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
                    // Display default draggable elements
                    ...[
                      'fire',
                      'water',
                      'air',
                      'earth',
                    ].map((defaultElement) {
                      return Draggable<String>(
                        data: defaultElement,
                        feedback: Image.asset(
                          "assets/images/$defaultElement.png",
                          width: 40,
                          height: 40,
                        ),
                        child: Image.asset(
                          "assets/images/$defaultElement.png",
                          width: 40,
                          height: 40,
                        ),
                      );
                    }).toList(),

                    // Display draggable elements based on inventory
                    ...gameState.inventory.map((item) {
                      return Draggable<String>(
                        data: item,
                        feedback: Image.asset(
                          "assets/images/$item.png",
                          width: 40,
                          height: 40,
                        ),
                        child: Builder(
                          builder: (context) {
                            return DragTarget<String>(
                              builder: (context, candidateData, rejectedData) {
                                return Image.asset(
                                  "assets/images/$item.png",
                                  width: 40,
                                  height: 40,
                                );
                              },
                              onAccept: (element) {
                                // Combine the dragged element with the dropped element
                                gameState.combineElements(element);
                                // Update the position of the dragged element
                                RenderBox renderBox =
                                    context.findRenderObject() as RenderBox;
                                Offset position =
                                    renderBox.localToGlobal(Offset.zero);
                                gameState.updateElementPositions(
                                    item, position);
                              },
                            );
                          },
                        ),
                      );
                    }).toList(),
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
  List<String> inventory = [];
  List<String> combinationSequence = [];
  String? generatedElement;
  Offset? generatedElementPosition;
  Map<String, Offset> elementPositions = {};

  void combineElements(String element) {
    combinationSequence.add(element);

    if (combinationSequence.length == 2) {
      String result = getCombinationResult(combinationSequence);
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
      } else if (combinationSequence.contains("dust") &&
          combinationSequence.contains("water")) {
        // Combine dust and water to get a new element
        if (!inventory.contains("mud")) {
          inventory.add("mud");
        }
      }

      if (result != "unknown_combination") {
        // Check if the result is a valid combination
        if (!inventory.contains(result)) {
          inventory.add(result);
        }
      }

      // Add the combined elements to positions
      for (var combinedElement in combinationSequence) {
        if (elementPositions.containsKey(combinedElement)) {
          elementPositions.remove(combinedElement);
        }
      }
      generatedElement = result;
      generatedElementPosition = elementPositions[combinationSequence.first];

      combinationSequence.clear();
      notifyListeners(); // Notify listeners when the state changes
    }
  }

  void updateElementPositions(String element, Offset position) {
    elementPositions[element] = position;
    notifyListeners();
  }

  String getCombinationResult(List<String> elements) {
    // Add your combination logic here
    // Map the combination of elements to the correct result
    if (elements.contains("fire") && elements.contains("water")) {
      return "steam";
    } else if (elements.contains("air") && elements.contains("earth")) {
      return "dust";
    } else if (elements.contains("dust") && elements.contains("water")) {
      return "mud";
    }

    // Add more combinations as needed
    // ...

    // If no specific combination is found, return a default value
    return "unknown_combination";
  }
}
