import 'package:book_share/components/rounded_button.dart';
import 'package:book_share/screens/login_screen.dart';
import 'package:book_share/services/auth.dart';
import 'package:book_share/services/crud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookPageView extends StatefulWidget {
  static const String id = 'book_page_view';
  final DocumentSnapshot docId;
  BookPageView({@required this.docId});

  @override
  _BookPageViewState createState() => _BookPageViewState();
}

class _BookPageViewState extends State<BookPageView> {
  AuthMethods authMethods = new AuthMethods();
  CRUDMethods crudMethods = new CRUDMethods();
  CollectionReference books = FirebaseFirestore.instance.collection('books');

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
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20.0, bottom: 12.0),
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
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height / 2.5,
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
                          height: MediaQuery.of(context).size.height / 3.5,
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1),
                            shape: BoxShape.rectangle,
                            color: Colors.grey[300],
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(snapshot.data['book_img']),
                            ),
                          ),
                        ),
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
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 14.0),
                child: Flexible(
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
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 7.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: Color(0xBB128C7E),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 14.0),
                child: Flexible(
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
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 7.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: Color(0xBB128C7E),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 14.0),
                child: Flexible(
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
                    margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 7.0),
                    padding: EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 5.0, bottom: 5.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xBB128C7E), width: 2.0),
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
                color: Colors.blueAccent,
                txt: 'Contact Seller',
                onpressed: () {
                  Navigator.pop(context, true);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
