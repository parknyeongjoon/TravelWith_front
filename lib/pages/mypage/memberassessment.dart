import 'package:flutter/material.dart';
import 'package:random_avatar/random_avatar.dart';

class Member {
  final String name;
  final int score;

  Member({required this.name, required this.score});
}

class MemberAssessment extends StatefulWidget {
  const MemberAssessment({super.key});

  @override
  State<MemberAssessment> createState() => _MemberAssessmentState();
}

class _MemberAssessmentState extends State<MemberAssessment> {
  // 샘플 데이터
  final List<Member> members = [
    Member(name: '한상구', score: 1),
    Member(name: '이용현', score: 5),
    Member(name: '박녕준', score: 4),
    Member(name: '최민준', score: 5),
    Member(name: '이주형', score: 5)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          title: const Text("Member Assessment"),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0, bottom: 16, left: 30, right: 30),
        child: ListView.builder(
          itemCount: members.length,
          itemBuilder: (context, index) {
            return AssessmentCard(member: members[index]);
          },
        ),
      ),
    );
  }
}

class AssessmentCard extends StatefulWidget {
  final Member member;

  const AssessmentCard({super.key, required this.member});

  @override
  State<AssessmentCard> createState() => _AssessmentCardState();
}

class _AssessmentCardState extends State<AssessmentCard> {
  Widget avatar = RandomAvatar("000000000000", width: 50, height: 50);

  late List<bool> selectedStars;

  @override
  void initState() {
    super.initState();
    selectedStars = List.generate(5, (index) => index < widget.member.score);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.pink[50],
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
                  shadowColor: const Color.fromRGBO(0, 0, 0, 0),
                ),
                onPressed: () {
                  // Do something when the button is pressed
                },
                child: avatar,
              ),
              Text(widget.member.name),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (int i = 0; i < 5; i++)
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            for (int j = 0; j <= i; j++) {
                              selectedStars[j] = true;
                            }
                            for (int j = i + 1; j < 5; j++) {
                              selectedStars[j] = false;
                            }
                          });
                        },
                        icon: selectedStars[i]
                            ? const Icon(Icons.star)
                            : const Icon(Icons.star_border_outlined),
                      ),
                    ),
                ],
              ),
              SizedBox(
                width: 270,
                child: ElevatedButton(onPressed: () {
                  // Do something when the check button is pressed
                }, child: const Icon(Icons.check)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}