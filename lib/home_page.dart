import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grow_socialee/Services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'contact.dart';

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

  // Client Logo Carousel Controllers & State
  late PageController _clientPageController;
  Timer? _carouselTimer;
  int _currentLogoPage = 0;

  // List of client logo assets - Add all client images here
  final List<String> clientLogos = [
    "assets/photos/aroma.png",
    "assets/photos/aura.png",
    "assets/photos/bani_thani.png",
    "assets/photos/bindu_decor.png",
    "assets/photos/ella.png",
    "assets/photos/every_child.png",
    "assets/photos/gayat_cate.png",
    "assets/photos/kids_connect.png",
    "assets/photos/manas.png",
    "assets/photos/nari_sanari.png",
    "assets/photos/nilav_shah.png",
    "assets/photos/jinali_modi.png",
    "assets/photos/pavan_salon.png",
    "assets/photos/shwaas.png",
    "assets/photos/tcl.png",
    "assets/photos/ugs.png",
    "assets/photos/ved_icu.png",
    "assets/photos/wost.png",
  ];

  // Theme Palette Colors
  static const Color primaryBlue = Colors.blue;
  static const Color accentPink = Color(0xFFE91E63);
  static const Color bgWhite = Colors.white;
  static const Color lightPink = Color(0xFFFCE4EC);

  // Contact Details & Social Links Constants
  final String addressQuery = "First Floor, Leela Efcee, 103, Waghawadi Rd., Hill Drive, Bhavnagar, Gujarat 364002";
  final String phoneNum = "+919408518168";
  final String emailAddr = "growsocialee@gmail.com";
  final String googleMapsUrl = "https://maps.google.com/?q=Leela+Efcee+Bhavnagar+Gujarat";

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
      viewportFraction: 0.45, // Default for mobile, will adjust dynamically in UI
    );

    _startAutoScroll();
  }

  void _startAutoScroll() {
    _carouselTimer?.cancel();
    _carouselTimer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
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
    if (_clientPageController.hasClients && clientLogos.isNotEmpty) {
      int prev = (_currentLogoPage - 1 + clientLogos.length) % clientLogos.length;
      _clientPageController.animateToPage(
        prev,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _initializeVideo() {
    _videoController = VideoPlayerController.asset('assets/videos/video.mp4')
      ..initialize().then((_) {
        setState(() {
          _isVideoInitialized = true;
        });
        _videoController.setLooping(true);
        _videoController.setVolume(0.0); // Muted for autoplay compatibility
        _checkAndControlVideoPlayback();
      });
  }

  // Monitor scroll position to play/pause video when visible
  void _onScrollCheckVideoVisibility() {
    _checkAndControlVideoPlayback();
  }

  void _checkAndControlVideoPlayback() {
    if (!_isVideoInitialized) return;

    final RenderObject? renderObject = _videoKey.currentContext?.findRenderObject();
    if (renderObject == null || !renderObject.attached) return;

    final RenderBox box = renderObject as RenderBox;
    final Offset position = box.localToGlobal(Offset.zero);
    final double screenHeight = MediaQuery.of(context).size.height;

    // Check if the video widget is substantially visible in the viewport
    final bool isVisible = (position.dy < screenHeight * 0.85) && (position.dy + box.size.height > screenHeight * 0.15);

    if (isVisible && !_videoController.value.isPlaying) {
      _videoController.play();
    } else if (!isVisible && _videoController.value.isPlaying) {
      _videoController.pause();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScrollCheckVideoVisibility);
    _scrollController.dispose();
    _videoController.dispose();
    _carouselTimer?.cancel();
    _clientPageController.dispose();
    super.dispose();
  }

  // Helper Methods for Launching Actions
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

  // Function to view video with interactive pinch-to-zoom
  void _openZoomableVideoDialog(BuildContext context) {
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
                      aspectRatio: _videoController.value.aspectRatio,
                      child: VideoPlayer(_videoController),
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
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: primaryBlue,
          automaticallyImplyLeading: false,
          elevation: 2,
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
      endDrawer: Drawer(
        width: isDesktop ? 360 : screenWidth * 0.8,
        backgroundColor: bgWhite,
        child: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
                color: lightPink,
                child: Center(
                  child: SizedBox(
                    height: 55,
                    child: Image.asset(
                      "assets/photos/Gro_Soc_Image.png",
                      color: primaryBlue,
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
                      },
                    ),
                    _buildDrawerItem(
                      index: 3,
                      icon: Icons.task_alt_outlined,
                      label: "SERVICES",
                      onTap: () {
                        setState(() => _selectedIndex = 3);
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const Services()));
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const Contact()));
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
          // Banner Image Section
          SliverToBoxAdapter(
            child: SizedBox(
              width: screenWidth,
              child: Image.asset("assets/photos/image.png", width: screenWidth, fit: BoxFit.cover),
            ),
          ),

          // Direct Video & Agency Info Section
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

          // Client Logo Section
          SliverToBoxAdapter(
            child: _clientLogo(),
          ),

          // Footer Section
          SliverToBoxAdapter(
            child: _buildFooter(context),
          ),
        ],
      ),
    );
  }

  // Direct video display fetching dynamic device dimensions
  Widget _buildDirectVideoPlayer(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;
    final bool isDesktop = deviceSize.width > 800;

    // Dynamically set container width & height based on current screen size
    final double playerWidth = isDesktop ? (deviceSize.width * 0.25).clamp(280.0, 360.0) : (deviceSize.width * 0.85).clamp(260.0, 340.0);
    final double playerHeight = playerWidth * 1.55;

    return Center(
      key: _videoKey,
      child: GestureDetector(
        onTap: () => _openZoomableVideoDialog(context),
        child: SizedBox(
          width: playerWidth + 40,
          height: playerHeight + 40,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Bottom-Left Backdrop Blue Box (Scaled dynamically)
              Positioned(
                left: 0,
                bottom: 0,
                child: Container(
                  width: playerWidth * 0.8,
                  height: playerHeight * 0.5,
                  decoration: BoxDecoration(
                    color: primaryBlue,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              // Front Video Viewport
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
                    child: _isVideoInitialized
                        ? AspectRatio(
                      aspectRatio: _videoController.value.aspectRatio,
                      child: VideoPlayer(_videoController),
                    )
                        : const Center(
                      child: CircularProgressIndicator(color: primaryBlue),
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

  // Agency Description
  Widget _buildAgencyDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Grow Socialee – The Best Social Media Marketing Agency in Bhavnagar We are Grow Socialee, a top social media marketing agency in Bhavnagar, helping small and medium-sized businesses boost their online presence. In today’s digital world, standing out is essential, and we simplify that process for you",
            style: GoogleFonts.ibmPlexSansThai(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "As the best digital marketing agency in Bhavnagar, we specialize in branding, content creation, social media management, and digital advertising. Need engaging video content? We are also the best video editing company in Bhavnagar, crafting eye-catching visuals for your brand.",
            style: GoogleFonts.ibmPlexSansThai(
              fontSize: 14,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Let’s build your digital success together! 📩 Contact Grow Socialee today!",
            style: GoogleFonts.ibmPlexSansThai(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "We understand social behaviours within online communities, cultures and subcultures.",
            style: GoogleFonts.ibmPlexSansThai(
              fontSize: 14,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const Contact()));
            },
            child: Container(
              padding: const EdgeInsets.only(left: 12, top: 8, bottom: 6, right: 8.5),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "Get in Touch",
                style: GoogleFonts.ibmPlexSansThai(
                  fontSize: 15.8,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoHeader() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          SizedBox(
            height: 40,
            child: Image.asset("assets/photos/Gro_Soc_Image.png", color: bgWhite),
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? primaryBlue : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: isSelected ? null : Border.all(color: Colors.black12, width: 0.5),
            ),
            child: Row(
              children: [
                Icon(icon, size: 22, color: isSelected ? bgWhite : accentPink),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: GoogleFonts.ibmPlexSansThai(
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

  Widget _buildFooter(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth > 800;

    return Container(
      width: double.infinity,
      color: lightPink,
      child: Column(
        children: [
          Container(
            height: 5,
            width: double.infinity,
            color: primaryBlue,
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
                    Expanded(flex: 2, child: _buildFooterBranding()),
                    const SizedBox(width: 40),
                    Expanded(flex: 3, child: _buildFooterContactDetails()),
                  ],
                )
                    : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFooterBranding(),
                    const SizedBox(height: 32),
                    const Divider(color: Colors.black12, thickness: 1),
                    const SizedBox(height: 24),
                    _buildFooterContactDetails(),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            color: primaryBlue,
            child: Center(
              child: Text(
                "© ${DateTime.now().year} All Rights Reserved.",
                style: GoogleFonts.ibmPlexSansThai(
                  color: bgWhite,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterBranding() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 48,
          child: Image.asset("assets/photos/Gro_Soc_Image.png", color: primaryBlue),
        ),
        const SizedBox(height: 12),
        Container(
          height: 3,
          width: 40,
          color: accentPink,
        ),
        const SizedBox(height: 16),
        Text(
          "Social Media Marketing Agency in Bhavnagar",
          style: GoogleFonts.ibmPlexSansThai(
            color: Colors.black87,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 20),
        _buildSocialIconsRow(),
      ],
    );
  }

  Widget _buildSocialIconsRow() {
    return Row(
      children: [
        _buildSocialIconButton(
          icon: FontAwesomeIcons.facebookF,
          backgroundColor: const Color(0xFF1877F2),
          onTap: () => _launchUrlString(facebookUrl),
        ),
        const SizedBox(width: 12),
        _buildSocialIconButton(
          icon: FontAwesomeIcons.instagram,
          backgroundColor: const Color(0xFFE4405F),
          onTap: () => _launchUrlString(instagramUrl),
        ),
        const SizedBox(width: 12),
        _buildSocialIconButton(
          icon: FontAwesomeIcons.linkedinIn,
          backgroundColor: const Color(0xFF0A66C2),
          onTap: () => _launchUrlString(linkedInUrl),
        ),
      ],
    );
  }

  Widget _buildSocialIconButton({
    required IconData icon,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: backgroundColor,
      shape: const CircleBorder(),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 38,
          height: 38,
          alignment: Alignment.center,
          child: FaIcon(
            icon,
            color: Colors.white,
            size: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildFooterContactDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "GET IN TOUCH",
          style: GoogleFonts.ibmPlexSansThai(
            color: accentPink,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        _buildFooterContactRow(
          icon: Icons.location_on_rounded,
          text: addressQuery,
          onTap: () => _launchUrlString(googleMapsUrl),
        ),
        const SizedBox(height: 12),
        _buildFooterContactRow(
          icon: Icons.phone_rounded,
          text: "+91 94085 18168",
          onTap: () => _makePhoneCall(phoneNum),
        ),
        const SizedBox(height: 12),
        _buildFooterContactRow(
          icon: Icons.email_rounded,
          text: emailAddr,
          onTap: () => _sendEmail(emailAddr),
        ),
        const SizedBox(height: 12),
        _buildFooterContactRow(
          icon: Icons.access_time_filled_rounded,
          text: "Working Hours: 9:30 AM to 7:00 PM",
          onTap: null,
        ),
      ],
    );
  }

  Widget _buildFooterContactRow({
    required IconData icon,
    required String text,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: primaryBlue.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: primaryBlue, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.ibmPlexSansThai(
                  color: Colors.black87,
                  fontSize: 14,
                  height: 1.4,
                  decoration: onTap != null ? TextDecoration.underline : TextDecoration.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _clientLogo() {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth > 800;

    // Adjust fraction based on screen width so logos fit without distortion
    final double fraction = isDesktop ? 0.22 : 0.45;

    // Re-initialize controller fraction if screen configuration changes
    if (_clientPageController.viewportFraction != fraction) {
      _clientPageController = PageController(
        initialPage: _currentLogoPage,
        viewportFraction: fraction,
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "We Work With",
            style: GoogleFonts.ibmPlexSansThai(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 3,
            width: 50,
            decoration: BoxDecoration(
              color: accentPink,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // Carousel Stack with Forward / Backward Buttons
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
                        setState(() {
                          _currentLogoPage = index;
                        });
                      },
                      itemCount: clientLogos.length,
                      itemBuilder: (context, index) {
                        return AnimatedBuilder(
                          animation: _clientPageController,
                          builder: (context, child) {
                            double value = 1.0;
                            if (_clientPageController.position.haveDimensions) {
                              value = (_clientPageController.page! - index);
                              value = (1 - (value.abs() * 0.18)).clamp(0.82, 1.0);
                            }
                            return Center(
                              child: Transform.scale(
                                scale: value,
                                child: child,
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey.shade200, width: 1),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.06),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Image.asset(
                                clientLogos[index],
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) => const Icon(
                                  Icons.broken_image_outlined,
                                  color: Colors.grey,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Backward Button Icon
                  Positioned(
                    left: isDesktop ? 20 : 5,
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
                            size: 18,
                            color: primaryBlue,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Forward Button Icon
                  Positioned(
                    right: isDesktop ? 20 : 5,
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
                            size: 18,
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

          // Carousel Page Indicator Dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              clientLogos.length,
                  (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                height: 7,
                width: _currentLogoPage == index ? 18 : 7,
                decoration: BoxDecoration(
                  color: _currentLogoPage == index ? primaryBlue : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}