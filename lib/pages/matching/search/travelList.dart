import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';
import 'package:tripmating/model/matchinginfo/NEW/MatchResponseDetail.dart';

import '/Controller/matchingProvider/matchingProviders.dart';
import 'conditionSearch.dart';
import 'joinTravel.dart';


class TravelList extends ConsumerStatefulWidget {
  const TravelList({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TravelListState();
}
class _TravelListState extends ConsumerState<TravelList> {
  @override
  void initState() {
    super.initState();
    ref.read(travelListProvider.notifier).SearchAPI(null);
  }

  @override
  Widget build(BuildContext context) {
    final travelListState = ref.watch(travelListProvider);

    return SingleChildScrollView(
      child: Expanded(
        child: Container(
          margin: EdgeInsets.fromLTRB(20, 14, 14, 0),
          alignment: Alignment.centerLeft,
          child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                  child: TextField(
                    focusNode: FocusNode(),
                    onChanged: (text) {
                      if(text == '')
                        ref.read(travelListProvider.notifier).SearchAPI(null);
                      else
                        ref.read(travelListProvider.notifier).SearchAPI(text);
                    },
                    decoration: InputDecoration(
                      hintText: '검색',
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none, // 테두리 선 없음
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Icon(Icons.search, color: Colors.grey),
                      ),
                      suffixIcon: Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context){
                                  return ConditionSearch();
                                });
                          },
                          icon: Icon(Icons.add_box, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 500,
                  child: ListView.builder(
                    itemCount: travelListState.length,
                    itemBuilder: (content, index) {
                      MatchResponseDetail travelData = travelListState[index];
                      return TravelCard(
                        data: travelData,
                      );
                    },
                  ),
                ),
              ]
          ),
        ),
      ),
    );
  }
}

class TravelCard extends ConsumerStatefulWidget {
  final MatchResponseDetail data;

  TravelCard({required this.data});

  @override
  ConsumerState<TravelCard> createState() => _TravelCardState();
}

class _TravelCardState extends ConsumerState<TravelCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (BuildContext context)=> JoinTravel(data: widget.data,));
      },
      child: Card(
        elevation: 3,
        margin: EdgeInsets.all(10),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.data.title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '${widget.data.mainTravelSpace!}',
                style: TextStyle(fontSize: 18,color: Colors.pink, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Text(
                    '${widget.data.startDate!.toString().substring(0,10)}',
                    style: TextStyle(fontSize: 16),
                  ),
                  const Text(" ~ "),
                  Text(
                    '${widget.data.endDate!.toString().substring(0,10)}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              Text(
                '${widget.data.host.name!}',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

