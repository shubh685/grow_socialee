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
        color: isWhiteLogo ? const Color(0xFF2C3E50) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isWhiteLogo ? Colors.transparent : const Color(0xFFF06292),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF06292).withOpacity(0.15),
            blurRadius: 12,
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
      viewportFraction: 0.18,
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
    }
  }

  void _checkAndControlVideoPlayback() {
    if (!mounted || !_isVideoInitialized || _videoError) return;
    if (!_videoController.value.isPlaying) {
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
    if (!controller.value.isInitialized) return;

    showDialog(
      context: context,
      builder: (context) {
        final Size deviceSize = MediaQuery.of(context).size;
        return Dialog(
          backgroundColor: Colors.transparent,
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
                      aspectRatio: controller.value.aspectRatio,
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
      backgroundColor: Colors.grey[100],
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
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              width: screenWidth,
              child: Image.asset(
                "assets/photos/image.png",
                width: screenWidth,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: const Center(
                    child:
                    Icon(Icons.broken_image, size: 50, color: Colors.grey),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: 40,
                horizontal: isDesktop ? 60 : 20,
              ),
              child: isDesktop
                  ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: _buildDirectVideoPlayer(context)),
                  const SizedBox(width: 40),
                  Expanded(child: _buildAgencyDescription()),
                ],
              )
                  : Column(
                children: [
                  _buildDirectVideoPlayer(context),
                  const SizedBox(height: 30),
                  _buildAgencyDescription(),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: _clientLogo(),
          ),

          SliverToBoxAdapter(
            child: _buildOurWorkSection(context),
          ),

          SliverToBoxAdapter(
            child: _buildFooter(context),
          ),
        ],
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
          width: playerWidth + 40,
          height: playerHeight + 40,
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
                    color: Colors.blue.shade600,
                    borderRadius: BorderRadius.circular(16),
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
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _isVideoInitialized && !_videoError
                        ? AspectRatio(
                      aspectRatio: _videoController.value.aspectRatio,
                      child: VideoPlayer(_videoController),
                    )
                        : Container(
                      color: Colors.grey[200],
                      child: Center(
                        child: _videoError
                            ? Column(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.videocam_off, color: Colors.grey, size: 40),
                            SizedBox(height: 8),
                            Text("Video format unsupported", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        )
                            : const SizedBox.shrink(),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Grow Socialee – The Best Social Media Marketing Agency in Bhavnagar",
            textAlign: TextAlign.justify,
            style: GoogleFonts.radley(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.indigo.shade900,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "We are Grow Socialee, a top social media marketing agency in Bhavnagar, helping small and medium-sized businesses boost their online presence. In today’s digital world, standing out is essential, and we simplify that process for you.",
            textAlign: TextAlign.justify, style: GoogleFonts.radley(fontSize: 16.2, fontWeight: FontWeight.w400, color: Colors.black87, height: 1.6),
          ),
          const SizedBox(height: 16),
          Text(
            "As the best digital marketing agency in Bhavnagar, we specialize in branding, content creation, social media management, and digital advertising. Need engaging video content? We are also the best video editing company in Bhavnagar, crafting eye-catching visuals for your brand.",
            textAlign: TextAlign.justify, style: GoogleFonts.radley(fontSize: 16.2, color: Colors.black87, height: 1.6),
          ),
          const SizedBox(height: 16),
          Text(
            "Let’s build your digital success together! 📩 Contact Grow Socialee today!",
            textAlign: TextAlign.justify,
            style: GoogleFonts.radley(fontSize: 16.2, fontWeight: FontWeight.w700, color: Colors.blue.shade800, height: 1.5),
          ),
          const SizedBox(height: 12),
          Text(
            "We understand social behaviours within online communities, cultures and subcultures.",
            textAlign: TextAlign.justify, style: GoogleFonts.radley(fontSize: 16.2, fontStyle: FontStyle.italic, color: Colors.black54, height: 1.5),
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => const Contact()));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: primaryBlue,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: primaryBlue.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text("Get in Touch", style: GoogleFonts.radley(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoHeader() {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          SizedBox(
            height: 55,
            child: Image.asset(
              "assets/photos/Gro_Soc_Image.png",
              color: bgWhite,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.business,
                color: bgWhite,
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
                    style: GoogleFonts.plusJakartaSans(
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

  Widget _clientLogo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
      decoration: BoxDecoration(
        color: bgWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
              "Brands We’re Proud Of", style: GoogleFonts.radley(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.indigo.shade900, letterSpacing: 0.5)),
          const SizedBox(height: 6),
          Container(
            height: 3,
            width: 60,
            decoration: BoxDecoration(
              color: accentPink,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          MouseRegion(
            onEnter: (_) => _stopAutoScroll(),
            onExit: (_) => _startAutoScroll(),
            child: SizedBox(
              height: 150,
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
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            child: Container(
                              width: 220,
                              height: 110,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: (clientLogos[index]["isWhite"] ?? false)
                                    ? const Color(0xFF2C3E50)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: (clientLogos[index]["isWhite"] ?? false)
                                      ? Colors.transparent
                                      : Colors.grey.shade200,
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
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
                    left: 6,
                    child: Material(
                      color: Colors.white,
                      shape: const CircleBorder(),
                      elevation: 3,
                      child: InkWell(
                        onTap: _previousPage,
                        customBorder: const CircleBorder(),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: const Icon(
                            Icons.arrow_back_ios_rounded,
                            size: 14,
                            color: primaryBlue,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 6,
                    child: Material(
                      color: Colors.white,
                      shape: const CircleBorder(),
                      elevation: 3,
                      child: InkWell(
                        onTap: _nextPage,
                        customBorder: const CircleBorder(),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 14,
                            color: primaryBlue,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              clientLogos.length,
                  (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                width: _currentLogoPage == index ? 10 : 5,
                height: 5,
                decoration: BoxDecoration(
                  color: _currentLogoPage == index
                      ? accentPink
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOurWorkSection(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth > 800;

    return Container(
      width: double.infinity,
      color: Colors.grey[50],
      padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
      child: Column(
        children: [
          Text("What We’ve Built", style: GoogleFonts.radley(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.indigo.shade900, letterSpacing: 0.5)),
          const SizedBox(height: 6),
          Container(
            height: 3,
            width: 60,
            decoration: BoxDecoration(
              color: primaryBlue,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Creative showcases.",
            textAlign: TextAlign.center,
            style: GoogleFonts.radley(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 28),
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
            color: Colors.blue.shade600,
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
          style: GoogleFonts.plusJakartaSans(
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
        Text("Contact Info", style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 12),
        InkWell(
          onTap: () => _launchUrlString(googleMapsUrl),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on_outlined, size: 18, color: Colors.white70),
              const SizedBox(width: 8),
              Expanded(
                child: Text(addressQuery, style: GoogleFonts.plusJakartaSans(fontSize: 13, color: Colors.white, height: 1.4)),
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
              Text(phoneNum, style: GoogleFonts.plusJakartaSans(fontSize: 13, color: Colors.white)),
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
              Text(emailAddr, style: GoogleFonts.plusJakartaSans(fontSize: 13, color: Colors.white)),
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
        Text("Follow Us", style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
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
  bool _initialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoPath);
    _controller.setLooping(true);
    _controller.setVolume(0.0);
    _controller.initialize().then((_) {
      if (!mounted) return;
      setState(() {
        _initialized = true;
      });
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: AspectRatio(
              aspectRatio: 9 / 16,
              child: _initialized && !_hasError
                  ? GestureDetector(
                onTap: () => widget.onExpand(_controller),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    VideoPlayer(_controller),
                    Container(
                      color: Colors.black12,
                    ),
                    const Icon(
                      Icons.fullscreen,
                      color: Colors.white,
                      size: 36,
                    ),
                  ],
                ),
              )
                  : Container(
                color: Colors.grey[200],
                child: Center(
                  child: _hasError
                      ? const Icon(Icons.broken_image, color: Colors.grey)
                      : const SizedBox.shrink(),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              widget.title,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}