import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../color_constants.dart';
import '../models/event.dart';
import '../services/database.dart';
import '../widgets/custom_appbar.dart';

class EventDetails extends StatefulWidget {
  final String id;

  const EventDetails({Key key, @required this.id}) : super(key: key);

  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  final DateFormat dateFormat = DateFormat('hh:mm a, d MMM yyyy');
  final DateFormat registerFormat = DateFormat('d MMM yyyy');

  final String uid = FirebaseAuth.instance.currentUser.uid;
  final String email = FirebaseAuth.instance.currentUser.email;

  Event event;

  bool _isLoading = true;

  Future<void> getEvent() async {
    final Event temp = await DatabaseService.getEvent(id: widget.id);
    setState(() {
      event = temp;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    getEvent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            body: const Center(child: CircularProgressIndicator()),
          )
        : Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: CustomAppBar(
                leading: IconButton(
                  icon: const Icon(
                    FontAwesomeIcons.chevronLeft,
                    size: 30,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: 'Event',
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.only(
                  bottom: 20, left: 20, right: 20, top: 10),
              child: Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        textScaleFactor: 2,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Event On: ${dateFormat.format(event.date)}',
                        textScaleFactor: 1.3,
                        maxLines: 2,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Register By: ${registerFormat.format(event.register)}',
                        textScaleFactor: 1.3,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        event.description,
                        softWrap: true,
                        textAlign: TextAlign.center,
                        textScaleFactor: 1.2,
                        style: const TextStyle(color: kTextColor),
                      ),
                      const SizedBox(height: 20),
                      if (!event.participants.contains(uid))
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MaterialButton(
                              height: MediaQuery.of(context).size.height * 0.06,
                              minWidth: MediaQuery.of(context).size.width * 0.6,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              onPressed: () async {
                                setState(() {
                                  _isLoading = true;
                                });
                                await DatabaseService.registerToEvent(
                                  uid: uid,
                                  email: email,
                                  eventId: event.id,
                                );
                                await getEvent();
                                setState(() {
                                  _isLoading = false;
                                });
                              },
                              color: Theme.of(context).accentColor,
                              child: const Text(
                                "Register",
                                textScaleFactor: 1.4,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}

class PastEventDetails extends StatelessWidget {
  final DateFormat dateFormat = DateFormat('hh:mm a, d MMM yyyy');

  final Event event;

  PastEventDetails({Key key, this.event}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: CustomAppBar(
          leading: IconButton(
            icon: const Icon(
              FontAwesomeIcons.chevronLeft,
              size: 30,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: 'Event',
        ),
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(bottom: 20, left: 20, right: 20, top: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  textScaleFactor: 2,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).accentColor,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Event was On: ${dateFormat.format(event.date)}',
                  textScaleFactor: 1.3,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  event.description,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  textScaleFactor: 1.2,
                  style: const TextStyle(color: kTextColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
