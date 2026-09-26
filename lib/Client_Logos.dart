import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grow_socialee/home_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'About.dart';
import 'Reviews.dart';
import 'contact.dart';
import 'Services.dart';

// ============================================================
// CLIENT LOGOS PAGE — THEME (matches HomePage royal blue + gold)
// ============================================================
class ClientTheme {
  // Backgrounds (identical to HomePage)
  static const Color royalBlue = HomePage.royalBlue;
  static const Color royalBlueMid = HomePage.royalBlueMid;
  static const Color darkBg = HomePage.darkBg;
  static const Color darkCardBg = HomePage.darkCardBg;
  static const Color glassCard = HomePage.glassCard;

  // Gold accents
  static const Color accentGold = HomePage.accentGold;
  static const Color accentGoldDeep = HomePage.accentGoldDeep;
  static const Color accentGoldSoft = HomePage.accentGoldSoft;

  // Cyan accents
  static const Color accentCyan = HomePage.accentCyan;
  static const Color accentCyanGlow = HomePage.accentCyanGlow;
  static const Color brandBlue = HomePage.brandBlue;

  // Text
  static const Color accentWhite = HomePage.accentWhite;
  static const Color textMuted = HomePage.textMuted;
  static const Color textSoft = HomePage.textSoft;
}

class ClientLogoPage extends StatefulWidget {
  const ClientLogoPage({super.key});

  @override
  State<ClientLogoPage> createState() => _ClientLogoPageState();
}

class _ClientLogoPageState extends State<ClientLogoPage> {
  int _selectedIndex = 2;
  int _activeFilter = 0; // 0=All, 1=Featured, 2=Partners

  final List<Map<String, dynamic>> clientLogos = const [
    {"path": "assets/photos/aroma.png", "isWhite": true, "featured": true},
    {"path": "assets/photos/aura.png", "isWhite": false, "featured": true},
    {"path": "assets/photos/bani_thani.png", "isWhite": false, "featured": false},
    {"path": "assets/photos/bindu_decor.png", "isWhite": false, "featured": false},
    {"path": "assets/photos/ella.png", "isWhite": false, "featured": true},
    {"path": "assets/photos/every_child.png", "isWhite": false, "featured": false},
    {"path": "assets/photos/gayat_cate.png", "isWhite": false, "featured": false},
    {"path": "assets/photos/kids_connect.png", "isWhite": false, "featured": false},
    {"path": "assets/photos/manas.png", "isWhite": false, "featured": true},
    {"path": "assets/photos/nari_sanari.png", "isWhite": false, "featured": false},
    {"path": "assets/photos/nilav_shah.png", "isWhite": false, "featured": false},
    {"path": "assets/photos/jinali_modi.png", "isWhite": false, "featured": false},
    {"path": "assets/photos/pavan_salon.png", "isWhite": false, "featured": false},
    {"path": "assets/photos/shwass.png", "isWhite": false, "featured": true},
    {"path": "assets/photos/the_celebration.png", "isWhite": true, "featured": true},
    {"path": "assets/photos/ugs.png", "isWhite": false, "featured": false},
    {"path": "assets/photos/ved_icu.png", "isWhite": false, "featured": false},
    {"path": "assets/photos/wost.png", "isWhite": false, "featured": false},
  ];

  final String addressQuery =
      "First Floor, Leela Efcee, 103, Waghawadi Rd., Hill Drive, Bhavnagar, Gujarat 364002";
  final String phoneNum = "+919408518168";
  final String emailAddr = "growsocialee@gmail.com";
  final String googleMapsUrl =
      "https://maps.google.com/?q=Leela+Efcee+Bhavnagar+Gujarat";

  final String facebookUrl = "https://www.facebook.com/growsocialeeofficial/";
  final String instagramUrl = "https://www.instagram.com/growsocialee.official/";
  final String linkedInUrl = "https://in.linkedin.com/company/grow-socialee";

  final List<GlobalKey<_BottomToTopAnimatedLogoCardState>> _cardKeys = [];

  @override
  void initState() {
    super.initState();
    _cardKeys.addAll(
      List.generate(
        clientLogos.length,
            (_) => GlobalKey<_BottomToTopAnimatedLogoCardState>(),
      ),
    );
  }

  void _checkCardsVisibility() {
    for (var key in _cardKeys) {
      key.currentState?.checkVisibility();
    }
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

  // Filtered list based on active chip
  List<Map<String, dynamic>> get _filteredLogos {
    if (_activeFilter == 0) return clientLogos;
    if (_activeFilter == 1) {
      return clientLogos.where((c) => c["featured"] == true).toList();
    }
    return clientLogos.where((c) => c["featured"] != true).toList();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth >= Breakpoints.tablet;

    return Scaffold(
      backgroundColor: ClientTheme.darkBg,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: _buildAppBar(screenWidth, isDesktop),
      ),
      endDrawer: _buildEndDrawer(screenWidth, isDesktop),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          _checkCardsVisibility();
          return false;
        },
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ✅ Hero section
            SliverToBoxAdapter(
              child: _buildHeroSection(isDesktop),
            ),
            // ✅ Filter chips
            SliverToBoxAdapter(
              child: _buildFilterChips(isDesktop),
            ),
            // ✅ Logos grid
            SliverToBoxAdapter(
              child: _buildAllLogosGrid(context),
            ),
            // ✅ Ornament divider
            SliverToBoxAdapter(
              child: _buildOrnamentDivider(),
            ),
            // ✅ CTA before footer
            SliverToBoxAdapter(
              child: _buildCTASection(isDesktop),
            ),
            // ✅ Footer
            SliverToBoxAdapter(
              child: AnimatedFooter(
                addressQuery: addressQuery,
                phoneNum: phoneNum,
                emailAddr: emailAddr,
                googleMapsUrl: googleMapsUrl,
                facebookUrl: facebookUrl,
                instagramUrl: instagramUrl,
                linkedInUrl: linkedInUrl,
                onLaunchUrl: _launchUrlString,
                onMakeCall: _makePhoneCall,
                onSendEmail: _sendEmail,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // APP BAR (Matching HomePage NavBar)
  // ============================================================
  PreferredSizeWidget _buildAppBar(double screenWidth, bool isDesktop) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(80),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: ClientTheme.royalBlue,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.08),
                  ClientTheme.royalBlueMid.withOpacity(0.6),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: ClientTheme.accentGold.withOpacity(0.35),
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
                            builder: (context) => const HomePage(),
                          ),
                        );
                      }),
                      _buildNavButton("ABOUT", 1, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const About(),
                          ),
                        );
                      }),
                      _buildNavButton("CLIENTS", 2, () {}),
                      _buildNavButton("SERVICES", 3, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Services(),
                          ),
                        );
                      }),
                      _buildNavButton("REVIEWS", 4, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Reviews(),
                          ),
                        );
                      }),
                      const SizedBox(width: 12),
                      Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              ClientTheme.accentGoldSoft,
                              ClientTheme.accentGoldDeep,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: ClientTheme.accentGold.withOpacity(0.3),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
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
                                ClientTheme.accentGold.withOpacity(0.2),
                                ClientTheme.accentGoldDeep.withOpacity(0.1),
                              ],
                            ),
                            border: Border.all(
                              color: ClientTheme.accentGold.withOpacity(0.7),
                              width: 1.2,
                            ),
                          ),
                          child: const Icon(
                            Icons.menu_rounded,
                            color: ClientTheme.accentGold,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
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
                color: isSelected
                    ? ClientTheme.accentGold
                    : ClientTheme.textSoft,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 2),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 2,
              width: isSelected ? 18 : 0,
              decoration: BoxDecoration(
                color: ClientTheme.accentGold,
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
                  ClientTheme.accentGold.withOpacity(0.25),
                  ClientTheme.accentGoldDeep.withOpacity(0.10),
                ],
              ),
              border: Border.all(
                color: ClientTheme.accentGold.withOpacity(0.7),
                width: 1.2,
              ),
            ),
            child: const Icon(
              Icons.workspace_premium_rounded,
              color: ClientTheme.accentGold,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [
                  ClientTheme.accentGoldSoft,
                  ClientTheme.accentGold,
                  ClientTheme.accentGoldDeep,
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
      backgroundColor: ClientTheme.royalBlue,
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
                    ClientTheme.royalBlueMid,
                    ClientTheme.glassCard,
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
              color: ClientTheme.accentGold.withOpacity(0.4),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const About(),
                        ),
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
                        MaterialPageRoute(
                          builder: (context) => Reviews(),
                        ),
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
                    ClientTheme.accentGoldSoft,
                    ClientTheme.accentGold,
                    ClientTheme.accentGoldDeep,
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
                  ClientTheme.accentGoldSoft,
                  ClientTheme.accentGold,
                  ClientTheme.accentGoldDeep,
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
  // HERO SECTION
  // ============================================================
  Widget _buildHeroSection(bool isDesktop) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0.6, -0.3),
          radius: 1.4,
          colors: [
            Color(0xFF173F7B),
            ClientTheme.royalBlue,
            Color(0xFF061733),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Cyan glow top-right
          Positioned(
            top: -80,
            right: -80,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    ClientTheme.accentCyan.withOpacity(0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Gold glow bottom-left
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
                    ClientTheme.accentGold.withOpacity(0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Opacity(
              opacity: 0.10,
              child: CustomPaint(painter: _ClientHeroPatternPainter()),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: isDesktop ? 90 : 55,
              horizontal: 24,
            ),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Column(
                  children: [
                    // Chapter marker
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: ClientTheme.accentGold.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: ClientTheme.accentGold.withOpacity(0.7),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: ClientTheme.accentGold.withOpacity(0.15),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.workspace_premium_rounded,
                            size: 14,
                            color: ClientTheme.accentGold,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "CHAPTER 03 · OUR CLIENTS",
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 10.5,
                              fontWeight: FontWeight.bold,
                              color: ClientTheme.accentGold,
                              letterSpacing: 2.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    // "Trusted by" small line
                    Text(
                      "Trusted by",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.alegreyaSc(
                        fontSize: isDesktop ? 24 : 18,
                        fontWeight: FontWeight.w400,
                        color: ClientTheme.textSoft,
                        height: 1.2,
                      ),
                    ),
                    // Big gradient headline
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [
                          ClientTheme.accentGoldSoft,
                          ClientTheme.accentGold,
                          ClientTheme.accentGoldDeep,
                        ],
                      ).createShader(bounds),
                      child: Text(
                        "50+ Visionary Brands",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.alegreyaSc(
                          fontSize: isDesktop ? 52 : 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "We take small business people into the path of progress by completing digital marketing services and we are doing it with love.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: isDesktop ? 15 : 13.5,
                        color: ClientTheme.textMuted,
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

  // ============================================================
  // FILTER CHIPS (visual only)
  // ============================================================
  Widget _buildFilterChips(bool isDesktop) {
    final chips = ["ALL BRANDS", "FEATURED", "PARTNERS"];

    return Container(
      width: double.infinity,
      color: ClientTheme.royalBlue,
      padding: EdgeInsets.symmetric(
        vertical: 24,
        horizontal: isDesktop ? 60 : 20,
      ),
      child: Center(
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 12,
          runSpacing: 12,
          children: List.generate(chips.length, (i) {
            final isActive = _activeFilter == i;
            return GestureDetector(
              onTap: () => setState(() => _activeFilter = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  gradient: isActive
                      ? const LinearGradient(
                    colors: [
                      ClientTheme.accentGoldSoft,
                      ClientTheme.accentGold,
                      ClientTheme.accentGoldDeep,
                    ],
                  )
                      : null,
                  color: isActive ? null : Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isActive
                        ? ClientTheme.accentGold
                        : ClientTheme.accentGold.withOpacity(0.35),
                    width: 1.3,
                  ),
                  boxShadow: isActive
                      ? [
                    BoxShadow(
                      color: ClientTheme.accentGold.withOpacity(0.30),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ]
                      : null,
                ),
                child: Text(
                  chips[i],
                  style: GoogleFonts.alegreyaSc(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                    color: isActive
                        ? const Color(0xFF1A1200)
                        : ClientTheme.accentGold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            );
          }),
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
      color: ClientTheme.royalBlueMid,
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
                    ClientTheme.accentGold.withOpacity(0.6),
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
                      ClientTheme.accentGoldSoft,
                      ClientTheme.accentGoldDeep,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: ClientTheme.accentGold.withOpacity(0.5),
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
                    ClientTheme.accentGold.withOpacity(0.6),
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
  // CTA SECTION before footer
  // ============================================================
  Widget _buildCTASection(bool isDesktop) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            ClientTheme.royalBlueMid,
            ClientTheme.royalBlue,
          ],
        ),
      ),
      padding: EdgeInsets.symmetric(
        vertical: isDesktop ? 60 : 40,
        horizontal: isDesktop ? 60 : 20,
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            children: [
              const Icon(
                Icons.handshake_outlined,
                color: ClientTheme.accentGold,
                size: 40,
              ),
              const SizedBox(height: 14),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    ClientTheme.accentGoldSoft,
                    ClientTheme.accentGold,
                    ClientTheme.accentGoldDeep,
                  ],
                ).createShader(bounds),
                child: Text(
                  "Ready to Join Them?",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.alegreyaSc(
                    fontSize: isDesktop ? 36 : 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.15,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Let's build your brand's success story together.",
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 15,
                  color: ClientTheme.textMuted,
                  height: 1.6,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(height: 26),
              // Gold gradient CTA
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      ClientTheme.accentGoldSoft,
                      ClientTheme.accentGold,
                      ClientTheme.accentGoldDeep,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: ClientTheme.accentGold.withOpacity(0.35),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Contact(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: const Color(0xFF1A1200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 18,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  icon: const Icon(
                    Icons.arrow_forward_rounded,
                    size: 18,
                    color: Color(0xFF1A1200),
                  ),
                  label: Text(
                    "START YOUR PROJECT",
                    style: GoogleFonts.alegreyaSc(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ALL LOGOS GRID
  // ============================================================
  Widget _buildAllLogosGrid(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final int crossAxisCount = screenWidth > 900
        ? 6
        : screenWidth > 600
        ? 4
        : 2;

    final filtered = _filteredLogos;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            ClientTheme.royalBlue,
            ClientTheme.royalBlueMid,
          ],
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Section pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: ClientTheme.accentGold.withOpacity(0.15),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: ClientTheme.accentGold.withOpacity(0.6),
              ),
            ),
            child: Text(
              "TRUSTED PARTNERSHIPS",
              style: GoogleFonts.playfairDisplay(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: ClientTheme.accentGold,
                letterSpacing: 2.0,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            "The Brands We Work With",
            textAlign: TextAlign.center,
            style: GoogleFonts.alegreyaSc(
              fontSize: screenWidth > 900 ? 32 : 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 36),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filtered.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.3,
            ),
            itemBuilder: (context, index) {
              final int rowIndex = index ~/ crossAxisCount;
              final int colIndex = index % crossAxisCount;
              // Find global index for key usage
              final globalIndex = clientLogos
                  .indexWhere((c) => c["path"] == filtered[index]["path"]);
              return BottomToTopAnimatedLogoCard(
                key: _cardKeys[globalIndex >= 0 ? globalIndex : index],
                imagePath: filtered[index]["path"] as String,
                isWhiteLogo: filtered[index]["isWhite"] as bool? ?? false,
                isFeatured: filtered[index]["featured"] as bool? ?? false,
                rowIndex: rowIndex,
                colIndex: colIndex,
              );
            },
          ),
        ],
      ),
    );
  }
}

// ============================================================
// HERO PATTERN PAINTER
// ============================================================
class _ClientHeroPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ClientTheme.accentGold.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (double i = -size.height; i < size.width + size.height; i += 50) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }

    final cyanPaint = Paint()
      ..color = ClientTheme.accentCyan.withOpacity(0.06)
      ..strokeWidth = 1.2;

    for (double i = -size.height; i < size.width + size.height; i += 90) {
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
// BOTTOM-TO-TOP ANIMATED LOGO CARD
// ============================================================
class BottomToTopAnimatedLogoCard extends StatefulWidget {
  final String imagePath;
  final bool isWhiteLogo;
  final bool isFeatured;
  final int rowIndex;
  final int colIndex;

  const BottomToTopAnimatedLogoCard({
    super.key,
    required this.imagePath,
    required this.rowIndex,
    required this.colIndex,
    this.isWhiteLogo = false,
    this.isFeatured = false,
  });

  @override
  State<BottomToTopAnimatedLogoCard> createState() =>
      _BottomToTopAnimatedLogoCardState();
}

class _BottomToTopAnimatedLogoCardState
    extends State<BottomToTopAnimatedLogoCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.6),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.7, curve: Curves.easeIn),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

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

      if (position.dy < screenHeight - 50 &&
          (position.dy + renderObject.size.height) > 0) {
        _hasAnimated = true;
        final int delay = (widget.rowIndex * 100) + (widget.colIndex * 60);
        Future.delayed(Duration(milliseconds: delay), () {
          if (mounted) {
            _controller.forward();
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: _buildCard(),
        ),
      ),
    );
  }

  Widget _buildCard() {
    final bool isFeatured = widget.isFeatured;
    final bool isWhite = widget.isWhiteLogo;

    // Featured cards get gold border + glow; normal cards get subtle cyan
    final borderColor = isFeatured
        ? ClientTheme.accentGold
        : (isWhite
        ? ClientTheme.accentGold.withOpacity(0.55)
        : ClientTheme.accentCyan.withOpacity(0.35));

    final shadowColor = isFeatured
        ? ClientTheme.accentGold.withOpacity(0.30)
        : (isWhite
        ? ClientTheme.accentGold.withOpacity(0.12)
        : ClientTheme.accentCyan.withOpacity(0.14));

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: isWhite
            ? const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0D2551),
            Color(0xFF13315C),
          ],
        )
            : LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.96),
            Colors.white.withOpacity(0.86),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor,
          width: isFeatured ? 1.8 : 1.4,
        ),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: isFeatured ? 20 : 14,
            spreadRadius: isFeatured ? 1 : 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Logo
          Center(
            child: Image.asset(
              widget.imagePath,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.broken_image_outlined,
                color: Colors.grey,
              ),
            ),
          ),
          // Featured crown badge
          if (isFeatured)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      ClientTheme.accentGoldSoft,
                      ClientTheme.accentGoldDeep,
                    ],
                  ),
                ),
                child: const Icon(
                  Icons.workspace_premium_rounded,
                  size: 10,
                  color: Color(0xFF1A1200),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ============================================================
// ANIMATED FOOTER
// ============================================================
class AnimatedFooter extends StatefulWidget {
  final String addressQuery;
  final String phoneNum;
  final String emailAddr;
  final String googleMapsUrl;
  final String facebookUrl;
  final String instagramUrl;
  final String linkedInUrl;
  final Function(String) onLaunchUrl;
  final Function(String) onMakeCall;
  final Function(String) onSendEmail;

  const AnimatedFooter({
    super.key,
    required this.addressQuery,
    required this.phoneNum,
    required this.emailAddr,
    required this.googleMapsUrl,
    required this.facebookUrl,
    required this.instagramUrl,
    required this.linkedInUrl,
    required this.onLaunchUrl,
    required this.onMakeCall,
    required this.onSendEmail,
  });

  @override
  State<AnimatedFooter> createState() => _AnimatedFooterState();
}

class _AnimatedFooterState extends State<AnimatedFooter>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.3, end: 0.9).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth >= Breakpoints.tablet;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            ClientTheme.royalBlue,
            Color(0xFF05132B),
          ],
        ),
      ),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _glowAnimation,
            builder: (context, child) {
              return Container(
                height: 3,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ClientTheme.accentGold
                          .withOpacity(_glowAnimation.value),
                      ClientTheme.accentCyan
                          .withOpacity(_glowAnimation.value),
                      ClientTheme.accentGoldDeep
                          .withOpacity(_glowAnimation.value),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: ClientTheme.accentGold
                          .withOpacity(_glowAnimation.value * 0.6),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              );
            },
          ),
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
                      flex: 2,
                      child: _buildFooterBrandSection(),
                    ),
                    const SizedBox(width: 40),
                    Expanded(
                      flex: 2,
                      child: _buildFooterContactSection(),
                    ),
                    const SizedBox(width: 40),
                    Expanded(
                      flex: 1,
                      child: _buildFooterSocialSection(),
                    ),
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
                style: GoogleFonts.playfairDisplay(
                  fontSize: 13,
                  color: ClientTheme.textMuted,
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
          style: GoogleFonts.playfairDisplay(
            fontSize: 14,
            color: ClientTheme.textMuted,
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
            color: ClientTheme.accentGold,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 16),
        _buildFooterLink(
          icon: Icons.location_on_outlined,
          text: widget.addressQuery,
          onTap: () => widget.onLaunchUrl(widget.googleMapsUrl),
          isMultiLine: true,
        ),
        const SizedBox(height: 12),
        _buildFooterLink(
          icon: Icons.phone_outlined,
          text: widget.phoneNum,
          onTap: () => widget.onMakeCall(widget.phoneNum),
        ),
        const SizedBox(height: 12),
        _buildFooterLink(
          icon: Icons.email_outlined,
          text: widget.emailAddr,
          onTap: () => widget.onSendEmail(widget.emailAddr),
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
            Icon(icon, size: 18, color: ClientTheme.accentGold),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                maxLines: isMultiLine ? 3 : 1,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 13,
                  color: isMultiLine
                      ? ClientTheme.accentWhite
                      : ClientTheme.textMuted,
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
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: ClientTheme.accentGold,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _buildSocialButton(
              icon: FontAwesomeIcons.facebook,
              url: widget.facebookUrl,
            ),
            _buildSocialButton(
              icon: FontAwesomeIcons.instagram,
              url: widget.instagramUrl,
            ),
            _buildSocialButton(
              icon: FontAwesomeIcons.linkedin,
              url: widget.linkedInUrl,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton({required IconData icon, required String url}) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: ClientTheme.accentGold.withOpacity(0.6),
        ),
        boxShadow: [
          BoxShadow(
            color: ClientTheme.accentGold.withOpacity(0.10),
            blurRadius: 8,
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, size: 18, color: ClientTheme.accentGold),
        onPressed: () => widget.onLaunchUrl(url),
      ),
    );
  }
}