import 'dart:convert';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:my_trainings_app/training_model.dart';
import 'package:my_trainings_app/utils/colors.dart';
import 'package:my_trainings_app/utils/strings.dart';
import 'package:my_trainings_app/widgets/outline_button.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CarouselSliderController buttonCarouselController =
      CarouselSliderController();
  List<Widget> imageList = [];
  int filterIndex = 0;
  List<String> filterList = ["Sort by", "Location", "Training Name", "Trainer"];
  List<Training> trainingList = [];

  @override
  void initState() {
    super.initState();
    imageList.add(Image.asset('assets/image1.webp', fit: BoxFit.fitWidth));
    imageList.add(Image.asset('assets/image2.png', fit: BoxFit.fitWidth));
    imageList.add(Image.asset('assets/image3.png', fit: BoxFit.fitWidth));
    imageList.add(Image.asset('assets/image4.png', fit: BoxFit.fitWidth));
  }

  Future<List<Training>> loadJsonFromAssets() async {
    String jsonString = await rootBundle.loadString('assets/training_data.json');
    List<dynamic> jsonList = json.decode(jsonString);
    trainingList = jsonList.map((json) => Training.fromJson(json)).toList();
    return jsonList.map((json) => Training.fromJson(json)).toList();
  }

  loadFilterData() async{
    setState(() {
      trainingList =  loadJsonFromAssets() as List<Training>;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBacColor,
      appBar: AppBar(
        title: const Text(trainings,
            style: TextStyle(
                color: whiteColor, fontWeight: FontWeight.w600, fontSize: 28)),
        backgroundColor: homePinkColor,
        actions: [
          IconButton(
              onPressed: () {
                //TODO: Need to write the menu options here
              }, icon: const Icon(Icons.menu, color: whiteColor))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            // Top carousel with filters widgets
           getCarousalWidget(),
            const SizedBox(height: 10),

            // Trainings list view
            getTrainingListWidget(),
          ],
        ),
      ),
    );
  }

  Widget getCarousalWidget(){
    return  Stack(children: [
      Container(
        height: MediaQuery.of(context).size.height / 2.4,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.all(16),
                child: OutLButton(
                    text: filter,
                    color: blackColor,
                    onTap: () {
                      showFilters();
                    }))
          ],
        ),
      ),
      Container(
        height: MediaQuery.of(context).size.height / 5,
        // height: 100,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: homePinkColor,
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: EdgeInsets.only(top: 40, left: 16),
                child: Text(highlights,
                    style: TextStyle(
                        color: whiteColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 18)))
          ],
        ),
      ),
      Positioned(
        left: 0,
        right: 0,
        top: 30,
        bottom: 30,
        child: Row(
          children: [
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5), BlendMode.dstIn),
              child: Container(
                height: 100,
                width: 30,
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                ),
                child: IconButton(
                    onPressed: () {
                      buttonCarouselController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.linear);
                    },
                    icon: const Icon(Icons.arrow_back_ios,
                        color: Colors.white)),
              ),
            ),
            Expanded(
              child: CarouselSlider(
                disableGesture: false,
                items: imageList,
                carouselController: buttonCarouselController,
                options: CarouselOptions(
                  autoPlay: true,
                  height: MediaQuery.of(context).size.height / 5,
                  enlargeCenterPage: true,
                  viewportFraction: 0.9,
                  animateToClosest: true,
                  padEnds: true,
                  pauseAutoPlayOnTouch: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(seconds: 1),
                  pageSnapping: true,
                  aspectRatio: 2.0,
                  initialPage: 2,
                ),
              ),
            ),
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5), BlendMode.dstIn),
              child: Container(
                height: 100,
                width: 30,
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                ),
                child: IconButton(
                    onPressed: () {
                      buttonCarouselController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.linear);
                    },
                    icon: const Icon(Icons.arrow_forward_ios,
                        color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    ]);
  }

  Widget getTrainingListWidget(){
    return FutureBuilder<List<Training>>(
      future: loadJsonFromAssets(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Text('Loading....');
          default:
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return ListView.builder(
                shrinkWrap: true,
                primary: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var item = snapshot.data![index];
                  return SizedBox(
                    height: 200,
                    child: Card(
                      margin: const EdgeInsets.all(8),
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(2))),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  right: 8, left: 6, top: 6, bottom: 6),
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.date,
                                    style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w800,
                                        overflow: TextOverflow.visible),
                                  ),
                                  Text(item.time,
                                      style: const TextStyle(
                                          color: greyColor,
                                          overflow:
                                          TextOverflow.visible)),
                                  Text(item.location,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          overflow:
                                          TextOverflow.visible)),
                                ],
                              ),
                            ),
                          ),
                          const Padding(
                            padding:
                            EdgeInsets.only(top: 10, bottom: 10),
                            child: DottedLine(
                              dashLength: 4,
                              dashGapLength: 5,
                              lineThickness: 1,
                              dashRadius: 5,
                              direction: Axis.vertical,
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  right: 6, left: 8, top: 4, bottom: 4),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    item.status,
                                    style: const TextStyle(
                                        color: homePinkColor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(item.title,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800)),
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          CircleAvatar(
                                              radius: 25,
                                              child: Container(
                                                  padding:
                                                  const EdgeInsets
                                                      .all(4),
                                                  margin:
                                                  const EdgeInsets
                                                      .all(3),
                                                  decoration:
                                                  const BoxDecoration(
                                                    color: Colors.white,
                                                    shape:
                                                    BoxShape.circle,
                                                  ),
                                                  child: ClipOval(
                                                    child: SizedBox(
                                                      height: 80,
                                                      width: 80,
                                                      child:
                                                      Image.network(
                                                        item.imageUrl,
                                                        fit: BoxFit
                                                            .cover,
                                                      ),
                                                    ),
                                                  ))),
                                          Positioned(
                                            bottom: 5,
                                            left: 35,
                                            child: InkWell(
                                              onTap: () {},
                                              child: const Center(
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                  Colors.green,
                                                  radius: 10,
                                                  child: Icon(
                                                    Icons.check,
                                                    color: Colors.white,
                                                    size: 20,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(item.trainer,
                                              style: const TextStyle(
                                                  fontWeight:
                                                  FontWeight.w600)),
                                          Text(item.trainerDesignation),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.end,
                                    children: [
                                      FilledButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                            MaterialStateColor.resolveWith(
                                                    (states) =>
                                                Colors.red),
                                            minimumSize: MaterialStateProperty
                                                .resolveWith((states) =>
                                            const Size(80, 30)),
                                            shape: MaterialStateProperty.resolveWith((states) =>
                                            const RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.all(Radius.circular(0))))),
                                        child: const Text(
                                          'Enrol Now',
                                          style:
                                          TextStyle(fontSize: 12.0),
                                        ),
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
        }
      },
    );
  }

  // Filters Widget
  void showFilters() {
    showModalBottomSheet(
      context: context,
      backgroundColor: whiteColor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(0))),
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Sort and Filters'),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close))
                ],
              ),
              const Divider(),
              Expanded(
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.1,
                      child: ListView.builder(
                          itemCount: filterList.length,
                          itemBuilder: (context, int index) {
                            var item = filterList[index];
                            return ListTile(
                              onTap: () {
                                if(index != 0){
                                  setState(() {
                                    filterIndex = index;
                                  });
                                }
                              },
                              selectedColor: Colors.white,
                              tileColor: Colors.grey.shade300,
                              title: Text(item,
                                  style: (filterIndex == index)
                                      ? const TextStyle(
                                          fontWeight: FontWeight.w800,
                                          color: blackColor)
                                      : const TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: blackColor)),
                              style: ListTileStyle.list,
                              selected: filterIndex == index ? true : false,
                            );
                          }),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.1,
                      child: ListView(
                        children: trainingList.map((training) {
                          List<bool> selection = List.filled(trainingList.length, false, growable: false);
                          return Row(
                            children: [
                              (filterIndex != 0)
                                  ? Checkbox(
                                      value: selection[filterIndex], onChanged: (value) {
                                        setState(() {
                                          selection[filterIndex] = value!;
                                        });
                              })
                                  : const SizedBox.shrink(),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(filterIndex == 1
                                    ? training.location
                                    : filterIndex == 2
                                        ? training.title
                                        : filterIndex == 3
                                            ? training.trainer
                                            : "",overflow: TextOverflow.visible),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
      },
    );
  }
}
