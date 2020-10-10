import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlertPopUp extends StatelessWidget {
  final String message;
  final String title;

  AlertPopUp({@required this.message, this.title});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title ?? "Error"),
      content: Column(
        children: <Widget>[
          SizedBox(height: 24.0),
          Text(
            message,
            style: TextStyle(
              fontFamily: "RB",
              fontWeight: FontWeight.normal,
              fontSize: 16.0,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(height: 36.0),
          RaisedButton(
            color: Theme.of(context).primaryColor,
            onPressed: () {
              Navigator.of(context).pop();
              //   if (!formKey.currentState.validate()) {
              //     return;
              //   }
              //   await Firestore.instance
              //       .collection('users')
              //       .document(_user.userId)
              //       .updateData({
              //     'name': _userNameController.text,
              //     'website': _websiteController.text,
              //     'bio': _bioController.text,
              //   });
              //   await Firestore.instance
              //       .collection('users')
              //       .document(_user.userId)
              //       .updateData({
              //     'email': _emailController.text,
              //     'gender': _genderController.text,
              //     'phoneNumber': _phoneController.text,
              //     'dob': dateOfBirth,
              //   });
            },
            child: Text(
              "Okay",
              style: TextStyle(
                fontFamily: "RB",
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
          SizedBox(height: 8.0),
        ],
      ),
    );
  }
}
