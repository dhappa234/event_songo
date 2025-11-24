import 'package:flutter/material.dart';
import '../constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: const Text('PROFIL', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          children: <Widget>[
            // Bagian Profil Atas
            Container(
              padding: const EdgeInsets.all(kDefaultPadding),
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 50, color: kPrimaryColor),
                  ),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Zenitsu Agatsuma',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        'Zenitsuu@gmail.com',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Detail Informasi
            _buildProfileDetailCard(
              label: 'Jurusan',
              value: 'Teknik Informatika',
            ),
            const SizedBox(height: 15),
            _buildProfileDetailCard(
              label: 'Angkatan',
              value: '2020',
            ),
            const SizedBox(height: 30),

            // Daftar Event yang Diunggah
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Daftar Event Yang Diunggah',
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ),
            const SizedBox(height: 15),

            // List Event yang Diunggah
            Container(
              decoration: BoxDecoration(
                color: kCardColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(), // Untuk list di dalam SingleChildScrollView
                shrinkWrap: true,
                itemCount: dummyUploadedEvents.length,
                separatorBuilder: (context, index) => const Divider(height: 1, indent: 15, endIndent: 15),
                itemBuilder: (context, index) {
                  final event = dummyUploadedEvents[index];
                  return ListTile(
                    title: Text(event.title),
                    trailing: Text(
                      event.status,
                      style: TextStyle(
                        color: event.status == 'Disetujui' ? kSecondaryColor : kPrimaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildProfileDetailCard({required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.all(kDefaultPadding / 2),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
      currentIndex: 2, // Current index di Profile
      selectedItemColor: kPrimaryColor,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      onTap: (index) {
        if (index == 0) Navigator.pushNamed(context, '/home');
        if (index == 1) Navigator.pushNamed(context, '/upload');
        // index 2: Current page
      },
    );
  }
}