import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:flutter/material.dart';

class ScannerView extends StatefulWidget {
  const ScannerView({super.key});

  @override
  State<ScannerView> createState() => _ScannerViewState();
}

class _ScannerViewState extends State<ScannerView> {
  @override
  Widget build(BuildContext context) {
    return AiBarcodeScanner(
      onDispose: () {
        /// This is called when the barcode scanner is disposed.
        /// You can write your own logic here.
        debugPrint("Barcode scanner disposed!");
      },
      hideGalleryButton: false,
      controller: MobileScannerController(
        detectionSpeed: DetectionSpeed.noDuplicates,
      ),
      onDetect: (BarcodeCapture capture) {
        /// The row string scanned barcode value
        final String? scannedValue =
            capture.barcodes.first.rawValue;
        debugPrint("Barcode scanned: $scannedValue");
        Navigator.pop(context, scannedValue);
      },
      validator: (value) {
        if (value.barcodes.isEmpty) {
          return false;
        }
        if (!(value.barcodes.first.rawValue
                ?.contains('flutter.dev') ??
            false)) {
          return false;
        }
        return true;
      },
    );
  }
  
}