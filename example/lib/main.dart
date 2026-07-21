import 'package:blinklink_feed/blinklink_feed.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Blinklink.initialize(
    clientId: '2304e68a-a385-4d55-aa2a-6875b4099381',
    environment: BlinklinkEnvironment.development,
    stream: 'STREAM0001',
    placement: 'PLACEMENT0001',
  );
  Blinklink.actions.listen(
    // ignore: avoid_print
    (action) => print('blinklink action: $action'),
  );
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blinklink Example',
      theme: ThemeData(colorSchemeSeed: Colors.deepOrange, useMaterial3: true),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _tab,
        children: const [
          _HostHome(),
          BlinklinkScreen(screenId: 'inspire'),
          BlinklinkSuperFeed(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.auto_awesome), label: 'Inspire'),
          NavigationDestination(icon: Icon(Icons.play_circle), label: 'Videos'),
        ],
      ),
    );
  }
}

class _HostHome extends StatelessWidget {
  const _HostHome();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text(
            'Host app home',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          SizedBox(
            height: 320,
            child: BlinklinkFeedView(layout: FeedLayout.carousel, title: 'Today'),
          ),
        ],
      ),
    );
  }
}
