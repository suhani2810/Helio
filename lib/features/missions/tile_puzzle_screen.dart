import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/design_system/colors.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/theme/theme_mode_enum.dart';
import '../../widgets/theme/sky_background.dart';
import '../../widgets/premium_card.dart';
import '../../core/services/mission_service.dart';
import '../mood/mood_tracking_screen.dart';
import '../../models/alarm_entity.dart';

class TilePuzzleScreen extends ConsumerStatefulWidget {
  final bool isPreview;
  final DateTime? scheduledTime;
  final AlarmEntity? alarm;

  const TilePuzzleScreen({
    super.key,
    this.isPreview = false,
    this.scheduledTime,
    this.alarm,
  });

  @override
  ConsumerState<TilePuzzleScreen> createState() => _TilePuzzleScreenState();
}

class _TilePuzzleScreenState extends ConsumerState<TilePuzzleScreen>
    with SingleTickerProviderStateMixin {
  late int _difficulty;
  late int _gridSize;
  late int _totalTaps;
  late List<int> _numbers;
  int _mistakesCount = 0;
  late DateTime _startTime;
  int? _errorTileIndex;
  bool _isSuccess = false;

  late final AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _difficulty = widget.alarm?.puzzleDifficulty ?? 1;
    _initPuzzle();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  int _countInversions(List<int> list) {
    int inversions = 0;
    for (int i = 0; i < list.length; i++) {
      for (int j = i + 1; j < list.length; j++) {
        if (list[i] != 0 && list[j] != 0 && list[i] > list[j]) {
          inversions++;
        }
      }
    }
    return inversions;
  }

  bool _isSolvable(List<int> list, int gridSize) {
    int inversions = _countInversions(list);
    if (gridSize % 2 == 1) {
      // For odd grid sizes (3x3, 5x5): solvable if inversions count is even
      return inversions % 2 == 0;
    } else {
      // For even grid sizes (4x4): solvable if (inversions + blankRowFromBottom) is odd
      int blankIndex = list.indexOf(0);
      int blankRowFromTop = blankIndex ~/ gridSize;
      int blankRowFromBottom = gridSize - blankRowFromTop;
      return (inversions + blankRowFromBottom) % 2 == 1;
    }
  }

  bool _isSolved(List<int> list) {
    int totalTiles = list.length;
    for (int i = 0; i < totalTiles - 1; i++) {
      if (list[i] != i + 1) return false;
    }
    return list[totalTiles - 1] == 0;
  }

  List<int> _generateSolvablePuzzle(int gridSize) {
    int totalTiles = gridSize * gridSize;
    List<int> list = List.generate(totalTiles, (index) => (index + 1) % totalTiles); // [1, 2, ..., N-1, 0]
    
    final random = Random();
    do {
      list.shuffle(random);
    } while (!_isSolvable(list, gridSize) || _isSolved(list));
    
    return list;
  }

  void _initPuzzle() {
    if (_difficulty == 0) {
      _gridSize = 3;
    } else if (_difficulty == 1) {
      _gridSize = 4;
    } else {
      _gridSize = 5;
    }
    _totalTaps = _gridSize * _gridSize;
    _numbers = _generateSolvablePuzzle(_gridSize);
    _mistakesCount = 0;
    _startTime = DateTime.now();
    _isSuccess = false;
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _onTileTap(int index) {
    if (_isSuccess) return;
    
    // Find the blank tile index (contains 0)
    int blankIndex = _numbers.indexOf(0);
    
    // Get row/col for both
    int row = index ~/ _gridSize;
    int col = index % _gridSize;
    int blankRow = blankIndex ~/ _gridSize;
    int blankCol = blankIndex % _gridSize;
    
    // Check if adjacent (horizontal or vertical)
    bool isAdjacent = (row == blankRow && (col - blankCol).abs() == 1) ||
                      (col == blankCol && (row - blankRow).abs() == 1);
                      
    if (isAdjacent) {
      setState(() {
        _numbers[blankIndex] = _numbers[index];
        _numbers[index] = 0;
      });
      
      if (_isSolved(_numbers)) {
        _finish();
      }
    } else {
      setState(() {
        _mistakesCount++;
        _errorTileIndex = index;
      });
      _shakeController.forward(from: 0.0);
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _errorTileIndex = null;
          });
        }
      });
    }
  }

  void _finish() async {
    setState(() {
      _isSuccess = true;
    });
    final duration = DateTime.now().difference(_startTime).inSeconds;

    if (!widget.isPreview) {
      await ref.read(missionServiceProvider).completeMission(
        missionType: 'Tile Puzzle',
        scheduledTime: widget.scheduledTime ?? DateTime.now(),
        alarm: widget.alarm,
        puzzleDifficulty: _difficulty,
        puzzleMistakes: _mistakesCount,
        puzzleCompletionTime: duration,
      );
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.isPreview 
              ? 'Preview Complete!' 
              : 'Solved with $_mistakesCount mistakes!'
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        if (widget.isPreview) {
          Navigator.pop(context);
        } else {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const MoodTrackingScreen()),
            (route) => route.isFirst,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeControllerProvider);
    final isNight = _isNightMode(themeMode, DateTime.now().hour);
    final textColor = isNight ? Colors.white : HelioColors.dayText;
    final primaryColor = isNight ? HelioColors.nightPrimary : HelioColors.dayPrimary;

    final diffLabels = ['Easy', 'Medium', 'Hard'];
    final diffColors = [HelioColors.success, primaryColor, HelioColors.warning];
    final diffColor = diffColors[_difficulty];
    final diffLabel = diffLabels[_difficulty];

    final double fontSize = _gridSize == 3
        ? 28
        : _gridSize == 4
            ? 22
            : 18;
    final double spacing = _gridSize == 3
        ? 12
        : _gridSize == 4
            ? 8
            : 6;

    // Count correct tiles (excluding blank)
    int correctCount = 0;
    for (int i = 0; i < _totalTaps - 1; i++) {
      if (_numbers[i] == i + 1) {
        correctCount++;
      }
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SkyBackground(
        showForeground: false,
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
              const SizedBox(height: 16),
              if (widget.isPreview)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    final label = diffLabels[index];
                    final color = diffColors[index];
                    final isSelected = _difficulty == index;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text(
                          label,
                          style: TextStyle(
                            color: isSelected ? Colors.white : textColor.withValues(alpha: 0.6),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: color,
                        backgroundColor: (isNight ? Colors.white : Colors.black).withValues(alpha: 0.05),
                        checkmarkColor: Colors.white,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _difficulty = index;
                              _initPuzzle();
                            });
                          }
                        },
                      ),
                    );
                  }),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: diffColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: diffColor.withOpacity(0.3), width: 1.5),
                  ),
                  child: Text(
                    diffLabel.toUpperCase(),
                    style: TextStyle(
                      color: diffColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              const Spacer(),
              Text(
                'Solve the Puzzle',
                style: TextStyle(
                  color: textColor,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Progress: $correctCount / ${_totalTaps - 1}',
                style: TextStyle(
                  color: textColor.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 32),
              PremiumCard(
                isGlass: isNight,
                padding: const EdgeInsets.all(12),
                child: SizedBox(
                  width: 320,
                  height: 320,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _gridSize,
                      mainAxisSpacing: spacing,
                      crossAxisSpacing: spacing,
                    ),
                    itemCount: _totalTaps,
                    itemBuilder: (context, index) {
                      final tile = _numbers[index];
                      final isCorrect = tile != 0 && tile == index + 1;
                      final isErrorTile = _errorTileIndex == index;

                      Color tileColor = primaryColor;
                      if (isCorrect) {
                        tileColor = HelioColors.success;
                      } else if (isErrorTile) {
                        tileColor = HelioColors.error;
                      } else if (isNight) {
                        tileColor = HelioColors.nightCard;
                      }

                      Widget tileWidget = AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: tile == 0 ? Colors.transparent : tileColor,
                          borderRadius: BorderRadius.circular(12),
                          border: tile == 0 
                              ? null 
                              : Border.all(
                                  color: isCorrect
                                      ? HelioColors.success
                                      : isErrorTile
                                          ? HelioColors.error
                                          : (isNight ? Colors.white.withValues(alpha: 0.1) : primaryColor),
                                  width: 2,
                                ),
                          boxShadow: tile == 0 
                              ? null 
                              : [
                                  BoxShadow(
                                    color: tileColor.withValues(alpha: 0.25),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                        ),
                        child: tile == 0 
                            ? null 
                            : Center(
                                child: Text(
                                  '$tile',
                                  style: TextStyle(
                                    fontSize: fontSize,
                                    fontWeight: FontWeight.w900,
                                    color: isCorrect || isErrorTile || !isNight
                                        ? Colors.white
                                        : textColor,
                                  ),
                                ),
                              ),
                      );

                      if (isErrorTile) {
                        return AnimatedBuilder(
                          animation: _shakeController,
                          builder: (context, child) {
                            final offset = sin(_shakeController.value * 4 * pi) * 8;
                            return Transform.translate(
                              offset: Offset(offset, 0),
                              child: child,
                            );
                          },
                          child: tileWidget,
                        );
                      }

                      return GestureDetector(
                        onTap: () => _onTileTap(index),
                        child: AnimatedScale(
                          scale: isCorrect ? 0.95 : 1.0,
                          duration: const Duration(milliseconds: 150),
                          child: tileWidget,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 48),
              TextButton.icon(
                onPressed: () => setState(() => _initPuzzle()),
                icon: Icon(Icons.refresh_rounded, color: primaryColor),
                label: Text(
                  'RESET BOARD',
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
