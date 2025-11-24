import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../constants.dart';

class DetailEventScreen extends StatelessWidget {
  const DetailEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final detail = switchFestDetail;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: detail.color,
        title: const Text('SWITCH FEST', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              detail.title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 15),

            _buildInfoCard(icon: Icons.date_range, label: 'Tanggal Berlangsung', value: detail.date),
            const SizedBox(height: 15),
            _buildInfoCard(icon: Icons.location_on, label: 'Tempat', value: detail.location),
            const SizedBox(height: 15),

            // === PETA STATIS OSM ===
            _buildMapWidget(context, detail.mapLocation),
            const SizedBox(height: 15),

            _buildInfoCard(icon: Icons.category, label: 'Jenis Kegiatan', value: detail.type),
            const SizedBox(height: 25),

            Text(
              'Deskripsi Event',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: detail.color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              detail.description,
              style: const TextStyle(fontSize: 15, height: 1.5),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildMapWidget(BuildContext context, LatLng location) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300)
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: FlutterMap(
          options: const MapOptions(
            initialCenter: uinWalisongoLocation,
            initialZoom: 15.0,
            interactionOptions: InteractionOptions(flags: InteractiveFlag.none),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.eventsongo.app',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  width: 80.0,
                  height: 80.0,
                  point: location,
                  child: const Icon(Icons.location_on, color: kPrimaryColor, size: 40.0),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildInfoCard({required IconData icon, required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.all(kDefaultPadding / 2),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey)),
          const SizedBox(height: 5),
          Row(
            children: [
              Icon(icon, color: kPrimaryColor, size: 20),
              const SizedBox(width: 8),
              Expanded(child: Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.cloud_upload), label: 'Upload'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
      currentIndex: 0,
      selectedItemColor: kPrimaryColor,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      onTap: (index) {
        if (index == 0) Navigator.popUntil(context, ModalRoute.withName('/home')); // Kembali ke Home
        if (index == 1) Navigator.pushNamed(context, '/upload');
        if (index == 2) Navigator.pushNamed(context, '/profile');
      },
    );
  }
}