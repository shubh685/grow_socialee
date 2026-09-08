import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Client_Logos.dart';
import 'contact.dart';
import 'home_page.dart';

class Services extends StatefulWidget {
  const Services({super.key});

  @override
  State<Services> createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  int _selectedIndex = 3; // Active Drawer Index for Services[cite: 12]
  int _selectedServiceIndex = 0; // For Interactive Service Showcase View

  // Theme Palette Colors (Exact Palette Retained)[cite: 12]
  static const Color primaryBlue = Colors.blue;
  static const Color accentPink = Color(0xFFE91E63);
  static const Color bgWhite = Colors.white;
  static const Color lightPink = Color(0xFFFCE4EC);

  // Contact Details & Social Links Constants[cite: 12]
  final String addressQuery =
      "First Floor, Leela Efcee, 103, Waghawadi Rd., Hill Drive, Bhavnagar, Gujarat 364002";
  final String phoneNum = "+919408518168";
  final String emailAddr = "growsocialee@gmail.com";
  final String googleMapsUrl =
      "https://maps.google.com/?q=Leela+Efcee+Bhavnagar+Gujarat";

  final String facebookUrl = "https://www.facebook.com/growsocialeeofficial/";
  final String instagramUrl = "https://www.instagram.com/growsocialee.official/";
  final String linkedInUrl = "https://in.linkedin.com/company/grow-socialee";

  // Service Data Structure[cite: 12]
  final List<Map<String, dynamic>> serviceData = [
    {
      "title": "Social Media Strategy Development",
      "icon": Icons.alt_route_rounded,
      "tag": "PLANNING & ROADMAP",
      "desc":
      "We audit your digital touchpoints, identify ideal buyer personas, and build tailor-made growth roadmaps to outshine competitors.",
      "deliverables": [
        "Target Audience & Competitor Analysis",
        "Platform Selection & Content Pillars",
        "Growth KPI & Goal Blueprint"
      ],
    },
    {
      "title": "Content Creation",
      "icon": Icons.brush_rounded,
      "tag": "CREATIVE & DESIGN",
      "desc":
      "Captivate audiences with high-quality graphics, viral short-form videos (Reels/Shorts), engaging copy, and sleek multi-slide carousels.",
      "deliverables": [
        "High-Impact Graphics & Motion Video",
        "Persuasive Copywriting & Hashtags",
        "Brand Visual Identity Consistency"
      ],
    },
    {
      "title": "Social Media Account Management",
      "icon": Icons.manage_accounts_rounded,
      "tag": "DAILY EXECUTION",
      "desc":
      "Focus on running your business while we handle daily content scheduling, active community engagement, and profile optimization.",
      "deliverables": [
        "Posting & Automated Scheduling",
        "Audience Q&A & DM Engagement",
        "Bio & Highlights Optimization"
      ],
    },
    {
      "title": "Social Media Advertising",
      "icon": Icons.campaign_rounded,
      "tag": "PAID TRAFFIC & ROAS",
      "desc":
      "Target qualified leads with hyper-focused ad campaigns on Meta (Facebook & Instagram), maximizing return on ad spend (ROAS).",
      "deliverables": [
        "Ad Creative & Copy A/B Testing",
        "Custom Audience & Retargeting Setup",
        "Daily Budget & Bidding Optimization"
      ],
    },
    {
      "title": "Analytics and Reporting",
      "icon": Icons.insert_chart_outlined_rounded,
      "tag": "DATA & INSIGHTS",
      "desc":
      "Transparent and concise monthly performance reports tracking impression trends, engagement spikes, traffic conversions, and ROI.",
      "deliverables": [
        "Comprehensive Monthly Metrics Report",
        "Audience Demographics Breakdown",
        "Actionable Strategic Refinements"
      ],
    },
    {
      "title": "Reputation Management",
      "icon": Icons.verified_user_rounded,
      "tag": "BRAND PROTECTION",
      "desc":
      "Build robust brand credibility by monitoring brand mentions, resolving public customer queries, and nurturing positive reviews.",
      "deliverables": [
        "Social Listening & Sentiment Tracking",
        "Crisis Management Protocols",
        "Review Amplification & Trust Building"
      ],
    },
  ];

  // URL Launchers[cite: 12]
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
    final bool isDesktop = screenWidth > 900;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFCFF),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65),
        child: Container(
          decoration: BoxDecoration(
            color: primaryBlue,
            boxShadow: [
              BoxShadow(
                color: primaryBlue.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
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
                  icon: const Icon(Icons.menu_rounded, color: bgWhite, size: 28),
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
      endDrawer: Drawer(
        width: isDesktop ? 360 : screenWidth * 0.8,
        backgroundColor: bgWhite,
        child: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    vertical: 24.0, horizontal: 16.0),
                color: lightPink,
                child: Center(
                  child: SizedBox(
                    height: 55,
                    child: Image.asset(
                      "assets/photos/Gro_Soc_Image.png",
                      color: primaryBlue,
                    ),
                  ),
                ),
              ),
              const Divider(height: 1, thickness: 1, color: accentPink),
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ClientLogoPage()));
                      },
                    ),
                    _buildDrawerItem(
                      index: 3,
                      icon: Icons.task_alt_outlined,
                      label: "SERVICES",
                      onTap: () {
                        setState(() => _selectedIndex = 3);
                        Navigator.pop(context);
                      },
                    ),
                    _buildDrawerItem(
                      index: 4,
                      icon: Icons.chat_bubble_outline_rounded,
                      label: "REVIEWS",
                      onTap: () {
                        setState(() => _selectedIndex = 4);
                        Navigator.pop(context);
                        _launchUrlString(
                          "https://www.google.com/maps/place/Grow+Socialee,+Social+Media+Marketing+Agency+in+Bhavnagar/@21.7521703,72.1422254,17z/data=!3m1!5s0x395f5a7614a4fc37:0xb6b7c2fd5ec85477!4m16!1m9!3m8!1s0x395f5bda3e409bdf:0x9c73e4385ba146c5!2sGrow+Socialee,+Social+Media+Marketing+Agency+in+Bhavnagar!8m2!3d21.7521703!4d72.1422254!9m1!1b1!16s%2Fg%2F11js22bbxs!3m5!1s0x395f5bda3e409bdf:0x9c73e4385ba146c5!8m2!3d21.7521703!4d72.1422254!16s%2Fg%2F11js22bbxs?entry=ttu&g_ep=EgoyMDI2MDkwMi4wIKXMDSoASAFQAw%3D%3D",
                        );
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
              Container(height: 6, color: accentPink)
            ],
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // Hero Banner Section
          SliverToBoxAdapter(
            child: _buildHeroSection(),
          ),

          // Interactive Dynamic Service View Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Column(
                    children: [
                      isDesktop
                          ? _buildDesktopInteractiveServices()
                          : _buildMobileServicesList(),
                      const SizedBox(height: 48),
                      _buildConsultationCTA(),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Enhanced Modern Footer
          SliverToBoxAdapter(
            child: _buildFooter(context),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoHeader() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
            child: SizedBox(
              height: 38,
              child: Image.asset("assets/photos/Gro_Soc_Image.png",
                  color: bgWhite),
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
              color: isSelected ? primaryBlue : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              border: isSelected
                  ? null
                  : Border.all(color: Colors.black.withOpacity(0.05), width: 1),
            ),
            child: Row(
              children: [
                Icon(icon, size: 22, color: isSelected ? bgWhite : accentPink),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: GoogleFonts.ibmPlexSansThai(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? bgWhite : Colors.black87,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.arrow_forward_ios_rounded,
                      size: 14, color: bgWhite),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Hero Banner Section
  Widget _buildHeroSection() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [lightPink, bgWhite],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 24),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 850),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: primaryBlue.withOpacity(0.2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.auto_awesome_rounded,
                        size: 16, color: primaryBlue),
                    const SizedBox(width: 8),
                    Text(
                      "GROW SOCIALEE SERVICES",
                      style: GoogleFonts.ibmPlexSansThai(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: primaryBlue,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Text(
                "Elevate Your Brand's Digital Footprint",
                textAlign: TextAlign.center,
                style: GoogleFonts.ibmPlexSansThai(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: primaryBlue,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                "From end-to-end strategy development to high-converting social media ads, we empower local and global businesses with result-driven digital solutions.",
                textAlign: TextAlign.center,
                style: GoogleFonts.ibmPlexSansThai(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Desktop Interactive Split Showcase View
  Widget _buildDesktopInteractiveServices() {
    final activeService = serviceData[_selectedServiceIndex];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column: Interactive Selector List
        Expanded(
          flex: 2,
          child: Column(
            children: List.generate(serviceData.length, (index) {
              final service = serviceData[index];
              final bool isSelected = _selectedServiceIndex == index;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: InkWell(
                  onTap: () => setState(() => _selectedServiceIndex = index),
                  borderRadius: BorderRadius.circular(14),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: isSelected ? lightPink : bgWhite,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? accentPink : Colors.black12,
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                        BoxShadow(
                          color: accentPink.withOpacity(0.15),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        )
                      ]
                          : [],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isSelected ? accentPink : primaryBlue.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            service["icon"],
                            color: isSelected ? bgWhite : primaryBlue,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            service["title"],
                            style: GoogleFonts.ibmPlexSansThai(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? accentPink : Colors.black87,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                          color: isSelected ? accentPink : Colors.black26,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(width: 28),
        // Right Column: Focused Service Display Detail
        Expanded(
          flex: 3,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Container(
              key: ValueKey<int>(_selectedServiceIndex),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: bgWhite,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: primaryBlue.withOpacity(0.2), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: primaryBlue.withOpacity(0.08),
                    blurRadius: 25,
                    offset: const Offset(0, 10),
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
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: lightPink,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(activeService["icon"],
                            color: accentPink, size: 36),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: primaryBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          activeService["tag"],
                          style: GoogleFonts.ibmPlexSansThai(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: primaryBlue,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    activeService["title"],
                    style: GoogleFonts.ibmPlexSansThai(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    activeService["desc"],
                    style: GoogleFonts.ibmPlexSansThai(
                      fontSize: 15,
                      color: Colors.black87,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Divider(color: Colors.black12),
                  const SizedBox(height: 16),
                  Text(
                    "KEY DELIVERABLES",
                    style: GoogleFonts.ibmPlexSansThai(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: accentPink,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...List<String>.from(activeService["deliverables"]).map(
                        (item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle_rounded,
                              size: 18, color: accentPink),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              item,
                              style: GoogleFonts.ibmPlexSansThai(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
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
          ),
        ),
      ],
    );
  }

  // Mobile Accordion/Card View
  Widget _buildMobileServicesList() {
    return Column(
      children: List.generate(serviceData.length, (index) {
        final service = serviceData[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: bgWhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black.withOpacity(0.08)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: lightPink,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(service["icon"], color: accentPink, size: 24),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: primaryBlue.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        service["tag"],
                        style: GoogleFonts.ibmPlexSansThai(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: primaryBlue,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  service["title"],
                  style: GoogleFonts.ibmPlexSansThai(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryBlue,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  service["desc"],
                  style: GoogleFonts.ibmPlexSansThai(
                    fontSize: 13,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 14),
                const Divider(color: Colors.black12),
                const SizedBox(height: 8),
                ...List<String>.from(service["deliverables"]).map(
                      (item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3.0),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_rounded,
                            size: 15, color: accentPink),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item,
                            style: GoogleFonts.ibmPlexSansThai(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
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
      }),
    );
  }

  // Consultation Banner
  Widget _buildConsultationCTA() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [primaryBlue, Color(0xFF1976D2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 650;
        return isMobile
            ? Column(
          children: [
            Text(
              "Ready to Scale Your Online Brand Presence?",
              textAlign: TextAlign.center,
              style: GoogleFonts.ibmPlexSansThai(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: bgWhite,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Get in touch with our team in Bhavnagar today for a complimentary strategy session.",
              textAlign: TextAlign.center,
              style: GoogleFonts.ibmPlexSansThai(
                fontSize: 13,
                color: bgWhite.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: accentPink,
                padding: const EdgeInsets.symmetric(
                    horizontal: 28, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Contact()),
                );
              },
              child: Text(
                "GET IN TOUCH",
                style: GoogleFonts.ibmPlexSansThai(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: bgWhite,
                  letterSpacing: 1.1,
                ),
              ),
            ),
          ],
        )
            : Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Ready to Scale Your Online Brand Presence?",
                    style: GoogleFonts.ibmPlexSansThai(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: bgWhite,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Get in touch with our team in Bhavnagar today for a complimentary strategy session.",
                    style: GoogleFonts.ibmPlexSansThai(
                      fontSize: 14,
                      color: bgWhite.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: accentPink,
                padding: const EdgeInsets.symmetric(
                    horizontal: 28, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 4,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Contact()),
                );
              },
              child: Text(
                "GET IN TOUCH",
                style: GoogleFonts.ibmPlexSansThai(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: bgWhite,
                  letterSpacing: 1.1,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  // Footer Component
  Widget _buildFooter(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth > 800;

    return Container(
      width: double.infinity,
      color: lightPink,
      child: Column(
        children: [
          Container(
            height: 4,
            width: double.infinity,
            color: primaryBlue,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: isDesktop
                    ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: _buildFooterBranding()),
                    const SizedBox(width: 40),
                    Expanded(
                        flex: 3, child: _buildFooterContactDetails()),
                  ],
                )
                    : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFooterBranding(),
                    const SizedBox(height: 32),
                    const Divider(color: Colors.black12, thickness: 1),
                    const SizedBox(height: 24),
                    _buildFooterContactDetails(),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            color: primaryBlue,
            child: Center(
              child: Text(
                "© ${DateTime.now().year} All Rights Reserved.",
                style: GoogleFonts.ibmPlexSansThai(
                  color: bgWhite,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterBranding() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 48,
          child: Image.asset("assets/photos/Gro_Soc_Image.png",
              color: primaryBlue),
        ),
        const SizedBox(height: 12),
        Container(
          height: 3,
          width: 40,
          color: accentPink,
        ),
        const SizedBox(height: 16),
        Text(
          "Social Media Marketing Agency in Bhavnagar",
          style: GoogleFonts.ibmPlexSansThai(
            color: Colors.black87,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 20),
        _buildSocialIconsRow(),
      ],
    );
  }

  Widget _buildSocialIconsRow() {
    return Row(
      children: [
        _buildSocialIconButton(
          icon: FontAwesomeIcons.facebookF,
          backgroundColor: const Color(0xFF1877F2),
          onTap: () => _launchUrlString(facebookUrl),
        ),
        const SizedBox(width: 12),
        _buildSocialIconButton(
          icon: FontAwesomeIcons.instagram,
          backgroundColor: const Color(0xFFE4405F),
          onTap: () => _launchUrlString(instagramUrl),
        ),
        const SizedBox(width: 12),
        _buildSocialIconButton(
          icon: FontAwesomeIcons.linkedinIn,
          backgroundColor: const Color(0xFF0A66C2),
          onTap: () => _launchUrlString(linkedInUrl),
        ),
      ],
    );
  }

  Widget _buildSocialIconButton({
    required IconData icon,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: backgroundColor,
      shape: const CircleBorder(),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 38,
          height: 38,
          alignment: Alignment.center,
          child: FaIcon(
            icon,
            color: Colors.white,
            size: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildFooterContactDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "GET IN TOUCH",
          style: GoogleFonts.ibmPlexSansThai(
            color: accentPink,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        _buildFooterContactRow(
          icon: Icons.location_on_rounded,
          text: addressQuery,
          onTap: () => _launchUrlString(googleMapsUrl),
        ),
        const SizedBox(height: 12),
        _buildFooterContactRow(
          icon: Icons.phone_rounded,
          text: "+91 94085 18168",
          onTap: () => _makePhoneCall(phoneNum),
        ),
        const SizedBox(height: 12),
        _buildFooterContactRow(
          icon: Icons.email_rounded,
          text: emailAddr,
          onTap: () => _sendEmail(emailAddr),
        ),
        const SizedBox(height: 12),
        _buildFooterContactRow(
          icon: Icons.access_time_filled_rounded,
          text: "Working Hours: 9:30 AM to 7:00 PM",
          onTap: null,
        ),
      ],
    );
  }

  Widget _buildFooterContactRow({
    required IconData icon,
    required String text,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: primaryBlue.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: primaryBlue, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.ibmPlexSansThai(
                  color: Colors.black87,
                  fontSize: 14,
                  height: 1.4,
                  decoration:
                  onTap != null ? TextDecoration.underline : TextDecoration.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}