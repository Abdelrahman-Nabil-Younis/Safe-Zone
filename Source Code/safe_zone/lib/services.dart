import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safe_zone/home.dart';

void main() {
  runApp(Services());
}

class Services extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Our Services',
            style: TextStyle(
              color: Color(0xFFF86C1D),
              fontFamily: 'Roboto Serif',
              fontSize: 40,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w500,
              height: 0.5,
            ),
          ),
          centerTitle: true,
          backgroundColor: Color.fromRGBO(237, 237, 237, 0.5),
          toolbarHeight: 80,
        ),
        body: ServicesList(),
      ),
    );
  }
}

class ServicesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 35),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Container(
              width: 350,
              height: 264,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black, width: 0.5),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    offset: Offset(4, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 33, right: 14, top: 15),
                child: Text(
                  'Welcome to our comprehensive car services and storage facility! We are dedicated to providing exceptional automotive services and secure storage solutions for our valued customers. Whether you need routine maintenance, repairs, or a safe place to store your vehicle, we have you covered.',
                  style: TextStyle(
                    color: Color(0xFF040415),
                    fontFamily: 'Roboto Serif',
                    fontSize: 15,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildServiceBox('1.jpg', 'Car Washing', context),
                SizedBox(height: 20),
                _buildServiceBox('2.jpg', 'Car Detailing', context),
                SizedBox(height: 20),
                _buildServiceBox('3.jpg', 'Car Tuning', context),
                SizedBox(height: 20),
                _buildServiceBox('4.jpeg', 'Oil Change', context),
                SizedBox(height: 20),
                _buildServiceBox('5.jpg', 'Tire Rotation', context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceBox(
      String imagePath, String title, BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('services')
          .where('service_name', isEqualTo: title)
          .limit(1)
          .get()
          .then((value) => value.docs.first),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return SizedBox(); // Return an empty widget if data doesn't exist
        }

        var serviceId = snapshot.data!.id;
        var serviceName = snapshot.data!['service_name'];

        return Container(
          height: 62,
          width: 309,
          margin: EdgeInsets.symmetric(vertical: 2),
          padding: EdgeInsets.only(
              left: 0), // Add padding to move content to the left
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(60),
            border: Border.all(color: Color(0xFFF86C1D), width: 2),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 10,
                offset: Offset(8, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // Align children to the ends
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(
                      color: Color(0xFFF86C1D), width: 2), // Border color
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      24), // Adjust border radius to accommodate the border width
                  child: Image.asset(
                    'assets/$imagePath',
                    width: 52,
                    height: 52,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 10), // Add spacing between image and text
              Text(
                serviceName,
                style: TextStyle(
                  color: Color(0xFF040415),
                  fontFamily: 'Roboto Serif',
                  fontSize: 16,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w400,
                  height: 1.25,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: SizedBox(
                  width: 80,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ServiceDetailPage(serviceId: serviceId),
                        ),
                      );
                    },
                    child: Text(
                      'Subscribe',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFF86C1D),
                      padding: EdgeInsets.symmetric(horizontal: 8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ServiceDetailPage extends StatelessWidget {
  final String serviceId;

  ServiceDetailPage({required this.serviceId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service Details'),
        backgroundColor: Color(0xFFF86C1D),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('services')
            .doc(serviceId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Service not found'));
          }

          var serviceData = snapshot.data!.data() as Map<String, dynamic>;
          var serviceName = serviceData['service_name'];
          var serviceDetails = serviceData['service_details'];
          var servicePrice = serviceData['service_price'];
          var times = serviceData['times'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Service Name: $serviceName',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('\nDetails: $serviceDetails',
                    style: TextStyle(fontSize: 16)),
                SizedBox(height: 8),
                Text('\nPrice: ${servicePrice.toString()} EGP',
                    style: TextStyle(fontSize: 16)),
                SizedBox(height: 8),
                Text('Times: $times', style: TextStyle(fontSize: 16)),
                SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      var user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        var vehicles = await FirebaseFirestore.instance
                            .collection('vehicles')
                            .where('userId', isEqualTo: user.uid)
                            .get();
                        if (vehicles.docs.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('No vehicles found')));
                          return;
                        }

                        var selectedVehicleId = await showDialog<String>(
                          context: context,
                          builder: (context) =>
                              ChooseVehicleDialog(vehicles: vehicles.docs),
                        );

                        if (selectedVehicleId != null) {
                          var confirmed = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Confirm Request'),
                              content:
                                  Text('Do you want to request this service?'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: Text('Confirm'),
                                ),
                              ],
                            ),
                          );

                          if (confirmed == true) {
                            await FirebaseFirestore.instance
                                .collection('requests')
                                .add({
                              'serviceId': serviceId,
                              'userId': user.uid,
                              'vehicleId': selectedVehicleId,
                              'timestamp': FieldValue.serverTimestamp(),
                            });
                            await FirebaseFirestore.instance
                                .collection('adminNotifications')
                                .add({
                              'userId': user.uid,
                              'serviceId': serviceId,
                              'vehicleId': selectedVehicleId,
                              'timestamp': FieldValue.serverTimestamp(),
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Request submitted')));
                            Navigator.pop(context);
                          }
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('User not logged in')));
                      }
                    },
                    child: Text(
                      'Request This Service',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFF86C1D),
                      padding: EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 50.0), // Adjust padding for button size
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            30.0), // Adjust border radius for button shape
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ChooseVehicleDialog extends StatelessWidget {
  final List<QueryDocumentSnapshot> vehicles;

  ChooseVehicleDialog({required this.vehicles});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Choose Vehicle'),
      content: SingleChildScrollView(
        child: Column(
          children: vehicles.map((vehicle) {
            var vehicleData = vehicle.data() as Map<String, dynamic>;
            var vehicleName = (vehicleData['brand'] ?? 'Unknown Brand') +
                ' - ' +
                (vehicleData['model'] ?? 'Unknown Model');
            return ListTile(
              title: Text(vehicleName),
              onTap: () => Navigator.pop(context, vehicle.id),
            );
          }).toList(),
        ),
      ),
    );
  }
}
