import 'dart:convert';
import 'dart:math' as math;
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

class _ContactState extends State<Contact> with TickerProviderStateMixin {
  int _selectedIndex = 5;
  int _selectedFormCategory = 0;

  // ===== THEME (matches home_page.dart) =====
  static const Color royalBlue = Color(0xFF0A1F44);
  static const Color royalBlueMid = Color(0xFF0F2A5C);
  static const Color darkBg = Color(0xFF0A1F44);
  static const Color darkCardBg = Color(0xFF0D2551);
  static const Color glassCard = Color(0xFF13315C);

  static const Color accentGold = Color(0xFFF5C842);
  static const Color accentGoldDeep = Color(0xFFD4A017);
  static const Color accentGoldSoft = Color(0xFFFFE08A);

  static const Color accentCyan = Color(0xFF4FC3F7);
  static const Color accentCyanGlow = Color(0xFF29B6F6);
  static const Color brandBlue = Color(0xFF1E88E5);

  static const Color accentWhite = Colors.white;
  static const Color textMuted = Color(0xFFB8D4F0);
  static const Color textSoft = Color(0xFFD6E6FA);

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
  late AnimationController _orbController;
  late AnimationController _pulseController;

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

    _orbController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _radarAnimationController.dispose();
    _orbController.dispose();
    _pulseController.dispose();
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

  // ============================================================
  // API SUBMISSION — PRESERVED EXACTLY
  // ============================================================
  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);

      final List<String> categories = [
        "General Inquiry",
        "Get Quote",
        "Support"
      ];
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
          setState(() => _serviceDr = null);
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
        if (mounted) setState(() => _isSubmitting = false);
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
        child: _buildAppBar(isDesktop),
      ),
      endDrawer: _buildEndDrawer(screenWidth, isDesktop),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
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
            child: _buildOrnamentDivider(),
          ),
          SliverToBoxAdapter(
            child: _buildAGFooter(context),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // APP BAR
  // ============================================================
  PreferredSizeWidget _buildAppBar(bool isDesktop) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(75),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              royalBlue,
              royalBlueMid,
            ],
          ),
          border: Border(
            bottom: BorderSide(
              color: accentGold.withOpacity(0.6),
              width: 1.5,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: accentCyan.withOpacity(0.15),
              blurRadius: 14,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          elevation: 0,
          titleSpacing: 0,
          title: _buildLogoHeader(),
          actions: [
            Builder(
              builder: (context) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () => Scaffold.of(context).openEndDrawer(),
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            accentGold.withOpacity(0.22),
                            accentGoldDeep.withOpacity(0.12),
                          ],
                        ),
                        border: Border.all(
                          color: accentGold.withOpacity(0.7),
                          width: 1.4,
                        ),
                      ),
                      child: const Icon(
                        Icons.menu_rounded,
                        color: accentGold,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoHeader() {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  accentGold.withOpacity(0.25),
                  accentGoldDeep.withOpacity(0.12),
                ],
              ),
              border: Border.all(
                color: accentGold.withOpacity(0.7),
                width: 1.2,
              ),
            ),
            child: const Icon(
              Icons.workspace_premium_rounded,
              color: accentGold,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [
                  accentGoldSoft,
                  accentGold,
                  accentGoldDeep,
                ],
              ).createShader(bounds),
              child: Text(
                "We are\nGrow Socialee",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.bellota(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.05,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // END DRAWER
  // ============================================================
  Widget _buildEndDrawer(double screenWidth, bool isDesktop) {
    return Drawer(
      width: isDesktop ? 380 : math.min(screenWidth * 0.85, 340),
      backgroundColor: royalBlue,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding:
              const EdgeInsets.symmetric(vertical: 28.0, horizontal: 16.0),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    royalBlueMid,
                    glassCard,
                  ],
                ),
              ),
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
            Divider(
                height: 1, thickness: 1, color: accentGold.withOpacity(0.4)),
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
                            builder: (context) => const HomePage()),
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
                    },
                  ),
                ],
              ),
            ),
            Container(
              height: 4,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    accentGoldSoft,
                    accentGold,
                    accentGoldDeep,
                  ],
                ),
              ),
            ),
          ],
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
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? const LinearGradient(
                colors: [
                  accentGoldSoft,
                  accentGold,
                  accentGoldDeep,
                ],
              )
                  : null,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isSelected ? const Color(0xFF1A1200) : Colors.white,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: GoogleFonts.bellota(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? const Color(0xFF1A1200)
                          : Colors.white,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                if (isSelected)
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: Color(0xFF1A1200),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HERO BANNER — Left: chapter + headline, Right: trust strip card
  // ============================================================
  Widget _buildAGHeroBanner(double screenWidth, bool isDesktop) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0.6, -0.3),
          radius: 1.4,
          colors: [
            Color(0xFF173F7B),
            royalBlue,
            Color(0xFF061733),
          ],
        ),
      ),
      child: Stack(
        children: [
          ..._buildFloatingOrbs(),
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    accentGold.withOpacity(0.10),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Opacity(
              opacity: 0.08,
              child: CustomPaint(painter: _HeroPatternPainter()),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: isDesktop ? 90 : 50,
              horizontal: isDesktop ? 60 : 22,
            ),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: isDesktop
                    ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 6,
                      child: _buildHeroLeftText(),
                    ),
                    const SizedBox(width: 40),
                    Expanded(
                      flex: 5,
                      child: _buildTrustStripCard(),
                    ),
                  ],
                )
                    : Column(
                  children: [
                    _buildHeroLeftText(),
                    const SizedBox(height: 32),
                    _buildTrustStripCard(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroLeftText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Chapter pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
          decoration: BoxDecoration(
            color: accentGold.withOpacity(0.12),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: accentGold.withOpacity(0.6),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: accentGold.withOpacity(0.10),
                blurRadius: 10,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.chat_bubble_outline_rounded,
                size: 14,
                color: accentGold,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  "CHAPTER 06 · GET IN TOUCH",
                  style: GoogleFonts.bellota(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: accentGold,
                    letterSpacing: 2.2,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Text(
          "Let's Build Something",
          style: GoogleFonts.bellota(
            fontSize: 26,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            height: 1.15,
          ),
        ),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [
              accentGoldSoft,
              accentGold,
              accentGoldDeep,
            ],
          ).createShader(bounds),
          child: Text(
            "Great Together.",
            style: GoogleFonts.bellota(
              fontSize: 46,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.05,
              letterSpacing: -1,
            ),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          "Get prompt responses from a friendly, professional and knowledgeable team.",
          style: GoogleFonts.bellota(
            fontSize: 15,
            color: textSoft,
            height: 1.6,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 28),
        Wrap(
          spacing: 14,
          runSpacing: 12,
          children: [
            _buildGoldGradientButton(
              icon: Icons.phone_rounded,
              label: "CALL NOW",
              onTap: () => _makePhoneCall(phoneNum),
            ),
            _buildGlassOutlineButton(
              icon: Icons.email_rounded,
              label: "EMAIL US",
              onTap: () => _sendEmail(emailAddr),
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // TRUST STRIP CARD (from uploaded image, side of chapter)
  // ============================================================
  Widget _buildTrustStripCard() {
    final List<Map<String, dynamic>> trustItems = [
      {
        "icon": Icons.flash_on_rounded,
        "label": "FAST RESPONSE",
      },
      {
        "icon": Icons.verified_rounded,
        "label": "TRUSTED AGENCY",
      },
      {
        "icon": Icons.support_agent_rounded,
        "label": "24/7 SUPPORT",
      },
      {
        "icon": Icons.location_city_rounded,
        "label": "BHAVNAGAR HQ",
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.08),
            Colors.white.withOpacity(0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: accentCyan.withOpacity(0.35),
          width: 1.3,
        ),
        boxShadow: [
          BoxShadow(
            color: accentCyan.withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, _) {
                      return Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: accentCyan,
                          boxShadow: [
                            BoxShadow(
                              color: accentCyan.withOpacity(
                                  0.4 + 0.5 * _pulseController.value),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "WHY CHOOSE US",
                    style: GoogleFonts.bellota(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: accentCyan,
                      letterSpacing: 2.0,
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.green.withOpacity(0.5),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.greenAccent,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "OPEN",
                      style: GoogleFonts.bellota(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                        color: Colors.greenAccent,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          // Trust items in 2x2 grid
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: trustItems.map((item) {
              return _buildTrustChip(
                icon: item["icon"] as IconData,
                label: item["label"] as String,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTrustChip({
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accentCyan.withOpacity(0.08),
            accentCyan.withOpacity(0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: accentCyan.withOpacity(0.4),
          width: 1.2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accentCyan.withOpacity(0.15),
              border: Border.all(
                color: accentCyan.withOpacity(0.5),
                width: 1,
              ),
            ),
            child: Icon(icon, color: accentCyan, size: 14),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: GoogleFonts.bellota(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: accentWhite,
              letterSpacing: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFloatingOrbs() {
    return [
      AnimatedBuilder(
        animation: _orbController,
        builder: (context, _) {
          final t = _orbController.value * 2 * math.pi;
          return Positioned(
            top: 100 + math.sin(t) * 30,
            left: 40 + math.cos(t) * 20,
            child: _orb(140, accentCyan.withOpacity(0.10)),
          );
        },
      ),
      AnimatedBuilder(
        animation: _orbController,
        builder: (context, _) {
          final t = _orbController.value * 2 * math.pi + 1.5;
          return Positioned(
            bottom: 80 + math.sin(t) * 40,
            right: 60 + math.cos(t) * 30,
            child: _orb(180, accentGold.withOpacity(0.08)),
          );
        },
      ),
      AnimatedBuilder(
        animation: _orbController,
        builder: (context, _) {
          final t = _orbController.value * 2 * math.pi + 3.0;
          return Positioned(
            top: 300 + math.sin(t) * 25,
            right: 200 + math.cos(t) * 20,
            child: _orb(90, accentCyan.withOpacity(0.14)),
          );
        },
      ),
    ];
  }

  Widget _orb(double size, Color color) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [color, Colors.transparent]),
        ),
      ),
    );
  }

  Widget _buildGoldGradientButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accentGoldSoft,
            accentGold,
            accentGoldDeep,
          ],
        ),
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: accentGold.withOpacity(0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: const Color(0xFF1A1200),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        icon: Icon(icon, size: 18, color: const Color(0xFF1A1200)),
        label: Text(
          label,
          style: GoogleFonts.bellota(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
          ),
        ),
        onPressed: onTap,
      ),
    );
  }

  Widget _buildGlassOutlineButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.white.withOpacity(0.06),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
        side: BorderSide(
          color: accentCyan.withOpacity(0.8),
          width: 1.6,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      icon: Icon(icon, size: 18, color: accentCyan),
      label: Text(
        label,
        style: GoogleFonts.bellota(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.8,
        ),
      ),
      onPressed: onTap,
    );
  }

  // ============================================================
  // ORNAMENT DIVIDER
  // ============================================================
  Widget _buildOrnamentDivider() {
    return Container(
      width: double.infinity,
      color: royalBlueMid,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 1.2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    accentGold.withOpacity(0.6),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Transform.rotate(
              angle: 0.785,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [accentGoldSoft, accentGoldDeep],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: accentGold.withOpacity(0.5),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 60,
              height: 1.2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    accentGold.withOpacity(0.6),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // FORM CARD
  // ============================================================
  Widget _buildInteractiveFormCard() {
    final categories = ["General Inquiry", "Get Quote", "Support"];

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.07),
            Colors.white.withOpacity(0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accentCyan.withOpacity(0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: accentCyan.withOpacity(0.10),
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Send Us A Message",
                        style: GoogleFonts.bellota(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: accentGold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Fill out the form below and we'll reply shortly.",
                        style: GoogleFonts.bellota(
                          fontSize: 14,
                          color: textMuted,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        accentCyan.withOpacity(0.25),
                        accentCyan.withOpacity(0.10),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: accentCyan.withOpacity(0.5)),
                  ),
                  child: const Icon(Icons.send_rounded,
                      color: accentCyan, size: 22),
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
                      selectedColor: accentGold,
                      backgroundColor: royalBlue,
                      labelStyle: GoogleFonts.bellota(
                        color:
                        isSelected ? const Color(0xFF1A1200) : textMuted,
                        fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 13,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: isSelected
                              ? accentGold
                              : accentCyan.withOpacity(0.3),
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
              dropdownColor: royalBlue,
              style:
              GoogleFonts.plusJakartaSans(fontSize: 14, color: Colors.white),
              iconEnabledColor: accentGold,
              decoration: InputDecoration(
                labelText: "Select Service",
                labelStyle:
                GoogleFonts.bellota(color: textMuted, fontSize: 14),
                prefixIcon: const Icon(Icons.cleaning_services_outlined,
                    color: accentCyan, size: 20),
                filled: true,
                fillColor: royalBlue,
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: accentCyan.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: accentGold, width: 1.5),
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
                    style: GoogleFonts.plusJakartaSans(
                        color: Colors.white, fontSize: 14),
                  ),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() => _serviceDr = newValue);
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
              height: 54,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      accentGoldSoft,
                      accentGold,
                      accentGoldDeep,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: accentGold.withOpacity(0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: const Color(0xFF1A1200),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _isSubmitting ? null : _handleSubmit,
                  child: _isSubmitting
                      ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: Color(0xFF1A1200),
                      strokeWidth: 2.5,
                    ),
                  )
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.near_me_rounded,
                          color: Color(0xFF1A1200), size: 20),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          "SUBMIT INQUIRY",
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.bellota(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF1A1200),
                            letterSpacing: 1.1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
      style: GoogleFonts.plusJakartaSans(fontSize: 14, color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.bellota(color: textMuted, fontSize: 14),
        prefixIcon: Icon(icon, color: accentCyan, size: 20),
        filled: true,
        fillColor: royalBlue,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: accentCyan.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: accentGold, width: 1.5),
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

  // ============================================================
  // SIDEBAR CARDS
  // ============================================================
  Widget _buildInteractiveContactSidebar() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                accentGold.withOpacity(0.12),
                accentGoldDeep.withOpacity(0.04),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: accentGold.withOpacity(0.6), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: accentGold.withOpacity(0.20),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [accentGoldSoft, accentGoldDeep],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: accentGold.withOpacity(0.35),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: const Icon(Icons.timer_rounded,
                    color: Color(0xFF1A1200), size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Fast Response Guarantee",
                      style: GoogleFonts.bellota(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "We usually respond within 2 working hours during business times.",
                      style: GoogleFonts.bellota(
                        fontSize: 13,
                        color: textMuted,
                        fontWeight: FontWeight.w300,
                      ),
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
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.06),
                Colors.white.withOpacity(0.02),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: accentCyan.withOpacity(0.3), width: 1.4),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accentCyan.withOpacity(0.15),
                  border: Border.all(color: accentCyan.withOpacity(0.5)),
                ),
                child: Icon(icon, color: accentCyan, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.bellota(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: accentGold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.bellota(
                        fontSize: 13,
                        color: textMuted,
                        height: 1.4,
                        fontWeight: FontWeight.w300,
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
                          color: Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.green.withOpacity(0.6),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedBuilder(
                              animation: _pulseController,
                              builder: (context, _) {
                                return Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Colors.greenAccent,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.greenAccent.withOpacity(
                                            0.4 + 0.5 * _pulseController.value),
                                        blurRadius: 8,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                actionLabel,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.bellota(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.greenAccent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              actionLabel,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.bellota(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: accentCyan,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            size: 14,
                            color: accentCyan,
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

  // ============================================================
  // GOOGLE MAP SECTION (Animated Radar)
  // ============================================================
  Widget _buildGoogleMapSection() {
    return Container(
      width: double.infinity,
      height: 380,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.06),
            Colors.white.withOpacity(0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accentCyan.withOpacity(0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: accentCyan.withOpacity(0.15),
            blurRadius: 20,
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
                  color: royalBlue,
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
                            color: accentCyan.withOpacity(0.25),
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: accentCyan,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.location_on_rounded,
                              size: 28,
                              color: Color(0xFF0A1F44),
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
                  color: royalBlue.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: accentGold, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: accentGold.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: accentGold.withOpacity(0.5),
                        ),
                      ),
                      child: const Icon(Icons.storefront_rounded,
                          color: accentGold, size: 24),
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
                                  style: GoogleFonts.bellota(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(Icons.star_rounded,
                                  size: 16, color: accentGold),
                              const SizedBox(width: 2),
                              Flexible(
                                child: Text(
                                  "4.9 (13)",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: GoogleFonts.bellota(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: accentGold,
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
                            style: GoogleFonts.bellota(
                                fontSize: 12, color: textMuted),
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
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.06),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                              color: accentCyan.withOpacity(0.7), width: 1.5),
                        ),
                      ),
                      onPressed: () => _launchUrlString(googleMapsUrl),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.map_rounded,
                              size: 18, color: accentCyan),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              "View Map",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.bellota(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            accentGoldSoft,
                            accentGold,
                            accentGoldDeep,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: accentGold.withOpacity(0.35),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          foregroundColor: const Color(0xFF1A1200),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => _launchUrlString(googleDirectionsUrl),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.directions_rounded,
                                size: 18, color: Color(0xFF1A1200)),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                "Get Directions",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.bellota(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF1A1200),
                                ),
                              ),
                            ),
                          ],
                        ),
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

  // ============================================================
  // FOOTER
  // ============================================================
  Widget _buildAGFooter(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth > 800;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            royalBlue,
            Color(0xFF05132B),
          ],
        ),
      ),
      child: Column(
        children: [
          Divider(
              height: 1, thickness: 1, color: accentGold.withOpacity(0.4)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 24),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: isDesktop
                    ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 2, child: _buildFooterBrandSection()),
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
            color: const Color(0xFF05132B),
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
          style: GoogleFonts.bellota(
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
          style: GoogleFonts.bellota(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: accentGold,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 16),
        _buildFooterLink(
          icon: Icons.location_on_outlined,
          text: addressQuery,
          onTap: () => _launchUrlString(googleMapsUrl),
          isMultiLine: true,
        ),
        const SizedBox(height: 12),
        _buildFooterLink(
          icon: Icons.phone_outlined,
          text: phoneNum,
          onTap: () => _makePhoneCall(phoneNum),
        ),
        const SizedBox(height: 12),
        _buildFooterLink(
          icon: Icons.email_outlined,
          text: emailAddr,
          onTap: () => _sendEmail(emailAddr),
        ),
      ],
    );
  }

  Widget _buildFooterLink({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    bool isMultiLine = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          crossAxisAlignment:
          isMultiLine ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: accentGold),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                maxLines: isMultiLine ? 3 : 1,
                style: GoogleFonts.bellota(
                  fontSize: 13,
                  color: isMultiLine ? Colors.white : textMuted,
                  height: 1.4,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterSocialSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "CONNECT WITH US",
          style: GoogleFonts.bellota(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: accentGold,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _buildSocialButton(
                icon: FontAwesomeIcons.facebook, url: facebookUrl),
            _buildSocialButton(
                icon: FontAwesomeIcons.instagram, url: instagramUrl),
            _buildSocialButton(
                icon: FontAwesomeIcons.linkedin, url: linkedInUrl),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton({required IconData icon, required String url}) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: accentGold.withOpacity(0.6)),
        boxShadow: [
          BoxShadow(
            color: accentGold.withOpacity(0.10),
            blurRadius: 8,
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, size: 18, color: accentGold),
        onPressed: () => _launchUrlString(url),
      ),
    );
  }
}

// ============================================================
// HERO PATTERN PAINTER
// ============================================================
class _HeroPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFF5C842).withOpacity(0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (double i = -size.height; i < size.width + size.height; i += 40) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }

    final cyanPaint = Paint()
      ..color = const Color(0xFF4FC3F7).withOpacity(0.05)
      ..strokeWidth = 1.2;
    for (double i = -size.height; i < size.width + size.height; i += 80) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        cyanPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ============================================================
// MAP GRID PAINTER (Animated Radar)
// ============================================================
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
      ..color = Colors.white.withOpacity(0.25)
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
      ..color = const Color(0xFF4FC3F7).withOpacity((1 - animationValue) * 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawCircle(center, currentRadius, radarPaint);
  }

  @override
  bool shouldRepaint(covariant _MapGridPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}