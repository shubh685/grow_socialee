import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';
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

  // ===== THEME (matches homepage.dart) =====
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

  @override
  State<Services> createState() => _ServicesState();
}

class _ServicesState extends State<Services> with TickerProviderStateMixin {
  int _selectedIndex = 3;
  int _selectedServiceIndex = 0;
  double _scrollOffset = 0;
  final ScrollController _scrollController = ScrollController();

  late AnimationController _transitionController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  late AnimationController _orbController;
  late AnimationController _pulseController;

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
      "Grow your brand online with strategic content and targeted campaigns.",
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
      "desc": "Improve search rankings and drive targeted organic traffic.",
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
      "desc": "Drive quality leads through optimized Meta ad campaigns.",
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
      "desc": "Modern and responsive high-performance website design.",
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
      "Strengthen your identity, build trust, and maintain online reputation.",
      "deliverables": [
        "Brand Reputation Management",
        "Social Media Monitoring",
        "Reviews & Customer Engagement"
      ],
    },
  ];

  final List<Map<String, String>> clientReviews = [
    {
      "name": "Venisha Chitalia",
      "company": "Bindu Decorators",
      "rating": "4.0",
      "review":
      "I am pleased with the social media management services provided. They have effectively increased my followers, achieving the target set within the expected timeframe. Their strategic approach delivered great value for money, and their consistent efforts have helped enhance my brand's online presence. Overall, a satisfactory experience, and I would recommend their services to anyone looking to grow their social media reach.",
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

  final List<Map<String, dynamic>> howWeWorkSteps = [
    {
      "num": "01",
      "icon": Icons.lightbulb_outline_rounded,
      "title": "Discovery Call",
      "desc": "Understand goals & audience",
    },
    {
      "num": "02",
      "icon": Icons.architecture_rounded,
      "title": "Strategy Design",
      "desc": "Craft a custom roadmap",
    },
    {
      "num": "03",
      "icon": Icons.rocket_launch_rounded,
      "title": "Execute & Optimize",
      "desc": "Launch and refine daily",
    },
    {
      "num": "04",
      "icon": Icons.trending_up_rounded,
      "title": "Scale & Report",
      "desc": "Track growth transparently",
    },
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    _transitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-0.2, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _transitionController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _transitionController, curve: Curves.easeIn),
    );

    _transitionController.forward();

    _orbController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  void _onScroll() {
    if (!mounted) return;
    final offset = _scrollController.hasClients ? _scrollController.offset : 0.0;
    if ((offset - _scrollOffset).abs() > 5) {
      setState(() => _scrollOffset = offset);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _transitionController.dispose();
    _orbController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _onSelectService(int index) {
    if (_selectedServiceIndex == index) return;
    setState(() {
      _selectedServiceIndex = index;
    });
    _transitionController.reset();
    _transitionController.forward();
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
    final bool isDesktop = screenWidth >= 900;

    return Scaffold(
      backgroundColor: Services.darkBg,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: _buildAppBar(screenWidth, isDesktop),
      ),
      endDrawer: _buildEndDrawer(screenWidth, isDesktop),
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: _buildAGHeroBanner(screenWidth, isDesktop),
          ),
          SliverToBoxAdapter(
            child: _buildCombinedServicesSection(isDesktop),
          ),
          SliverToBoxAdapter(
            child: _buildOrnamentDivider(),
          ),
          SliverToBoxAdapter(
            child: _buildUniqueReviewsSection(isDesktop),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: _buildConsultationCTA(),
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

  // ============================================================
  // APP BAR (Matches homepage.dart)
  // ============================================================
  PreferredSizeWidget _buildAppBar(double screenWidth, bool isDesktop) {
    final bool isScrolled = _scrollOffset > 30;
    return PreferredSize(
      preferredSize: const Size.fromHeight(80),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isScrolled
              ? Services.royalBlue.withOpacity(0.92)
              : Services.royalBlue,
          boxShadow: [
            BoxShadow(
              color: Services.accentGold.withOpacity(isScrolled ? 0.2 : 0.05),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.08),
                    Services.royalBlueMid.withOpacity(0.6),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Services.accentGold.withOpacity(0.35),
                  width: 1.2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLogoHeader(),
                  if (isDesktop)
                    Row(
                      children: [
                        _buildNavButton("HOME", 0, () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage()),
                          );
                        }),
                        _buildNavButton("ABOUT", 1, () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const About()),
                          );
                        }),
                        _buildNavButton("CLIENTS", 2, () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ClientLogoPage()),
                          );
                        }),
                        _buildNavButton("SERVICES", 3, () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Services()),
                          );
                        }),
                        _buildNavButton("REVIEWS", 4, () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Reviews()),
                          );
                        }),
                        const SizedBox(width: 12),
                        Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Services.accentGoldSoft,
                                Services.accentGoldDeep,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Services.accentGold.withOpacity(0.3),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
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
                              "CONTACT US",
                              style: GoogleFonts.alegreyaSc(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1A1200),
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    Builder(
                      builder: (context) => Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(50),
                          onTap: () => Scaffold.of(context).openEndDrawer(),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  Services.accentGold.withOpacity(0.2),
                                  Services.accentGoldDeep.withOpacity(0.1),
                                ],
                              ),
                              border: Border.all(
                                color: Services.accentGold.withOpacity(0.7),
                                width: 1.2,
                              ),
                            ),
                            child: const Icon(Icons.menu_rounded,
                                color: Services.accentGold, size: 22),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton(String title, int index, VoidCallback onTap) {
    final bool isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () {
        setState(() => _selectedIndex = index);
        onTap();
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: GoogleFonts.alegreyaSc(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? Services.accentGold : Services.textSoft,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 2),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 2,
              width: isSelected ? 18 : 0,
              decoration: BoxDecoration(
                color: Services.accentGold,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    HomePage.accentGold.withOpacity(0.25),
                    HomePage.accentGoldDeep.withOpacity(0.10),
                  ],
                ),
                border: Border.all(
                  color: HomePage.accentGold.withOpacity(0.7),
                  width: 1.2,
                ),
              ),
              child: Image.asset("assets/photos/img.png")
          ),
          const SizedBox(width: 12),
          Flexible(
            child: InkWell(
              child: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    HomePage.accentGoldSoft,
                    HomePage.accentGold,
                    HomePage.accentGoldDeep,
                  ],
                ).createShader(bounds),
                child: Text(
                  "We are\nGrow Socialee",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.alegreyaSc(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.05,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // END DRAWER (Matches homepage.dart)
  // ============================================================
  Widget _buildEndDrawer(double screenWidth, bool isDesktop) {
    return Drawer(
      width: isDesktop ? 380 : math.min(screenWidth * 0.85, 340),
      backgroundColor: Services.royalBlue,
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
                    Services.royalBlueMid,
                    Services.glassCard,
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
                height: 1,
                thickness: 1,
                color: Services.accentGold.withOpacity(0.4)),
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
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Services.accentGoldSoft,
                    Services.accentGold,
                    Services.accentGoldDeep,
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
            padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? const LinearGradient(
                colors: [
                  Services.accentGoldSoft,
                  Services.accentGold,
                  Services.accentGoldDeep,
                ],
              )
                  : null,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(icon,
                    size: 20,
                    color:
                    isSelected ? const Color(0xFF1A1200) : Colors.white),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: GoogleFonts.alegreyaSc(
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
                  const Icon(Icons.arrow_forward_ios_rounded,
                      size: 14, color: Color(0xFF1A1200)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HERO BANNER
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
            Services.royalBlue,
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
                    Services.accentGold.withOpacity(0.10),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Opacity(
              opacity: 0.08,
              child: Image.asset(
                "assets/photos/image.png",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const SizedBox(),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: isDesktop ? 90 : 55,
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
                    const SizedBox(width: 48),
                    Expanded(
                      flex: 5,
                      child: _buildHowWeWorkPanel(),
                    ),
                  ],
                )
                    : Column(
                  children: [
                    _buildHeroLeftText(),
                    const SizedBox(height: 40),
                    _buildHowWeWorkPanel(),
                  ],
                ),
              ),
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
            top: 100 + (math.sin(t) * 30),
            left: 40 + (math.cos(t) * 20),
            child: _orb(140, Services.accentCyan.withOpacity(0.10)),
          );
        },
      ),
      AnimatedBuilder(
        animation: _orbController,
        builder: (context, _) {
          final t = _orbController.value * 2 * math.pi + 1.5;
          return Positioned(
            bottom: 80 + (math.sin(t) * 40),
            right: 60 + (math.cos(t) * 30),
            child: _orb(180, Services.accentGold.withOpacity(0.08)),
          );
        },
      ),
      AnimatedBuilder(
        animation: _orbController,
        builder: (context, _) {
          final t = _orbController.value * 2 * math.pi + 3.0;
          return Positioned(
            top: 300 + (math.sin(t) * 25),
            right: 200 + (math.cos(t) * 20),
            child: _orb(90, Services.accentCyan.withOpacity(0.14)),
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

  Widget _buildHeroLeftText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
          decoration: BoxDecoration(
            color: Services.accentGold.withOpacity(0.12),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Services.accentGold.withOpacity(0.6),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Services.accentGold.withOpacity(0.10),
                blurRadius: 10,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.workspace_premium_rounded,
                color: Services.accentGold,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                "CHAPTER 04 · OUR SERVICES",
                style: GoogleFonts.alegreyaSc(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  color: Services.accentGold,
                  letterSpacing: 2.2,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Text(
          "Getting your name on top is our",
          style: GoogleFonts.alegreyaSc(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            height: 1.2,
          ),
        ),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [
              Services.accentGoldSoft,
              Services.accentGold,
              Services.accentGoldDeep,
            ],
          ).createShader(bounds),
          child: Text(
            "No.1 priority.",
            style: GoogleFonts.alegreyaSc(
              fontSize: 52,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.05,
              letterSpacing: -1,
            ),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          "We make sure you receive the attention your business deserves. We are not just a social media agency — we provide a multi-channel variance of services tailored for growth.",
          style: GoogleFonts.playfairDisplay(
            fontSize: 15,
            color: Services.textSoft,
            height: 1.6,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 28),
        Wrap(
          spacing: 14,
          runSpacing: 14,
          children: [
            _buildGoldGradientButton(
              icon: Icons.rocket_launch_rounded,
              label: "START A PROJECT",
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Contact()));
              },
            ),
            _buildGlassOutlineButton(
              icon: Icons.phone_rounded,
              label: "CALL US NOW",
              onTap: () => _makePhoneCall(phoneNum),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHowWeWorkPanel() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.08),
            Colors.white.withOpacity(0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Services.accentCyan.withOpacity(0.35),
          width: 1.3,
        ),
        boxShadow: [
          BoxShadow(
            color: Services.accentCyan.withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(0, 6),
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
                children: [
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, _) {
                      return Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Services.accentCyan,
                          boxShadow: [
                            BoxShadow(
                              color: Services.accentCyan.withOpacity(
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
                    "HOW WE WORK",
                    style: GoogleFonts.alegreyaSc(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      color: Services.accentCyan,
                      letterSpacing: 2.0,
                    ),
                  ),
                ],
              ),
              Text(
                "STEP · 4",
                style: GoogleFonts.alegreyaSc(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Services.textMuted,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Stack(
            children: [
              Positioned(
                left: 21,
                top: 20,
                bottom: 20,
                child: Container(
                  width: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Services.accentCyan.withOpacity(0.6),
                        Services.accentGold.withOpacity(0.6),
                      ],
                    ),
                  ),
                ),
              ),
              Column(
                children: howWeWorkSteps.map((step) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _buildHowWeWorkStep(step),
                  );
                }).toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHowWeWorkStep(Map<String, dynamic> step) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [
                Services.accentGoldSoft,
                Services.accentGold,
                Services.accentGoldDeep,
              ],
            ),
            border: Border.all(
              color: Services.royalBlue,
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: Services.accentGold.withOpacity(0.35),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Icon(
            step["icon"] as IconData,
            color: const Color(0xFF1A1200),
            size: 18,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "${step["num"]} · ",
                      style: GoogleFonts.alegreyaSc(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Services.accentCyan,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        step["title"] as String,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  step["desc"] as String,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 12,
                    color: Services.textMuted,
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
            Services.accentGoldSoft,
            Services.accentGold,
            Services.accentGoldDeep,
          ],
        ),
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Services.accentGold.withOpacity(0.35),
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
          style: GoogleFonts.alegreyaSc(
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
          color: Services.accentCyan.withOpacity(0.8),
          width: 1.6,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      icon: Icon(icon, size: 18, color: Services.accentCyan),
      label: Text(
        label,
        style: GoogleFonts.alegreyaSc(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.8,
        ),
      ),
      onPressed: onTap,
    );
  }

  // ============================================================
  // COMBINED SERVICES SECTION
  // ============================================================
  Widget _buildCombinedServicesSection(bool isDesktop) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Services.royalBlue,
            Services.royalBlueMid,
          ],
        ),
      ),
      padding: EdgeInsets.symmetric(
        vertical: 60,
        horizontal: isDesktop ? 60 : 20,
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1250),
          child: Column(
            children: [
              _buildSectionPill("WHAT WE OFFER"),
              const SizedBox(height: 14),
              Text(
                "Tailored Growth Solutions",
                textAlign: TextAlign.center,
                style: GoogleFonts.alegreyaSc(
                  fontSize: isDesktop ? 36 : 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
              isDesktop
                  ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      children:
                      List.generate(serviceData.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: _buildServiceCard(
                            service: serviceData[index],
                            index: index,
                            isCompact: true,
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    flex: 2,
                    child: _buildInteractiveDetailCard(isDesktop),
                  ),
                ],
              )
                  : Column(
                children: [
                  Column(
                    children:
                    List.generate(serviceData.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: _buildServiceCard(
                          service: serviceData[index],
                          index: index,
                          isCompact: false,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 32),
                  _buildInteractiveDetailCard(isDesktop),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionPill(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Services.accentGold.withOpacity(0.15),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Services.accentGold.withOpacity(0.6)),
      ),
      child: Text(
        label,
        style: GoogleFonts.alegreyaSc(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Services.accentGold,
          letterSpacing: 2.0,
        ),
      ),
    );
  }

  Widget _buildServiceCard({
    required Map<String, dynamic> service,
    required int index,
    required bool isCompact,
  }) {
    final bool isSelected = _selectedServiceIndex == index;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _onSelectService(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: isCompact ? 14 : 18,
          ),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Services.accentGold.withOpacity(0.14),
                Services.accentGoldDeep.withOpacity(0.06),
              ],
            )
                : LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.06),
                Colors.white.withOpacity(0.02),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? Services.accentGold
                  : Services.accentCyan.withOpacity(0.25),
              width: isSelected ? 1.8 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? Services.accentGold.withOpacity(0.25)
                    : Colors.black.withOpacity(0.10),
                blurRadius: isSelected ? 16 : 6,
                spreadRadius: isSelected ? 1 : 0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? const LinearGradient(
                    colors: [
                      Services.accentGoldSoft,
                      Services.accentGoldDeep
                    ],
                  )
                      : LinearGradient(
                    colors: [
                      Services.accentCyan.withOpacity(0.20),
                      Services.accentCyan.withOpacity(0.08),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? Services.accentGold
                        : Services.accentCyan.withOpacity(0.4),
                    width: 1,
                  ),
                ),
                child: Icon(
                  service["icon"] as IconData,
                  color: isSelected ? const Color(0xFF1A1200) : Services.accentCyan,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      service["title"] as String,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Services.accentGold : Colors.white,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      service["desc"] as String,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 12,
                        color: isSelected
                            ? Services.textSoft
                            : Colors.white.withOpacity(0.55),
                        height: 1.2,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: isSelected ? Services.accentGold : Colors.white24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInteractiveDetailCard(bool isDesktop) {
    final activeService = serviceData[_selectedServiceIndex];

    return Container(
      constraints: BoxConstraints(minHeight: isDesktop ? 440 : 0),
      padding: EdgeInsets.all(isDesktop ? 36 : 24),
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
        border: Border.all(
          color: Services.accentGold.withOpacity(0.6),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Services.accentGold.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.20),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Services.accentGoldSoft,
                          Services.accentGoldDeep
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Services.accentGold.withOpacity(0.35),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      activeService["icon"] as IconData,
                      color: const Color(0xFF1A1200),
                      size: 34,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Services.accentCyan.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Services.accentCyan.withOpacity(0.55),
                            ),
                          ),
                          child: Text(
                            activeService["tag"] as String,
                            style: GoogleFonts.alegreyaSc(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Services.accentCyan,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [
                              Services.accentGoldSoft,
                              Services.accentGoldDeep
                            ],
                          ).createShader(bounds),
                          child: Text(
                            activeService["title"] as String,
                            style: GoogleFonts.alegreyaSc(
                              fontSize: isDesktop ? 26 : 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Text(
                activeService["desc"] as String,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 15,
                  color: Services.textMuted,
                  height: 1.6,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Container(
                    width: 30,
                    height: 2,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Services.accentGold, Services.accentCyan],
                      ),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "WHAT WE DELIVER",
                    style: GoogleFonts.alegreyaSc(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children:
                (activeService["deliverables"] as List<String>).map((item) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Services.accentCyan.withOpacity(0.35),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          size: 16,
                          color: Services.accentGold,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            item,
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ORNAMENT DIVIDER
  // ============================================================
  Widget _buildOrnamentDivider() {
    return Container(
      width: double.infinity,
      color: Services.royalBlueMid,
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
                    Services.accentGold.withOpacity(0.6),
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
                    colors: [Services.accentGoldSoft, Services.accentGoldDeep],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Services.accentGold.withOpacity(0.5),
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
                    Services.accentGold.withOpacity(0.6),
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
  // REVIEWS SECTION
  // ============================================================
  Widget _buildUniqueReviewsSection(bool isDesktop) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Services.royalBlueMid,
            Services.royalBlue,
          ],
        ),
      ),
      padding: EdgeInsets.symmetric(
        vertical: 70,
        horizontal: isDesktop ? 60 : 20,
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            children: [
              _buildSectionPill("CLIENT STORIES"),
              const SizedBox(height: 14),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    Services.accentGoldSoft,
                    Services.accentGold,
                    Services.accentGoldDeep
                  ],
                ).createShader(bounds),
                child: Text(
                  "What People Say About Grow Socialee",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.alegreyaSc(
                    fontSize: isDesktop ? 34 : 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              LayoutBuilder(
                builder: (context, constraints) {
                  return Wrap(
                    spacing: 24,
                    runSpacing: 24,
                    alignment: WrapAlignment.center,
                    children: clientReviews.asMap().entries.map((entry) {
                      final int idx = entry.key;
                      final rev = entry.value;
                      double cardWidth = isDesktop
                          ? (constraints.maxWidth - 24) / 2
                          : constraints.maxWidth;
                      double ratingVal =
                          double.tryParse(rev["rating"] ?? "5.0") ?? 5.0;

                      return SizedBox(
                        width: cardWidth,
                        child: _buildReviewCard(rev, ratingVal, idx),
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

  Widget _buildReviewCard(
      Map<String, String> rev, double ratingVal, int index) {
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
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: index.isEven
              ? Services.accentGold.withOpacity(0.55)
              : Services.accentCyan.withOpacity(0.45),
          width: 1.4,
        ),
        boxShadow: [
          BoxShadow(
            color: (index.isEven ? Services.accentGold : Services.accentCyan)
                .withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -20,
            right: 0,
            child: Text(
              '"',
              style: GoogleFonts.playfairDisplay(
                fontSize: 120,
                fontWeight: FontWeight.bold,
                color: (index.isEven ? Services.accentGold : Services.accentCyan)
                    .withOpacity(0.15),
                height: 1,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: List.generate(
                      5,
                          (i) => Icon(
                        i < ratingVal.floor()
                            ? Icons.star_rounded
                            : Icons.star_half_rounded,
                        color: Services.accentGold,
                        size: 18,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Services.accentGold.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Services.accentGold.withOpacity(0.5),
                      ),
                    ),
                    child: Text(
                      rev["tag"]!,
                      style: GoogleFonts.alegreyaSc(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Services.accentGold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                '"${rev["review"]!}"',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 14,
                  color: Colors.white,
                  height: 1.65,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(height: 24),
              Divider(color: Colors.white.withOpacity(0.12), height: 1),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [
                          Services.accentGoldSoft,
                          Services.accentGoldDeep
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Services.accentGold.withOpacity(0.35),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Services.royalBlue,
                      child: Text(
                        rev["name"]![0],
                        style: GoogleFonts.alegreyaSc(
                          fontWeight: FontWeight.bold,
                          color: Services.accentGold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          rev["name"]!,
                          style: GoogleFonts.alegreyaSc(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          rev["company"]!,
                          style: GoogleFonts.alegreyaSc(
                            fontSize: 12,
                            color: Services.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CONSULTATION CTA
  // ============================================================
  Widget _buildConsultationCTA() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(36),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.08),
            Colors.white.withOpacity(0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Services.accentGold.withOpacity(0.6),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Services.accentGold.withOpacity(0.20),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 650;
        return isMobile
            ? Column(
          children: [
            const Icon(Icons.rocket_launch_rounded,
                color: Services.accentGold, size: 34),
            const SizedBox(height: 14),
            Text(
              "Ready to Scale Your Online Brand Presence?",
              textAlign: TextAlign.center,
              style: GoogleFonts.alegreyaSc(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Get in touch with our team in Bhavnagar today for a complimentary growth session.",
              textAlign: TextAlign.center,
              style: GoogleFonts.playfairDisplay(
                fontSize: 13,
                color: Services.textMuted,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 24),
            _buildGoldGradientButton(
              icon: Icons.arrow_forward_rounded,
              label: "GET IN TOUCH",
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Contact()));
              },
            ),
          ],
        )
            : Row(
          children: [
            const Icon(Icons.rocket_launch_rounded,
                color: Services.accentGold, size: 40),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Ready to Scale Your Online Brand Presence?",
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Get in touch with our team in Bhavnagar today for a complimentary growth session.",
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 14,
                      color: Services.textMuted,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24),
            _buildGoldGradientButton(
              icon: Icons.arrow_forward_rounded,
              label: "GET IN TOUCH",
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Contact()));
              },
            ),
          ],
        );
      }),
    );
  }

  // ============================================================
  // FOOTER (Matches homepage.dart)
  // ============================================================
  Widget _buildAGFooter(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth >= 900;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Services.royalBlue,
            Color(0xFF05132B),
          ],
        ),
      ),
      child: Column(
        children: [
          Divider(
              height: 1,
              thickness: 1,
              color: Services.accentGold.withOpacity(0.4)),
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
          style: GoogleFonts.playfairDisplay(
            fontSize: 14,
            color: Services.textMuted,
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
          style: GoogleFonts.alegreyaSc(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Services.accentGold,
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
            Icon(icon, size: 18, color: Services.accentGold),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                maxLines: isMultiLine ? 3 : 1,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 13,
                  color: isMultiLine ? Colors.white : Services.textMuted,
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
          style: GoogleFonts.alegreyaSc(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Services.accentGold,
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
        border: Border.all(color: Services.accentGold.withOpacity(0.6)),
        boxShadow: [
          BoxShadow(
            color: Services.accentGold.withOpacity(0.10),
            blurRadius: 8,
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, size: 18, color: Services.accentGold),
        onPressed: () => _launchUrlString(url),
      ),
    );
  }
}