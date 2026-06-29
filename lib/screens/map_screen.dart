import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/map_point.dart';
import '../services/database_service.dart';
import 'list_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final DatabaseService _db = DatabaseService();
  final MapController _mapController = MapController();
  List<MapPoint> _points = [];

  @override
  void initState() {
    super.initState();
    _loadPoints();
  }

  Future<void> _loadPoints() async {
    final pts = await _db.getAllPoints();
    setState(() => _points = pts);
  }

  void _onMapTap(TapPosition tapPos, LatLng latlng) {
    _showAddPointDialog(latlng);
  }

  Future<void> _showAddPointDialog(LatLng latlng) async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nouveau point'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Nom du point...',
            border: OutlineInputBorder(),
          ),
          textCapitalization: TextCapitalization.sentences,
          onSubmitted: (v) => Navigator.of(ctx).pop(v.trim()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(controller.text.trim()),
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );

    if (name != null && name.isNotEmpty) {
      final point = MapPoint(
        name: name,
        latitude: latlng.latitude,
        longitude: latlng.longitude,
      );
      await _db.insertPoint(point);
      await _loadPoints();
    }
  }

  Future<void> _deletePoint(MapPoint point) async {
    await _db.deletePoint(point.id!);
    await _loadPoints();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${point.name} supprimé')),
      );
    }
  }

  List<Marker> get _markers => _points
      .map(
        (p) => Marker(
          point: LatLng(p.latitude, p.longitude),
          width: 44,
          height: 56,
          child: GestureDetector(
            onTap: () => _showMarkerOptions(p),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    p.name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                const Icon(Icons.location_on, color: Colors.teal, size: 28),
              ],
            ),
          ),
        ),
      )
      .toList();

  void _showMarkerOptions(MapPoint point) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.location_on, color: Colors.teal),
              title: Text(point.name,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(
                '${point.latitude.toStringAsFixed(5)}, ${point.longitude.toStringAsFixed(5)}',
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('Supprimer ce point'),
              onTap: () {
                Navigator.of(ctx).pop();
                _deletePoint(point);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carte des points'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            tooltip: 'Liste des points',
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ListScreen()),
              );
              _loadPoints();
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Center(
              child: Text(
                '${_points.length} pt${_points.length != 1 ? "s" : ""}',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ),
        ],
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: const LatLng(48.8566, 2.3522),
          initialZoom: 12,
          onTap: _onMapTap,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.ethan.map_points_app',
          ),
          MarkerLayer(markers: _markers),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Appuie sur la carte pour placer un point')),
        ),
        icon: const Icon(Icons.add_location_alt),
        label: const Text('Appuyer sur la carte'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
    );
  }
}
