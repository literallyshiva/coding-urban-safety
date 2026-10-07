import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../state/assessment_state.dart';
import '../widgets/research_scaffold.dart';
import 'safety_assessment_page.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key, required this.assessmentState});

  final AssessmentState assessmentState;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  static const _india = CameraPosition(
    target: LatLng(20.5937, 78.9629),
    zoom: 4.5,
  );

  GoogleMapController? _mapController;
  bool _loadingLocation = true;
  String? _locationError;

  @override
  void initState() {
    super.initState();
    _captureCurrentLocation();
  }

  Future<void> _captureCurrentLocation() async {
    setState(() {
      _loadingLocation = true;
      _locationError = null;
    });

    try {
      final enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled) {
        throw StateError('Location services are disabled on this device.');
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw StateError('Location permission is required to assess a place.');
      }

      const settings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 0,
      );
      final position = await Geolocator.getCurrentPosition(
        locationSettings: settings,
      );
      final location = LatLng(position.latitude, position.longitude);
      widget.assessmentState.setLocation(location);

      if (mounted) {
        setState(() => _loadingLocation = false);
        await _mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: location, zoom: 17),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadingLocation = false;
        _locationError = e.toString().replaceFirst('Bad state: ', '');
      });
    }
  }

  Future<void> _assessPlace() async {
    await _captureCurrentLocation();
    if (!mounted || widget.assessmentState.location == null) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SafetyAssessmentPage(
          assessmentState: widget.assessmentState,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final location = widget.assessmentState.location;

    return Scaffold(
      appBar: AppBar(title: const Text('CODING URBAN SAFETY')),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: location == null
                ? _india
                : CameraPosition(target: location, zoom: 17),
            onMapCreated: (controller) {
              _mapController = controller;
              if (location != null) {
                controller.animateCamera(CameraUpdate.newLatLngZoom(location, 17));
              }
            },
            myLocationEnabled: location != null,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: false,
            markers: location == null
                ? const {}
                : {
                    Marker(
                      markerId: const MarkerId('assessment-location'),
                      position: location,
                      infoWindow: const InfoWindow(title: 'Assessment location'),
                    ),
                  },
          ),
          Positioned(
            left: 16,
            right: 16,
            top: 16,
            child: SafeArea(
              bottom: false,
              child: Material(
                color: Colors.white,
                elevation: 2,
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _loadingLocation
                              ? 'Finding your current location…'
                              : _locationError ?? 'Current location captured. Choose this place when you are ready.',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      if (_locationError != null)
                        IconButton(
                          onPressed: _captureCurrentLocation,
                          icon: const Icon(Icons.refresh),
                          tooltip: 'Retry location',
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: SafeArea(
              top: false,
              child: PrimaryActionButton(
                label: 'ASSESS A PLACE',
                loading: _loadingLocation,
                onPressed: location == null && _locationError != null
                    ? null
                    : _assessPlace,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
