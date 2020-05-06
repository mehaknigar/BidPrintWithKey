import 'dart:math';
import 'package:bidprint/bars/topbar.dart';
import 'package:bidprint/variables/colors.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'chat_screen.dart';

final Firestore _firestore = Firestore.instance;
String userEmail,userID, userType;

class ChatListPage extends StatefulWidget {
  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  myPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString("email");
    var user = prefs.getString("user");
    var id = prefs.getString("userID");
    setState(() {
      userEmail = email;
      userID = id;
      userType = user;
    });
  }

  @override
  void initState() {
    super.initState();
    myPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TopBar().getAppBar(
          Icon(Icons.exit_to_app, color: transparent), "Message List", null),
      body: MessageStream(),
    );
  }
}

class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('Users')
          .document(userEmail)
          .collection('chats')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final messages = snapshot.data.documents.reversed;
        List<SingleList> messageBubbles = [];
        for (var message in messages) {
          final chatId = message.data['chat_id'];
          final name = message.data['chat_with_name'];
          final email = message.data['chat_with'];
          final id = message.data['chat_with_id'];
          final userType = message.data['chat_with_user_type'];

          final messageBubble = SingleList(
            code: chatId,
            targetEmail: email,
            targetName: name,
            targetID: id,
            targetUserType: userType,
          );
          messageBubbles.add(messageBubble);
        }

        if (messageBubbles.length == 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('images/no_message.jpg'),
              Text(
                'No Messages Yet!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF91A5C3),
                  fontSize: 30.0,
                ),
              ),
            ],
          );
        }

        return ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 20.0,
          ),
          children: messageBubbles,
        );
      },
    );
  }
}

class SingleList extends StatefulWidget {
  final String code, targetName, targetEmail, targetID, targetUserType;

  SingleList({
    @required this.code,
    @required this.targetEmail,
    @required this.targetName,
    @required this.targetID,
    @required this.targetUserType,
  });

  @override
  _SingleListState createState() => _SingleListState();
}

class _SingleListState extends State<SingleList> {
  final TextEditingController message = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(userEmail);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              userEmail: userEmail,
              userID: userID,
              userType: userType,
              chatID: widget.code,
              targetEmail: widget.targetEmail,
              targetID: widget.targetID,
              targetUserType: widget.targetUserType,
            ),
          ),
        );
      },
      child: ListTile(
        leading: Icon(Icons.message),
        title: Text(widget.targetEmail),
        trailing: Icon(Icons.arrow_forward),
      ),
    );
  }
}

class DeleteDialog extends StatefulWidget {
  final String code;

  DeleteDialog(this.code);

  @override
  _DeleteDialogState createState() => _DeleteDialogState();
}

class _DeleteDialogState extends State<DeleteDialog> {
  double containerHeight = 0;

  void changeHeight() {
    setState(() {
      containerHeight = 16;
    });
    hideText();
  }

  void hideText() {
    Future.delayed(
      Duration(seconds: 1),
      () {
        setState(() {
          containerHeight = 0;
        });
      },
    );
  }

  int selectedRadio;

  setSelectedRadio(int value) {
    setState(() {
      selectedRadio = value;
    });
  }

  void deleteChat() {
    _firestore.collection('messages').document(widget.code).delete();
  }

  void deleteAllMessages() async {
    _firestore
        .collection('messages')
        .document(widget.code)
        .collection(widget.code)
        .getDocuments()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents) {
        ds.reference.delete();
      }
    });

    _firestore.collection('messages').document(widget.code).delete();
  }

  @override
  void initState() {
    super.initState();
    selectedRadio = 0;
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: <Widget>[
        Text(
          'Delete',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 20.0,
          ),
        ),
        ListTile(
          title: Text('Delete this chat from here only?'),
          leading: Radio(
            value: 1,
            groupValue: selectedRadio,
            activeColor: Theme.of(context).accentColor,
            onChanged: (value) {
              setSelectedRadio(value);
            },
          ),
        ),
        ListTile(
          title: Text('Delete this chat from everywhere?'),
          leading: Radio(
            value: 2,
            groupValue: selectedRadio,
            activeColor: Theme.of(context).accentColor,
            onChanged: (value) {
              setSelectedRadio(value);
            },
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20.0),
          child: RaisedButton(
            child: Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
            color: Color(0xFFCC3300),
            onPressed: () {
              switch (selectedRadio) {
                case 1:
                  deleteChat();
                  Navigator.pop(context);
                  break;
                case 2:
                  deleteAllMessages();
                  Navigator.pop(context);
                  break;
                default:
                  changeHeight();
              }
            },
          ),
        ),
        AnimatedContainer(
          margin: EdgeInsets.only(top: 10.0),
          duration: Duration(milliseconds: 100),
          height: containerHeight,
          child: Text(
            'Please select any option!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ),
      ],
    );
  }
}
