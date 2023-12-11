import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tripmating/model/matchinginfo/Assessment.dart';

import '../../Controller/myPageProvider/myPageProvider.dart';
import '/Controller/messageProvider/messageProviders.dart';
import '/model/messages/MessagePreview.dart';
import '/model/messages/Message.dart';

import '/model/messages/MessageWrite.dart';

class Mypage extends ConsumerStatefulWidget {
  const Mypage({Key? key}) : super(key: key);

  @override
  ConsumerState<Mypage> createState() => _MypageState();


}


class _MypageState extends ConsumerState<Mypage> {

  @override
  void initState() {
    super.initState();
    var memberInfoDTO = ref.read(myPageProvider).memberInfoDTO;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        children:  [
          const InfoPanel(),
          const SizedBox(height: 20),
          const AssessmentPanel(),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: () {
                context.go("/login");
              },
              child: const Text("Log out")
          )
        ],
      ),
    );
  }
}

class InfoPanel extends ConsumerStatefulWidget {
  const InfoPanel({super.key});

  @override
  _InfoPanelState createState() => _InfoPanelState();

}

class _InfoPanelState extends ConsumerState<InfoPanel> {
  @override
  void initState() {
    super.initState();
    ref.read(myPageProvider.notifier).getMyPageDetail();
    print("222222222");
  }

  @override
  Widget build(BuildContext context) {
    Widget avatar = RandomAvatar(
      "000000000000",
      width: 150,
      height: 150,
    );

    var memberInfoDTO =  ref.watch(myPageProvider).memberInfoDTO;
    print(memberInfoDTO);

    Widget genderIcon = setGenderIcon(memberInfoDTO!.gender!);

    return Column(
      children: [
        Container(
          color: Color(0xFFF8F8F8),
          child: Center(
            child: Container(
              width: 385,
              margin: const EdgeInsets.only(top: 15.0, bottom: 20.0),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      avatar,
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(memberInfoDTO!.name!, style: TextStyle(
                            fontSize: 27,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w400,
                          )
                          ),
                          genderIcon,
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(width: 40),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /* const Row(
                          children: [
                            Icon(Icons.star, size: 18),
                            SizedBox(width: 10),
                            Text("4.5/5", style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w300,
                            )
                            ),
                          ],
                        ),*/
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.phone, size: 18),
                            SizedBox(width: 10),
                            Text(memberInfoDTO.phoneNumber, style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w300,
                            )
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.cake, size: 18),
                            const SizedBox(width: 10),
                            Text(DateFormat('yyyy-MM-dd').format(memberInfoDTO.birthDate), style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w300,
                            )
                            ),
                            const SizedBox(width: 15)
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.star, size: 18),
                            const SizedBox(width: 10),
                            Text("reviews: 4.7/5", style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w300,
                            )
                            ),
                            const SizedBox(width: 15)
                          ],
                        ),
                      ],
                    ),
                  ),


                ],
              ),
            ),
          ),
        ),

      ],
    );
  }

  Widget setGenderIcon(String gender) {
    switch (gender) {
      case "MALE":
        return const Icon(Icons.male, size: 24, color: Colors.blue);
      case "FEMALE":
        return const Icon(Icons.female, size: 24, color: Colors.red);
      default:
        return const SizedBox();
    }
  }
}

class AssessmentPanel extends ConsumerStatefulWidget {
  const AssessmentPanel({super.key});
  @override
  ConsumerState<AssessmentPanel> createState() => _AssessmentPanelState();
}

class _AssessmentPanelState extends ConsumerState<AssessmentPanel> {
  final pageController = PageController();
  @override
  void initState() {
    super.initState();
    ref.read(myPageProvider.notifier).getMyPageDetail();
    print("222222222");
  }

  @override
  Widget build(BuildContext context) {
    var memberInfoDTO =  ref.watch(myPageProvider);
    return Container(
      color: Color(0xFFF8F8F8),
      child: Column(
        children: [
          const Text("MyIntroduce", style: TextStyle(
            fontSize: 30,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w300,

          ), textAlign: TextAlign.center),
          const SizedBox(height: 15),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.transparent,
              onSurface: Colors.transparent,
              shadowColor: Colors.transparent,
              elevation: 0,
            ),
            onPressed: () {
              context.go("/mypage/assessment");
            },
            child: Column(
              children: [
                Container(
                  width: 330,
                  height: 154,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(memberInfoDTO.myIntroduceTitle, style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                    ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                    width: 330,
                    height: 154,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: PageView(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text("파티장: 최민준", style: TextStyle(color: Colors.black)),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:[
                                      Text("i want to travel Tokyo", style: TextStyle(color: Colors.black, fontSize: 25)),
                                      Icon(Icons.arrow_circle_right, color: Colors.black,),
                                    ]
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text("2023-12-19 ~ 2023-12-29", style: TextStyle(color: Colors.black),),
                                    Text("총 인원: 5", style: TextStyle(color: Colors.black),),
                                  ],
                                ),
                              ]
                          ),

                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text("파티장: 이주형형", style: TextStyle(color: Colors.black)),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:[
                                      Text("오꼬노미야끼", style: TextStyle(color: Colors.black, fontSize: 25)),
                                      Icon(Icons.arrow_circle_right, color: Colors.black,),
                                    ]
                                ),
                                SizedBox(height: 1),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text("2023-12-11 ~ 2023-12-25", style: TextStyle(color: Colors.black),),
                                    Text("총 인원: 5", style: TextStyle(color: Colors.black),),
                                  ],
                                ),
                              ]
                          ),

                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text("파티장: 최민준", style: TextStyle(color: Colors.black)),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:[
                                      Text("닭강정먹으로", style: TextStyle(color: Colors.black, fontSize: 25)),
                                      Icon(Icons.arrow_circle_right, color: Colors.black,),
                                    ]
                                ),
                                SizedBox(height: 1),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text("2023-12-11 ~ 2023-12-11", style: TextStyle(color: Colors.black),),
                                    Text("총 인원 n", style: TextStyle(color: Colors.black),),
                                  ],
                                ),
                              ]
                          ),

                        ),
                      ],
                    )
                )
                // Container(
                //   width: 330,
                //   height: 154,
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(30),
                //     color: Colors.white,
                //     boxShadow: [
                //       BoxShadow(
                //         color: Colors.grey.withOpacity(0.5),
                //         spreadRadius: 1,
                //         blurRadius: 8,
                //         offset: const Offset(0, 5),
                //       ),
                //     ],
                //   ),
                //   child: PageView(
                //     controller: pageController,
                //       return Column(
                //         children: [
                //           ]
                //       );
                //     },
                //   ),
                // ),
              ],
            ),
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}

