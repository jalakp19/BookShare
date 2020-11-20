import 'package:book_share/components/rounded_button.dart';
import 'package:book_share/screens/login_screen.dart';
import 'package:book_share/services/auth.dart';
import 'package:book_share/services/crud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class BookPageEdit extends StatefulWidget {
  static const String id = 'book_page_edit';
  final DocumentSnapshot docId;
  BookPageEdit({@required this.docId});

  @override
  _BookPageEditState createState() => _BookPageEditState();
}

class _BookPageEditState extends State<BookPageEdit> {
  AuthMethods authMethods = new AuthMethods();
  CRUDMethods crudMethods = new CRUDMethods();
  CollectionReference books = FirebaseFirestore.instance.collection('books');

  var _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  bool spinner = false;

  File newProfilePic;
  Future getImage() async {
    var tempImg = await ImagePicker().getImage(source: ImageSource.gallery);
    newProfilePic = File(tempImg.path);

    setState(() {
      spinner = true;
    });
    uploadImage();
  }

  uploadImage() {
    String imgName = getRandomString(15);
    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('bookimages/$imgName.jpg');

    StorageUploadTask task = firebaseStorageRef.putFile(newProfilePic);
    task.onComplete.then((value) async {
      print('##############done#########');
      var newPhotoUrl = await value.ref.getDownloadURL();
      String strVal = newPhotoUrl.toString();
      setState(() {
        crudMethods.updateBookImg(widget.docId.id, strVal);
        spinner = false;
      });
    }).catchError((e) {
      print(e);
    });
  }

  deleteBook() {
    Navigator.of(context).pop();
    Navigator.pop(context, true);
    print('###########');
    print('###########');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: Color(0xFF12867E),
          leading: Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
            ),
            child: Icon(
              Icons.menu_book_sharp,
              size: 35.0,
            ),
          ),
          titleSpacing: 0.0,
          title: Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8.0),
            child: Text(
              'Book Share',
              style: TextStyle(
                fontSize: 22.0,
              ),
            ),
          ),
          actions: <Widget>[
            GestureDetector(
              onTap: () async {
                try {
                  await authMethods.signOut();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                      (Route<dynamic> route) => false);
                } catch (e) {
                  print(e.toString());
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 2.0, right: 16.0),
                child: Icon(Icons.logout),
              ),
            ),
          ],
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: spinner,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 2.0),
                child: Expanded(
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: books.doc(widget.docId.id).snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text("Loading");
                      }

                      return Center(
                        child: Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                2.5,
                                        padding: EdgeInsets.all(1.0),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.black, width: 1),
                                          shape: BoxShape.rectangle,
                                          color: Colors.black,
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                snapshot.data['book_img']),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width / 1.8,
                                height:
                                    MediaQuery.of(context).size.height / 3.5,
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.black, width: 1),
                                  shape: BoxShape.rectangle,
                                  color: Colors.grey[300],
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image:
                                        NetworkImage(snapshot.data['book_img']),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width / 2.0,
                                  top:
                                      MediaQuery.of(context).size.height / 4.0),
                              child: CircleAvatar(
                                backgroundColor: Colors.black54,
                                child: IconButton(
                                  icon: Icon(Icons.edit),
                                  color: Colors.white,
                                  onPressed: () {
                                    getImage();
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 7.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: Color(0xBB128C7E),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Flexible(
                          child: StreamBuilder<DocumentSnapshot>(
                            stream: books.doc(widget.docId.id).snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return Text('Something went wrong');
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Text("Loading");
                              }

                              return Text(
                                snapshot.data['book_name'],
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.only(
                        right: 10.0,
                        left: 10.0,
                      ),
                      icon: Icon(Icons.edit),
                      color: Colors.white,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            final _formKey = GlobalKey<FormState>();

                            TextEditingController myController =
                                TextEditingController();

                            return AlertDialog(
                              title: Row(
                                children: [
                                  Icon(
                                    Icons.edit,
                                    color: Colors.red[700],
                                    size: 25.0,
                                  ),
                                  Text('  Edit Book Name')
                                ],
                              ),
                              content: Form(
                                key: _formKey,
                                child: TextFormField(
                                  autofocus: true,
                                  cursorColor: Colors.black,
                                  controller: myController,
                                  textAlign: TextAlign.center,
                                  validator: (input) => (input.trim().length ==
                                              0 ||
                                          input.trim().length > 40)
                                      ? 'Name should be less than or equal to 40 characters'
                                      : null,
                                ),
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                        fontSize: 18.0, color: Colors.black54),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                FlatButton(
                                  child: Text(
                                    'Done',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      _formKey.currentState.save();

                                      crudMethods.updateBookName(
                                          widget.docId.id, myController.text);
                                      Navigator.of(context).pop();
                                    }
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 7.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: Color(0xBB128C7E),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Flexible(
                          child: StreamBuilder<DocumentSnapshot>(
                            stream: books.doc(widget.docId.id).snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return Text('Something went wrong');
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Text("Loading");
                              }

                              return Text(
                                snapshot.data['author_name'],
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.only(
                        right: 10.0,
                        left: 10.0,
                      ),
                      icon: Icon(Icons.edit),
                      color: Colors.white,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            final _formKey = GlobalKey<FormState>();

                            TextEditingController myController =
                                TextEditingController();

                            return AlertDialog(
                              title: Row(
                                children: [
                                  Icon(
                                    Icons.edit,
                                    color: Colors.red[700],
                                    size: 25.0,
                                  ),
                                  Text('  Edit Author\'s Name')
                                ],
                              ),
                              content: Form(
                                key: _formKey,
                                child: TextFormField(
                                  autofocus: true,
                                  cursorColor: Colors.black,
                                  controller: myController,
                                  textAlign: TextAlign.center,
                                  validator: (input) => (input.trim().length ==
                                              0 ||
                                          input.trim().length > 40)
                                      ? 'Name should be less than or equal to 40 characters'
                                      : null,
                                ),
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                        fontSize: 18.0, color: Colors.black54),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                FlatButton(
                                  child: Text(
                                    'Done',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      _formKey.currentState.save();

                                      crudMethods.updateAuthorName(
                                          widget.docId.id, myController.text);
                                      Navigator.of(context).pop();
                                    }
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 7.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: Color(0xBB128C7E),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Flexible(
                          child: StreamBuilder<DocumentSnapshot>(
                            stream: books.doc(widget.docId.id).snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return Text('Something went wrong');
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Text("Loading");
                              }

                              return Text(
                                snapshot.data['course_name'],
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.only(
                        right: 10.0,
                        left: 10.0,
                      ),
                      icon: Icon(Icons.edit),
                      color: Colors.white,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            final _formKey = GlobalKey<FormState>();

                            TextEditingController myController =
                                TextEditingController();

                            return AlertDialog(
                              title: Row(
                                children: [
                                  Icon(
                                    Icons.edit,
                                    color: Colors.red[700],
                                    size: 25.0,
                                  ),
                                  Text('  Edit Course Name')
                                ],
                              ),
                              content: Form(
                                key: _formKey,
                                child: TextFormField(
                                  autofocus: true,
                                  cursorColor: Colors.black,
                                  controller: myController,
                                  textAlign: TextAlign.center,
                                  validator: (input) => (input.trim().length ==
                                              0 ||
                                          input.trim().length > 40)
                                      ? 'Name should be less than or equal to 40 characters'
                                      : null,
                                ),
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                        fontSize: 18.0, color: Colors.black54),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                FlatButton(
                                  child: Text(
                                    'Done',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      _formKey.currentState.save();

                                      crudMethods.updateCourseName(
                                          widget.docId.id, myController.text);
                                      Navigator.of(context).pop();
                                    }
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                padding: EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 5.0, bottom: 5.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xBB128C7E), width: 2.0),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Text(
                  widget.docId['year'],
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height / 6,
                ),
                child: ListView.builder(
                  itemCount: widget.docId['branch'].length,
                  itemBuilder: (context, i) {
                    return Container(
                      margin:
                          EdgeInsets.only(left: 20.0, right: 20.0, top: 7.0),
                      padding: EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 5.0, bottom: 5.0),
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Color(0xBB128C7E), width: 2.0),
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Text(
                        widget.docId['branch'][i].toString(),
                        style: TextStyle(fontSize: 16.0),
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),
              ),
              Center(
                child: RoundedButton(
                  color: Colors.red[700],
                  txt: 'Delete',
                  onpressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Row(
                            children: [
                              Icon(
                                Icons.delete_rounded,
                                color: Colors.red[700],
                                size: 40.0,
                              ),
                              Text(' Are you sure ?')
                            ],
                          ),
                          content:
                              Text('This record will be permanently deleted'),
                          actions: <Widget>[
                            FlatButton(
                              child: Text(
                                'No',
                                style: TextStyle(
                                  fontSize: 20.0,
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            FlatButton(
                              child: Text(
                                'Yes',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.red[700],
                                ),
                              ),
                              onPressed: () {
                                deleteBook();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
