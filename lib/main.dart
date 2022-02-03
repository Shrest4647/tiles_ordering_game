import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiles_ordering_game/game_page.dart';

final counterProvider = StateProvider<int>((ref) {
  return 0;
});

final darkModeProvider = StateProvider<bool>((ref) {
  return false;
});

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: const TilesGamePage(),
        appBar: AppBar(),
      ),
    );
  }
}

class MyDrawer extends ConsumerWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int _counter = ref.watch(counterProvider);
    bool isDark = ref.watch(darkModeProvider);
    return Drawer(
      child: Column(
        children: [
          Text('Drawer ${isDark ? "ON" : "OFF"}'),
          Switch(
            value: isDark,
            onChanged: (value) =>
                (ref.read(darkModeProvider.state).state = value),
          ),
          const Text(
            'You have pushed the button this many times:',
          ),
          Text(
            '$_counter',
            style: Theme.of(context).textTheme.headline4,
          ),
          ElevatedButton.icon(
            onPressed: () => ref.read(counterProvider.state).state++,
            icon: const Icon(Icons.key),
            label: const Text('Press'),
          ),
        ],
      ),
    );
  }
}
