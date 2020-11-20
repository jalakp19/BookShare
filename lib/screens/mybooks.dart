import 'package:book_share/screens/book_page_edit.dart';
import 'package:book_share/screens/login_screen.dart';
import 'package:book_share/services/auth.dart';
import 'package:book_share/services/crud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyBooks extends StatefulWidget {
  static const String id = 'mybooks';

  @override
  _MyBooksState createState() => _MyBooksState();
}

class _MyBooksState extends State<MyBooks> {
  AuthMethods authMethods = new AuthMethods();
  CRUDMethods crudMethods = new CRUDMethods();
  CollectionReference books = FirebaseFirestore.instance.collection('books');

  bool flag = false;

  @override
  void initState() {
    super.initState();
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
                  Navigator.pop(context);
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
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: Container(
          // alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Text(
              'My Books',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 18.0),
            ),
          ),
          color: Color(0xFF128C7E),
        ),
        elevation: 0,
      ),
      body: Container(
        color: Colors.white54,
        child: Flexible(
          child: StreamBuilder<QuerySnapshot>(
            stream: books.orderBy('time', descending: true).snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  color: Colors.white,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              bool flag = false;
              for (int i = 0; i < snapshot.data.size; i++) {
                if (snapshot.data.docs[i]['email'] ==
                    FirebaseAuth.instance.currentUser.email) {
                  flag = true;
                  break;
                }
              }

              return flag
                  ? ListView.builder(
                      itemCount: snapshot.data.size,
                      itemBuilder: (context, index) {
                        if (snapshot.data.docs[index]['email'] ==
                            FirebaseAuth.instance.currentUser.email) {
                          return Card(
                            margin: EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 5.0),
                            elevation: 5,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BookPageEdit(
                                        docId: snapshot.data.docs[index]),
                                  ),
                                ).then((value) {
                                  if (true) {
                                    Future.delayed(Duration(milliseconds: 300),
                                        () {
                                      // 300 ms over, navigate to a new page
                                      if (value == true) {
                                        print("HHHHHHEEEELLOOOOOOOOOOOOO");
                                        crudMethods.deleteBook(
                                            snapshot.data.docs[index].id);
                                      }
                                    });
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
                                        padding:
                                            EdgeInsets.fromLTRB(10, 5, 0, 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  3, 0, 0, 1),
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
                                              padding: EdgeInsets.fromLTRB(
                                                  3, 0, 0, 1),
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
                                              padding: EdgeInsets.fromLTRB(
                                                  3, 0, 0, 1),
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
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 3, 0, 3),
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
                                                            Radius.circular(
                                                                10))),
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
                          'Sorry ,You donot have any books',
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }
}

// books.length != 0
// ? ListView.builder(
// itemCount: books.length,
// itemBuilder: (context, index) {
// return Card(
// margin:
// EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
// elevation: 5,
// child: GestureDetector(
// onTap: () {
// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (context) => BookPage(docId: books[index]),
// ),
// ).then((value) {
// if (true) {
// setState(() {
// String docId = books[index].id;
// books.clear();
// if (value == true) {
// print("HHHHHHEEEELLOOOOOOOOOOOOO");
// crudMethods.deleteBook(docId);
// }
// crudMethods
//     .getBooks(
// FirebaseAuth.instance.currentUser.email)
//     .then((val) {
// setState(() {
// val.docs.forEach((doc) {
// if (doc['email'] ==
// FirebaseAuth
//     .instance.currentUser.email) {
// books.add(doc);
// }
// });
// if (books.length == 0) {
// flag = true;
// }
// });
// });
// });
// }
// });
// },
// child: Container(
// margin: EdgeInsets.symmetric(
// vertical: 5.0, horizontal: 5.0),
// height: 150.0,
// child: Row(
// children: <Widget>[
// Container(
// height: 140.0,
// width: 100.0,
// decoration: BoxDecoration(
// borderRadius: BorderRadius.only(
// bottomLeft: Radius.circular(5),
// topLeft: Radius.circular(5)),
// image: DecorationImage(
// fit: BoxFit.cover,
// image: NetworkImage(books[index]['book_img']),
// ),
// ),
// ),
// Container(
// height: 150,
// child: Padding(
// padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// mainAxisAlignment: MainAxisAlignment.start,
// children: <Widget>[
// Padding(
// padding: EdgeInsets.fromLTRB(3, 0, 0, 1),
// child: Container(
// width:
// MediaQuery.of(context).size.width /
// 1.6,
// padding: EdgeInsets.only(left: 2.0),
// child: Text(
// books[index]['book_name'],
// style: TextStyle(
// fontSize: 16.0,
// fontWeight: FontWeight.w500,
// ),
// ),
// ),
// ),
// Padding(
// padding: EdgeInsets.fromLTRB(3, 0, 0, 1),
// child: Container(
// width:
// MediaQuery.of(context).size.width /
// 1.6,
// padding: EdgeInsets.only(left: 2.0),
// child: Text(
// books[index]['author_name'],
// style: TextStyle(
// fontSize: 16.0,
// fontWeight: FontWeight.w400,
// ),
// ),
// ),
// ),
// Padding(
// padding: EdgeInsets.fromLTRB(3, 0, 0, 1),
// child: Container(
// width:
// MediaQuery.of(context).size.width /
// 1.6,
// padding: EdgeInsets.only(left: 2.0),
// child: Text(
// books[index]['course_name'],
// style: TextStyle(
// fontSize: 16.0,
// fontWeight: FontWeight.w400,
// ),
// ),
// ),
// ),
// Padding(
// padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
// child: Container(
// padding: EdgeInsets.only(
// left: 5.0,
// right: 5.0,
// top: 2.0,
// bottom: 2.0),
// decoration: BoxDecoration(
// border:
// Border.all(color: Colors.teal),
// borderRadius: BorderRadius.all(
// Radius.circular(10))),
// child: Text(
// books[index]['year'],
// ),
// ),
// ),
// ],
// ),
// ),
// )
// ],
// ),
// ),
// ),
// );
// },
// )
// : flag == true
// ? Container(
// color: Colors.white,
// child: Center(
// child: Text(
// 'Sorry ,You donot have any books',
// style: TextStyle(
// fontSize: 15.0,
// color: Colors.black54,
// ),
// ),
// ),
// )
// : Container(
// color: Colors.white,
// child: Center(
// child: CircularProgressIndicator(),
// ),
// ),
