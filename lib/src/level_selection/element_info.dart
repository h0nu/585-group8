// element_info.dart

class ElementInfo {
  final String title;
  final String description;
  final String category;
  final String combination;
  final String imagePath;

  ElementInfo({
    required this.title,
    required this.description,
    required this.category,
    required this.combination,
    required this.imagePath,
  });
}

final List<ElementInfo> elementData = [
  ElementInfo(
    title: 'Water',
    description: 'Water is a vital, clear, and adaptable liquid essential for life.',
    category: 'Liquid, Transparent',
    combination: 'Water + Fire = Steam',
    imagePath: 'assets/images/water.png',
  ),
  ElementInfo(
    title: 'Earth',
    description: 'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
    category: 'Solid, Brown',
    combination: 'Earth + Water = Mud',
    imagePath: 'assets/images/earth.png',
  ),
  ElementInfo(
    title: 'Fire',
    description: 'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
    category: 'Hot, Red',
    combination: 'Fire + Air = Smoke',
    imagePath: 'assets/images/fire.png',
  ),
  // Add more ElementInfo objects as needed
];
