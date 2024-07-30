import 'dart:math';

class Note {
  String uid;
  String id;
  String note;
  int color;
  final DateTime createdAt;
  final DateTime updatedAt;

  Note({
    required this.uid,
    required this.id,
    required this.note,
    this.color = 0xFFFFFFFF,
    required this.createdAt,
    required this.updatedAt, 
  });
}


int generateRandomLightColor() {
  Random random = Random();
  List<int> colors = [
    0xFFFF8080,
    0xFFFF9F80,
    0xFFFFBF80,
    0xFFFFDF80,
    0xFFDFFF80,
    0xFFBFFF80,
    0xFF9FFF80,
    0xFF80FF9F,
    0xFF80FFBF,
    0xFF80FFDF,
    0xFF80FFFF,
    0xFF80DFFF,
    0xFF80BFFF,
    0xFF809FFF,
    0xFF8080FF,
    0xFFB399FF,
    0xFFCC99FF,
    0xFFE699FF,
    0xFFFF99FF,
    0xFFFF99E6,
    0xFFFF99CC,
    0xFFFF99B3,
    0xFFFF9999,
  ];

  int randomIndex = random.nextInt(colors.length);
  return colors[randomIndex];
}

