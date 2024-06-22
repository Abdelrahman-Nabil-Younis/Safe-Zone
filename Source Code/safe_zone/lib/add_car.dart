import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(AddCar());
}

class AddCar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF9FAFB),
      ),
      home: VehicleDetailsScreen(),
    );
  }
}

class VehicleDetailsScreen extends StatefulWidget {
  @override
  _VehicleDetailsScreenState createState() => _VehicleDetailsScreenState();
}

class _VehicleDetailsScreenState extends State<VehicleDetailsScreen> {
  File? _carImage;
  File? _licenseImage;
  String? _selectedVehicleType;
  String? _selectedBrand;
  String? _firstName;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _plateController = TextEditingController();
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        setState(() {
          _firstName = userDoc['firstName'];
        });
      }
    } catch (e) {
      print("Error fetching user name: $e");
    }
  }

  Future<void> _getCarImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _carImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _getLicenseImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _licenseImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Hello',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontFamily: 'Roboto Serif',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _firstName ?? 'Loading...',
                          style: const TextStyle(
                            color: Color(0xFFF76B1C),
                            fontSize: 24,
                            fontFamily: 'Roboto Serif',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Please add your',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontFamily: 'Roboto Serif',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'vehicle’s details',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontFamily: 'Roboto Serif',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 75,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: _carImage != null
                                ? FileImage(_carImage!)
                                : null,
                            child: _carImage == null
                                ? Icon(
                                    Icons.camera_alt,
                                    size: 50,
                                    color: Colors.grey[800],
                                  )
                                : null,
                          ),
                          Positioned(
                            bottom: -13,
                            right: 4,
                            child: IconButton(
                              icon: const Icon(
                                Icons.add_a_photo_rounded,
                                color: Colors.black,
                              ),
                              onPressed: _getCarImage,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Car Picture',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 40),
              _buildDropdown(
                context,
                'Type of Vehicle',
                _selectedVehicleType,
                ['Car', 'Van', 'Autobus'],
                (value) {
                  setState(() {
                    _selectedVehicleType = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              _buildDropdown(
                context,
                'Brand',
                _selectedBrand,
                [
                  'Chevrolet',
                  'Nissan',
                  'BMW',
                  'Mercedes',
                  'Hyundai',
                  'Kia',
                  'Toyota',
                  'Renault',
                  'Skoda',
                  'Volkswagen',
                  'Peugeot',
                  'Opel',
                  'MG',
                  'Chery',
                  'Suzuki',
                  'Mitsubishi',
                  'Fiat',
                  'Jeep',
                  'Volvo',
                  'Seat',
                  'Audi',
                  'Citroën',
                  'Porsche',
                  'BYD',
                  'Geely',
                  'Honda',
                  'Tesla',
                  'Subaru',
                  'Lada',
                  'Haval',
                  'Jetour',
                  'Mazda',
                  'Dodge',
                  'Cadillac',
                  'Acura'
                ],
                (value) {
                  setState(() {
                    _selectedBrand = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              _buildTextField('Model', _modelController),
              const SizedBox(height: 20),
              _buildTextField('Plate', _plateController),
              const SizedBox(height: 20),
              _buildImagePicker('License', _licenseImage, _getLicenseImage),
              const SizedBox(height: 40),
              Container(
                height: 48,
                width: 300,
                child: ElevatedButton(
                  onPressed: _isUploading ? null : _saveCarDetails,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF76B1C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: _isUploading
                      ? CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const Text(
                          'Save',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 24),
              if (_selectedVehicleType != null || _selectedBrand != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Selected Vehicle Type: $_selectedVehicleType\nSelected Brand: $_selectedBrand',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(BuildContext context, String hint, String? value,
      List<String> items, ValueChanged<String?> onChanged) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: DropdownButton<String>(
        dropdownColor: Colors.white,
        isExpanded: true,
        value: value,
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
        hint: Text(hint),
        underline: const SizedBox(),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
        ),
      ),
    );
  }

  Widget _buildImagePicker(
      String label, File? imageFile, VoidCallback onPickImage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'Roboto',
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onPickImage,
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
              image: imageFile != null
                  ? DecorationImage(
                      image: FileImage(imageFile),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: imageFile == null
                ? Center(
                    child: Icon(
                      Icons.add_a_photo,
                      size: 50,
                      color: Colors.grey[800],
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }

  Future<void> _saveCarDetails() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isUploading = true;
      });

      try {
        String? carImageUrl;
        String? licenseImageUrl;

        if (_carImage != null) {
          carImageUrl = await _uploadFile(_carImage!, 'car_images');
        }

        if (_licenseImage != null) {
          licenseImageUrl = await _uploadFile(_licenseImage!, 'license_images');
        }

        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await FirebaseFirestore.instance.collection('vehicles').add({
            'userId': user.uid,
            'vehicleType': _selectedVehicleType,
            'brand': _selectedBrand,
            'model': _modelController.text,
            'plate': _plateController.text,
            'carImageUrl': carImageUrl,
            'licenseImageUrl': licenseImageUrl,
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vehicle details saved successfully')),
        );

        // Navigate to the home screen after showing the success message
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } catch (e) {
        print('Error saving vehicle details: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save vehicle details')),
        );
      } finally {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  Future<String> _uploadFile(File file, String folder) async {
    try {
      String fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
      Reference storageRef =
          FirebaseStorage.instance.ref().child('$folder/$fileName');
      UploadTask uploadTask = storageRef.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading file: $e');
      return '';
    }
  }
}
