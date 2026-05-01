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
      home: const KameraPage(),
    );
  }
}

class KameraPage extends StatefulWidget {
  const KameraPage({super.key});

  @override
  State<KameraPage> createState() => _KameraPageState();
}

class _KameraPageState extends State<KameraPage> {
  double _iso = 100;
  double _shutter = 60;
  double _wb = 5500;
  double _tint = 0;
  String _rezolucija = '1920x1080';
  int _fps = 30;
  bool _showControls = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Kamera
          CameraAwesomeBuilder.custom(
            saveConfig: SaveConfig.photoAndVideo(),
            sensorConfig: SensorConfig.single(
              sensor: Sensor.position(SensorPosition.back),
              aspectRatio: CameraAspectRatios.ratio_16_9,
            ),
            builder: (state, preview) {
              return Stack(
                children: [
                  // Preview
                  preview,

                  // Gornji bar
                  Positioned(
                    top: 50,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _infoChip('ISO $_iso'),
                        _infoChip('1/${_shutter.toInt()}s'),
                        _infoChip('${_wb.toInt()}K'),
                        _infoChip('${_fps}fps'),
                        GestureDetector(
                          onTap: () => setState(() => _showControls = !_showControls),
                          child: _infoChip(_showControls ? '✕' : '⚙', active: true),
                        ),
                      ],
                    ),
                  ),

                  // Pro kontrole panel
                  if (_showControls)
                    Positioned(
                      bottom: 150,
                      left: 0,
                      right: 0,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.75),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            _slider('ISO', _iso, 50, 3200, (v) => setState(() => _iso = v.roundToDouble())),
                            _slider('Shutter 1/x', _shutter, 8, 4000, (v) => setState(() => _shutter = v.roundToDouble())),
                            _slider('White Balance', _wb, 2000, 10000, (v) => setState(() => _wb = v.roundToDouble())),
                            _slider('Tint', _tint, -150, 150, (v) => setState(() => _tint = v.roundToDouble())),
                            const SizedBox(height: 8),
                            // FPS
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('FPS: ', style: TextStyle(color: Colors.white)),
                                ...[24, 30, 60].map((f) => GestureDetector(
                                  onTap: () => setState(() => _fps = f),
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 6),
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: _fps == f ? Colors.amber : Colors.white24,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text('$f', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                  ),
                                )),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Rezolucija
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('RES: ', style: TextStyle(color: Colors.white)),
                                ...['1920x1080', '3840x2160', '1280x720'].map((r) => GestureDetector(
                                  onTap: () => setState(() => _rezolucija = r),
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 4),
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: _rezolucija == r ? Colors.amber : Colors.white24,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(r == '3840x2160' ? '4K' : r == '1920x1080' ? '1080p' : '720p',
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                  ),
                                )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Dugmad dole
                  Positioned(
                    bottom: 30,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Switch kamera
                        GestureDetector(
                          onTap: () => state.switchCameraSensor(),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.flip_camera_ios, color: Colors.white, size: 28),
                          ),
                        ),
                        // Shutter dugme
                        GestureDetector(
                          onTap: () => state.when(
                            onPhotoMode: (s) => s.takePhoto(),
                          ),
                          child: Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                              color: Colors.white,
                            ),
                          ),
                        ),
                        // Prazno mjesto (simetrija)
                        const SizedBox(width: 52),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _infoChip(String label, {bool active = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: active ? Colors.amber.withOpacity(0.8) : Colors.black54,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label, style: TextStyle(color: active ? Colors.black : Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  Widget _slider(String label, double value, double min, double max, ValueChanged<double> onChanged) {
    return Row(
      children: [
        SizedBox(width: 90, child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12))),
        Expanded(
          child: Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            activeColor: Colors.amber,
            inactiveColor: Colors.white24,
            onChanged: onChanged,
          ),
        ),
        SizedBox(width: 50, child: Text(value.toInt().toString(), style: const TextStyle(color: Colors.white, fontSize: 12), textAlign: TextAlign.right)),
      ],
    );
  }
}