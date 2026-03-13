import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../services/storage_service.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  final StorageService _storageService = StorageService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _learnedTodayController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();

  String? _qrCode;
  double? _latitude;
  double? _longitude;
  DateTime? _capturedAt;
  String? _locationError;

  bool _isCapturingLocation = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _learnedTodayController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  Future<void> _scanQrAndCaptureLocation() async {
    final String? result = await Navigator.of(context).push<String>(
      MaterialPageRoute<String>(
        builder: (_) => const _QrScannerPage(
          title: 'Scan QR for Check-out',
        ),
      ),
    );

    if (result == null || !mounted) {
      return;
    }

    setState(() {
      _qrCode = result;
    });

    await _captureLocationAndTimestamp();
  }

  Future<void> _captureLocationAndTimestamp() async {
    if (mounted) {
      setState(() {
        _isCapturingLocation = true;
        _locationError = null;
      });
    }

    try {
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          setState(() {
            _locationError = 'Location services are disabled. Please enable GPS.';
          });
        }
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        if (mounted) {
          setState(() {
            _locationError = 'Location permission denied.';
          });
        }
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          setState(() {
            _locationError =
                'Location permission is permanently denied. Open app settings.';
          });
        }
        return;
      }

      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
        _capturedAt = DateTime.now();
      });
    } catch (error) {
      if (mounted) {
        setState(() {
          _locationError = 'Failed to get location: $error';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCapturingLocation = false;
        });
      }
    }
  }

  Future<void> _submitCheckOut() async {
    final FormState? form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    if (_qrCode == null) {
      _showMessage('Please scan the class QR code before submitting.');
      return;
    }

    if (_latitude == null || _longitude == null) {
      await _captureLocationAndTimestamp();
      if (_latitude == null || _longitude == null) {
        _showMessage('Location is required to submit check-out.');
        return;
      }
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final CheckOutRecord record = CheckOutRecord(
        id: 'checkout_${DateTime.now().millisecondsSinceEpoch}',
        qrCode: _qrCode!,
        latitude: _latitude!,
        longitude: _longitude!,
        timestamp: (_capturedAt ?? DateTime.now()).toIso8601String(),
        learnedToday: _learnedTodayController.text.trim(),
        feedback: _feedbackController.text.trim(),
      );

      await _storageService.saveCheckOut(record);

      if (!mounted) {
        return;
      }

      _showMessage('Check-out submitted successfully.');
      Navigator.of(context).pop(true);
    } catch (error) {
      _showMessage('Failed to save check-out: $error');
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Finish Class (After Class)')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Step 1: Verify Check-out QR',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      _qrCode == null ? 'No QR scanned yet' : 'QR: $_qrCode',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: _scanQrAndCaptureLocation,
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text('Scan QR'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Step 2: Capture GPS and Timestamp',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (_isCapturingLocation)
                const LinearProgressIndicator()
              else if (_locationError != null)
                Text(
                  _locationError!,
                  style: const TextStyle(color: Colors.red),
                )
              else if (_latitude != null && _longitude != null)
                Text(
                  'Lat: ${_latitude?.toStringAsFixed(6)}, '
                  'Lng: ${_longitude?.toStringAsFixed(6)}\n'
                  'Timestamp: ${(_capturedAt ?? DateTime.now()).toLocal()}',
                )
              else
                const Text(
                  'Location will be captured automatically after QR scan.',
                ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: <Widget>[
                  OutlinedButton.icon(
                    onPressed: _captureLocationAndTimestamp,
                    icon: const Icon(Icons.my_location),
                    label: const Text('Capture Again'),
                  ),
                  OutlinedButton.icon(
                    onPressed: Geolocator.openAppSettings,
                    icon: const Icon(Icons.settings),
                    label: const Text('Open App Settings'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Step 3: Reflection Form',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _learnedTodayController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'What did you learn today? (Short text)',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please describe what you learned today.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _feedbackController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Feedback about the class or the instructor',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please provide class or instructor feedback.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              const Text(
                'Step 4: Submit',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitCheckOut,
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Submit Check-out'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QrScannerPage extends StatefulWidget {
  const _QrScannerPage({required this.title});

  final String title;

  @override
  State<_QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<_QrScannerPage> {
  late final MobileScannerController _controller;
  bool _hasReturned = false;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      returnImage: false,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleDetect(BarcodeCapture capture) {
    if (_hasReturned || !mounted) {
      return;
    }

    String? code;
    for (final Barcode barcode in capture.barcodes) {
      final String? value = barcode.rawValue;
      if (value != null && value.isNotEmpty) {
        code = value;
        break;
      }
    }

    if (code == null) {
      return;
    }

    _hasReturned = true;
    Navigator.of(context).pop(code);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Stack(
        children: <Widget>[
          MobileScanner(
            controller: _controller,
            onDetect: _handleDetect,
            errorBuilder: (
              BuildContext context,
              MobileScannerException error,
              Widget? child,
            ) {
              return _ScannerErrorView(
                errorCode: error.errorCode.name,
                onRetry: _controller.start,
                onOpenSettings: Geolocator.openAppSettings,
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(12),
              color: Colors.black54,
              child: const Text(
                'Point the camera at the class QR code',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScannerErrorView extends StatelessWidget {
  const _ScannerErrorView({
    required this.errorCode,
    required this.onRetry,
    required this.onOpenSettings,
  });

  final String errorCode;
  final Future<void> Function() onRetry;
  final Future<bool> Function() onOpenSettings;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.camera_alt_outlined, size: 48),
            const SizedBox(height: 12),
            Text(
              'Camera unavailable ($errorCode).\nCheck camera permission and try again.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: onRetry,
                  child: const Text('Retry Camera'),
                ),
                OutlinedButton(
                  onPressed: onOpenSettings,
                  child: const Text('Open App Settings'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
