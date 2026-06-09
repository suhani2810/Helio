import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alarm/alarm.dart';
import 'core/design_system/colors.dart';
import 'core/theme/theme_provider.dart';
import 'core/theme/theme_mode_enum.dart';
import 'features/home/home_screen.dart';
import 'features/alarms/alarm_list_screen.dart';
import 'features/insights/insights_dashboard.dart';
import 'features/settings/profile_screen.dart';
import 'features/alarms/alarm_ringing_screen.dart';
import 'providers/repository_providers.dart';

class NavigationWrapper extends ConsumerStatefulWidget {
  const NavigationWrapper({super.key});

  @override
  ConsumerState<NavigationWrapper> createState() => _NavigationWrapperState();
}

class _NavigationWrapperState extends ConsumerState<NavigationWrapper>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late final List<AnimationController> _iconControllers;
  StreamSubscription<AlarmSettings>? _subscription;

  final List<Widget> _screens = const [
    HomeScreen(),
    AlarmListScreen(),
    InsightsDashboard(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _iconControllers = List.generate(
      4,
      (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      ),
    );
    _iconControllers[0].forward();

    // Task 2: Listen for alarm ringing
    _subscription = Alarm.ringStream.stream.listen((settings) {
      _navigateToRinging(settings);
    });
  }

  void _navigateToRinging(AlarmSettings settings) async {
    final alarmRepo = ref.read(alarmRepositoryProvider);
    final alarm = await alarmRepo.getAlarm(settings.id);
    
    if (mounted) {
       Navigator.push(
         context,
         MaterialPageRoute(
           builder: (_) => AlarmRingingScreen(alarm: alarm),
         ),
       );
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    for (final controller in _iconControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onTap(int index) {
    if (index == _currentIndex) return;
    HapticFeedback.lightImpact();
    _iconControllers[_currentIndex].reverse();
    _iconControllers[index].forward();
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeControllerProvider);
    final isNight = _isNightMode(themeMode, DateTime.now().hour);

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: _PremiumNavBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
        controllers: _iconControllers,
        isNight: isNight,
      ),
    );
  }

  bool _isNightMode(AppThemeMode mode, int hour) {
    if (mode == AppThemeMode.night) return true;
    if (mode == AppThemeMode.day) return false;
    return hour < 5 || hour >= 19;
  }
}

class _PremiumNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<AnimationController> controllers;
  final bool isNight;

  const _PremiumNavBar({
    required this.currentIndex,
    required this.onTap,
    required this.controllers,
    required this.isNight,
  });

  static const _items = [
    _NavItem(icon: Icons.wb_sunny_outlined, activeIcon: Icons.wb_sunny_rounded, label: 'Home'),
    _NavItem(icon: Icons.alarm_outlined, activeIcon: Icons.alarm_rounded, label: 'Alarms'),
    _NavItem(icon: Icons.auto_graph_outlined, activeIcon: Icons.auto_graph_rounded, label: 'Insights'),
    _NavItem(icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      height: 76,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(38),
        boxShadow: [
          BoxShadow(
            color: isNight 
                ? const Color(0xFF7C9DFF).withOpacity(0.1) 
                : Colors.black.withOpacity(0.08),
            blurRadius: 30,
            spreadRadius: -5,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(38),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: isNight 
                  ? const Color(0xFF071330).withOpacity(0.5) 
                  : Colors.white.withOpacity(0.85),
              borderRadius: BorderRadius.circular(38),
              border: Border.all(
                color: isNight 
                    ? Colors.white.withOpacity(0.08) 
                    : Colors.white.withOpacity(0.5),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_items.length, (index) {
                final isSelected = index == currentIndex;
                return _NavTile(
                  item: _items[index],
                  isSelected: isSelected,
                  controller: controllers[index],
                  onTap: () => onTap(index),
                  isNight: isNight,
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  final _NavItem item;
  final bool isSelected;
  final AnimationController controller;
  final VoidCallback onTap;
  final bool isNight;

  const _NavTile({
    required this.item,
    required this.isSelected,
    required this.controller,
    required this.onTap,
    required this.isNight,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = isNight ? HelioColors.nightPrimary : HelioColors.dayPrimary;
    final inactiveColor = isNight ? Colors.white54 : HelioColors.dayText.withOpacity(0.4);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected ? activeColor.withOpacity(0.1) : Colors.transparent,
              shape: BoxShape.circle,
              boxShadow: [
                if (isSelected && isNight)
                  BoxShadow(
                    color: activeColor.withOpacity(0.3),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
              ],
            ),
            child: Icon(
              isSelected ? item.activeIcon : item.icon,
              color: isSelected ? activeColor : inactiveColor,
              size: 26,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            item.label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? activeColor : inactiveColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
