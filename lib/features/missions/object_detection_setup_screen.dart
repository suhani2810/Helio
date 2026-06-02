import 'package:flutter/material.dart';
import '../../core/design_system/colors.dart';

class ObjectDetectionSetupScreen extends StatelessWidget {
  const ObjectDetectionSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final objects = [
      {'name': 'Toothbrush', 'icon': Icons.cleaning_services},
      {'name': 'Mug', 'icon': Icons.coffee},
      {'name': 'Spoon', 'icon': Icons.restaurant},
      {'name': 'Water Bottle', 'icon': Icons.water_drop},
      {'name': 'Pillow', 'icon': Icons.bed},
      {'name': 'Book', 'icon': Icons.book},
      {'name': 'Toothpaste', 'icon': Icons.brush},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Object Setup'),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: HelioColors.textSecondary),
                hintText: 'Search objects...',
                filled: true,
                fillColor: HelioColors.cardDark,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: HelioColors.sunriseOrange, width: 1),
              ),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.remove_red_eye_outlined, size: 60, color: Colors.white24),
                    SizedBox(height: 16),
                    Text('Live Preview Placeholder', style: TextStyle(color: Colors.white24)),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: HelioColors.surfaceDark,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Select Target Object', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1,
                      ),
                      itemCount: objects.length,
                      itemBuilder: (context, index) {
                        return _buildObjectCard(context, objects[index]);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: HelioColors.sunriseOrange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text('Continue to Setup', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildObjectCard(BuildContext context, Map<String, dynamic> object) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: HelioColors.cardDark,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(object['icon'] as IconData, color: HelioColors.morningYellow, size: 32),
          const SizedBox(height: 8),
          Text(
            object['name'] as String,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
