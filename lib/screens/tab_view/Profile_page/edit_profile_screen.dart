import 'package:OpPvt/models/user.dart';
import 'package:OpPvt/providers/auht_provider.dart';
import 'package:OpPvt/res/images.dart';
import 'package:OpPvt/res/screen_size_utils.dart';
import 'package:OpPvt/res/validators.dart';
import 'package:OpPvt/widgets/alert_pop_up.dart';
// import 'package:OpPvt/lib/widgets/alert_pop_up.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
// import 'package:op_pvt/models/user.dart';
// import 'package:op_pvt/providers/auht_provider.dart';
// import 'package:op_pvt/res/images.dart';
// import 'package:op_pvt/res/screen_size_utils.dart';
// import 'package:op_pvt/res/validators.dart';
// import 'package:op_pvt/screens/tab_view/Profile_page/personel_info.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController _userNameController;
  TextEditingController _websiteController;
  TextEditingController _bioController;
  TextEditingController _emailController;

  TextEditingController _phoneController;

  TextEditingController _genderController;

  String dateOfBirth;
  final format = DateFormat("yyyy-MM-dd");
  User _user = User();
  @override
  void initState() {
    // _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _genderController = TextEditingController();
    _userNameController = TextEditingController();
    _websiteController = TextEditingController();
    _bioController = TextEditingController();
    getCurrentUserData();
    super.initState();
  }

  showAlerDialogAndEditProfile() {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text("Edit Profile"),
            content: Column(
              children: <Widget>[
                SizedBox(height: 24.0),
                Text(
                  'Are you sure you want to edit your profile',
                  style: TextStyle(
                    fontFamily: "RB",
                    fontWeight: FontWeight.normal,
                    fontSize: 16.0,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(height: 36.0),
                RaisedButton(
                  color: Colors.black,
                  onPressed: () async {
                    if (!formKey.currentState.validate()) {
                      return;
                    }
                    await Firestore.instance
                        .collection('users')
                        .document(_user.userId)
                        .updateData({
                      'name': _userNameController.text,
                      'website': _websiteController.text,
                      'bio': _bioController.text,
                    });
                    await Firestore.instance
                        .collection('users')
                        .document(_user.userId)
                        .updateData({
                      'email': _emailController.text,
                      'gender': _genderController.text,
                      'phoneNumber': _phoneController.text,
                      'dob': dateOfBirth,
                    });
                    Navigator.of(context).pop();
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
        });
  }

  final formKey = GlobalKey<FormState>();

  bool loading = true;
  void getCurrentUserData() async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final FirebaseUser user = await auth.currentUser();
      // User currentUser;
      final uid = user.uid;
      // print(uid);
      final document =
          await Firestore.instance.collection("users").document(uid).get();
      _user = User.fromMap(document.data);
      print(_user.userId);
      _userNameController.text = _user.name;
      _bioController.text = _user.bio;
      _websiteController.text = _user.website;
      _user = User.fromMap(document.data);
      _emailController.text = _user.email;
      _genderController.text = _user.gender;
      _phoneController.text = _user.phoneNumber;
      dateOfBirth = _user.dob;
      setState(() {
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Column(children: [
          Stack(
            children: [
              Container(
                width: deviceSize.width,
                height: 100,
              ),
              Positioned(
                bottom: 18,
                child: Container(
                  height: 90,
                  width: deviceSize.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0),
                    ),
                    color: const Color(0xff000000),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x29939393),
                        offset: Offset(0, 10),
                        blurRadius: 30,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'EDIT MY PROFILE',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          fontFamily: 'Emmett'),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 24,
                child: Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 2)),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      // Navigator.of(context).pop();
                    },
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 140,
              width: deviceSize.width,
              child: Image.asset(
                'assets/images/default_add_image2.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            'EDIT PROFILE PICTURE',
            style: TextStyle(
                fontSize: 20,
                fontFamily: 'Emmett',
                color: Colors.blue,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 8,
          ),
          // Container(
          //   height: 260,
          //   width: 260,
          //   decoration: BoxDecoration(
          //       shape: BoxShape.rectangle,
          //       borderRadius: BorderRadius.circular(8)),
          //   child: Image.asset(
          //     'assets/images/default_profile_image.png',
          //     fit: BoxFit.fill,
          //   ),
          // ),
          // SizedBox(
          //   height: 8,
          // ),
          // Text(
          //   'EDIT MY POST',
          //   style: TextStyle(
          //       fontSize: 20,
          //       fontFamily: 'Emmett',
          //       color: Colors.blue,
          //       fontWeight: FontWeight.bold),
          // ),
          SizedBox(
            height: 24,
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Text(
          //         'UserName: ',
          //         style: TextStyle(
          //             fontSize: 18,
          //             fontWeight: FontWeight.bold,
          //             fontFamily: 'Emmett'),
          //       ),
          //       SizedBox(
          //         height: 10,
          //       ),
          //       Text(
          //         'Email: ',
          //         style: TextStyle(
          //             fontSize: 18,
          //             fontWeight: FontWeight.bold,
          //             fontFamily: 'Emmett'),
          //       ),
          //       SizedBox(
          //         height: 10,
          //       ),
          //       Row(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Text(
          //             'Bio:   ',
          //             style: TextStyle(
          //                 fontSize: 18,
          //                 fontWeight: FontWeight.bold,
          //                 fontFamily: 'Emmett'),
          //           ),
          //           Container(
          //             width: deviceSize.width * 0.80,
          //             child: Text(
          //               'This is an example. This is an example. This is an example. This is an example.',
          //               maxLines: 4,
          //               textAlign: TextAlign.start,
          //               overflow: TextOverflow.ellipsis,
          //               style: TextStyle(
          //                   fontSize: 14,
          //                   color: Colors.black,
          //                   fontWeight: FontWeight.w500),
          //             ),
          //           )
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
          SingleChildScrollView(
            reverse: true,
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTop(),
                  _buildUpdating(
                    'Username :',
                    _userNameController,
                    Validators.emptyValidator,
                  ),
                  _buildUpdating(
                    'Website :',
                    _websiteController,
                    Validators.emptyValidator,
                  ),
                  _buildUpdating(
                    'Bio :',
                    _bioController,
                    Validators.emptyValidator,
                  ),
                  // InkWell(
                  //   child: Padding(
                  //     padding: const EdgeInsets.symmetric(
                  //         horizontal: 20, vertical: 10),
                  //     child: Container(
                  //       decoration: BoxDecoration(
                  //           border: Border.all(
                  //             color: Colors.grey[300],
                  //           ),
                  //           borderRadius: BorderRadius.circular(30),
                  //           color: Colors.grey[200]),
                  //       // color: Colors.red[200],
                  //       child: Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: Text(
                  //           'Personel Information',
                  //           style: TextStyle(
                  //             fontSize: DS.setSP(15),
                  //             fontWeight: FontWeight.w500,
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  //   onTap: () => Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => PersonelInfoPage(),
                  //     ),
                  //   ),
                  // )
                  SizedBox(
                    height: 32,
                  ),
                  // _buildUpdatingForPersonalInfo('Email Address :',
                  //     _emailController, Validators.emailValidator),
                  // _buildUpdatingForPersonalInfo('Phone Number :',
                  //     _phoneController, Validators.emptyValidator,
                  //     keyboard: TextInputType.phone),
                  // _buildUpdatingForPersonalInfo(
                  //   'Gender :',
                  //   _genderController,
                  //   Validators.emptyValidator,
                  // ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () {
                        DatePicker.showDatePicker(context,
                            showTitleActions: true,
                            minTime: DateTime(1950, 3, 5),
                            maxTime: DateTime.now(),
                            theme: DatePickerTheme(
                              backgroundColor: Color(0xFF0F0F0F),
                              itemStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              cancelStyle:
                                  TextStyle(color: Colors.white, fontSize: 16),
                              doneStyle:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ), onChanged: (date) {
                          print('change $date in time zone ' +
                              date.timeZoneOffset.inHours.toString());
                        }, onConfirm: (date) {
                          setState(
                            () {
                              dateOfBirth = format.format(date).toString();
                              print('confirm $date');
                              // dob = date.toString();
                            },
                          );
                        }, currentTime: DateTime.now(), locale: LocaleType.en);
                      },
                      child: Container(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: (dateOfBirth == null)
                              ? Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.calendar_today,
                                      color: Colors.grey[600],
                                    ),
                                    SizedBox(
                                      width: DS.setWidth(100),
                                    ),
                                    Center(
                                      child: Text(
                                        'Select your date of birth',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              : Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Icon(
                                      Icons.calendar_today,
                                      color: Colors.black,
                                    ),
                                    SizedBox(
                                      width: DS.setWidth(100),
                                    ),
                                    Text(
                                      dateOfBirth,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 24,
          ),
          RaisedButton(
            onPressed: () {
              showAlerDialogAndEditProfile();
            }
            // () async {
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
            //   Navigator.of(context).pop();
            // }
            ,
            color: Colors.black,
            child: Text(
              'Save',
              style: TextStyle(fontFamily: 'Emmett', color: Colors.white),
            ),
          ),
          SizedBox(
            height: 16,
          )
        ]),
      ),
    ));
  }

  Padding _buildUpdating(
      String text, TextEditingController controller, Function validator) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: TextStyle(color: Colors.grey[600]),
          ),
          TextFormField(
            validator: validator,
            controller: controller,
          )
        ],
      ),
    );
  }

  Column _buildTop() {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              // shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: _user.imageUrl == null
                    ? AssetImage(Images.boyDoc)
                    : NetworkImage(_user.imageUrl),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        InkWell(
          child: Text(
            'EDIT MY POST',
            style: TextStyle(
                fontSize: 20,
                fontFamily: 'Emmett',
                color: Colors.blue,
                fontWeight: FontWeight.bold),
          ),
          onTap: () => AuthProvider().uploadProfilePicture(ImageSource.gallery),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Padding _buildUpdatingForPersonalInfo(
      String text, TextEditingController controller, Function validator,
      {TextInputType keyboard}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: TextStyle(color: Colors.grey[600]),
          ),
          TextFormField(
            keyboardType: keyboard ?? TextInputType.text,
            validator: validator,
            controller: controller,
          )
        ],
      ),
    );
  }
}
