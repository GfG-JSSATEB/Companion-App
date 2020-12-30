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

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _desctiptionController = TextEditingController();

  String _titleErrorMessage = '';
  bool _validTitle = true;

  String _descriptionErrorMessage = '';
  bool _validDescription = true;

  bool _isUpdate;

  bool _isLoading = false;

  @override
  void initState() {
    _isUpdate = widget.announcement != null;
    if (_isUpdate) {
      _titleController.text = widget.announcement.title;
      _desctiptionController.text = widget.announcement.description;
    }
    super.initState();
  }

  bool _isValidDescription() {
    if (_desctiptionController.text.trim().length < 3) {
      _descriptionErrorMessage = 'Description too short';
      return false;
    } else {
      return true;
    }
  }

  bool _isValidTitle() {
    if (_titleController.text.trim().length < 3) {
      _titleErrorMessage = 'Title too short';
      return false;
    } else {
      return true;
    }
  }

  Future<void> _onSubmit() async {
    try {
      setState(() {
        _isLoading = true;
      });
      _isUpdate
          ? await DatabaseService.updateAnnouncement(
              title: _titleController.text.trim(),
              description: _desctiptionController.text.trim(),
              id: widget.announcement.id,
            )
          : await DatabaseService.addAnnouncement(
              title: _titleController.text.trim(),
              description: _desctiptionController.text.trim(),
            );

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content:
            Text('Announcemnt ${_isUpdate ? 'updated' : 'added'} Successfully'),
      ));

      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    } catch (e) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('$e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _desctiptionController.dispose();
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
                  _inputForm(context),
                  const SizedBox(height: 20),
                  _submitButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column _inputForm(BuildContext context) {
    return Column(
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
          controller: _titleController,
          title: 'Title',
          validity: _validTitle,
          errorMessage: _titleErrorMessage,
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
          controller: _desctiptionController,
          title: 'Description',
          validity: _validDescription,
          textInputType: TextInputType.multiline,
          maxLines: null,
          errorMessage: _descriptionErrorMessage,
          obscureText: false,
        ),
      ],
    );
  }

  MaterialButton _submitButton(BuildContext context) {
    return MaterialButton(
      height: MediaQuery.of(context).size.height * 0.06,
      minWidth: MediaQuery.of(context).size.width * 0.6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      onPressed: () async {
        setState(() {
          _validDescription = _isValidDescription();
          _validTitle = _isValidTitle();
        });

        if (_validDescription && _validTitle) {
          await _onSubmit();
        }
      },
      color: Theme.of(context).accentColor,
      child: Text(
        _isUpdate ? 'Update' : "Add",
        textScaleFactor: 1.4,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
