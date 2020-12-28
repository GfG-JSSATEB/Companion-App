import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../../models/announcement.dart';
import '../../services/database.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_textfield.dart';

class AddAnnouncement extends StatefulWidget {
  final Announcement announcement;

  const AddAnnouncement({Key key, this.announcement}) : super(key: key);

  @override
  _AddAnnouncementState createState() => _AddAnnouncementState();
}

class _AddAnnouncementState extends State<AddAnnouncement> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController desctiptionController = TextEditingController();

  String titleErrorMessage = '';
  bool validTitle = true;

  String descriptionErrorMessage = '';
  bool validDescription = true;

  bool isUpdate;

  bool _isLoading = false;

  @override
  void initState() {
    isUpdate = widget.announcement != null;
    if (isUpdate) {
      titleController.text = widget.announcement.title;
      desctiptionController.text = widget.announcement.description;
    }
    super.initState();
  }

  bool isValidDescription() {
    if (desctiptionController.text.trim().length < 3) {
      descriptionErrorMessage = 'Description too short';
      return false;
    } else {
      return true;
    }
  }

  bool isValidTitle() {
    if (titleController.text.trim().length < 3) {
      titleErrorMessage = 'Title too short';
      return false;
    } else {
      return true;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    desctiptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: Scaffold(
        key: _scaffoldKey,
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
                children: [
                  Text(
                    'Title:',
                    textScaleFactor: 2,
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: titleController,
                    title: 'Title',
                    validity: validTitle,
                    errorMessage: titleErrorMessage,
                    obscureText: false,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Description:',
                    textScaleFactor: 2,
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: desctiptionController,
                    title: 'Description',
                    validity: validDescription,
                    textInputType: TextInputType.multiline,
                    maxLines: null,
                    errorMessage: descriptionErrorMessage,
                    obscureText: false,
                  ),
                  const SizedBox(height: 20),
                  MaterialButton(
                    height: MediaQuery.of(context).size.height * 0.06,
                    minWidth: MediaQuery.of(context).size.width * 0.6,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: () async {
                      setState(() {
                        validDescription = isValidDescription();
                        validTitle = isValidTitle();
                      });

                      if (validDescription && validTitle) {
                        setState(() {
                          _isLoading = true;
                        });
                        try {
                          isUpdate
                              ? await DatabaseService.updateAnnouncement(
                                  title: titleController.text.trim(),
                                  description:
                                      desctiptionController.text.trim(),
                                  id: widget.announcement.id,
                                )
                              : await DatabaseService.addAnnouncement(
                                  title: titleController.text.trim(),
                                  description:
                                      desctiptionController.text.trim(),
                                );

                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text(
                                'Announcemnt ${isUpdate ? 'updated' : 'added'} Successfully'),
                          ));

                          Future.delayed(const Duration(seconds: 2), () {
                            Navigator.pop(context);
                          });
                        } catch (e) {
                          _scaffoldKey.currentState
                              .showSnackBar(SnackBar(content: Text('$e')));
                        } finally {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      }
                    },
                    color: Theme.of(context).accentColor,
                    child: Text(
                      isUpdate ? 'Update' : "Add",
                      textScaleFactor: 1.4,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
