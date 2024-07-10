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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final newContact = Contact();

  Map<String, dynamic> formValues = {
    'fname': "",
    'lname': "",
    'number': "",
    'email': ""
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add Contact"),
        ),
        body: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.all(30),
            child: ListView(
              children: [
                // for first name
                Container(
                    child: TextFormField(
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
                )),
                // for last name
                Container(
                    child: TextFormField(
                  decoration: InputDecoration(labelText: "Last Name"),
                  onChanged: ((String? value) {
                    formValues['lname'] = value;
                  }),
                  onSaved: ((String? value) {
                    newContact.name.last = formValues['lname'];
                  }),
                )),
                // for number
                Container(
                    child: TextFormField(
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
                )),
                // for email
                Container(
                    child: TextFormField(
                  decoration: InputDecoration(labelText: "Email"),
                  onChanged: ((String? value) {
                    formValues['email'] = value;
                  }),
                  onSaved: ((String? value) {
                    newContact.emails = [Email(formValues['email'])];
                  }),
                )),
                // add contact button
                TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState?.save();
                      setState(() {
                        newContact.insert();
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Contact added successfully!")));
                    }
                  },
                  child: const Text('Add Contact'),
                ),
              ],
            ),
          ),
        ));
  }
}
