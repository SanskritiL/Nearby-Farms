import 'package:earth_hack/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogflow_v2/flutter_dialogflow.dart';

void main() => runApp(new Chat());

class Chat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new ChatDialogflow(),
    );
  }
}

class ChatDialogflow extends StatefulWidget {
  ChatDialogflow({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ChatDialogflow createState() => new _ChatDialogflow();
}

class _ChatDialogflow extends State<ChatDialogflow> {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController();

  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration:
                    new InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                  icon: new Icon(Icons.send),
                  color: primaryColor,
                  onPressed: () => _handleSubmitted(_textController.text)),
            ),
          ],
        ),
      ),
    );
  }

  void response(query) async {
    _textController.clear();

    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "config/credentials.json").build();
    Dialogflow dialogflow =
        Dialogflow(authGoogle: authGoogle, language: Language.english);
    print("working");
    AIResponse response = await dialogflow.detectIntentFromText(query);
    print("worked");

    ChatMessage message = new ChatMessage(
      text: response.getMessage() ??
          new CardDialogflow(response.getListMessage()[0]).title,
      name: "Nearby Farms",
      type: false,
    );
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    ChatMessage message = new ChatMessage(
      text: text,
      name: "Sans",
      type: true,
    );
    setState(() {
      _messages.insert(0, message);
    });
    response(text);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Column(children: <Widget>[
        new Flexible(
            child: new ListView.builder(
          padding: new EdgeInsets.all(8.0),
          reverse: true,
          itemBuilder: (_, int index) => _messages[index],
          itemCount: _messages.length,
        )),
        new Divider(height: 1.0),
        new Container(
          decoration: new BoxDecoration(color: Theme.of(context).cardColor),
          child: _buildTextComposer(),
        ),
      ]),
    );
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.name, this.type});

  final String text;
  final String name;
  final bool type;

  List<Widget> otherMessage(context) {
    return <Widget>[
      new Container(
        margin: const EdgeInsets.only(right: 16.0),
        child: new CircleAvatar(
          child: new Text('B',
              style: new TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold)),
          backgroundColor: primaryColor,
        ),
      ),
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(this.name,
                style: new TextStyle(fontWeight: FontWeight.bold)),
            new Container(
              padding: const EdgeInsets.all(5.0),
              margin: const EdgeInsets.only(top: 5.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey[200],
                ),
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.grey[200],
              ),
              child: new Text(text),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> myMessage(context) {
    return <Widget>[
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            new Text(this.name, style: TextStyle(fontWeight: FontWeight.bold)),
            new Container(
              padding: const EdgeInsets.all(5.0),
              margin: const EdgeInsets.only(top: 5.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey[200],
                ),
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.grey[200],
              ),
              child: new Text(text),
            ),
          ],
        ),
      ),
      new Container(
        margin: const EdgeInsets.only(left: 16.0),
        child: new CircleAvatar(
            backgroundColor: primaryColor,
            child: new Text(
              this.name[0],
              style: new TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black),
            )),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: this.type ? myMessage(context) : otherMessage(context),
      ),
    );
  }
}
