import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:book_share/screens/receiver_profile.dart';
import 'package:book_share/services/auth.dart';
import 'package:book_share/services/crud.dart';
import 'package:intl/intl.dart';

class ChatRoom extends StatefulWidget {
  final String docId;
  final String senderEmail;
  final String receiverEmail;
  ChatRoom({this.docId, this.receiverEmail, this.senderEmail});

  static const String id = 'chat_room';

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods = new AuthMethods();
  CRUDMethods crudMethods = new CRUDMethods();
  final _firestore = FirebaseFirestore.instance;

  String receiverUserName = 'Loading...';
  String receiverDisplayPic =
      'https://cdn.icon-icons.com/icons2/1378/PNG/512/avatardefault_92824.png';
  String senderUserName = 'Loading...';
  String senderDisplayPic =
      'https://cdn.icon-icons.com/icons2/1378/PNG/512/avatardefault_92824.png';

  String message;
  TextEditingController messageTextController = new TextEditingController();

  @override
  void initState() {
    crudMethods.getDocId(widget.receiverEmail).then((val) {
      setState(() {
        receiverDisplayPic = val.docs.first['profile_pic'];
        receiverUserName = val.docs.first['username'];
      });
      crudMethods.getDocId(widget.senderEmail).then((val) {
        senderDisplayPic = val.docs.first['profile_pic'];
        senderUserName = val.docs.first['username'];
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          backgroundColor: Color(0xFF128C7E),
          centerTitle: false,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            splashRadius: 1.0,
            padding: EdgeInsets.only(top: 18.0),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          titleSpacing: 0.0,
          title: Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: GestureDetector(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => ReceiverProfile(
                //       email: widget.receiverEmail,
                //     ),
                //   ),
                // );
              },
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: 40.0,
                    height: 40.0,
                    // padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(receiverDisplayPic),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    receiverUserName,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.0,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("assets/images/background.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('chatrooms')
                  .doc(widget.docId)
                  .collection('messages')
                  .orderBy('time', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final messages = snapshot.data.docs.reversed;
                List<Widget> messageWidgets = [];
                for (var message in messages) {
                  String chatId = widget.docId;
                  String messageId = message.id;
                  String messageText = message.data()['text'];
                  String messageSender = message.data()['sender'];
                  final messageTime = message.data()['time'] as Timestamp;

                  final tempWidget = MessageBubble(
                    chatId: chatId,
                    docId: messageId,
                    text: messageText,
                    sender: messageSender,
                    isMe: (messageSender == widget.senderEmail),
                    time: DateFormat('kk:mm').format(messageTime == null
                        ? DateTime.now()
                        : messageTime.toDate()),
                  );
                  messageWidgets.add(tempWidget);
                }
                return Expanded(
                  child: ListView(
                    reverse: true,
                    children: messageWidgets,
                  ),
                );
              },
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 0.0),
              margin: EdgeInsets.only(
                  top: 10.0, right: 10.0, left: 10.0, bottom: 10.0),
              decoration: BoxDecoration(
                borderRadius: new BorderRadius.all(new Radius.circular(30.0)),
                color: Colors.white,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      cursorColor: Colors.black54,
                      controller: messageTextController,
                      onChanged: (value) {
                        message = value;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 20.0),
                        hintText: 'Type your message here...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: IconButton(
                      color: Color(0xFF128C7E),
                      icon: FaIcon(FontAwesomeIcons.solidPaperPlane),
                      onPressed: () {
                        messageTextController.clear();
                        if (message != '' && message != null) {
                          _firestore
                              .collection('chatrooms')
                              .doc(widget.docId)
                              .set({
                            'usera': widget.senderEmail,
                            'usera_username': senderUserName,
                            'usera_dp': senderDisplayPic,
                            'userb': widget.receiverEmail,
                            'userb_username': receiverUserName,
                            'userb_dp': receiverDisplayPic,
                            'time': FieldValue.serverTimestamp(),
                          });
                          _firestore
                              .collection('chatrooms')
                              .doc(widget.docId)
                              .collection('messages')
                              .add({
                            'text': message,
                            'sender': widget.senderEmail,
                            'time': FieldValue.serverTimestamp(),
                          });
                          message = '';
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatefulWidget {
  final String chatId;
  final String docId;
  final String text;
  final String sender;
  final bool isMe;
  final String time;

  MessageBubble(
      {this.chatId, this.docId, this.text, this.sender, this.isMe, this.time});

  @override
  _MessageBubbleState createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
      child: Column(
        crossAxisAlignment:
            widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 2.0,
          ),
          GestureDetector(
            onLongPress: () {
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
                      content: Text('Do you want to delete this message ?'),
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
                            CRUDMethods crudMethods = new CRUDMethods();
                            crudMethods.deleteMessage(
                                widget.chatId, widget.docId);
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  });
            },
            child: Material(
              elevation: 5.0,
              borderRadius: widget.isMe
                  ? BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0))
                  : BorderRadius.only(
                      topRight: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0)),
              color: widget.isMe ? Color(0xFFDCF8C7) : Color(0xFFFFFEFF),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        widget.text,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${widget.time}',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 12.0,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
