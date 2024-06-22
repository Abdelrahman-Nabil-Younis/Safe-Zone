import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Define a Vehicle class to represent the structure of a vehicle
class Vehicle {
  final String name;
  final String model;
  final String userId; // Add userId to the Vehicle class

  Vehicle(this.name, this.model, this.userId);
}

void main() {
  runApp(const Cars());
}

class Cars extends StatelessWidget {
  const Cars({Key? key});

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
            'Cars',
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('vehicles').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          List<Vehicle> vehicles =
              snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            return Vehicle(data['brand'], data['model'], data['userId']);
          }).toList();

          return SingleChildScrollView(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 10.0, left: 23.5, right: 23.5),
                child: Column(
                  children: List.generate(
                    vehicles.length,
                    (index) => VehicleBox(
                      vehicleIndex: index + 1,
                      vehicle: vehicles[index],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class VehicleBox extends StatelessWidget {
  final int vehicleIndex;
  final Vehicle vehicle;

  const VehicleBox(
      {Key? key, required this.vehicleIndex, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: SizedBox(
        width: 435,
        height: 145,
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
                      '${vehicle.name} ${vehicle.model}',
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
                const Divider(
                  height: 2,
                  thickness: 2,
                  color: Color(0xFFF76B1C),
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
                          text: 'Car $vehicleIndex:\n',
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
                        TextSpan(
                          text: 'Owner Details',
                          style: const TextStyle(
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
                                  builder: (context) => UserDetailsPage(
                                    userId: vehicle.userId,
                                  ),
                                ),
                              );
                            },
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
                        const TextSpan(
                          text: '          ',
                        ),
                      ],
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

class UserDetailsPage extends StatelessWidget {
  final String userId;

  const UserDetailsPage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Details',
          style: TextStyle(
            color: Color(0xFFF76B1C),
            fontSize: 17,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w700,
            letterSpacing: -0.41,
          ),
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('users').doc(userId).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.data!.exists) {
            return const Center(
              child: Text('User not found'),
            );
          }

          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  data['profileImgUrl'] != null
                      ? Image.network(data['profileImgUrl'])
                      : const Icon(Icons.account_circle, size: 100),
                  const SizedBox(height: 16),
                  Text('First Name: ${data['firstName']}'),
                  Text('Second Name: ${data['secondName']}'),
                  Text('Gender: ${data['gender']}'),
                  Text('Birthdate: ${data['birthdate']}'),
                  Text('Phone Number: ${data['phoneNumber']}'),
                  Text('Email: ${data['email']}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
