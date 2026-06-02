import 'package:flutter/material.dart';
import '../../core/design_system/colors.dart';

class FollowUpAlarmChainScreen extends StatefulWidget {
  const FollowUpAlarmChainScreen({super.key});

  @override
  State<FollowUpAlarmChainScreen> createState() =>
      _FollowUpAlarmChainScreenState();
}

class _FollowUpAlarmChainScreenState extends State<FollowUpAlarmChainScreen> {
  bool _isEnabled = false;
  int _alarmCount = 3;
  int _interval = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alarm Chain'),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: HelioColors.sunriseOrange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: HelioColors.sunriseOrange.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.link,
                    color: HelioColors.sunriseOrange,
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Trigger consecutive alarms if the initial mission is not completed.',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  Switch(
                    value: _isEnabled,
                    onChanged: (val) => setState(() => _isEnabled = val),
                    activeThumbColor: HelioColors.sunriseOrange,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            if (_isEnabled) ...[
              Text(
                'Chain Settings',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              _buildSettingRow('Number of Alarms', '$_alarmCount', () {
                setState(() => _alarmCount = (_alarmCount % 5) + 1);
              }),
              const Divider(color: Colors.white10),
              _buildSettingRow('Interval', '$_interval mins', () {
                setState(
                  () => _interval = (_interval + 5 > 20) ? 5 : _interval + 5,
                );
              }),
              const Spacer(),
            ] else
              const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: HelioColors.sunriseOrange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Save Chain Settings',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingRow(String title, String value, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 16)),
            Row(
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: HelioColors.sunriseOrange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: HelioColors.textSecondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
