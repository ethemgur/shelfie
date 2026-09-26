import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../core/isbn.dart';
import '../../l10n/gen/app_localizations.dart';

/// Scans an ISBN-13 / EAN-13 barcode and pops with the ISBN. Typing the ISBN
/// is always available (no camera, permission denied, or desktop web).
class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final _controller = MobileScannerController(
    formats: const [BarcodeFormat.ean13],
    detectionSpeed: DetectionSpeed.noDuplicates,
  );
  final _manual = TextEditingController();
  bool _done = false;
  String? _manualError;

  @override
  void dispose() {
    _controller.dispose();
    _manual.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_done) return;
    for (final barcode in capture.barcodes) {
      final isbn = Isbn.normalize13(barcode.rawValue ?? '');
      if (isbn != null) {
        _done = true;
        context.pop(isbn);
        return;
      }
    }
  }

  void _submitManual() {
    final isbn = Isbn.normalize13(_manual.text);
    if (isbn == null) {
      setState(
        () => _manualError = AppLocalizations.of(context).scanInvalidIsbn,
      );
      return;
    }
    context.pop(isbn);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.scanTitle)),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              controller: _controller,
              onDetect: _onDetect,
              errorBuilder: (context, error) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    l10n.scanCameraUnavailable,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _manual,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (_) => _submitManual(),
                      decoration: InputDecoration(
                        labelText: l10n.scanTypeIsbn,
                        errorText: _manualError,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: FilledButton(
                      onPressed: _submitManual,
                      child: Text(l10n.scanLookUp),
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
}
