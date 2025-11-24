import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart'; // Digunakan untuk koordinat LatLng

// === KONSTANTA WARNA & UKURAN ===
const Color kPrimaryColor = Color(0xFFE67E22); // Orange
const Color kSecondaryColor = Color(0xFF27AE60); // Green
const Color kBackgroundColor = Color(0xFFF7F7F7); // Light background
const Color kCardColor = Colors.white;
const double kDefaultPadding = 20.0;

// === MODEL DATA EVENT DETAIL ===
class EventDetail {
  final String title;
  final String date;
  final String location;
  final String type;
  final String description;
  final Color color;
  final LatLng mapLocation; // Menggunakan LatLng dari latlong2

  EventDetail({
    required this.title,
    required this.date,
    required this.location,
    required this.type,
    required this.description,
    required this.color,
    required this.mapLocation,
  });
}

// === DATA DUMMY ===
const LatLng uinWalisongoLocation = LatLng(-6.9839, 110.3756);

final EventDetail switchFestDetail = EventDetail(
  title: 'Super Walisongo Information Technology Festival',
  date: '1 - 10 Desember 2025',
  location: 'Kampus 3 UIN Walisongo Semarang',
  type: 'Futsal Tournament',
  description:
  'All questions and generative insights from any domain, with our AI-powered TCF check tool. Lorem ipsum dolor sit amet, lorem ipsum. Ajak semua temanmu untuk bersenang-senang, malam ini...',
  color: kPrimaryColor,
  mapLocation: uinWalisongoLocation,
);

class UploadedEvent {
  final String title;
  final String status;

  UploadedEvent(this.title, this.status);
}

final List<UploadedEvent> dummyUploadedEvents = [
  UploadedEvent('Switch Fest', 'Disetujui'),
  UploadedEvent('ComFest', 'Disetujui'),
  UploadedEvent('Manajemen Fest', 'Pending'),
];