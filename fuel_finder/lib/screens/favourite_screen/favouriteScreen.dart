import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fuel_finder/core/utils/image_constant.dart';
import 'package:fuel_finder/firebase/firebase.getFavoritesForuser.dart';
import 'package:fuel_finder/widgets/top_image.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:intl/intl.dart';

class Userfav extends StatefulWidget {
  const Userfav({super.key});

  @override
  State<Userfav> createState() => _UserfavState();
}

class _UserfavState extends State<Userfav> {
  final GetFavouritesController getFav = Get.put(GetFavouritesController());
  double count = 0;
  int userPoints = 0; // Add this variable

  @override
  void initState() {
    super.initState();
    // Fetch the user's points from Firestore when the widget initializes
    getUserPoints();
  }

  Future<void> getUserPoints() async {
    final userId = GetStorage().read('docId');
    if (userId != null) {
      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      final userData = userSnapshot.data();
      if (userData != null && userData.containsKey('points')) {
        setState(() {
          userPoints = userData['points'];
        });
      }
    }
  }

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
                          'My Favourites',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Poppins'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SingleChildScrollView(
              child: StreamBuilder<QuerySnapshot>(
                stream: getFav.getuserFav(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData) {
                    return const Text('No reviews found');
                  } else {
                    return Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            count += snapshot.data!.docs[index]['points'];
                            print(count);
                            return Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 12),
                              child: Column(
                                children: [
                                  Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40),
                                      color: Colors.grey.withOpacity(0.2),
                                    ),
                                    child: Stack(children: [
                                      Positioned(
                                          top: 40,
                                          left: 20,
                                          child: Text(
                                            DateFormat('MM/dd/yyyy').format(
                                              snapshot.data!
                                                  .docs[index]['dateCreated']
                                                  .toDate(),
                                            ),
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey),
                                          )),
                                      Positioned(
                                        top: 10,
                                        right: 20,
                                        child: IconButton(
                                          onPressed: () {
                                            getFav.deleteFav(
                                                snapshot.data!.docs[index].id);
                                            Get.snackbar(
                                                'Success', 'Review Deleted',
                                                backgroundColor: Colors.green,
                                                colorText: Colors.white,
                                                snackPosition:
                                                SnackPosition.BOTTOM);
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 15,
                                        left: 20,
                                        child: Row(children: [
                                          Text(
                                            snapshot.data!.docs[index]
                                            ['fuelstation'],
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w400,
                                                color: Colors.grey),
                                          ),
                                        ]),
                                      ),
                                      Positioned(
                                        top: 70,
                                        left: 15,
                                        child: RatingBar.builder(
                                          initialRating: snapshot
                                              .data!.docs[index]['rating'],
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemSize: 20,
                                          itemPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 4.0),
                                          itemBuilder: (context, _) =>
                                              Image.asset(
                                                ImageConstant.image7,
                                              ),
                                          onRatingUpdate: (rating) {
                                            // Store the rating value
                                          },
                                        ),
                                      ),
                                    ]),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
            const SizedBox(
              height: 74,
            ),
            Center(
              child: Column(children: [
                const Text(
                  "Now You Can Pay With Points",
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(
                  height: 17,
                ),
                Image.asset(
                  ImageConstant.image6,
                ),
                const SizedBox(
                  height: 27,
                ),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 47),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Your points - " + userPoints.toString() + ' points',
                    style: const TextStyle(
                      fontSize: 20,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Text(
                    "Points used - 0 points",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Text(
                    "Reward balance - 1100 points",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 23,
            )
          ],
        ),
      ),
    );
  }
}
