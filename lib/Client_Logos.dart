import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grow_socialee/home_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'About.dart';
import 'contact.dart';
import 'Services.dart';

class ClientLogoPage extends StatefulWidget {
  const ClientLogoPage({super.key});

  @override
  State<ClientLogoPage> createState() => _ClientLogoPageState();
}

class _ClientLogoPageState extends State<ClientLogoPage> {
  int _selectedIndex = 2;

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
        slivers: [
          // Enhanced Hero Section
          SliverToBoxAdapter(
            child: _buildHeroSection(isDesktop),
          ),
          SliverToBoxAdapter(
            child: _buildAllLogosGrid(context),
          ),
          SliverToBoxAdapter(
            child: _buildFooter(context),
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

  // Enhanced Hero Section with Sphinix-style tagline
  Widget _buildHeroSection(bool isDesktop) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [lightPink, bgWhite],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.people_alt_rounded, size: 16, color: primaryBlue),
                    const SizedBox(width: 6),
                    Text("OUR CLIENTS", style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.bold, color: primaryBlue, letterSpacing: 1.2)),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Text("The Brands We're Working With", textAlign: TextAlign.center, style: GoogleFonts.bebasNeue(fontSize: isDesktop ? 36 : 28, fontWeight: FontWeight.bold, color: Colors.indigo.shade900, height: 1.2)),
              const SizedBox(height: 10),
              Text(
                  "We take small business people into the path of progress by completing digital marketing services and we are doing it with love.",
                  textAlign: TextAlign.center, style: GoogleFonts.plusJakartaSans(fontSize: 16, color: Colors.black87, height: 1.5)),
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
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: clientLogos.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.4,
            ),
            itemBuilder: (context, index) {
              return AnimatedLogoCard(
                imagePath: clientLogos[index]["path"]!,
                isWhiteLogo: clientLogos[index]["isWhite"] ?? false,
                index: index,
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
            color: Colors.indigo.shade500,
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
          style: GoogleFonts.ibmPlexSansThai(
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
        Text("Contact Info", style: GoogleFonts.ibmPlexSansThai(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 12),
        InkWell(
          onTap: () => _launchUrlString(googleMapsUrl),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on_outlined, size: 18, color: Colors.white70),
              const SizedBox(width: 8),
              Expanded(
                child: Text(addressQuery, style: GoogleFonts.ibmPlexSansThai(fontSize: 13, color: Colors.white, height: 1.4)),
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
              Text(phoneNum, style: GoogleFonts.ibmPlexSansThai(fontSize: 13, color: Colors.white),
              ),
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
              Text(emailAddr, style: GoogleFonts.ibmPlexSansThai(fontSize: 13, color: Colors.white)),
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

class AnimatedLogoCard extends StatefulWidget {
  final String imagePath;
  final bool isWhiteLogo;
  final int index;

  const AnimatedLogoCard({
    super.key,
    required this.imagePath,
    required this.index,
    this.isWhiteLogo = false,
  });

  @override
  State<AnimatedLogoCard> createState() => _AnimatedLogoCardState();
}

class _AnimatedLogoCardState extends State<AnimatedLogoCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    Offset startOffset;
    switch (widget.index % 6) {
      case 0:
        startOffset = const Offset(-1.2, 0.0);
        break;
      case 1:
        startOffset = const Offset(1.2, 0.0);
        break;
      case 2:
        startOffset = const Offset(0.0, -1.2);
        break;
      case 3:
        startOffset = const Offset(0.0, 1.2);
        break;
      case 4:
        startOffset = const Offset(-1.0, -1.0);
        break;
      case 5:
      default:
        startOffset = const Offset(1.0, 1.0);
        break;
    }

    _offsetAnimation = Tween<Offset>(
      begin: startOffset,
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

    Future.delayed(Duration(milliseconds: (widget.index % 6) * 120), () {
      if (mounted) {
        _controller.forward();
      }
    });
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
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: widget.isWhiteLogo ? const Color(0xFF2C3E50) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.isWhiteLogo ? Colors.transparent : Colors.grey.shade200,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Image.asset(
              widget.imagePath,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.broken_image_outlined, color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }
}