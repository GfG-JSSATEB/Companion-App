import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

import '../models/event.dart';
import '../services/database.dart';
import '../services/image_picker.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_textfield.dart';

class AddEvent extends StatefulWidget {
  final Event event;

  const AddEvent({Key key, this.event}) : super(key: key);

  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _desctiptionController = TextEditingController();

  final DateFormat _dateFormat = DateFormat('d MMM yyyy');

  String _titleErrorMessage = '';
  bool _validTitle = true;

  String _descriptionErrorMessage = '';
  bool _validDescription = true;

  bool _isUpdate;

  DateTime _eventPickedDate;
  TimeOfDay _eventTime;
  DateTime _registerPickedDate;

  File _poster;

  bool _isLoading = false;

  @override
  void initState() {
    _eventPickedDate = DateTime.now();
    _eventTime = TimeOfDay.now();
    _registerPickedDate = DateTime.now();
    _isUpdate = widget.event != null;
    if (_isUpdate) {
      _titleController.text = widget.event.title;
      _desctiptionController.text = widget.event.description;
      _eventPickedDate = widget.event.date;
      _registerPickedDate = widget.event.register;
      _eventTime = TimeOfDay.fromDateTime(_eventPickedDate);
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

  Future<void> _pickDate(String type) async {
    final DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDate: type == 'event' ? _eventPickedDate : _registerPickedDate,
    );
    if (date != null) {
      if (type == 'event') {
        setState(() {
          _eventPickedDate = date;
        });
      } else {
        setState(() {
          _registerPickedDate = date;
        });
      }
    }
  }

  Future<void> _pickTime() async {
    final TimeOfDay t =
        await showTimePicker(context: context, initialTime: _eventTime);
    if (t != null) {
      setState(() {
        _eventTime = t;
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
      _poster = await imagePicker.pickImage(
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

  Future<void> _onSubmit() async {
    try {
      setState(() {
        _isLoading = true;
      });
      _isUpdate
          ? await DatabaseService.updateEvent(
              id: widget.event.id,
              title: _titleController.text.trim(),
              description: _desctiptionController.text.trim(),
              date: DateTime(
                _eventPickedDate.year,
                _eventPickedDate.month,
                _eventPickedDate.day,
                _eventTime.hour,
                _eventTime.minute,
              ),
              register: _registerPickedDate,
            )
          : await DatabaseService.addEvent(
              title: _titleController.text.trim(),
              description: _desctiptionController.text.trim(),
              poster: _poster,
              date: DateTime(
                _eventPickedDate.year,
                _eventPickedDate.month,
                _eventPickedDate.day,
                _eventTime.hour,
                _eventTime.minute,
              ),
              register: _registerPickedDate,
            );

      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Even ${_isUpdate ? 'updated' : 'added'} Successfully'),
        ),
      );

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
                  _textInfo(),
                  const SizedBox(height: 20),
                  _dateInfo(),
                  if (!_isUpdate) ...[
                    const InputText(title: 'Poster'),
                    ListTile(
                      title:
                          Text(_poster != null ? 'Uploaded' : 'Choose a file'),
                      trailing: const Icon(FontAwesomeIcons.chevronDown),
                      onTap: () => _pickImage(),
                    ),
                  ],
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

  Column _textInfo() {
    return Column(
      children: [
        const InputText(title: 'Title'),
        const SizedBox(height: 10),
        CustomTextField(
          controller: _titleController,
          title: 'Title',
          validity: _validTitle,
          errorMessage: _titleErrorMessage,
          obscureText: false,
        ),
        const SizedBox(height: 20),
        const InputText(title: 'Description'),
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

  Column _dateInfo() {
    return Column(
      children: [
        const InputText(title: 'Event Date'),
        ListTile(
          title: Text("Date: ${_dateFormat.format(_eventPickedDate)}"),
          trailing: const Icon(FontAwesomeIcons.chevronDown),
          onTap: () => _pickDate('event'),
        ),
        const InputText(title: 'Event Time'),
        ListTile(
          title: Text("Time: ${_eventTime.hour}:${_eventTime.minute}"),
          trailing: const Icon(FontAwesomeIcons.chevronDown),
          onTap: _pickTime,
        ),
        const InputText(title: 'Last Date to register'),
        ListTile(
          title: Text("Date: ${_dateFormat.format(_registerPickedDate)}"),
          trailing: const Icon(FontAwesomeIcons.chevronDown),
          onTap: () => _pickDate('register'),
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

        if (_validDescription &&
            _validTitle &&
            (_isUpdate || _poster != null)) {
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
