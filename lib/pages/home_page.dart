import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:note/components/note_card.dart';
import 'package:note/models/note_model.dart';
import 'package:note/pages/note_screen.dart';
import 'package:note/pages/signUp_logIn_selector.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CollectionReference myNotes =
      FirebaseFirestore.instance.collection('Notes');
  late Future<String?> uidFuture;
  String? userEmail;
  int noteCount = 0;
  late StreamSubscription<QuerySnapshot> noteSubscription;

  @override
  void initState() {
    super.initState();
    uidFuture = _getCurrentUserUid();
    _getUserEmail();
    _fetchNoteCount();
  }

  @override
  void dispose() {
    noteSubscription.cancel();
    super.dispose();
  }

  Future<String?> _getCurrentUserUid() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      return user?.uid;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching user UID: $e');
      }
      return null;
    }
  }

  void _logOut(BuildContext context) {
    FirebaseAuth.instance.signOut().then((_) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SignupLoginSelector()),
      );
    });
  }

  Future<void> _getUserEmail() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      setState(() {
        userEmail = user?.email;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching user email: $e');
      }
    }
  }

  Future<void> _fetchNoteCount() async {
    final uid = await uidFuture;
    if (uid != null) {
      final querySnapshot = await myNotes.where('uid', isEqualTo: uid).get();
      setState(() {
        noteCount = querySnapshot.size;
      });

      // Listen for changes in the notes collection
      noteSubscription =
          myNotes.where('uid', isEqualTo: uid).snapshots().listen((snapshot) {
        setState(() {
          noteCount = snapshot.size;
        });
      });
    }
  }

  List<NoteCard> _buildNoteCards(List<QueryDocumentSnapshot> notes) {
    List<NoteCard> noteCards = [];
    for (var note in notes) {
      var data = note.data() as Map<String, dynamic>?;
      if (data != null) {
        Note noteObject = Note(
          uid: data['uid'],
          id: note.id,
          note: data['note'] ?? "",
          createdAt: data.containsKey('createdAt')
              ? (data['createdAt'] as Timestamp).toDate()
              : DateTime.now(),
          updatedAt: data.containsKey('updatedAt')
              ? (data['updatedAt'] as Timestamp).toDate()
              : DateTime.now(),
          color: data.containsKey('color') ? data['color'] : 0xFFFFFFFF,
        );
        noteCards.add(
          NoteCard(
            note: noteObject,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoteScreen(note: noteObject),
                ),
              );
            },
          ),
        );
      }
    }
    return noteCards;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Row(
          children: [
            Expanded(
              child: Text(
                'N O T E S',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 30,
                ),
              ),
            ),
          ],
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.black,
                size: 38,
                weight: 10,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          children: [
            Container(
                color: const Color.fromARGB(255, 10, 34, 170),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        top: 15,
                        bottom: 10,
                      ),
                      child: Image.asset(
                        'assets/images/Note_App_Logo.png',
                        height: 80,
                        width: 80,
                        fit: BoxFit.contain,
                      ),
                    ),
                    if (userEmail != null) ...[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$userEmail',
                                style: const TextStyle(
                                  color: Colors.lightBlueAccent,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                              ),
                              Text(
                                'Notes : $noteCount',
                                style: TextStyle(
                                  color: Colors.lightBlue[600],
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    Padding(
                      padding: const EdgeInsets.only(right: 0),
                      child: IconButton(
                        icon: const Icon(
                          Icons.keyboard_arrow_left,
                          color: Colors.white,
                          size: 40,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                )),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Log Out'),
                    onTap: () => _logOut(context),
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Profile Settings'),
                    onTap: () => (),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.white,
        child: FutureBuilder<String?>(
          future: uidFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              );
            } else if (snapshot.hasError || !snapshot.hasData) {
              return const Center(child: Text('Error fetching user data.'));
            }

            final uid = snapshot.data!;
            return StreamBuilder<QuerySnapshot>(
              stream: myNotes.where('uid', isEqualTo: uid).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  );
                }
                final notes = snapshot.data!.docs;
                final noteCards = _buildNoteCards(notes);
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: noteCards.length,
                  itemBuilder: (context, index) {
                    return noteCards[index];
                  },
                  padding: const EdgeInsets.all(10),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NoteScreen(
                note: Note(
                  uid: '',
                  id: '',
                  note: '',
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                ),
              ),
            ),
          );
        },
        backgroundColor: Colors.black,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
                           









// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:note/components/note_card.dart';
// import 'package:note/models/note_model.dart';
// import 'package:note/pages/note_screen.dart';
// import 'package:note/pages/signUp_logIn_selector.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final CollectionReference myNotes =
//       FirebaseFirestore.instance.collection('Notes');
//   late Future<String?> uidFuture;
//   String? userEmail;
//   int noteCount = 0;

//   @override
//   void initState() {
//     super.initState();
//     uidFuture = _getCurrentUserUid();
//     _getUserEmail();
//     _fetchNoteCount();
//   }

//   Future<String?> _getCurrentUserUid() async {
//     try {
//       User? user = FirebaseAuth.instance.currentUser;
//       return user?.uid;
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error fetching user UID: $e');
//       }
//       return null;
//     }
//   }

//   void _logOut(BuildContext context) {
//     FirebaseAuth.instance.signOut().then((_) {
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (context) => const SignupLoginSelector()),
//       );
//     });
//   }

//   Future<void> _getUserEmail() async {
//     try {
//       User? user = FirebaseAuth.instance.currentUser;
//       setState(() {
//         userEmail = user?.email;
//       });
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error fetching user email: $e');
//       }
//     }
//   }

//   Future<void> _fetchNoteCount() async {
//     final uid = await uidFuture;
//     if (uid != null) {
//       final querySnapshot = await myNotes.where('uid', isEqualTo: uid).get();
//       setState(() {
//         noteCount = querySnapshot.size;
//       });
//     }
//   }

//   List<NoteCard> _buildNoteCards(List<QueryDocumentSnapshot> notes) {
//     List<NoteCard> noteCards = [];
//     for (var note in notes) {
//       var data = note.data() as Map<String, dynamic>?;
//       if (data != null) {
//         Note noteObject = Note(
//           uid: data['uid'],
//           id: note.id,
//           note: data['note'] ?? "",
//           createdAt: data.containsKey('createdAt')
//               ? (data['createdAt'] as Timestamp).toDate()
//               : DateTime.now(),
//           updatedAt: data.containsKey('updatedAt')
//               ? (data['updatedAt'] as Timestamp).toDate()
//               : DateTime.now(),
//           color: data.containsKey('color') ? data['color'] : 0xFFFFFFFF,
//         );
//         noteCards.add(
//           NoteCard(
//             note: noteObject,
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => NoteScreen(note: noteObject),
//                 ),
//               );
//             },
//           ),
//         );
//       }
//     }
//     return noteCards;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         automaticallyImplyLeading: false,
//         title: const Row(
//           children: [
//             Expanded(
//               child: Text(
//                 'N O T E S',
//                 textAlign: TextAlign.left,
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                   fontSize: 30,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           Builder(
//             builder: (context) => IconButton(
//               icon: const Icon(
//                 Icons.menu,
//                 color: Colors.black,
//                 size: 38,
//                 weight: 10,
//               ),
//               onPressed: () => Scaffold.of(context).openDrawer(),
//             ),
//           ),
//         ],
//       ),
//       drawer: Drawer(
//         backgroundColor: Colors.white,
//         child: Column(
//           children: [
//             // Container(
//             //   color: Colors.black,
//             //   alignment: Alignment.center,
//             //   height: 90,
//             //   child: Row(
//             //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //     children: [
//             //       const Padding(
//             //         padding: EdgeInsets.only(left: 20),
//             //         child: Text(
//             //           'Menu',
//             //           style: TextStyle(
//             //             color: Colors.white,
//             //             fontSize: 25,
//             //           ),
//             //         ),
//             //       ),
//             //       Padding(
//             //         padding: const EdgeInsets.only(right: 5),
//             //         child: IconButton(
//             //           icon: const Icon(
//             //             Icons.keyboard_arrow_left,
//             //             color: Colors.white,
//             //             size: 35,
//             //           ),
//             //           onPressed: () {
//             //             Navigator.pop(context);
//             //           },
//             //         ),
//             //       ),
//             //     ],
//             //   ),
//             // ),
//             Container(
//                 color: Color.fromARGB(255, 10, 34, 170),
//                 alignment: Alignment.center,
//                 padding: const EdgeInsets.symmetric(
//                     vertical:
//                         10), // Added padding to vertically center contents
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(
//                         left: 10,
//                         top: 15,
//                         bottom: 10,
//                       ),
//                       child: Image.asset(
//                         'assets/images/Note_App_Logo.png',
//                         height: 80,
//                         width: 80,
//                         fit: BoxFit.contain,
//                       ),
//                     ),
//                     if (userEmail != null) ...[
//                       Expanded(
//                         // Ensures that the text takes up available space
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 10),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 // 'User: $userEmail',
//                                 '$userEmail',
//                                 style: const TextStyle(
//                                   color: Colors.lightBlueAccent,
//                                   fontSize: 15,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                                 overflow: TextOverflow
//                                     .ellipsis, // Wrap text if necessary
//                                 maxLines: 3,
//                               ),
//                               Text(
//                                 'Notes : $noteCount',
//                                 style: TextStyle(
//                                   color: Colors.lightBlue[600],
//                                   fontSize: 15,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                                 overflow: TextOverflow.ellipsis,
//                                 maxLines: 2,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                     Padding(
//                       padding: const EdgeInsets.only(right: 0),
//                       child: IconButton(
//                         icon: const Icon(
//                           Icons.keyboard_arrow_left,
//                           color: Colors.white,
//                           size: 40,
//                         ),
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                       ),
//                     ),
//                   ],
//                 )),

//             Expanded(
//               child: ListView(
//                 children: [
//                   ListTile(
//                     leading: const Icon(Icons.logout),
//                     title: const Text('Log Out'),
//                     onTap: () => _logOut(context),
//                   ),
//                   ListTile(
//                     leading: const Icon(Icons.settings),
//                     title: const Text('Profile Settings'),
//                     onTap: () => (),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: Container(
//         color: Colors.white,
//         child: FutureBuilder<String?>(
//           future: uidFuture,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(
//                 child: CircularProgressIndicator(
//                   valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
//                 ),
//               );
//             } else if (snapshot.hasError || !snapshot.hasData) {
//               return const Center(child: Text('Error fetching user data.'));
//             }

//             final uid = snapshot.data!;
//             return StreamBuilder<QuerySnapshot>(
//               stream: myNotes.where('uid', isEqualTo: uid).snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return const Center(
//                     child: CircularProgressIndicator(
//                       valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
//                     ),
//                   );
//                 }
//                 final notes = snapshot.data!.docs;
//                 final noteCards = _buildNoteCards(notes);
//                 return GridView.builder(
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     crossAxisSpacing: 10,
//                     mainAxisSpacing: 10,
//                   ),
//                   itemCount: noteCards.length,
//                   itemBuilder: (context, index) {
//                     return noteCards[index];
//                   },
//                   padding: const EdgeInsets.all(10),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => NoteScreen(
//                 note: Note(
//                   uid: '',
//                   id: '',
//                   note: '',
//                   createdAt: DateTime.now(),
//                   updatedAt: DateTime.now(),
//                 ),
//               ),
//             ),
//           );
//         },
//         backgroundColor: Colors.black,
//         child: const Icon(
//           Icons.add,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }
// }
