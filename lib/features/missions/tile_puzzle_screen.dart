import 'package:flutter/material.dart';
import '../../core/design_system/colors.dart';

class TilePuzzleScreen extends StatefulWidget {
  const TilePuzzleScreen({super.key});

  @override
  State<TilePuzzleScreen> createState() => _TilePuzzleScreenState();
}

class _TilePuzzleScreenState extends State<TilePuzzleScreen> {
  final List<int?> _tiles = List.generate(8, (index) => index + 1)..add(null);

  @override
  void initState() {
    super.initState();
    _tiles.shuffle();
  }

  void _onTileTap(int index) {
    int? emptyIndex;
    if (index > 0 && _tiles[index - 1] == null) {
      emptyIndex = index - 1;
    } else if (index < 8 && _tiles[index + 1] == null)
      emptyIndex = index + 1;
    else if (index > 2 && _tiles[index - 3] == null)
      emptyIndex = index - 3;
    else if (index < 6 && _tiles[index + 3] == null)
      emptyIndex = index + 3;

    if (emptyIndex != null) {
      setState(() {
        _tiles[emptyIndex!] = _tiles[index];
        _tiles[index] = null;
      });
      _checkWin();
    }
  }

  void _checkWin() {
    bool win = true;
    for (int i = 0; i < 8; i++) {
      if (_tiles[i] != i + 1) {
        win = false;
        break;
      }
    }
    if (win) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Puzzle Solved! Focus level: High.')),
      );
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tile Puzzle')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Rearrange tiles in order'),
            const SizedBox(height: 32),
            Container(
              width: 300,
              height: 300,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: HelioColors.cardDark,
                borderRadius: BorderRadius.circular(16),
              ),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                ),
                itemCount: 9,
                itemBuilder: (context, index) {
                  final tile = _tiles[index];
                  if (tile == null) return const SizedBox.shrink();
                  return GestureDetector(
                    onTap: () => _onTileTap(index),
                    child: Container(
                      decoration: BoxDecoration(
                        color: HelioColors.sunriseOrange,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '$tile',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 40),
            TextButton(
              onPressed: () => setState(() => _tiles.shuffle()),
              child: const Text('Shuffle Again'),
            ),
          ],
        ),
      ),
    );
  }
}
