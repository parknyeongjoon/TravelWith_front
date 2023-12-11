import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripmating/service/utils/dio_service.dart';


import '/Controller/messageProvider/messageProviders.dart';
import '/model/messages/MessagePreview.dart';
import '/model/messages/Message.dart';

import '/model/messages/MessageWrite.dart';


class Chat extends ConsumerStatefulWidget {
  const Chat({super.key});

  @override
  ConsumerState<Chat> createState() => _ChatState();
}

class _ChatState extends ConsumerState<Chat> {
  @override
  void initState() {
    super.initState();
    ref.read(messageProvider.notifier).getMessageList();

  }

  @override
  Widget build(BuildContext context) {
    final messageList = ref.watch(messageProvider);
    return SafeArea(
      child: ListView.builder(

        itemCount: messageList.length,
        padding: EdgeInsets.only(top: 8),
        itemBuilder: (context, index) {
          MessagePreview data = messageList[index];
          print(data);
          return SizedBox(
            height: 85,
            child: TextButton(
              onPressed: () {
                context.go('/chat/chatroom', extra: data);
              },
              style: TextButton.styleFrom(
                primary: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Color(0xFFF8BBD0),
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(data.memberInfoDTO.profileImg),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.memberInfoDTO.name,
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                            fontSize: 16.5,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          data.contents,
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color : Color(0xFF757575),
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                   Text(
                    data.recentDate.toString().substring(0,10),
                    style: TextStyle(
                      color : Color(0xFF757575),
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ChatRoom extends ConsumerStatefulWidget {
  final MessagePreview data;

  ChatRoom({required this.data});

  @override
  ConsumerState<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends ConsumerState<ChatRoom> {

  List<ChatMessage> messages = <ChatMessage>[
  ];
  
  @override
  void initState() {
    super.initState();

    ChatUser userMe = ChatUser(
      id: DioServices.getEmail(),
      firstName: '나',
    );

    ChatUser userYou = ChatUser(
      id: widget.data.memberInfoDTO.email,
      firstName: widget.data.memberInfoDTO.name,
    );
    ref.read(messageDetailProvider.notifier).getMessageDetail(widget.data.memberInfoDTO.email, userMe, userYou);
    ref.read(messageProvider.notifier).getMessageList();

  }

  @override
  Widget build(BuildContext context) {
    final messageDetail = ref.watch(messageDetailProvider);
    ChatUser userMe = ChatUser(
      id: 'abc1234@test1.com',
      firstName: '나',
    );

    ChatUser userYou = ChatUser(
      id: widget.data.memberInfoDTO.email,
      firstName: widget.data.memberInfoDTO.name,
    );


    return Scaffold(
      appBar: PreferredSize(preferredSize: const Size.fromHeight(50), child: AppBar(

      ),),
      body: SafeArea(
        child:
        DashChat(
          currentUser: userMe,
          onSend: (ChatMessage m) {
            messageSend(MessageWrite(
              contents: m.text,
              title: '',
              receiverEmail: widget.data.memberInfoDTO.email,
            ));
            ref.read(messageDetailProvider.notifier).getMessageDetail(widget.data.memberInfoDTO.email, userMe, userYou);
          },
          messages: messageDetail,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(messageDetailProvider.notifier).getMessageDetail(widget.data.memberInfoDTO.email, userMe, userYou);
        },
        child: Icon(Icons.refresh),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }
}


