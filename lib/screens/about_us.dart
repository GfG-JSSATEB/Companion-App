import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../color_constants.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_drawer.dart';

class AboutUs extends StatelessWidget {
  static const routeName = '/aboutUs';

  final String fburl =
      "https://www.facebook.com/Gfg_jssateb-100108775197286/?ref=page_internal";
  final String websiteurl = "mailto:gfg.jssateb@gmail.com";
  final String linkedinUrl =
      "https://www.linkedin.com/company/geeksforgeeks-student-chapter-jssateb/";
  final String whatsappUrl = "https://chat.whatsapp.com/GKTxGaduQl6649CvzvrbYr";
  final String instagramUrl = "https://www.instagram.com/gfg_jssateb/";

  Future<void> _launchSocial(String url) async {
    try {
      bool launched =
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
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(
          title: 'About Us',
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
                  'description descriptiondescriptiondescription escriptio nescription escriptionescription escriptionescription ',
                  softWrap: true,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                  textScaleFactor: 1.3,
                  style: TextStyle(color: kTextColor),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildIconButton(
                        icon: FontAwesomeIcons.facebook, url: fburl),
                    buildIconButton(
                        icon: FontAwesomeIcons.instagram, url: instagramUrl),
                    buildIconButton(
                        icon: FontAwesomeIcons.linkedinIn, url: linkedinUrl),
                    buildIconButton(
                        icon: FontAwesomeIcons.whatsapp, url: whatsappUrl),
                    buildIconButton(
                        icon: FontAwesomeIcons.globe, url: websiteurl),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconButton buildIconButton({@required IconData icon, @required String url}) {
    return IconButton(
      icon: Icon(
        icon,
        color: kTextColor,
        size: 30,
      ),
      onPressed: () {
        _launchSocial(url);
      },
    );
  }
}
