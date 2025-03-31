import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart'; // Input formatter
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';

class StatusCompletedScreen extends StatefulWidget {
  const StatusCompletedScreen({super.key});

  @override
  State<StatusCompletedScreen> createState() => _StatusCompletedScreenState();
}

class _StatusCompletedScreenState extends State<StatusCompletedScreen> {
  File? _image;
  final picker = ImagePicker();
  final TextEditingController _endOdometerController = TextEditingController();
  String _currentTime = "";
  Timer? _timer;
  String? _latitude;
  String? _longitude;
  bool _isFetchingLocation = false;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _startTimer();
    _requestLocationPermission();
  }

  void _updateTime() {
    setState(() {
      _currentTime = DateFormat.jm().format(DateTime.now());
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _updateTime());
  }

  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return;
    }
    _fetchLocation();
  }

  Future<void> _fetchLocation() async {
    setState(() => _isFetchingLocation = true);
    try {
      final LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );

      setState(() {
        _latitude = "Lat: ${position.latitude.toStringAsFixed(5)}";
        _longitude = "Lon: ${position.longitude.toStringAsFixed(5)}";
      });
    } catch (e) {
      setState(() {
        _latitude = "Error fetching location";
        _longitude = e.toString();
      });
    } finally {
      setState(() => _isFetchingLocation = false);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _endOdometerController.dispose();
    super.dispose();
  }

  Future<void> captureImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Status Completion',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Check-out Time',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                Container(
                  height: 40,
                  width: 180,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(173, 216, 230, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(_currentTime, style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current\nCoordinates',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                Container(
                  width: 200,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(173, 216, 230, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child:
                        _isFetchingLocation
                            ? CircularProgressIndicator()
                            : Column(
                              children: [
                                Text(
                                  _latitude ?? "Permission Required",
                                  style: TextStyle(fontSize: 14),
                                ),
                                Text(
                                  _longitude ?? "",
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Text(
              'End Odometer Reading',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _endOdometerController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                hintText: 'Enter odometer reading...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            SizedBox(height: 30),
            Center(
              child: Column(
                children: [
                  _image != null
                      ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          _image!,
                          width: 200,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      )
                      : Text(
                        'No Image Captured',
                        style: TextStyle(fontSize: 16),
                      ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: captureImage,
                    child: Text(
                      'Capture Image',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {},
              child: Text("Complete", style: TextStyle(fontSize: 18)),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
