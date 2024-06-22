import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:safe_zone/admin_notifications.dart';

void main() {
  runApp(const Users());
}

class Users extends StatelessWidget {
  const Users({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Users',
      home: UserPage(),
    );
  }
}

class UserPage extends StatelessWidget {
  const UserPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.topCenter,
          child: Text(
            'Users',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFF76B1C),
              fontSize: 17,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w700,
              height: 0,
              letterSpacing: -0.41,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 23.5, right: 23.5),
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator(); // Loading indicator
                }

                final List<DocumentSnapshot> documents = snapshot.data!.docs;

                final filteredDocuments =
                    documents.where((doc) => !(doc['isAdmin'] ?? false));

                return Column(
                  children: List.generate(
                    filteredDocuments.length,
                    (index) {
                      final userData = filteredDocuments.elementAt(index).data()
                          as Map<String, dynamic>;

                      final String firstName = userData['firstName'];
                      final String secondName = userData['secondName'] ?? '';
                      final String gender = userData['gender'];
                      final String userId =
                          filteredDocuments.elementAt(index).id;

                      return UserBox(
                        userIndex: index + 1,
                        firstName: firstName,
                        secondName: secondName,
                        gender: gender,
                        userId: userId,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class UserBox extends StatelessWidget {
  final int userIndex;
  final String firstName;
  final String secondName;
  final String gender;
  final String userId;

  const UserBox({
    Key? key,
    required this.userIndex,
    required this.firstName,
    required this.secondName,
    required this.gender,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final String salutation = gender == 'Male' ? 'Mr. ' : 'Mrs. ';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserCarsPage(userId: userId),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: SizedBox(
          width: 435,
          height: 185,
          child: Stack(
            children: [
              Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(width: 2, color: const Color(0xFFF76B1C)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0F000000),
                      blurRadius: 12,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.person_outline,
                              color: Color(0xFFF76B1C)),
                          const SizedBox(width: 8),
                          Text(
                            '$salutation$firstName $secondName',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: double.infinity,
                        height: 2,
                        color: const Color(0xFFF76B1C),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(left: 28),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '${firstName.capitalize!}\'s Profile:\n',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w700,
                                  decoration: TextDecoration.underline,
                                  wordSpacing: 2,
                                ),
                              ),
                              const TextSpan(
                                text: '\n',
                                style: TextStyle(
                                  fontSize: 10,
                                ),
                              ),
                              const TextSpan(
                                text: 'Cars',
                                style: TextStyle(
                                  color: Color(0xFFF76B1C),
                                  fontSize: 20,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w700,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              const TextSpan(
                                text: '  ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              TextSpan(
                                text: '\n\nSend Notifications',
                                style: TextStyle(
                                  color: Color(0xFFF76B1C),
                                  fontSize: 20,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w700,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AdminNotificationPage(),
                                      ),
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserCarsPage extends StatelessWidget {
  final String userId;

  const UserCarsPage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Cars',
          style: TextStyle(
            color: Color(0xFFF76B1C),
            fontSize: 17,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w700,
            letterSpacing: -0.41,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 23.5, right: 23.5),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('vehicles')
                  .where('userId', isEqualTo: userId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator(); // Loading indicator
                }

                final List<DocumentSnapshot> documents = snapshot.data!.docs;

                if (documents.isEmpty) {
                  return const Text("This user has no cars");
                }

                return Column(
                  children: List.generate(
                    documents.length,
                    (index) {
                      final vehicleData =
                          documents[index].data() as Map<String, dynamic>;

                      final String vehicleName = vehicleData['brand'];
                      final String vehicleModel = vehicleData['model'];

                      return VehicleBox(
                        vehicleIndex: index + 1,
                        vehicleName: vehicleName,
                        vehicleModel: vehicleModel,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class VehicleBox extends StatelessWidget {
  final int vehicleIndex;
  final String vehicleName;
  final String vehicleModel;

  const VehicleBox({
    Key? key,
    required this.vehicleIndex,
    required this.vehicleName,
    required this.vehicleModel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: SizedBox(
        width: 435,
        height: 96,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(width: 2, color: const Color(0xFFF76B1C)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0F000000),
                blurRadius: 12,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.directions_car_filled_sharp,
                        color: Color(0xFFF76B1C)),
                    const SizedBox(width: 8),
                    Text(
                      '$vehicleName $vehicleModel',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  height: 2,
                  color: const Color(0xFFF76B1C),
                ),
                const SizedBox(
                  height: 4,
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 28),
                  child: RichText(
                    text: const TextSpan(
                      children: [],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
