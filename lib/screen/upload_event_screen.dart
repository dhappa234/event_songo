import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../constants.dart';

// Koordinat UIN Walisongo Semarang (Pusat Peta Awal)
const LatLng _kUINWalisongoLocation = LatLng(-6.9839, 110.3756);

class UploadEventScreen extends StatefulWidget {
  const UploadEventScreen({super.key});

  @override
  State<UploadEventScreen> createState() => _UploadEventScreenState();
}

class _UploadEventScreenState extends State<UploadEventScreen> {
  DateTime? _selectedDate;
  LatLng _pickedLocation = _kUINWalisongoLocation;
  final MapController mapController = MapController();
  final TextEditingController _searchController = TextEditingController(); // Controller untuk Search Box

  // --- FUNGSI NAVIGASI PETA ---

  // Fungsi untuk Zoom In
  void _zoomIn() {
    final currentZoom = mapController.camera.zoom;
    mapController.move(mapController.camera.center, currentZoom + 1);
  }

  // Fungsi untuk Zoom Out
  void _zoomOut() {
    final currentZoom = mapController.camera.zoom;
    mapController.move(mapController.camera.center, currentZoom - 1);
  }

  // Fungsi Simulasi Pencarian Lokasi
  // Karena Geocoding berbayar/API terbatas, ini adalah SIMULASI
  void _simulateSearchLocation(String query) {
    // Di aplikasi nyata, ini akan memanggil API Geocoding.
    // Kita simulasi dengan selalu mengarahkan ke koordinat UIN Walisongo

    // Asumsi: jika query tidak kosong, anggap pencarian berhasil
    if (query.isNotEmpty) {
      setState(() {
        _pickedLocation = _kUINWalisongoLocation;
      });
      mapController.move(_kUINWalisongoLocation, 16.0); // Zoom lebih dekat ke hasil pencarian
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Simulasi: Peta diarahkan ke UIN Walisongo.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan lokasi yang ingin dicari.')),
      );
    }
  }

  // --- FUNGSI FORM LAINNYA ---

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _onMapTap(TapPosition tapPosition, LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Lokasi dipilih: Lat ${position.latitude.toStringAsFixed(4)}, Lng ${position.longitude.toStringAsFixed(4)}')),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: const Text('UPLOAD EVENT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildTextFormField(label: 'Nama Event', hintText: 'Masukkan Nama Event'),
            const SizedBox(height: 20),

            _buildDateFormField(context),
            const SizedBox(height: 20),

            _buildTextFormField(label: 'Deskripsi Event', hintText: 'Tulis deskripsi event secara singkat', maxLines: 4),
            const SizedBox(height: 20),

            _buildUploadButton(label: 'Logo Event', icon: Icons.image_rounded),
            const SizedBox(height: 20),

            // === PETA INTERAKTIF OSM DENGAN KONTROL ===
            _buildLocationPicker(),
            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Logika Submit Event
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 5,
                ),
                child: const Text('SUBMIT EVENT', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  // --- Widget Map & Kontrol ---

  Widget _buildLocationPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Tempat Event', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 8),

        // Search Box (Simulasi Geocoding)
        _buildSearchBox(),
        const SizedBox(height: 10),

        Container(
          height: 250,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack( // Gunakan Stack untuk menempatkan peta dan tombol kontrol
              children: [
                FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                    initialCenter: _kUINWalisongoLocation, // Diatur ke UIN Walisongo
                    initialZoom: 14.0,
                    onTap: _onMapTap,
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
                          point: _pickedLocation,
                          child: const Icon(Icons.location_on, color: kPrimaryColor, size: 40.0),
                        ),
                      ],
                    ),
                  ],
                ),
                // Tombol Kontrol Zoom
                Positioned(
                  top: 10,
                  right: 10,
                  child: Column(
                    children: [
                      // TOMBOL ZOOM IN (mini: true DIHAPUS)
                      FloatingActionButton.small(
                        heroTag: 'zoom_in',
                        // mini: true, <-- Dihapus
                        backgroundColor: kCardColor,
                        onPressed: _zoomIn,
                        child: const Icon(Icons.add, color: kPrimaryColor),
                      ),
                      const SizedBox(height: 5),
                      // TOMBOL ZOOM OUT (mini: true DIHAPUS)
                      FloatingActionButton.small(
                        heroTag: 'zoom_out',
                        // mini: true, <-- Dihapus
                        backgroundColor: kCardColor,
                        onPressed: _zoomOut,
                        child: const Icon(Icons.remove, color: kPrimaryColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Koordinat Dipilih: Lat ${_pickedLocation.latitude.toStringAsFixed(4)}, Lng ${_pickedLocation.longitude.toStringAsFixed(4)}',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildSearchBox() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Cari Alamat, misal: Kampus UIN',
              filled: true,
              fillColor: kCardColor,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Tombol Cari Koordinat (Simulasi Geocoding)
        FloatingActionButton.small(
          heroTag: 'search_location',
          backgroundColor: kPrimaryColor,
          onPressed: () => _simulateSearchLocation(_searchController.text),
          child: const Icon(Icons.search, color: Colors.white),
        ),
      ],
    );
  }

  // --- Widget Form Lainnya ---

  Widget _buildTextFormField({required String label, required String hintText, int maxLines = 1}) {
    // ... (kode tetap sama)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 8),
        TextFormField(
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: kCardColor,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.all(12),
          ),
        ),
      ],
    );
  }

  Widget _buildDateFormField(BuildContext context) {
    // ... (kode tetap sama)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Tanggal Event', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _selectDate(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            decoration: BoxDecoration(
              color: kCardColor,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2)),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: kPrimaryColor.withOpacity(0.7), size: 20),
                const SizedBox(width: 10),
                Text(
                  _selectedDate == null
                      ? 'Pilih Tanggal Event'
                      : '${_selectedDate!.day}-${_selectedDate!.month}-${_selectedDate!.year}',
                  style: TextStyle(
                    color: _selectedDate == null ? Colors.grey : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadButton({required String label, required IconData icon}) {
    // ... (kode tetap sama)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 8),
        Container(
          height: 60,
          width: double.infinity,
          decoration: BoxDecoration(
            color: kCardColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: InkWell(
            onTap: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: kSecondaryColor),
                const SizedBox(width: 8),
                const Text('Pilih Logo', style: TextStyle(color: kSecondaryColor, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    // ... (kode tetap sama)
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.cloud_upload), label: 'Upload'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
      currentIndex: 1,
      selectedItemColor: kPrimaryColor,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      onTap: (index) {
        if (index == 0) Navigator.pushNamed(context, '/home');
        if (index == 2) Navigator.pushNamed(context, '/profile');
      },
    );
  }
}