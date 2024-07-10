import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddContactPage extends StatefulWidget {
  const AddContactPage({super.key});

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  // for new contact elements
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final newContact = Contact();
  Map<String, dynamic> formValues = {
    'fname': "",
    'lname': "",
    'number': "",
    'email': ""
  };

  // for camera features
  Permission permission = Permission.camera;
  PermissionStatus permissionStatus = PermissionStatus.denied;
  File? imageFile;

  // initialize permission check
  @override
  void initState() {
    super.initState();

    _listenForPermissionStatus();
  }

  // checks permission
  void _listenForPermissionStatus() async {
    final status = await permission.status;
    setState(() => permissionStatus = status);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add Contact"),
        ),
        body: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.all(20),
            child: ListView(
              children: [
                // for adding contact image
                uploadProfileImage(),
                // for first name
                TextFormField(
                  decoration: InputDecoration(labelText: "First Name"),
                  onChanged: ((String? value) {
                    formValues['fname'] = value;
                  }),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This is a required field';
                    }
                    return null;
                  },
                  onSaved: ((String? value) {
                    newContact.name.first = formValues['fname'];
                  }),
                ),
                // for last name
                TextFormField(
                  decoration: InputDecoration(labelText: "Last Name"),
                  onChanged: ((String? value) {
                    formValues['lname'] = value;
                  }),
                  onSaved: ((String? value) {
                    newContact.name.last = formValues['lname'];
                  }),
                ),
                // for number
                TextFormField(
                  decoration: InputDecoration(labelText: "Phone Number"),
                  onChanged: ((String? value) {
                    formValues['number'] = value;
                  }),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This is a required field';
                    }
                    return null;
                  },
                  onSaved: ((String? value) {
                    newContact.phones = [Phone(formValues['number'])];
                  }),
                ),
                // for email
                TextFormField(
                  decoration: InputDecoration(labelText: "Email"),
                  onChanged: ((String? value) {
                    formValues['email'] = value;
                  }),
                  onSaved: ((String? value) {
                    newContact.emails = [Email(formValues['email'])];
                  }),
                ),
                // add contact button
                Container(
                    padding: EdgeInsets.all(20),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState?.save();
                          setState(() {
                            newContact.insert();
                          });
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text("Contact added successfully!")));
                        }
                      },
                      child: const Text('Add Contact'),
                    ))
              ],
            ),
          ),
        ));
  }

  // for using camera to take contact image
  Widget uploadProfileImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        imageFile == null
            ? Container()
            : ClipOval(
                child: Image.file(imageFile!,
                    fit: BoxFit.cover, width: 100, height: 100),
              ),
        IconButton(
            onPressed: () async {
              if (permissionStatus == PermissionStatus.granted) {
                final image =
                    await ImagePicker().pickImage(source: ImageSource.camera);
                setState(() {
                  imageFile = image == null ? null : File(image.path);
                });
              } else {
                requestPermission();
              }
            },
            icon: Icon(
              Icons.camera_alt,
              size: (imageFile == null) ? 50 : 30,
            )),
      ],
    );
  }

  // asks for permission when called
  Future<void> requestPermission() async {
    final status = await permission.request();

    setState(() {
      permissionStatus = status;
    });
  }
}
