import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

import '../../models/event.dart';
import '../../services/database.dart';
import '../../services/image_picker.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_textfield.dart';

class AddEvent extends StatefulWidget {
  final Event event;

  const AddEvent({Key key, this.event}) : super(key: key);

  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController desctiptionController = TextEditingController();

  final DateFormat dateFormat = DateFormat('d MMM yyyy');

  String titleErrorMessage = '';
  bool validTitle = true;

  String descriptionErrorMessage = '';
  bool validDescription = true;

  bool isUpdate;

  DateTime eventPickedDate;
  TimeOfDay eventTime;
  DateTime registerPickedDate;

  File poster;

  bool _isLoading = false;

  @override
  void initState() {
    eventPickedDate = DateTime.now();
    eventTime = TimeOfDay.now();
    registerPickedDate = DateTime.now();
    isUpdate = widget.event != null;
    if (isUpdate) {
      titleController.text = widget.event.title;
      desctiptionController.text = widget.event.description;
      eventPickedDate = widget.event.date;
      registerPickedDate = widget.event.register;
      eventTime = TimeOfDay.fromDateTime(eventPickedDate);
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

  Future<void> _pickDate(String type) async {
    final DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDate: type == 'event' ? eventPickedDate : registerPickedDate,
    );
    if (date != null) {
      if (type == 'event') {
        setState(() {
          eventPickedDate = date;
        });
      } else {
        setState(() {
          registerPickedDate = date;
        });
      }
    }
  }

  Future<void> _pickTime() async {
    final TimeOfDay t =
        await showTimePicker(context: context, initialTime: eventTime);
    if (t != null) {
      setState(() {
        eventTime = t;
      });
    }
  }

  Future<void> _pickImage() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final imagePicker =
          Provider.of<ImagePickerService>(context, listen: false);
      poster = await imagePicker.pickImage(
        source: ImageSource.gallery,
      );
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
              child: Column(
                children: [
                  textInfo(),
                  const SizedBox(height: 20),
                  dateInfo(),
                  if (!isUpdate) ...[
                    const InputText(title: 'Poster'),
                    ListTile(
                      title:
                          Text(poster != null ? 'Uploaded' : 'Choose a file'),
                      trailing: const Icon(FontAwesomeIcons.chevronDown),
                      onTap: () => _pickImage(),
                    ),
                  ],
                  const SizedBox(height: 20),
                  submitButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column textInfo() {
    return Column(
      children: [
        const InputText(title: 'Title'),
        const SizedBox(height: 10),
        CustomTextField(
          controller: titleController,
          title: 'Title',
          validity: validTitle,
          errorMessage: titleErrorMessage,
          obscureText: false,
        ),
        const SizedBox(height: 20),
        const InputText(title: 'Description'),
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
      ],
    );
  }

  Column dateInfo() {
    return Column(
      children: [
        const InputText(title: 'Event Date'),
        ListTile(
          title: Text("Date: ${dateFormat.format(eventPickedDate)}"),
          trailing: const Icon(FontAwesomeIcons.chevronDown),
          onTap: () => _pickDate('event'),
        ),
        const InputText(title: 'Event Time'),
        ListTile(
          title: Text("Time: ${eventTime.hour}:${eventTime.minute}"),
          trailing: const Icon(FontAwesomeIcons.chevronDown),
          onTap: _pickTime,
        ),
        const InputText(title: 'Last Date to register'),
        ListTile(
          title: Text("Date: ${dateFormat.format(registerPickedDate)}"),
          trailing: const Icon(FontAwesomeIcons.chevronDown),
          onTap: () => _pickDate('register'),
        ),
      ],
    );
  }

  MaterialButton submitButton(BuildContext context) {
    return MaterialButton(
      height: MediaQuery.of(context).size.height * 0.06,
      minWidth: MediaQuery.of(context).size.width * 0.6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      onPressed: () async {
        setState(() {
          validDescription = isValidDescription();
          validTitle = isValidTitle();
        });

        if (validDescription && validTitle && (isUpdate || poster != null)) {
          setState(() {
            _isLoading = true;
          });
          try {
            isUpdate
                ? await DatabaseService.updateEvent(
                    id: widget.event.id,
                    title: titleController.text.trim(),
                    description: desctiptionController.text.trim(),
                    date: DateTime(
                      eventPickedDate.year,
                      eventPickedDate.month,
                      eventPickedDate.day,
                      eventTime.hour,
                      eventTime.minute,
                    ),
                    register: registerPickedDate,
                  )
                : await DatabaseService.addEvent(
                    title: titleController.text.trim(),
                    description: desctiptionController.text.trim(),
                    poster: poster,
                    date: DateTime(
                      eventPickedDate.year,
                      eventPickedDate.month,
                      eventPickedDate.day,
                      eventTime.hour,
                      eventTime.minute,
                    ),
                    register: registerPickedDate,
                  );

            _scaffoldKey.currentState.showSnackBar(
              SnackBar(
                content:
                    Text('Even ${isUpdate ? 'updated' : 'added'} Successfully'),
              ),
            );

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
    );
  }
}

class InputText extends StatelessWidget {
  final String title;
  const InputText({
    Key key,
    @required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      '$title:',
      textScaleFactor: 2,
      style: TextStyle(
        color: Theme.of(context).accentColor,
      ),
    );
  }
}
