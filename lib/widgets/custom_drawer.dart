import 'package:flutter/material.dart';
import 'package:gfg_jssateb/color_constants.dart';
import 'package:gfg_jssateb/screens/events.dart';
import 'package:provider/provider.dart';

import '../screens/home.dart';
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
              iconData: Icons.home,
              onTap: () =>
                  Navigator.pushReplacementNamed(context, HomePage.routeName),
            ),
            DrawerTile(
              title: 'Events',
              iconData: Icons.event,
              onTap: () =>
                  Navigator.pushReplacementNamed(context, EventsPage.routeName),
            ),
            DrawerTile(
              title: 'Sign Out',
              iconData: Icons.exit_to_app,
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
          leading: Icon(iconData, color: kTextColor),
          title: Text(
            title,
            textScaleFactor: 1.3,
            style: const TextStyle(
              color: kTextColor,
            ),
          ),
          onTap: () => onTap(),
        ),
        const Divider(color: kTextColor, thickness: 2),
      ],
    );
  }
}
