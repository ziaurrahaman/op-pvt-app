import 'package:OpPvt/models/user.dart';
import 'package:OpPvt/providers/auht_provider.dart';
import 'package:OpPvt/res/images.dart';
import 'package:OpPvt/res/screen_size_utils.dart';
import 'package:OpPvt/screens/login_signup/login_page.dart';
import 'package:OpPvt/screens/login_signup/signUp_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:op_pvt/models/user.dart';
// import 'package:op_pvt/providers/auht_provider.dart';
// import 'package:op_pvt/res/images.dart';

// import 'package:op_pvt/res/screen_size_utils.dart';
// import 'package:op_pvt/screens/login_signup/login_page.dart';
// import 'package:op_pvt/screens/login_signup/signUp_page.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final pageController = PageController(
    initialPage: 1,
  );
  TextStyle style;
  bool loading = true;
  @override
  void initState() {
    getUserID();
    super.initState();
  }

  void getUserID() async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final FirebaseUser user = await auth.currentUser();
      userId = user.uid;
      final document =
          await Firestore.instance.collection('users').document(userId).get();
      currentUser = User.fromMap(document.data);
      setState(() {
        loading = false;
      });
    } catch (e) {
      print(userId);
      setState(() {
        loading = false;
      });
    }
  }

  User currentUser;
  String userId;

  @override
  Widget build(BuildContext context) {
    style = TextStyle(fontSize: DS.setSP(14));

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: DS.setHeightRatio(0.17),
              width: DS.getWidth,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Expanded(
                      //   // width: DS.getWidth * 0.5,
                      //   child: ClipRRect(
                      //     borderRadius: BorderRadius.circular(8),
                      //     child: TextFormField(
                      //       controller: _searchController,
                      //       keyboardType: TextInputType.text,
                      //       style: TextStyle(
                      //           fontSize: DS.setSP(20), color: Colors.white),
                      //       decoration: InputDecoration(
                      //         fillColor: Color(0XFFFFFFFF).withOpacity(0.25),
                      //         filled: true,
                      //         hintText: 'Search',
                      //         // contentPadding: EdgeInsets.only(top: 6),
                      //         hintStyle: TextStyle(
                      //           fontSize: DS.setSP(17),
                      //           color: Color(0XFFA7A7A7),
                      //         ),
                      //         prefixIcon: SizedBox(
                      //           width: 48,
                      //           height: 48,
                      //           child: Center(
                      //             child: Icon(
                      //               Icons.search,
                      //               color: Color(0XFFA7A7A7),
                      //               // size: 22,
                      //             ),
                      //           ),
                      //         ),
                      //         border: InputBorder.none,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(
                      //   width: DS.setWidth(10),
                      // ),
                      Container(
                        width: DS.setWidthRatio(0.1),
                        decoration: BoxDecoration(
                          color: Color(0XFFFFFFFF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Image(
                            image: AssetImage(
                              Images.logo,
                            ),
                          ),
                        ),
                      ),
                      Selector<AuthProvider, FirebaseUser>(
                        selector: (context, AuthProvider value) =>
                            value.firebaseUser,
                        builder: (context, value, child) {
                          if (value == null) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _SignupLogin(
                                  title: 'login',
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => LoginPage(),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                  child: _SignupLogin(
                                    title: 'SignUp',
                                    onTap: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => SignUpPage(),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            );
                          } else {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              child: _SignupLogin(
                                title: 'Log Out',
                                onTap: () => {
                                  context.read<AuthProvider>().signOut(),
                                },
                              ),
                            );
                          }
                        },
                      ),
                      Container(
                        // height: DS.setHeightRatio(0.12),
                        width: DS.setWidthRatio(0.1),
                        decoration: BoxDecoration(
                          color: Color(0XFFFFFFFF).withOpacity(0.25),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: Center(
                            child: Image(
                              image: AssetImage(Images.rocket),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            loading
                ? Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Expanded(
                    child: StreamBuilder(
                      stream:
                          Firestore.instance.collection('users').snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                                ConnectionState.waiting ||
                            !snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.data.documents.length == 0) {
                          return Center(
                            child: Text("No Users Created."),
                          );
                        }
                        if (snapshot.hasError) {
                          return Center(child: Text(snapshot.error.toString()));
                        }
                        return PageView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (BuildContext context, int index) {
                            // final user = User.fromMap();
                            print(
                              snapshot.data.documents[index]['subscribers'],
                            );
                            return _buildContent(
                              User(
                                bio: snapshot.data.documents[index]['bio'],
                                dob: snapshot.data.documents[index]['dob'],
                                email: snapshot.data.documents[index]['email'],
                                flag: snapshot.data.documents[index]['flag'],
                                gender: snapshot.data.documents[index]
                                    ['gender'],
                                imageUrl: snapshot.data.documents[index]
                                    ['profile_picture'],
                                likes: snapshot.data.documents[index]['likes'],
                                name: snapshot.data.documents[index]['name'],
                                phoneNumber: snapshot.data.documents[index]
                                    ['phoneNumber'],
                                pinned: snapshot.data.documents[index]
                                    ['pinned'],
                                subscribers: snapshot.data.documents[index]
                                    ['subscribers'],
                                userId: snapshot.data.documents[index]
                                    ['userId'],
                                website: snapshot.data.documents[index]
                                    ['website'],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(User data) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            buildTopContainer(data),
            SizedBox(
              height: DS.setHeight(10),
            ),
            Container(
              decoration: BoxDecoration(
                color: Color(0xffA3A3A3).withOpacity(0.28),
                border: Border.all(color: Colors.grey, width: 0.3),
                borderRadius: BorderRadius.circular(5),
              ),
              child: ExpansionTile(
                title: Text(
                  'About',
                  style: TextStyle(
                      fontSize: DS.setSP(15),
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                childrenPadding:
                    EdgeInsets.only(left: 10, bottom: 10, right: 10),
                tilePadding: EdgeInsets.only(left: 10),
                children: [
                  _buildName('Name:', data.name),
                  _buildName('DOB:', data.dob),
                  _buildName('Email:', data.email),
                  _buildName('Gender:', data.gender),
                ],
              ),
            ),
            Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10),
                  height: DS.getHeight * 0.40,
                  width: DS.getWidth,
                  child: Center(
                    child: Image.asset(
                      Images.boyDoc,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  height: DS.getHeight * 0.40,
                  width: DS.getWidth,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(0),
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          // margin:
                          //     EdgeInsets.symmetric(horizontal: 10),
                          height: DS.setHeightRatio(0.15),
                          width: DS.getWidth,
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 5),
                                child: Row(
                                  children: [
                                    Text(
                                      'johnsmith11: ',
                                      style: TextStyle(
                                        fontSize: DS.setSP(15),
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      'you are looking good',
                                      style: TextStyle(
                                        fontSize: DS.setSP(15),
                                        // fontWeight: FontWeigh/t.bold,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                            itemCount: 5,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: TextFormField(
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'Add comment',
                                  hintStyle: TextStyle(
                                    color: Color(0xffFFFFFF).withOpacity(0.51),
                                  ),
                                ),
                              ),
                            ),
                            Icon(
                              Icons.send,
                              color: Color(0xffFFFFFF).withOpacity(0.51),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildName(String first, String second) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            first,
            style: TextStyle(
              fontSize: DS.setSP(13),
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            second,
            style: TextStyle(
              fontSize: DS.setSP(13),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTopContainer(User data) {
    return Card(
      elevation: 0,
      child: Row(
        children: [
          Container(
            width: DS.setWidth(100),
            height: DS.setHeight(120),
            decoration: BoxDecoration(
              // shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: data.imageUrl == null
                    ? AssetImage(
                        Images.boyDoc,
                      )
                    : NetworkImage(data.imageUrl),
              ),
            ),
          ),
          Expanded(
            // width: DS.getWidth * 0.5,
            // height: DS.setHeightRatio(0.19),
            // margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Container(
              margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.name,
                    style: TextStyle(
                      fontSize: DS.setSP(15),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: DS.setHeight(10),
                  ),
                  Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${data.likes.length} Likes',
                        style: TextStyle(
                          color: Color(0xffA3A3A3),
                          fontSize: DS.setSP(15),
                        ),
                      ),
                      Text(
                        '${data.subscribers.length} Subscribers',
                        style: TextStyle(
                          color: Color(0xffA3A3A3),
                          fontSize: DS.setSP(15),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      userId == data.userId
                          ? Container(
                              width: 0,
                              height: 0,
                            )
                          : Row(
                              children: [
                                InkWell(
                                  child: Icon(
                                    Icons.thumb_up,
                                    color: !data.likes.contains(userId)
                                        ? Color(0xffA3A3A3)
                                        : Colors.blue,
                                  ),
                                  onTap: () async {
                                    if (userId == null) {
                                      return;
                                    }
                                    if (!data.likes.contains(userId)) {
                                      data.likes.add(userId);
                                      await Firestore.instance
                                          .collection('users')
                                          .document(data.userId)
                                          .updateData({
                                        'likes': data.likes.length == 0
                                            ? []
                                            : data.likes,
                                      });
                                      currentUser.liked.add(data.userId);
                                      await Firestore.instance
                                          .collection('users')
                                          .document(userId)
                                          .updateData({
                                        'liked': currentUser.liked.length == 0
                                            ? []
                                            : currentUser.liked,
                                      });
                                      return;
                                    }
                                    if (data.likes.contains(userId)) {
                                      data.likes.remove(userId);
                                      await Firestore.instance
                                          .collection('users')
                                          .document(data.userId)
                                          .updateData({
                                        'likes': data.likes.length == 0
                                            ? []
                                            : data.likes,
                                      });
                                      currentUser.liked.remove(data.userId);
                                      await Firestore.instance
                                          .collection('users')
                                          .document(userId)
                                          .updateData({
                                        'liked': currentUser.liked.length == 0
                                            ? []
                                            : currentUser.liked
                                      });

                                      return;
                                    }
                                  },
                                ),
                                SizedBox(
                                  width: DS.setWidth(10),
                                ),
                              ],
                            ),
                      Icon(
                        Icons.email,
                        color: Color(0xffA3A3A3),
                      ),
                      SizedBox(
                        width: DS.setWidth(10),
                      ),
                      Icon(
                        Icons.flag,
                        color: Color(0xffA3A3A3),
                      ),
                      Spacer(),
                      userId == data.userId
                          ? Container(
                              width: 0,
                            )
                          : InkWell(
                              child: Container(
                                height: DS.setHeight(30),
                                width: DS.setWidthRatio(0.2),
                                decoration: BoxDecoration(
                                  color: Color(0XFFFF0000),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Text(
                                    data.subscribers.contains(userId)
                                        ? 'UnSubscribe'
                                        : 'Subscribe',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: DS.setSP(12),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () async {
                                if (userId == null) {
                                  return;
                                }
                                if (!data.subscribers.contains(userId)) {
                                  data.subscribers.add(userId);
                                  await Firestore.instance
                                      .collection('users')
                                      .document(data.userId)
                                      .updateData({
                                    'subscribers': data.subscribers.length == 0
                                        ? []
                                        : data.subscribers,
                                  });
                                  currentUser.subscribed.add(data.userId);
                                  await Firestore.instance
                                      .collection('users')
                                      .document(userId)
                                      .updateData({
                                    'subscribed':
                                        currentUser.subscribed.length == 0
                                            ? []
                                            : currentUser.subscribed,
                                  });
                                  return;
                                }
                                if (data.subscribers.contains(userId) &&
                                    userId != data.userId) {
                                  data.subscribers.remove(userId);
                                  await Firestore.instance
                                      .collection('users')
                                      .document(data.userId)
                                      .updateData({
                                    'subscribers': data.subscribers.length == 0
                                        ? []
                                        : data.subscribers,
                                  });
                                  currentUser.subscribed.remove(data.userId);
                                  await Firestore.instance
                                      .collection('users')
                                      .document(userId)
                                      .updateData({
                                    'subscribed':
                                        currentUser.subscribed.length == 0
                                            ? []
                                            : currentUser.subscribed,
                                  });
                                  return;
                                }
                              },
                            ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _SignupLogin extends StatelessWidget {
  final Function onTap;
  final String title;
  _SignupLogin({
    Key key,
    this.onTap,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0XFFFFFFFF).withOpacity(0.25),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: DS.setSP(15),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
