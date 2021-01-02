import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/custom_appbar.dart';
import '../widgets/custom_drawer.dart';

class AboutApp extends StatelessWidget {
  static const String routeName = '/aboutApp';
  final String _playstoreUrl = 'https://play.google.com/store';
  final String _githubeUrl = 'https://github.com/GfG-JSSATEB';

  Future<void> _launchSocial(String url) async {
    try {
      final bool launched =
          await launch(url, forceSafariVC: false, forceWebView: false);
      if (!launched) {
        await launch("https://www.geeksforgeeks.org/",
            forceSafariVC: false, forceWebView: false);
      }
    } catch (e) {
      await launch("https://www.geeksforgeeks.org/",
          forceSafariVC: false, forceWebView: false);
    }
  }

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
          title: 'About App',
        ),
      ),
      drawer: CustomDrawer(),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding: const EdgeInsets.all(15),
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 3)],
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Text(
                  'GfG JSSATEB',
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
                const Text(
                  'GfG JSSATEB app is created to provide seamless experience for students to register and participate in events and get latest announcements directly in their finger tips.',
                  softWrap: true,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.visible,
                  textScaleFactor: 1.3,
                ),
                const SizedBox(height: 15),
                const ListTile(
                  trailing: Text(
                    '1.0.0',
                    textScaleFactor: 1.5,
                  ),
                  title: Text(
                    'Version',
                    textScaleFactor: 1.5,
                  ),
                ),
                _AboutTile(
                  icon: FontAwesomeIcons.shareAlt,
                  title: 'Share',
                  onTap: () => Share.share(
                      'Check out the app at https://example.com',
                      subject: 'GfG JSSATEB has a app now!!'),
                ),
                _AboutTile(
                  icon: FontAwesomeIcons.googlePlay,
                  title: 'Rate Us',
                  onTap: () => _launchSocial(_playstoreUrl),
                ),
                _AboutTile(
                  icon: FontAwesomeIcons.github,
                  title: 'Contribute',
                  onTap: () => _launchSocial(_githubeUrl),
                ),
                _AboutTile(
                  title: 'Contact Developer',
                  icon: FontAwesomeIcons.solidEnvelope,
                  onTap: () => _launchSocial('mailto:varun.sathreya@gmail.com'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AboutTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function onTap;
  const _AboutTile({
    Key key,
    @required this.title,
    @required this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        textScaleFactor: 1.5,
      ),
      trailing: IconButton(
        icon: Icon(
          icon,
          size: 30,
          color: Theme.of(context).accentColor,
        ),
        onPressed: () => onTap(),
      ),
    );
  }
}
