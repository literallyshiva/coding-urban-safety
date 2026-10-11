import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../state/assessment_state.dart';
import '../services/place_search.dart';
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
  final TextEditingController _searchController = TextEditingController();
  List<PlaceSuggestion> _suggestions = [];
  bool _searching = false;
  String? _searchError;

  @override
  void dispose() {
    _searchController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _searchPlaces() async {
    final query = _searchController.text.trim();
    if (query.length < 3) {
      setState(() => _searchError = 'Enter at least 3 characters.');
      return;
    }
    setState(() { _searching = true; _searchError = null; _suggestions = []; });
    try {
      final results = await PlaceSearch.search(query);
      if (mounted) setState(() { _suggestions = results;
        if (results.isEmpty) _searchError = 'No matching places found.'; });
    } catch (_) {
      if (mounted) setState(() => _searchError =
          'Place search unavailable. Enable Places API (New) and check your API key restrictions.');
    } finally {
      if (mounted) setState(() => _searching = false);
    }
  }

  Future<void> _selectSuggestion(PlaceSuggestion suggestion) async {
    setState(() { _searching = true; _searchError = null; });
    try {
      final point = await PlaceSearch.resolve(suggestion.id);
      if (!mounted) return;
      final location = LatLng(point.lat, point.lng);
      setState(() { _manualMode = true; _existingMode = false;
        _selected = location; _placeId = null; _suggestions = [];
        _searchController.text = suggestion.description; });
      await _mapController?.animateCamera(CameraUpdate.newLatLngZoom(location, 17));
    } catch (_) {
      if (mounted) setState(() => _searchError = 'Unable to select this place. Try another result.');
    } finally {
      if (mounted) setState(() => _searching = false);
    }
  }


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
        throw StateError('GPS is turned off. Enable device location, or choose New place to select manually.');
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw StateError(permission == LocationPermission.deniedForever
            ? 'Location is blocked. Enable it in browser settings or choose New place.'
            : 'Location permission denied. Choose New place to select manually.');
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
      widget.assessmentState.location = null;
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: Row(children: [
                  Expanded(child: TextField(
                    controller: _searchController,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) => _searchPlaces(),
                    decoration: const InputDecoration(
                      isDense: true, prefixIcon: Icon(Icons.search),
                      hintText: 'Search a landmark or address',
                    ),
                  )),
                  const SizedBox(width: 6),
                  IconButton.filledTonal(
                    tooltip: 'Search places',
                    onPressed: _searching ? null : _searchPlaces,
                    icon: _searching
                        ? const SizedBox(width: 18, height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.arrow_forward),
                  ),
                ]),
              ),
              if (_searchError != null)
                Padding(padding: const EdgeInsets.all(8),
                  child: Text(_searchError!, style: const TextStyle(color: Colors.red))),
              if (_suggestions.isNotEmpty)
                SizedBox(height: 170, child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _suggestions.length,
                  itemBuilder: (context, index) => ListTile(
                    dense: true,
                    leading: const Icon(Icons.place_outlined),
                    title: Text(_suggestions[index].description,
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                    onTap: _searching ? null : () => _selectSuggestion(_suggestions[index]),
                  ),
                )),
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
            top: _existingMode ? 340 : (_suggestions.isNotEmpty ? 330 : 160),
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
                              : (_manualMode ? 'Tap the map or search above to choose a new place.' : _existingMode ? 'Select a contributed place from the list.' : (_locationError ?? 'Choose this place when ready.')),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      if (_locationError != null)
                        TextButton(onPressed: () => setState(() {
                          _manualMode = true; _existingMode = false;
                          _locationError = null; _selected = null;
                        }), child: const Text('Choose on map')),
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
