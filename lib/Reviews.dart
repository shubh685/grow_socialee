import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grow_socialee/About.dart';
import 'package:grow_socialee/Client_Logos.dart';
import 'package:grow_socialee/Services.dart';
import 'package:grow_socialee/contact.dart';
import 'package:grow_socialee/home_page.dart';
import 'package:url_launcher/url_launcher.dart';

class Reviews extends StatefulWidget {
  const Reviews({super.key});

  @override
  State<Reviews> createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  int _selectedIndex = 4; // Reviews tab active

  // Base Blue & White Theme matched with HomePage
  static const Color brandBlue = Color(0xFF1B64B1);
  static const Color darkBg = Color(0xFF144F8E);
  static const Color darkCardBg = Color(0xFF0F3E72);
  static const Color accentWhite = Colors.white;
  static const Color textMuted = Color(0xFFD0E1F9);

  // Eye-Catching Secondary Accent Colors from HomePage
  static const Color accentGold = Color(0xFFFFB703);
  static const Color accentCyan = Color(0xFF00E5FF);

  final ScrollController _scrollController = ScrollController();
  final GlobalKey<_StatsSectionState> _statsKey = GlobalKey<_StatsSectionState>();

  final String addressQuery =
      "First Floor, Leela Efcee, 103, Waghawadi Rd., Hill Drive, Bhavnagar, Gujarat 364002";
  final String phoneNum = "+919408518168";
  final String emailAddr = "growsocialee@gmail.com";
  final String googleMapsUrl =
      "https://maps.google.com/?q=Leela+Efcee+Bhavnagar+Gujarat";
  final String googleReviewsUrl =
      "https://www.google.com/maps/place/Grow+Socialee,+Social+Media+Marketing+Agency+in+Bhavnagar/@21.7521703,72.1422254,17z/data=!3m1!5s0x395f5a7614a4fc37:0xb6b7c2fd5ec85477!4m16!1m9!3m8!1s0x395f5bda3e409bdf:0x9c73e4385ba146c5!2sGrow+Socialee,+Social+Media+Marketing+Agency+in+Bhavnagar!8m2!3d21.7521703!4d72.1422254!9m1!1b1!16s%2Fg%2F11js22bbxs!3m5!1s0x395f5bda3e409bdf:0x9c73e4385ba146c5!8m2!3d21.7521703!4d72.1422254!16s%2Fg%2F11js22bbxs?entry=ttu&g_ep=EgoyMDI2MDkwMi4wIKXMDSoASAFQAw%3D%3D";

  final String facebookUrl = "https://www.facebook.com/growsocialeeofficial/";
  final String instagramUrl = "https://www.instagram.com/growsocialee.official/";
  final String linkedInUrl = "https://in.linkedin.com/company/grow-socialee";

  // Detailed Client Reviews List
  final List<Map<String, String>> clientReviews = [
    {
      "name": "Dr. Jinali Modi",
      "company": "Body Mind Soul",
      "rating": "5.0",
      "review":
      "Growsocialee has been helping me for my social media management and Shaily the founder has been extremely professional, she is very helpful and always available for any questions. She is very cooperative in her approach, she has in depth knowledge of how this social media marketing works and knows the right things to do. She is very creative and her team also brings the vision to life.",
      "tag": "Hospital Marketing",
      "isFeatured": "true"
    },
    {
      "name": "Venisha Chitalia",
      "company": "Bindu Decorators",
      "rating": "4.0",
      "review":
      "I am pleased with the social media management services provided. They have effectively increased my followers, achieving the target set within the expected timeframe. Their strategic approach delivered great value for money, and their consistent efforts have helped enhance my brand’s online presence.",
      "tag": "Brand Marketing",
      "isFeatured": "false"
    },
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScrollCheck);
  }

  void _onScrollCheck() {
    if (mounted) {
      _statsKey.currentState?.checkVisibility();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScrollCheck);
    _scrollController.dispose();
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

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth > 800;

    return Scaffold(
      backgroundColor: darkBg,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75),
        child: Container(
          decoration: BoxDecoration(
            color: darkBg,
            border: Border(bottom: BorderSide(color: accentCyan.withOpacity(0.3), width: 1.5)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
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
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu_rounded, color: accentGold, size: 28),
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
              Divider(height: 1, thickness: 1, color: accentCyan.withOpacity(0.3)),
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
                          MaterialPageRoute(builder: (context) => const HomePage()),
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
                          MaterialPageRoute(builder: (context) => const About()),
                        );
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
                          MaterialPageRoute(builder: (context) => const ClientLogoPage()),
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
                          MaterialPageRoute(builder: (context) => const Services()),
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
                          MaterialPageRoute(builder: (context) => const Contact()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Container(height: 4, color: accentGold)
            ],
          ),
        ),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Hero Banner matching HomePage gradient and typography
          SliverToBoxAdapter(
            child: _buildHeroBanner(screenWidth, isDesktop),
          ),

          // Highlighting Auto-Scrolling Counter Stats Bar
          SliverToBoxAdapter(
            child: StatsSection(key: _statsKey, isDesktop: isDesktop),
          ),

          // Highlighted Featured Review Spotlight
          SliverToBoxAdapter(
            child: _buildFeaturedReviewSpotlight(isDesktop),
          ),

          // Alternating Card Style Review Showcase
          SliverToBoxAdapter(
            child: _buildReviewsSection(isDesktop),
          ),

          // Google Review Call-To-Action Container
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: _buildGoogleReviewCTA(),
                ),
              ),
            ),
          ),

          // HomePage Matching Footer Section
          SliverToBoxAdapter(
            child: _buildFooter(context),
          ),
        ],
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
          Flexible(
            child: Text(
              "We are \n Grow Socialee",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.bellota(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.0,
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
              color: isSelected ? accentGold : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(icon, size: 20, color: isSelected ? Colors.black : Colors.white),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: GoogleFonts.bellota(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.black87 : Colors.white,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.black),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroBanner(double screenWidth, bool isDesktop) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            darkBg,
            darkCardBg,
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.10,
              child: Image.asset(
                "assets/photos/image.png",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const SizedBox(),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: isDesktop ? 110 : 65,
              horizontal: isDesktop ? 80 : 24,
            ),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 950),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: accentCyan.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: accentCyan.withOpacity(0.6)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded, size: 16, color: accentCyan),
                          const SizedBox(width: 8),
                          Text(
                            "CLIENT TESTIMONIALS",
                            style: GoogleFonts.bellota(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: accentCyan,
                              letterSpacing: 2.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Proven Impact & Authentic Client Voices.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.bellota(
                        fontSize: isDesktop ? 48 : 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Discover real experiences from brand owners and business partners who transformed their digital footprint with Grow Socialee.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.bellota(
                        fontSize: isDesktop ? 17 : 13,
                        color: textMuted,
                        height: 1.6,
                        fontWeight: FontWeight.w300,
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

  Widget _buildFeaturedReviewSpotlight(bool isDesktop) {
    final featured = clientReviews.firstWhere((r) => r["isFeatured"] == "true");

    return Container(
      color: darkBg,
      padding: EdgeInsets.symmetric(
        vertical: 40,
        horizontal: isDesktop ? 60 : 20,
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1100),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: darkCardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: accentGold, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: accentGold,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "FEATURED STORY",
                      style: GoogleFonts.bellota(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  Row(
                    children: List.generate(
                      5,
                          (index) => const Icon(Icons.star_rounded, color: accentGold, size: 20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                "\"${featured["review"]!}\"",
                style: GoogleFonts.bellota(
                  fontSize: isDesktop ? 16 : 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                  height: 1.6,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: accentGold,
                    child: Text(
                      featured["name"]![0],
                      style: GoogleFonts.bellota(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        featured["name"]!,
                        style: GoogleFonts.bellota(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: accentGold,
                        ),
                      ),
                      Text(
                        featured["company"]!,
                        style: GoogleFonts.bellota(
                          fontSize: 13,
                          color: textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReviewsSection(bool isDesktop) {
    return Container(
      width: double.infinity,
      color: Colors.white60,
      padding: EdgeInsets.symmetric(
        vertical: 70,
        horizontal: isDesktop ? 60 : 20,
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: darkCardBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text("CLIENT STORIES", style: GoogleFonts.bellota(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 2.0)),
              ),
              const SizedBox(height: 10),
              Text(
                "What People Say About Grow Socialee",
                textAlign: TextAlign.center,
                style: GoogleFonts.bellota(
                  fontSize: isDesktop ? 34 : 24,
                  fontWeight: FontWeight.bold,
                  color: darkCardBg,
                ),
              ),
              const SizedBox(height: 40),
              LayoutBuilder(
                builder: (context, constraints) {
                  return Wrap(
                    spacing: 24,
                    runSpacing: 24,
                    alignment: WrapAlignment.center,
                    children: clientReviews.map((rev) {
                      double cardWidth = isDesktop
                          ? (constraints.maxWidth - 24) / 2
                          : constraints.maxWidth;
                      double ratingVal = double.tryParse(rev["rating"] ?? "5.0") ?? 5.0;

                      return SizedBox(
                        width: cardWidth,
                        child: Container(
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            color: darkCardBg,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: accentGold, width: 1.5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.12),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: List.generate(
                                      5,
                                          (index) => Icon(
                                        index < ratingVal.floor()
                                            ? Icons.star_rounded
                                            : Icons.star_half_rounded,
                                        color: accentGold,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: accentGold,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      rev["tag"]!,
                                      style: GoogleFonts.bellota(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),
                              Text(
                                "\"${rev["review"]!}\"",
                                style: GoogleFonts.bellota(
                                  fontSize: 14,
                                  color: Colors.white,
                                  height: 1.6,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              const SizedBox(height: 24),
                              const Divider(color: Colors.white24, height: 1),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: accentGold,
                                    radius: 20,
                                    child: Text(
                                      rev["name"]![0],
                                      style: GoogleFonts.bellota(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        rev["name"]!,
                                        style: GoogleFonts.bellota(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        rev["company"]!,
                                        style: GoogleFonts.bellota(
                                          fontSize: 12,
                                          color: textMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
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

  Widget _buildGoogleReviewCTA() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(36),
      decoration: BoxDecoration(
        color: darkCardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accentCyan.withOpacity(0.5), width: 1.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 650;
        return isMobile
            ? Column(
          children: [
            const Icon(FontAwesomeIcons.google, size: 36, color: accentGold),
            const SizedBox(height: 16),
            Text(
              "Read More Reviews On Google",
              textAlign: TextAlign.center,
              style: GoogleFonts.bellota(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Check out our verified customer feedback and location details directly on Google Maps.",
              textAlign: TextAlign.center,
              style: GoogleFonts.bellota(
                fontSize: 13,
                color: textMuted,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: accentGold,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.open_in_new_rounded, size: 16, color: Colors.black),
              label: Text(
                "VIEW ON GOOGLE MAPS",
                style: GoogleFonts.bellota(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              onPressed: () => _launchUrlString(googleReviewsUrl),
            ),
          ],
        )
            : Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: darkBg,
                shape: BoxShape.circle,
              ),
              child: const Icon(FontAwesomeIcons.google, size: 32, color: accentGold),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Read More Reviews On Google",
                    style: GoogleFonts.bellota(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Check out our verified customer feedback and location details directly on Google Maps.",
                    style: GoogleFonts.bellota(
                      fontSize: 14,
                      color: textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: accentGold,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.open_in_new_rounded, size: 16, color: Colors.black),
              label: Text(
                "VIEW ON GOOGLE MAPS",
                style: GoogleFonts.bellota(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              onPressed: () => _launchUrlString(googleReviewsUrl),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth > 800;

    return Container(
      width: double.infinity,
      color: darkBg,
      child: Column(
        children: [
          Divider(height: 1, thickness: 1, color: accentCyan.withOpacity(0.3)),
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
                style: GoogleFonts.bellota(
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
        InkWell(
          onTap: () => _launchUrlString(googleMapsUrl),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on_outlined, size: 18, color: accentGold),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  addressQuery,
                  style: GoogleFonts.bellota(
                    fontSize: 13,
                    color: Colors.white,
                    height: 1.4,
                    fontWeight: FontWeight.w700,
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
              const Icon(Icons.phone_outlined, size: 18, color: accentGold),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  phoneNum,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.bellota(
                    fontSize: 13,
                    color: textMuted,
                    fontWeight: FontWeight.w700,
                  ),
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
              const Icon(Icons.email_outlined, size: 18, color: accentGold),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  emailAddr,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.bellota(
                    fontSize: 13,
                    color: textMuted,
                    fontWeight: FontWeight.w700,
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
          style: GoogleFonts.bellota(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: accentGold,
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

class StatData {
  final double endValue;
  final String suffix;
  final String label;
  final bool isDecimal;

  StatData({
    required this.endValue,
    required this.suffix,
    required this.label,
    this.isDecimal = false,
  });
}

class StatsSection extends StatefulWidget {
  final bool isDesktop;

  const StatsSection({super.key, required this.isDesktop});

  @override
  State<StatsSection> createState() => _StatsSectionState();
}

class _StatsSectionState extends State<StatsSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final ScrollController _scrollController = ScrollController();
  Timer? _autoScrollTimer;

  bool _hasAnimated = false;

  final List<StatData> _stats = [
    StatData(endValue: 4.9, suffix: "★", label: "AVERAGE RATING", isDecimal: true),
    StatData(endValue: 60, suffix: "+", label: "CAMPAIGNS DELIVERED"),
    StatData(endValue: 99, suffix: "%", label: "CLIENT RETENTION"),
    StatData(endValue: 20, suffix: "+", label: "REVIEWS"),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkVisibility();
      if (!widget.isDesktop) {
        _startAutoScroll();
      }
    });
  }

  void checkVisibility() {
    if (_hasAnimated) return;

    final RenderObject? renderObject = context.findRenderObject();
    if (renderObject is RenderBox && renderObject.hasSize) {
      final position = renderObject.localToGlobal(Offset.zero);
      final screenHeight = MediaQuery.of(context).size.height;

      if (position.dy < screenHeight - 50 &&
          (position.dy + renderObject.size.height) > 0) {
        _hasAnimated = true;
        _controller.forward();
      }
    }
  }

  void _startAutoScroll() {
    _autoScrollTimer =
        Timer.periodic(const Duration(milliseconds: 30), (timer) {
          if (_scrollController.hasClients) {
            double maxScroll = _scrollController.position.maxScrollExtent;
            double currentScroll = _scrollController.position.pixels;
            if (currentScroll >= maxScroll) {
              _scrollController.jumpTo(0);
            } else {
              _scrollController.jumpTo(currentScroll + 1.2);
            }
          }
        });
  }

  @override
  void dispose() {
    _controller.dispose();
    _autoScrollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        vertical: 40,
        horizontal: widget.isDesktop ? 60 : 20,
      ),
      child: Center(
        child: Container(
          color: Colors.white,
          constraints: const BoxConstraints(maxWidth: 1200),
          child: widget.isDesktop
              ? LayoutBuilder(
            builder: (context, constraints) {
              return Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: List.generate(_stats.length, (index) {
                  final item = _stats[index];
                  double cardWidth =
                      (constraints.maxWidth - (16 * (_stats.length - 1))) /
                          _stats.length;
                  if (cardWidth < 180) cardWidth = 180;
                  return SizedBox(
                    width: cardWidth,
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return _buildStatCard(item, _animation.value);
                      },
                    ),
                  );
                }),
              );
            },
          )
              : SizedBox(
            height: 130,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _stats.length * 10,
                  itemBuilder: (context, index) {
                    final item = _stats[index % _stats.length];
                    return Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: SizedBox(
                        width: 180,
                        child: _buildStatCard(item, _animation.value),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(StatData item, double progress) {
    double currentValue = item.endValue * progress;
    String formattedValue = item.isDecimal
        ? currentValue.toStringAsFixed(1)
        : currentValue.toInt().toString();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      decoration: BoxDecoration(
        color: _ReviewsState.darkCardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _ReviewsState.accentGold,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              "$formattedValue${item.suffix}",
              style: GoogleFonts.bellota(
                fontSize: widget.isDesktop ? 32 : 24,
                fontWeight: FontWeight.bold,
                color: _ReviewsState.accentGold,
                height: 1.0,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            item.label.toUpperCase(),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.bellota(
              fontSize: widget.isDesktop ? 11 : 10,
              fontWeight: FontWeight.w600,
              color: _ReviewsState.textMuted,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}