import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatefulWidget {
  const TermsAndConditionsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TermsAndConditionsPageState createState() => _TermsAndConditionsPageState();
}

class _TermsAndConditionsPageState extends State<TermsAndConditionsPage> {
  late ScrollController _scrollController;
  bool _showScrollButton = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.offset > 200 && !_showScrollButton) {
      setState(() {
        _showScrollButton = true;
      });
    } else if (_scrollController.offset <= 200 && _showScrollButton) {
      setState(() {
        _showScrollButton = false;
      });
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Container(
                  width: double.infinity,
                  decoration: const ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AGREEMENT',
                          style: TextStyle(
                            color: Color(0xFF9F9F9F),
                            fontSize: 16,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Terms of Service',
                          style: TextStyle(
                            color: Color(0xFF494949),
                            fontSize: 30,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Last updated on 5/12/2022',
                          style: TextStyle(
                            color: Color(0xFF7C7C7C),
                            fontSize: 16,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Divider(
                          color: Color(0xFFD9D9D9),
                          thickness: 1,
                        ),
                      ],
                    ),
                  ),
                ),

                // Clause 1
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '1. Acceptance of Terms',
                      style: TextStyle(
                        color: Color(0xFF494949),
                        fontSize: 20,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 9),
                    SizedBox(
                      width: 312.69,
                      child: Text(
                        'These terms and conditions constitute a binding legal agreement between you and Safe Zone ("Company," "we," "us," or "our"). By accessing or using the Safe Zone app, you agree to abide by these terms.',
                        style: TextStyle(
                          color: Color(0xFF494949),
                          fontSize: 16,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16), // Spacing between clauses

                // Clause 2
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '2. App Services',
                      style: TextStyle(
                        color: Color(0xFF494949),
                        fontSize: 20,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 9),
                    SizedBox(
                      width: 312.69,
                      child: Text(
                        'The Safe Zone app provides a platform for users to book vehicle services such as routine maintenance, repairs, and customization, as well as reserve secure parking spaces for short-term or long-term use. The specific services are subject to change or discontinuation at our discretion.',
                        style: TextStyle(
                          color: Color(0xFF494949),
                          fontSize: 16,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16), // Spacing between clauses

                // Clause 3
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '3. User Accounts',
                      style: TextStyle(
                        color: Color.fromRGBO(73, 73, 73, 1),
                        fontSize: 20,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 9),
                    SizedBox(
                      width: 312.69,
                      child: Text(
                        "To use the app's services, you must create a user account. You agree to provide accurate and current information during the registration process. You are responsible for maintaining the confidentiality of your account information, including your password, and for all activities that occur under your account.",
                        style: TextStyle(
                          color: Color(0xFF494949),
                          fontSize: 16,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                // Clause 4
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '4. Service Booking',
                      style: TextStyle(
                        color: Color.fromRGBO(73, 73, 73, 1),
                        fontSize: 20,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 9),
                    SizedBox(
                      width: 312.69,
                      child: Text(
                        "When you book a vehicle service through the app, you agree to pay the applicable fees. All bookings are subject to availability and confirmation. We reserve the right to cancel or refuse any booking at our discretion.",
                        style: TextStyle(
                          color: Color(0xFF494949),
                          fontSize: 16,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                // Clause 5
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '5. Payment and Refunds',
                      style: TextStyle(
                        color: Color.fromRGBO(73, 73, 73, 1),
                        fontSize: 20,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 9),
                    SizedBox(
                      width: 312.69,
                      child: Text(
                        "All payments for services must be made through the app using the accepted payment methods. You are responsible for providing accurate payment information. We do not store your payment details. Refunds are subject to our refund policy, which is available on the app or upon request.",
                        style: TextStyle(
                          color: Color(0xFF494949),
                          fontSize: 16,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                // Clause 6
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '6. Vehicle Maintenance and Repair',
                      style: TextStyle(
                        color: Color.fromRGBO(73, 73, 73, 1),
                        fontSize: 20,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 9),
                    SizedBox(
                      width: 312.69,
                      child: Text(
                        "We take care to ensure that all services are performed by skilled technicians and mechanics. However, we are not liable for any damage or loss resulting from vehicle maintenance, repairs, or customization unless caused by our gross negligence or intentional misconduct.",
                        style: TextStyle(
                          color: Color(0xFF494949),
                          fontSize: 16,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                // Clause 7
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '7. Parking Services',
                      style: TextStyle(
                        color: Color.fromRGBO(73, 73, 73, 1),
                        fontSize: 20,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 9),
                    SizedBox(
                      width: 312.69,
                      child: Text(
                        "Our parking facilities are equipped with advanced security measures, including 24/7 surveillance. However, we do not guarantee against theft, loss, or damage to vehicles or their contents. You are responsible for securing your vehicle and valuables. Our liability for any loss or damage is limited to the value of the parking fee paid.",
                        style: TextStyle(
                          color: Color(0xFF494949),
                          fontSize: 16,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                // Clause 8
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '8. Limitation of Liability',
                      style: TextStyle(
                        color: Color.fromRGBO(73, 73, 73, 1),
                        fontSize: 20,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 9),
                    SizedBox(
                      width: 312.69,
                      child: Text(
                        "To the fullest extent permitted by law, the Company shall not be liable for any indirect, incidental, consequential, special, or punitive damages arising out of or related to your use of the app or its services. Our total liability, whether in contract, tort, or otherwise, shall not exceed the amount paid by you for the services.",
                        style: TextStyle(
                          color: Color(0xFF494949),
                          fontSize: 16,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                // Clause 9
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '9. Indemnification',
                      style: TextStyle(
                        color: Color.fromRGBO(73, 73, 73, 1),
                        fontSize: 20,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 9),
                    SizedBox(
                      width: 312.69,
                      child: Text(
                        "You agree to indemnify, defend, and hold the Company, its affiliates, officers, directors, employees, and agents harmless from any claims, damages, liabilities, or expenses arising out of your use of the app, your breach of these terms, or your violation of any applicable laws.",
                        style: TextStyle(
                          color: Color(0xFF494949),
                          fontSize: 16,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                // Clause 10
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '10. Privacy Policy',
                      style: TextStyle(
                        color: Color.fromRGBO(73, 73, 73, 1),
                        fontSize: 20,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 9),
                    SizedBox(
                      width: 312.69,
                      child: Text(
                        "Your use of the app is subject to our privacy policy, which outlines how we collect, use, and protect your personal information. By using the app, you agree to the terms of the privacy policy.",
                        style: TextStyle(
                          color: Color(0xFF494949),
                          fontSize: 16,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                // Clause 11
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '11. Termination',
                      style: TextStyle(
                        color: Color.fromRGBO(73, 73, 73, 1),
                        fontSize: 20,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 9),
                    SizedBox(
                      width: 312.69,
                      child: Text(
                        "We reserve the right to terminate your account and access to the app at any time, with or without cause. If you breach these terms, we may terminate your account without notice.",
                        style: TextStyle(
                          color: Color(0xFF494949),
                          fontSize: 16,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                // Clause 12
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '12. Governing Law and Dispute Resolution',
                      style: TextStyle(
                        color: Color.fromRGBO(73, 73, 73, 1),
                        fontSize: 20,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 9),
                    SizedBox(
                      width: 312.69,
                      child: Text(
                        "These terms shall be governed by and construed in accordance with the laws of the jurisdiction where Safe Zone is based. Any disputes arising out of or related to these terms shall be resolved through arbitration in accordance with the rules of the relevant arbitration body.",
                        style: TextStyle(
                          color: Color(0xFF494949),
                          fontSize: 16,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                // Clause 13
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '13. Changes to Terms',
                      style: TextStyle(
                        color: Color.fromRGBO(73, 73, 73, 1),
                        fontSize: 20,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 9),
                    SizedBox(
                      width: 312.69,
                      child: Text(
                        "We may update or modify these terms at any time. We will notify you of any significant changes, and your continued use of the app after such changes indicates your acceptance of the revised terms.",
                        style: TextStyle(
                          color: Color(0xFF494949),
                          fontSize: 16,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                // Clause 14
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '14. Contact Us',
                      style: TextStyle(
                        color: Color.fromRGBO(73, 73, 73, 1),
                        fontSize: 20,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 9),
                    SizedBox(
                      width: 312.69,
                      child: Text(
                        "If you have any questions about these terms, please contact us at [contact email or address].",
                        style: TextStyle(
                          color: Color(0xFF494949),
                          fontSize: 16,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                // Ending
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 9),
                    SizedBox(
                      width: 312.69,
                      child: Text(
                        "By using the Safe Zone app, you acknowledge that you have read, understood, and agreed to these terms and conditions. Thank you for choosing Safe Zone.",
                        style: TextStyle(
                          color: Color(0xFF494949),
                          fontSize: 16,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16), // Spacing between clauses

                // Accept & Continue Button
                Center(
                  child: Container(
                    width: 183,
                    height: 47,
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFFF5000),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      shadows: const [
                        BoxShadow(
                          color: Color(0xFF8E6DE9),
                          blurRadius: 25,
                          offset: Offset(0, 5),
                          spreadRadius: -10,
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          left: -162,
                          top: 0,
                          child: Container(
                            width: 162,
                            height: 47,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const Positioned(
                          left: 16,
                          top: 12.5,
                          child: Text(
                            'Accept & Continue',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w700,
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
          if (_showScrollButton)
            Positioned(
              bottom: 16,
              right: 16,
              child: FloatingActionButton(
                onPressed: _scrollToTop,
                child: const Icon(Icons.arrow_upward),
              ),
            ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: TermsAndConditionsPage(),
  ));
}
