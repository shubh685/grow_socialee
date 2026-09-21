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

// ============================================================
// ABOUT PAGE — THEME (matches HomePage royal blue + gold)
// ============================================================
class AboutTheme {
  // Backgrounds (identical to HomePage)
  static const Color royalBlue = Color(0xFF0A1F44);
  static const Color royalBlueMid = Color(0xFF0F2A5C);
  static const Color darkBg = Color(0xFF0A1F44);
  static const Color darkCardBg = Color(0xFF0D2551);
  static const Color glassCard = Color(0xFF13315C);

  // Gold accents (identical to HomePage)
  static const Color accentGold = Color(0xFFF5C842);
  static const Color accentGoldDeep = Color(0xFFD4A017);
  static const Color accentGoldSoft = Color(0xFFFFE08A);

  // Cyan accents
  static const Color accentCyan = Color(0xFF4FC3F7);
  static const Color accentCyanGlow = Color(0xFF29B6F6);
  static const Color brandBlue = Color(0xFF1E88E5);

  // Text colors
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
        preferredSize: const Size.fromHeight(75),
        child: _buildAppBar(isDesktop),
      ),
      endDrawer: _buildEndDrawer(screenWidth, isDesktop),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          _valuesKey.currentState?.checkVisibility();
          _teamKey.currentState?.checkVisibility();
          return false;
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _buildAGHeroBanner(screenWidth, isDesktop),
            ),
            SliverToBoxAdapter(
              child: _buildPhilosophyStrip(isDesktop),
            ),
            SliverToBoxAdapter(
              child: _buildAboutSplitSection(screenWidth, isDesktop),
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
              child: TeamSection(key: _teamKey, isDesktop: isDesktop),
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
  PreferredSizeWidget _buildAppBar(bool isDesktop) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(75),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AboutTheme.royalBlue,
              AboutTheme.royalBlueMid,
            ],
          ),
          border: Border(
            bottom: BorderSide(
              color: AboutTheme.accentGold.withOpacity(0.6),
              width: 1.5,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: AboutTheme.accentCyan.withOpacity(0.15),
              blurRadius: 16,
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
                            AboutTheme.accentGold.withOpacity(0.22),
                            AboutTheme.accentGoldDeep.withOpacity(0.12),
                          ],
                        ),
                        border: Border.all(
                          color: AboutTheme.accentGold.withOpacity(0.7),
                          width: 1.4,
                        ),
                      ),
                      child: const Icon(
                        Icons.menu_rounded,
                        color: AboutTheme.accentGold,
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
    return Padding(
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
                  AboutTheme.accentGold.withOpacity(0.25),
                  AboutTheme.accentGoldDeep.withOpacity(0.10),
                ],
              ),
              border: Border.all(
                color: AboutTheme.accentGold.withOpacity(0.7),
                width: 1.2,
              ),
            ),
            child: const Icon(
              Icons.workspace_premium_rounded,
              color: AboutTheme.accentGold,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [
                  AboutTheme.accentGoldSoft,
                  AboutTheme.accentGold,
                  AboutTheme.accentGoldDeep,
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
                  letterSpacing: 0.3,
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
  // HERO BANNER — Split layout with numbering + gradient text
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
          // Ambient glows
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
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: isDesktop ? 90 : 55,
              horizontal: isDesktop ? 60 : 22,
            ),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1150),
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
                      flex: 4,
                      child: _buildHeroRightBadges(),
                    ),
                  ],
                )
                    : Column(
                  children: [
                    _buildHeroLeftText(),
                    const SizedBox(height: 36),
                    _buildHeroRightBadges(),
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
        // Pill badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
              Text(
                "CHAPTER 01 · WHO WE ARE",
                style: GoogleFonts.bellota(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  color: AboutTheme.accentGold,
                  letterSpacing: 2.2,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        // "Crafting Digital" — small
        Text(
          "Crafting Digital",
          style: GoogleFonts.bellota(
            fontSize: 30,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            height: 1.05,
            letterSpacing: -0.5,
          ),
        ),
        // "Legacies" — gradient huge
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
            style: GoogleFonts.bellota(
              fontSize: 58,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.05,
              letterSpacing: -1.5,
            ),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          "Through Strategic Innovation.",
          style: GoogleFonts.bellota(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: AboutTheme.accentCyan,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 22),
        Text(
          "We combine creative thinking, data-driven strategy, and design excellence to help brands dominate their digital space.",
          style: GoogleFonts.bellota(
            fontSize: 15,
            color: AboutTheme.textSoft,
            height: 1.6,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }

  Widget _buildHeroRightBadges() {
    final badges = [
      {
        "icon": Icons.emoji_events_outlined,
        "label": "AWARD-WINNING",
        "sub": "Design & Strategy",
      },
      {
        "icon": Icons.groups_2_outlined,
        "label": "14-PERSON TEAM",
        "sub": "Dedicated Specialists",
      },
      {
        "icon": Icons.trending_up_rounded,
        "label": "50+ BRANDS",
        "sub": "Scaled Successfully",
      },
    ];

    return Column(
      children: badges.map((b) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: _buildHeroBadge(
            icon: b["icon"] as IconData,
            label: b["label"] as String,
            sub: b["sub"] as String,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildHeroBadge({
    required IconData icon,
    required String label,
    required String sub,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.08),
            Colors.white.withOpacity(0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AboutTheme.accentCyan.withOpacity(0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AboutTheme.accentCyan.withOpacity(0.10),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AboutTheme.accentGoldSoft,
                  AboutTheme.accentGoldDeep,
                ],
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: AboutTheme.accentGold.withOpacity(0.22),
                  blurRadius: 8,
                ),
              ],
            ),
            child:
            Icon(icon, color: const Color(0xFF1A1200), size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.bellota(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: AboutTheme.accentGold,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  sub,
                  style: GoogleFonts.bellota(
                    fontSize: 11.5,
                    color: AboutTheme.textMuted,
                    fontWeight: FontWeight.w400,
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
  // PHILOSOPHY STRIP — Horizontal band of 4 mini values
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
        vertical: isDesktop ? 28 : 20,
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
                    style: GoogleFonts.bellota(
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
  // ABOUT SPLIT SECTION — Overlapping image + tilt effect
  // ============================================================
  Widget _buildAboutSplitSection(double screenWidth, bool isDesktop) {
    return Container(
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
        vertical: 70,
        horizontal: isDesktop ? 60 : 20,
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1150),
          child: isDesktop
              ? Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: _buildTiltedImageStack()),
              const SizedBox(width: 60),
              Expanded(child: _buildAboutDescription()),
            ],
          )
              : Column(
            children: [
              _buildTiltedImageStack(),
              const SizedBox(height: 40),
              _buildAboutDescription(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTiltedImageStack() {
    return Center(
      child: SizedBox(
        width: 440,
        height: 460,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Back tilted frame
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
            // Front main image
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
            // Floating year badge
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
                      "EST.",
                      style: GoogleFonts.bellota(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1A1200),
                        letterSpacing: 2,
                      ),
                    ),
                    Text(
                      "Bhavnagar",
                      style: GoogleFonts.bellota(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A1200),
                        height: 1.1,
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

  Widget _buildAboutDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Chapter marker
        Row(
          children: [
            Container(
              width: 30,
              height: 1.5,
              color: AboutTheme.accentGold,
            ),
            const SizedBox(width: 10),
            Text(
              "ABOUT GROW SOCIALEE",
              style: GoogleFonts.bellota(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AboutTheme.accentGold,
                letterSpacing: 2.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        // Big heading
        Text(
          "Innovating Digital",
          style: GoogleFonts.bellota(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            height: 1.15,
          ),
        ),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [
              AboutTheme.accentGoldSoft,
              AboutTheme.accentGold,
              AboutTheme.accentGoldDeep,
            ],
          ).createShader(bounds),
          child: Text(
            "Excellence in Bhavnagar",
            style: GoogleFonts.bellota(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.15,
            ),
          ),
        ),
        const SizedBox(height: 22),
        // First paragraph with left accent bar
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
                style: GoogleFonts.bellota(
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
          style: GoogleFonts.bellota(
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
          style: GoogleFonts.bellota(
            fontSize: 15,
            color: AboutTheme.textMuted,
            height: 1.6,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 26),
        // CTA
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
          style: GoogleFonts.bellota(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ORNAMENT DIVIDER — Gold diamond between sections
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
  // CAPABILITIES — Horizontal cards with vertical accent bars
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
              // Section header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AboutTheme.accentGold.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(30),
                  border:
                  Border.all(color: AboutTheme.accentGold.withOpacity(0.6)),
                ),
                child: Text(
                  "WHAT WE BRING TO THE TABLE",
                  style: GoogleFonts.bellota(
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
                style: GoogleFonts.bellota(
                  fontSize: isDesktop ? 36 : 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),

              // Capability cards
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
          // Vertical accent bar + number
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
                style: GoogleFonts.bellota(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // Icon
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
          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cap["title"] as String,
                  style: GoogleFonts.bellota(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AboutTheme.accentWhite,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  cap["desc"] as String,
                  style: GoogleFonts.bellota(
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
              color: AboutTheme.accentGold.withOpacity(0.4)),
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
                  color: AboutTheme.textMuted,
                ),
                textAlign: TextAlign.center,
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
          style: GoogleFonts.bellota(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AboutTheme.accentGold,
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
            Icon(icon, size: 18, color: AboutTheme.accentGold),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                maxLines: isMultiLine ? 3 : 1,
                style: GoogleFonts.bellota(
                  fontSize: 13,
                  color: isMultiLine
                      ? AboutTheme.accentWhite
                      : AboutTheme.textMuted,
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
            color: AboutTheme.accentGold,
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
        style: GoogleFonts.bellota(
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
        style: GoogleFonts.bellota(
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
              style: GoogleFonts.bellota(
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
            style: GoogleFonts.bellota(
              fontSize: widget.isDesktop ? 34 : 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 40),
          Center(
            child: Container(
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
                            opacity: _fadeAnimation, child: missionCard),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: SlideTransition(
                        position: _topToBottomAnimation,
                        child: FadeTransition(
                            opacity: _fadeAnimation, child: visionCard),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: SlideTransition(
                        position: _rightToLeftAnimation,
                        child: FadeTransition(
                            opacity: _fadeAnimation, child: pillarsCard),
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
            style: GoogleFonts.bellota(
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
              style: GoogleFonts.bellota(
                  fontSize: 13, color: AboutTheme.textMuted, height: 1.5),
              children: [
                TextSpan(
                  text: "$title: ",
                  style: GoogleFonts.bellota(
                    fontSize: 13.5,
                    color: AboutTheme.accentWhite,
                    fontWeight: FontWeight.bold,
                    height: 1.5,
                  ),
                ),
                TextSpan(
                  text: text,
                  style: GoogleFonts.bellota(
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
            color: accentColor.withOpacity(0.14),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Ribbon header with number + icon
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
                    border:
                    Border.all(color: accentColor.withOpacity(0.55)),
                  ),
                  child: Icon(icon, color: accentColor, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "CHAPTER $number",
                        style: GoogleFonts.bellota(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                          color: accentColor,
                          letterSpacing: 2.0,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        title,
                        style: GoogleFonts.bellota(
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
          // Content
          Padding(
            padding: const EdgeInsets.all(22),
            child: content,
          ),
        ],
      ),
    );
  }
}

// ============================================================
// TEAM SECTION — Horizontal profile cards with avatar rings
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
    final founderCard = _buildTeamCard(
      name: "Shaily Shah",
      designation: "Founder",
      tagline: "Vision & Direction",
      initials: "SS",
      accentColor: AboutTheme.accentGold,
      isFeatured: true,
    );

    final managerCard = _buildTeamCard(
      name: "Umesh Baraiya",
      designation: "Manager",
      tagline: "Client Relations",
      initials: "UB",
      accentColor: AboutTheme.accentCyan,
      isFeatured: false,
    );

    final subManagerCard = _buildTeamCard(
      name: "Vaibhavsinh Jadeja",
      designation: "Sub Manager",
      tagline: "Operations",
      initials: "VJ",
      accentColor: AboutTheme.accentGoldSoft,
      isFeatured: false,
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AboutTheme.accentGold.withOpacity(0.15),
              borderRadius: BorderRadius.circular(30),
              border:
              Border.all(color: AboutTheme.accentGold.withOpacity(0.6)),
            ),
            child: Text(
              "MEET OUR LEADERSHIP",
              style: GoogleFonts.bellota(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AboutTheme.accentGold,
                letterSpacing: 2.0,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            "The Minds Behind the Agency",
            style: GoogleFonts.bellota(
              fontSize: widget.isDesktop ? 34 : 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 40),
          Center(
            child: Container(
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
                            opacity: _fadeAnimation, child: founderCard),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: SlideTransition(
                        position: _topToBottomAnimation,
                        child: FadeTransition(
                            opacity: _fadeAnimation, child: managerCard),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: SlideTransition(
                        position: _rightToLeftAnimation,
                        child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: subManagerCard),
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
                        opacity: _fadeAnimation, child: founderCard),
                  ),
                  const SizedBox(height: 20),
                  SlideTransition(
                    position: _topToBottomAnimation,
                    child: FadeTransition(
                        opacity: _fadeAnimation, child: managerCard),
                  ),
                  const SizedBox(height: 20),
                  SlideTransition(
                    position: _rightToLeftAnimation,
                    child: FadeTransition(
                        opacity: _fadeAnimation, child: subManagerCard),
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
    required String tagline,
    required String initials,
    required Color accentColor,
    required bool isFeatured,
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top ribbon bar (featured crown)
          if (isFeatured)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AboutTheme.accentGoldSoft,
                    AboutTheme.accentGold,
                    AboutTheme.accentGoldDeep,
                  ],
                ),
                borderRadius:
                BorderRadius.vertical(top: Radius.circular(15)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.workspace_premium_rounded,
                    size: 12,
                    color: Color(0xFF1A1200),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "FOUNDER",
                    style: GoogleFonts.bellota(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1A1200),
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            )
          else
            const SizedBox(height: 24),
          Padding(
            padding: EdgeInsets.fromLTRB(
                24, isFeatured ? 20 : 0, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Avatar with ring
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        accentColor.withOpacity(0.60),
                        accentColor.withOpacity(0.15),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withOpacity(0.35),
                        blurRadius: 18,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 38,
                    backgroundColor: AboutTheme.darkCardBg,
                    child: Text(
                      initials,
                      style: GoogleFonts.bellota(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: accentColor,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Name
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.bellota(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: AboutTheme.accentWhite,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                // Designation chip
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border:
                    Border.all(color: accentColor.withOpacity(0.55)),
                  ),
                  child: Text(
                    designation.toUpperCase(),
                    style: GoogleFonts.bellota(
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                      color: accentColor,
                      letterSpacing: 1.6,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Tagline
                Text(
                  tagline,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.bellota(
                    fontSize: 12,
                    color: AboutTheme.textMuted,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}