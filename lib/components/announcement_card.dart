import 'package:flutter/material.dart';

import '../models/announcement.dart';
import '../screens/announcement.dart';

class AnnouncementCard extends StatelessWidget {
  final Announcement announcement;

  const AnnouncementCard({@required this.announcement});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AnnouncementScreen(announcement: announcement),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 3)],
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text(
              announcement.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              textScaleFactor: 2,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).accentColor,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              announcement.description,
              softWrap: true,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 5,
              textScaleFactor: 1.3,
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  color: Theme.of(context).accentColor,
                ),
                Text(
                  " ${announcement.relativeTime}",
                  textScaleFactor: 1.2,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
