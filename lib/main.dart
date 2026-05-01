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
      home: const KameraScreen(),
    );
  }
}

class KameraScreen extends StatefulWidget {
  const KameraScreen({super.key});

  @override
  State<KameraScreen> createState() => _KameraScreenState();
}

class _KameraScreenState extends State<KameraScreen> {
  // Početna vrijednost shutter speeda (1/20 sekunde)
  double _currentShutterSpeed = 0.05;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          CameraAwesomeBuilder.awesome(
            saveConfig: SaveConfig.photoAndVideo(),
            sensorConfig: SensorConfig.single(
              sensor: Sensor.position(SensorPosition.back),
              aspectRatio: CameraAspectRatios.ratio_16_9,
            ),
            // Ova funkcija se poziva svaki put kad se UI osvježi
            onCondition: (state) {
              // ZAKLJUČAVAMO ekspoziciju da bi ručni shutter speed radio
              state.sensorConfig.setExposureMode(ExposureMode.locked);
              // PRETVARAMO sekunde u mikrosekunde za plugin
              state.sensorConfig.setShutterSpeed(
                Duration(microseconds: (_currentShutterSpeed * 1000000).toInt()),
              );
              return null;
            },
            previewFit: CameraPreviewFit.cover,
            onMediaTap: (mediaCapture) {
              mediaCapture.captureRequest.when(
                single: (single) {
                  print("Snimljeno: ${single.file?.path}");
                },
              );
            },
          ),

          // UI Kontrola za Shutter Speed
          Positioned(
            bottom: 120,
            left: 30,
            right: 30,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Shutter: 1 / ${(1 / _currentShutterSpeed).toStringAsFixed(0)}s",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Slider(
                    value: _currentShutterSpeed,
                    min: 0.001, // 1/1000 sec (veoma brzo - tamno)
                    max: 0.5,   // 1/2 sec (sporo - svijetlo)
                    divisions: 100,
                    activeColor: Colors.yellow,
                    onChanged: (value) {
                      setState(() {
                        _currentShutterSpeed = value;
                      });
                    },
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