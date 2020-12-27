import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../models/announcement.dart';
import '../models/student_data.dart';
import '../services/database.dart';
import '../widgets/custom_appbar.dart';
import 'admin/add_announcement.dart';

class AnnouncementScreen extends StatelessWidget {
  final Announcement announcement;

  void showAlertDialog(BuildContext context) {
    final Widget cancelButton = FlatButton(
      onPressed: () => Navigator.pop(context),
      child: const Text(
        "Cancel",
        textScaleFactor: 1.2,
      ),
    );
    final Widget okButton = FlatButton(
      onPressed: () async {
        await DatabaseService.deleteAnnouncement(id: announcement.id);
        Navigator.pop(context);
        Navigator.pop(context);
      },
      child: const Text(
        "OK",
        textScaleFactor: 1.2,
      ),
    );

    final AlertDialog alert = AlertDialog(
      backgroundColor: Theme.of(context).backgroundColor,
      title: Text(
        "Deleting Announcement!!!",
        textScaleFactor: 1.1,
        style: TextStyle(color: Theme.of(context).accentColor),
      ),
      content: const Text(
        "Are you sure you want to delete the announcement?",
        textScaleFactor: 1.1,
      ),
      actions: [
        cancelButton,
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  const AnnouncementScreen({Key key, @required this.announcement})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final bool isAdmin =
        Provider.of<StudentData>(context, listen: false).isAdmin;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: CustomAppBar(
          actions: isAdmin
              ? [
                  IconButton(
                    icon: const Icon(FontAwesomeIcons.plus),
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddAnnouncement(),
                      ),
                    ),
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
          title: 'Announcement',
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
                const SizedBox(height: 20),
                Text(
                  'Date: ${announcement.date}',
                  textScaleFactor: 1.5,
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  announcement.description,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  textScaleFactor: 1.4,
                ),
                if (isAdmin) ...[
                  const SizedBox(height: 10),
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
                            builder: (context) =>
                                AddAnnouncement(announcement: announcement),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          FontAwesomeIcons.trash,
                          color: Theme.of(context).accentColor,
                        ),
                        onPressed: () => showAlertDialog(context),
                      )
                    ],
                  ),
                  const SizedBox(height: 10)
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
