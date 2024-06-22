import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() => runApp(const Profile());

class Profile extends StatelessWidget {
  const Profile({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _profileImage;
  File? _coverImage;
  String? _profileImgUrl;
  String? _coverImgUrl;
  bool _isUploading = false;
  Future<void>? _loadingFuture;

  @override
  void initState() {
    super.initState();
    _loadingFuture = _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (userData.exists) {
          setState(() {
            _profileImgUrl = userData['profileImgUrl'];
            _coverImgUrl = userData['coverImgUrl'];
          });
        }
      } catch (error) {
        print('Error loading profile data: $error');
      }
    }
  }

  Future<void> _pickImage(bool isCoverImage) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        if (isCoverImage) {
          _coverImage = File(pickedFile.path);
        } else {
          _profileImage = File(pickedFile.path);
        }
      });
    }
  }

  Future<void> _uploadProfileAndCoverImages() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && (_profileImage != null || _coverImage != null)) {
      setState(() {
        _isUploading = true;
      });

      try {
        if (_coverImage != null) {
          final coverFileName = 'cover_${user.uid}.jpg';
          final coverDestination = 'users/$coverFileName';
          final coverRef = FirebaseStorage.instance.ref(coverDestination);
          await coverRef.putFile(_coverImage!);
          final coverImageUrl = await coverRef.getDownloadURL();
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({'coverImgUrl': coverImageUrl});
          setState(() {
            _coverImgUrl = coverImageUrl;
            _coverImage = null;
          });
        }

        if (_profileImage != null) {
          final profileFileName = 'profile_${user.uid}.jpg';
          final profileDestination = 'users/$profileFileName';
          final profileRef = FirebaseStorage.instance.ref(profileDestination);
          await profileRef.putFile(_profileImage!);
          final profileImageUrl = await profileRef.getDownloadURL();
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({'profileImgUrl': profileImageUrl});
          setState(() {
            _profileImgUrl = profileImageUrl;
            _profileImage = null;
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Profile and cover pictures updated successfully'),
          backgroundColor: Colors.green,
        ));
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to update profile and cover pictures: $error'),
          backgroundColor: Colors.red,
        ));
      } finally {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  void _showProfilePicture() {
    if (_profileImgUrl != null) {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CachedNetworkImage(
                  imageUrl: _profileImgUrl!,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Close'),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('No profile picture to display'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder<void>(
            future: _loadingFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => _pickImage(true),
                      child: Container(
                        width: double.infinity,
                        height: 212,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x3F000000),
                              blurRadius: 4,
                              offset: Offset(4, 5),
                            ),
                          ],
                          color: Colors.grey,
                        ),
                        child: _coverImage != null
                            ? Image.file(_coverImage!, fit: BoxFit.cover)
                            : _coverImgUrl != null
                                ? CachedNetworkImage(
                                    imageUrl: _coverImgUrl!,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  )
                                : Icon(Icons.add_a_photo,
                                    size: 48, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () => _pickImage(false),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey,
                              backgroundImage: _profileImage != null
                                  ? FileImage(_profileImage!) as ImageProvider
                                  : _profileImgUrl != null
                                      ? CachedNetworkImageProvider(
                                          _profileImgUrl!)
                                      : null,
                              child: _profileImage == null &&
                                      _profileImgUrl == null
                                  ? Icon(Icons.add_a_photo,
                                      size: 48, color: Colors.white)
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 16),
                          FutureBuilder<DocumentSnapshot>(
                            future: _fetchUserInfo(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else if (snapshot.hasData &&
                                  snapshot.data != null) {
                                final userData = snapshot.data!;
                                final firstName = userData['firstName'] ?? '';
                                final secondName = userData['secondName'] ?? '';

                                return Text(
                                  '$firstName $secondName',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              } else {
                                return SizedBox.shrink();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _showProfilePicture,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFE5B4),
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                          ),
                          child: Text(
                            'Show Profile Picture',
                            style: TextStyle(fontSize: 12, color: Colors.black),
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: _uploadProfileAndCoverImages,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFE5B4),
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                          ),
                          child: _isUploading
                              ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.black),
                                )
                              : Text(
                                  'Update Profile& Cover Picture',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.black),
                                ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    FutureBuilder<DocumentSnapshot>(
                      future: _fetchUserInfo(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData && snapshot.data != null) {
                          final userData = snapshot.data!;
                          final firstName = userData['firstName'] ?? '';
                          final secondName = userData['secondName'] ?? '';
                          final phoneNumber = userData['phoneNumber'] ?? '';
                          final email = userData['email'] ?? '';

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildInfoRow('First Name:', firstName),
                                const SizedBox(height: 16),
                                _buildInfoRow('Last Name:', secondName),
                                const SizedBox(height: 16),
                                _buildInfoRow('Phone:', phoneNumber),
                                const SizedBox(height: 16),
                                _buildInfoRow('Email:', email),
                                const SizedBox(height: 16),
                                FutureBuilder<QuerySnapshot>(
                                  future: _fetchUserVehicleInfo(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else if (snapshot.hasData &&
                                        snapshot.data != null) {
                                      final vehicleData = snapshot.data!;
                                      final vehicleWidgets = <Widget>[];

                                      for (var i = 0;
                                          i < vehicleData.docs.length;
                                          i++) {
                                        final vehicle = vehicleData.docs[i];
                                        final brand = vehicle['brand'] ?? '';
                                        final model = vehicle['model'] ?? '';
                                        final carImageUrl =
                                            vehicle['carImageUrl'] ?? '';
                                        final carNumber = i + 1;

                                        vehicleWidgets.add(
                                          Container(
                                            padding: const EdgeInsets.all(16),
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 8),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFFFE5B4),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                _buildInfoRow(
                                                    'Car $carNumber Brand:',
                                                    brand),
                                                const SizedBox(height: 8),
                                                _buildInfoRow(
                                                    'Car $carNumber Model:',
                                                    model),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: CachedNetworkImage(
                                                      imageUrl: carImageUrl,
                                                      width: double.infinity,
                                                      height: 200,
                                                      fit: BoxFit.cover,
                                                      placeholder: (context,
                                                              url) =>
                                                          Center(
                                                              child:
                                                                  CircularProgressIndicator()),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Icon(Icons.error),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Subscribed to:',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Gold Package',
                                                      style: TextStyle(
                                                        color: const Color(
                                                            0xFFF76B1C),
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }

                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: vehicleWidgets,
                                      );
                                    } else {
                                      return SizedBox.shrink();
                                    }
                                  },
                                ),
                              ],
                            ),
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      },
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 1,
          color: Colors.grey.withOpacity(0.5),
        ),
      ],
    );
  }

  Future<DocumentSnapshot> _fetchUserInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
    }
    throw Exception('User not found');
  }

  Future<QuerySnapshot> _fetchUserVehicleInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return await FirebaseFirestore.instance
          .collection('vehicles')
          .where('userId', isEqualTo: user.uid)
          .get();
    }
    throw Exception('User not found');
  }

  Future<void> _updateFirstName(String firstName) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'firstName': firstName});
    }
  }

  Future<void> _updateSecondName(String secondName) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'secondName': secondName});
    }
  }
}
