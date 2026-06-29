import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/map_point.dart';
import '../services/database_service.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final DatabaseService _db = DatabaseService();
  List<MapPoint> _points = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPoints();
  }

  Future<void> _loadPoints() async {
    setState(() => _loading = true);
    final pts = await _db.getAllPoints();
    setState(() {
      _points = pts;
      _loading = false;
    });
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

  Future<void> _editPoint(MapPoint point) async {
    final controller = TextEditingController(text: point.name);
    final newName = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Renommer le point'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          onSubmitted: (v) => Navigator.of(ctx).pop(v.trim()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(controller.text.trim()),
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );

    if (newName != null && newName.isNotEmpty && newName != point.name) {
      await _db.updatePoint(point.copyWith(name: newName));
      await _loadPoints();
    }
  }

  void _showMiniMap(MapPoint point) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SizedBox(
          height: 280,
          child: Stack(
            children: [
              FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(point.latitude, point.longitude),
                  initialZoom: 14,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.none,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.ethan.map_points_app',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(point.latitude, point.longitude),
                        child: const Icon(Icons.location_on,
                            color: Colors.teal, size: 36),
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton.filled(
                  onPressed: () => Navigator.of(ctx).pop(),
                  icon: const Icon(Icons.close),
                  style: IconButton.styleFrom(backgroundColor: Colors.white54),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    point.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Points (${_points.length})'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _points.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.location_off,
                          size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(
                        'Aucun point enregistré',
                        style: TextStyle(
                            fontSize: 16, color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Reviens sur la carte et appuie pour en ajouter.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: _points.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (ctx, i) {
                    final p = _points[i];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.teal.shade100,
                        child: Text(
                          '${i + 1}',
                          style: const TextStyle(
                              color: Colors.teal,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(p.name,
                          style:
                              const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text(
                        '${p.latitude.toStringAsFixed(5)}, ${p.longitude.toStringAsFixed(5)}',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade600),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.map_outlined,
                                color: Colors.teal),
                            onPressed: () => _showMiniMap(p),
                            tooltip: 'Voir sur carte',
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined),
                            onPressed: () => _editPoint(p),
                            tooltip: 'Renommer',
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.red),
                            onPressed: () => _deletePoint(p),
                            tooltip: 'Supprimer',
                          ),
                        ],
                      ),
                      onTap: () => _showMiniMap(p),
                    );
                  },
                ),
    );
  }
}
