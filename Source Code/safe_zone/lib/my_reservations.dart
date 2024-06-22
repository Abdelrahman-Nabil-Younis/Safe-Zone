import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyReservations());
}

class MyReservations extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFFF86C1D),
        hintColor: Color(0xFF040415),
        textTheme: TextTheme(
          displayLarge: TextStyle(
            fontFamily: 'Roboto Serif',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFFF86C1D),
          ),
          bodyLarge: TextStyle(
            fontFamily: 'Roboto Serif',
            fontSize: 18,
            color: Colors.black87,
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Roboto Serif',
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Color(0xFFF86C1D),
          textTheme: ButtonTextTheme.primary,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFFF86C1D),
        ),
      ),
      home: ReservationScreen(),
    );
  }
}

class ReservationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Reservations',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ReservationList(),
    );
  }
}

class ReservationList extends StatefulWidget {
  @override
  _ReservationListState createState() => _ReservationListState();
}

class _ReservationListState extends State<ReservationList>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<List<QueryDocumentSnapshot>> _fetchReservations() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('reservations')
          .where('userId', isEqualTo: user.uid)
          .orderBy('timestamp', descending: true)
          .get();
      return querySnapshot.docs;
    }
    return [];
  }

  Future<String> _fetchPackageName(String packageId) async {
    final doc = await FirebaseFirestore.instance
        .collection('packages')
        .doc(packageId)
        .get();
    return doc['package_name'];
  }

  Future<Map<String, String>> _fetchVehicleDetails(String vehicleId) async {
    final doc = await FirebaseFirestore.instance
        .collection('vehicles')
        .doc(vehicleId)
        .get();
    return {
      'brand': doc['brand'],
      'model': doc['model'],
    };
  }

  void _cancelReservation(String reservationId) async {
    await FirebaseFirestore.instance
        .collection('reservations')
        .doc(reservationId)
        .delete();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Reservation canceled successfully!')),
    );
    setState(() {});
  }

  Future<void> _showCancellationConfirmationDialog(String reservationId) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cancel Reservation'),
          content: Text('Are you sure you want to cancel your reservation?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                _cancelReservation(reservationId);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Center(
        child: Text('Please log in to view your reservations.'),
      );
    }

    return FutureBuilder<List<QueryDocumentSnapshot>>(
      future: _fetchReservations(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          print('Error fetching reservations: ${snapshot.error}');
          return Center(
              child: Text('Error fetching reservations: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          print('No reservations found for user ID: ${user.uid}');
          return Center(child: Text('No reservations found.'));
        }

        var reservations = snapshot.data!;
        print('Found ${reservations.length} reservations');

        return ListView.builder(
          itemCount: reservations.length,
          itemBuilder: (context, index) {
            var reservation = reservations[index];
            var reservationId = reservation.id;
            var packageId = reservation['packageId'];
            var vehicleId = reservation['vehicleId'];
            var timestamp = reservation['timestamp'] as Timestamp?;
            var appointmentDateTime =
                (reservation['appointmentDateTime'] as Timestamp?)?.toDate();

            return FutureBuilder<String>(
              future: _fetchPackageName(packageId),
              builder: (context, packageSnapshot) {
                if (!packageSnapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                return FutureBuilder<Map<String, String>>(
                  future: _fetchVehicleDetails(vehicleId),
                  builder: (context, vehicleSnapshot) {
                    if (!vehicleSnapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }

                    var vehicleDetails = vehicleSnapshot.data!;

                    return FadeTransition(
                      opacity: _animation,
                      child: Card(
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        child: ListTile(
                          title: Text('Package: ${packageSnapshot.data}',
                              style: Theme.of(context).textTheme.displayLarge),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Vehicle: ${vehicleDetails['brand']} ${vehicleDetails['model']}',
                                  style: Theme.of(context).textTheme.bodyLarge),
                              Text(
                                  'Reservation Time: ${appointmentDateTime != null ? appointmentDateTime.toString() : 'Unknown'}',
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                            ],
                          ),
                          isThreeLine: true,
                          trailing: TextButton(
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () {
                              _showCancellationConfirmationDialog(
                                  reservationId);
                            },
                          ),
                          onTap: () {
                            if (appointmentDateTime != null) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Reservation Details'),
                                    content: Text(
                                        'Package: ${packageSnapshot.data}\n'
                                        'Vehicle: ${vehicleDetails['brand']} ${vehicleDetails['model']}\n'
                                        'Appointment Date and Time: $appointmentDateTime'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}

class Packagess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Packages'),
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReservationScreen()),
              );
            },
          ),
        ],
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
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: packages.map<Widget>((package) {
                var packageName = package['package_name'];
                var packageServices =
                    List<String>.from(package['package_services']);
                var packageId = package.id;
                return _buildPackageBox(
                    context, packageName, packageServices, packageId);
              }).toList(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPackageBox(BuildContext context, String title,
      List<String> features, String packageId) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.grey, width: 0.5),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: Offset(4.0, 4.0),
            blurRadius: 15.0,
            spreadRadius: 1.0,
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
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    decoration: TextDecoration.underline,
                    fontSize: 20.0,
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
                              color: Colors.grey,
                            ),
                            SizedBox(width: 8.0),
                            Expanded(
                              child: Text(
                                feature,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
            SizedBox(height: 16.0),
            _buildSubscriptionBox(context, packageId),
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
              builder: (context) => MyReservationScreen(packageId: packageId)),
        );
      },
      child: Text('Select Package'),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFF86C1D)),
      ),
    );
  }
}

class MyReservationScreen extends StatelessWidget {
  final String packageId;

  const MyReservationScreen({required this.packageId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservation Details'),
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

  void _saveReservation() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && selectedVehicleId != null) {
      await FirebaseFirestore.instance.collection('reservations').add({
        'userId': user.uid,
        'vehicleId': selectedVehicleId,
        'packageId': widget.packageId,
        'timestamp': FieldValue.serverTimestamp(),
        'appointmentDateTime':
            Timestamp.now(), // Add a timestamp for the appointment
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reservation saved successfully!')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a vehicle.')),
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
              'You have selected package:',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            Text(
              widget.packageId,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 20.0),
            Text(
              'Select a vehicle:',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            SizedBox(height: 10.0),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedVehicleId,
              hint: Text('Select a vehicle'),
              items: vehicles.map((vehicle) {
                var vehicleName = vehicle['brand'] + ' ' + vehicle['model'];
                var vehicleId = vehicle.id;
                return DropdownMenuItem<String>(
                  value: vehicleId,
                  child: Text(vehicleName),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedVehicleId = value;
                });
              },
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _saveReservation,
              child: Text('Confirm Reservation'),
            ),
          ],
        );
      },
    );
  }
}
