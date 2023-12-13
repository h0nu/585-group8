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
    description: 'The Earth provides a foundation for support and a medium for various natural processes.',
    category: 'Solid, Brown',
    combination: 'Earth + Water = Mud',
    imagePath: 'assets/images/earth.png',
  ),
  ElementInfo(
    title: 'Fire',
    description: 'Fire is like a super-fast dance party for tiny particles that make heat and light when they get together.',
    category: 'Hot, Red',
    combination: 'Fire + Air = Smoke',
    imagePath: 'assets/images/fire.png',
  ),
  // Add more ElementInfo objects as needed
];
