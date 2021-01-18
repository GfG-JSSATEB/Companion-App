import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/event.dart';
import '../screens/event_details.dart';
import '../screens/past_events_detals.dart';
import 'cached_image.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final DateFormat dateFormat = DateFormat('d MMM yyyy');

  EventCard({@required this.event});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => event.isFinished
          ? Navigator.push<PastEventDetails>(
              context,
              MaterialPageRoute(
                builder: (context) => PastEventDetails(
                  event: event,
                ),
              ),
            )
          : Navigator.push<EventDetails>(
              context,
              MaterialPageRoute(
                builder: (context) => EventDetails(
                  id: event.id,
                ),
              ),
            ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 5)],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: CustomCachedImage(
                  url: event.url,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                event.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textScaleFactor: 1.8,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).accentColor,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                event.description,
                maxLines: 5,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.justify,
                textScaleFactor: 1.2,
              ),
              const SizedBox(height: 15),
              _buildRichText(
                context: context,
                title: 'Event Date',
                value: dateFormat.format(event.date),
              ),
              const SizedBox(height: 5),
              _buildRichText(
                context: context,
                title: 'Register By',
                value: dateFormat.format(event.register),
              )
            ],
          ),
        ),
      ),
    );
  }

  RichText _buildRichText({
    @required BuildContext context,
    @required String title,
    @required String value,
  }) {
    return RichText(
      textAlign: TextAlign.center,
      maxLines: 2,
      textScaleFactor: 1.3,
      text: TextSpan(
        children: [
          TextSpan(
            text: "$title: ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).accentColor,
            ),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
              color: Theme.of(context).accentColor,
            ),
          ),
        ],
      ),
    );
  }
}
