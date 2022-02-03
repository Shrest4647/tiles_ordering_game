import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TilesNotifier extends StateNotifier<List<int>> {
  TilesNotifier() : super(List.generate(9, (index) => ++index)) {
    state.shuffle();
  }
  swap(int a, int b) {
    List prev = [...state];
    int temp = prev[a];
    prev[a] = prev[b];
    prev[b] = temp;
    state = [...prev];
  }
}

final tilesNotifierProvider =
    StateNotifierProvider<TilesNotifier, List<int>>((ref) {
  return TilesNotifier();
});

final gameWinStateProvider = StateProvider<bool>((ref) {
  final tiles = ref.watch(tilesNotifierProvider);
  return tiles.firstWhere((element) => tiles.indexOf(element) != (element - 1),
          orElse: () => -1) ==
      -1;
});

class GameStatus extends ConsumerWidget {
  const GameStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isWinning = ref.watch(gameWinStateProvider);
    if (isWinning) {
      return const Text(
        'Congratulations! You Won.',
        style: TextStyle(fontSize: 20),
      );
    }
    return const SizedBox();
  }
}

class TilesGamePage extends StatelessWidget {
  const TilesGamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const GameStatus(),
            const SizedBox(
              height: 400,
              width: 400,
              child: AspectRatio(
                aspectRatio: 1,
                child: TilesGameGrid(),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Stack(
              children: const [
                Center(
                    child: CircleAvatar(
                  radius: 75,
                  child: SizedBox(
                    height: 150,
                  ),
                )),
                Center(
                  child: SizedBox(
                    height: 150,
                    width: 150,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: TilesControls(),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class TilesControls extends ConsumerWidget {
  const TilesControls({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<int> tiles = ref.watch(tilesNotifierProvider);

    return GridView.count(
      crossAxisCount: 3,
      children: [
        const SizedBox(),
        Card(
          child: FittedBox(
            child: IconButton(
              onPressed: () {
                int currentIndex = tiles.indexOf(9);
                if ((currentIndex ~/ 3) < 1) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Move Invalid'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                } else {
                  ref
                      .read(tilesNotifierProvider.notifier)
                      .swap(currentIndex, currentIndex - 3);
                }
              },
              icon: const Icon(
                Icons.keyboard_arrow_up,
              ),
            ),
          ),
        ),
        const SizedBox(),
        Card(
          child: FittedBox(
            child: IconButton(
              onPressed: () {
                int currentIndex = tiles.indexOf(9);
                if ((currentIndex % 3) < 1) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Move Invalid'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                } else {
                  ref
                      .read(tilesNotifierProvider.notifier)
                      .swap(currentIndex, currentIndex - 1);
                }
              },
              icon: const Icon(
                Icons.keyboard_arrow_left,
              ),
            ),
          ),
        ),
        const SizedBox(),
        Card(
          child: FittedBox(
            child: IconButton(
              onPressed: () {
                int currentIndex = tiles.indexOf(9);
                if ((currentIndex % 3) > 1) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Move Invalid'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                } else {
                  ref
                      .read(tilesNotifierProvider.notifier)
                      .swap(currentIndex, currentIndex + 1);
                }
              },
              icon: const Icon(
                Icons.keyboard_arrow_right,
              ),
            ),
          ),
        ),
        const SizedBox(),
        Card(
          child: FittedBox(
            child: IconButton(
              onPressed: () {
                int currentIndex = tiles.indexOf(9);
                if (currentIndex ~/ 3 > 1) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Move Invalid'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                } else {
                  ref
                      .read(tilesNotifierProvider.notifier)
                      .swap(currentIndex, currentIndex + 3);
                }
              },
              icon: const Icon(
                Icons.keyboard_arrow_down,
              ),
            ),
          ),
        ),
        const SizedBox(),
      ],
    );
  }
}

class TilesGameGrid extends ConsumerWidget {
  const TilesGameGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<int> tiles = ref.watch(tilesNotifierProvider);
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.red,
          width: 5,
        ),
      ),
      child: GridView.builder(
          dragStartBehavior: DragStartBehavior.down,
          itemCount: 9,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 1,
            crossAxisSpacing: 1,
          ),
          itemBuilder: (context, index) {
            return GridTile(
              child: Card(
                color: tiles[index] == 9 ? Colors.black26 : Colors.amber,
                child: FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: tiles[index] == 9 ? null : Text('${tiles[index]}'),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
