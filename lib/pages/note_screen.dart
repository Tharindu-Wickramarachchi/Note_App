// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_switch/flutter_switch.dart';
// import 'package:note/models/note_model.dart';
// import 'package:quill_html_editor/quill_html_editor.dart';

// class NoteScreen extends StatefulWidget {
//   final Note note;
//   const NoteScreen({super.key, required this.note});

//   @override
//   State<NoteScreen> createState() => _NoteScreenState();
// }

// class _NoteScreenState extends State<NoteScreen> {
//   late QuillEditorController controller;
//   late String uid;
//   late Note note;
//   late int color;
//   String htmlContent = '';
//   bool isLightMode = true; // Initial state for light mode

//   final CollectionReference myNotes =
//       FirebaseFirestore.instance.collection('Notes');

//   @override
//   void initState() {
//     super.initState();
//     User? user = FirebaseAuth.instance.currentUser;
//     uid = user?.uid ?? '';
//     note = widget.note;
//     color = note.color == 0xFFFFFFFF ? generateRandomLightColor() : note.color;

//     controller = QuillEditorController();
//     controller.onTextChanged((text) {
//       debugPrint('Text changed: $text');
//     });
//     controller.onEditorLoaded(() {
//       debugPrint('Editor Loaded');
//     });

//     if (note.id.isNotEmpty) {
//       fetchNote();
//     }
//   }

//   Future<void> fetchNote() async {
//     DocumentSnapshot doc = await myNotes.doc(note.id).get();
//     if (doc.exists) {
//       setState(() {
//         htmlContent = doc['note'] ?? '';
//         controller.setText(htmlContent);
//       });
//     }
//   }

//   final customToolBarList = [
//     ToolBarStyle.bold,
//     ToolBarStyle.italic,
//     ToolBarStyle.align,
//     ToolBarStyle.color,
//     ToolBarStyle.background,
//     ToolBarStyle.listBullet,
//     ToolBarStyle.listOrdered,
//     ToolBarStyle.clean,
//     ToolBarStyle.addTable,
//     ToolBarStyle.editTable,
//   ];

//   bool _showToolbar = false;

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   void deleteConfirmation() {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           content: Container(
//             width: screenWidth * 0.9,
//             height: screenHeight * 0.25,
//             alignment: Alignment.center,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Image.asset(
//                   'assets/images/question_mark_logo.png',
//                   height: 80,
//                   width: 80,
//                   fit: BoxFit.contain,
//                 ),
//                 const SizedBox(height: 10),
//                 const Text(
//                   'Are you sure?',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 10),
//                 const Text(
//                   'This Note will be deleted permanently. You can\'t undo this action.',
//                   style: TextStyle(
//                     fontSize: 16,
//                   ),
//                   textAlign: TextAlign.justify,
//                 ),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: <Widget>[
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.pop(context); // Close the dialog
//                   },
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(5),
//                     child: Container(
//                       height: 45,
//                       width: 110,
//                       alignment: Alignment.center,
//                       color: const Color.fromARGB(255, 156, 211, 255),
//                       child: const Text(
//                         'Cancel',
//                         style: TextStyle(
//                           color: Color.fromARGB(255, 0, 110, 255),
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 GestureDetector(
//                   onTap: () {
//                     myNotes.doc(note.id).delete();
//                     Navigator.pop(context); // Close the dialog
//                     Navigator.pop(context); // Close the Note
//                     deleteMessage(); // Display note deleted message
//                   },
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(5),
//                     child: Container(
//                       height: 45,
//                       width: 110,
//                       alignment: Alignment.center,
//                       color: const Color.fromARGB(255, 255, 157, 150),
//                       child: const Text(
//                         'Yes',
//                         style: TextStyle(
//                           color: Color.fromARGB(255, 255, 0, 0),
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void deleteMessage() {
//     const snackBar = SnackBar(
//       content: Text(
//         'Note Deleted Successfully',
//         style: TextStyle(
//           fontSize: 16,
//           color: Colors.black,
//           fontWeight: FontWeight.bold,
//         ),
//         textAlign: TextAlign.center, // Center align the text
//       ),
//       backgroundColor: Colors.red, // Background color
//       duration: Duration(seconds: 3), // Duration of SnackBar will be shown
//     );

//     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   }

//   void saveMessage() {
//     const snackBar = SnackBar(
//       content: Text(
//         'Note Saved Successfully',
//         style: TextStyle(
//           fontSize: 16,
//           color: Colors.black,
//           fontWeight: FontWeight.bold,
//         ),
//         textAlign: TextAlign.center, // Center align the text
//       ),
//       backgroundColor: Colors.blue, // Background color
//       duration: Duration(seconds: 3), // Duration of SnackBar will be shown
//     );

//     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   }

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     // double screenHeight = MediaQuery.of(context).size.height;

//     final _toolbarColor = Theme.of(context).colorScheme.tertiary;
//     final _backgroundColor = isLightMode ? Colors.white : Colors.black; // Dynamic background color
//     final _toolbarIconColor = Theme.of(context).colorScheme.primary;
//     final _editorTextStyle = TextStyle(
//       fontSize: 18,
//       color: isLightMode ? Colors.black : Colors.white, // Text color based on mode
//       fontWeight: FontWeight.normal,
//       fontFamily: 'Roboto',
//     );
//     final _hintTextStyle = TextStyle(
//       fontSize: 18,
//       color: Theme.of(context).colorScheme.secondary,
//       fontWeight: FontWeight.normal,
//     );

//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.surface,
//       body: SafeArea(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(
//                 top: 5,
//                 left: 5,
//                 right: 5,
//                 bottom: 12,
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       color: Theme.of(context).colorScheme.surface,
//                     ),
//                     child: BackButton(
//                       color: Theme.of(context).colorScheme.primary,
//                     ),
//                   ),
//                   Text(
//                     note.id.isEmpty ? 'ADD NOTE' : 'EDIT NOTE',
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 20,
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           color: Colors.blueAccent,
//                         ),
//                         child: IconButton(
//                           onPressed: () {
//                             saveNotes();
//                             Navigator.pop(context);
//                             saveMessage(); //save confirmation message
//                           },
//                           icon: const Icon(
//                             Icons.save,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ),
//                       if (note.id.isNotEmpty) const SizedBox(width: 10),
//                       if (note.id.isNotEmpty)
//                         Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             color: Colors.redAccent,
//                           ),
//                           child: IconButton(
//                             onPressed: () {
//                               deleteConfirmation();
//                             },
//                             icon: const Icon(
//                               Icons.delete,
//                               color: Colors.black,
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               width: screenWidth,
//               color: Colors.blueAccent,
//               child: MaterialButton(
//                 onPressed: () {
//                   setState(() {
//                     _showToolbar = !_showToolbar;
//                   });
//                 },
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Icon(
//                       _showToolbar
//                           ? Icons.keyboard_arrow_up
//                           : Icons.keyboard_arrow_down,
//                       color: Colors.black,
//                       size: 28,
//                     ),
//                     const SizedBox(width: 8),
//                     const Text(
//                       'TOOLBAR',
//                       style: TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 18),
//                     ),
//                     const SizedBox(width: 8),
//                     FlutterSwitch(
//                       width: 55.0,
//                       height: 25.0,
//                       valueFontSize: 12.0,
//                       toggleSize: 18.0,
//                       value: isLightMode,
//                       borderRadius: 30.0,
//                       padding: 3.0,
//                       showOnOff: true,
//                       onToggle: (val) {
//                         setState(() {
//                           isLightMode = val;
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             if (_showToolbar)
//               ToolBar(
//                 toolBarColor: _toolbarColor,
//                 padding: const EdgeInsets.all(10),
//                 iconSize: 25,
//                 iconColor: _toolbarIconColor,
//                 activeIconColor: Colors.blue,
//                 controller: controller,
//                 crossAxisAlignment: WrapCrossAlignment.center,
//                 direction: Axis.horizontal,
//               ),
//             Expanded(
//               child: QuillHtmlEditor(
//                 text: htmlContent,
//                 hintText: 'Add your text here...',
//                 controller: controller,
//                 isEnabled: true,
//                 ensureVisible: false,
//                 minHeight: 800,
//                 autoFocus: false,
//                 textStyle: _editorTextStyle,
//                 hintTextStyle: _hintTextStyle,
//                 hintTextAlign: TextAlign.start,
//                 padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
//                 hintTextPadding: const EdgeInsets.only(left: 20),
//                 backgroundColor: _backgroundColor, // Use dynamic background color
//                 inputAction: InputAction.newline,
//                 onEditingComplete: (s) => debugPrint('Editing completed: $s'),
//                 loadingBuilder: (context) {
//                   return const Center(
//                     child: CircularProgressIndicator(
//                       strokeWidth: 2,
//                       color: Colors.blue,
//                     ),
//                   );
//                 },
//                 onFocusChanged: (focus) {
//                   debugPrint('Has focus: $focus');
//                   setState(() {});
//                 },
//                 onTextChanged: (text) => debugPrint('Text changed: $text'),
//                 onEditorCreated: () {
//                   debugPrint('Editor has been loaded');
//                 },
//                 onEditorResized: (height) =>
//                     debugPrint('Editor resized: $height'),
//                 onSelectionChanged: (sel) => debugPrint(
//                     'Selection changed: index ${sel.index}, range ${sel.length}'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget textButton({required String text, required VoidCallback onPressed}) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: MaterialButton(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         color: Theme.of(context).colorScheme.primary,
//         onPressed: onPressed,
//         child: Text(
//           text,
//           style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
//         ),
//       ),
//     );
//   }

//   void saveNotes() async {
//     DateTime now = DateTime.now();

//     // Retrieve HTML content from the editor
//     String? htmlContent = await controller.getText();

//     if (note.id.isEmpty) {
//       await myNotes.add({
//         'uid': uid,
//         'note': htmlContent, // Save HTML content or empty string if null
//         'color': color,
//         'createdAt': now,
//       });
//     } else {
//       await myNotes.doc(note.id).update({
//         'note': htmlContent,
//         'color': color,
//         'updatedAt': now,
//       });
//     }
//   }
// }








import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note/models/note_model.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

class NoteScreen extends StatefulWidget {
  final Note note;
  const NoteScreen({super.key, required this.note});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  late QuillEditorController controller;
  late String uid;
  late Note note;
  late int color;
  String htmlContent = ''; // Initialize htmlContent

  final CollectionReference myNotes =
      FirebaseFirestore.instance.collection('Notes');

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    uid = user?.uid ?? '';
    note = widget.note;
    color = note.color == 0xFFFFFFFF ? generateRandomLightColor() : note.color;

    controller = QuillEditorController();
    controller.onTextChanged((text) {
      debugPrint('Text changed: $text');
    });
    controller.onEditorLoaded(() {
      debugPrint('Editor Loaded');
    });

    // Fetch the note content if the note already exists
    if (note.id.isNotEmpty) {
      fetchNote();
    }
  }

  Future<void> fetchNote() async {
    DocumentSnapshot doc = await myNotes.doc(note.id).get();
    if (doc.exists) {
      setState(() {
        htmlContent = doc['note'] ?? '';
        controller
            .setText(htmlContent); // Set the fetched content to the editor
      });
    }
  }

  final customToolBarList = [
    ToolBarStyle.bold,
    ToolBarStyle.italic,
    ToolBarStyle.align,
    ToolBarStyle.color,
    ToolBarStyle.background,
    ToolBarStyle.listBullet,
    ToolBarStyle.listOrdered,
    ToolBarStyle.clean,
    ToolBarStyle.addTable,
    ToolBarStyle.editTable,
  ];

  bool _showToolbar = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void deleteConfirmation() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Container(
            width: screenWidth * 0.9,
            height: screenHeight * 0.25,
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/images/question_mark_logo.png',
                  height: 80,
                  width: 80,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Are you sure?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  'This Note will be deleted permanently. You can\'t undo this action.',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Container(
                      height: 45,
                      width: 110,
                      alignment: Alignment.center,
                      color: const Color.fromARGB(255, 156, 211, 255),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 110, 255),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    myNotes.doc(note.id).delete();
                    Navigator.pop(context); // Close the dialog
                    Navigator.pop(context); // Close the Note
                    deleteMessage(); // Display note deleted message
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Container(
                      height: 45,
                      width: 110,
                      alignment: Alignment.center,
                      color: const Color.fromARGB(255, 255, 157, 150),
                      child: const Text(
                        'Yes',
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 0, 0),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void deleteMessage() {
    const snackBar = SnackBar(
      content: Text(
        'Note Deleted Successfully',
        style: TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center, // Center align the text
      ),
      backgroundColor: Colors.red, // Background color
      duration: Duration(seconds: 3), // Duration of SnackBar will be shown
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void saveMessage() {
    const snackBar = SnackBar(
      content: Text(
        'Note Saved Successfully',
        style: TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center, // Center align the text
      ),
      backgroundColor: Colors.blue, // Background color
      duration: Duration(seconds: 3), // Duration of SnackBar will be shown
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;

    final _toolbarColor = Theme.of(context).colorScheme.tertiary;
    final _backgroundColor = Theme.of(context).colorScheme.surfaceTint;
    final _toolbarIconColor = Theme.of(context).colorScheme.primary;
    final _editorTextStyle = TextStyle(
      fontSize: 18,
      color: Theme.of(context).colorScheme.primary,
      fontWeight: FontWeight.normal,
      fontFamily: 'Roboto',
    );
    final _hintTextStyle = TextStyle(
      fontSize: 18,
      color: Theme.of(context).colorScheme.secondary,
      fontWeight: FontWeight.normal,
    );

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 5,
                left: 5,
                right: 5,
                bottom: 12,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    child: BackButton(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(
                    note.id.isEmpty ? 'ADD NOTE' : 'EDIT NOTE',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blueAccent,
                        ),
                        child: IconButton(
                          onPressed: () {
                            saveNotes();
                            Navigator.pop(context);
                            saveMessage(); //save confirmation message
                          },
                          icon: const Icon(
                            Icons.save,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      if (note.id.isNotEmpty) const SizedBox(width: 10),
                      if (note.id.isNotEmpty)
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.redAccent,
                          ),
                          child: IconButton(
                            onPressed: () {
                              deleteConfirmation();
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.black,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: screenWidth,
              color: Colors.blueAccent,
              child: MaterialButton(
                
                onPressed: () {
                  setState(() {
                    _showToolbar = !_showToolbar;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      _showToolbar
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Colors.black,
                      size: 28,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'TOOLBAR',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            if (_showToolbar)
              ToolBar(
                toolBarColor: _toolbarColor,
                padding: const EdgeInsets.all(10),
                iconSize: 25,
                iconColor: _toolbarIconColor,
                activeIconColor: Colors.blue,
                controller: controller,
                crossAxisAlignment: WrapCrossAlignment.center,
                direction: Axis.horizontal,
              ),
            Expanded(
              child: QuillHtmlEditor(
                text: htmlContent,
                hintText: 'Add your text here...',
                controller: controller,
                isEnabled: true,
                ensureVisible: false,
                minHeight: 800,
                autoFocus: false,
                textStyle: _editorTextStyle,
                hintTextStyle: _hintTextStyle,
                hintTextAlign: TextAlign.start,
                padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                hintTextPadding: const EdgeInsets.only(left: 20),
                backgroundColor: _backgroundColor,
                inputAction: InputAction.newline,
                onEditingComplete: (s) => debugPrint('Editing completed: $s'),
                loadingBuilder: (context) {
                  return const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.blue,
                    ),
                  );
                },
                onFocusChanged: (focus) {
                  debugPrint('Has focus: $focus');
                  setState(() {});
                },
                onTextChanged: (text) => debugPrint('Text changed: $text'),
                onEditorCreated: () {
                  debugPrint('Editor has been loaded');
                },
                onEditorResized: (height) =>
                    debugPrint('Editor resized: $height'),
                onSelectionChanged: (sel) => debugPrint(
                    'Selection changed: index ${sel.index}, range ${sel.length}'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget textButton({required String text, required VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        color: Theme.of(context).colorScheme.primary,
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
    );
  }

  void saveNotes() async {
    DateTime now = DateTime.now();

    // Retrieve HTML content from the editor
    String? htmlContent = await controller.getText();

    if (note.id.isEmpty) {
      await myNotes.add({
        'uid': uid,
        'note': htmlContent, // Save HTML content or empty string if null
        'color': color,
        'createdAt': now,
      });
    } else {
      await myNotes.doc(note.id).update({
        'note': htmlContent,
        'color': color,
        'updatedAt': now,
      });
    }
  }
}
