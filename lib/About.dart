import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grow_socialee/Client_Logos.dart';
import 'package:grow_socialee/Services.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Reviews.dart';
import 'contact.dart';
import 'home_page.dart';

// ============================================================
// ABOUT PAGE — THEME (matches HomePage royal blue + gold)
// ============================================================
class AboutTheme {
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
}

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  int _selectedIndex = 1;
  double _scrollOffset = 0;

  final GlobalKey<_ValuesSectionState> _valuesKey =
  GlobalKey<_ValuesSectionState>();
  final GlobalKey<_TeamSectionState> _teamKey = GlobalKey<_TeamSectionState>();

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
      backgroundColor: AboutTheme.darkBg,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: _buildAppBar(screenWidth, isDesktop),
      ),
      endDrawer: _buildEndDrawer(screenWidth, isDesktop),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          // Values section uses its own visibility check
          _valuesKey.currentState?.checkVisibility();
          // Team section uses VisibilityDetector (no manual call needed)
          return false;
        },
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: _buildAGHeroBanner(screenWidth, isDesktop),
            ),
            SliverToBoxAdapter(
              child: _buildPhilosophyStrip(isDesktop),
            ),
            SliverToBoxAdapter(
              child: _buildCapabilitiesSection(isDesktop),
            ),
            SliverToBoxAdapter(
              child: _buildOrnamentDivider(),
            ),
            SliverToBoxAdapter(
              child: ValuesSection(key: _valuesKey, isDesktop: isDesktop),
            ),
            SliverToBoxAdapter(
              child: _buildOrnamentDivider(),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: AboutTheme.accentGold.withOpacity(0.1),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child:  Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 24,
                          height: 1.5,
                          color: AboutTheme.darkBg,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "FOUNDER'S HISTORY",
                          style: GoogleFonts.poppins(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            color: AboutTheme.darkCardBg,
                            letterSpacing: 2.5,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: 24,
                          height: 1.5,
                          color: AboutTheme.darkBg,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: _AboutSplitSectionAnimated(screenWidth: screenWidth, isDesktop: isDesktop),
            ),
            SliverToBoxAdapter(
              child: _buildOrnamentDivider(),
            ),
            SliverToBoxAdapter(
              child: TeamSection(key: _teamKey, isDesktop: isDesktop),
            ),
            SliverToBoxAdapter(
              child: _buildOrnamentDivider(),
            ),
            SliverToBoxAdapter(
              child: _buildFooter(context),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // APP BAR
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
              ? HomePage.royalBlue.withOpacity(0.92)
              : HomePage.royalBlue,
          boxShadow: [
            BoxShadow(
              color: HomePage.accentGold.withOpacity(isScrolled ? 0.2 : 0.05),
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
                    HomePage.royalBlueMid.withOpacity(0.6),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: HomePage.accentGold.withOpacity(0.35),
                  width: 1.2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 3,
                    child: _buildLogoHeader(),
                  ),
                  const SizedBox(width: 8),
                  if (isDesktop)
                    Flexible(
                      flex: 7,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
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
                                    builder: (context) =>
                                    const ClientLogoPage()),
                              );
                            }),
                            _buildNavButton("SERVICES", 3, () {
                              Navigator.push(
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
                            _HoverScale(
                              scale: 1.05,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      HomePage.accentGoldSoft,
                                      HomePage.accentGoldDeep,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: HomePage.accentGold
                                          .withOpacity(0.3),
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
                                          builder: (context) =>
                                          const Contact()),
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
                            ),
                          ],
                        ),
                      ),
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
                                  HomePage.accentGold.withOpacity(0.2),
                                  HomePage.accentGoldDeep.withOpacity(0.1),
                                ],
                              ),
                              border: Border.all(
                                color: HomePage.accentGold.withOpacity(0.7),
                                width: 1.2,
                              ),
                            ),
                            child: const Icon(Icons.menu_rounded,
                                color: HomePage.accentGold, size: 22),
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
                color:
                isSelected ? AboutTheme.accentGold : AboutTheme.textSoft,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 2),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 2,
              width: isSelected ? 18 : 0,
              decoration: BoxDecoration(
                color: AboutTheme.accentGold,
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
          InkWell(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HomePage())),
            child: Container(
              height: 50,
              width: 50,
              padding: const EdgeInsets.all(4),
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
              child: ClipOval(
                child: Image.asset(
                  "assets/photos/logo.png",
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.broken_image,
                    color: HomePage.accentGold,
                    size: 24,
                  ),
                ),
              ),
            ),
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
  // END DRAWER
  // ============================================================
  Widget _buildEndDrawer(double screenWidth, bool isDesktop) {
    return Drawer(
      width: isDesktop ? 380 : screenWidth * 0.8,
      backgroundColor: AboutTheme.royalBlue,
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
                    AboutTheme.royalBlueMid,
                    AboutTheme.glassCard,
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
              color: AboutTheme.accentGold.withOpacity(0.4),
            ),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Reviews()),
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
            Container(
              height: 4,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AboutTheme.accentGoldSoft,
                    AboutTheme.accentGold,
                    AboutTheme.accentGoldDeep,
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
                  AboutTheme.accentGoldSoft,
                  AboutTheme.accentGold,
                  AboutTheme.accentGoldDeep,
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
  Widget _buildAGHeroBanner(double screenWidth, bool isDesktop) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0.6, -0.3),
          radius: 1.4,
          colors: [
            Color(0xFF173F7B),
            AboutTheme.royalBlue,
            Color(0xFF061733),
          ],
        ),
      ),
      child: Stack(
        children: [
          // ---- decorative glows ----
          Positioned(
            top: -80,
            right: -80,
            child: Container(
              width: 340,
              height: 340,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AboutTheme.accentGold.withOpacity(0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AboutTheme.accentCyan.withOpacity(0.14),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Opacity(
              opacity: 0.08,
              child: CustomPaint(painter: _AboutHeroPatternPainter()),
            ),
          ),

          // ============================================================
          //  FRAME — wide / short layout matching reference photo
          // ============================================================
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: isDesktop ? 12 : 8,
              horizontal: isDesktop ? 24 : 12,
            ),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1150),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.06),
                      Colors.white.withOpacity(0.02),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AboutTheme.accentGold.withOpacity(0.3),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AboutTheme.royalBlueMid.withOpacity(0.4),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(isDesktop ? 16 : 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isDesktop
                        ? SizedBox(
                      height: 300,                          // ← fixed hero content height
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // ---------- COLUMN 1: 55% ----------
                          Expanded(
                            flex: 110,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                _buildHeroLeftText(isDesktop: true),
                                const SizedBox(height: 18),
                                _buildHeroRightBadges(true, screenWidth),
                              ],
                            ),
                          ),

                          const SizedBox(width: 13),

                          // ---------- VERTICAL DIVIDER ----------
                          Container(
                            width: 1.2,
                            decoration: BoxDecoration(
                              color: AboutTheme.accentGold
                            ),
                          ),

                          const SizedBox(width: 12.5),

                          // ---------- COLUMN 2: 45% ----------
                          Expanded(
                            flex: 90,
                            child: _buildHeroCompanyContent(isDesktop: true),
                          ),
                        ],
                      ),
                    )
                        : Column(/* …unchanged mobile… */),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroLeftText({bool isDesktop = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // "Crafting Digital"
        Text(
          "Crafting Digital",
          style: GoogleFonts.alegreyaSc(
            fontSize: isDesktop ? 30 : 26,           // ↓ 32 → 30
            fontWeight: FontWeight.w500,
            color: Colors.white,
            height: 1.05,
            letterSpacing: -0.5,
          ),
        ),
        // "Legacies"
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [
              AboutTheme.accentGoldSoft,
              AboutTheme.accentGold,
              AboutTheme.accentGoldDeep,
            ],
          ).createShader(bounds),
          child: Text(
            "Legacies",
            style: GoogleFonts.alegreyaSc(
              fontSize: isDesktop ? 54 : 44,         // ↓ 60 → 54
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.05,
              letterSpacing: -1.5,
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Merged subtitle
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "Through Strategic Innovation. ",
                style: GoogleFonts.alegreyaSc(
                  fontSize: isDesktop ? 16 : 16,     // ↓ 18 → 16
                  fontWeight: FontWeight.w400,
                  color: AboutTheme.accentCyan,
                  height: 1.4,
                ),
              ),
              TextSpan(
                text:
                "We combine creative thinking, data-driven strategy, and design excellence to help brands dominate their digital space.",
                style: GoogleFonts.playfairDisplay(
                  fontSize: isDesktop ? 13.5 : 13.5, // ↓ 14 → 13.5
                  color: AboutTheme.textSoft,
                  height: 1.4,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.justify,
          softWrap: true,
        ),
      ],
    );
  }

  // RIGHT SIDE BADGES — compact vertical stack beside headline
  Widget _buildHeroRightBadges(bool isDesktop, double screenWidth) {
    final badges = [
      {
        "icon": Icons.emoji_events_outlined,
        "label": "AWARD-WINNING",
      },
      {
        "icon": Icons.groups_2_outlined,
        "label": "14-PERSON TEAM",
      },
      {
        "icon": Icons.trending_up_rounded,
        "label": "50+ BRANDS",
      },
    ];

    if (isDesktop) {
      return LayoutBuilder(
        builder: (context, constraints) {
          const double spacing = 10.0;
          const int count = 3;
          final double badgeWidth =
              (constraints.maxWidth - spacing * (count - 1)) / count;

          return IntrinsicHeight(                 // ← gives the Row a height
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: badges.asMap().entries.map((entry) {
                final i = entry.key;
                final b = entry.value;
                return Padding(
                  padding: EdgeInsets.only(left: i == 0 ? 0 : spacing),
                  child: SizedBox(
                    width: badgeWidth,
                    child: _buildHeroBadge(
                      icon: b["icon"] as IconData,
                      label: b["label"] as String,
                      isDesktopOrTablet: true,
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      );
    }

    // MOBILE / TABLET wrap
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final bool isTablet = availableWidth > 600;

        double itemWidth = isTablet ? (availableWidth - 16) / 2 : availableWidth;

        return Wrap(
          spacing: 16,
          runSpacing: 12,
          alignment: WrapAlignment.start,
          children: badges.map((b) {
            return SizedBox(
              width: itemWidth,
              child: _buildHeroBadge(
                icon: b["icon"] as IconData,
                label: b["label"] as String,
                isDesktopOrTablet: isTablet,
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildHeroBadge({
    required IconData icon,
    required String label,
    bool isDesktopOrTablet = false,
  }) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 60),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.08),
            Colors.white.withOpacity(0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AboutTheme.accentCyan.withOpacity(0.35),
          width: 1.1,
        ),
        boxShadow: [
          BoxShadow(
            color: AboutTheme.accentCyan.withOpacity(0.10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AboutTheme.accentGoldSoft,
                  AboutTheme.accentGoldDeep,
                ],
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: AboutTheme.accentGold.withOpacity(0.22),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Icon(icon, color: const Color(0xFF1A1200), size: 17),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              style: GoogleFonts.poppins(
                fontSize: 11.85,                // ← slight bump from 11.5
                fontWeight: FontWeight.w800,
                color: AboutTheme.accentGold,
                letterSpacing: 0.6,
                height: 1.15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCompanyContent({required bool isDesktop}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Chapter chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.5, vertical: 5.5),
          decoration: BoxDecoration(
            color: AboutTheme.accentGold.withOpacity(0.12),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: AboutTheme.accentGold.withOpacity(0.6),
              width: 1.2,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.auto_awesome_rounded,
                  size: 14, color: AboutTheme.accentGold),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  "CHAPTER 01 · About Grow Socialee",
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: AboutTheme.accentGold,
                    letterSpacing: isDesktop ? 2.2 : 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  //  build philosphy card
  // ============================================================
  // PHILOSOPHY STRIP
  // ============================================================
  Widget _buildPhilosophyStrip(bool isDesktop) {
    final items = [
      {"icon": Icons.visibility_outlined, "label": "VISION-LED"},
      {"icon": Icons.auto_graph_rounded, "label": "DATA-DRIVEN"},
      {"icon": Icons.palette_outlined, "label": "DESIGN-FIRST"},
      {"icon": Icons.handshake_outlined, "label": "CLIENT-OBSESSED"},
    ];

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AboutTheme.royalBlueMid,
            AboutTheme.glassCard,
            AboutTheme.royalBlueMid,
          ],
        ),
      ),
      padding: EdgeInsets.symmetric(
        vertical: isDesktop ? 18 : 16,
        horizontal: isDesktop ? 60 : 20,
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: isDesktop ? 40 : 20,
            runSpacing: 14,
            children: items.map((it) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(it["icon"] as IconData,
                      color: AboutTheme.accentCyan, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    it["label"] as String,
                    style: GoogleFonts.alegreyaSc(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: AboutTheme.accentWhite,
                      letterSpacing: 1.8,
                    ),
                  ),
                ],
              );
            }).toList(),
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
      color: AboutTheme.royalBlueMid,
      padding: const EdgeInsets.symmetric(vertical: 24),
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
                    AboutTheme.accentGold.withOpacity(0.6),
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
                    colors: [
                      AboutTheme.accentGoldSoft,
                      AboutTheme.accentGoldDeep,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AboutTheme.accentGold.withOpacity(0.5),
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
                    AboutTheme.accentGold.withOpacity(0.6),
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
  // CAPABILITIES SECTION
  // ============================================================
  Widget _buildCapabilitiesSection(bool isDesktop) {
    final capabilities = [
      {
        "num": "01",
        "title": "Brand Strategy & Design",
        "desc":
        "Positioning your business with robust brand identities, logo assets, and visual guidelines.",
        "icon": Icons.palette_outlined,
        "color": AboutTheme.accentGold,
      },
      {
        "num": "02",
        "title": "Social Media Growth",
        "desc":
        "End-to-end community management, content curation, and data analytics across all platforms.",
        "icon": Icons.share_rounded,
        "color": AboutTheme.accentCyan,
      },
      {
        "num": "03",
        "title": "High-Impact Video Production",
        "desc":
        "Short-form video editing, brand reels, and promo ads designed to maximize audience engagement.",
        "icon": Icons.movie_filter_outlined,
        "color": AboutTheme.accentGoldSoft,
      },
      {
        "num": "04",
        "title": "Targeted Performance Ads",
        "desc":
        "Precision advertising campaigns across Google & Meta to drive measurable ROI.",
        "icon": Icons.ads_click_rounded,
        "color": AboutTheme.brandBlue,
      },
    ];

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AboutTheme.royalBlueMid,
            AboutTheme.royalBlue,
          ],
        ),
      ),
      padding: EdgeInsets.symmetric(
        vertical: 70,
        horizontal: isDesktop ? 60 : 20,
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1150),
          child: Column(
            children: [
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AboutTheme.accentGold.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(30),
                  border:
                  Border.all(color: AboutTheme.accentGold.withOpacity(0.6)),
                ),
                child: Text(
                  "SERVICES THAT DRIVE DIGITAL GROWTH",
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AboutTheme.accentGold,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                "Integrated Digital Expertise",
                textAlign: TextAlign.center,
                style: GoogleFonts.alegreyaSc(
                  fontSize: isDesktop ? 36 : 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
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
                        child: _buildCapabilityCard(cap),
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

  Widget _buildCapabilityCard(Map<String, dynamic> cap) {
    final Color color = cap["color"] as Color;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.06),
            color.withOpacity(0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.35), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.12),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 3,
                height: 46,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [color, color.withOpacity(0.2)],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                cap["num"] as String,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(0.22),
                  color.withOpacity(0.08),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withOpacity(0.5)),
            ),
            child: Icon(cap["icon"] as IconData, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cap["title"] as String,
                  style: GoogleFonts.alegreyaSc(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AboutTheme.accentWhite,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  cap["desc"] as String,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 13.5,
                    color: AboutTheme.textMuted,
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
        ],
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
            AboutTheme.royalBlue,
            Color(0xFF05132B),
          ],
        ),
      ),
      child: Column(
        children: [
          Divider(
            height: 1,
            thickness: 1,
            color: AboutTheme.accentGold.withOpacity(0.4),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
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
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage())),
              child: Container(
                height: 50,
                width: 50,
                padding: const EdgeInsets.all(4),
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
                child: ClipOval(
                  child: Image.asset(
                    "assets/photos/logo.png",
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.broken_image,
                      color: HomePage.accentGold,
                      size: 24,
                    ),
                  ),
                ),
              ),
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
                    "We are Grow Socialee",
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
        const SizedBox(height: 16),
        Text(
          "Empowering businesses through digital strategies, branding, video production, and social media solutions.",
          style: GoogleFonts.playfairDisplay(
            fontSize: 14,
            color: AboutTheme.textMuted,
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
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AboutTheme.accentGold,
            letterSpacing: 1.2,
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
            Icon(icon, size: 18, color: AboutTheme.accentGold),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                maxLines: isMultiLine ? 3 : 1,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 13,
                  color: AboutTheme.accentWhite,
                  height: 1.4,
                  fontWeight: FontWeight.bold,
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
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AboutTheme.accentGold,
            letterSpacing: 1.2,
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
        border: Border.all(color: AboutTheme.accentGold.withOpacity(0.6)),
        boxShadow: [
          BoxShadow(
            color: AboutTheme.accentGold.withOpacity(0.10),
            blurRadius: 8,
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, size: 18, color: AboutTheme.accentGold),
        onPressed: () => _launchUrlString(url),
      ),
    );
  }
}

// ============================================================
// ABOUT SPLIT SECTION WITH ANIMATIONS (Congratulations Top-to-Down & Walk Back-to-Front)
// ============================================================
class _AboutSplitSectionAnimated extends StatefulWidget {
  final double screenWidth;
  final bool isDesktop;

  const _AboutSplitSectionAnimated({
    required this.screenWidth,
    required this.isDesktop,
  });

  @override
  State<_AboutSplitSectionAnimated> createState() => _AboutSplitSectionAnimatedState();
}

class _AboutSplitSectionAnimatedState extends State<_AboutSplitSectionAnimated>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _topDownSlideAnimation;
  late Animation<double> _walkBackToFrontScaleAnimation;
  late Animation<double> _fadeInAnimation;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    // 1. Congratulations top-to-down animation translation
    _topDownSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, -0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
    ));

    // 2. Walk from back to front animation (scaling from deep/small to full size)
    _walkBackToFrontScaleAnimation = Tween<double>(
      begin: 0.65,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.1, 1.0, curve: Curves.easeOutBack),
    ));

    _fadeInAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('about-split-visibility-key'),
      onVisibilityChanged: (info) {
        if (!_hasAnimated && info.visibleFraction > 0.15) {
          _hasAnimated = true;
          _controller.forward();
        }
      },
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AboutTheme.royalBlue,
              AboutTheme.royalBlueMid,
            ],
          ),
        ),
        padding: EdgeInsets.symmetric(
          vertical: 15,
          horizontal: widget.isDesktop ? 60 : 20,
        ),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1150),
            child: widget.isDesktop
                ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: _buildTiltedImageStackAnimated()),
                const SizedBox(width: 60),
                Expanded(child: _buildAboutDescription()),
              ],
            )
                : Column(
              children: [
                _buildTiltedImageStackAnimated(),
                const SizedBox(height: 40),
                _buildAboutDescription(),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTiltedImageStackAnimated() {
    return SlideTransition(
      position: _topDownSlideAnimation,
      child: FadeTransition(
        opacity: _fadeInAnimation,
        child: ScaleTransition(
          scale: _walkBackToFrontScaleAnimation,
          child: Center(
            child: SizedBox(
              width: 440,
              height: 460,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 30,
                    left: 0,
                    child: Transform.rotate(
                      angle: -0.06,
                      child: Container(
                        width: 340,
                        height: 380,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AboutTheme.accentGold.withOpacity(0.25),
                              AboutTheme.accentGoldDeep.withOpacity(0.10),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AboutTheme.accentGold.withOpacity(0.5),
                            width: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 340,
                      height: 400,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AboutTheme.accentGold.withOpacity(0.7),
                          width: 1.8,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AboutTheme.accentGold.withOpacity(0.25),
                            blurRadius: 28,
                            spreadRadius: 2,
                            offset: const Offset(0, 12),
                          ),
                          BoxShadow(
                            color: AboutTheme.accentCyan.withOpacity(0.20),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          "assets/photos/image.png",
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: AboutTheme.darkCardBg,
                            child: const Icon(
                              Icons.business_rounded,
                              size: 60,
                              color: AboutTheme.textMuted,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 10,
                    child: Container(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AboutTheme.accentGoldSoft,
                            AboutTheme.accentGold,
                            AboutTheme.accentGoldDeep,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: AboutTheme.accentGold.withOpacity(0.40),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Shaily Shah",
                              style: GoogleFonts.alegreyaSc(
                                fontSize: 16.8,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF1A1200),
                                letterSpacing: 2,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 8.5, right: 6.5, top: 5.5, bottom: 6.2),
                              decoration: BoxDecoration(
                                  color: AboutTheme.darkCardBg,
                                  borderRadius: BorderRadius.circular(0)
                              ),
                              child: Text(
                                "Founder",
                                style: GoogleFonts.poppins(
                                  fontSize: 13.8,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  height: 1.1,
                                ),
                              ),
                            ),
                          ]
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

  Widget _buildAboutDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 14),
        Text("Shaily Shah", style: GoogleFonts.alegreyaSc(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.white, height: 1.15)),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [
              AboutTheme.accentGoldSoft,
              AboutTheme.accentGold,
              AboutTheme.accentGoldDeep,
            ],
          ).createShader(bounds),
          child: Text(
            "Founder of Grow Socialee",
            style: GoogleFonts.alegreyaSc(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.15,
            ),
          ),
        ),
        const SizedBox(height: 22),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 3,
              height: 82,
              margin: const EdgeInsets.only(top: 4, right: 14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AboutTheme.accentGold,
                    AboutTheme.accentCyan,
                  ],
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: Text(
                "We are Grow Socialee—a full-suite digital marketing agency based in Bhavnagar committed to scaling small and medium enterprises. Modern market dynamics demand more than an online presence; they require digital dominance.",
                textAlign: TextAlign.justify,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 15,
                  color: AboutTheme.textMuted,
                  height: 1.6,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          "From custom social media strategies and video editing production to conversion-focused ad campaigns and brand identity design, our tailored solutions eliminate complexity and generate sustainable revenue growth.",
          textAlign: TextAlign.justify,
          style: GoogleFonts.playfairDisplay(
            fontSize: 15,
            color: AboutTheme.textMuted,
            height: 1.6,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          "At Grow Socialee, we believe every brand has a unique story waiting to be told. We combine creative thinking, strategic planning, and digital technology to transform ideas into impactful brand experiences that connect with the right audience and build lasting relationships.",
          textAlign: TextAlign.justify,
          style: GoogleFonts.playfairDisplay(
            fontSize: 15,
            color: AboutTheme.textMuted,
            height: 1.6,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 26),
        _buildGoldGradientButton(
          icon: Icons.arrow_forward_rounded,
          label: "WORK WITH US",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Contact()),
            );
          },
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
            AboutTheme.accentGoldSoft,
            AboutTheme.accentGold,
            AboutTheme.accentGoldDeep,
          ],
        ),
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: AboutTheme.accentGold.withOpacity(0.35),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onTap,
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
          style: GoogleFonts.playfairDisplay(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }
}

// ============================================================
// HERO PATTERN PAINTER
// ============================================================
class _AboutHeroPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AboutTheme.accentGold.withOpacity(0.06)
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
      ..color = AboutTheme.accentCyan.withOpacity(0.05)
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
// VALUES SECTION — 3 cards with ribbon headers & numbers
// ============================================================
class ValuesSection extends StatefulWidget {
  final bool isDesktop;

  const ValuesSection({super.key, required this.isDesktop});

  @override
  State<ValuesSection> createState() => _ValuesSectionState();
}

class _ValuesSectionState extends State<ValuesSection>
    with SingleTickerProviderStateMixin {
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
    ).animate(
        CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic));

    _topToBottomAnimation = Tween<Offset>(
      begin: const Offset(0.0, -0.3),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic));

    _rightToLeftAnimation = Tween<Offset>(
      begin: const Offset(0.3, 0.0),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic));

    _fadeAnimation =
        CurvedAnimation(parent: _animController, curve: Curves.easeIn);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkVisibility();
    });
  }

  void checkVisibility() {
    if (_hasAnimated) return;
    if (!mounted) return;

    final RenderObject? renderObject = context.findRenderObject();
    if (renderObject is RenderBox && renderObject.hasSize) {
      final position = renderObject.localToGlobal(Offset.zero);
      final screenHeight = MediaQuery.of(context).size.height;

      if (position.dy < screenHeight - 100 &&
          (position.dy + renderObject.size.height) > 0) {
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
      number: "01",
      icon: Icons.trending_up_rounded,
      title: "Our Mission",
      accentColor: AboutTheme.accentGold,
      content: Text(
        "To simplify digital growth for businesses by delivering impactful branding, creative visual design, strategic social media engagement, and revenue-focused advertising campaigns.",
        style: GoogleFonts.playfairDisplay(
            fontSize: 14, color: AboutTheme.textMuted, height: 1.6),
      ),
    );

    final visionCard = _buildCard(
      number: "02",
      icon: Icons.visibility_outlined,
      title: "Our Vision",
      accentColor: AboutTheme.accentCyan,
      content: Text(
        "To empower small and medium enterprises to establish distinct online identities and gain competitive advantages in an ever-evolving digital world.",
        style: GoogleFonts.playfairDisplay(
            fontSize: 14, color: AboutTheme.textMuted, height: 1.6),
      ),
    );

    final pillarsCard = _buildCard(
      number: "03",
      icon: Icons.workspace_premium_outlined,
      title: "Brand Pillars",
      accentColor: AboutTheme.accentGoldSoft,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildPillarPoint(
              "01", "Clarity First",
              "Demystifying complex marketing avenues for actionable execution."),
          const SizedBox(height: 10),
          _buildPillarPoint(
              "02", "Tailored Growth",
              "Custom strategies engineered around your exact commercial goals."),
          const SizedBox(height: 10),
          _buildPillarPoint(
              "03", "Dedicated Focus",
              "Hands-on partnership supporting every step of your digital scale."),
        ],
      ),
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AboutTheme.royalBlue,
            AboutTheme.royalBlueMid,
          ],
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AboutTheme.accentGold.withOpacity(0.15),
              borderRadius: BorderRadius.circular(30),
              border:
              Border.all(color: AboutTheme.accentGold.withOpacity(0.6)),
            ),
            child: Text(
              "CORE PHILOSOPHY",
              style: GoogleFonts.playfairDisplay(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AboutTheme.accentGold,
                letterSpacing: 2.0,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            "Driven by Strategy & Purpose",
            style: GoogleFonts.alegreyaSc(
              fontSize: widget.isDesktop ? 34 : 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1150),
              child: widget.isDesktop
                  ? IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: SlideTransition(
                        position: _leftToRightAnimation,
                        child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: missionCard),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: SlideTransition(
                        position: _topToBottomAnimation,
                        child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: visionCard),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: SlideTransition(
                        position: _rightToLeftAnimation,
                        child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: pillarsCard),
                      ),
                    ),
                  ],
                ),
              )
                  : Column(
                children: [
                  SlideTransition(
                    position: _leftToRightAnimation,
                    child: FadeTransition(
                        opacity: _fadeAnimation, child: missionCard),
                  ),
                  const SizedBox(height: 20),
                  SlideTransition(
                    position: _topToBottomAnimation,
                    child: FadeTransition(
                        opacity: _fadeAnimation, child: visionCard),
                  ),
                  const SizedBox(height: 20),
                  SlideTransition(
                    position: _rightToLeftAnimation,
                    child: FadeTransition(
                        opacity: _fadeAnimation, child: pillarsCard),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPillarPoint(String num, String title, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: AboutTheme.accentGoldSoft.withOpacity(0.15),
            borderRadius: BorderRadius.circular(6),
            border:
            Border.all(color: AboutTheme.accentGoldSoft.withOpacity(0.4)),
          ),
          child: Text(
            num,
            style: GoogleFonts.playfairDisplay(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: AboutTheme.accentGoldSoft,
              letterSpacing: 1,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.playfairDisplay(
                  fontSize: 13, color: AboutTheme.textMuted, height: 1.5),
              children: [
                TextSpan(
                  text: "$title: ",
                  style: GoogleFonts.alegreyaSc(
                    fontSize: 13.5,
                    color: AboutTheme.accentWhite,
                    fontWeight: FontWeight.bold,
                    height: 1.5,
                  ),
                ),
                TextSpan(
                  text: text,
                  style: GoogleFonts.playfairDisplay(
                      fontSize: 13, color: AboutTheme.textMuted, height: 1.5),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCard({
    required String number,
    required IconData icon,
    required String title,
    required Widget content,
    required Color accentColor,
  }) {
    final cardChild = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: widget.isDesktop ? MainAxisSize.max : MainAxisSize.min,
      children: [
        // Ribbon header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                accentColor.withOpacity(0.18),
                accentColor.withOpacity(0.04),
              ],
            ),
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(15)),
            border: Border(
              bottom: BorderSide(
                color: accentColor.withOpacity(0.35),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      accentColor.withOpacity(0.30),
                      accentColor.withOpacity(0.10),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: accentColor.withOpacity(0.55)),
                ),
                child: Icon(icon, color: accentColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "CHAPTER $number",
                      style: GoogleFonts.poppins(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                        color: accentColor,
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      title,
                      style: GoogleFonts.alegreyaSc(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: AboutTheme.accentWhite,
                        height: 1.15,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Content Area - safely conditioned for desktop vs mobile
        widget.isDesktop
            ? Expanded(
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: content,
          ),
        )
            : Padding(
          padding: const EdgeInsets.all(22),
          child: content,
        ),
      ],
    );

    return Container(
      width: double.infinity,
      height: widget.isDesktop ? double.infinity : null,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.06),
            accentColor.withOpacity(0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accentColor.withOpacity(0.45), width: 1.3),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.14),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: cardChild,
    );
  }
}

// ============================================================
// TEAM SECTION
// ============================================================
class TeamSection extends StatefulWidget {
  final bool isDesktop;

  const TeamSection({super.key, required this.isDesktop});

  @override
  State<TeamSection> createState() => _TeamSectionState();
}

class _TeamSectionState extends State<TeamSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  bool _hasAnimated = false;

  final List<Map<String, String>> _teamMembers = [
    {"name": "Harsh Shah", "designation": "Co - Founder", "photo": "assets/team_photos/team_photos/harsh_sir.png"},
    {"name": "Umesh", "designation": "Manager", "photo": "assets/team_photos/team_photos/umesh.png"},
    {"name": "Vaibhav", "designation": "Sr. Video Editor", "photo": "assets/team_photos/team_photos/vaibhav.png"},
    {"name": "Ankita", "designation": "Video Editor\n& Graphics Designer", "photo": "assets/team_photos/team_photos/ankita.png"},
    {"name": "Dhruvita", "designation": "Video Editor\n& Graphics Designer", "photo": "assets/team_photos/team_photos/dhruvita.png"},
    {"name": "Mayank", "designation": "Graphics Designer", "photo": "assets/team_photos/team_photos/mayank.png"},
    {"name": "Om", "designation": "Video Editor", "photo": "assets/team_photos/team_photos/om.png"},
    {"name": "Dharmik", "designation": "Video Editor", "photo": "assets/team_photos/team_photos/dharmik.png"},
    {"name": "Harshdeep", "designation": "Video Editor", "photo": "assets/team_photos/team_photos/harshdeep.png"},
    {"name": "Kashish", "designation": "Social Media Executive", "photo": "assets/foldername/ph3.jpg"},
    {"name": "Hitanshi", "designation": "Data Scraper", "photo": "assets/team_photos/team_photos/hitanshi.png"},
    {"name": "Chirag", "designation": "SEO Executive", "photo": "assets/team_photos/team_photos/chirag.png"},
    {"name": "Shubham", "designation": "Web Developer", "photo": "assets/team_photos/team_photos/shubham.png"},
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  /// Row-based top-to-bottom animation.
  /// Row 0 (first 5)  → starts at 0.00
  /// Row 1 (next 5)   → starts at 0.25
  /// Row 2 (last 3)   → starts at 0.50
  Animation<Offset> _slideFor(int index) {
    final int columns = widget.isDesktop ? 5 : 2;
    final int row = index ~/ columns;
    // Each row's animation starts later than the previous one.
    final double start = (row * 0.25).clamp(0.0, 0.7);
    final double end = (start + 0.5).clamp(0.0, 1.0);

    return Tween<Offset>(
      begin: const Offset(0.0, -0.5), // from above
      end: Offset.zero,               // to natural position
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Interval(start, end, curve: Curves.easeOutCubic),
      ),
    );
  }

  Animation<double> _fadeFor(int index) {
    final int columns = widget.isDesktop ? 5 : 2;
    final int row = index ~/ columns;
    final double start = (row * 0.25).clamp(0.0, 0.7);
    final double end = (start + 0.5).clamp(0.0, 1.0);

    return CurvedAnimation(
      parent: _animController,
      curve: Interval(start, end, curve: Curves.easeIn),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 65, horizontal: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AboutTheme.royalBlueMid,
            AboutTheme.royalBlue,
          ],
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10.5),
            decoration: BoxDecoration(
              color: AboutTheme.accentGold.withOpacity(0.15),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: AboutTheme.accentGold.withOpacity(0.6)),
            ),
            child: Column(
              children: [
                Text("CHAPTER 04", style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: AboutTheme.accentGold, letterSpacing: 2.0)),
                const SizedBox(height: 8.5),
                Text("THE PEOPLE SHAPING DIGITAL EXPERIENCES", style: GoogleFonts.playfairDisplay(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 2.0)),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            "Get to Know Our Digital Team", textAlign: TextAlign.center, style: GoogleFonts.alegreyaSc(fontSize: widget.isDesktop ? 34 : 26, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 40),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: VisibilityDetector(
                key: const Key('team-section-visibility'),
                onVisibilityChanged: (info) {
                  if (!_hasAnimated && info.visibleFraction > 0.15) {
                    _hasAnimated = true;
                    _animController.forward();
                  }
                },
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: _teamMembers.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: widget.isDesktop ? 5 : 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: widget.isDesktop ? 0.99 : 0.68,
                  ),
                  itemBuilder: (context, index) {
                    final member = _teamMembers[index];
                    return SlideTransition(
                      position: _slideFor(index),
                      child: FadeTransition(
                        opacity: _fadeFor(index),
                        child: _buildTeamCard(
                          name: member["name"]!,
                          designation: member["designation"]!,
                          assetPath: member["photo"]!,
                          accentColor: AboutTheme.accentGold,
                        ),
                      ),
                    );
                  },
                ),
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
    required String assetPath,
    required Color accentColor,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.06),
            accentColor.withOpacity(0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accentColor.withOpacity(0.45), width: 1.3),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.15),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double cardWidth = constraints.maxWidth;
            final double circleSize = cardWidth * 0.58;

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ===== FIXED-HEIGHT PHOTO AREA =====
                SizedBox(
                  height: circleSize,
                  child: Center(
                    child: Container(
                      width: circleSize,
                      height: circleSize,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          assetPath,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: AboutTheme.royalBlueMid,
                            child: const Icon(Icons.person, color: Colors.white, size: 30),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // ===== NAME — fixed one line height =====
                Text(
                  name,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.alegreyaSc(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AboutTheme.accentWhite,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 8),
                // ===== DESIGNATION CHIP — fixed height =====
                SizedBox(
                  height: 36,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        designation.toUpperCase(),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 9.8,
                          fontWeight: FontWeight.bold,
                          color: AboutTheme.darkCardBg,
                          letterSpacing: 1.1,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ============================================================
// HOVER SCALE WRAPPER
// ============================================================
class _HoverScale extends StatefulWidget {
  final Widget child;
  final double scale;
  const _HoverScale({required this.child, this.scale = 1.05});

  @override
  State<_HoverScale> createState() => _HoverScaleState();
}

class _HoverScaleState extends State<_HoverScale> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < Breakpoints.tablet;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedScale(
        scale: (_hovering && !isMobile) ? widget.scale : 1.0,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

class Breakpoints {
  static const double mobileSmall = 380;
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
  static const double largeDesktop = 1500;

  static bool isMobileSmall(double w) => w < mobileSmall;
  static bool isMobile(double w) => w < mobile;
  static bool isTablet(double w) => w >= mobile && w < tablet;
  static bool isDesktop(double w) => w >= tablet;
  static bool isLargeDesktop(double w) => w >= desktop;
}