import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../audio/audio_controller.dart';
import '../audio/sounds.dart';

import '../style/palette.dart';
import 'element_info.dart';

class EncyclopediaScreen extends StatefulWidget {
  const EncyclopediaScreen({Key? key}) : super(key: key);

  @override
  _EncyclopediaScreenState createState() => _EncyclopediaScreenState();
}

class _EncyclopediaScreenState extends State<EncyclopediaScreen> {
  String searchQuery = '';
  List<ElementInfo> filteredElements = elementData;

  // Helper method to create a card for each element
  Widget _buildElementCard(ElementInfo elementInfo, BuildContext context) {
    final palette = context.watch<Palette>();
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      color: palette.cardBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              elementInfo.title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color:Colors.white),
            ),
            SizedBox(height: 8),
            Material(
              elevation: 4, // Adjust the elevation value as needed
              borderRadius: BorderRadius.circular(8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Description:',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              elementInfo.description,
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Category:',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              elementInfo.category,
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Combinations:',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              elementInfo.combination,
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8),
                      // Add an Image widget with the specified imagePath
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 7), // Adjust vertical padding as needed
                        child: Align(
                          alignment: Alignment.center,
                          child: Image.asset(
                            elementInfo.imagePath,
                            width: 100, // Adjust the width as needed
                            height: 100, // Adjust the height as needed
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final audioController = context.watch<AudioController>();

    return Scaffold(
      appBar: null,
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            alignment: Alignment.center,
            color: palette.backgroundSettings,
            padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
            child: Text(
              'Encyclopedia',
              style: TextStyle(
                fontSize: 30,
                color: Colors.black,
                fontFamily: 'Permanent Marker',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                  if (searchQuery.isEmpty) {
                    // If search query is empty, display all elements
                    filteredElements = List.from(elementData);
                  } else {
                    // If search query is not empty, filter elements based on the query
                    filteredElements = elementData
                        .where((element) => element.title.toLowerCase().contains(searchQuery.toLowerCase()))
                        .toList();
                  }
                });
              },
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: Scrollbar(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: filteredElements.map((elementInfo) => _buildElementCard(elementInfo, context)).toList(),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: palette.backgroundMenu,
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
        ],
      ),
    );
  }

}
