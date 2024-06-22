import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safe_zone/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Reservation());
}

class Reservation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Packages(),
    );
  }
}

class Packages extends StatelessWidget {
  final String? selectedPackageId; // Package ID selected by the user

  Packages({this.selectedPackageId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Packages'),
        backgroundColor: Color(0xFFF86C1D),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('packages').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            var packages = snapshot.data!.docs;
            // Filter packages if selectedPackageId is not null
            if (selectedPackageId != null) {
              packages = packages
                  .where((package) => package.id == selectedPackageId)
                  .toList();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: packages.map<Widget>((package) {
                var packageName = package['package_name'];
                var packageServices =
                    List<String>.from(package['package_services']);
                var packageId = package.id;
                var packagePrice = package['price'];
                var packageDuration = package['duration'];
                return _buildPackageBox(context, packageName, packageServices,
                    packageId, packagePrice, packageDuration);
              }).toList(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPackageBox(BuildContext context, String title,
      List<String> features, String packageId, packagePrice, packageDuration) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.black, width: 0.5),
        color: Color.fromRGBO(255, 255, 255, 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            offset: Offset(4.0, 4.0),
            blurRadius: 20.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Color(0xFF040415),
                fontFamily: 'Roboto Serif',
                fontSize: 22.0,
                fontWeight: FontWeight.w600,
                height: 0.90909,
                decoration: TextDecoration.underline,
              ),
            ),
            SizedBox(height: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: features
                  .map((feature) => Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.circle,
                              size: 10,
                              color: Color(0xFF040415),
                            ),
                            SizedBox(width: 8.0),
                            Expanded(
                              child: Text(
                                feature,
                                style: TextStyle(
                                  color: Color(0xFF040415),
                                  fontFamily: 'Roboto Serif',
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w400,
                                  height: 1.11111,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Text(
                  'Price: ',
                  style: TextStyle(
                    color: Color(0xFF040415),
                    fontFamily: 'Roboto Serif',
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400,
                    height: 1.11111,
                  ),
                ),
                Text(
                  '$packagePrice EGP',
                  style: TextStyle(
                    color: Color(0xFF040415),
                    fontFamily: 'Roboto Serif',
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400,
                    height: 1.11111,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Text(
                  '\nDuration: ',
                  style: TextStyle(
                    color: Color(0xFF040415),
                    fontFamily: 'Roboto Serif',
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400,
                    height: 1.11111,
                  ),
                ),
                Text(
                  '\n$packageDuration Month',
                  style: TextStyle(
                    color: Color(0xFF040415),
                    fontFamily: 'Roboto Serif',
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400,
                    height: 1.11111,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Center(child: _buildSubscriptionBox(context, packageId)),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionBox(BuildContext context, String packageId) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ReservationScreen(packageId: packageId)),
        );
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFFF86C1D), // foreground color
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 80.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      child: Text(
        'Select Package',
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class ReservationScreen extends StatelessWidget {
  final String packageId;

  const ReservationScreen({required this.packageId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservation Details'),
        backgroundColor: Color(0xFFF86C1D),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: VehicleSelection(packageId: packageId),
      ),
    );
  }
}

class VehicleSelection extends StatefulWidget {
  final String packageId;

  const VehicleSelection({required this.packageId});

  @override
  _VehicleSelectionState createState() => _VehicleSelectionState();
}

class _VehicleSelectionState extends State<VehicleSelection> {
  String? selectedVehicleId;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  late Future<List<DocumentSnapshot>> vehiclesFuture;

  @override
  void initState() {
    super.initState();
    vehiclesFuture = _fetchVehicles();
  }

  Future<List<DocumentSnapshot>> _fetchVehicles() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final vehiclesSnapshot = await FirebaseFirestore.instance
          .collection('vehicles')
          .where('userId', isEqualTo: user.uid)
          .get();
      return vehiclesSnapshot.docs;
    }
    return [];
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime)
      setState(() {
        selectedTime = picked;
      });
  }

  void _saveReservation() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null &&
        selectedVehicleId != null &&
        selectedDate != null &&
        selectedTime != null) {
      final appointmentDateTime = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        selectedTime!.hour,
        selectedTime!.minute,
      );

      // Check the total reservations
      final reservationSnapshot =
          await FirebaseFirestore.instance.collection('reservations').get();
      if (reservationSnapshot.size >= 10) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No parking slots available.')),
        );
        return;
      }

      // Save the reservation
      final reservationRef =
          await FirebaseFirestore.instance.collection('reservations').add({
        'userId': user.uid,
        'vehicleId': selectedVehicleId,
        'packageId': widget.packageId,
        'appointmentDateTime': appointmentDateTime,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Notify the admin
      await FirebaseFirestore.instance.collection('adminNotifications').add({
        'title': 'New Reservation',
        'userId': user.uid,
        'vehicleId': selectedVehicleId,
        'packageId': widget.packageId,
        'appointmentDateTime': appointmentDateTime,
        'reservationId': reservationRef.id,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reservation saved successfully!')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Please select a vehicle and an appointment date/time.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DocumentSnapshot>>(
      future: vehiclesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No vehicles available.'));
        }
        var vehicles = snapshot.data!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select a car to subscribe to package\n",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            Text(
              'Package ID: ${widget.packageId}\n',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Text(
              'Select a vehicle:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
            ),
            ...vehicles.map((vehicle) {
              var vehicleId = vehicle.id;
              var vehicleName =
                  '${vehicle['brand']} - ${vehicle['model']} - (${vehicle['plate']})';
              return RadioListTile<String>(
                title: Text(vehicleName),
                value: vehicleId,
                groupValue: selectedVehicleId,
                onChanged: (value) {
                  setState(() {
                    selectedVehicleId = value;
                  });
                },
              );
            }).toList(),
            Spacer(),
            SizedBox(height: 20.0),
            Center(
              // Center the buttons
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xFFF86C1D), // foreground color
                      padding: EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 118.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: Text(
                      selectedDate != null
                          ? 'Selected Date: ${selectedDate!.toLocal()}'
                              .split(' ')[0]
                          : 'Select Date',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () => _selectTime(context),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xFFF86C1D), // foreground color
                      padding: EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 116.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: Text(
                      selectedTime == null
                          ? 'Select Time'
                          : 'Selected Time: ${selectedTime!.format(context)}',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: _saveReservation,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xFFF86C1D), // foreground color
                      padding: EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 100.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: Text(
                      'Book Package',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
                height: 20.0), // Add some space between buttons and bottom edge
          ],
        );
      },
    );
  }
}
