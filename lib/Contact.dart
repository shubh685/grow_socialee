import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'About.dart';
import 'Client_Logos.dart';
import 'Reviews.dart';
import 'Services.dart';
import 'home_page.dart';

class Contact extends StatefulWidget {
  const Contact({super.key});

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> with SingleTickerProviderStateMixin {
  int _selectedIndex = 5;
  int _selectedFormCategory = 0;

  static const Color brandBlue = Color(0xFF1B64B1);
  static const Color darkBg = Color(0xFF144F8E);
  static const Color darkCardBg = Color(0xFF0F3E72);
  static const Color textMuted = Color(0xFFD0E1F9);
  static const Color accentWhite = Colors.white;

  final _formKey = GlobalKey<FormState>();
  String? _serviceDr;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  final List<String> _servicesList = [
    "Social Media Strategy Development",
    "Content Creation",
    "Social Media Account Management",
    "Social Media Advertising",
    "Analytics and Reporting",
    "Reputation Management",
  ];

  bool _isSubmitting = false;
  late AnimationController _radarAnimationController;

  final String addressQuery =
      "First Floor, Leela Efcee, 103, Waghawadi Rd., Hill Drive, Bhavnagar, Gujarat 364002";
  final String phoneNum = "+919408518168";
  final String emailAddr = "growsocialee@gmail.com";
  final String googleMapsUrl =
      "https://maps.google.com/?q=Grow+Socialee+Leela+Efcee+Bhavnagar";
  final String googleDirectionsUrl =
      "https://www.google.com/maps/dir/?api=1&destination=Grow+Socialee+Leela+Efcee+Bhavnagar";

  final String facebookUrl = "https://www.facebook.com/growsocialeeofficial/";
  final String instagramUrl = "https://www.instagram.com/growsocialee.official/";
  final String linkedInUrl = "https://in.linkedin.com/company/grow-socialee";

  @override
  void initState() {
    super.initState();
    _radarAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _radarAnimationController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _launchUrlString(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $url')),
        );
      }
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (!await launchUrl(launchUri)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open phone dialer')),
        );
      }
    }
  }

  Future<void> _sendEmail(String email) async {
    final Uri launchUri = Uri(scheme: 'mailto', path: email);
    if (!await launchUrl(launchUri)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open email client')),
        );
      }
    }
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      final List<String> categories = ["General Inquiry", "Get Quote", "Support"];
      final String selectedCategory = categories[_selectedFormCategory];
      final Uri apiUrl =
      Uri.parse("http://192.168.1.103/grow_socialee/send_inquiry.php");

      try {
        final Map<String, dynamic> requestData = {
          "name": _nameController.text.trim(),
          "phone": _phoneController.text.trim(),
          "email": _emailController.text.trim(),
          "category": selectedCategory,
          "service": _serviceDr ?? '',
          "message": _messageController.text.trim(),
        };

        final response = await http.post(
          apiUrl,
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
          body: jsonEncode(requestData),
        );

        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (!mounted) return;

        if (response.statusCode == 200 && responseData['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseData['message'] ??
                  "Thank you! Your inquiry has been dispatched successfully."),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );

          _formKey.currentState?.reset();
          _nameController.clear();
          _emailController.clear();
          _phoneController.clear();
          _messageController.clear();
          setState(() {
            _serviceDr = null;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseData['message'] ??
                  "Failed to submit inquiry. Please try again."),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Network error: $e"),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isSubmitting = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth > 850;

    return Scaffold(
      backgroundColor: darkBg,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75),
        child: Container(
          decoration: const BoxDecoration(
            color: HomePage.darkBg,
            border: Border(bottom: BorderSide(color: Colors.white24, width: 1)),
          ),
          child: SafeArea(
            child: AppBar(
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
              elevation: 0,
              titleSpacing: 0,
              title: _buildLogoHeader(),
              actions: [
                Builder(
                  builder: (context) => IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.menu_rounded,
                        color: Colors.white, size: 28),
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
        ),
      ),
      endDrawer: Drawer(
        width: isDesktop ? 360 : screenWidth * 0.8,
        backgroundColor: HomePage.darkBg,
        child: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    vertical: 28.0, horizontal: 16.0),
                color: HomePage.darkCardBg,
                child: Center(
                  child: SizedBox(
                    height: 55,
                    child: Image.asset(
                      "assets/photos/Gro_Soc_Image.png",
                      color: Colors.white,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.image,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
              const Divider(height: 1, thickness: 1, color: Colors.white24),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildDrawerItem(
                      index: 0,
                      icon: Icons.home_rounded,
                      label: "HOME",
                      onTap: () {
                        setState(() => _selectedIndex = 0);
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        );
                      },
                    ),
                    _buildDrawerItem(
                      index: 1,
                      icon: Icons.info_outline_rounded,
                      label: "ABOUT",
                      onTap: () {
                        setState(() => _selectedIndex = 1);
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const About()));
                      },
                    ),
                    _buildDrawerItem(
                      index: 2,
                      icon: Icons.group_outlined,
                      label: "CLIENTS",
                      onTap: () {
                        setState(() => _selectedIndex = 2);
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ClientLogoPage()));
                      },
                    ),
                    _buildDrawerItem(
                      index: 3,
                      icon: Icons.task_alt_outlined,
                      label: "SERVICES",
                      onTap: () {
                        setState(() => _selectedIndex = 3);
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Services()));
                      },
                    ),
                    _buildDrawerItem(
                      index: 4,
                      icon: Icons.chat_bubble_outline_rounded,
                      label: "REVIEWS",
                      onTap: () {
                        setState(() => _selectedIndex = 4);
                        Navigator.pop(context);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Reviews()));
                      },
                    ),
                    _buildDrawerItem(
                      index: 5,
                      icon: Icons.contact_phone_sharp,
                      label: "CONTACT US",
                      onTap: () {
                        setState(() => _selectedIndex = 5);
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Contact()));
                      },
                    ),
                  ],
                ),
              ),
              Container(
                height: 4,
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _buildAGHeroBanner(screenWidth, isDesktop),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: isDesktop ? 60 : 30,
                horizontal: isDesktop ? 60 : 16,
              ),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1150),
                  child: isDesktop
                      ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 7,
                        child: Column(
                          children: [
                            _buildInteractiveFormCard(),
                            const SizedBox(height: 32),
                            _buildGoogleMapSection(),
                          ],
                        ),
                      ),
                      const SizedBox(width: 32),
                      Expanded(
                        flex: 5,
                        child: _buildInteractiveContactSidebar(),
                      ),
                    ],
                  )
                      : Column(
                    children: [
                      _buildInteractiveContactSidebar(),
                      const SizedBox(height: 32),
                      _buildInteractiveFormCard(),
                      const SizedBox(height: 32),
                      _buildGoogleMapSection(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _buildAGFooter(context),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoHeader() {
    // FIX 1: Remove Flexible inside Row with no parent Row; use a plain
    // constrained Text so it doesn't try to expand infinitely.
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.centerLeft,
      child: const Text(
        "We are \n Grow Socialee",
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: "Main Fonts",
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required int index,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final isSelected = _selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(icon, size: 20, color: isSelected ? darkBg : Colors.white),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? darkBg : Colors.white,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.arrow_forward_ios_rounded,
                      size: 14, color: darkBg),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAGHeroBanner(double screenWidth, bool isDesktop) {
    return Container(
      width: double.infinity,
      color: darkBg,
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.12,
              child: CustomPaint(
                painter: _HeroPatternPainter(),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: isDesktop ? 90 : 50,
              horizontal: isDesktop ? 80 : 24,
            ),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.white30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.chat_bubble_outline_rounded,
                              size: 14, color: Colors.white),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              "GET IN TOUCH WITH US",
                              style: GoogleFonts.cinzel(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 2.0,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Let's Build Something Great Together.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isDesktop ? 48 : 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.2,
                        letterSpacing: -0.5,
                        fontFamily: 'Main Fonts',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Get prompt responses from a friendly, professional and knowledgeable team.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.alexandria(
                        fontSize: isDesktop ? 16 : 14,
                        color: textMuted,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Wrap(
                      spacing: 16,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: darkBg,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 28,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 4,
                          ),
                          icon: const Icon(Icons.phone_rounded, size: 18),
                          label: Text(
                            "CALL NOW",
                            style: GoogleFonts.aleo(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                          onPressed: () => _makePhoneCall(phoneNum),
                        ),
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 28,
                              vertical: 16,
                            ),
                            side:
                            const BorderSide(color: Colors.white30, width: 1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const Icon(Icons.email_rounded, size: 18),
                          label: Text(
                            "EMAIL US",
                            style: GoogleFonts.aleo(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                          onPressed: () => _sendEmail(emailAddr),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractiveFormCard() {
    final categories = ["General Inquiry", "Get Quote", "Support"];

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: darkCardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FIX 2: Wrap Row children so the icon doesn't push text into
            // overflow on narrow screens. Use Flexible for the icon container
            // and let the text column take remaining space.
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Send Us A Message",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          fontFamily: 'Main Fonts',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Fill out the form below and we'll reply shortly.",
                        style: GoogleFonts.alexandria(
                          fontSize: 13,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: const Icon(Icons.send_rounded,
                      color: Colors.white, size: 22),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(categories.length, (index) {
                  final isSelected = _selectedFormCategory == index;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(categories[index]),
                      selected: isSelected,
                      selectedColor: Colors.white,
                      backgroundColor: darkBg,
                      labelStyle: GoogleFonts.alexandria(
                        color: isSelected ? darkBg : textMuted,
                        fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: isSelected ? Colors.white : Colors.white24,
                        ),
                      ),
                      onSelected: (bool selected) {
                        if (selected) {
                          setState(() => _selectedFormCategory = index);
                        }
                      },
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 20),
            _buildInputField(
              controller: _nameController,
              label: "Your Name",
              icon: Icons.person_outline_rounded,
              validator: (v) =>
              v == null || v.isEmpty ? "Please enter your name" : null,
            ),
            const SizedBox(height: 16),
            _buildInputField(
              controller: _emailController,
              label: "Email Address",
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.isEmpty) return "Please enter your email";
                if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(v)) {
                  return "Please enter a valid email";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildInputField(
              controller: _phoneController,
              label: "Contact Number",
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: (v) => v == null || v.isEmpty
                  ? "Please enter your mobile number"
                  : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _serviceDr,
              isExpanded: true,
              dropdownColor: darkCardBg,
              style: GoogleFonts.alexandria(fontSize: 14, color: Colors.white),
              iconEnabledColor: Colors.white,
              decoration: InputDecoration(
                labelText: "Select Service",
                labelStyle:
                GoogleFonts.alexandria(color: textMuted, fontSize: 14),
                prefixIcon: const Icon(Icons.cleaning_services_outlined,
                    color: Colors.white, size: 20),
                filled: true,
                fillColor: darkBg,
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white24),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white, width: 1.5),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.redAccent),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                  const BorderSide(color: Colors.redAccent, width: 1.5),
                ),
              ),
              items: _servicesList.map((String service) {
                return DropdownMenuItem<String>(
                  value: service,
                  child: Text(
                    service,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.alexandria(
                        color: Colors.white, fontSize: 14),
                  ),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _serviceDr = newValue;
                });
              },
              validator: (v) =>
              v == null || v.isEmpty ? "Please select a service" : null,
            ),
            const SizedBox(height: 16),
            _buildInputField(
              controller: _messageController,
              label: _selectedFormCategory == 1
                  ? "Describe your project requirements..."
                  : "How can we help you?",
              icon: Icons.chat_bubble_outline_rounded,
              maxLines: 4,
              validator: (v) =>
              v == null || v.isEmpty ? "Please enter your message" : null,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: darkBg,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _isSubmitting ? null : _handleSubmit,
                child: _isSubmitting
                    ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: darkBg,
                    strokeWidth: 2.5,
                  ),
                )
                // FIX 3: Removed nested Flexible-in-Row (unnecessary and
                // can produce constraint issues). Just a plain Row is fine.
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.near_me_rounded,
                        color: darkBg, size: 20),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        "SUBMIT INQUIRY",
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.aleo(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: darkBg,
                          letterSpacing: 1.1,
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
    );
  }

  Widget _buildInteractiveContactSidebar() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          // FIX 4: Row containing circle icon + text. Circle icon is fine,
          // but on extremely narrow screens the icon padding + text could
          // still overflow. Wrap icon in a fixed-size container is fine;
          // text column already in Expanded. This is safe.
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: darkCardBg,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.timer_rounded,
                    color: Colors.white, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Fast Response Guarantee",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: darkCardBg,
                        fontFamily: 'Main Fonts',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "We usually respond within 2 working hours during business times.",
                      style: GoogleFonts.alexandria(
                          fontSize: 12, color: darkBg),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildSidebarDetailCard(
          icon: Icons.location_on_rounded,
          title: "Visit Our Agency",
          subtitle: addressQuery,
          actionLabel: "Get Directions",
          onTap: () => _launchUrlString(googleDirectionsUrl),
        ),
        const SizedBox(height: 14),
        _buildSidebarDetailCard(
          icon: Icons.phone_in_talk_rounded,
          title: "Call Direct",
          subtitle: phoneNum,
          actionLabel: "Dial Now",
          onTap: () => _makePhoneCall(phoneNum),
        ),
        const SizedBox(height: 14),
        _buildSidebarDetailCard(
          icon: Icons.mark_email_read_rounded,
          title: "Email Support",
          subtitle: emailAddr,
          actionLabel: "Compose Email",
          onTap: () => _sendEmail(emailAddr),
        ),
        const SizedBox(height: 14),
        _buildSidebarDetailCard(
          icon: Icons.access_time_filled_rounded,
          title: "Working Hours",
          subtitle: "9:30 AM to 7:00 PM (Monday - Saturday)",
          actionLabel: "Status: Open Today",
          onTap: null,
          isStatusBadge: true,
        ),
      ],
    );
  }

  Widget _buildSidebarDetailCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String actionLabel,
    required VoidCallback? onTap,
    bool isStatusBadge = false,
  }) {
    return Material(
      color: Colors.white70,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white24),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: darkCardBg,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white24),
                ),
                child: Icon(icon, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: darkCardBg,
                        fontFamily: 'Main Fonts',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.alexandria(
                        fontSize: 13,
                        color: darkBg,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (isStatusBadge)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.green.withOpacity(0.4),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                actionLabel,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.alexandria(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                    // FIX 5: Wrap label + arrow so long labels don't
                    // overflow. Use Flexible for the text and let the
                    // arrow stay at fixed size.
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              actionLabel,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.alexandria(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            size: 14,
                            color: darkCardBg,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleMapSection() {
    return Container(
      width: double.infinity,
      height: 380,
      decoration: BoxDecoration(
        color: darkCardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: _radarAnimationController,
              builder: (context, child) {
                return Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: darkBg,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _MapGridPainter(
                            animationValue: _radarAnimationController.value,
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.location_on_rounded,
                              size: 28,
                              color: darkBg,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                // FIX 6: Rating row can overflow on narrow screens. Wrap
                // the "Grow Socialee" text in Flexible with ellipsis, and
                // put the star+rating in its own Flexible so both shrink.
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.storefront_rounded,
                          color: darkCardBg, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  "Grow Socialee",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: GoogleFonts.aleo(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: darkCardBg,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(Icons.star_rounded,
                                  size: 16, color: darkBg),
                              const SizedBox(width: 2),
                              Flexible(
                                child: Text(
                                  "4.9 (13)",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: GoogleFonts.alexandria(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: darkBg,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Leela Efcee, Waghawadi Rd, Bhavnagar",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.alexandria(
                                fontSize: 12, color: darkCardBg),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              // FIX: Do NOT wrap the label of ElevatedButton.icon in Flexible.
              // Instead use a plain ElevatedButton with our own Row so we can
              // safely apply Flexible/Ellipsis to the text.
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: darkCardBg,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(color: Colors.white24),
                        ),
                      ),
                      onPressed: () => _launchUrlString(googleMapsUrl),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.map_rounded,
                              size: 18, color: Colors.white),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              "View Map",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.aleo(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: darkBg,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => _launchUrlString(googleDirectionsUrl),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.directions_rounded, size: 18),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              "Get Directions",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.aleo(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
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
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      style: GoogleFonts.alexandria(fontSize: 14, color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.alexandria(color: textMuted, fontSize: 14),
        prefixIcon: Icon(icon, color: Colors.white, size: 20),
        filled: true,
        fillColor: darkBg,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white24),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildAGFooter(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth > 800;

    return Container(
      width: double.infinity,
      color: darkBg,
      child: Column(
        children: [
          const Divider(height: 1, thickness: 1, color: Colors.white24),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 24),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: isDesktop
                    ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: _buildFooterBrandSection()),
                    const SizedBox(width: 40),
                    Expanded(
                        flex: 2, child: _buildFooterContactSection()),
                    const SizedBox(width: 40),
                    Expanded(
                        flex: 1, child: _buildFooterSocialSection()),
                  ],
                )
                    : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFooterBrandSection(),
                    const SizedBox(height: 36),
                    _buildFooterContactSection(),
                    const SizedBox(height: 36),
                    _buildFooterSocialSection(),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
            color: darkCardBg,
            child: Center(
              child: Text(
                "© ${DateTime.now().year} Grow Socialee. All rights reserved.",
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: textMuted,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterBrandSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 45,
          child: Image.asset(
            "assets/photos/Gro_Soc_Image.png",
            color: Colors.white,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.image,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "Empowering businesses through digital strategies, branding, video production, and social media solutions.",
          style: GoogleFonts.alexandria(
            fontSize: 14,
            color: textMuted,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildFooterContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "CONTACT INFO",
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: () => _launchUrlString(googleMapsUrl),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on_outlined,
                  size: 18, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  addressQuery,
                  style: GoogleFonts.alexandria(
                    fontSize: 13,
                    color: textMuted,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () => _makePhoneCall(phoneNum),
          // FIX 8: Wrap phone text in Expanded so it can't overflow.
          child: Row(
            children: [
              const Icon(Icons.phone_outlined, size: 18, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  phoneNum,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.alexandria(
                    fontSize: 13,
                    color: textMuted,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () => _sendEmail(emailAddr),
          // FIX 9: Wrap email text in Expanded so it can't overflow.
          child: Row(
            children: [
              const Icon(Icons.email_outlined, size: 18, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  emailAddr,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.alexandria(
                    fontSize: 13,
                    color: textMuted,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFooterSocialSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "CONNECT WITH US",
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 16),
        // FIX 10: Wrap in a Wrap instead of Row so icons don't overflow on
        // very narrow widths (e.g. split-screen on web).
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: [
            IconButton(
              icon: const Icon(FontAwesomeIcons.facebook,
                  size: 20, color: Colors.white),
              onPressed: () => _launchUrlString(facebookUrl),
            ),
            IconButton(
              icon: const Icon(FontAwesomeIcons.instagram,
                  size: 20, color: Colors.white),
              onPressed: () => _launchUrlString(instagramUrl),
            ),
            IconButton(
              icon: const Icon(FontAwesomeIcons.linkedin,
                  size: 20, color: Colors.white),
              onPressed: () => _launchUrlString(linkedInUrl),
            ),
          ],
        ),
      ],
    );
  }
}

class _HeroPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (double i = -size.height; i < size.width + size.height; i += 40) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MapGridPainter extends CustomPainter {
  final double animationValue;

  _MapGridPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    for (double i = 0; i < size.height; i += 35) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), gridPaint);
    }

    for (double i = 0; i < size.width; i += 45) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), gridPaint);
    }

    final roadPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(0, size.height * 0.65),
      Offset(size.width, size.height * 0.35),
      roadPaint,
    );

    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width * 0.35;
    final currentRadius = maxRadius * animationValue;

    final radarPaint = Paint()
      ..color = Colors.white.withOpacity((1 - animationValue) * 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawCircle(center, currentRadius, radarPaint);
  }

  @override
  bool shouldRepaint(covariant _MapGridPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}