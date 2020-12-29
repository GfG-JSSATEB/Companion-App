import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../models/student_data.dart';
import '../screens/about_us.dart';
import '../screens/admin/get_student.dart';
import '../screens/events.dart';
import '../screens/home.dart';
import '../screens/settings.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Theme.of(context).backgroundColor,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 30),
            logo(context),
            const SizedBox(height: 30),
            header(context),
            const SizedBox(height: 30),
            _DrawerTile(
              title: 'Home',
              iconData: FontAwesomeIcons.home,
              onTap: () =>
                  Navigator.pushReplacementNamed(context, HomePage.routeName),
            ),
            _DrawerTile(
              title: 'Events',
              iconData: FontAwesomeIcons.calendarAlt,
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const EventsPage(
                    isFinished: false,
                    isParticipated: false,
                  ),
                ),
              ),
            ),
            _DrawerTile(
              title: 'Past Events',
              iconData: FontAwesomeIcons.calendarCheck,
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const EventsPage(
                    isFinished: true,
                    isParticipated: false,
                  ),
                ),
              ),
            ),
            _DrawerTile(
              title: 'About Us',
              iconData: FontAwesomeIcons.info,
              onTap: () =>
                  Navigator.pushReplacementNamed(context, AboutUs.routeName),
            ),
            _DrawerTile(
              title: 'Settings',
              iconData: FontAwesomeIcons.cog,
              onTap: () =>
                  Navigator.pushReplacementNamed(context, Settings.routeName),
            ),
            Consumer<StudentData>(
              builder: (_, student, __) {
                return student.isAdmin
                    ? _DrawerTile(
                        title: 'Get Student',
                        iconData: FontAwesomeIcons.solidUser,
                        onTap: () => Navigator.pushReplacementNamed(
                            context, GetStudent.routeName),
                      )
                    : const Text('');
              },
            )
          ],
        ),
      ),
    );
  }

  CircleAvatar logo(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).accentColor,
      radius: 65,
      child: ClipOval(child: Image.asset('assets/images/logo.png')),
    );
  }

  Center header(BuildContext context) {
    return Center(
      child: Text(
        'GfG JSSATEB',
        textAlign: TextAlign.center,
        textScaleFactor: 2.5,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).accentColor,
        ),
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  final String title;
  final IconData iconData;
  final Function onTap;

  const _DrawerTile({
    Key key,
    @required this.title,
    @required this.iconData,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(
            iconData,
            color: Theme.of(context).accentColor,
          ),
          title: Text(
            title,
            textScaleFactor: 1.3,
          ),
          onTap: () => onTap(),
        ),
        const Divider(
          thickness: 2,
        ),
      ],
    );
  }
}
