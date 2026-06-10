import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import '../../core/design_system/colors.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/theme/theme_mode_enum.dart';
import '../../widgets/theme/sky_background.dart';
import '../../widgets/premium_card.dart';
import '../mood/mood_tracking_screen.dart';
import '../../core/services/mission_service.dart';
import '../../models/alarm_entity.dart';

class ObjectDetectionMissionScreen extends ConsumerStatefulWidget {
  final bool isPreview;
  final DateTime? scheduledTime;
  final AlarmEntity? alarm;

  const ObjectDetectionMissionScreen({
    super.key,
    this.isPreview = false,
    this.scheduledTime,
    this.alarm,
  });

  @override
  ConsumerState<ObjectDetectionMissionScreen> createState() => _ObjectDetectionMissionScreenState();
}

class _ObjectDetectionMissionScreenState extends ConsumerState<ObjectDetectionMissionScreen> {
  CameraController? _cameraController;
  late ImageLabeler _imageLabeler;
  bool _isCameraInitialized = false;
  bool _isProcessing = false;
  XFile? _capturedImage;
  String? _detectedLabel;
  double? _confidence;
  String? _errorMessage;

  // Supported object mapping to ML Kit labels
  final Map<String, List<String>> _objectMappings = {
    'Toothbrush': ['toothbrush', 'brush', 'toiletries'],
    'Cup': ['cup', 'mug', 'coffee cup', 'drinkware', 'tableware', 'cupware'],
    'Mug': ['cup', 'mug', 'coffee cup', 'drinkware', 'tableware', 'cupware'],
    'Book': ['book', 'publication', 'novel', 'textbook', 'paperback'],
    'Laptop': ['laptop', 'computer', 'notebook computer', 'personal computer', 'netbook', 'display'],
    'Keyboard': ['keyboard', 'computer keyboard', 'input device'],
    'Phone': ['phone', 'mobile phone', 'cell phone', 'telephone', 'gadget', 'handset'],
    'Chair': ['chair', 'furniture', 'seat'],
    'Backpack': ['backpack', 'bag', 'luggage', 'rucksack'],
    'Key': ['key', 'keys', 'metal'],
  };

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _imageLabeler = ImageLabeler(options: ImageLabelerOptions(confidenceThreshold: 0.3));
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() => _errorMessage = 'No cameras found');
        return;
      }

      final backCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        backCamera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888,
      );

      await _cameraController!.initialize();
      if (mounted) {
        setState(() => _isCameraInitialized = true);
      }
    } catch (e) {
      setState(() => _errorMessage = 'Failed to initialize camera: $e');
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _imageLabeler.close();
    super.dispose();
  }

  Future<void> _captureAndDetect() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized || _isProcessing) return;

    setState(() {
      _isProcessing = true;
      _errorMessage = null;
      _detectedLabel = null;
      _confidence = null;
    });

    try {
      final image = await _cameraController!.takePicture();
      if (!mounted) return;
      setState(() => _capturedImage = image);

      final inputImage = InputImage.fromFilePath(image.path);
      final labels = await _imageLabeler.processImage(inputImage);

      final targetObject = (widget.alarm?.targetObject ?? 'Toothbrush').trim();
      final acceptableLabels = (_objectMappings[targetObject] ?? [targetObject.toLowerCase()])
          .map((e) => e.toLowerCase().trim())
          .toList();

      ImageLabel? bestMatch;
      for (var label in labels) {
        final labelText = label.label.toLowerCase().trim();
        if (acceptableLabels.any((acc) => 
            labelText == acc || 
            labelText.contains(acc) || 
            acc.contains(labelText))) {
          if (bestMatch == null || label.confidence > bestMatch.confidence) {
            bestMatch = label;
          }
        }
      }

      if (bestMatch != null && bestMatch.confidence >= 0.50) {
        setState(() {
          _detectedLabel = bestMatch!.label;
          _confidence = bestMatch.confidence;
          _errorMessage = null;
          _isProcessing = false;
        });
        _completeMission();
      } else {
        // Find the most confident label regardless of match to show what was detected
        ImageLabel? topLabel = labels.isNotEmpty ? labels.first : null;
        setState(() {
          _detectedLabel = topLabel?.label ?? 'Nothing found';
          _confidence = topLabel?.confidence ?? 0.0;
          _errorMessage = 'Target "$targetObject" not identified with sufficient confidence (min 50%). Try again.';
          _isProcessing = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isProcessing = false;
      });
    }
  }

  void _retake() {
    setState(() {
      _capturedImage = null;
      _detectedLabel = null;
      _confidence = null;
      _errorMessage = null;
    });
  }

  void _completeMission() async {
    if (!widget.isPreview) {
      await ref.read(missionServiceProvider).completeMission(
        missionType: 'Object Detection',
        scheduledTime: widget.scheduledTime ?? DateTime.now(),
        alarm: widget.alarm,
      );
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(widget.isPreview 
          ? 'Preview Complete!' 
          : 'Object "${widget.alarm?.targetObject ?? 'Toothbrush'}" Verified!'),
        backgroundColor: Colors.green,
      ),
    );
    
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      if (widget.isPreview) {
        Navigator.of(context).pop();
      } else {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MoodTrackingScreen()),
          (route) => route.isFirst,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeControllerProvider);
    final isNight = _isNightMode(themeMode, DateTime.now().hour);
    final textColor = isNight ? Colors.white : HelioColors.dayText;
    final primaryColor = isNight ? HelioColors.nightPrimary : HelioColors.dayPrimary;
    final targetObject = widget.alarm?.targetObject ?? 'Toothbrush';

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera Preview or Captured Image
          Positioned.fill(
            child: _buildImageSurface(),
          ),

          // Overlay UI
          SafeArea(
            child: Column(
              children: [
                _buildHeader(textColor),
                const Spacer(),
                _buildDetectionStatus(isNight, textColor, primaryColor, targetObject),
                _buildControls(primaryColor),
              ],
            ),
          ),

          if (_isProcessing)
            Container(
              color: Colors.black45,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImageSurface() {
    if (_capturedImage != null) {
      return Image.file(
        File(_capturedImage!.path),
        fit: BoxFit.cover,
      );
    }

    if (!_isCameraInitialized || _cameraController == null) {
      return const Center(child: CircularProgressIndicator(color: Colors.white));
    }

    return CameraPreview(_cameraController!);
  }

  Widget _buildHeader(Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const Text(
            'Object Verification',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetectionStatus(bool isNight, Color textColor, Color primaryColor, String target) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: PremiumCard(
        isGlass: true,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.search_rounded, color: Colors.white70, size: 20),
                const SizedBox(width: 8),
                Text(
                  'FIND: $target',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
            if (_detectedLabel != null) ...[
              const SizedBox(height: 16),
              const Divider(color: Colors.white24),
              const SizedBox(height: 16),
              Text(
                'Detected: $_detectedLabel',
                style: TextStyle(
                  color: _errorMessage == null ? Colors.greenAccent : Colors.orangeAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Confidence: ${(_confidence! * 100).toInt()}%',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildControls(Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(48, 0, 48, 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_capturedImage == null)
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _captureAndDetect,
                icon: const Icon(Icons.camera_rounded),
                label: const Text('VERIFY OBJECT'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  elevation: 8,
                ),
              ),
            )
          else
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _retake,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('TRY AGAIN'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white, width: 2),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
              ),
            ),
        ],
      ),
    );
  }

  bool _isNightMode(AppThemeMode mode, int hour) {
    if (mode == AppThemeMode.night) return true;
    if (mode == AppThemeMode.day) return false;
    return hour < 5 || hour >= 19;
  }
}
