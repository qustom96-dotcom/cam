import 'package:flutter/material.dart';
import 'package:camerawesome/camerawesome_plugin.dart';

void main() {
  runApp(const MaterialApp(
    home: KameraScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class KameraScreen extends StatefulWidget {
  const KameraScreen({super.key});

  @override
  State<KameraScreen> createState() => _KameraScreenState();
}

class _KameraScreenState extends State<KameraScreen> {
  double _brzina = 0.02; // Početna brzina 1/50s

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
        // Overlay je najbolji način da kontrolišeš senzor u realnom vremenu
        onOverlay: (state) {
          return Positioned(
            bottom: 100,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "SHUTTER: 1 / ${(1 / _brzina).toStringAsFixed(0)}s",
                    style: const TextStyle(
                      color: Colors.white, 
                      fontSize: 18, 
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Slider(
                    value: _brzina,
                    min: 0.0005, // 1/2000s
                    max: 0.2,    // 1/5s
                    onChanged: (v) {
                      setState(() {
                        _brzina = v;
                      });
                      // Ovdje šaljemo komande senzoru
                      state.sensorConfig.setExposureMode(ExposureMode.manual);
                      state.sensorConfig.setIso(400); // Fiksiramo da ne skače samo
                      state.sensorConfig.setShutterSpeed(
                        Duration(microseconds: (v * 1000000).toInt()),
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