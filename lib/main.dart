import 'package:flutter/material.dart';
import 'package:camerawesome/camerawesome_plugin.dart';

void main() => runApp(const MaterialApp(home: KameraScreen(), debugShowCheckedModeBanner: false));

class KameraScreen extends StatefulWidget {
  const KameraScreen({super.key});
  @override
  State<KameraScreen> createState() => _KameraScreenState();
}

class _KameraScreenState extends State<KameraScreen> {
  double _brzina = 0.02;
  SensorConfig? _sensor; // Ovdje ćemo čuvati kontrolu

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          CameraAwesomeBuilder.awesome(
            saveConfig: SaveConfig.photoAndVideo(),
            onCondition: (state) {
              _sensor = state.sensorConfig; // Snimimo senzor da ga imamo kasnije
              return null;
            },
            sensorConfig: SensorConfig.single(
              sensor: Sensor.position(SensorPosition.back),
            ),
          ),
          Positioned(
            bottom: 50, left: 20, right: 20,
            child: Container(
              padding: const EdgeInsets.all(10),
              color: Colors.black54,
              child: Column(
                children: [
                  Text("BRZINA: 1/${(1/_brzina).toStringAsFixed(0)}s", style: const TextStyle(color: Colors.white)),
                  Slider(
                    value: _brzina,
                    min: 0.001, max: 0.1,
                    onChanged: (v) {
                      setState(() => _brzina = v);
                      // Ako smo "uhvatili" senzor, promijeni mu brzinu
                      if (_sensor != null) {
                        _sensor!.setExposureMode(ExposureMode.manual);
                        _sensor!.setShutterSpeed(Duration(microseconds: (v * 1000000).toInt()));
                      }
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