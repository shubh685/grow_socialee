import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'About.dart';
import 'Client_Logos.dart';
import 'Reviews.dart';
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

  // Colors aligned with home_page.dart
  static const Color brandBlue = Color(0xFF1B64B1);
  static const Color darkBg = Color(0xFF144F8E);
  static const Color darkCardBg = Color(0xFF0F3E72);
  static const Color accentWhite = Colors.white;
  static const Color textMuted = Color(0xFFD0E1F9);
  static const Color accentGold = Color(0xFFFFB703);
  static const Color accentCyan = Color(0xFF00E5FF);

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
      "title": "Social Media Marketing",
      "icon": Icons.campaign,
      "tag": "SOCIAL MEDIA GROWTH",
      "desc":
      "Grow your brand online with strategic content, targeted campaigns, and performance-driven social media marketing.",
      "deliverables": [
        "Social Media Strategy",
        "Audience & Competitor Research",
        "Content Planning & Creation",
        "Engagement & Community Management",
        "Paid Social Media Campaigns",
        "Analytics & Monthly Performance Reports"
      ],
    },
    {
      "title": "S.E.O",
      "icon": Icons.search,
      "tag": "SEARCH ENGINE OPTIMIZATION",
      "desc":
      "Improve search rankings, drive organic traffic, and increase your online visibility with effective SEO strategies.",
      "deliverables": [
        "Keyword Research & On-Page SEO",
        "Technical SEO & Optimization",
        "Organic Traffic & Ranking Growth"
      ],
    },
    {
      "title": "P.P.C",
      "icon": Icons.campaign_rounded,
      "tag": "PAY PER CLICK",
      "desc":
      "Drive targeted traffic and qualified leads through optimized Meta ad campaigns.",
      "deliverables": [
        "Ad Creative & Copy Testing",
        "Audience & Retargeting Setup",
        "Budget & Bidding Optimization"
      ],
    },
    {
      "title": "Web Development",
      "icon": Icons.web_rounded,
      "tag": "WEBSITE DEVELOPMENT",
      "desc":
      "Modern, responsive, and high-performance websites designed to grow your business.",
      "deliverables": [
        "Responsive Website Design",
        "Fast & Secure Development",
        "Website Maintenance & Support"
      ],
    },
    {
      "title": "Branding",
      "icon": Icons.verified_user_rounded,
      "tag": "BRAND TRUST",
      "desc":
      "Strengthen your brand identity, build trust, and maintain a positive online reputation.",
      "deliverables": [
        "Brand Reputation Management",
        "Social Media Monitoring",
        "Reviews & Customer Engagement"
      ],
    },
  ];

  // Unique Reviews Data preserved
  final List<Map<String, String>> clientReviews = [
    {
      "name": "Venisha Chitalia",
      "company": "Bindu Decorators",
      "rating": "4.0",
      "review":
      "I am pleased with the social media management services provided. They have effectively increased my followers, achieving the target set within the expected timeframe. Their strategic approach delivered great value for money, and their consistent efforts have helped enhance my brand’s online presence. Overall, a satisfactory experience, and I would recommend their services to anyone looking to grow their social media reach.",
      "tag": "Brand's Product Marketing"
    },
    {
      "name": "Dr. Jinali Modi",
      "company": "Body Mind Soul",
      "rating": "5.0",
      "review":
      "Growsocialee has been helping me for my social media management and Shaily the founder has been extremely professional, she is very helpful and always available for any questions she is very cooperative in her approach, she has in depth knowledge of how this social media marketing works and knows the right things to do. She is very creative and her team also brings the vision to life.",
      "tag": "Hospital's Marketing"
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const Reviews()));
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
                color: accentGold,
              )
            ],
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // Dark Modern Hero Banner matching HomePage style
          SliverToBoxAdapter(
            child: _buildAGHeroBanner(screenWidth, isDesktop),
          ),

          // Services Grid
          SliverToBoxAdapter(
            child: _buildServicesGrid(screenWidth),
          ),

          // Interactive Service Detail Section
          SliverToBoxAdapter(
            child: _buildInteractiveServiceSection(isDesktop),
          ),

          // Testimonials & Reviews Section (Styled exactly as per Reviews.dart)
          SliverToBoxAdapter(
            child: _buildUniqueReviewsSection(isDesktop),
          ),

          // Consultation CTA
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: _buildConsultationCTA(),
                ),
              ),
            ),
          ),

          // Footer Section matching HomePage
          SliverToBoxAdapter(
            child: _buildAGFooter(context),
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

  Widget _buildAGHeroBanner(double screenWidth, bool isDesktop) {
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
              vertical: isDesktop ? 100 : 60,
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
                      child: Text(
                        "OUR DIGITAL CAPABILITIES",
                        style: GoogleFonts.bellota(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: accentCyan,
                          letterSpacing: 2.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Column(
                      children: [
                        Text(
                          "Getting your name on top is our",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.bellota(
                            fontSize: isDesktop ? 56 : 34,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.1,
                          ),
                        ),
                        Text(
                          "No.1 priority.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.bellota(
                            fontSize: isDesktop ? 56 : 34,
                            fontWeight: FontWeight.bold,
                            color: accentGold,
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "We make sure you receive the attention your business deserves. We are not just a social media agency — we provide a multi-channel variance of services tailored for growth.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.bellota(
                        fontSize: isDesktop ? 17 : 14,
                        color: textMuted,
                        height: 1.6,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(height: 36),
                    Wrap(
                      spacing: 16,
                      runSpacing: 14,
                      alignment: WrapAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentGold,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 18,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 8,
                            shadowColor: accentGold.withOpacity(0.4),
                          ),
                          icon: const Icon(Icons.rocket_launch_rounded, size: 18, color: Colors.black),
                          label: Text(
                            "START A PROJECT",
                            style: GoogleFonts.bellota(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.0,
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
                              horizontal: 32,
                              vertical: 18,
                            ),
                            side: const BorderSide(color: accentCyan, width: 1.8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const Icon(Icons.phone_rounded, size: 18, color: accentCyan),
                          label: Text(
                            "CALL US NOW",
                            style: GoogleFonts.bellota(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
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

  Widget _buildServicesGrid(double screenWidth) {
    final bool isDesktop = screenWidth >= 1024;
    final bool isTablet = screenWidth >= 650 && screenWidth < 1024;

    const double gap = 24;
    const double maxContentWidth = 1200;

    int crossAxisCount = 1;
    if (isDesktop) {
      crossAxisCount = 3;
    } else if (isTablet) {
      crossAxisCount = 2;
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 70,
        horizontal: isDesktop ? 60 : 20,
      ),
      color: darkBg,
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: maxContentWidth),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "WHAT WE OFFER",
                  style: GoogleFonts.bellota(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: darkCardBg,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Tailored Growth Solutions",
                textAlign: TextAlign.center,
                style: GoogleFonts.bellota(
                  fontSize: isDesktop ? 36 : 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Comprehensive digital marketing strategies engineered to scale your market influence.",
                textAlign: TextAlign.center,
                style: GoogleFonts.bellota(
                  fontSize: 15,
                  color: textMuted,
                  height: 1.5,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(height: 48),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: serviceData.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: gap,
                  mainAxisSpacing: gap,
                  mainAxisExtent: 260,
                ),
                itemBuilder: (context, index) {
                  final service = serviceData[index];
                  return _buildServiceCard(
                    service: service,
                    index: index,
                  );
                },
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
  }) {
    final bool isSelected = _selectedServiceIndex == index;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedServiceIndex = index;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white60,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? accentGold : Colors.transparent,
              width: isSelected ? 2.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isSelected ? 0.25 : 0.1),
                blurRadius: isSelected ? 16 : 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isSelected ? darkCardBg : darkBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(service["icon"], color: isSelected ? accentGold : Colors.white, size: 24),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: darkCardBg.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: darkCardBg.withOpacity(0.12)),
                        ),
                        child: Text(service["tag"], overflow: TextOverflow.ellipsis, style: GoogleFonts.bellota(fontSize: 10, fontWeight: FontWeight.bold, color: darkCardBg, letterSpacing: 0.8)),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(service["title"], maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.bellota(fontSize: 18, fontWeight: FontWeight.bold, color: darkCardBg)),
                  const SizedBox(height: 6),
                  Text(service["desc"], style: GoogleFonts.bellota(fontSize: 13, color: Colors.black87, height: 1.4), maxLines: 2, overflow: TextOverflow.ellipsis,),
                ],
              ),
              Row(
                children: [
                  Text("Explore Deliverables", style: GoogleFonts.bellota(fontSize: 13, fontWeight: FontWeight.bold, color: brandBlue)),
                  const SizedBox(width: 6),
                  const Icon(Icons.arrow_forward_rounded, size: 16, color: brandBlue),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInteractiveServiceSection(bool isDesktop) {
    final activeService = serviceData[_selectedServiceIndex];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 70,
        horizontal: isDesktop ? 60 : 20,
      ),
      color: Colors.white70,
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: darkCardBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "SERVICE DEEP DIVE",
                  style: GoogleFonts.bellota(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Breakdown & Key Deliverables",
                style: GoogleFonts.bellota(
                  fontSize: isDesktop ? 34 : 24,
                  fontWeight: FontWeight.bold,
                  color: darkCardBg,
                ),
              ),
              const SizedBox(height: 36),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Container(
                  key: ValueKey<int>(_selectedServiceIndex),
                  padding: EdgeInsets.all(isDesktop ? 40 : 24),
                  decoration: BoxDecoration(
                    color: darkCardBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: accentGold,
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: isDesktop
                      ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: accentCyan.withOpacity(0.4)),
                              ),
                              child: Icon(activeService["icon"], color: brandBlue, size: 48),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: accentCyan.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: accentCyan.withOpacity(0.4)),
                              ),
                              child: Text(
                                activeService["tag"],
                                textAlign: TextAlign.center,
                                style: GoogleFonts.bellota(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: accentCyan,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 40),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              activeService["title"],
                              style: GoogleFonts.bellota(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: accentGold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              activeService["desc"],
                              style: GoogleFonts.bellota(
                                fontSize: 15,
                                color: textMuted,
                                height: 1.6,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            const SizedBox(height: 28),
                            Text(
                              "WHAT WE DELIVER",
                              style: GoogleFonts.bellota(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.5,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: List<String>.from(activeService["deliverables"])
                                  .map((item) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: darkBg,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: accentCyan.withOpacity(0.3)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.check_circle_rounded,
                                      size: 16,
                                      color: accentGold,
                                    ),
                                    const SizedBox(width: 10),
                                    Flexible(
                                      child: Text(
                                        item,
                                        style: GoogleFonts.bellota(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
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
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(activeService["icon"], color: brandBlue, size: 32),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: accentCyan.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: accentCyan.withOpacity(0.4)),
                              ),
                              child: Text(activeService["tag"], textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, style: GoogleFonts.bellota(fontSize: 10, fontWeight: FontWeight.bold, color: accentCyan, letterSpacing: 0.8)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(activeService["title"], style: GoogleFonts.bellota(fontSize: 22, fontWeight: FontWeight.bold, color: accentGold)),
                      const SizedBox(height: 12),
                      Text(activeService["desc"], style: GoogleFonts.bellota(fontSize: 14, color: textMuted, height: 1.6, fontWeight: FontWeight.w300)),
                      const SizedBox(height: 24),
                      Text("WHAT WE DELIVER", style: GoogleFonts.bellota(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.2)),
                      const SizedBox(height: 12),
                      ...List<String>.from(activeService["deliverables"]).map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle_rounded, size: 16, color: accentGold),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(item, style: GoogleFonts.bellota(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
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

  // Reviews section redesigned matching Reviews.dart review cards structure
  Widget _buildUniqueReviewsSection(bool isDesktop) {
    return Container(
      width: double.infinity,
      color: darkCardBg,
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
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text("CLIENT STORIES", style: GoogleFonts.bellota(fontSize: 12, fontWeight: FontWeight.bold, color: darkCardBg, letterSpacing: 2.0)),
              ),
              const SizedBox(height: 10),
              Text("What People Say About Grow Socialee", textAlign: TextAlign.center, style: GoogleFonts.bellota(fontSize: isDesktop ? 34 : 24, fontWeight: FontWeight.bold, color: Colors.white)),
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

  Widget _buildConsultationCTA() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(36),
      decoration: BoxDecoration(
        color: darkCardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accentGold, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
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
            Text(
              "Ready to Scale Your Online Brand Presence?",
              textAlign: TextAlign.center,
              style: GoogleFonts.bellota(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Get in touch with our team in Bhavnagar today for a complimentary growth session.",
              textAlign: TextAlign.center,
              style: GoogleFonts.bellota(
                fontSize: 13,
                color: textMuted,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: accentGold,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Contact()),
                );
              },
              child: Text(
                "GET IN TOUCH",
                style: GoogleFonts.bellota(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
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
                    style: GoogleFonts.bellota(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Get in touch with our team in Bhavnagar today for a complimentary growth session.",
                    style: GoogleFonts.bellota(
                      fontSize: 14,
                      color: textMuted,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: accentGold,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 4,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Contact()),
                );
              },
              child: Text(
                "GET IN TOUCH",
                style: GoogleFonts.bellota(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ],
        );
      }),
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