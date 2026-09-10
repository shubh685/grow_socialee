import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'About.dart';
import 'Client_Logos.dart';
import 'contact.dart';
import 'home_page.dart';

class Services extends StatefulWidget {
  const Services({super.key});

  @override
  State<Services> createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  int _selectedIndex = 3;
  int _selectedServiceIndex = 0;

  static const Color primaryBlue = Colors.blue;
  static const Color accentPink = Color(0xFFE91E63);
  static const Color bgWhite = Colors.white;
  static const Color lightPink = Color(0xFFFCE4EC);

  final String addressQuery =
      "First Floor, Leela Efcee, 103, Waghawadi Rd., Hill Drive, Bhavnagar, Gujarat 364002";
  final String phoneNum = "+919408518168";
  final String emailAddr = "growsocialee@gmail.com";
  final String googleMapsUrl =
      "https://maps.google.com/?q=Leela+Efcee+Bhavnagar+Gujarat";

  final String facebookUrl = "https://www.facebook.com/growsocialeeofficial/";
  final String instagramUrl = "https://www.instagram.com/growsocialee.official/";
  final String linkedInUrl = "https://in.linkedin.com/company/grow-socialee";

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
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.indigo.shade700, Colors.blue.shade400,
            ]),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.shade700.withOpacity(0.3),
                blurRadius: 10,
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
                padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
                color: Colors.blue.shade600,
                child: Center(
                  child: SizedBox(
                    height: 55,
                    child: Image.asset(
                      "assets/photos/Gro_Soc_Image.png",
                      color: Colors.white,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.image,
                        color: primaryBlue,
                        size: 40,
                      ),
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => About()));
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
                                builder: (context) => const Contact()));
                      },
                    ),
                  ],
                ),
              ),
              Container(
                height: 6,
                color: accentPink,
              )
            ],
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // Sphinix-style Hero Banner
          SliverToBoxAdapter(
            child: _buildSphinixHeroBanner(screenWidth, isDesktop),
          ),

          // Services Grid (Sphinix-style cards)
          SliverToBoxAdapter(
            child: _buildServicesGrid(isDesktop),
          ),

          // Interactive Service Detail Section
          SliverToBoxAdapter(
            child: _buildInteractiveServiceSection(isDesktop),
          ),

          // Consultation CTA
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: _buildConsultationCTA(),
                ),
              ),
            ),
          ),

          // Footer
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
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? Colors.pink.shade400: Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: isSelected
                  ? null
                  : Border.all(color: Colors.black12, width: 0.5),
            ),
            child: Row(
              children: [
                Icon(icon, size: 22, color: isSelected ? Colors.white : Colors.blue.shade600),
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
                  const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: bgWhite),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Sphinix-style Hero Banner
  Widget _buildSphinixHeroBanner(double screenWidth, bool isDesktop) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.indigo.shade700,
            Colors.blue.shade500,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: CustomPaint(
                painter: _HeroPatternPainter(),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: isDesktop ? 80 : 50,
              horizontal: isDesktop ? 60 : 24,
            ),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Column(
                  children: [
                    // Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.auto_awesome_rounded,
                              size: 16, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            "OUR SERVICES",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Main Headline - Sphinix style
                    Text(
                      "Getting your name on top is our #1 priority.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.bebasNeue(
                        fontSize: isDesktop ? 48 : 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.2,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Subheadline
                    Text(
                      "We make sure you receive the attention your business deserves. We are not just a social media agency - we provide a variance of services.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: isDesktop ? 18 : 15,
                        color: Colors.white.withOpacity(0.95),
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // CTA Buttons
                    Wrap(
                      spacing: 16,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentPink,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 28,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 4,
                          ),
                          icon: const Icon(Icons.rocket_launch_rounded, size: 20),
                          label: Text(
                            "GET STARTED",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.1,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Contact(),
                              ),
                            );
                          },
                        ),
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 28,
                              vertical: 16,
                            ),
                            side: const BorderSide(color: Colors.white, width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          icon: const Icon(Icons.phone_rounded, size: 20),
                          label: Text(
                            "CALL US",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.1,
                            ),
                          ),
                          onPressed: () => _makePhoneCall(phoneNum),
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

  // Services Grid - Sphinix Style Cards
  Widget _buildServicesGrid(bool isDesktop) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 60,
        horizontal: isDesktop ? 60 : 20,
      ),
      color: Colors.grey[50],
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Text(
                "What We Offer",
                style: GoogleFonts.bebasNeue(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo.shade900,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 4,
                width: 80,
                decoration: BoxDecoration(
                  color: accentPink,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Comprehensive digital marketing solutions tailored to your business needs.",
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),
              // Service Cards Grid
              Wrap(
                spacing: 24,
                runSpacing: 24,
                alignment: WrapAlignment.center,
                children: List.generate(serviceData.length, (index) {
                  final service = serviceData[index];
                  return _buildServiceCard(
                    service: service,
                    index: index,
                    isDesktop: isDesktop,
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceCard({
    required Map<String, dynamic> service,
    required int index,
    required bool isDesktop,
  }) {
    final double cardWidth = isDesktop ? 360 : double.infinity;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedServiceIndex = index;
          });
          // Scroll to detail section
          Scrollable.ensureVisible(
            context,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: cardWidth,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _selectedServiceIndex == index
                  ? accentPink
                  : Colors.black.withOpacity(0.08),
              width: _selectedServiceIndex == index ? 2 : 1,
            ),
            boxShadow: _selectedServiceIndex == index
                ? [
              BoxShadow(
                color: accentPink.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ]
                : [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon and Tag Row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: _selectedServiceIndex == index
                            ? accentPink
                            : lightPink,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        service["icon"],
                        color: _selectedServiceIndex == index
                            ? Colors.white
                            : accentPink,
                        size: 28,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: primaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        service["tag"],
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: primaryBlue,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Title
              Text(
                service["title"],
                style: GoogleFonts.bebasNeue(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo.shade900,
                ),
              ),
              const SizedBox(height: 10),
              // Description
              Text(
                service["desc"],
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  color: Colors.black54,
                  height: 1.5,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 20),
              // Learn More Link
              Row(
                children: [
                  Text(
                    "Learn More",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: accentPink,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    size: 16,
                    color: accentPink,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Interactive Service Detail Section
  Widget _buildInteractiveServiceSection(bool isDesktop) {
    final activeService = serviceData[_selectedServiceIndex];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 60,
        horizontal: isDesktop ? 60 : 20,
      ),
      color: Colors.white,
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              // Section Header
              Text(
                "Service Deep Dive",
                style: GoogleFonts.bebasNeue(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo.shade900,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 4,
                width: 60,
                decoration: BoxDecoration(
                  color: primaryBlue,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 40),
              // Service Detail Card
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Container(
                  key: ValueKey<int>(_selectedServiceIndex),
                  padding: EdgeInsets.all(isDesktop ? 40 : 24),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: primaryBlue.withOpacity(0.15),
                      width: 1.5,
                    ),
                  ),
                  child: isDesktop
                      ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left: Icon and Tag
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: lightPink,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                activeService["icon"],
                                color: accentPink,
                                size: 48,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: primaryBlue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                activeService["tag"],
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: primaryBlue,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 40),
                      // Right: Content
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              activeService["title"],
                              style: GoogleFonts.bebasNeue(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo.shade900,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              activeService["desc"],
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                color: Colors.black87,
                                height: 1.6,
                              ),
                            ),
                            const SizedBox(height: 28),
                            Text(
                              "KEY DELIVERABLES",
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: accentPink,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: List<String>.from(
                                  activeService["deliverables"])
                                  .map((item) => Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Colors.black.withOpacity(0.08)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.check_circle_rounded,
                                      size: 16,
                                      color: accentPink,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      item,
                                      style:
                                      GoogleFonts.plusJakartaSans(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ))
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: lightPink,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              activeService["icon"],
                              color: accentPink,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: primaryBlue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                activeService["tag"],
                                textAlign: TextAlign.center,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: primaryBlue,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        activeService["title"],
                        style: GoogleFonts.bebasNeue(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo.shade900,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        activeService["desc"],
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          color: Colors.black87,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "KEY DELIVERABLES",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: accentPink,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...List<String>.from(activeService["deliverables"])
                          .map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_circle_rounded,
                              size: 16,
                              color: accentPink,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                item,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
              child: Text("GET IN TOUCH", style: GoogleFonts.ibmPlexSansThai(fontSize: 13, fontWeight: FontWeight.bold, color: bgWhite, letterSpacing: 1.1)),
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
      color: Colors.indigo.shade500,
      child: Column(
        children: [
          Container(
            height: 5,
            width: double.infinity,
            color: Colors.blue.shade600,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
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
                    const SizedBox(height: 30),
                    _buildFooterContactSection(),
                    const SizedBox(height: 30),
                    _buildFooterSocialSection(),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            color: Colors.indigo.shade500,
            child: Center(
              child: Text(
                "© ${DateTime.now().year} Grow Socialee. All rights reserved.",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: Colors.white,
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
        const SizedBox(height: 12),
        Text(
          "Empowering businesses through digital strategies, branding, video production, and social media solutions.",
          style: GoogleFonts.ibmPlexSansThai(
            fontSize: 13,
            color: Colors.white,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildFooterContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Contact Info", style: GoogleFonts.ibmPlexSansThai(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 12),
        InkWell(
          onTap: () => _launchUrlString(googleMapsUrl),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on_outlined, size: 18, color: Colors.white70),
              const SizedBox(width: 8),
              Expanded(
                child: Text(addressQuery, style: GoogleFonts.ibmPlexSansThai(fontSize: 13, color: Colors.white, height: 1.4)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        InkWell(
          onTap: () => _makePhoneCall(phoneNum),
          child: Row(
            children: [
              const Icon(Icons.phone_outlined, size: 18, color: Colors.white70),
              const SizedBox(width: 8),
              Text(phoneNum, style: GoogleFonts.ibmPlexSansThai(fontSize: 13, color: Colors.white),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        InkWell(
          onTap: () => _sendEmail(emailAddr),
          child: Row(
            children: [
              const Icon(Icons.email_outlined, size: 18, color: Colors.white70),
              const SizedBox(width: 8),
              Text(emailAddr, style: GoogleFonts.ibmPlexSansThai(fontSize: 13, color: Colors.white)),
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
        Text("Follow Us on", style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.circular(12)
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(FontAwesomeIcons.facebook, size: 20, color: primaryBlue),
                onPressed: () => _launchUrlString(facebookUrl),
              ),
              const SizedBox(
                  height: 15,
                  child: VerticalDivider(color: Colors.black87, thickness: 2.5)),
              IconButton(
                icon: const Icon(FontAwesomeIcons.instagram, size: 20, color: accentPink),
                onPressed: () => _launchUrlString(instagramUrl),
              ),
              const SizedBox(
                  height: 15,
                  child: VerticalDivider(color: Colors.black87, thickness: 2.5)),
              IconButton(
                icon: const Icon(FontAwesomeIcons.linkedin, size: 20, color: primaryBlue),
                onPressed: () => _launchUrlString(linkedInUrl),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Custom Painter for Hero Background Pattern
class _HeroPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Draw diagonal lines pattern
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