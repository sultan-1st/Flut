import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:collection/collection.dart'; // For firstWhereOrNull
import 'package:login_signup/models/favorite.dart';
import 'package:login_signup/models/metro_models.dart';
import 'package:provider/provider.dart';

import '../../providers/add_favorite.dart';

// Global variables for metro data
List<MetroLine> metroLines = [];
List<MetroStop> metroStops = [];

// Function to parse metro data from JSON
Future<void> parseMetroData() async {
  final String jsonString = await rootBundle.loadString('assets/Ryadhmetro.json');
  final Map<String, dynamic> jsonData = jsonDecode(jsonString);

  // Extract metro data
  final Map<String, dynamic> metroData = jsonData['metro'];

  // Parse metro lines
  metroLines = (metroData['line'] as List).map((lineJson) => MetroLine.fromJson(lineJson)).toList();

  // Parse metro stops
  metroStops = (metroData['stops'] as List).map((stopJson) => MetroStop.fromJson(stopJson)).toList();

  print('Loaded ${metroLines.length} metro lines and ${metroStops.length} stops.');
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late Future<void> metroDataFuture;

  @override
  void initState() {
    super.initState();
    metroDataFuture = parseMetroData(); // Load metro data
    final favoriteProvider = Provider.of<FavoriteProvider>(context, listen: false);
    favoriteProvider.fetchFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    return Scaffold(
      body: FutureBuilder<void>(
        future: metroDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return content(favoriteProvider); // Show the map after data is loaded
          }
        },
      ),
    );
  }

  Widget content(FavoriteProvider favoriteProvider) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(24.7136, 46.6753), // Riyadh coordinates
        initialZoom: 11,
        interactionOptions: const InteractionOptions(flags: InteractiveFlag.doubleTapZoom),
      ),
      children: [
        openStreetMapTileLayer,
        PolylineLayer(
          polylines: metroLines.where((line) => line.coords != null).map((line) {
            return Polyline(
              points: line.coords!.map((coord) => LatLng(coord[0], coord[1])).toList(),
              color: line.routeColor != null ? Color(int.parse('FF${line.routeColor!.substring(1)}', radix: 16)) : Colors.grey, // Default to grey if routeColor is null
              strokeWidth: 4.0,
            );
          }).toList(),
        ),
        MarkerLayer(
          markers: metroStops.map((stop) {
            // Find the matching MetroLine for the current stop based on lineId
            final MetroLine? matchingLine = metroLines.firstWhereOrNull((line) => line.lineId == stop.lineId);

            // Use the routeColor from the matching line, or default to grey if not found
            final Color markerColor = matchingLine?.routeColor != null ? Color(int.parse(matchingLine!.routeColor!.replaceFirst('#', 'FF'), radix: 16)) : Colors.grey;

            return Marker(
              point: LatLng(stop.latitude, stop.longitude),
              width: 25, // Size of the marker
              height: 25,
              child: GestureDetector(
                onTap: () async {
                  var favorite = Favorite(lat: stop.latitude.toString(), long: stop.longitude.toString());
                  if (favoriteProvider.favorites.contains(favorite)) {
                    await showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => AlertDialog(
                        title: Text('Remove From Favorites'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
                          TextButton(
                            onPressed: () {
                              favoriteProvider.removeFromFavorites(favorite);
                              Navigator.pop(context);
                            },
                            child: Text('Remove'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    await showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => AlertDialog(
                        title: Text('Add To Favorites'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
                          TextButton(
                            onPressed: () {
                              favoriteProvider.saveToFavorites(Favorite(lat: stop.latitude.toString(), long: stop.longitude.toString()));
                              Navigator.pop(context);
                            },
                            child: Text('Add to Favorites'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: Container(
                  width: 15, // Diameter of the inner circle
                  height: 15,
                  decoration: BoxDecoration(
                    color: markerColor, // Inner circle color matches the metro line
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white, // Outer border color
                      width: 2, // Border thickness
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

TileLayer get openStreetMapTileLayer => TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'dev.fleaflet.flutter_map.example',
    );
