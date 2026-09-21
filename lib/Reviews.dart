import 'dart:async';
import 'dart:math' as math;
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

class _ReviewsState extends State<Reviews> with TickerProviderStateMixin {
  int _selectedIndex = 4;

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

  // Compatibility aliases
  static const Color textMutedLegacy = Color(0xFFB8D4F0);

  final ScrollController _scrollController = ScrollController();
  final GlobalKey<_ReviewsStatsState> _statsKey = GlobalKey<_ReviewsStatsState>();

  late AnimationController _orbController;
  late AnimationController _pulseController;

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
      "I am pleased with the social media management services provided. They have effectively increased my followers, achieving the target set within the expected timeframe. Their strategic approach delivered great value for money, and their consistent efforts have helped enhance my brand's online presence.",
      "tag": "Brand Marketing",
      "isFeatured": "false"
    },
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScrollCheck);

    _orbController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
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
    _orbController.dispose();
    _pulseController.dispose();
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
        child: _buildAppBar(isDesktop),
      ),
      endDrawer: _buildEndDrawer(screenWidth, isDesktop),
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: _buildHeroBanner(screenWidth, isDesktop),
          ),
          SliverToBoxAdapter(
            child: _ReviewsStats(key: _statsKey, isDesktop: isDesktop),
          ),
          SliverToBoxAdapter(
            child: _buildFeaturedReviewSpotlight(isDesktop),
          ),
          SliverToBoxAdapter(
            child: _buildOrnamentDivider(),
          ),
          SliverToBoxAdapter(
            child: _buildReviewsSection(isDesktop),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: _buildGoogleReviewCTA(),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _buildFooter(context),
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
  // HERO BANNER
  // ============================================================
  Widget _buildHeroBanner(double screenWidth, bool isDesktop) {
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
          // Floating orbs
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
              opacity: 0.06,
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
                constraints: const BoxConstraints(maxWidth: 1100),
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
                      child: _buildHeroRatingCard(),
                    ),
                  ],
                )
                    : Column(
                  children: [
                    _buildHeroLeftText(),
                    const SizedBox(height: 40),
                    _buildHeroRatingCard(),
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

  Widget _buildHeroLeftText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                Icons.star_rounded,
                color: accentGold,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                "CHAPTER 05 · CLIENT TESTIMONIALS",
                style: GoogleFonts.bellota(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  color: accentGold,
                  letterSpacing: 2.2,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Text(
          "Proven Impact &",
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
            "Authentic Voices.",
            style: GoogleFonts.bellota(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.1,
              letterSpacing: -0.5,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          "Discover real experiences from brand owners and business partners who transformed their digital footprint with Grow Socialee.",
          style: GoogleFonts.bellota(
            fontSize: 15,
            color: textSoft,
            height: 1.6,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 28),
        // Pulsing live indicator
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: accentCyan.withOpacity(0.08),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: accentCyan.withOpacity(0.5),
              width: 1,
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
                      shape: BoxShape.circle,
                      color: accentCyan,
                      boxShadow: [
                        BoxShadow(
                          color: accentCyan.withOpacity(
                              0.4 + 0.5 * _pulseController.value),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(width: 10),
              Text(
                "20+ VERIFIED REVIEWS ON GOOGLE",
                style: GoogleFonts.bellota(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: accentCyan,
                  letterSpacing: 1.6,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeroRatingCard() {
    return Container(
      padding: const EdgeInsets.all(24),
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
          color: accentCyan.withOpacity(0.35),
          width: 1.3,
        ),
        boxShadow: [
          BoxShadow(
            color: accentCyan.withOpacity(0.15),
            blurRadius: 22,
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
              Text(
                "GOOGLE RATING",
                style: GoogleFonts.bellota(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: accentCyan,
                  letterSpacing: 2.0,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      accentGoldSoft.withOpacity(0.25),
                      accentGoldDeep.withOpacity(0.12),
                    ],
                  ),
                  border: Border.all(
                    color: accentGold.withOpacity(0.5),
                  ),
                ),
                child: const Icon(
                  FontAwesomeIcons.google,
                  size: 16,
                  color: accentGold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    accentGoldSoft,
                    accentGold,
                    accentGoldDeep,
                  ],
                ).createShader(bounds),
                child: Text(
                  "4.9",
                  style: GoogleFonts.bellota(
                    fontSize: 62,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.0,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  "/ 5.0",
                  style: GoogleFonts.bellota(
                    fontSize: 16,
                    color: textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(
              5,
                  (i) => const Padding(
                padding: EdgeInsets.only(right: 4),
                child: Icon(
                  Icons.star_rounded,
                  color: accentGold,
                  size: 20,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Divider(color: Colors.white.withOpacity(0.12), height: 1),
          const SizedBox(height: 16),
          Wrap(
            spacing: 20,
            runSpacing: 10,
            children: [
              _buildMiniStat("99%", "Retention"),
              _buildMiniStat("20+", "Reviews"),
              _buildMiniStat("50+", "Clients"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [accentGoldSoft, accentGoldDeep],
          ).createShader(bounds),
          child: Text(
            value,
            style: GoogleFonts.bellota(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.0,
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.bellota(
            fontSize: 11,
            color: textMuted,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // FEATURED SPOTLIGHT
  // ============================================================
  Widget _buildFeaturedReviewSpotlight(bool isDesktop) {
    final featured =
    clientReviews.firstWhere((r) => r["isFeatured"] == "true");

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            royalBlue,
            royalBlueMid,
          ],
        ),
      ),
      padding: EdgeInsets.symmetric(
        vertical: 50,
        horizontal: isDesktop ? 60 : 20,
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.08),
                  Colors.white.withOpacity(0.02),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: accentGold.withOpacity(0.7),
                width: 1.6,
              ),
              boxShadow: [
                BoxShadow(
                  color: accentGold.withOpacity(0.22),
                  blurRadius: 28,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Giant quote mark
                Positioned(
                  top: -30,
                  right: -10,
                  child: Text(
                    '"',
                    style: GoogleFonts.bellota(
                      fontSize: 180,
                      fontWeight: FontWeight.bold,
                      color: accentGold.withOpacity(0.12),
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
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                accentGoldSoft,
                                accentGold,
                                accentGoldDeep,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: accentGold.withOpacity(0.35),
                                blurRadius: 12,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.workspace_premium_rounded,
                                size: 12,
                                color: Color(0xFF1A1200),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "FEATURED STORY",
                                style: GoogleFonts.bellota(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF1A1200),
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: List.generate(
                            5,
                                (i) => const Icon(
                              Icons.star_rounded,
                              color: accentGold,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    Text(
                      '"${featured["review"]!}"',
                      style: GoogleFonts.bellota(
                        fontSize: isDesktop ? 17 : 14.5,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        height: 1.65,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 26),
                    Divider(color: Colors.white.withOpacity(0.12), height: 1),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [
                                accentGoldSoft,
                                accentGoldDeep,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: accentGold.withOpacity(0.35),
                                blurRadius: 14,
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 22,
                            backgroundColor: royalBlue,
                            child: Text(
                              featured["name"]![0],
                              style: GoogleFonts.bellota(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: accentGold,
                              ),
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
              ],
            ),
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
  // REVIEWS SECTION
  // ============================================================
  Widget _buildReviewsSection(bool isDesktop) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            royalBlueMid,
            royalBlue,
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
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: accentGold.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(30),
                  border:
                  Border.all(color: accentGold.withOpacity(0.6)),
                ),
                child: Text(
                  "CLIENT STORIES",
                  style: GoogleFonts.bellota(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: accentGold,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    Colors.white,
                    accentGoldSoft,
                  ],
                ).createShader(bounds),
                child: Text(
                  "What People Say About Grow Socialee",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.bellota(
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
    final accent = index.isEven ? accentGold : accentCyan;

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
          color: accent.withOpacity(0.55),
          width: 1.4,
        ),
        boxShadow: [
          BoxShadow(
            color: accent.withOpacity(0.14),
            blurRadius: 18,
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
              style: GoogleFonts.bellota(
                fontSize: 120,
                fontWeight: FontWeight.bold,
                color: accent.withOpacity(0.12),
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
                        color: accentGold,
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
                      color: accent.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: accent.withOpacity(0.5),
                      ),
                    ),
                    child: Text(
                      rev["tag"]!,
                      style: GoogleFonts.bellota(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: accent,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                '"${rev["review"]!}"',
                style: GoogleFonts.bellota(
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
                      gradient: LinearGradient(
                        colors: [
                          accent.withOpacity(0.6),
                          accent.withOpacity(0.15),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: accent.withOpacity(0.35),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: royalBlue,
                      child: Text(
                        rev["name"]![0],
                        style: GoogleFonts.bellota(
                          fontWeight: FontWeight.bold,
                          color: accent,
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
  // GOOGLE REVIEW CTA
  // ============================================================
  Widget _buildGoogleReviewCTA() {
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
          color: accentCyan.withOpacity(0.55),
          width: 1.6,
        ),
        boxShadow: [
          BoxShadow(
            color: accentCyan.withOpacity(0.20),
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
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [accentGoldSoft, accentGoldDeep],
                ),
                boxShadow: [
                  BoxShadow(
                    color: accentGold.withOpacity(0.35),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: const Icon(
                FontAwesomeIcons.google,
                size: 26,
                color: Color(0xFF1A1200),
              ),
            ),
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
            _buildGoogleButton(),
          ],
        )
            : Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [accentGoldSoft, accentGoldDeep],
                ),
                boxShadow: [
                  BoxShadow(
                    color: accentGold.withOpacity(0.35),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: const Icon(
                FontAwesomeIcons.google,
                size: 26,
                color: Color(0xFF1A1200),
              ),
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
            _buildGoogleButton(),
          ],
        );
      }),
    );
  }

  Widget _buildGoogleButton() {
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
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        icon: const Icon(
          Icons.open_in_new_rounded,
          size: 16,
          color: Color(0xFF1A1200),
        ),
        label: Text(
          "VIEW ON GOOGLE MAPS",
          style: GoogleFonts.bellota(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.0,
          ),
        ),
        onPressed: () => _launchUrlString(googleReviewsUrl),
      ),
    );
  }

  // ============================================================
  // FOOTER
  // ============================================================
  Widget _buildFooter(BuildContext context) {
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
// REVIEWS STATS SECTION
// ============================================================
class _ReviewsStats extends StatefulWidget {
  final bool isDesktop;

  const _ReviewsStats({super.key, required this.isDesktop});

  @override
  State<_ReviewsStats> createState() => _ReviewsStatsState();
}

class _ReviewsStatsState extends State<_ReviewsStats>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final ScrollController _scrollController = ScrollController();
  Timer? _autoScrollTimer;

  bool _hasAnimated = false;

  final List<_StatData> _stats = [
    _StatData(
        endValue: 4.9,
        suffix: "★",
        label: "AVERAGE RATING",
        isDecimal: true),
    _StatData(endValue: 60, suffix: "+", label: "CAMPAIGNS DELIVERED"),
    _StatData(endValue: 99, suffix: "%", label: "CLIENT RETENTION"),
    _StatData(endValue: 20, suffix: "+", label: "REVIEWS"),
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
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _ReviewsState.royalBlueMid,
            _ReviewsState.royalBlue,
          ],
        ),
      ),
      padding: EdgeInsets.symmetric(
        vertical: 50,
        horizontal: widget.isDesktop ? 60 : 20,
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: widget.isDesktop
              ? LayoutBuilder(
            builder: (context, constraints) {
              int columns = 4;
              if (constraints.maxWidth < 900) columns = 2;
              final double spacing = 16;
              final double w = (constraints.maxWidth -
                  (spacing * (columns - 1))) /
                  columns;
              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                alignment: WrapAlignment.center,
                children: List.generate(_stats.length, (index) {
                  return SizedBox(
                    width: w,
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) =>
                          _buildStatCard(_stats[index], _animation.value),
                    ),
                  );
                }),
              );
            },
          )
              : SizedBox(
            height: 140,
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

  Widget _buildStatCard(_StatData item, double progress) {
    double currentValue = item.endValue * progress;
    String formattedValue = item.isDecimal
        ? currentValue.toStringAsFixed(1)
        : currentValue.toInt().toString();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.10),
            Colors.white.withOpacity(0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _ReviewsState.accentGold.withOpacity(0.6),
          width: 1.4,
        ),
        boxShadow: [
          BoxShadow(
            color: _ReviewsState.accentCyan.withOpacity(0.10),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [
                _ReviewsState.accentGoldSoft,
                _ReviewsState.accentGold,
                _ReviewsState.accentGoldDeep,
              ],
            ).createShader(bounds),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                "$formattedValue${item.suffix}",
                style: GoogleFonts.bellota(
                  fontSize: widget.isDesktop ? 34 : 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.0,
                ),
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

class _StatData {
  final double endValue;
  final String suffix;
  final String label;
  final bool isDecimal;

  _StatData({
    required this.endValue,
    required this.suffix,
    required this.label,
    this.isDecimal = false,
  });
}