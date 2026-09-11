import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grow_socialee/About.dart';
import 'package:grow_socialee/Client_Logos.dart';
import 'package:grow_socialee/Services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'contact.dart';

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
        color: isWhiteLogo ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isWhiteLogo ? Colors.white10 : const Color(0xFF3B82F6),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withOpacity(0.1),
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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late VideoPlayerController _videoController;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _videoKey = GlobalKey();
  bool _isVideoInitialized = false;
  bool _videoError = false;

  late PageController _clientPageController;
  Timer? _carouselTimer;
  int _currentLogoPage = 0;
  final GlobalKey<_StatsSectionState> _statsKey = GlobalKey<_StatsSectionState>();

  // FAQ expansion states
  final List<bool> _faqExpanded = List.generate(6, (index) => false);

  final List<Map<String, dynamic>> clientLogos = [
    {"path": "assets/photos/aroma.png", "isWhite": true},
    {"path": "assets/photos/aura.png", "isWhite": false},
    {"path": "assets/photos/bani_thani.png", "isWhite": true},
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

  // Service States Data
  final List<Map<String, dynamic>> statesServed = [
    {
      "state": "Gujarat",
      "cities": "Bhavnagar, Ahmedabad, Surat, Vadodara, Rajkot",
      "clients": "15+ Brands Served",
      "icon": Icons.location_city_rounded,
    },
    {
      "state": "Maharashtra",
      "cities": "Mumbai, Pune, Nagpur, Thane",
      "clients": "8+ Brands Served",
      "icon": Icons.business_rounded,
    },
    {
      "state": "Rajasthan",
      "cities": "Jaipur, Udaipur, Jodhpur",
      "clients": "5+ Brands Served",
      "icon": Icons.fort_rounded,
    },
    {
      "state": "Delhi NCR",
      "cities": "New Delhi, Gurugram, Noida",
      "clients": "4+ Brands Served",
      "icon": Icons.account_balance_rounded,
    },
  ];

  // FAQ Data
  final List<Map<String, String>> faqs = [
    {
      "question": "How will you learn about my business?",
      "answer": "We start with a comprehensive discovery session where we dive deep into understanding your business goals, target audience, competitors, and unique value proposition. This helps us create a tailored strategy that aligns with your brand vision."
    },
    {
      "question": "What type of results can I expect?",
      "answer": "Results vary based on your industry and goals, but typically our clients see increased engagement within 30 days, follower growth within 60 days, and measurable ROI within 90 days. We set clear KPIs and track progress transparently."
    },
    {
      "question": "How will you create content that fits my business?",
      "answer": "Our creative team develops a brand style guide based on your identity, then creates content that resonates with your audience. We combine trending formats with your unique brand voice to maximize engagement."
    },
    {
      "question": "How soon should I expect to see result?",
      "answer": "While some improvements like profile optimization are immediate, meaningful growth typically takes 2-3 months. Social media success is a marathon, not a sprint - we focus on sustainable, long-term growth."
    },
    {
      "question": "How will you report and how do we know what you'll be working on?",
      "answer": "You'll receive monthly performance reports with detailed analytics, plus access to a shared content calendar. We also schedule regular check-in calls to discuss strategy and upcoming campaigns."
    },
    {
      "question": "What sorts of businesses do you work with?",
      "answer": "We work with businesses of all sizes - from local startups to established brands. Our expertise spans retail, healthcare, hospitality, education, and professional services."
    },
  ];

  // AG Modern Design Theme Colors
  static const Color darkBg = Color(0xFF0F172A);
  static const Color darkCardBg = Color(0xFF1E293B);
  static const Color accentBlue = Color(0xFF3B82F6);
  static const Color accentCyan = Color(0xFF06B6D4);
  static const Color textMuted = Color(0xFF94A3B8);

  final String addressQuery =
      "First Floor, Leela Efcee, 103, Waghawadi Rd., Hill Drive, Bhavnagar, Gujarat 364002";
  final String phoneNum = "+919408518168";
  final String emailAddr = "growsocialee@gmail.com";
  final String googleMapsUrl =
      "https://maps.google.com/?q=Leela+Efcee+Bhavnagar+Gujarat";

  final String facebookUrl = "https://www.facebook.com/growsocialeeofficial/";
  final String instagramUrl = "https://www.instagram.com/growsocialee.official/";
  final String linkedInUrl = "https://in.linkedin.com/company/grow-socialee";

  @override
  void initState() {
    super.initState();
    _initializeVideo();
    _scrollController.addListener(_onScrollCheckVideoVisibility);
    _initializeClientCarousel();
  }

  void _initializeClientCarousel() {
    _clientPageController = PageController(
      initialPage: 0,
      viewportFraction: 0.22,
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
        setState(() {
          _videoError = true;
        });
        debugPrint('Main Video initialization error: $error');
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _videoError = true;
      });
      debugPrint('Main Video initialization exception: $e');
    }
  }

  void _onScrollCheckVideoVisibility() {
    if (mounted) {
      _checkAndControlVideoPlayback();
      _statsKey.currentState?.checkVisibility();
    }
  }

  void _checkAndControlVideoPlayback() {
    if (!mounted || _videoError) return;
    if (_videoController.value.isInitialized && !_videoController.value.isPlaying) {
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
    _scrollController.removeListener(_onScrollCheckVideoVisibility);
    _scrollController.dispose();
    _videoController.dispose();
    _clientPageController.dispose();
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
    showDialog(
      context: context,
      builder: (context) {
        final Size deviceSize = MediaQuery.of(context).size;
        return Dialog(
          backgroundColor: Colors.black.withOpacity(0.9),
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
    final bool isDesktop = screenWidth > 800;

    return Scaffold(
      backgroundColor: darkBg,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75),
        child: Container(
          decoration: const BoxDecoration(
            color: darkBg,
            border: Border(bottom: BorderSide(color: Colors.white10, width: 1)),
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
                  icon: const Icon(Icons.menu_rounded, color: Colors.white, size: 28),
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
                        color: accentBlue,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
              const Divider(height: 1, thickness: 1, color: Colors.white10),
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const About()));
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
                height: 4,
                color: accentBlue,
              )
            ],
          ),
        ),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Modern Dark Hero Banner Section
          SliverToBoxAdapter(
            child: _buildAGHeroBanner(screenWidth, isDesktop),
          ),
          // Agency Overview Section
          SliverToBoxAdapter(
            child: Container(
              color: darkBg,
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
            ),
          ),
          // Animated Stats Section Card Row
          SliverToBoxAdapter(
            child: StatsSection(key: _statsKey, isDesktop: isDesktop),
          ),
          // Process / Workflow Section (AG Style)
          SliverToBoxAdapter(
            child: _buildAGProcessSection(isDesktop),
          ),
          // Client Logos Carousel
          SliverToBoxAdapter(
            child: _clientLogo(),
          ),
          // Video Showcase / Our Work
          SliverToBoxAdapter(
            child: _buildAGOurWorkSection(context),
          ),
          // FAQ Section Accordion
          SliverToBoxAdapter(
            child: _buildAGFaqSection(isDesktop),
          ),
          // Modern Footer Section
          SliverToBoxAdapter(
            child: _buildAGFooter(context),
          ),
        ],
      ),
    );
  }

  // AG Modern Hero Banner Section
  Widget _buildAGHeroBanner(double screenWidth, bool isDesktop) {
    return Container(
      width: double.infinity,
      color: darkBg,
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.15,
              child: Image.asset(
                "assets/photos/image.png",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const SizedBox(),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: isDesktop ? 120 : 70,
              horizontal: isDesktop ? 80 : 24,
            ),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 950),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: accentBlue.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: accentBlue.withOpacity(0.3)),
                      ),
                      child: Text(
                        "WE MAKE YOUR BUSINESS VISIBLE",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: accentCyan,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text("Getting your name on top is our No.1 priority.", textAlign: TextAlign.center, style: GoogleFonts.plusJakartaSans(fontSize: isDesktop ? 60 : 28, fontStyle: FontStyle.italic, fontWeight: FontWeight.w800, color: Colors.white, height: 1.15, letterSpacing: -0.5)),
                    const SizedBox(height: 20),
                    Text(
                        "We make sure you receive the attention your business deserves. We are not just a social media agency - we provide a variance of services.",
                        textAlign: TextAlign.center, style: GoogleFonts.plusJakartaSans(fontSize: isDesktop ? 18 : 15, color: textMuted, height: 1.6)),
                    const SizedBox(height: 36),
                    Wrap(
                      spacing: 16,
                      runSpacing: 14,
                      alignment: WrapAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentBlue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 20,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 8,
                            shadowColor: accentBlue.withOpacity(0.4),
                          ),
                          icon: const Icon(Icons.rocket_launch_rounded, size: 18),
                          label: Text(
                            "GET STARTED NOW",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
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
                              vertical: 20,
                            ),
                            side: const BorderSide(color: Colors.white24, width: 1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.grid_view_rounded, size: 18),
                          label: Text(
                            "EXPLORE SERVICES",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Services(),
                              ),
                            );
                          },
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

  // AG Process / Workflow Section
  Widget _buildAGProcessSection(bool isDesktop) {
    final steps = [
      {"step": "01", "title": "Define Your Vision", "desc": "We clarify your goals, audience, offer, and creative direction with clear objectives."},
      {"step": "02", "title": "Submit Your Strategy", "desc": "Share requirements and timelines through a seamless collaborative roadmap."},
      {"step": "03", "title": "Create & Refine", "desc": "We design, shoot, build, and polish with structured feedback loops."},
      {"step": "04", "title": "Project Delivery", "desc": "Your final assets and marketing campaigns go live to drive revenue."},
    ];

    return Container(
      padding: EdgeInsets.symmetric(vertical: 80, horizontal: isDesktop ? 60 : 20),
      color: darkBg,
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            children: [
              Text(
                "OUR METHODOLOGY",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: accentCyan,
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "A Clearer Way to Build & Scale",
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: isDesktop ? 32 : 24,
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
                    children: steps.map((s) {
                      double w = isDesktop
                          ? (constraints.maxWidth - 60) / 4
                          : (constraints.maxWidth - 20) / 2;
                      if (w < 220) w = constraints.maxWidth;
                      return SizedBox(
                        width: w,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: darkCardBg,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                s["step"]!,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  color: accentBlue,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                s["title"]!,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                s["desc"]!,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  color: textMuted,
                                  height: 1.5,
                                ),
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

  // FAQ Accordion Section
  Widget _buildAGFaqSection(bool isDesktop) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 80, horizontal: isDesktop ? 60 : 20),
      color: darkCardBg,
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            children: [
              Text(
                "QUESTIONS ANSWERED",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: accentBlue,
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Frequently Asked Questions",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: isDesktop ? 32 : 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
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
                      color: darkBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isExpanded ? accentBlue : Colors.white10,
                        width: 1,
                      ),
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.transparent,
                      ),
                      child: ExpansionTile(
                        key: Key('faq_$index'),
                        initiallyExpanded: isExpanded,
                        onExpansionChanged: (expanded) {
                          setState(() {
                            _faqExpanded[index] = expanded;
                          });
                        },
                        iconColor: accentCyan,
                        collapsedIconColor: textMuted,
                        title: Text(
                          faq["question"]!,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isExpanded ? Colors.white : Colors.white70,
                          ),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 16.0,
                              right: 16.0,
                              bottom: 16.0,
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                faq["answer"]!,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  color: textMuted,
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

  Widget _buildDirectVideoPlayer(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;
    final bool isDesktop = deviceSize.width > 800;

    final double playerWidth = isDesktop
        ? (deviceSize.width * 0.25).clamp(280.0, 360.0)
        : (deviceSize.width * 0.85).clamp(260.0, 340.0);
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
                    color: accentBlue.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: playerWidth,
                  height: playerHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white24, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: !_videoError
                        ? AspectRatio(
                      aspectRatio: _videoController.value.isInitialized
                          ? _videoController.value.aspectRatio
                          : (9 / 16),
                      child: VideoPlayer(_videoController),
                    )
                        : Container(
                      color: darkCardBg,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.videocam_off, color: textMuted, size: 40),
                            const SizedBox(height: 8),
                            Text("Video format unsupported",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.plusJakartaSans(color: textMuted, fontSize: 12)),
                          ],
                        ),
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
        Text(
          "ABOUT GROW SOCIALEE",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: accentCyan,
            letterSpacing: 2.0,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Grow Socialee",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 36,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "We are Grow Socialee, a top social media marketing agency in Bhavnagar, helping small and medium-sized businesses boost their online presence. In today's digital world, standing out is essential, and we simplify that process for you.",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            color: textMuted,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "As the best digital marketing agency in Bhavnagar, we specialize in branding, content creation, social media management, and digital advertising. Need engaging video content? We are also the best video editing company in Bhavnagar, crafting eye-catching visuals for your brand.",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            color: textMuted,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          "Let's build your digital success together! 📩 Contact Grow Socialee today!",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: accentBlue,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          "We understand social behaviours within online communities, cultures and subcultures.",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white70,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => const Contact()));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: accentBlue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            "Get in Touch",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogoHeader() {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          SizedBox(
            height: 50,
            child: Image.asset(
              "assets/photos/Gro_Soc_Image.png",
              color: Colors.white,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.business,
                color: Colors.white,
                size: 30,
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
              color: isSelected ? accentBlue : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              border: isSelected
                  ? null
                  : Border.all(color: Colors.white12, width: 0.5),
            ),
            child: Row(
              children: [
                Icon(icon, size: 20, color: isSelected ? Colors.white : accentCyan),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _clientLogo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60.0, horizontal: 20.0),
      color: darkBg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "TRUSTED PARTNERSHIPS",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: accentCyan,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "The Brands We're Working With",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 36),
          MouseRegion(
            onEnter: (_) => _stopAutoScroll(),
            onExit: (_) => _startAutoScroll(),
            child: SizedBox(
              height: 140,
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
                          setState(() {
                            _currentLogoPage = index;
                          });
                        }
                      },
                      itemCount: clientLogos.length,
                      itemBuilder: (context, index) {
                        return AnimatedBuilder(
                          animation: _clientPageController,
                          builder: (context, child) {
                            double value = 1.0;
                            if (_clientPageController.position.haveDimensions) {
                              value = (_clientPageController.page! - index);
                              value = (1 - (value.abs() * 0.12)).clamp(0.88, 1.0);
                            }
                            return Center(
                              child: Transform.scale(
                                scale: value,
                                child: child,
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            child: Container(
                              width: 220,
                              height: 110,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: (clientLogos[index]["isWhite"] ?? false)
                                    ? darkCardBg
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white12,
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: Image.asset(
                                  clientLogos[index]["path"]!,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image_outlined,
                                      color: Colors.grey),
                                ),
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
                      color: darkCardBg,
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
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: Material(
                      color: darkCardBg,
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
                            color: Colors.white,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              clientLogos.length,
                  (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: _currentLogoPage == index ? 14 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: _currentLogoPage == index
                      ? accentBlue
                      : Colors.white24,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAGOurWorkSection(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth > 800;

    return Container(
      width: double.infinity,
      color: darkCardBg,
      padding: const EdgeInsets.symmetric(vertical: 70.0, horizontal: 20.0),
      child: Column(
        children: [
          Text(
            "SELECTED WORK",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: accentCyan,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "What We've Built",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Creative showcases & production reels.",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              color: textMuted,
            ),
          ),
          const SizedBox(height: 36),
          LayoutBuilder(
            builder: (context, constraints) {
              return Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: ourWorkVideos.map((item) {
                  double cardWidth = isDesktop
                      ? (constraints.maxWidth - 80) / 4
                      : (screenWidth > 500
                      ? (screenWidth - 60) / 2
                      : screenWidth - 40);
                  return SizedBox(
                    width: cardWidth.clamp(240.0, 320.0),
                    child: _OurWorkVideoCard(
                      videoPath: item["path"]!,
                      title: item["title"]!,
                      onExpand: (controller) =>
                          _openZoomableVideoDialog(context, controller),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
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
          const Divider(height: 1, thickness: 1, color: Colors.white10),
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
          style: GoogleFonts.plusJakartaSans(
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
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: () => _launchUrlString(googleMapsUrl),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on_outlined, size: 18, color: accentCyan),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  addressQuery,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: textMuted,
                    height: 1.4,
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
              const Icon(Icons.phone_outlined, size: 18, color: accentCyan),
              const SizedBox(width: 10),
              Text(
                phoneNum,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: textMuted,
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
              const Icon(Icons.email_outlined, size: 18, color: accentCyan),
              const SizedBox(width: 10),
              Text(
                emailAddr,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: textMuted,
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
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
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

class _OurWorkVideoCard extends StatefulWidget {
  final String videoPath;
  final String title;
  final Function(VideoPlayerController) onExpand;

  const _OurWorkVideoCard({
    required this.videoPath,
    required this.title,
    required this.onExpand,
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
      setState(() {
        _hasError = true;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: AspectRatio(
              aspectRatio: 9 / 16,
              child: !_hasError
                  ? GestureDetector(
                onTap: () => widget.onExpand(_controller),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    VideoPlayer(_controller),
                  ],
                ),
              )
                  : Container(
                color: const Color(0xFF1E293B),
                child: const Center(
                  child: Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Text(
              widget.title,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Stats Data Model
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

// Animated Statistics Component
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
    StatData(endValue: 20, suffix: "+", label: "BRANDS SCALED"),
    StatData(endValue: 100, suffix: "+", label: "VIDEOS CREATED"),
    StatData(endValue: 99, suffix: "%", label: "CLIENT RETENTION"),
    StatData(endValue: 4.9, suffix: "★", label: "GOOGLE RATING", isDecimal: true),
    StatData(endValue: 12, suffix: "", label: "DEDICATED TEAM"),
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

      if (position.dy < screenHeight - 50 && (position.dy + renderObject.size.height) > 0) {
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
      color: _HomePageState.darkBg,
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
              return Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: List.generate(_stats.length, (index) {
                  final item = _stats[index];
                  double cardWidth = (constraints.maxWidth - (16 * (_stats.length - 1))) / _stats.length;
                  if (cardWidth < 180) cardWidth = 180;
                  return SizedBox(
                    width: cardWidth,
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return _buildStatCard(item, _animation.value);
                      },
                    ),
                  );
                }),
              );
            },
          )
              : SizedBox(
            height: 140, // Increased height to prevent overflow
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

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: _HomePageState.darkCardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white10,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              "$formattedValue${item.suffix}",
              style: GoogleFonts.plusJakartaSans(
                fontSize: widget.isDesktop ? 32 : 24,
                fontWeight: FontWeight.w800,
                color: _HomePageState.accentCyan,
                height: 1.0,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            item.label.toUpperCase(),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.plusJakartaSans(
              fontSize: widget.isDesktop ? 12 : 11,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}