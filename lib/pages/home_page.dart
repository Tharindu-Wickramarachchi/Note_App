import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:note/components/note_card.dart';
import 'package:note/models/note_model.dart';
import 'package:note/models/theme.dart';
import 'package:note/pages/note_screen.dart';
import 'package:note/pages/signUp_logIn_selector.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:note/models/theme_provider.dart';

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
  bool isSingleColumn = false;

  @override
  void initState() {
    super.initState();
    uidFuture = _getCurrentUserUid();
    _getUserEmail();
    _fetchNoteCount();
    _loadLayoutState();
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

      noteSubscription =
          myNotes.where('uid', isEqualTo: uid).snapshots().listen((snapshot) {
        setState(() {
          noteCount = snapshot.size;
        });
      });
    }
  }

  Future<void> _loadLayoutState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isSingleColumn = prefs.getBool('isSingleColumn') ?? false;
    });
  }

  Future<void> _saveLayoutState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isSingleColumn', isSingleColumn);
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Expanded(
              child: Text(
                'N O T E S',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 30,
                ),
              ),
            ),
          ],
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(
                Icons.menu,
                color: Theme.of(context).colorScheme.primary,
                size: 42,
                weight: 10,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Theme.of(context).colorScheme.surface,
        child: Column(
          children: [
            Container(
              color: const Color.fromARGB(255, 0, 16, 109),
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
                            Padding(
                              padding: const EdgeInsets.only(bottom: 2),
                              child: Text(
                                '$userEmail',
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 39, 187, 255),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                              ),
                            ),
                            Text(
                              'Notes : $noteCount',
                              style: const TextStyle(
                                color: Color.fromARGB(255, 3, 201, 191),
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
              ),
            ),
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
                    onTap: () {
                      // Add profile settings functionality here
                    },
                  ),
                  ListTile(
                    leading:
                        Icon(isSingleColumn ? Icons.grid_on : Icons.view_list),
                    title: Text(isSingleColumn
                        ? 'Switch to Grid View'
                        : 'Switch to List View'),
                    onTap: () {
                      setState(() {
                        isSingleColumn = !isSingleColumn;
                        _saveLayoutState();
                      });
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: FlutterSwitch(
                width: MediaQuery.of(context).size.width * 0.18,
                height: MediaQuery.of(context).size.height * 0.035,
                valueFontSize: 12,
                value: themeProvider.themeData == darkMode,
                borderRadius: 30,
                padding: 3.5,
                showOnOff: true,
                inactiveColor: Colors.grey.shade800,
                activeColor: Colors.blue.shade200,
                inactiveText: 'Dark',
                activeText: 'Light',
                inactiveTextColor: Colors.white,
                activeTextColor: Colors.black,
                inactiveToggleColor: Colors.grey.shade300,
                activeToggleColor: Colors.yellow.shade800,
                onToggle: (val) {
                  themeProvider.toggleTheme();
                },
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.surface,
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
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isSingleColumn ? 1 : 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: isSingleColumn ? 2.5 : 1.0,
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
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.surface,
        ),
      ),
    );
  }
}
