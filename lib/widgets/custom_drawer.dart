import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../screens/about_us.dart';
import '../screens/events.dart';
import '../screens/home.dart';
import '../screens/settings.dart';
import '../screens/sign_in.dart';
import '../services/auth.dart';

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
            DrawerTile(
              title: 'Home',
              iconData: FontAwesomeIcons.home,
              onTap: () =>
                  Navigator.pushReplacementNamed(context, HomePage.routeName),
            ),
            DrawerTile(
              title: 'Events',
              iconData: FontAwesomeIcons.calendarAlt,
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const EventsPage(
                    isFinished: false,
                  ),
                ),
              ),
            ),
            DrawerTile(
              title: 'Past Events',
              iconData: FontAwesomeIcons.calendarCheck,
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const EventsPage(
                    isFinished: true,
                  ),
                ),
              ),
            ),
            DrawerTile(
              title: 'About Us',
              iconData: FontAwesomeIcons.info,
              onTap: () =>
                  Navigator.pushReplacementNamed(context, AboutUs.routeName),
            ),
            DrawerTile(
              title: 'Settings',
              iconData: FontAwesomeIcons.cog,
              onTap: () =>
                  Navigator.pushReplacementNamed(context, Settings.routeName),
            ),
            DrawerTile(
              title: 'Sign Out',
              iconData: FontAwesomeIcons.signOutAlt,
              onTap: () async {
                await context.read<AuthService>().signOut();
                Navigator.pushReplacementNamed(context, SignIn.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }

  CircleAvatar logo(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).accentColor,
      radius: 65,
      child: ClipOval(child: Image.asset('assets/images/logo.jpg')),
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

class DrawerTile extends StatelessWidget {
  final String title;
  final IconData iconData;
  final Function onTap;

  const DrawerTile({
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
