import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grow_socialee/About.dart';
import 'package:grow_socialee/Client_Logos.dart';
import 'package:grow_socialee/Reviews.dart';
import 'package:grow_socialee/Services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:grow_socialee/contact.dart';

// ============================================================
// RESPONSIVE BREAKPOINTS
// ============================================================
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

// ============================================================
// UNIFORM LOGO CARD
// ============================================================
class UniformLogoCard extends StatelessWidget {
  final String imagePath;
  final double width;
  final bool isWhiteLogo;

  const UniformLogoCard({
    Key? key,
    required this.imagePath,
    this.width = 320,
    this.isWhiteLogo = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: width / 2.7,
      decoration: BoxDecoration(
        color: isWhiteLogo ? HomePage.glassCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isWhiteLogo
              ? HomePage.accentCyan.withOpacity(0.4)
              : HomePage.brandBlue,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Center(
        child: Image.asset(
          imagePath,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.grey[100],
            child: const Icon(Icons.broken_image_outlined, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// HOME PAGE
// ============================================================
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  // ===== ROYAL PREMIUM THEME =====
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
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late VideoPlayerController _videoController;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _videoKey = GlobalKey();
  bool _isVideoInitialized = false;
  bool _videoError = false;
  double _scrollOffset = 0;

  late PageController _clientPageController;
  Timer? _carouselTimer;
  int _currentLogoPage = 0;
  final GlobalKey<_StatsSectionState> _statsKey =
  GlobalKey<_StatsSectionState>();

  // Hero floating orbs animation
  late AnimationController _orbController;

  final List<bool> _faqExpanded = List.generate(6, (index) => false);

  final List<Map<String, dynamic>> clientLogos = [
    {"path": "assets/photos/aroma.png", "isWhite": true},
    {"path": "assets/photos/aura.png", "isWhite": false},
    {"path": "assets/photos/bani_thani.png", "isWhite": false},
    {"path": "assets/photos/bindu_decor.png", "isWhite": false},
    {"path": "assets/photos/ella.png", "isWhite": false},
    {"path": "assets/photos/every_child.png", "isWhite": false},
    {"path": "assets/photos/gayat_cate.png", "isWhite": false},
    {"path": "assets/photos/kids_connect.png", "isWhite": false},
    {"path": "assets/photos/manas.png", "isWhite": false},
    {"path": "assets/photos/nari_sanari.png", "isWhite": false},
    {"path": "assets/photos/nilav_shah.png", "isWhite": false},
    {"path": "assets/photos/jinali_modi.png", "isWhite": false},
    {"path": "assets/photos/pavan_salon.png", "isWhite": false},
    {"path": "assets/photos/shwass.png", "isWhite": false},
    {"path": "assets/photos/the_celebration.png", "isWhite": true},
    {"path": "assets/photos/ugs.png", "isWhite": false},
    {"path": "assets/photos/ved_icu.png", "isWhite": false},
    {"path": "assets/photos/wost.png", "isWhite": false},
  ];

  final List<Map<String, String>> ourWorkVideos = [
    {"title": "Brand Campaign 1", "path": "assets/videos/video_2.mp4"},
    {"title": "Social Media Showcase", "path": "assets/videos/video_3.mp4"},
    {"title": "Client Reel", "path": "assets/videos/video_4.mp4"},
    {"title": "Promotional Short", "path": "assets/videos/video_5.mp4"},
  ];

  final List<Map<String, String>> faqs = [
    {
      "question": "How will you learn about my business?",
      "answer":
      "We start with a comprehensive discovery session where we dive deep into understanding your business goals, target audience, competitors, and unique value proposition. This helps us create a tailored strategy that aligns with your brand vision."
    },
    {
      "question": "What type of results can I expect?",
      "answer":
      "Results vary based on your industry and goals, but typically our clients see increased engagement within 30 days, follower growth within 60 days, and measurable ROI within 90 days. We set clear KPIs and track progress transparently."
    },
    {
      "question": "How will you create content that fits my business?",
      "answer":
      "Our creative team develops a brand style guide based on your identity, then creates content that resonates with your audience. We combine trending formats with your unique brand voice to maximize engagement."
    },
    {
      "question": "How soon should I expect to see result?",
      "answer":
      "While some improvements like profile optimization are immediate, meaningful growth typically takes 2-3 months. Social media success is a marathon, not a sprint - we focus on sustainable, long-term growth."
    },
    {
      "question":
      "How will you report and how do we know what you'll be working on?",
      "answer":
      "You'll receive monthly performance reports with detailed analytics, plus access to a shared content calendar. We also schedule regular check-in calls to discuss strategy and upcoming campaigns."
    },
    {
      "question": "What sorts of businesses do you work with?",
      "answer":
      "We work with businesses of all sizes - from local startups to established brands. Our expertise spans retail, healthcare, hospitality, education, and professional services."
    },
  ];

  final String addressQuery =
      "First Floor, Leela Efcee, 103, Waghawadi Rd., Hill Drive, Bhavnagar, Gujarat 364002";
  final String phoneNum = "+919408518168";
  final String emailAddr = "growsocialee@gmail.com";
  final String googleMapsUrl =
      "https://maps.google.com/?q=Leela+Efcee+Bhavnagar+Gujarat";

  final String facebookUrl = "https://www.facebook.com/growsocialeeofficial/";
  final String instagramUrl =
      "https://www.instagram.com/growsocialee.official/";
  final String linkedInUrl = "https://in.linkedin.com/company/grow-socialee";

  @override
  void initState() {
    super.initState();
    _initializeVideo();
    _scrollController.addListener(_onScroll);
    _initializeClientCarousel();

    _orbController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  void _onScroll() {
    if (!mounted) return;
    final offset = _scrollController.hasClients
        ? _scrollController.offset
        : 0.0;
    if ((offset - _scrollOffset).abs() > 5) {
      setState(() => _scrollOffset = offset);
    }
    _checkAndControlVideoPlayback();
    _statsKey.currentState?.checkVisibility();
  }

  void _initializeClientCarousel() {
    _clientPageController = PageController(
      initialPage: 0,
      viewportFraction: 0.15,
    );
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _carouselTimer?.cancel();
    _carouselTimer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_clientPageController.hasClients && clientLogos.isNotEmpty) {
        if (_currentLogoPage < clientLogos.length - 1) {
          _currentLogoPage++;
        } else {
          _currentLogoPage = 0;
        }
        _clientPageController.animateToPage(
          _currentLogoPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _stopAutoScroll() {
    _carouselTimer?.cancel();
  }

  void _nextPage() {
    if (!mounted) return;
    if (_clientPageController.hasClients && clientLogos.isNotEmpty) {
      int next = (_currentLogoPage + 1) % clientLogos.length;
      _clientPageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (!mounted) return;
    if (_clientPageController.hasClients && clientLogos.isNotEmpty) {
      int prev =
          (_currentLogoPage - 1 + clientLogos.length) % clientLogos.length;
      _clientPageController.animateToPage(
        prev,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _initializeVideo() {
    try {
      _videoController =
          VideoPlayerController.asset('assets/videos/video.mp4');
      _videoController.setLooping(true);
      _videoController.setVolume(0.0);
      _videoController.initialize().then((_) {
        if (!mounted) return;
        setState(() {
          _isVideoInitialized = true;
          _videoError = false;
        });
        _videoController.play();
      }).catchError((error) {
        if (!mounted) return;
        setState(() => _videoError = true);
        debugPrint('Main Video initialization error: $error');
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _videoError = true);
      debugPrint('Main Video initialization exception: $e');
    }
  }

  void _checkAndControlVideoPlayback() {
    if (!mounted || _videoError) return;
    if (_videoController.value.isInitialized &&
        !_videoController.value.isPlaying) {
      try {
        _videoController.play();
      } catch (e) {
        debugPrint('Error playing video: $e');
      }
    }
  }

  @override
  void dispose() {
    _stopAutoScroll();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _videoController.dispose();
    _clientPageController.dispose();
    _orbController.dispose();
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

  void _openZoomableVideoDialog(
      BuildContext context, VideoPlayerController controller) {
    controller.play();
    showDialog(
      context: context,
      builder: (context) {
        final Size deviceSize = MediaQuery.of(context).size;
        return Dialog(
          backgroundColor: Colors.black.withOpacity(0.92),
          insetPadding: const EdgeInsets.all(10),
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: deviceSize.width * 0.9,
                height: deviceSize.height * 0.8,
                child: InteractiveViewer(
                  panEnabled: true,
                  boundaryMargin: const EdgeInsets.all(20),
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: controller.value.isInitialized
                          ? controller.value.aspectRatio
                          : (9 / 16),
                      child: VideoPlayer(controller),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth >= Breakpoints.tablet;
    final bool isLargeDesktop = screenWidth >= Breakpoints.desktop;

    return Scaffold(
      backgroundColor: HomePage.darkBg,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75),
        child: _buildAppBar(screenWidth, isDesktop),
      ),
      endDrawer: _buildEndDrawer(screenWidth, isDesktop),
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: _buildAGHeroBanner(screenWidth, isDesktop, isLargeDesktop),
          ),
          SliverToBoxAdapter(
            child: _buildAboutVideoSection(screenWidth, isDesktop),
          ),
          SliverToBoxAdapter(
            child: StatsSection(key: _statsKey, isDesktop: isDesktop),
          ),
          SliverToBoxAdapter(
            child: _buildAGProcessSection(screenWidth, isDesktop),
          ),
          SliverToBoxAdapter(
            child: _clientLogo(screenWidth),
          ),
          SliverToBoxAdapter(
            child: _buildAGOurWorkSection(context, screenWidth),
          ),
          SliverToBoxAdapter(
            child: _buildAGFaqSection(screenWidth, isDesktop),
          ),
          SliverToBoxAdapter(
            child: _buildAGFooter(context, screenWidth),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // APP BAR
  // ============================================================
  PreferredSizeWidget _buildAppBar(double screenWidth, bool isDesktop) {
    final bool isScrolled = _scrollOffset > 30;
    return PreferredSize(
      preferredSize: const Size.fromHeight(75),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isScrolled
                ? [
              HomePage.royalBlue.withOpacity(0.98),
              HomePage.royalBlueMid.withOpacity(0.98),
            ]
                : [
              HomePage.royalBlue,
              HomePage.royalBlueMid,
            ],
          ),
          border: Border(
            bottom: BorderSide(
              color: HomePage.accentGold.withOpacity(isScrolled ? 0.8 : 0.4),
              width: 1.5,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: HomePage.accentCyan
                  .withOpacity(isScrolled ? 0.25 : 0.12),
              blurRadius: isScrolled ? 24 : 16,
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
                            HomePage.accentGold.withOpacity(0.22),
                            HomePage.accentGoldDeep.withOpacity(0.12),
                          ],
                        ),
                        border: Border.all(
                          color: HomePage.accentGold.withOpacity(0.7),
                          width: 1.4,
                        ),
                      ),
                      child: const Icon(Icons.menu_rounded,
                          color: HomePage.accentGold, size: 24),
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
                  HomePage.accentGold.withOpacity(0.25),
                  HomePage.accentGoldDeep.withOpacity(0.10),
                ],
              ),
              border: Border.all(
                color: HomePage.accentGold.withOpacity(0.7),
                width: 1.2,
              ),
            ),
            child: const Icon(Icons.workspace_premium_rounded,
                color: HomePage.accentGold, size: 18),
          ),
          const SizedBox(width: 12),
          Flexible(
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
      width: isDesktop ? 380 : math.min(screenWidth * 0.85, 340),
      backgroundColor: HomePage.royalBlue,
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
                    HomePage.royalBlueMid,
                    HomePage.glassCard,
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
                color: HomePage.accentGold.withOpacity(0.4)),
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
                    HomePage.accentGoldSoft,
                    HomePage.accentGold,
                    HomePage.accentGoldDeep,
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
                  HomePage.accentGoldSoft,
                  HomePage.accentGold,
                  HomePage.accentGoldDeep,
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
  Widget _buildAGHeroBanner(
      double screenWidth, bool isDesktop, bool isLargeDesktop) {
    final double heroPaddingV = isLargeDesktop
        ? 130
        : isDesktop
        ? 100
        : 60;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0.6, -0.3),
          radius: 1.4,
          colors: [
            Color(0xFF173F7B),
            HomePage.royalBlue,
            Color(0xFF061733),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Animated floating orbs
          ..._buildFloatingOrbs(),
          // Static gold glow (top-right)
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
                    HomePage.accentGold.withOpacity(0.10),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Background image
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
              vertical: heroPaddingV,
              horizontal: isLargeDesktop
                  ? 80
                  : isDesktop
                  ? 50
                  : 22,
            ),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1180),
                child: isDesktop
                    ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 5,
                      child: _buildHeroTextContent(isDesktop),
                    ),
                    const SizedBox(width: 48),
                    Expanded(
                      flex: 4,
                      child: _buildHeroStatCards(isDesktop),
                    ),
                  ],
                )
                    : Column(
                  children: [
                    _buildHeroTextContent(isDesktop),
                    const SizedBox(height: 40),
                    _buildHeroStatCards(isDesktop),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Animated floating orbs for hero
  List<Widget> _buildFloatingOrbs() {
    return [
      AnimatedBuilder(
        animation: _orbController,
        builder: (context, _) {
          final t = _orbController.value * 2 * math.pi;
          return Positioned(
            top: 100 + math.sin(t) * 30,
            left: 40 + math.cos(t) * 20,
            child: _orb(140, HomePage.accentCyan.withOpacity(0.10)),
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
            child: _orb(180, HomePage.accentGold.withOpacity(0.08)),
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
            child: _orb(90, HomePage.accentCyan.withOpacity(0.14)),
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

  // Left side hero text
  Widget _buildHeroTextContent(bool isDesktop) {
    return Column(
      crossAxisAlignment:
      isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        // Pill badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
          decoration: BoxDecoration(
            color: HomePage.accentGold.withOpacity(0.12),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: HomePage.accentGold.withOpacity(0.6),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: HomePage.accentGold.withOpacity(0.10),
                blurRadius: 10,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.workspace_premium_rounded,
                  color: HomePage.accentGold, size: 16),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  "PREMIUM SOCIAL GROWTH AGENCY",
                  style: GoogleFonts.bellota(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: HomePage.accentGold,
                    letterSpacing: 2.2,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          "Getting your name on top",
          textAlign: isDesktop ? TextAlign.left : TextAlign.center,
          style: GoogleFonts.bellota(
            fontSize: isDesktop ? 40 : 26,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 4),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [
              HomePage.accentGoldSoft,
              HomePage.accentGold,
              HomePage.accentGoldDeep,
            ],
          ).createShader(bounds),
          child: Text(
            "No.1 priority",
            textAlign: isDesktop ? TextAlign.left : TextAlign.center,
            style: GoogleFonts.bellota(
              fontSize: isDesktop ? 68 : 42,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.05,
              letterSpacing: -1,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          "Premium social growth, influence & visibility — crafted for royalty. Trusted by brands, creators & leaders worldwide.",
          textAlign: isDesktop ? TextAlign.left : TextAlign.center,
          style: GoogleFonts.bellota(
            fontSize: isDesktop ? 16 : 14,
            color: HomePage.textSoft,
            height: 1.6,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 32),
        Wrap(
          spacing: 16,
          runSpacing: 14,
          alignment: isDesktop ? WrapAlignment.start : WrapAlignment.center,
          children: [
            _buildGoldGradientButton(
              icon: Icons.rocket_launch_rounded,
              label: "Start Growing Now",
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Contact()));
              },
            ),
            _buildGlassOutlineButton(
              icon: Icons.grid_view_rounded,
              label: "Learn More",
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Services()));
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGoldGradientButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return _HoverScale(
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              HomePage.accentGoldSoft,
              HomePage.accentGold,
              HomePage.accentGoldDeep,
            ],
          ),
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: HomePage.accentGold.withOpacity(0.30),
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
            padding:
            const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
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
              letterSpacing: 0.8,
            ),
          ),
          onPressed: onTap,
        ),
      ),
    );
  }

  Widget _buildGlassOutlineButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return _HoverScale(
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.white.withOpacity(0.06),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
          side: BorderSide(
            color: HomePage.accentCyan.withOpacity(0.8),
            width: 1.6,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        icon: Icon(icon, size: 18, color: HomePage.accentCyan),
        label: Text(
          label,
          style: GoogleFonts.bellota(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
          ),
        ),
        onPressed: onTap,
      ),
    );
  }

  Widget _buildHeroStatCards(bool isDesktop) {
    final cards = [
      {
        "icon": Icons.trending_up_rounded,
        "title": "Audience Growth",
        "value": "+120% in 30 Days",
        "sub": "Organic followers • Real engagement",
      },
      {
        "icon": Icons.bolt_rounded,
        "title": "Engagement Boost",
        "value": "98% Increase",
        "sub": "Likes • Comments • Shares • Saves",
      },
      {
        "icon": Icons.verified_user_rounded,
        "title": "Royal Support",
        "value": "24/7 Priority Care",
        "sub": "Dedicated account manager • VIP onboarding",
      },
    ];

    return Column(
      children: cards.map((c) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildGlassStatCard(
            icon: c["icon"] as IconData,
            title: c["title"] as String,
            value: c["value"] as String,
            sub: c["sub"] as String,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGlassStatCard({
    required IconData icon,
    required String title,
    required String value,
    required String sub,
  }) {
    return _HoverScale(
      scale: 1.02,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.10),
                  Colors.white.withOpacity(0.04),
                ],
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: HomePage.accentCyan.withOpacity(0.35),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: HomePage.accentCyan.withOpacity(0.10),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        HomePage.accentGoldSoft,
                        HomePage.accentGoldDeep,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: HomePage.accentGold.withOpacity(0.20),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child:
                  Icon(icon, color: const Color(0xFF1A1200), size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.bellota(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: HomePage.accentGold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        value,
                        style: GoogleFonts.bellota(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        sub,
                        style: GoogleFonts.bellota(
                          fontSize: 10.5,
                          color: HomePage.textMuted,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ABOUT + VIDEO SECTION
  // ============================================================
  Widget _buildAboutVideoSection(double screenWidth, bool isDesktop) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            HomePage.royalBlue,
            HomePage.royalBlueMid,
          ],
        ),
      ),
      padding: EdgeInsets.symmetric(
        vertical: 60,
        horizontal: isDesktop ? 60 : 20,
      ),
      child: isDesktop
          ? Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: _buildDirectVideoPlayer(context)),
          const SizedBox(width: 50),
          Expanded(child: _buildAGAgencyDescription()),
        ],
      )
          : Column(
        children: [
          _buildDirectVideoPlayer(context),
          const SizedBox(height: 40),
          _buildAGAgencyDescription(),
        ],
      ),
    );
  }

  Widget _buildDirectVideoPlayer(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;
    final bool isDesktop = deviceSize.width >= Breakpoints.tablet;

    final double playerWidth = isDesktop
        ? (deviceSize.width * 0.25).clamp(280.0, 360.0)
        : (deviceSize.width * 0.85).clamp(240.0, 340.0);
    final double playerHeight = playerWidth * 1.55;

    return Center(
      key: _videoKey,
      child: GestureDetector(
        onTap: () => _openZoomableVideoDialog(context, _videoController),
        child: SizedBox(
          width: playerWidth + 30,
          height: playerHeight + 30,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Cyan glow block behind
              Positioned(
                left: 0,
                bottom: 0,
                child: Container(
                  width: playerWidth * 0.8,
                  height: playerHeight * 0.5,
                  decoration: BoxDecoration(
                    color: HomePage.accentCyan.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: HomePage.accentCyan.withOpacity(0.18),
                        blurRadius: 24,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
              // Gold glow accent
              Positioned(
                right: -10,
                top: -10,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        HomePage.accentGold.withOpacity(0.18),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: _HoverScale(
                  scale: 1.02,
                  child: Container(
                    width: playerWidth,
                    height: playerHeight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: HomePage.accentGold.withOpacity(0.7),
                        width: 1.6,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: HomePage.accentCyan.withOpacity(0.22),
                          blurRadius: 20,
                          spreadRadius: 1,
                          offset: const Offset(0, 8),
                        ),
                        BoxShadow(
                          color: HomePage.accentGold.withOpacity(0.10),
                          blurRadius: 14,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        children: [
                          !_videoError
                              ? AspectRatio(
                            aspectRatio: _videoController
                                .value.isInitialized
                                ? _videoController.value.aspectRatio
                                : (9 / 16),
                            child: VideoPlayer(_videoController),
                          )
                              : Container(
                            color: HomePage.glassCard,
                            child: Center(
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.videocam_off,
                                      color: HomePage.textMuted,
                                      size: 40),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Video format unsupported",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.plusJakartaSans(
                                      color: HomePage.textMuted,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Play overlay
                          if (!_videoError && _isVideoInitialized)
                            Positioned.fill(
                              child: IgnorePointer(
                                child: Center(
                                  child: AnimatedOpacity(
                                    duration:
                                    const Duration(milliseconds: 200),
                                    opacity: 0.0,
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black.withOpacity(0.4),
                                        border: Border.all(
                                          color: HomePage.accentGold,
                                          width: 2,
                                        ),
                                      ),
                                      child: const Icon(Icons.play_arrow_rounded,
                                          color: HomePage.accentGold,
                                          size: 32),
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAGAgencyDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: HomePage.accentGold.withOpacity(0.15),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: HomePage.accentGold.withOpacity(0.6)),
          ),
          child: Text(
            "ABOUT GROW SOCIALEE",
            style: GoogleFonts.bellota(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: HomePage.accentGold,
              letterSpacing: 2.0,
            ),
          ),
        ),
        const SizedBox(height: 14),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [
              HomePage.accentGoldSoft,
              HomePage.accentGold,
              HomePage.accentGoldDeep,
            ],
          ).createShader(bounds),
          child: Text(
            "Grow Socialee",
            style: GoogleFonts.bellota(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.1,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "We are Grow Socialee, a top social media marketing agency in Bhavnagar, helping small and medium-sized businesses boost their online presence. In today's digital world, standing out is essential, and we simplify that process for you.",
          textAlign: TextAlign.justify,
          style: GoogleFonts.bellota(
            fontSize: 15,
            color: HomePage.textMuted,
            height: 1.6,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "As the best digital marketing agency in Bhavnagar, we specialize in branding, content creation, social media management, and digital advertising. Need engaging video content? We are also the best video editing company in Bhavnagar, crafting eye-catching visuals for your brand.",
          textAlign: TextAlign.justify,
          style: GoogleFonts.bellota(
            fontSize: 15,
            color: HomePage.textMuted,
            height: 1.6,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          "Let's build your digital success together! 📩 Contact Grow Socialee today!",
          textAlign: TextAlign.justify,
          style: GoogleFonts.bellota(
            fontSize: 15,
            color: Colors.white,
            height: 1.5,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          "We understand social behaviours within online communities, cultures and subcultures.",
          textAlign: TextAlign.justify,
          style: GoogleFonts.bellota(
            fontSize: 15,
            fontWeight: FontWeight.w300,
            color: Colors.white70,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 24),
        _buildGoldGradientButton(
          icon: Icons.mail_outline_rounded,
          label: "Get in Touch",
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Contact()));
          },
        ),
      ],
    );
  }

  // ============================================================
  // PROCESS SECTION
  // ============================================================
  Widget _buildAGProcessSection(double screenWidth, bool isDesktop) {
    final steps = [
      {
        "step": "01",
        "title": "Define Your Vision",
        "desc":
        "We clarify your goals, audience, offer, and creative direction with clear objectives."
      },
      {
        "step": "02",
        "title": "Submit Your Strategy",
        "desc":
        "Share requirements and timelines through a seamless collaborative roadmap."
      },
      {
        "step": "03",
        "title": "Create & Refine",
        "desc":
        "We design, shoot, build, and polish with structured feedback loops."
      },
      {
        "step": "04",
        "title": "Project Delivery",
        "desc":
        "Your final assets and marketing campaigns go live to drive revenue."
      },
    ];

    return Container(
      padding: EdgeInsets.symmetric(
          vertical: 80, horizontal: isDesktop ? 60 : 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            HomePage.darkBg,
            HomePage.royalBlueMid,
          ],
        ),
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1150),
          child: Column(
            children: [
              _buildSectionPill("OUR METHODOLOGY"),
              const SizedBox(height: 14),
              Text(
                "A Clearer Way to Build & Scale",
                textAlign: TextAlign.center,
                style: GoogleFonts.bellota(
                  fontSize: isDesktop ? 38 : 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
              LayoutBuilder(
                builder: (context, constraints) {
                  int columns = 4;
                  if (constraints.maxWidth < 500) {
                    columns = 1;
                  } else if (constraints.maxWidth < 900) {
                    columns = 2;
                  }
                  final double spacing = 20;
                  final double w = (constraints.maxWidth -
                      (spacing * (columns - 1))) /
                      columns;
                  return Wrap(
                    spacing: spacing,
                    runSpacing: spacing,
                    children:
                    steps.map((s) => _buildProcessCard(s, w)).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProcessCard(Map<String, String> s, double width) {
    return SizedBox(
      width: width,
      child: _HoverScale(
        scale: 1.03,
        child: Container(
          padding: const EdgeInsets.all(22),
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
              color: HomePage.accentCyan.withOpacity(0.35),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: HomePage.accentCyan.withOpacity(0.08),
                blurRadius: 14,
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
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [
                        HomePage.accentGoldSoft,
                        HomePage.accentGoldDeep,
                      ],
                    ).createShader(bounds),
                    child: Text(
                      s["step"]!,
                      style: GoogleFonts.bellota(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: HomePage.accentGold.withOpacity(0.12),
                      border: Border.all(
                        color: HomePage.accentGold.withOpacity(0.5),
                      ),
                    ),
                    child: const Icon(Icons.arrow_forward_rounded,
                        color: HomePage.accentGold, size: 14),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                s["title"]!,
                style: GoogleFonts.bellota(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                s["desc"]!,
                style: GoogleFonts.bellota(
                  fontSize: 13,
                  color: HomePage.textMuted,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // FAQ SECTION
  // ============================================================
  Widget _buildAGFaqSection(double screenWidth, bool isDesktop) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: 80, horizontal: isDesktop ? 60 : 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            HomePage.royalBlueMid,
            HomePage.darkBg,
          ],
        ),
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            children: [
              _buildSectionPill("QUESTIONS ANSWERED", isCyan: true),
              const SizedBox(height: 10),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    HomePage.accentGoldSoft,
                    HomePage.accentGold,
                    HomePage.accentGoldDeep,
                  ],
                ).createShader(bounds),
                child: Text(
                  "Frequently Asked Questions",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.bellota(
                    fontSize: isDesktop ? 38 : 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 36),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: faqs.length,
                itemBuilder: (context, index) {
                  final faq = faqs[index];
                  final isExpanded = _faqExpanded[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
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
                        color: isExpanded
                            ? HomePage.accentGold
                            : HomePage.accentCyan.withOpacity(0.25),
                        width: 1.4,
                      ),
                      boxShadow: isExpanded
                          ? [
                        BoxShadow(
                          color: HomePage.accentGold.withOpacity(0.10),
                          blurRadius: 12,
                        )
                      ]
                          : null,
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.transparent,
                      ),
                      child: ExpansionTile(
                        key: Key('faq_$index'),
                        initiallyExpanded: isExpanded,
                        onExpansionChanged: (expanded) {
                          setState(() => _faqExpanded[index] = expanded);
                        },
                        iconColor: HomePage.accentGold,
                        collapsedIconColor: HomePage.accentCyan,
                        title: Text(
                          faq["question"]!,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0, right: 16.0, bottom: 16.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                faq["answer"]!,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  color: HomePage.textMuted,
                                  height: 1.6,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SECTION PILL HELPER
  // ============================================================
  Widget _buildSectionPill(String label, {bool isCyan = false}) {
    final color = isCyan ? HomePage.accentCyan : HomePage.accentGold;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color.withOpacity(0.6)),
      ),
      child: Text(
        label,
        style: GoogleFonts.bellota(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: color,
          letterSpacing: 2.0,
        ),
      ),
    );
  }

  // ============================================================
  // CLIENT LOGO CAROUSEL
  // ============================================================
  Widget _clientLogo(double screenWidth) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double w = constraints.maxWidth;

        double cardWidth;
        double cardHeight;
        double viewportFraction;

        if (w > 1400) {
          viewportFraction = 0.14;
          cardWidth = 190;
          cardHeight = 95;
        } else if (w > 1200) {
          viewportFraction = 0.18;
          cardWidth = 180;
          cardHeight = 90;
        } else if (w > 900) {
          viewportFraction = 0.24;
          cardWidth = 175;
          cardHeight = 88;
        } else if (w > 600) {
          viewportFraction = 0.35;
          cardWidth = 165;
          cardHeight = 82;
        } else if (w > 400) {
          viewportFraction = 0.55;
          cardWidth = 155;
          cardHeight = 78;
        } else {
          viewportFraction = 0.72;
          cardWidth = 145;
          cardHeight = 72;
        }

        if (_clientPageController.viewportFraction != viewportFraction) {
          final int currentPage =
          _clientPageController.hasClients &&
              _clientPageController.page != null
              ? _clientPageController.page!.round()
              : _currentLogoPage;
          _clientPageController = PageController(
            initialPage: currentPage,
            viewportFraction: viewportFraction,
          );
        }

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 60.0, horizontal: 20.0),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                HomePage.royalBlueMid,
                HomePage.royalBlue,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildSectionPill("TRUSTED PARTNERSHIPS"),
              const SizedBox(height: 14),
              Text(
                "The Brands We're Working With",
                style: GoogleFonts.bellota(
                  fontSize: w > 900 ? 34 : 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 36),
              MouseRegion(
                onEnter: (_) => _stopAutoScroll(),
                onExit: (_) => _startAutoScroll(),
                child: SizedBox(
                  height: cardHeight + 30,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification notification) {
                          if (notification is ScrollStartNotification) {
                            _stopAutoScroll();
                          } else if (notification is ScrollEndNotification) {
                            _startAutoScroll();
                          }
                          return false;
                        },
                        child: PageView.builder(
                          controller: _clientPageController,
                          onPageChanged: (int index) {
                            if (mounted) {
                              setState(() => _currentLogoPage = index);
                            }
                          },
                          itemCount: clientLogos.length,
                          itemBuilder: (context, index) {
                            final bool isWhiteLogo =
                                (clientLogos[index]["isWhite"] ?? false) ==
                                    true;

                            return AnimatedBuilder(
                              animation: _clientPageController,
                              builder: (context, child) {
                                double value = 1.0;
                                if (_clientPageController
                                    .position.haveDimensions) {
                                  value =
                                  (_clientPageController.page! - index);
                                  value = (1 - (value.abs() * 0.12))
                                      .clamp(0.88, 1.0);
                                }
                                return Center(
                                  child: Transform.scale(
                                    scale: value,
                                    child: child,
                                  ),
                                );
                              },
                              child: Container(
                                margin:
                                const EdgeInsets.symmetric(horizontal: 6),
                                width: cardWidth,
                                height: cardHeight,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  gradient: isWhiteLogo
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
                                      Colors.white.withOpacity(0.95),
                                      Colors.white.withOpacity(0.85),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: isWhiteLogo
                                        ? HomePage.accentGold
                                        .withOpacity(0.55)
                                        : HomePage.accentCyan
                                        .withOpacity(0.35),
                                    width: 1.2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: isWhiteLogo
                                          ? HomePage.accentGold
                                          .withOpacity(0.10)
                                          : HomePage.accentCyan
                                          .withOpacity(0.12),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Image.asset(
                                    clientLogos[index]["path"]!,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error,
                                        stackTrace) =>
                                    const Icon(
                                        Icons.broken_image_outlined,
                                        color: Colors.grey),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      // Arrows
                      Positioned(
                        left: 0,
                        child: Material(
                          color: HomePage.accentGold,
                          shape: const CircleBorder(),
                          elevation: 4,
                          child: InkWell(
                            onTap: _previousPage,
                            customBorder: const CircleBorder(),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: const Icon(
                                Icons.arrow_back_ios_rounded,
                                size: 14,
                                color: Color(0xFF1A1200),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        child: Material(
                          color: HomePage.accentGold,
                          shape: const CircleBorder(),
                          elevation: 4,
                          child: InkWell(
                            onTap: _nextPage,
                            customBorder: const CircleBorder(),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 14,
                                color: Color(0xFF1A1200),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    clientLogos.length,
                        (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: _currentLogoPage == index ? 18 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        gradient: _currentLogoPage == index
                            ? const LinearGradient(
                          colors: [
                            HomePage.accentGoldSoft,
                            HomePage.accentGoldDeep,
                          ],
                        )
                            : null,
                        color: _currentLogoPage == index
                            ? null
                            : Colors.white24,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // OUR WORK SECTION — 4-column responsive grid
  // ============================================================
  Widget _buildAGOurWorkSection(BuildContext context, double screenWidth) {
    final bool isDesktop = screenWidth >= Breakpoints.tablet;
    final double horizontal = isDesktop ? 60 : 20;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            HomePage.darkBg,
            HomePage.royalBlueMid,
          ],
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 70.0, horizontal: horizontal),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: Column(
            children: [
              _buildSectionPill("SELECTED WORK"),
              const SizedBox(height: 14),
              Text(
                "What We've Built",
                textAlign: TextAlign.center,
                style: GoogleFonts.bellota(
                  fontSize: screenWidth > 900 ? 36 : 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Creative showcases & production reels.",
                textAlign: TextAlign.center,
                style: GoogleFonts.bellota(
                  fontSize: 15,
                  color: HomePage.textMuted,
                ),
              ),
              const SizedBox(height: 36),
              LayoutBuilder(
                builder: (context, constraints) {
                  // Responsive grid breakpoints:
                  //  - >= 1024 px : 4 columns (Desktop)
                  //  - >= 700 px  : 3 columns (Tablet)
                  //  - >= 480 px  : 2 columns (Large Mobile)
                  //  - < 480 px   : 1 column  (Mobile)
                  int columns;
                  if (constraints.maxWidth < 480) {
                    columns = 1;
                  } else if (constraints.maxWidth < 700) {
                    columns = 2;
                  } else if (constraints.maxWidth < 1024) {
                    columns = 3;
                  } else {
                    columns = 4;
                  }

                  final double spacing = 16;
                  final double w = (constraints.maxWidth -
                      (spacing * (columns - 1))) /
                      columns;

                  return Wrap(
                    spacing: spacing,
                    runSpacing: spacing,
                    alignment: WrapAlignment.center,
                    children: ourWorkVideos.map((item) {
                      return SizedBox(
                        width: w,
                        child: _OurWorkVideoCard(
                          videoPath: item["path"]!,
                          title: item["title"]!,
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

  // ============================================================
  // FOOTER
  // ============================================================
  Widget _buildAGFooter(BuildContext context, double screenWidth) {
    final bool isDesktop = screenWidth >= Breakpoints.tablet;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            HomePage.royalBlue,
            Color(0xFF05132B),
          ],
        ),
      ),
      child: Column(
        children: [
          Divider(
              height: 1,
              thickness: 1,
              color: HomePage.accentGold.withOpacity(0.4)),
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
                        flex: 2,
                        child: _buildFooterContactSection()),
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
                  color: HomePage.textMuted,
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
              fontSize: 14, color: HomePage.textMuted, height: 1.6),
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
            color: HomePage.accentGold,
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
            Icon(icon, size: 18, color: HomePage.accentGold),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                maxLines: isMultiLine ? 3 : 1,
                style: GoogleFonts.bellota(
                  fontSize: 13,
                  color: isMultiLine
                      ? HomePage.accentWhite
                      : HomePage.textMuted,
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
            color: HomePage.accentGold,
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
    return _HoverScale(
      scale: 1.1,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: HomePage.accentGold.withOpacity(0.6)),
          boxShadow: [
            BoxShadow(
              color: HomePage.accentGold.withOpacity(0.10),
              blurRadius: 8,
            ),
          ],
        ),
        child: IconButton(
          icon: Icon(icon, size: 18, color: HomePage.accentGold),
          onPressed: () => _launchUrlString(url),
        ),
      ),
    );
  }
}

// ============================================================
// HOVER SCALE WRAPPER (Desktop hover effect)
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

// ============================================================
// OUR WORK VIDEO CARD
// ============================================================
class _OurWorkVideoCard extends StatefulWidget {
  final String videoPath;
  final String title;

  const _OurWorkVideoCard({
    required this.videoPath,
    required this.title,
  });

  @override
  State<_OurWorkVideoCard> createState() => _OurWorkVideoCardState();
}

class _OurWorkVideoCardState extends State<_OurWorkVideoCard> {
  late VideoPlayerController _controller;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoPath);
    _controller.setLooping(true);
    _controller.setVolume(0.0);
    _controller.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
      _controller.play();
    }).catchError((err) {
      if (!mounted) return;
      setState(() => _hasError = true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _HoverScale(
      scale: 1.03,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.08),
              Colors.white.withOpacity(0.03),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: HomePage.accentGold.withOpacity(0.5),
            width: 1.4,
          ),
          boxShadow: [
            BoxShadow(
              color: HomePage.accentCyan.withOpacity(0.10),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(16)),
              child: AspectRatio(
                aspectRatio: 9 / 16,
                child: !_hasError
                    ? Stack(
                  alignment: Alignment.center,
                  children: [
                    VideoPlayer(_controller),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color:
                            HomePage.accentGold.withOpacity(0.6),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.touch_app_rounded,
                                color: HomePage.accentGold, size: 12),
                            const SizedBox(width: 4),
                            Text(
                              "TAP",
                              style: GoogleFonts.bellota(
                                fontSize: 9,
                                color: HomePage.accentGold,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
                    : Container(
                  color: HomePage.glassCard,
                  child: const Center(
                    child: Icon(Icons.broken_image,
                        color: Colors.grey),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                widget.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.bellota(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: HomePage.accentGold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// STATS
// ============================================================
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
    StatData(endValue: 50, suffix: "+", label: "BRANDS SCALED"),
    StatData(endValue: 1000, suffix: "+", label: "VIDEOS CREATED"),
    StatData(endValue: 99, suffix: "%", label: "CLIENT RETENTION"),
    StatData(endValue: 4.9, suffix: "★", label: "GOOGLE RATING", isDecimal: true),
    StatData(endValue: 14, suffix: "", label: "DEDICATED TEAM"),
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
            HomePage.royalBlueMid,
            HomePage.royalBlue,
          ],
        ),
      ),
      padding: EdgeInsets.symmetric(
        vertical: 60,
        horizontal: widget.isDesktop ? 60 : 20,
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: widget.isDesktop
              ? LayoutBuilder(
            builder: (context, constraints) {
              int columns = 5;
              if (constraints.maxWidth < 900) columns = 3;
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
                        width: 170,
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

    return _HoverScale(
      scale: 1.05,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
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
            color: HomePage.accentGold.withOpacity(0.6),
            width: 1.4,
          ),
          boxShadow: [
            BoxShadow(
              color: HomePage.accentCyan.withOpacity(0.10),
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
                  HomePage.accentGoldSoft,
                  HomePage.accentGold,
                  HomePage.accentGoldDeep,
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
                color: HomePage.textMuted,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}