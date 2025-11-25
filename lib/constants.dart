import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart'; // Digunakan untuk koordinat LatLng

// ===================================
// === 1. KONSTANTA WARNA & UKURAN ===
// ===================================
const Color kPrimaryColor = Color(0xFFE67E22); // Orange (Warna Aksi/Utama)
const Color kSecondaryColor = Color(0xFF27AE60); // Green (Warna Sekunder/Sukses)
const Color kBackgroundColor = Color(0xFFF7F7F7); // Light background (Latar Belakang Aplikasi)
const Color kCardColor = Colors.white; // Warna Kartu/Elemen
const double kDefaultPadding = 20.0;
const double kDefaultRadius = 12.0;

// =============================
// === 2. MODEL DATA (CLASSES) ===
// =============================

// Model untuk Data Event yang diambil dari Supabase
class EventDetail {
  final int id; // ID dari tabel Supabase
  final String title;
  final String date;
  final String location;
  final String type;
  final String description;
  final String imageUrl; // URL gambar dari Storage Supabase
  final LatLng mapLocation; // Menggunakan LatLng dari latlong2
  final DateTime createdAt; // Waktu pembuatan

  EventDetail({
    required this.id,
    required this.title,
    required this.date,
    required this.location,
    required this.type,
    required this.description,
    required this.imageUrl,
    required this.mapLocation,
    required this.createdAt,
  });

  // Factory constructor untuk membuat objek EventDetail dari Map (JSON Supabase)
  factory EventDetail.fromJson(Map<String, dynamic> json) {
    return EventDetail(
      id: json['id'] as int,
      title: json['title'] as String,
      date: json['date'] as String, // Atau sesuaikan jika Anda menggunakan tipe data Date
      location: json['location'] as String,
      type: json['type'] as String,
      description: json['description'] as String,
      imageUrl: json['image_url'] as String, // Asumsi nama kolom di Supabase adalah 'image_url'
      // Asumsi Supabase menyimpan lat/lng sebagai kolom terpisah (misalnya, 'latitude' dan 'longitude')
      mapLocation: LatLng(json['latitude'] as double, json['longitude'] as double),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

// Model untuk Event yang diunggah pengguna (untuk layar Profil)
class UploadedEvent {
  final int id;
  final String title;
  final String status; // Status: 'Disetujui', 'Pending', 'Ditolak'

  UploadedEvent({required this.id, required this.title, required this.status});

  factory UploadedEvent.fromJson(Map<String, dynamic> json) {
    return UploadedEvent(
      id: json['id'] as int,
      title: json['title'] as String,
      status: json['status'] as String, // Asumsi ada kolom 'status' di tabel
    );
  }
}


// ===============================
// === 3. DATA DUMMY (Opsional) ===
// ===============================

// Anda dapat menghapus ini jika semua data sudah dihubungkan ke Supabase,
// tetapi ini berguna untuk pengujian UI.
const LatLng uinWalisongoLocation = LatLng(-6.9839, 110.3756);

final EventDetail dummySwitchFestDetail = EventDetail(
  id: 1,
  title: 'Super Walisongo Information Technology Festival',
  date: '1 - 10 Desember 2025',
  location: 'Kampus 3 UIN Walisongo Semarang',
  type: 'Futsal Tournament',
  description:
  'All questions and generative insights from any domain, with our AI-powered TCF check tool. Lorem ipsum dolor sit amet, lorem ipsum. Ajak semua temanmu untuk bersenang-senang, malam ini...',
  imageUrl: 'https://placehold.co/600x400/png', // Placeholder
  mapLocation: uinWalisongoLocation,
  createdAt: DateTime.now(),
);

final List<UploadedEvent> dummyUploadedEvents = [
  UploadedEvent(id: 1, title: 'Switch Fest', status: 'Disetujui'),
  UploadedEvent(id: 2, title: 'ComFest', status: 'Disetujui'),
  UploadedEvent(id: 3, title: 'Manajemen Fest', status: 'Pending'),
];