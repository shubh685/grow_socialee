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
// THEME CONTROLLER — LIGHT / DARK SWITCHABLE
// ============================================================
class GSTheme {
  final bool isDark;

  const GSTheme({this.isDark = true});

  // Core brand colors (shared)
  static const Color accentGold = Color(0xFFF5C842);
  static const Color accentGoldDeep = Color(0xFFD4A017);
  static const Color accentGoldSoft = Color(0xFFFFE08A);
  static const Color accentCyan = Color(0xFF4FC3F7);
  static const Color brandBlue = Color(0xFF1E88E5);
  static const Color accentPink = Color(0xFFFF2E63); // Spettro-style highlight

  // DARK palette
  static const Color darkBg = Color(0xFF050B1A);
  static const Color darkBgAlt = Color(0xFF0A1F44);
  static const Color darkCard = Color(0xFF0D2551);
  static const Color darkGlass = Color(0xFF13315C);
  static const Color darkTextMuted = Color(0xFF8BA8C9);
  static const Color darkTextSoft = Color(0xFFD6E6FA);

  // LIGHT palette
  static const Color lightBg = Color(0xFFF7F9FC);
  static const Color lightBgAlt = Color(0xFFEEF3FA);
  static const Color lightCard = Colors.white;
  static const Color lightGlass = Color(0xFFF1F5FB);
  static const Color lightTextMuted = Color(0xFF5B6B82);
  static const Color lightTextSoft = Color(0xFF2A3A52);

  // Active colors
  Color get bg => isDark ? darkBg : lightBg;
  Color get bgAlt => isDark ? darkBgAlt : lightBgAlt;
  Color get card => isDark ? darkCard : lightCard;
  Color get glass => isDark ? darkGlass : lightGlass;
  Color get textPrimary => isDark ? Colors.white : const Color(0xFF0A1F44);
  Color get textMuted => isDark ? darkTextMuted : lightTextMuted;
  Color get textSoft => isDark ? darkTextSoft : lightTextSoft;
  Color get border => isDark
      ? accentGold.withOpacity(0.35)
      : const Color(0xFF0A1F44).withOpacity(0.12);
  Color get surfaceOverlay =>
      isDark ? Colors.white.withOpacity(0.06) : Colors.white.withOpacity(0.9);
}

// ============================================================
// UNIFORM LOGO CARD (kept for reuse)
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
        color: isWhiteLogo ? GSTheme.darkGlass : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isWhiteLogo
              ? GSTheme.accentCyan.withOpacity(0.4)
              : GSTheme.brandBlue,
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

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _isDarkMode = true; // <-- toggle this to switch themes

  GSTheme get theme => GSTheme(isDark: _isDarkMode);

  late VideoPlayerController _videoController;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _videoKey = GlobalKey();
  bool _isVideoInitialized = false;
  bool _videoError = false;
  double _scrollOffset = 0;

  late PageController _clientPageController;
  Timer? _carouselTimer;
  int _currentLogoPage = 0;

  late PageController _workPageController;
  Timer? _workCarouselTimer;
  int _currentWorkPage = 0;

  final GlobalKey<_StatsSectionState> _statsKey =
  GlobalKey<_StatsSectionState>();

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
    {"title": "Brand Campaign 1", "path": "assets/videos/video.mp4"},
    {"title": "Brand Campaign 2", "path": "assets/videos/video_2.mp4"},
    {"title": "Social Media Showcase", "path": "assets/videos/video_3.mp4"},
    {"title": "Client Reel 1", "path": "assets/videos/video_4.mp4"},
    {"title": "Promotional Short 1", "path": "assets/videos/video_5.mp4"},
    {"title": "Creative Spotlight", "path": "assets/videos/video_6.mp4"},
    {"title": "Brand Storytelling", "path": "assets/videos/video_7.mp4"},
    {"title": "Dynamic Promo", "path": "assets/videos/video_8.mp4"},
    {"title": "High-End Showcase", "path": "assets/videos/video_9.mp4"},
    {"title": "Targeted Reel", "path": "assets/videos/video_10.mp4"},
    {"title": "Engagement Short", "path": "assets/videos/video_11.mp4"},
    {"title": "Corporate Highlight", "path": "assets/videos/video_12.mp4"},
    {"title": "Masterpiece Final", "path": "assets/videos/video_13.mp4"},
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
    _initializeWorkCarousel();

    _orbController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  void _onScroll() {
    if (!mounted) return;
    final offset = _scrollController.hasClients ? _scrollController.offset : 0.0;
    if ((offset - _scrollOffset).abs() > 5) {
      setState(() => _scrollOffset = offset);
    }
    _checkAndControlVideoPlayback();
    _statsKey.currentState?.checkVisibility();
  }

  void _initializeClientCarousel() {
    _clientPageController =
        PageController(initialPage: 0, viewportFraction: 0.15);
    _startAutoScroll();
  }

  void _initializeWorkCarousel() {
    _workPageController =
        PageController(initialPage: 0, viewportFraction: 0.22);
    _startWorkAutoScroll();
  }

  void _startAutoScroll() {
    _carouselTimer?.cancel();
    _carouselTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_clientPageController.hasClients && clientLogos.isNotEmpty) {
        _currentLogoPage = (_currentLogoPage + 1) % clientLogos.length;
        _clientPageController.animateToPage(
          _currentLogoPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _stopAutoScroll() => _carouselTimer?.cancel();

  void _startWorkAutoScroll() {
    _workCarouselTimer?.cancel();
    _workCarouselTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_workPageController.hasClients && ourWorkVideos.isNotEmpty) {
        _currentWorkPage = (_currentWorkPage + 1) % ourWorkVideos.length;
        _workPageController.animateToPage(
          _currentWorkPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _stopWorkAutoScroll() => _workCarouselTimer?.cancel();

  void _nextPage() {
    if (!mounted) return;
    if (_clientPageController.hasClients && clientLogos.isNotEmpty) {
      int next = (_currentLogoPage + 1) % clientLogos.length;
      _clientPageController.animateToPage(next,
          duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    }
  }

  void _previousPage() {
    if (!mounted) return;
    if (_clientPageController.hasClients && clientLogos.isNotEmpty) {
      int prev =
          (_currentLogoPage - 1 + clientLogos.length) % clientLogos.length;
      _clientPageController.animateToPage(prev,
          duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    }
  }

  void _nextWorkPage() {
    if (!mounted) return;
    if (_workPageController.hasClients && ourWorkVideos.isNotEmpty) {
      int next = (_currentWorkPage + 1) % ourWorkVideos.length;
      _workPageController.animateToPage(next,
          duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    }
  }

  void _previousWorkPage() {
    if (!mounted) return;
    if (_workPageController.hasClients && ourWorkVideos.isNotEmpty) {
      int prev =
          (_currentWorkPage - 1 + ourWorkVideos.length) % ourWorkVideos.length;
      _workPageController.animateToPage(prev,
          duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    }
  }

  void _initializeVideo() {
    try {
      _videoController = VideoPlayerController.asset('assets/videos/video.mp4');
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
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _videoError = true);
    }
  }

  void _checkAndControlVideoPlayback() {
    if (!mounted || _videoError) return;
    if (_videoController.value.isInitialized &&
        !_videoController.value.isPlaying) {
      try {
        _videoController.play();
      } catch (_) {}
    }
  }

  @override
  void dispose() {
    _stopAutoScroll();
    _stopWorkAutoScroll();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _videoController.dispose();
    _clientPageController.dispose();
    _workPageController.dispose();
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

  // ============================================================
  // BUILD
  // ============================================================
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth >= Breakpoints.tablet;
    final bool isLargeDesktop = screenWidth >= Breakpoints.desktop;

    return Scaffold(
      backgroundColor: theme.bg,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: _buildAppBar(screenWidth, isDesktop),
      ),
      endDrawer: _buildEndDrawer(screenWidth, isDesktop),
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 1. HERO
          SliverToBoxAdapter(
            child: _buildHeroBanner(screenWidth, isDesktop, isLargeDesktop),
          ),
          // 2. STAT TICKER (Spettro-style)
          SliverToBoxAdapter(child: _buildStatTicker()),
          // 3. ABOUT + VIDEO
          SliverToBoxAdapter(
            child: _buildAboutVideoSection(screenWidth, isDesktop),
          ),
          // 4. STATS SECTION
          SliverToBoxAdapter(
            child: StatsSection(
              key: _statsKey,
              isDesktop: isDesktop,
              isDark: _isDarkMode,
            ),
          ),
          // 5. PROCESS
          SliverToBoxAdapter(
            child: _buildProcessSection(screenWidth, isDesktop),
          ),
          // 6. CLIENT LOGOS
          SliverToBoxAdapter(child: _clientLogo(screenWidth)),
          // 7. OUR WORK
          SliverToBoxAdapter(child: _buildOurWorkSection(context, screenWidth)),
          // 8. FAQ
          SliverToBoxAdapter(child: _buildFaqSection(screenWidth, isDesktop)),
          // 9. CTA BANNER
          SliverToBoxAdapter(child: _buildCtaBanner(screenWidth, isDesktop)),
          // 10. FOOTER
          SliverToBoxAdapter(child: _buildFooter(context)),
        ],
      ),
    );
  }

  // ============================================================
  // APP BAR (Spettro-style top nav)
  // ============================================================
  PreferredSizeWidget _buildAppBar(double screenWidth, bool isDesktop) {
    final bool isScrolled = _scrollOffset > 30;
    return PreferredSize(
      preferredSize: const Size.fromHeight(80),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: theme.bgAlt.withOpacity(isScrolled ? 0.95 : 0.85),
          border: Border(
            bottom: BorderSide(
              color: theme.border,
              width: 1,
            ),
          ),
          boxShadow: isScrolled
              ? [
            BoxShadow(
              color: GSTheme.accentGold.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ]
              : null,
        ),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(flex: 3, child: _buildLogoHeader()),
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
                                    builder: (_) => const HomePage()),
                              );
                            }),
                            _buildNavButton("ABOUT", 1, () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const About()),
                              );
                            }),
                            _buildNavButton("CLIENTS", 2, () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const ClientLogoPage()),
                              );
                            }),
                            _buildNavButton("SERVICES", 3, () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const Services()),
                              );
                            }),
                            _buildNavButton("REVIEWS", 4, () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => Reviews()),
                              );
                            }),
                            const SizedBox(width: 8),
                            // Theme toggle
                            _buildThemeToggle(),
                            const SizedBox(width: 8),
                            _buildBookCallButton(),
                          ],
                        ),
                      ),
                    )
                  else
                    Row(
                      children: [
                        _buildThemeToggle(),
                        const SizedBox(width: 8),
                        Builder(
                          builder: (context) => Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(50),
                              onTap: () =>
                                  Scaffold.of(context).openEndDrawer(),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: GSTheme.accentGold.withOpacity(0.12),
                                  border: Border.all(
                                    color: GSTheme.accentGold.withOpacity(0.7),
                                    width: 1.2,
                                  ),
                                ),
                                child: const Icon(Icons.menu_rounded,
                                    color: GSTheme.accentGold, size: 22),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThemeToggle() {
    return _HoverScale(
      scale: 1.08,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: () => setState(() => _isDarkMode = !_isDarkMode),
          child: Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: GSTheme.accentCyan.withOpacity(0.14),
              border: Border.all(
                color: GSTheme.accentCyan.withOpacity(0.6),
                width: 1.2,
              ),
            ),
            child: Icon(
              _isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              color: GSTheme.accentCyan,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBookCallButton() {
    return _HoverScale(
      scale: 1.05,
      child: Container(
        decoration: BoxDecoration(
          color: GSTheme.accentGold,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: GSTheme.accentGold.withOpacity(0.3),
              blurRadius: 12,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const Contact()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "BOOK A CALL",
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0A1F44),
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.arrow_outward_rounded,
                      size: 13, color: Color(0xFF0A1F44)),
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
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 12.5,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected
                    ? GSTheme.accentGold
                    : theme.textSoft,
                letterSpacing: 0.6,
              ),
            ),
            const SizedBox(height: 2),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 2,
              width: isSelected ? 20 : 0,
              decoration: BoxDecoration(
                color: GSTheme.accentGold,
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
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
            ),
            child: Container(
              height: 48,
              width: 48,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    GSTheme.accentGold.withOpacity(0.25),
                    GSTheme.accentGoldDeep.withOpacity(0.10),
                  ],
                ),
                border: Border.all(
                  color: GSTheme.accentGold.withOpacity(0.7),
                  width: 1.2,
                ),
              ),
              child: ClipOval(
                child: Image.asset(
                  "assets/photos/logo.png",
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.broken_image,
                    color: GSTheme.accentGold,
                    size: 22,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [
                  GSTheme.accentGoldSoft,
                  GSTheme.accentGold,
                  GSTheme.accentGoldDeep,
                ],
              ).createShader(bounds),
              child: Text(
                "GROW SOCIALEE",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 1.2,
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
      backgroundColor: theme.bgAlt,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding:
              const EdgeInsets.symmetric(vertical: 28.0, horizontal: 16.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.bgAlt,
                    theme.glass,
                  ],
                ),
              ),
              child: Center(
                child: Text(
                  "GROW SOCIALEE",
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: GSTheme.accentGold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
            Divider(
                height: 1,
                thickness: 1,
                color: GSTheme.accentGold.withOpacity(0.4)),
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
                      Navigator.pop(context);
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) => const HomePage()));
                    },
                  ),
                  _buildDrawerItem(
                    index: 1,
                    icon: Icons.info_outline_rounded,
                    label: "ABOUT",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const About()));
                    },
                  ),
                  _buildDrawerItem(
                    index: 2,
                    icon: Icons.group_outlined,
                    label: "CLIENTS",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ClientLogoPage()));
                    },
                  ),
                  _buildDrawerItem(
                    index: 3,
                    icon: Icons.task_alt_outlined,
                    label: "SERVICES",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const Services()));
                    },
                  ),
                  _buildDrawerItem(
                    index: 4,
                    icon: Icons.chat_bubble_outline_rounded,
                    label: "REVIEWS",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => Reviews()));
                    },
                  ),
                  _buildDrawerItem(
                    index: 5,
                    icon: Icons.contact_phone_sharp,
                    label: "CONTACT US",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const Contact()));
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
                    GSTheme.accentGoldSoft,
                    GSTheme.accentGold,
                    GSTheme.accentGoldDeep,
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
                  GSTheme.accentGoldSoft,
                  GSTheme.accentGold,
                  GSTheme.accentGoldDeep,
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
                    isSelected ? const Color(0xFF0A1F44) : theme.textSoft),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color:
                      isSelected ? const Color(0xFF0A1F44) : theme.textSoft,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.arrow_forward_ios_rounded,
                      size: 14, color: Color(0xFF0A1F44)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HERO BANNER — Spettro-style bold typography
  // ============================================================
  Widget _buildHeroBanner(
      double screenWidth, bool isDesktop, bool isLargeDesktop) {
    final double heroPaddingV = isLargeDesktop ? 60 : isDesktop ? 50 : 36;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: theme.isDark
              ? [
            const Color(0xFF061733),
            const Color(0xFF0A1F44),
            const Color(0xFF050B1A),
          ]
              : [
            const Color(0xFFEEF3FA),
            const Color(0xFFF7F9FC),
            const Color(0xFFFFFFFF),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Floating orbs
          ..._buildFloatingOrbs(),
          // Radial gold glow
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 340,
              height: 340,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    GSTheme.accentGold
                        .withOpacity(theme.isDark ? 0.10 : 0.14),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Cyan glow left
          Positioned(
            bottom: -80,
            left: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    GSTheme.accentCyan
                        .withOpacity(theme.isDark ? 0.08 : 0.10),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // BG image faint
          Positioned.fill(
            child: Opacity(
              opacity: theme.isDark ? 0.06 : 0.04,
              child: Image.asset(
                "assets/photos/image.png",
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox(),
              ),
            ),
          ),
          // Content
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: heroPaddingV,
              horizontal:
              isLargeDesktop ? 80 : isDesktop ? 50 : 22,
            ),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1280),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Breadcrumb + EST. tag
                    _buildBreadcrumbRow(),
                    const SizedBox(height: 22),
                    // Main headline (Spettro-style)
                    _buildHeroHeadline(isDesktop),
                    const SizedBox(height: 22),
                    // Description
                    _buildHeroDescription(isDesktop),
                    const SizedBox(height: 30),
                    // CTAs
                    _buildHeroActions(isDesktop),
                    const SizedBox(height: 40),
                    // Live session ticker hint (small)
                    _buildHeroMiniTicker(isDesktop),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreadcrumbRow() {
    return Row(
      children: [
        Text(
          "HOME",
          style: GoogleFonts.inter(
            fontSize: 10.5,
            fontWeight: FontWeight.w700,
            color: theme.textMuted,
            letterSpacing: 1.5,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text("/",
              style: GoogleFonts.inter(
                  fontSize: 10.5, color: theme.textMuted)),
        ),
        Text(
          "EST. 2013 · BHAVNAGAR",
          style: GoogleFonts.inter(
            fontSize: 10.5,
            fontWeight: FontWeight.w700,
            color: GSTheme.accentCyan,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildHeroHeadline(bool isDesktop) {
    final double size = isDesktop ? 62 : 34;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "WE GROW",
          style: GoogleFonts.inter(
            fontSize: size,
            fontWeight: FontWeight.w900,
            color: theme.textPrimary,
            height: 1.02,
            letterSpacing: -2,
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Text(
                "BRANDS THAT ",
                style: GoogleFonts.inter(
                  fontSize: size,
                  fontWeight: FontWeight.w900,
                  color: theme.textPrimary,
                  height: 1.02,
                  letterSpacing: -2,
                ),
              ),
            ),
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [
                  GSTheme.accentGoldSoft,
                  GSTheme.accentGold,
                  GSTheme.accentGoldDeep,
                ],
              ).createShader(bounds),
              child: Text(
                "STAND OUT.",
                style: GoogleFonts.inter(
                  fontSize: size,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  height: 1.02,
                  letterSpacing: -2,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeroDescription(bool isDesktop) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 780),
      child: RichText(
        text: TextSpan(
          style: GoogleFonts.inter(
            fontSize: isDesktop ? 16 : 14,
            height: 1.6,
            color: theme.textMuted,
            fontWeight: FontWeight.w400,
          ),
          children: [
            TextSpan(
              text: "Grow Socialee ",
              style: GoogleFonts.inter(
                fontSize: isDesktop ? 16 : 14,
                fontWeight: FontWeight.w800,
                color: theme.textPrimary,
                height: 1.6,
              ),
            ),
            const TextSpan(
              text:
              "started with one belief: attention is the most valuable currency online — and most brands are invisible. ",
            ),
            TextSpan(
              text: "12 years later, 500+ brands ",
              style: GoogleFonts.inter(
                fontSize: isDesktop ? 16 : 14,
                fontWeight: FontWeight.w700,
                color: GSTheme.accentGold,
                height: 1.6,
              ),
            ),
            const TextSpan(
              text:
              "across India trust our in-house team to make them impossible to scroll past.",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroActions(bool isDesktop) {
    return Wrap(
      spacing: 14,
      runSpacing: 12,
      children: [
        _buildBookCallButtonLarge(),
        _buildGlassOutlineButton(
          icon: Icons.grid_view_rounded,
          label: "See Our Services",
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const Services()));
          },
        ),
      ],
    );
  }

  Widget _buildBookCallButtonLarge() {
    return _HoverScale(
      scale: 1.04,
      child: Container(
        decoration: BoxDecoration(
          color: GSTheme.accentGold,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: GSTheme.accentGold.withOpacity(0.30),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(50),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const Contact()));
            },
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.rocket_launch_rounded,
                      size: 16, color: Color(0xFF0A1F44)),
                  const SizedBox(width: 8),
                  Text(
                    "BOOK A FREE STRATEGY CALL",
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0A1F44),
                      letterSpacing: 1.0,
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

  Widget _buildGlassOutlineButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return _HoverScale(
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          foregroundColor: theme.textPrimary,
          backgroundColor: theme.surfaceOverlay,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          side: BorderSide(
            color: GSTheme.accentCyan.withOpacity(0.8),
            width: 1.4,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        icon: Icon(icon, size: 15, color: GSTheme.accentCyan),
        label: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
          ),
        ),
        onPressed: onTap,
      ),
    );
  }

  Widget _buildHeroMiniTicker(bool isDesktop) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: theme.surfaceOverlay,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: GSTheme.accentCyan.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: GSTheme.accentPink,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            isDesktop
                ? "live · 500+ brands scaled · 25,000+ reels produced"
                : "live · 500+ brands · 25K+ reels",
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: theme.textMuted,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STAT TICKER (Spettro-style infinite marquee)
  // ============================================================
  Widget _buildStatTicker() {
    final items = [
      "1 BILLION+ TOTAL REACH",
      "500+ BRANDS SERVED",
      "25,000+ REELS PRODUCED",
      "3,450+ SHOOTS DONE",
      "10 CRORE+ AD SPEND MANAGED",
      "12+ YEARS IN THE GAME",
      "24 SERVICES IN-HOUSE",
    ];
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: theme.isDark ? const Color(0xFF050B1A) : const Color(0xFF0A1F44),
        border: Border(
          top: BorderSide(color: GSTheme.accentGold.withOpacity(0.2)),
          bottom: BorderSide(color: GSTheme.accentGold.withOpacity(0.2)),
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length * 6,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final item = items[index % items.length];
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: GSTheme.accentGold,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    item,
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      color: Colors.white.withOpacity(0.9),
                      letterSpacing: 2.0,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // FLOATING ORBS
  // ============================================================
  List<Widget> _buildFloatingOrbs() {
    return [
      AnimatedBuilder(
        animation: _orbController,
        builder: (context, _) {
          final t = _orbController.value * 2 * math.pi;
          return Positioned(
            top: 100 + math.sin(t) * 30,
            left: 40 + math.cos(t) * 20,
            child: _orb(140, GSTheme.accentCyan.withOpacity(0.10)),
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
            child: _orb(180, GSTheme.accentGold.withOpacity(0.08)),
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

  // ============================================================
  // ABOUT + VIDEO SECTION
  // ============================================================
  Widget _buildAboutVideoSection(double screenWidth, bool isDesktop) {
    return Container(
      color: theme.bg,
      padding: EdgeInsets.symmetric(
        vertical: 70,
        horizontal: isDesktop ? 60 : 20,
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: isDesktop
              ? Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: _buildDirectVideoPlayer(context)),
              const SizedBox(width: 60),
              Expanded(child: _buildAgencyDescription()),
            ],
          )
              : Column(
            children: [
              _buildDirectVideoPlayer(context),
              const SizedBox(height: 40),
              _buildAgencyDescription(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDirectVideoPlayer(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;
    final bool isDesktop = deviceSize.width >= Breakpoints.tablet;

    final double playerWidth = isDesktop
        ? (deviceSize.width * 0.22).clamp(260.0, 340.0)
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
              Positioned(
                left: 0,
                bottom: 0,
                child: Container(
                  width: playerWidth * 0.8,
                  height: playerHeight * 0.5,
                  decoration: BoxDecoration(
                    color: GSTheme.accentCyan.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: GSTheme.accentCyan.withOpacity(0.18),
                        blurRadius: 24,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
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
                        GSTheme.accentGold.withOpacity(0.18),
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
                        color: GSTheme.accentGold.withOpacity(0.7),
                        width: 1.6,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: GSTheme.accentCyan.withOpacity(0.22),
                          blurRadius: 20,
                          spreadRadius: 1,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        children: [
                          !_videoError
                              ? AspectRatio(
                            aspectRatio:
                            _videoController.value.isInitialized
                                ? _videoController.value.aspectRatio
                                : (9 / 16),
                            child: VideoPlayer(_videoController),
                          )
                              : Container(
                            color: theme.glass,
                            child: Center(
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.videocam_off,
                                      color: theme.textMuted, size: 40),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Video unsupported",
                                    style: GoogleFonts.inter(
                                      color: theme.textMuted,
                                      fontSize: 12,
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAgencyDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSectionPill("/// ABOUT GROW SOCIALEE"),
        const SizedBox(height: 16),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [
              GSTheme.accentGoldSoft,
              GSTheme.accentGold,
              GSTheme.accentGoldDeep,
            ],
          ).createShader(bounds),
          child: Text(
            "GROW\nSOCIALEE",
            style: GoogleFonts.inter(
              fontSize: 44,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 0.98,
              letterSpacing: -1.5,
            ),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          "Grow Socialee is a creative social media and digital marketing agency based in Bhavnagar, Gujarat. "
              "We help brands build a strong digital presence through strategy, content, branding, and social media marketing.",
          style: GoogleFonts.inter(
            fontSize: 14.5,
            color: theme.textMuted,
            height: 1.7,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          "Our team of creative and digital professionals works with businesses across India and international markets. "
              "From content creation and social media management to SEO and web development, we offer end-to-end digital solutions.",
          style: GoogleFonts.inter(
            fontSize: 14.5,
            color: theme.textMuted,
            height: 1.7,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Container(
              width: 4,
              height: 40,
              decoration: BoxDecoration(
                color: GSTheme.accentGold,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                "We turn ideas into meaningful content, stronger brands, and measurable digital growth.",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: theme.textSoft,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 26),
        _buildBookCallButtonLarge(),
      ],
    );
  }

  // ============================================================
  // PROCESS SECTION
  // ============================================================
  Widget _buildProcessSection(double screenWidth, bool isDesktop) {
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
      color: theme.bgAlt,
      padding: EdgeInsets.symmetric(
          vertical: 80, horizontal: isDesktop ? 60 : 20),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              _buildSectionPill("/// OUR METHODOLOGY"),
              const SizedBox(height: 16),
              Text(
                "A Clearer Way to Build & Scale",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: isDesktop ? 40 : 26,
                  fontWeight: FontWeight.w900,
                  color: theme.textPrimary,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 44),
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
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: GSTheme.accentCyan.withOpacity(0.3),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(theme.isDark ? 0.3 : 0.05),
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
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [
                        GSTheme.accentGoldSoft,
                        GSTheme.accentGoldDeep,
                      ],
                    ).createShader(bounds),
                    child: Text(
                      s["step"]!,
                      style: GoogleFonts.inter(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -1,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: GSTheme.accentGold.withOpacity(0.12),
                      border: Border.all(
                        color: GSTheme.accentGold.withOpacity(0.5),
                      ),
                    ),
                    child: const Icon(Icons.arrow_outward_rounded,
                        color: GSTheme.accentGold, size: 14),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                s["title"]!,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: theme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                s["desc"]!,
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  color: theme.textMuted,
                  height: 1.55,
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
  Widget _buildFaqSection(double screenWidth, bool isDesktop) {
    return Container(
      color: theme.bg,
      padding: EdgeInsets.symmetric(
          vertical: 80, horizontal: isDesktop ? 60 : 20),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            children: [
              _buildSectionPill("/// QUESTIONS ANSWERED"),
              const SizedBox(height: 14),
              Text(
                "Frequently Asked Questions",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: isDesktop ? 40 : 26,
                  fontWeight: FontWeight.w900,
                  color: theme.textPrimary,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 40),
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
                      color: theme.card,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isExpanded
                            ? GSTheme.accentGold
                            : theme.border,
                        width: 1.4,
                      ),
                      boxShadow: isExpanded
                          ? [
                        BoxShadow(
                          color:
                          GSTheme.accentGold.withOpacity(0.10),
                          blurRadius: 12,
                        ),
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
                        iconColor: GSTheme.accentGold,
                        collapsedIconColor: GSTheme.accentCyan,
                        title: Text(
                          faq["question"]!,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: theme.textPrimary,
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
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: theme.textMuted,
                                  height: 1.65,
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
  // CTA BANNER (Spettro-style end CTA)
  // ============================================================
  Widget _buildCtaBanner(double screenWidth, bool isDesktop) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: isDesktop ? 90 : 60, horizontal: isDesktop ? 60 : 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: theme.isDark
              ? [
            const Color(0xFF050B1A),
            const Color(0xFF0A1F44),
            const Color(0xFF050B1A),
          ]
              : [
            const Color(0xFF0A1F44),
            const Color(0xFF0D2551),
          ],
        ),
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            children: [
              _buildSectionPill("/// THE PART WHERE WE DO THE THING",
                  isCyan: true),
              const SizedBox(height: 22),
              Text(
                "Your brand belongs on\nthat wall.",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: isDesktop ? 54 : 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  height: 1.05,
                  letterSpacing: -1.5,
                ),
              ),
              const SizedBox(height: 26),
              _buildBookCallButtonLarge(),
              const SizedBox(height: 18),
              Text(
                "no deck · no jargon · 20 minutes · reply within 1 working day",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  color: Colors.white.withOpacity(0.6),
                  letterSpacing: 0.5,
                ),
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
    final color = isCyan ? GSTheme.accentCyan : GSTheme.accentGold;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: color,
          letterSpacing: 1.8,
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
          padding: const EdgeInsets.symmetric(vertical: 70.0, horizontal: 20.0),
          color: theme.bgAlt,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildSectionPill("/// THE BRAND WALL"),
              const SizedBox(height: 16),
              Text(
                "The big names trust us.",
                style: GoogleFonts.inter(
                  fontSize: w > 900 ? 38 : 26,
                  fontWeight: FontWeight.w900,
                  color: theme.textPrimary,
                  letterSpacing: -1,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                "T-Series to Sun Pharma — the heavyweights on our roster.\nAnd behind them, 500+ more brands of every size.",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14.5,
                  color: theme.textMuted,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 40),
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
                                      ? LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: theme.isDark
                                        ? [
                                      const Color(0xFF0D2551),
                                      const Color(0xFF13315C),
                                    ]
                                        : [
                                      const Color(0xFF0A1F44),
                                      const Color(0xFF0D2551),
                                    ],
                                  )
                                      : LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.white.withOpacity(
                                          theme.isDark ? 0.95 : 1.0),
                                      Colors.white.withOpacity(
                                          theme.isDark ? 0.85 : 0.98),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: isWhiteLogo
                                        ? GSTheme.accentGold.withOpacity(0.55)
                                        : GSTheme.accentCyan.withOpacity(0.35),
                                    width: 1.2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: isWhiteLogo
                                          ? GSTheme.accentGold
                                          .withOpacity(0.10)
                                          : GSTheme.accentCyan
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
                                    errorBuilder: (_, __, ___) => const Icon(
                                        Icons.broken_image_outlined,
                                        color: Colors.grey),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        left: 0,
                        child: Material(
                          color: GSTheme.accentGold,
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
                                color: Color(0xFF0A1F44),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        child: Material(
                          color: GSTheme.accentGold,
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
                                color: Color(0xFF0A1F44),
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
                            GSTheme.accentGoldSoft,
                            GSTheme.accentGoldDeep,
                          ],
                        )
                            : null,
                        color: _currentLogoPage == index
                            ? null
                            : theme.textMuted.withOpacity(0.3),
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
  // OUR WORK SECTION
  // ============================================================
  Widget _buildOurWorkSection(BuildContext context, double screenWidth) {
    final bool isDesktop = screenWidth >= Breakpoints.tablet;
    final double horizontal = isDesktop ? 60 : 20;

    return Container(
      width: double.infinity,
      color: theme.bg,
      padding: EdgeInsets.symmetric(vertical: 70.0, horizontal: horizontal),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: Column(
            children: [
              _buildSectionPill("/// SELECTED WORK"),
              const SizedBox(height: 16),
              Text(
                "What We've Built",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: screenWidth > 900 ? 40 : 26,
                  fontWeight: FontWeight.w900,
                  color: theme.textPrimary,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Creative showcases & production reels from Video 2 to Video 13.",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14.5,
                  color: theme.textMuted,
                ),
              ),
              const SizedBox(height: 40),
              LayoutBuilder(
                builder: (context, constraints) {
                  final double w = constraints.maxWidth;
                  double viewportFraction;

                  if (w > 1200) {
                    viewportFraction = 0.22;
                  } else if (w > 900) {
                    viewportFraction = 0.30;
                  } else if (w > 600) {
                    viewportFraction = 0.45;
                  } else {
                    viewportFraction = 0.75;
                  }

                  if (_workPageController.viewportFraction !=
                      viewportFraction) {
                    final int currentPage =
                    _workPageController.hasClients &&
                        _workPageController.page != null
                        ? _workPageController.page!.round()
                        : _currentWorkPage;
                    _workPageController = PageController(
                      initialPage: currentPage,
                      viewportFraction: viewportFraction,
                    );
                  }

                  return MouseRegion(
                    onEnter: (_) => _stopWorkAutoScroll(),
                    onExit: (_) => _startWorkAutoScroll(),
                    child: SizedBox(
                      height: 440,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          NotificationListener<ScrollNotification>(
                            onNotification:
                                (ScrollNotification notification) {
                              if (notification is ScrollStartNotification) {
                                _stopWorkAutoScroll();
                              } else if (notification
                              is ScrollEndNotification) {
                                _startWorkAutoScroll();
                              }
                              return false;
                            },
                            child: PageView.builder(
                              controller: _workPageController,
                              onPageChanged: (int index) {
                                if (mounted) {
                                  setState(() => _currentWorkPage = index);
                                }
                              },
                              itemCount: ourWorkVideos.length,
                              itemBuilder: (context, index) {
                                final item = ourWorkVideos[index];
                                return AnimatedBuilder(
                                  animation: _workPageController,
                                  builder: (context, child) {
                                    double value = 1.0;
                                    if (_workPageController
                                        .position.haveDimensions) {
                                      value = (_workPageController.page! -
                                          index);
                                      value = (1 - (value.abs() * 0.10))
                                          .clamp(0.90, 1.0);
                                    }
                                    return Center(
                                      child: Transform.scale(
                                        scale: value,
                                        child: child,
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: _OurWorkVideoCard(
                                      videoPath: item["path"]!,
                                      title: item["title"]!,
                                      theme: theme,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Positioned(
                            left: 0,
                            child: Material(
                              color: GSTheme.accentGold,
                              shape: const CircleBorder(),
                              elevation: 4,
                              child: InkWell(
                                onTap: _previousWorkPage,
                                customBorder: const CircleBorder(),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  child: const Icon(
                                    Icons.arrow_back_ios_rounded,
                                    size: 16,
                                    color: Color(0xFF0A1F44),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            child: Material(
                              color: GSTheme.accentGold,
                              shape: const CircleBorder(),
                              elevation: 4,
                              child: InkWell(
                                onTap: _nextWorkPage,
                                customBorder: const CircleBorder(),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  child: const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 16,
                                    color: Color(0xFF0A1F44),
                                  ),
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
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    ourWorkVideos.length,
                        (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: _currentWorkPage == index ? 18 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        gradient: _currentWorkPage == index
                            ? const LinearGradient(
                          colors: [
                            GSTheme.accentGoldSoft,
                            GSTheme.accentGoldDeep,
                          ],
                        )
                            : null,
                        color: _currentWorkPage == index
                            ? null
                            : theme.textMuted.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(3),
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

  // ============================================================
  // FOOTER
  // ============================================================
  Widget _buildFooter(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth > 800;

    return Container(
      width: double.infinity,
      color: theme.isDark ? const Color(0xFF030814) : const Color(0xFF0A1F44),
      child: Column(
        children: [
          Divider(
              height: 1,
              thickness: 1,
              color: GSTheme.accentGold.withOpacity(0.3)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: isDesktop
                    ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: _buildFooterBrandSection()),
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
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: GSTheme.accentGold.withOpacity(0.2),
                ),
              ),
            ),
            child: Center(
              child: Text(
                "© ${DateTime.now().year} Grow Socialee. All rights reserved.",
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.5),
                  letterSpacing: 0.5,
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
            Container(
              height: 50,
              width: 50,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    GSTheme.accentGold.withOpacity(0.25),
                    GSTheme.accentGoldDeep.withOpacity(0.10),
                  ],
                ),
                border: Border.all(
                  color: GSTheme.accentGold.withOpacity(0.7),
                  width: 1.2,
                ),
              ),
              child: ClipOval(
                child: Image.asset(
                  "assets/photos/logo.png",
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.broken_image,
                    color: GSTheme.accentGold,
                    size: 24,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [
                  GSTheme.accentGoldSoft,
                  GSTheme.accentGold,
                  GSTheme.accentGoldDeep,
                ],
              ).createShader(bounds),
              child: Text(
                "GROW SOCIALEE",
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          "Empowering businesses through digital strategies, branding, video production, and social media solutions.",
          style: GoogleFonts.inter(
            fontSize: 13.5,
            color: Colors.white.withOpacity(0.6),
            height: 1.65,
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
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: GSTheme.accentGold,
            letterSpacing: 2.0,
          ),
        ),
        const SizedBox(height: 18),
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
            Icon(icon, size: 18, color: GSTheme.accentGold),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                maxLines: isMultiLine ? 3 : 1,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.85),
                  height: 1.5,
                  fontWeight: FontWeight.w500,
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
          "CONNECT",
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: GSTheme.accentGold,
            letterSpacing: 2.0,
          ),
        ),
        const SizedBox(height: 18),
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
        border: Border.all(color: GSTheme.accentGold.withOpacity(0.6)),
        boxShadow: [
          BoxShadow(
            color: GSTheme.accentGold.withOpacity(0.10),
            blurRadius: 8,
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, size: 18, color: GSTheme.accentGold),
        onPressed: () => _launchUrlString(url),
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

// ============================================================
// OUR WORK VIDEO CARD
// ============================================================
class _OurWorkVideoCard extends StatefulWidget {
  final String videoPath;
  final String title;
  final GSTheme theme;

  const _OurWorkVideoCard({
    required this.videoPath,
    required this.title,
    required this.theme,
  });

  @override
  State<_OurWorkVideoCard> createState() => _OurWorkVideoCardState();
}

class _OurWorkVideoCardState extends State<_OurWorkVideoCard> {
  late VideoPlayerController _controller;
  bool _hasError = false;
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _initVideoFast();
  }

  Future<void> _initVideoFast() async {
    try {
      _controller = VideoPlayerController.asset(widget.videoPath);
      _controller.setLooping(true);
      _controller.setVolume(0.0);
      await _controller.initialize();
      if (!mounted) return;
      setState(() => _isReady = true);
      _controller.play();
    } catch (err) {
      if (!mounted) return;
      setState(() => _hasError = true);
    }
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
        width: double.infinity,
        decoration: BoxDecoration(
          color: widget.theme.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: GSTheme.accentGold.withOpacity(0.5),
            width: 1.4,
          ),
          boxShadow: [
            BoxShadow(
              color: GSTheme.accentCyan.withOpacity(0.10),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(16)),
                child: !_hasError && _isReady
                    ? Stack(
                  fit: StackFit.expand,
                  alignment: Alignment.center,
                  children: [
                    FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _controller.value.size.width,
                        height: _controller.value.size.height,
                        child: VideoPlayer(_controller),
                      ),
                    ),
                  ],
                )
                    : Container(
                  color: widget.theme.glass,
                  child: const Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: GSTheme.accentGold,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 55,
              padding:
              const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
              alignment: Alignment.center,
              child: Text(
                widget.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: GSTheme.accentGold,
                  letterSpacing: 0.5,
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
// STATS SECTION
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
  final bool isDark;

  const StatsSection({
    super.key,
    required this.isDesktop,
    required this.isDark,
  });

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

  GSTheme get theme => GSTheme(isDark: widget.isDark);

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
    _autoScrollTimer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
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
      color: theme.bgAlt,
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
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        decoration: BoxDecoration(
          color: theme.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: GSTheme.accentGold.withOpacity(0.6),
            width: 1.4,
          ),
          boxShadow: [
            BoxShadow(
              color: GSTheme.accentCyan.withOpacity(0.10),
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
                  GSTheme.accentGoldSoft,
                  GSTheme.accentGold,
                  GSTheme.accentGoldDeep,
                ],
              ).createShader(bounds),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "$formattedValue${item.suffix}",
                  style: GoogleFonts.inter(
                    fontSize: widget.isDesktop ? 36 : 26,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1.0,
                    letterSpacing: -1,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              item.label.toUpperCase(),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: widget.isDesktop ? 10.5 : 9.5,
                fontWeight: FontWeight.w700,
                color: theme.textMuted,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}