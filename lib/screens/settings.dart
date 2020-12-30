import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../screens/sign_in.dart';
import '../services/auth.dart';
import '../settings/dark_notifier.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_drawer.dart';
import 'about_app.dart';
import 'profile.dart';

class Settings extends StatelessWidget {
  static const String routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    bool _isDark = Provider.of<DarkNotifier>(context, listen: false).isDark;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(
          title: 'Settings',
        ),
      ),
      drawer: CustomDrawer(),
      body: Consumer<DarkNotifier>(
        builder: (context, value, child) {
          return Padding(
            padding:
                const EdgeInsets.only(bottom: 20, left: 20, right: 20, top: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
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
                    _SettingsTile(
                      icon: FontAwesomeIcons.solidUser,
                      title: 'Profile',
                      onTap: () =>
                          Navigator.pushNamed(context, ProfilePage.routeName),
                    ),
                    _SettingsTile(
                      icon: FontAwesomeIcons.infoCircle,
                      title: 'About App',
                      onTap: () =>
                          Navigator.pushNamed(context, AboutApp.routeName),
                    ),
                    _SettingsTile(
                      icon: FontAwesomeIcons.fill,
                      title: 'Dark Theme',
                      trailing: Switch(
                        value: _isDark,
                        onChanged: (value) {
                          _isDark = value;
                          Provider.of<DarkNotifier>(context, listen: false)
                              .darkMode = _isDark;
                        },
                      ),
                      onTap: () {},
                    ),
                    _SettingsTile(
                      title: 'Sign Out',
                      icon: FontAwesomeIcons.signOutAlt,
                      onTap: () async {
                        await context.read<AuthService>().signOut();
                        Navigator.pushReplacementNamed(
                            context, SignIn.routeName);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function onTap;
  final Widget trailing;

  const _SettingsTile({
    Key key,
    @required this.title,
    @required this.icon,
    @required this.onTap,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onTap(),
      leading: Icon(
        icon,
        color: Theme.of(context).accentColor,
      ),
      title: Text(
        title,
        textScaleFactor: 1.2,
      ),
      trailing: trailing,
    );
  }
}
