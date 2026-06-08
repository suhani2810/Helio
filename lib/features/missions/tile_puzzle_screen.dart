import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/design_system/colors.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/theme/theme_mode_enum.dart';
import '../../widgets/theme/sky_background.dart';
import '../../widgets/premium_card.dart';

class TilePuzzleScreen extends ConsumerStatefulWidget {
  const TilePuzzleScreen({super.key});

  @override
  ConsumerState<TilePuzzleScreen> createState() => _TilePuzzleScreenState();
}

class _TilePuzzleScreenState extends ConsumerState<TilePuzzleScreen> {
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
    } else if (index < 8 && _tiles[index + 1] == null) {
      emptyIndex = index + 1;
    } else if (index > 2 && _tiles[index - 3] == null) {
      emptyIndex = index - 3;
    } else if (index < 6 && _tiles[index + 3] == null) {
      emptyIndex = index + 3;
    }

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
    final themeMode = ref.watch(themeControllerProvider);
    final isNight = _isNightMode(themeMode, DateTime.now().hour);
    final textColor = isNight ? Colors.white : HelioColors.dayText;
    final primaryColor = isNight ? HelioColors.nightPrimary : HelioColors.dayPrimary;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SkyBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_rounded, color: textColor),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      'Tile Puzzle',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                'Rearrange in order (1-8)',
                style: TextStyle(
                  color: textColor.withOpacity(0.6),
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 32),
              PremiumCard(
                isGlass: isNight,
                padding: const EdgeInsets.all(12),
                child: Container(
                  width: 320,
                  height: 320,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                    ),
                    itemCount: 9,
                    itemBuilder: (context, index) {
                      final tile = _tiles[index];
                      if (tile == null) return const SizedBox.shrink();
                      return GestureDetector(
                        onTap: () => _onTileTap(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              '$tile',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 48),
              TextButton.icon(
                onPressed: () => setState(() => _tiles.shuffle()),
                icon: Icon(Icons.refresh_rounded, color: primaryColor),
                label: Text(
                  'SHUFFLE AGAIN',
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const Spacer(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  bool _isNightMode(AppThemeMode mode, int hour) {
    if (mode == AppThemeMode.night) return true;
    if (mode == AppThemeMode.day) return false;
    return hour < 5 || hour >= 19;
  }
}
