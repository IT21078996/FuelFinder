import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fuel_finder/core/utils/image_constant.dart';
import 'package:fuel_finder/firebase/firebase.getAllFeedbacks.dart';
import 'package:fuel_finder/widgets/top_image.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';

class RecomondationScreen extends StatefulWidget {
  const RecomondationScreen({super.key});

  @override
  State<RecomondationScreen> createState() => _RecomondationScreenState();
}

class _RecomondationScreenState extends State<RecomondationScreen> {
  final getcartController getfeedbackss = Get.put(getcartController());
  TextEditingController filterController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: <Widget>[
                const TopContainer(),
                Positioned(
                  top: 70,
                  left: 30,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Row(
                      children: [
                        Icon(
                          Icons.arrow_back_ios,
                          color: Colors.black,
                          size: 20,
                        ),
                        Text(
                          'Recomondations',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.grey.withOpacity(0.2),
                ),
                child: TextField(
                  controller: filterController,
                  decoration: const InputDecoration(
                    hintText: 'Fillter  By',
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 87, 87, 87),
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    setState(() {
                      getfeedbackss.filterFeedbacks(filterController.text);
                    });
                  },
                ),
              ),
            ),
            SingleChildScrollView(
              child: StreamBuilder<QuerySnapshot>(
                stream: getfeedbackss.getAllFeedbacks(filterController.text),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData) {
                    return const Text('No reviews found');
                  } else {
                    return Column(
                      children: snapshot.data!.docs.map((doc) {
                        DateTime dateCreated = doc['dateCreated'].toDate();
                        DateTime currentDate = DateTime.now();
                        int differenceInDays =
                            currentDate.difference(dateCreated).inDays;

                        String formattedDate;
                        if (differenceInDays == 0) {
                          formattedDate = 'Today';
                        } else if (differenceInDays == 1) {
                          formattedDate = 'Yesterday';
                        } else {
                          formattedDate = '$differenceInDays days ago';
                        }

                        return Column(
                          children: [
                            Container(
                              height: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 20,
                                    left: 20,
                                    child: SizedBox(
                                      width: 70,
                                      height: 70,
                                      child: ClipRRect(
                                        child: CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl: doc['image'].toString(),
                                          progressIndicatorBuilder: (context,
                                              url, downloadProgress) =>
                                              CircularProgressIndicator(
                                                  value: downloadProgress
                                                      .progress),
                                          errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 20,
                                    left: 110,
                                    child: Text(
                                      doc['name'],
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  Positioned(
                                    top: 45,
                                    left: 100,
                                    child: RatingBar.builder(
                                      initialRating: doc['rating'],
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemSize: 20,
                                      itemPadding: const EdgeInsets.symmetric(
                                          horizontal: 4.0),
                                      itemBuilder: (context, _) =>
                                          Image.asset(ImageConstant.image7),
                                      onRatingUpdate: (rating) {
                                        // Store the rating value
                                      },
                                    ),
                                  ),
                                  Positioned(
                                    top: 20,
                                    right: 20,
                                    child: Text(
                                      formattedDate,
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey,
                                      ),
                                    ), // Use the formatted date
                                  ),
                                  Positioned(
                                    top: 100,
                                    left: 20,
                                    right: 20,
                                    child: RichText(
                                      text: TextSpan(
                                        style:
                                        DefaultTextStyle.of(context).style,
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: doc['fuelstation'],
                                            style: const TextStyle(
                                              color: Colors.red,
                                            ),
                                          ),
                                          const TextSpan(
                                            text: ' - ',
                                          ),
                                          TextSpan(
                                            text: doc['comment'],
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w400,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 120,
                                    right: 20,
                                    child: LikeButton(
                                      size: 20,
                                      circleColor: const CircleColor(
                                          start: Colors.green,
                                          end: Color.fromARGB(
                                              255, 246, 252, 246)),
                                      bubblesColor: const BubblesColor(
                                        dotPrimaryColor: Colors.green,
                                        dotSecondaryColor: Colors.green,
                                      ),
                                      likeBuilder: (bool isLiked) {
                                        return Icon(
                                          Icons.thumb_up,
                                          color: isLiked
                                              ? Colors.green
                                              : Colors.grey,
                                          size: 20,
                                        );
                                      },
                                      likeCount: 0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider()
                          ],
                        );
                      }).toList(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
