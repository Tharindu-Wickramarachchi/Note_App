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
    required this.updatedAt, // Default color: white
  });
}

// // it generate the random color in our notes
// int generateRandomLightColor() {
//   Random random = Random();
//   int red = 200 + random.nextInt(56); // 200 to 255
//   int green = 200 + random.nextInt(56); // 200 to 255
//   int blue = 200 + random.nextInt(56); // 200 to 255
//   return (0xFF << 24) | (red << 16) | (green << 8) | blue;
// }

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

// String getGradientColor() {
//   List<Color> randomGradient = gradients[Random().nextInt(gradients.length)];
//   // Convert the gradient colors to a string representation
//   return randomGradient.map((color) => color.toString()).join(', ');
// }

// List<List<Color>> gradients = [
//   [
//     Colors.blue.shade500,
//     Colors.blue.shade400,
//     Colors.blue.shade300,
//     Colors.blue.shade200,
//   ],
//   [
//     Colors.blueAccent.shade700,
//     Colors.blueAccent.shade400,
//     Colors.blueAccent,
//     Colors.blueAccent.shade200,
//   ],
//   [
//     Colors.indigo.shade500,
//     Colors.indigo.shade400,
//     Colors.indigo.shade300,
//     Colors.indigo.shade200,
//   ],
//   [
//     Colors.indigoAccent.shade700,
//     Colors.indigoAccent.shade400,
//     Colors.indigoAccent,
//     Colors.indigoAccent.shade200,
//   ],
//   [
//     Colors.lightBlue.shade500,
//     Colors.lightBlue.shade400,
//     Colors.lightBlue.shade300,
//     Colors.lightBlue.shade200,
//   ],
//   [
//     Colors.lightBlueAccent.shade700,
//     Colors.lightBlueAccent.shade400,
//     Colors.lightBlueAccent,
//     Colors.lightBlueAccent.shade200,
//   ],
//   [
//     Colors.cyan.shade500,
//     Colors.cyan.shade400,
//     Colors.cyan.shade300,
//     Colors.cyan.shade200,
//   ],
//   [
//     Colors.cyanAccent.shade700,
//     Colors.cyanAccent.shade400,
//     Colors.cyanAccent,
//     Colors.cyanAccent.shade200,
//   ],
//   [
//     Colors.red.shade600,
//     Colors.red.shade500,
//     Colors.red.shade400,
//     Colors.red.shade300,
//   ],
//   [
//     Colors.redAccent.shade700,
//     Colors.redAccent.shade400,
//     Colors.redAccent,
//     Colors.redAccent.shade200,
//   ],
//   [
//     Colors.green.shade500,
//     Colors.green.shade400,
//     Colors.green.shade300,
//     Colors.green.shade200,
//   ],
//   [
//     Colors.greenAccent.shade700,
//     Colors.greenAccent.shade400,
//     Colors.greenAccent,
//     Colors.greenAccent.shade200,
//   ],
//   [
//     Colors.teal.shade600,
//     Colors.teal.shade500,
//     Colors.teal.shade400,
//     Colors.teal.shade300,
//   ],
//   [
//     Colors.tealAccent.shade700,
//     Colors.tealAccent.shade400,
//     Colors.tealAccent,
//     Colors.tealAccent.shade200,
//   ],
//   [
//     Colors.lightGreen.shade600,
//     Colors.lightGreen.shade500,
//     Colors.lightGreen.shade400,
//     Colors.lightGreen.shade300,
//   ],
//   [
//     Colors.lightGreenAccent.shade700,
//     Colors.lightGreenAccent.shade400,
//     Colors.lightGreenAccent,
//     Colors.lightGreenAccent.shade200,
//   ],
//   [
//     Colors.lime.shade600,
//     Colors.lime.shade500,
//     Colors.lime.shade400,
//     Colors.lime.shade300,
//   ],
//   [
//     Colors.limeAccent.shade700,
//     Colors.limeAccent.shade400,
//     Colors.limeAccent,
//     Colors.limeAccent.shade200,
//   ],
//   [
//     Colors.pink.shade500,
//     Colors.pink.shade400,
//     Colors.pink.shade300,
//     Colors.pink.shade200,
//   ],
//   [
//     Colors.pinkAccent.shade700,
//     Colors.pinkAccent.shade400,
//     Colors.pinkAccent,
//     Colors.pinkAccent.shade200,
//   ],
//   [
//     Colors.purple.shade500,
//     Colors.purple.shade400,
//     Colors.purple.shade300,
//     Colors.purple.shade200,
//   ],
//   [
//     Colors.purpleAccent.shade700,
//     Colors.purpleAccent.shade400,
//     Colors.purpleAccent,
//     Colors.purpleAccent.shade200,
//   ],
//   [
//     Colors.deepPurple.shade500,
//     Colors.deepPurple.shade400,
//     Colors.deepPurple.shade300,
//     Colors.deepPurple.shade200,
//   ],
//   [
//     Colors.deepPurpleAccent.shade700,
//     Colors.deepPurpleAccent.shade400,
//     Colors.deepPurpleAccent,
//     Colors.deepPurpleAccent.shade200,
//   ],
//   [
//     Colors.orange.shade500,
//     Colors.orange.shade400,
//     Colors.orange.shade300,
//     Colors.orange.shade200,
//   ],
//   [
//     Colors.orangeAccent.shade700,
//     Colors.orangeAccent.shade400,
//     Colors.orangeAccent,
//     Colors.orangeAccent.shade200,
//   ],
//   [
//     Colors.deepOrange.shade500,
//     Colors.deepOrange.shade400,
//     Colors.deepOrange.shade300,
//     Colors.deepOrange.shade200,
//   ],
//   [
//     Colors.amber.shade500,
//     Colors.amber.shade400,
//     Colors.amber.shade300,
//     Colors.amber.shade200,
//   ],
//   [
//     Colors.amberAccent.shade700,
//     Colors.amberAccent.shade400,
//     Colors.amberAccent,
//     Colors.amberAccent.shade200,
//   ],
//   [
//     Colors.brown.shade500,
//     Colors.brown.shade400,
//     Colors.brown.shade300,
//     Colors.brown.shade200,
//   ],
//   [
//     Colors.yellow.shade500,
//     Colors.yellow.shade400,
//     Colors.yellow.shade300,
//     Colors.yellow.shade200,
//   ],
//   [
//     Colors.yellowAccent.shade700,
//     Colors.yellowAccent.shade400,
//     Colors.yellowAccent,
//     Colors.yellowAccent.shade200,
//   ],
// ];
