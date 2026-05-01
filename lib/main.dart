import 'package:flutter/material.dart';
import 'package:camerawesome/camerawesome_plugin.dart';

void main() {
  runApp(const MaterialApp(
    home: KameraProScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class KameraProScreen extends StatefulWidget {
  const KameraProScreen({super.key});

  @override
  State<KameraProScreen> createState() => _KameraProScreenState();
}

class _KameraProScreenState extends State<KameraProScreen> {
  double _shutterValue = 0.02; // 1/50s

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CameraAwesomeBuilder.awesome(
        saveConfig: SaveConfig.photoAndVideo(),
        sensorConfig: SensorConfig.single(
          sensor: Sensor.position(SensorPosition.back),
          aspectRatio: CameraAspectRatios.ratio_16_9,
        ),
        previewFit: CameraPreviewFit.cover,
        // Overlay koji direktno komanduje senzoru
        onOverlay: (state) {
          // Svaki put kad se ekran osvježi, potvrđujemo manualne postavke
          state.sensorConfig.setExposureMode(ExposureMode.manual);
          state.sensorConfig.setIso(400); 
          state.sensorConfig.setShutterSpeed(
            Duration(microseconds: (_shutterValue * 1000000).toInt()),
          );

          return Positioned(
            bottom: 80,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "BRZINA: 1 / ${(1 / _shutterValue).toStringAsFixed(0)}s",
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Slider(
                    value: _shutterValue,
                    min: 0.0005, // 1/2000s
                    max: 0.1,    // 1/10s
                    activeColor: Colors.orangeAccent,
                    onChanged: (v) {
                      setState(() {
                        _shutterValue = v;
                      });
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}