import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  bool _loadingLocation = false;
  String? _locationError;
  bool _manualMode = false;
  bool _existingMode = false;
  LatLng? _selected;
  String? _placeId;

  @override
  void initState() {
    super.initState();
    // GPS is optional; map selection works without location permission.
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
      if (!_manualMode && !_existingMode) {
        _selected = location;
        _placeId = null;
        widget.assessmentState.selectPlace(location, source: 'gps');
      }

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
    if (!_manualMode && !_existingMode) {
      await _captureCurrentLocation();
    } else if (_selected != null) {
      widget.assessmentState.selectPlace(_selected!, placeId: _placeId, source: _existingMode ? 'existing' : 'manual');
    }
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
    final location = _selected;

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
            myLocationEnabled: !_manualMode && !_existingMode && location != null,
            onTap: (point) {
              if (_manualMode) setState(() { _selected = point; _placeId = null; });
            },
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
            left: 16, right: 16, top: 12,
            child: SafeArea(child: Material(color: Colors.white, borderRadius: BorderRadius.circular(12), child: Column(children: [
              Wrap(spacing: 5, children: [
                ChoiceChip(label: const Text('My GPS'), selected: !_manualMode && !_existingMode, onSelected: (_) { setState(() { _manualMode = false; _existingMode = false; _selected = null; _placeId = null; }); _captureCurrentLocation(); }),
                ChoiceChip(label: const Text('New place'), selected: _manualMode, onSelected: (_) => setState(() { _manualMode = true; _existingMode = false; _selected = null; _placeId = null; })),
                ChoiceChip(label: const Text('Existing places'), selected: _existingMode, onSelected: (_) => setState(() { _manualMode = false; _existingMode = true; _selected = null; _placeId = null; })),
              ]),
              if (_existingMode) SizedBox(height: 180, child: StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
                stream: FirebaseFirestore.instance.collection('places').limit(100).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) return const Text('Unable to load places. Check Firestore rules.');
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                  if (snapshot.data!.docs.isEmpty) return const Center(child: Text('No contributed places yet.'));
                  return ListView.builder(itemCount: snapshot.data!.docs.length, itemBuilder: (context, index) {
                    final doc = snapshot.data!.docs[index];
                    final point = doc.data()['location'];
                    if (point is! GeoPoint) return const SizedBox.shrink();
                    final pos = LatLng(point.latitude, point.longitude);
                    return ListTile(dense: true, selected: _placeId == doc.id, title: Text('Place ${index+1}'), subtitle: Text('${point.latitude.toStringAsFixed(5)}, ${point.longitude.toStringAsFixed(5)}'), onTap: () {
                      setState(() { _selected = pos; _placeId = doc.id; });
                      _mapController?.animateCamera(CameraUpdate.newLatLngZoom(pos, 17));
                    });
                  });
                },
              )),
            ]))),
          ),
          Positioned(
            left: 16,
            right: 16,
            top: _existingMode ? 260 : 85,
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
                          (!_manualMode && !_existingMode && _loadingLocation)
                              ? 'Finding your current location…'
                              : (_manualMode ? 'Tap the map to contribute a new place.' : _existingMode ? 'Select a contributed place from the list.' : (_locationError ?? 'Choose this place when ready.')),
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
                loading: !_manualMode && !_existingMode && _loadingLocation,
                onPressed: (_manualMode || _existingMode) && location == null ? null : _assessPlace,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
