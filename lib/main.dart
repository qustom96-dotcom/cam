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
      debugShowCheckedModeBanner: false,
      home: CameraAwesomePage(),
    );
  }
}

class CameraAwesomePage extends StatelessWidget {
  const CameraAwesomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CameraAwesomeBuilder.awesome(
        saveConfig: SaveConfig.photoAndVideo(),
        sensorConfig: SensorConfig.single(
          sensor: Sensor.position(SensorPosition.back),
          aspectRatio: CameraAspectRatios.ratio_16_9,
          zoom: 0.0,
        ),
        previewFit: CameraPreviewFit.cover,
        onMediaTap: (mediaCapture) {
          mediaCapture.captureRequest.when(
            single: (single) {
              print("Snimljeno: ${single.file?.path}");
            },
          );
        },
      ),
    );
  }
}