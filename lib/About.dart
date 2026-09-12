import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grow_socialee/Client_Logos.dart';
import 'package:grow_socialee/Services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Reviews.dart';
import 'contact.dart';
import 'home_page.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  int _selectedIndex = 1;

  final GlobalKey<_ValuesSectionState> _valuesKey = GlobalKey<_ValuesSectionState>();
  final GlobalKey<_TeamSectionState> _teamKey = GlobalKey<_TeamSectionState>();

  // Color Palette aligned with HomePage theme
  static const Color brandBlue = Color(0xFF1B64B1);
  static const Color darkBg = Color(0xFF144F8E);
  static const Color darkCardBg = Color(0xFF0F3E72);
  static const Color accentWhite = Colors.white;
  static const Color textMuted = Color(0xFFD0E1F9);

  final String addressQuery =
      "First Floor, Leela Efcee, 103, Waghawadi Rd., Hill Drive, Bhavnagar, Gujarat 364002";
  final String phoneNum = "+919408518168";
  final String emailAddr = "growsocialee@gmail.com";
  final String googleMapsUrl =
      "https://maps.google.com/?q=Leela+Efcee+Bhavnagar+Gujarat";

  final String facebookUrl = "https://www.facebook.com/growsocialeeofficial/";
  final String instagramUrl = "https://www.instagram.com/growsocialee.official/";
  final String linkedInUrl = "https://in.linkedin.com/company/grow-socialee";

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

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth > 800;

    return Scaffold(
      backgroundColor: darkBg,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75),
        child: Container(
          decoration: const BoxDecoration(
            color: darkBg,
            border: Border(bottom: BorderSide(color: Colors.white24, width: 1)),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            elevation: 0,
            titleSpacing: 0,
            title: _buildLogoHeader(),
            actions: [
              Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu_rounded, color: Colors.white, size: 28),
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                ),
              ),
              const SizedBox(width: 12),
            ],
          ),
        ),
      ),
      endDrawer: Drawer(
        width: isDesktop ? 360 : screenWidth * 0.8,
        backgroundColor: darkBg,
        child: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 28.0, horizontal: 16.0),
                color: darkCardBg,
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
                            builder: (context) => const ClientLogoPage(),
                          ),
                        );
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
                            builder: (context) => const Services(),
                          ),
                        );
                      },
                    ),
                    _buildDrawerItem(
                      index: 4,
                      icon: Icons.chat_bubble_outline_rounded,
                      label: "REVIEWS",
                      onTap: () {
                        setState(() => _selectedIndex = 4);
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Reviews()));
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
                            builder: (context) => const Contact(),
                          ),
                        );
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
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          _valuesKey.currentState?.checkVisibility();
          _teamKey.currentState?.checkVisibility();
          return false;
        },
        child: CustomScrollView(
          slivers: [
            // AG Modern Creative Hero Banner
            SliverToBoxAdapter(
              child: _buildAGHeroBanner(screenWidth, isDesktop),
            ),

            // Detailed Overview & Vision Section
            SliverToBoxAdapter(
              child: Container(
                color: darkBg,
                padding: EdgeInsets.symmetric(
                  vertical: 60,
                  horizontal: isDesktop ? 60 : 20,
                ),
                child: isDesktop
                    ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: _buildAboutImageCard()),
                    const SizedBox(width: 50),
                    Expanded(child: _buildAboutDescription()),
                  ],
                )
                    : Column(
                  children: [
                    _buildAboutImageCard(),
                    const SizedBox(height: 40),
                    _buildAboutDescription(),
                  ],
                ),
              ),
            ),

            // Core Capabilities & Expertise Grid Section
            SliverToBoxAdapter(
              child: _buildCapabilitiesSection(isDesktop),
            ),

            // Core Values & Pillars Cards Section
            SliverToBoxAdapter(
              child: ValuesSection(key: _valuesKey, isDesktop: isDesktop),
            ),

            // Leadership Team Section
            SliverToBoxAdapter(
              child: TeamSection(key: _teamKey, isDesktop: isDesktop),
            ),

            // Footer Section
            SliverToBoxAdapter(
              child: _buildFooter(context),
            ),
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
        children: [
          SizedBox(
            height: 50,
            child: Text(
              "We are \n Grow Socialee",
              style: GoogleFonts.aleo(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
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
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: darkBg,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // AG Dark Creative Hero Banner
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
                painter: _AboutHeroPatternPainter(),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: isDesktop ? 100 : 60,
              horizontal: isDesktop ? 80 : 24,
            ),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 950),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.white30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.auto_awesome_rounded,
                              size: 16, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            "WHO WE ARE",
                            style: GoogleFonts.cinzel(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 2.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Crafting Digital Legacies Through Strategic Innovation.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.aleo(
                        fontSize: isDesktop ? 48 : 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.2,
                        letterSpacing: -0.5,
                      ),
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

  // Styled Image Card
  Widget _buildAboutImageCard() {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 480),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            "assets/photos/image.png",
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 320,
              color: darkCardBg,
              child: const Icon(Icons.business_rounded, size: 60, color: textMuted),
            ),
          ),
        ),
      ),
    );
  }

  // Detailed Text Description
  Widget _buildAboutDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "ABOUT GROW SOCIALEE",
          style: GoogleFonts.cinzel(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 2.0,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Innovating Digital Excellence in Bhavnagar",
          style: GoogleFonts.aleo(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "We are Grow Socialee—a full-suite digital marketing agency based in Bhavnagar committed to scaling small and medium enterprises. Modern market dynamics demand more than an online presence; they require digital dominance.",
          textAlign: TextAlign.justify,
          style: GoogleFonts.alexandria(
            fontSize: 15,
            color: textMuted,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          "From custom social media strategies and video editing production to conversion-focused ad campaigns and brand identity design, our tailored solutions eliminate complexity and generate sustainable revenue growth.",
          textAlign: TextAlign.justify,
          style: GoogleFonts.alexandria(
            fontSize: 15,
            color: textMuted,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          "At Grow Socialee, we believe every brand has a unique story waiting to be told. We combine creative thinking, strategic planning, and digital technology to transform ideas into impactful brand experiences that connect with the right audience and build lasting relationships.",
          textAlign: TextAlign.justify,
          style: GoogleFonts.alexandria(
            fontSize: 15,
            color: textMuted,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Contact()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: darkBg,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          icon: const Icon(Icons.arrow_forward_rounded, size: 18),
          label: Text(
            "WORK WITH US",
            style: GoogleFonts.aleo(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
        ),
      ],
    );
  }

  // Expanded Capabilities & Service Highlights Section
  Widget _buildCapabilitiesSection(bool isDesktop) {
    final capabilities = [
      {
        "title": "Brand Strategy & Design",
        "desc": "Positioning your business with robust brand identities, logo assets, and visual guidelines.",
        "icon": Icons.palette_outlined,
      },
      {
        "title": "Social Media Growth",
        "desc": "End-to-end community management, content curation, and data analytics across all platforms.",
        "icon": Icons.share_rounded,
      },
      {
        "title": "High-Impact Video Production",
        "desc": "Short-form video editing, brand reels, and promo ads designed to maximize audience engagement.",
        "icon": Icons.movie_filter_outlined,
      },
      {
        "title": "Targeted Performance Ads",
        "desc": "Precision advertising campaigns across Google & Meta to drive measurable ROI.",
        "icon": Icons.ads_click_rounded,
      },
    ];

    return Container(
      color: Colors.white70,
      padding: EdgeInsets.symmetric(
        vertical: 70,
        horizontal: isDesktop ? 60 : 20,
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            children: [
              Text("WHAT WE BRING TO THE TABLE", style: GoogleFonts.cinzel(fontSize: 12, fontWeight: FontWeight.bold, color: darkBg, letterSpacing: 2.0)),
              const SizedBox(height: 10),
              Text("Integrated Digital Expertise", textAlign: TextAlign.center, style: GoogleFonts.aleo(fontSize: isDesktop ? 32 : 24, fontWeight: FontWeight.w800, color: darkCardBg)),
              const SizedBox(height: 40),
              LayoutBuilder(
                builder: (context, constraints) {
                  return Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    children: capabilities.map((cap) {
                      double cardWidth = isDesktop
                          ? (constraints.maxWidth - 20) / 2
                          : constraints.maxWidth;
                      return SizedBox(
                        width: cardWidth,
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: darkCardBg,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: darkCardBg.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(cap["icon"] as IconData, color: Colors.white, size: 28)
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(cap["title"] as String, style: GoogleFonts.aleo(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                                    const SizedBox(height: 6),
                                    Text(cap["desc"] as String, style: GoogleFonts.alexandria(fontSize: 14, color: Colors.white70, height: 1.5)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Footer Section
  Widget _buildFooter(BuildContext context) {
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
                    Expanded(flex: 2, child: _buildFooterContactSection()),
                    const SizedBox(width: 40),
                    Expanded(flex: 1, child: _buildFooterSocialSection()),
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
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "Empowering businesses through digital strategies, branding, video production, and social media solutions.",
          style: GoogleFonts.plusJakartaSans(
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
              const Icon(Icons.location_on_outlined, size: 18, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  addressQuery,
                  style: GoogleFonts.plusJakartaSans(
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
          child: Row(
            children: [
              const Icon(Icons.phone_outlined, size: 18, color: Colors.white),
              const SizedBox(width: 10),
              Text(
                phoneNum,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: textMuted,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () => _sendEmail(emailAddr),
          child: Row(
            children: [
              const Icon(Icons.email_outlined, size: 18, color: Colors.white),
              const SizedBox(width: 10),
              Text(
                emailAddr,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: textMuted,
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
        Row(
          children: [
            IconButton(
              icon: const Icon(FontAwesomeIcons.facebook, size: 20, color: Colors.white),
              onPressed: () => _launchUrlString(facebookUrl),
            ),
            IconButton(
              icon: const Icon(FontAwesomeIcons.instagram, size: 20, color: Colors.white),
              onPressed: () => _launchUrlString(instagramUrl),
            ),
            IconButton(
              icon: const Icon(FontAwesomeIcons.linkedin, size: 20, color: Colors.white),
              onPressed: () => _launchUrlString(linkedInUrl),
            ),
          ],
        ),
      ],
    );
  }
}

// Background Grid Painter for Hero Banner
class _AboutHeroPatternPainter extends CustomPainter {
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

// Mission, Vision & Pillars Cards
class ValuesSection extends StatefulWidget {
  final bool isDesktop;

  const ValuesSection({super.key, required this.isDesktop});

  @override
  State<ValuesSection> createState() => _ValuesSectionState();
}

class _ValuesSectionState extends State<ValuesSection> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<Offset> _leftToRightAnimation;
  late Animation<Offset> _topToBottomAnimation;
  late Animation<Offset> _rightToLeftAnimation;
  late Animation<double> _fadeAnimation;

  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _leftToRightAnimation = Tween<Offset>(
      begin: const Offset(-0.3, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic));

    _topToBottomAnimation = Tween<Offset>(
      begin: const Offset(0.0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic));

    _rightToLeftAnimation = Tween<Offset>(
      begin: const Offset(0.3, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic));

    _fadeAnimation = CurvedAnimation(parent: _animController, curve: Curves.easeIn);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkVisibility();
    });
  }

  void checkVisibility() {
    if (_hasAnimated) return;

    final RenderObject? renderObject = context.findRenderObject();
    if (renderObject is RenderBox && renderObject.hasSize) {
      final position = renderObject.localToGlobal(Offset.zero);
      final screenHeight = MediaQuery.of(context).size.height;

      if (position.dy < screenHeight - 100 && (position.dy + renderObject.size.height) > 0) {
        _hasAnimated = true;
        _animController.forward();
      }
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final missionCard = _buildCard(
      icon: Icons.trending_up_rounded,
      title: "Our Mission",
      content: Text(
        "To simplify digital growth for businesses by delivering impactful branding, creative visual design, strategic social media engagement, and revenue-focused advertising campaigns.",
        style: GoogleFonts.alexandria(fontSize: 14, color: _AboutState.darkBg, height: 1.5, fontWeight: FontWeight.w400),
      ),
    );

    final visionCard = _buildCard(
      icon: Icons.visibility_outlined,
      title: "Our Vision",
      content: Text(
        "To empower small and medium enterprises to establish distinct online identities and gain competitive advantages in an ever-evolving digital world.",
        style: GoogleFonts.alexandria(fontSize: 14, color: _AboutState.darkBg, height: 1.5, fontWeight: FontWeight.w400),
      ),
    );

    final pillarsCard = _buildCard(
      icon: Icons.workspace_premium_outlined,
      title: "Brand Pillars",
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPillarPoint("1. Clarity First: ", "Demystifying complex marketing avenues for actionable execution."),
          const SizedBox(height: 8),
          _buildPillarPoint("2. Tailored Growth: ", "Custom strategies engineered around your exact commercial goals."),
          const SizedBox(height: 8),
          _buildPillarPoint("3. Dedicated Focus: ", "Hands-on partnership supporting every step of your digital scale."),
        ],
      ),
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      color: const Color(0xFF144F8E),
      child: Column(
        children: [
          Text(
            "CORE PHILOSOPHY",
            style: GoogleFonts.cinzel(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Driven by Strategy & Purpose",
            style: GoogleFonts.aleo(
              fontSize: widget.isDesktop ? 32 : 24,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 40),
          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: widget.isDesktop
                  ? IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: SlideTransition(
                        position: _leftToRightAnimation,
                        child: FadeTransition(opacity: _fadeAnimation, child: missionCard),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: SlideTransition(
                        position: _topToBottomAnimation,
                        child: FadeTransition(opacity: _fadeAnimation, child: visionCard),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: SlideTransition(
                        position: _rightToLeftAnimation,
                        child: FadeTransition(opacity: _fadeAnimation, child: pillarsCard),
                      ),
                    ),
                  ],
                ),
              )
                  : Column(
                children: [
                  SlideTransition(
                    position: _leftToRightAnimation,
                    child: FadeTransition(opacity: _fadeAnimation, child: missionCard),
                  ),
                  const SizedBox(height: 20),
                  SlideTransition(
                    position: _topToBottomAnimation,
                    child: FadeTransition(opacity: _fadeAnimation, child: visionCard),
                  ),
                  const SizedBox(height: 20),
                  SlideTransition(
                    position: _rightToLeftAnimation,
                    child: FadeTransition(opacity: _fadeAnimation, child: pillarsCard),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPillarPoint(String boldTitle, String text) {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.alexandria(fontSize: 13, color: const Color(0xFFD0E1F9), height: 1.4, fontWeight: FontWeight.bold),
        children: [
          TextSpan(
            text: boldTitle,
            style: GoogleFonts.alexandria(fontSize: 14, color: _AboutState.darkCardBg, height: 1.5, fontWeight: FontWeight.bold),
          ),
          TextSpan(text: text,   style: GoogleFonts.alexandria(fontSize: 14, color: _AboutState.darkBg, height: 1.5, fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required Widget content,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: _AboutState.darkCardBg, size: 26),
          ),
          const SizedBox(height: 20),
          Text(title, style: GoogleFonts.aleo(fontSize: 20, fontWeight: FontWeight.bold, color: HomePage.darkCardBg)),
          const SizedBox(height: 12),
          content,
        ],
      ),
    );
  }
}

// Leadership Team Component
class TeamSection extends StatefulWidget {
  final bool isDesktop;

  const TeamSection({super.key, required this.isDesktop});

  @override
  State<TeamSection> createState() => _TeamSectionState();
}

class _TeamSectionState extends State<TeamSection> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<Offset> _leftToRightAnimation;
  late Animation<Offset> _topToBottomAnimation;
  late Animation<Offset> _rightToLeftAnimation;
  late Animation<double> _fadeAnimation;

  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _leftToRightAnimation = Tween<Offset>(
      begin: const Offset(-0.3, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic));

    _topToBottomAnimation = Tween<Offset>(
      begin: const Offset(0.0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic));

    _rightToLeftAnimation = Tween<Offset>(
      begin: const Offset(0.3, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic));

    _fadeAnimation = CurvedAnimation(parent: _animController, curve: Curves.easeIn);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkVisibility();
    });
  }

  void checkVisibility() {
    if (_hasAnimated) return;

    final RenderObject? renderObject = context.findRenderObject();
    if (renderObject is RenderBox && renderObject.hasSize) {
      final position = renderObject.localToGlobal(Offset.zero);
      final screenHeight = MediaQuery.of(context).size.height;

      if (position.dy < screenHeight - 100 && (position.dy + renderObject.size.height) > 0) {
        _hasAnimated = true;
        _animController.forward();
      }
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final founderCard = _buildTeamCard(
      name: "Shaily Shah",
      designation: "Founder",
    );

    final managerCard = _buildTeamCard(
      name: "Umesh Baraiya",
      designation: "Manager",
    );

    final subManagerCard = _buildTeamCard(
      name: "Vaibhavsinh Jadeja",
      designation: "Sub Manager",
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      color: Colors.white70,
      child: Column(
        children: [
          Text(
            "MEET OUR LEADERSHIP", style: GoogleFonts.cinzel(fontSize: 12, fontWeight: FontWeight.bold, color: _AboutState.darkBg, letterSpacing: 2.0,)),
          const SizedBox(height: 10),
          Text(
            "The Minds Behind the Agency", style: GoogleFonts.aleo(fontSize: widget.isDesktop ? 32 : 24, fontWeight: FontWeight.w800, color: HomePage.darkCardBg)),
          const SizedBox(height: 40),
          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: widget.isDesktop
                  ? IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: SlideTransition(
                        position: _leftToRightAnimation,
                        child: FadeTransition(opacity: _fadeAnimation, child: founderCard),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: SlideTransition(
                        position: _topToBottomAnimation,
                        child: FadeTransition(opacity: _fadeAnimation, child: managerCard),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: SlideTransition(
                        position: _rightToLeftAnimation,
                        child: FadeTransition(opacity: _fadeAnimation, child: subManagerCard),
                      ),
                    ),
                  ],
                ),
              )
                  : Column(
                children: [
                  SlideTransition(
                    position: _leftToRightAnimation,
                    child: FadeTransition(opacity: _fadeAnimation, child: founderCard),
                  ),
                  const SizedBox(height: 20),
                  SlideTransition(
                    position: _topToBottomAnimation,
                    child: FadeTransition(opacity: _fadeAnimation, child: managerCard),
                  ),
                  const SizedBox(height: 20),
                  SlideTransition(
                    position: _rightToLeftAnimation,
                    child: FadeTransition(opacity: _fadeAnimation, child: subManagerCard),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamCard({
    required String name,
    required String designation,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: const Color(0xFF144F8E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white.withOpacity(0.15),
            child: const Icon(Icons.person_rounded, size: 45, color: Colors.white),
          ),
          const SizedBox(height: 18),
          Text(
            name,
            textAlign: TextAlign.center,
            style: GoogleFonts.aleo(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            designation.toUpperCase(),
            textAlign: TextAlign.center,
            style: GoogleFonts.cinzel(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFD0E1F9),
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}