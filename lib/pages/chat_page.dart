import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spy_chat/models/message.dart';
import 'package:spy_chat/services/auth_service.dart';
import 'package:spy_chat/services/chat_service.dart';
import 'package:spy_chat/services/socket_service.dart';
import 'package:spy_chat/widget/chat_message.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;
  List<ChatMessage> _messages = [];

  bool _isTyping = false;

  @override
  void initState() {
    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);
    _loadHistory(chatService.userToSend!.uid);
    socketService.socket!.on('personal-message', _listenMessage);
    super.initState();
  }

  void _loadHistory(String? uid) async {
    List<Message>? chat = await chatService.getChat(uid!);
    List<ChatMessage> historyChat = [];
    for (var m in chat!) {
      if (m.from == uid || m.from == authService.user!.uid) {
        historyChat.add(
            ChatMessage(
                text: m.message!,
                uid: m.from!,
                animationController: AnimationController(
                    vsync: this, duration: const Duration(milliseconds: 2))
                  ..forward()));
      }
    }
    List<ChatMessage> finalList = historyChat;

    setState(() {
      _messages.insertAll(0, finalList);
    });
  }

  void _listenMessage(dynamic message) {
    ChatMessage newMessage = ChatMessage(
        text: message['message'],
        uid: message['from'],
        animationController: AnimationController(
            vsync: this, duration: const Duration(milliseconds: 200)));
    setState(() {
      _messages.insert(0, newMessage);
    });
    newMessage.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final user = chatService.userToSend;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 1,
          title: Column(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue[200],
                maxRadius: 14,
                child: Text(
                  user!.name!.substring(0, 2),
                  style: const TextStyle(fontSize: 12, color: Colors.blue),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                user.name!,
                style: const TextStyle(color: Colors.black87, fontSize: 12),
              )
            ],
          ),
        ),
        body: Column(
          children: [
            Flexible(
                child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (_, index) => _messages[index],
              physics: const BouncingScrollPhysics(),
              reverse: true,
            )),
            const Divider(
              height: 1,
            ),
            Container(
              color: Colors.white,
              height: 50,
              child: _inputChat(),
            ),
          ],
        ));
  }

  Widget _inputChat() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit,
                onChanged: (text) {
                  setState(() {
                    if (text.isNotEmpty) {
                      _isTyping = true;
                    } else {
                      _isTyping = false;
                    }
                  });
                },
                decoration: const InputDecoration.collapsed(
                  hintText: 'Send message',
                ),
                focusNode: _focusNode,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Platform.isIOS
                  ? CupertinoButton(child: Text('Send'), onPressed: () {})
                  : Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      child: IconTheme(
                        data: IconThemeData(color: Colors.blue[400]),
                        child: IconButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          icon: const Icon(
                            Icons.send,
                          ),
                          onPressed: _isTyping
                              ? () => _handleSubmit(_textController.text)
                              : null,
                        ),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }

  _handleSubmit(String text) {
    if (text.isEmpty) return;
    _textController.clear();
    _focusNode.requestFocus();

    final newMessage = ChatMessage(
      text: text,
      uid: authService.user!.uid!,
      animationController: AnimationController(
          vsync: this, duration: const Duration(milliseconds: 200)),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();
    setState(() {
      _isTyping = false;
    });
    socketService.emit('personal-message', {
      'from': authService.user!.uid,
      'to': chatService.userToSend!.uid,
      'message': text
    });
  }

  @override
  void dispose() {
    // TODO: Off socket
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    chatService.userToSend = null;
    socketService.socket!.off('personal-message');
    super.dispose();
  }
}
