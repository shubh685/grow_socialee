import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grow_socialee/home_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'About.dart';
import 'Reviews.dart';
import 'contact.dart';
import 'Services.dart';

class ClientLogoPage extends StatefulWidget {
  const ClientLogoPage({super.key});

  @override
  State<ClientLogoPage> createState() => _ClientLogoPageState();
}

class _ClientLogoPageState extends State<ClientLogoPage> {
  int _selectedIndex = 2;

  final List<Map<String, dynamic>> clientLogos = const [
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

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth > 800;

    return Scaffold(
      backgroundColor: HomePage.darkBg,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75),
        child: Container(
          decoration: BoxDecoration(
            color: HomePage.darkBg,
            border: Border(
              bottom: BorderSide(
                color: HomePage.accentCyan.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
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
                builder: (context) => IconButton(
                  icon: const Icon(
                    Icons.menu_rounded,
                    color: HomePage.accentGold,
                    size: 28,
                  ),
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
        backgroundColor: HomePage.darkBg,
        child: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 28.0,
                  horizontal: 16.0,
                ),
                color: HomePage.darkCardBg,
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
                color: HomePage.accentCyan.withOpacity(0.3),
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Reviews()));
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
                color: HomePage.accentGold,
              )
            ],
          ),
        ),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          _checkCardsVisibility();
          return false;
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _buildHeroSection(isDesktop),
            ),
            SliverToBoxAdapter(
              child: _buildAllLogosGrid(context),
            ),
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

  Widget _buildLogoHeader() {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              "We are \n Grow Socialee",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.bellota(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.0,
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
              color: isSelected ? HomePage.accentGold : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isSelected ? Colors.black : Colors.white,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: GoogleFonts.bellota(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.black87 : Colors.white,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                if (isSelected)
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: Colors.black,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(bool isDesktop) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            HomePage.darkBg,
            HomePage.darkCardBg,
          ],
        ),
      ),
      padding: EdgeInsets.symmetric(
        vertical: isDesktop ? 80 : 50,
        horizontal: 24,
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 850),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: HomePage.accentCyan.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: HomePage.accentCyan.withOpacity(0.6)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.people_alt_rounded,
                      size: 16,
                      color: HomePage.accentCyan,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "OUR CLIENTS",
                      style: GoogleFonts.bellota(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: HomePage.accentCyan,
                        letterSpacing: 2.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "The Brands We're Working With",
                textAlign: TextAlign.center,
                style: GoogleFonts.bellota(
                  fontSize: isDesktop ? 44 : 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                "We take small business people into the path of progress by completing digital marketing services and we are doing it with love.",
                textAlign: TextAlign.center,
                style: GoogleFonts.bellota(
                  fontSize: 14.5,
                  color: HomePage.textMuted,
                  height: 1.6,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAllLogosGrid(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final int crossAxisCount = screenWidth > 900
        ? 6
        : screenWidth > 600
        ? 4
        : 2;

    return Container(
      color: HomePage.darkBg,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: clientLogos.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.3,
        ),
        itemBuilder: (context, index) {
          final int rowIndex = index ~/ crossAxisCount;
          final int colIndex = index % crossAxisCount;

          return BottomToTopAnimatedLogoCard(
            key: _cardKeys[index],
            imagePath: clientLogos[index]["path"]!,
            isWhiteLogo: clientLogos[index]["isWhite"] ?? false,
            rowIndex: rowIndex,
            colIndex: colIndex,
          );
        },
      ),
    );
  }
}

class BottomToTopAnimatedLogoCard extends StatefulWidget {
  final String imagePath;
  final bool isWhiteLogo;
  final int rowIndex;
  final int colIndex;

  const BottomToTopAnimatedLogoCard({
    super.key,
    required this.imagePath,
    required this.rowIndex,
    required this.colIndex,
    this.isWhiteLogo = false,
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
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 650),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.8), // Enforces bottom-to-top dimension movement
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
      curve: Curves.easeIn,
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
        // Stagger row by row line-by-line horizontally
        final int delay = (widget.rowIndex * 120) + (widget.colIndex * 50);
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
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: widget.isWhiteLogo ? HomePage.darkCardBg : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.isWhiteLogo
                  ? HomePage.accentCyan.withOpacity(0.4)
                  : HomePage.accentCyan.withOpacity(0.8),
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
          child: Center(
            child: Image.asset(
              widget.imagePath,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.broken_image_outlined,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

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

    _glowAnimation = Tween<double>(begin: 0.2, end: 0.8).animate(
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
    final bool isDesktop = screenWidth > 800;

    return Container(
      width: double.infinity,
      color: HomePage.darkBg,
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
                      HomePage.accentCyan.withOpacity(_glowAnimation.value),
                      HomePage.accentGold.withOpacity(_glowAnimation.value),
                      HomePage.accentCyan.withOpacity(_glowAnimation.value),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: HomePage.accentCyan.withOpacity(_glowAnimation.value),
                      blurRadius: 10,
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
            color: HomePage.darkCardBg,
            child: Center(
              child: Text(
                "© ${DateTime.now().year} Grow Socialee. All rights reserved.",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: HomePage.textMuted,
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
            color: HomePage.textMuted,
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
            color: HomePage.accentGold,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: () => widget.onLaunchUrl(widget.googleMapsUrl),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 18,
                color: HomePage.accentGold,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.addressQuery,
                  style: GoogleFonts.bellota(
                    fontSize: 13,
                    color: HomePage.accentWhite,
                    height: 1.4,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () => widget.onMakeCall(widget.phoneNum),
          child: Row(
            children: [
              const Icon(
                Icons.phone_outlined,
                size: 18,
                color: HomePage.accentGold,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.phoneNum,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.bellota(
                    fontSize: 13,
                    color: HomePage.textMuted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () => widget.onSendEmail(widget.emailAddr),
          child: Row(
            children: [
              const Icon(
                Icons.email_outlined,
                size: 18,
                color: HomePage.accentGold,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.emailAddr,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.bellota(
                    fontSize: 13,
                    color: HomePage.textMuted,
                    fontWeight: FontWeight.w700,
                  ),
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
          style: GoogleFonts.bellota(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: HomePage.accentGold,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            IconButton(
              icon: const Icon(
                FontAwesomeIcons.facebook,
                size: 20,
                color: Colors.white,
              ),
              onPressed: () => widget.onLaunchUrl(widget.facebookUrl),
            ),
            IconButton(
              icon: const Icon(
                FontAwesomeIcons.instagram,
                size: 20,
                color: Colors.white,
              ),
              onPressed: () => widget.onLaunchUrl(widget.instagramUrl),
            ),
            IconButton(
              icon: const Icon(
                FontAwesomeIcons.linkedin,
                size: 20,
                color: Colors.white,
              ),
              onPressed: () => widget.onLaunchUrl(widget.linkedInUrl),
            ),
          ],
        ),
      ],
    );
  }
}