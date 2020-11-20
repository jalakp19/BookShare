import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CRUDMethods {
  String defaultImage =
      'https://cdn.icon-icons.com/icons2/1378/PNG/512/avatardefault_92824.png';

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference books = FirebaseFirestore.instance.collection('books');

  getProfilePic(String email) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return Flexible(
      child: StreamBuilder<QuerySnapshot>(
        stream: users.where('email', isEqualTo: email).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Container(
              width: MediaQuery.of(context).size.width / 2.5,
              height: MediaQuery.of(context).size.width / 2.5,
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 5),
                shape: BoxShape.circle,
                color: Colors.white,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(defaultImage),
                ),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              width: MediaQuery.of(context).size.width / 2.5,
              height: MediaQuery.of(context).size.width / 2.5,
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 5),
                shape: BoxShape.circle,
                color: Colors.white,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(defaultImage),
                ),
              ),
            );
          }

          return Container(
            width: MediaQuery.of(context).size.width / 2.5,
            height: MediaQuery.of(context).size.width / 2.5,
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 5),
              shape: BoxShape.circle,
              color: Colors.white,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(snapshot.data.docs.first['profile_pic']),
              ),
            ),
          );
        },
      ),
    );
  }

  getUserNameWid(String email) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return Flexible(
      child: StreamBuilder<QuerySnapshot>(
        stream: users.where('email', isEqualTo: email).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return Text(
            snapshot.data.docs.first['username'],
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }

  getRegNoWid(String email) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return Flexible(
      child: StreamBuilder<QuerySnapshot>(
        stream: users.where('email', isEqualTo: email).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return Text(
            snapshot.data.docs.first['regno'],
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }

  Future<void> addUser(String username, String email) {
    return users
        .add({
          'username': username,
          'email': email,
          'profile_pic': defaultImage,
          'regno': 'xxxxxxxxx',
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> addBooks(
      {String username,
      String email,
      String bookimg,
      String bookname,
      String authorsname,
      String coursename,
      String year,
      List<dynamic> branch}) {
    return books
        .add({
          'username': username,
          'email': email,
          'book_img': bookimg,
          'book_name': bookname,
          'author_name': authorsname,
          'course_name': coursename,
          'year': year,
          'branch': branch,
          'time': FieldValue.serverTimestamp(),
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> updateUserName(String docId, String val) async {
    return users
        .doc(docId)
        .update({'username': val})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> updateRegNo(String docId, String val) async {
    return users
        .doc(docId)
        .update({'regno': val})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> updateProfilePic(String docId, String val) async {
    return users
        .doc(docId)
        .update({'profile_pic': val})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> updateBookImg(String docId, String val) async {
    return books
        .doc(docId)
        .update({'book_img': val})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> updateBookName(String docId, String val) async {
    return books
        .doc(docId)
        .update({'book_name': val})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> updateAuthorName(String docId, String val) async {
    return books
        .doc(docId)
        .update({'author_name': val})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> updateCourseName(String docId, String val) async {
    return books
        .doc(docId)
        .update({'course_name': val})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> deleteBook(String docId) {
    print(docId);
    return books
        .doc(docId)
        .delete()
        .then((value) => print("Book Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
  }

  getDocId(String email) async {
    return await users.where('email', isEqualTo: email).get();
  }

  Future<void> deleteMessage(String chatId, String docId) {
    CollectionReference msg = FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatId)
        .collection('messages');

    return msg
        .doc(docId)
        .delete()
        .then((value) => print("User Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
  }
}
