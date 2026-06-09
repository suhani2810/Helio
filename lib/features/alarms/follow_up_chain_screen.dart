import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/design_system/colors.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/theme/theme_mode_enum.dart';
import '../../widgets/theme/sky_background.dart';
import '../../widgets/premium_card.dart';
import '../missions/mission_selection_screen.dart';

class FollowUpAlarmChainScreen extends ConsumerStatefulWidget {
  final bool isEnabled;
  final int interval;
  final String mission;

  const FollowUpAlarmChainScreen({
    super.key,
    this.isEnabled = false,
    this.interval = 5,
    this.mission = 'None',
  });

  @override
  ConsumerState<FollowUpAlarmChainScreen> createState() =>
      _FollowUpAlarmChainScreenState();
}

class _FollowUpAlarmChainScreenState extends ConsumerState<FollowUpAlarmChainScreen> {
  late bool _isEnabled;
  late int _interval;
  late String _mission;

  @override
  void initState() {
    super.initState();
    _isEnabled = widget.isEnabled;
    _interval = widget.interval;
    _mission = widget.mission;
  }

  bool _isNightMode(AppThemeMode mode, int hour) {
    if (mode == AppThemeMode.night) return true;
    if (mode == AppThemeMode.day) return false;
    return hour < 5 || hour >= 19;
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom App Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_rounded, color: textColor),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      'Follow-up Mission',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PremiumCard(
                        isGlass: isNight,
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: primaryColor.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.link,
                                color: primaryColor,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                'Trigger a second mission if you don\'t stay awake after the first one.',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: textColor,
                                ),
                              ),
                            ),
                            Switch(
                              value: _isEnabled,
                              onChanged: (val) => setState(() => _isEnabled = val),
                              activeColor: primaryColor,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      if (_isEnabled) ...[
                        Text(
                          'Follow-up Settings',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 16),
                        PremiumCard(
                          isGlass: isNight,
                          padding: EdgeInsets.zero,
                          child: Column(
                            children: [
                              _buildSettingRow(
                                Icons.timer_outlined,
                                'Delay Interval',
                                '$_interval mins',
                                textColor,
                                primaryColor,
                                onTap: () {
                                  setState(
                                    () => _interval = (_interval + 5 > 20) ? 5 : _interval + 5,
                                  );
                                },
                              ),
                              _buildSettingRow(
                                Icons.assignment_outlined,
                                'Mission Type',
                                _mission,
                                textColor,
                                primaryColor,
                                isLast: true,
                                onTap: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const MissionSelectionScreen(),
                                    ),
                                  );
                                  if (result != null) {
                                    setState(() => _mission = result as String);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, {
                        'isEnabled': _isEnabled,
                        'interval': _interval,
                        'mission': _mission,
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 8,
                      shadowColor: primaryColor.withValues(alpha: 0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Confirm Settings',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingRow(
    IconData icon,
    String title,
    String value,
    Color textColor,
    Color primaryColor, {
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Icon(icon, color: textColor.withValues(alpha: 0.5), size: 24),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  value,
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.chevron_right_rounded, color: textColor.withValues(alpha: 0.2)),
              ],
            ),
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            indent: 60,
            endIndent: 20,
            color: textColor.withValues(alpha: 0.05),
          ),
      ],
    );
  }
}
