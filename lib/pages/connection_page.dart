import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MeApp());
}

class MeApp extends StatelessWidget {
  const MeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<InternetConnectionStatus>(
      initialData: InternetConnectionStatus.connected,
      create: (_) {
        return InternetConnectionChecker().onStatusChange;
      },
      child: const MaterialApp(
        home: ConnectionStatusPage(),
      ),
    );
  }
}

class InternetNotAvailable extends StatelessWidget {
  const InternetNotAvailable({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width: MediaQuery.of(context).size.width,
      color: Colors.red,
      child: const Center(
        child: Text(
          'No Internet Connection!!!',
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }
}

class ConnectionStatusPage extends StatelessWidget {
  const ConnectionStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    final internetStatus = Provider.of<InternetConnectionStatus>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Visibility(
              visible: internetStatus == InternetConnectionStatus.disconnected,
              child: const InternetNotAvailable(),
            ),
          ],
        ),
      ),
    );
  }
}


