import 'package:book_share/screens/chat_room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyChats extends StatefulWidget {
  @override
  _MyChatsState createState() => _MyChatsState();
}

class _MyChatsState extends State<MyChats> {
  CollectionReference chatRooms =
      FirebaseFirestore.instance.collection('chatrooms');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F7F7),
      body: Column(
        children: [
          SizedBox(
            height: 5.0,
          ),
          Container(
            child: Flexible(
              child: StreamBuilder<QuerySnapshot>(
                stream: chatRooms.orderBy('time', descending: true).snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> mainsnapshot) {
                  if (mainsnapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (mainsnapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  bool flag = false;
                  for (int i = 0; i < mainsnapshot.data.size; i++) {
                    if ((FirebaseAuth.instance.currentUser.email ==
                            mainsnapshot.data.docs[i]['usera']) ||
                        (FirebaseAuth.instance.currentUser.email ==
                            mainsnapshot.data.docs[i]['userb'])) {
                      flag = true;
                      break;
                    }
                  }

                  return flag
                      ? ListView.builder(
                          itemCount: mainsnapshot.data.size,
                          itemBuilder: (context, i) {
                            final messageTime =
                                mainsnapshot.data.docs[i]['time'] as Timestamp;
                            String time = 'Loading...';
                            time = DateFormat('dd/MM/yy : kk:mm')
                                .format(messageTime.toDate());

                            if ((FirebaseAuth.instance.currentUser.email ==
                                    mainsnapshot.data.docs[i]['usera']) ||
                                (FirebaseAuth.instance.currentUser.email ==
                                    mainsnapshot.data.docs[i]['userb'])) {
                              String receiverEmailId =
                                  FirebaseAuth.instance.currentUser.email ==
                                          mainsnapshot.data.docs[i]['usera']
                                      ? mainsnapshot.data.docs[i]['userb']
                                      : mainsnapshot.data.docs[i]['usera'];

                              String receiverUserName = FirebaseAuth
                                          .instance.currentUser.email ==
                                      mainsnapshot.data.docs[i]['usera']
                                  ? mainsnapshot.data.docs[i]['userb_username']
                                  : mainsnapshot.data.docs[i]['usera_username'];

                              String receiverDisplayPic =
                                  FirebaseAuth.instance.currentUser.email ==
                                          mainsnapshot.data.docs[i]['usera']
                                      ? mainsnapshot.data.docs[i]['userb_dp']
                                      : mainsnapshot.data.docs[i]['usera_dp'];

                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      String key = getChatRoomId(
                                          mainsnapshot.data.docs[i]['usera'],
                                          mainsnapshot.data.docs[i]['userb']);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChatRoom(
                                            docId: key,
                                            senderEmail: FirebaseAuth
                                                .instance.currentUser.email,
                                            receiverEmail: receiverEmailId,
                                          ),
                                        ),
                                      );
                                    },
                                    child: ListTile(
                                      leading: Container(
                                        width: 50.0,
                                        height: 50.0,
                                        padding: EdgeInsets.all(5.0),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                receiverDisplayPic),
                                          ),
                                        ),
                                      ),
                                      title: new Text(receiverUserName),
                                      subtitle: new Text(time),
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.black54,
                                    height: 0.0,
                                    indent: 50.0,
                                    endIndent: 50.0,
                                    thickness: 0.0,
                                  )
                                ],
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
                              'Sorry ,There are no active chats',
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
        ],
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
