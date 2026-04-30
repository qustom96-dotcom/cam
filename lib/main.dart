import 'package:flutter/material.dart';
import 'package:camerawesome/camerawesome_plugin.dart';

void main() {
  runApp(const KameraProApp());
}

class KameraProApp extends StatelessWidget {
  const KameraProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: CameraAwesomeBuilder.awesome(
          // Postavke za video i sliku
          saveConfig: SaveConfig.photoAndVideo(),
          
          // Kontrole koje si tražio (ISO, Shutter, Focus...)
          onMediaTap: (media) {
            print("Snimljeno: ${media.filePath}");
          },
          
          // Senzor i rezolucija
          sensorConfig: SensorConfig.single(
            sensor: Sensor.position(SensorPosition.back),
            aspectRatio: CameraAspectRatios.ratio_16_9,
          ),
          
          // Ovo automatski dodaje UI sa svim kontrolama
          previewFit: CameraPreviewFit.cover,
        ),
      ),
    );
  }
}