import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

import '../models/event.dart';
import '../models/student.dart';
import '../models/student_data.dart';
import '../services/database.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/error_message.dart';
import 'add_events.dart';

class EventDetails extends StatefulWidget {
  final String id;

  const EventDetails({Key key, @required this.id}) : super(key: key);

  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final DateFormat _dateFormat = DateFormat('hh:mm a, d MMM yyyy');
  final DateFormat _registerFormat = DateFormat('d MMM yyyy');

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final String _id = widget.id;

    final Student student =
        Provider.of<StudentData>(context, listen: false).student;
    final bool isAdmin = student.isAdmin;
    final String uid = student.id;
    final String email = student.email;

    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: CustomAppBar(
            actions: isAdmin
                ? [
                    IconButton(
                      icon: const Icon(FontAwesomeIcons.check),
                      onPressed: () => customAlertDialog(
                          context: context,
                          title: 'Toggle Event!',
                          description:
                              'Are you sure you want to mark event finshed?',
                          onOK: () async {
                            DatabaseService.toggleEvent(
                              id: _id,
                              isFinished: true,
                            );
                            Navigator.pop(context);
                            Navigator.pop(context);
                          }),
                    ),
                    const SizedBox(width: 5),
                  ]
                : null,
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
              child: StreamBuilder<DocumentSnapshot>(
                stream: DatabaseService.getEvent(id: _id),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: ErrorMessage(
                        message: snapshot.error,
                      ),
                    );
                  } else if (snapshot.hasData) {
                    final Event event =
                        Event.fromDocumentSnapshot(snapshot.data);
                    return _buildEventDetail(
                      event: event,
                      context: context,
                      uid: uid,
                      email: email,
                      isAdmin: isAdmin,
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column _buildEventDetail({
    @required Event event,
    @required BuildContext context,
    @required String uid,
    @required String email,
    @required bool isAdmin,
  }) {
    return Column(
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
          'Event On: ${_dateFormat.format(event.date)}',
          textScaleFactor: 1.3,
          maxLines: 2,
          textAlign: TextAlign.justify,
          style: TextStyle(
            color: Theme.of(context).accentColor,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Register By: ${_registerFormat.format(event.register)}',
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
        ),
        const SizedBox(height: 20),
        if (!event.participants.contains(uid) && !event.registrationEnded)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                height: MediaQuery.of(context).size.height * 0.06,
                minWidth: MediaQuery.of(context).size.width * 0.6,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                onPressed: () async {
                  try {
                    setState(() {
                      _isLoading = true;
                    });
                    await DatabaseService.registerToEvent(
                      uid: uid,
                      email: email,
                      eventId: event.id,
                    );

                    _scaffoldKey.currentState.showSnackBar(const SnackBar(
                      content: Text('Registerd Successfully'),
                    ));
                  } catch (e) {
                    _scaffoldKey.currentState
                        .showSnackBar(SnackBar(content: Text('$e')));
                  } finally {
                    setState(() {
                      _isLoading = false;
                    });
                  }
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
        if (isAdmin) ...[
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(
                  FontAwesomeIcons.pen,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddEvent(
                      event: event,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  FontAwesomeIcons.trash,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () => customAlertDialog(
                  context: context,
                  title: 'Deleting Event!!!',
                  description: 'Are you sure you want to delete this event!?',
                  onOK: () {
                    DatabaseService.deleteEvent(id: event.id);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          Center(
            child: Column(
              children: [
                FlatButton(
                  color: Theme.of(context).accentColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onPressed: () {
                    Clipboard.setData(
                        ClipboardData(text: event.participantsEmail.join(',')));

                    _scaffoldKey.currentState.showSnackBar(const SnackBar(
                        content: Text(
                            'Participants email have been copied to clipboard')));
                  },
                  child: const Text(
                    'Get Participants Email',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                FlatButton(
                  color: Theme.of(context).accentColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    try {
                      await DatabaseService.toggleEventRegistration(
                          id: event.id,
                          registrationEnded: !event.registrationEnded);
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text(
                              'Registration for this event is ${event.registrationEnded ? 'resumed' : 'stopped'}')));
                    } catch (e) {
                      _scaffoldKey.currentState
                          .showSnackBar(SnackBar(content: Text('$e')));
                    } finally {
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  },
                  child: Text(
                    '${event.registrationEnded ? 'Resume' : 'Stop'} Registration',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}
