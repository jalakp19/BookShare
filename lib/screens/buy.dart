import 'package:book_share/screens/book_page_view.dart';
import 'package:book_share/screens/chat_room.dart';
import 'package:book_share/screens/home_screen.dart';
import 'package:book_share/services/auth.dart';
import 'package:book_share/services/crud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BuyBooks extends StatefulWidget {
  @override
  _BuyBooksState createState() => _BuyBooksState();
}

class _BuyBooksState extends State<BuyBooks> {
  AuthMethods authMethods = new AuthMethods();
  CRUDMethods crudMethods = new CRUDMethods();
  CollectionReference books = FirebaseFirestore.instance.collection('books');
  TextEditingController myController = new TextEditingController();
  Widget bookList;

  updateScreen(String val) {
    setState(() {
      bookList = Flexible(
        child: StreamBuilder<QuerySnapshot>(
          stream: books.orderBy('book_name').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              if (myController.text == null || myController.text == '') {
                return Container(
                  color: Colors.white,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            }

            bool flag = false;
            var mainflag = new List(snapshot.data.size);

            if (myController.text == null || myController.text == '') {
              for (int i = 0; i < snapshot.data.size; i++) {
                mainflag[i] = true;
              }
            } else {
              for (int i = 0; i < snapshot.data.size; i++) {
                mainflag[i] = false;
              }
              for (int i = 0; i < snapshot.data.size; i++) {
                if (snapshot.data.docs[i]['book_name'].toString().contains(
                    RegExp(myController.text, caseSensitive: false))) {
                  mainflag[i] = true;
                }
                if (snapshot.data.docs[i]['author_name'].toString().contains(
                    RegExp(myController.text, caseSensitive: false))) {
                  mainflag[i] = true;
                }
                if (snapshot.data.docs[i]['course_name'].toString().contains(
                    RegExp(myController.text, caseSensitive: false))) {
                  mainflag[i] = true;
                }
                if (snapshot.data.docs[i]['year'].toString().contains(
                    RegExp(myController.text, caseSensitive: false))) {
                  mainflag[i] = true;
                }

                for (int j = 0;
                    j < snapshot.data.docs[i]['branch'].length;
                    j++) {
                  if (snapshot.data.docs[i]['branch'][j].toString().contains(
                      RegExp(myController.text, caseSensitive: false))) {
                    mainflag[i] = true;
                  }
                }
              }
            }

            for (int i = 0; i < snapshot.data.size; i++) {
              if (snapshot.data.docs[i]['email'] !=
                      FirebaseAuth.instance.currentUser.email &&
                  mainflag[i]) {
                flag = true;
                break;
              }
            }

            return flag
                ? ListView.builder(
                    itemCount: snapshot.data.size,
                    itemBuilder: (context, index) {
                      if (snapshot.data.docs[index]['email'] !=
                              FirebaseAuth.instance.currentUser.email &&
                          mainflag[index]) {
                        return Card(
                          margin: EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 5.0),
                          elevation: 5,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookPageView(
                                      docId: snapshot.data.docs[index]),
                                ),
                              ).then((value) {
                                if (value) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomeScreen(),
                                    ),
                                  );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatRoom(
                                        docId: getChatRoomId(
                                            FirebaseAuth
                                                .instance.currentUser.email,
                                            snapshot.data.docs[index]['email']),
                                        senderEmail: FirebaseAuth
                                            .instance.currentUser.email,
                                        receiverEmail: snapshot.data.docs[index]
                                            ['email'],
                                      ),
                                    ),
                                  );
                                }
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 5.0),
                              height: 150.0,
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    height: 140.0,
                                    width: 100.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(5),
                                          topLeft: Radius.circular(5)),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(snapshot
                                            .data.docs[index]['book_img']),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 150,
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding:
                                                EdgeInsets.fromLTRB(3, 0, 0, 1),
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.6,
                                              padding:
                                                  EdgeInsets.only(left: 2.0),
                                              child: Text(
                                                snapshot.data.docs[index]
                                                    ['book_name'],
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsets.fromLTRB(3, 0, 0, 1),
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.6,
                                              padding:
                                                  EdgeInsets.only(left: 2.0),
                                              child: Text(
                                                snapshot.data.docs[index]
                                                    ['author_name'],
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsets.fromLTRB(3, 0, 0, 1),
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.6,
                                              padding:
                                                  EdgeInsets.only(left: 2.0),
                                              child: Text(
                                                snapshot.data.docs[index]
                                                    ['course_name'],
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsets.fromLTRB(0, 3, 0, 3),
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                  left: 5.0,
                                                  right: 5.0,
                                                  top: 2.0,
                                                  bottom: 2.0),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.teal),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                              child: Text(
                                                snapshot.data.docs[index]
                                                    ['year'],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        return SizedBox(
                          height: 0.0,
                        );
                      }
                    },
                  )
                : Container(
                    color: Colors.white,
                    child: Center(
                      child: Text(
                        'Sorry ,There are no books to display',
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  );
          },
        ),
      );
    });
  }

  @override
  void initState() {
    updateScreen('');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F7F7),
      body: Container(
        color: Colors.white54,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Flexible(
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: myController,
                        cursorColor: Colors.black,
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                            hintText: 'Search your book...',
                            hintStyle: TextStyle(
                              fontSize: 16.0,
                            ),
                            contentPadding: EdgeInsets.only(
                                left: 25.0,
                                top: 20.0,
                                bottom: 10.0,
                                right: 15.0)),
                        onChanged: (val) {
                          updateScreen(myController.text);
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.info_outline,
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('You can search by:'),
                                content: Text(
                                    'Book name\nAuthor\'s name\nCourse name\nYear/Semester\nBranch'),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text(
                                      'Done',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            });
                      },
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: bookList,
            ),
          ],
        ),
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.compareTo(b) == 1) {
    return "$a\_$b";
  } else {
    return "$b\_$a";
  }
}
