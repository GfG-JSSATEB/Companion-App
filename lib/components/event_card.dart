import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../color_constants.dart';
import '../models/event.dart';
import 'cached_image.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final DateFormat dateFormat = DateFormat('d MMM yyyy');

  EventCard({@required this.event});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              style: TextStyle(
                color: kTextColor.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 15),
            buildRichText(
              context: context,
              title: 'Event Date:',
              value: dateFormat.format(event.date),
            ),
            const SizedBox(height: 5),
            buildRichText(
              context: context,
              title: 'Register By:',
              value: dateFormat.format(event.register),
            )
          ],
        ),
      ),
    );
  }

  RichText buildRichText({
    @required BuildContext context,
    @required String title,
    @required String value,
  }) {
    return RichText(
      textAlign: TextAlign.center,
      maxLines: 2,
      textScaleFactor: 1.3,
      text: TextSpan(
        style: TextStyle(
          color: kTextColor.withOpacity(0.8),
        ),
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
          ),
        ],
      ),
    );
  }
}
