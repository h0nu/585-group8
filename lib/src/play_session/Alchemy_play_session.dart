import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../style/palette.dart';
import '../audio/audio_controller.dart';
import '../audio/sounds.dart';

class AlchemyGame extends StatefulWidget {
  @override
  _AlchemyGameState createState() => _AlchemyGameState();
}

class _AlchemyGameState extends State<AlchemyGame> {
  List<String> combinationSequence = [];

  @override
  Widget build(BuildContext context) {
    final audioController = context.watch<AudioController>();
    final palette = context.watch<Palette>();
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => AlchemyGameState(),
        child: _AlchemyGameContent(),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 24.0),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: palette.backgroundAlchemy, // Change the color as needed
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () {
                    audioController.playSfx(SfxType.buttonTap);
                    GoRouter.of(context).go('/play');
                  },
                  icon: Icon(Icons.home),
                ),
                IconButton(
                  onPressed: () {
                    audioController.playSfx(SfxType.buttonTap);
                    GoRouter.of(context).push('/hints');
                  },
                  icon: Icon(Icons.lightbulb),
                ),
                IconButton(
                  onPressed: () {
                    audioController.playSfx(SfxType.buttonTap);
                    GoRouter.of(context).push('/encyclopedia');
                  },
                  icon: Icon(Icons.menu_book),
                ),
                IconButton(
                  onPressed: () {
                    audioController.playSfx(SfxType.buttonTap);
                    GoRouter.of(context).push('/settings');
                  },
                  icon: Icon(Icons.settings),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension IterableExtension<E> on List<E> {
  Iterable<T> mapIndexed<T>(T Function(int index, E element) f) sync* {
    var index = 0;
    for (final element in this) {
      yield f(index, element);
      index += 1;
    }
  }
}

class _AlchemyGameContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<AlchemyGameState>(context);

    return SafeArea(
    child: Row(
      children: <Widget>[
        Expanded(
          flex: 4,
          child: Stack(
            children: [
              DragTarget<String>(
                builder: (context, candidateData, rejectedData) {
                  return Container(
                    color: Colors.white,
                    // margin: EdgeInsets.all(8),
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

                        // Display combined elements
                        ...gameState.combinedElementsHistory
                            .mapIndexed((index, element) {
                          return Positioned(
                            left: index * 50.0,
                            top: gameState.elementPositions[element]?.dy ?? 0,
                            child: Draggable<String>(
                              data: element,
                              feedback: Image.asset(
                                "assets/images/$element.png",
                                width: 40,
                                height: 40,
                              ),
                              child: Image.asset(
                                "assets/images/$element.png",
                                width: 40,
                                height: 40,
                              ),
                              childWhenDragging: Container(),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  );
                },
                onAccept: (element) {
                  // Update the position of the dragged element
                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    RenderBox renderBox =
                        context.findRenderObject() as RenderBox;
                    Offset position = renderBox.localToGlobal(Offset.zero);
                    gameState.updateElementPositions(element, position);

                    // Combine the dragged element with the dropped element
                    gameState.combineElements(element);
                  });
                },
              ),

              // Add ClearScreenButton to the bottom middle of the blue screen
              ClearScreenButton(),
            ],
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
                    ...gameState.visibleIndividualElements.map((item) {
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
                                // Update the position of the dragged element
                                RenderBox renderBox =
                                    context.findRenderObject() as RenderBox;
                                Offset position =
                                    renderBox.localToGlobal(Offset.zero);
                                gameState.updateElementPositions(
                                    item, position);

                                // Combine the dragged element with the dropped element
                                gameState.combineElements(element);
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
    ),
    );
  }
}

class ClearScreenButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<AlchemyGameState>(context, listen: false);
    final palette = context.watch<Palette>();

    return Positioned(
      bottom: 25,
      left: 25, 
      child: GestureDetector(
        onTap: () {
          gameState.clearCombinedElements();
        },
        child: Container(
          width: 60,
          height: 60, 
          decoration: BoxDecoration(
            color: palette.backgroundPlayButton,
            shape: BoxShape.circle, 
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(
              Icons.cleaning_services, 
              color: Colors.white,
            ),
            onPressed: () {
              gameState.clearCombinedElements();
            },
          ),
        ),
      ),
    );
  }
}


class AlchemyGameState extends ChangeNotifier {
  List<String> inventory = [];
  List<String> combinationSequence = [];
  List<String> visibleIndividualElements =
      []; // Keep track of visible individual elements
  String? generatedElement;
  Offset? generatedElementPosition;
  Map<String, Offset> elementPositions = {};
  List<String> combinedElementsHistory = [];

  void combineElements(String element) {
    combinationSequence.add(element);

    if (combinationSequence.length == 2) {
      String result = getCombinationResult(combinationSequence);

      if (result != "unknown_combination") {
        // Check if the result is a valid combination
        if (!inventory.contains(result)) {
          inventory.add(result);
        }

        // Check if the result is not already in the combinedElementsHistory
        if (!combinedElementsHistory.contains(result)) {
          // Add the generated element to the visible elements
          visibleIndividualElements.add(result);

          // Update the combined elements history
          combinedElementsHistory.add(result);

          // Add the combined elements to positions
          for (var combinedElement in combinationSequence) {
            if (elementPositions.containsKey(combinedElement)) {
              elementPositions.remove(combinedElement);
            }
          }

          // Add the input elements back to visibility
          for (var inputElement in combinationSequence) {
            // Add only if it is not already present, and it's not a default element
            if (!visibleIndividualElements.contains(inputElement) &&
                !["fire", "water", "air", "earth"].contains(inputElement)) {
              visibleIndividualElements.add(inputElement);
            }
          }

          // Set the position of the generated element
          if (elementPositions.containsKey(combinationSequence.first)) {
            double baseX = elementPositions[combinationSequence.first]!.dx;
            double baseY = elementPositions[combinationSequence.first]!.dy;

            for (int i = 0; i < combinationSequence.length; i++) {
              String combinedElement = combinationSequence[i];
              elementPositions[combinedElement] = Offset(baseX + i * 40, baseY);
            }
          }
        } else {
          // Handle known combination logic when the result is already in history
          // For example, you may want to display a message or take specific actions
        }
      } else {
        // Handle unknown combination logic
        // Remove both elements from the blue screen only

        for (var combinedElement in combinationSequence) {
          elementPositions.remove(combinedElement);
        }
      }

      combinationSequence.clear();
      notifyListeners(); // Notify listeners when the state changes
    }
  }

  void updateElementPositions(String element, Offset position) {
    elementPositions[element] = position;

    // Check if the element is not already present in elementPositions
    if (!elementPositions.containsKey(element)) {
      visibleIndividualElements.add(element);
    }

    notifyListeners();
  }

  // New method to clear combined elements
  void clearCombinedElements() {
    combinedElementsHistory.clear();
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
    } else if (elements.contains("fire") && elements.contains("earth")) {
      return "ash";
    } else if (elements.contains("fire") && elements.contains("mud")) {
      return "brick";
    } else if (elements.contains("water") && elements.contains("steam")) {
      return "cloud";
    } else if (elements.contains("cloud") && elements.contains("air")) {
      return "sky";
    } else if (elements.contains("fire") && elements.contains("sky")) {
      return "sun";
    } else if (elements.contains("sun") && elements.contains("water")) {
      return "rain";
    } else if (elements.contains("rain") && elements.contains("sun")) {
      return "rainbow";
    } else if (elements.contains("fire") && elements.contains("brick")) {
      return "house";
    } else if (elements.contains("house") && elements.contains("water")) {
      return "aquarium";
    } else if (elements.contains("air") && elements.contains("aquarium")) {
      return "oxygen";
    } else if (elements.contains("earth") && elements.contains("life")) {
      return "human";
    } else if (elements.contains("human") && elements.contains("dust")) {
      return "allergy";
    } else if (elements.contains("oxygen") && elements.contains("water")) {
      return "life";
    }

    // Add more combinations as needed
    // ...

    // If no specific combination is found, return a default value
    return "unknown_combination";
  }
}
