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
  // Počinjemo sa 1/50 sekunde (0.02s)
  double _currentShutterSpeed = 0.02;

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
        // Ovdje pravimo naš vlastiti interfejs preko kamere
        onOverlay: (state) {
          return Positioned(
            bottom: 100,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "BRZINA: 1 / ${(1 / _currentShutterSpeed).toStringAsFixed(0)}s",
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Slider(
                    value: _currentShutterSpeed,
                    min: 0.0005, // 1/2000s (jako tamno)
                    max: 0.1,    // 1/10s (jako svijetlo)
                    onChanged: (value) {
                      setState(() {
                        _currentShutterSpeed = value;
                      });
                      
                      // DIREKTNO komandujemo senzoru
                      state.sensorConfig.setExposureMode(ExposureMode.manual);
                      // Fiksiramo ISO da nam ne kvari testiranje
                      state.sensorConfig.setIso(400); 
                      // Postavljamo tvoju brzinu
                      state.sensorConfig.setShutterSpeed(
                        Duration(microseconds: (value * 1000000).toInt()),
                      );
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