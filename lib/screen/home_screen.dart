import 'package:flutter/material.dart';
import '../constants.dart';

// Model Data Dummy (diambil dari constants.dart jika ada, tetapi diulang di sini untuk kemudahan)
class Event {
  final String title;
  final String description;
  final Color color;
  Event(this.title, this.description, this.color);
}
final List<Event> dummyEvents = [
  Event('Switch Fest', 'Ajak semua temanmu untuk bersenang-senang, malam ini...', kPrimaryColor),
  Event('ComFest', 'All questions and generative insights from any domain, with our...', kSecondaryColor),
  Event('Manajemen Fest', 'All questions and generative insights from any domain, with our...', const Color(0xFF8E44AD)),
  Event('Saintek Fest', 'All questions and generative insights from any domain, with our...', const Color(0xFF3498DB)),
];


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EVENTSONGO!', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: kPrimaryColor,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: kDefaultPadding / 2),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
              child: const Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: kPrimaryColor),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Thalita Azalia',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.fromLTRB(kDefaultPadding, kDefaultPadding, kDefaultPadding, 10),
            child: Text(
              'DAFTAR EVENT',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              itemCount: dummyEvents.length,
              itemBuilder: (context, index) {
                return EventCard(event: dummyEvents[index]);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
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
        if (index == 1) {
          Navigator.pushNamed(context, '/upload');
        } else if (index == 2) {
          Navigator.pushNamed(context, '/profile');
        }
      },
    );
  }
}

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({required this.event, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: kDefaultPadding),
      child: Container(
        decoration: BoxDecoration(
          color: kCardColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: event.color.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/detail');
          },
          borderRadius: BorderRadius.circular(15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 10,
                height: 150,
                decoration: BoxDecoration(
                  color: event.color,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(kDefaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        event.title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: event.color,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        event.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/detail');
                        },
                        child: Text(
                          'Lihat selengkapnya >',
                          style: TextStyle(color: event.color, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}