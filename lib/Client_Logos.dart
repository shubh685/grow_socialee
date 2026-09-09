import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grow_socialee/home_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'contact.dart';
import 'Services.dart';

class ClientLogoPage extends StatefulWidget {
  const ClientLogoPage({super.key});

  @override
  State<ClientLogoPage> createState() => _ClientLogoPageState();
}

class _ClientLogoPageState extends State<ClientLogoPage> {
  int _selectedIndex = 2; // Selected index for CLIENTS page

  // List of client logo assets
  final List<String> clientLogos = [
    "assets/photos/aroma.png",
    "assets/photos/aura.png",
    "assets/photos/bani_thni.png",
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
    "assets/photos/shwass.png",
    "assets/photos/th_ce_la.png",
    "assets/photos/ugs.png",
    "assets/photos/ved_icu.png",
    "assets/photos/wost.png",
  ];

  // Theme Palette Colors
  static const Color primaryBlue = Colors.blue;
  static const Color accentPink = Color(0xFFE91E63);
  static const Color bgWhite = Colors.white;
  static const Color lightPink = Color(0xFFFCE4EC);

  // Contact Details & Social Links
  final String addressQuery =
      "First Floor, Leela Efcee, 103, Waghawadi Rd., Hill Drive, Bhavnagar, Gujarat 364002";
  final String phoneNum = "+919408518168";
  final String emailAddr = "growsocialee@gmail.com";
  final String googleMapsUrl =
      "https://maps.google.com/?q=Leela+Efcee+Bhavnagar+Gujarat";

  final String facebookUrl =
      "https://www.facebook.com/growsocialeeofficial/";
  final String instagramUrl =
      "https://www.instagram.com/growsocialee.official/";
  final String linkedInUrl =
      "https://in.linkedin.com/company/grow-socialee";

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
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.business,
                        size: 40,
                        color: primaryBlue,
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
                          MaterialPageRoute(builder: (context) => const Services()),
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
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          SizedBox(
            height: 40,
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? primaryBlue : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: isSelected
                  ? null
                  : Border.all(color: Colors.black12, width: 0.5),
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
                  const Icon(Icons.arrow_forward_ios_rounded,
                      size: 14, color: bgWhite),
              ],
            ),
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
          Text(
            "Our Valued Clients",
            style: GoogleFonts.ibmPlexSansThai(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: clientLogos.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
            ),
            itemBuilder: (context, index) {
              return AnimatedLogoCard(
                imagePath: clientLogos[index],
                index: index,
              );
            },
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
            errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.business, size: 40, color: primaryBlue),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "Empowering brands with impactful digital marketing solutions.",
          style: GoogleFonts.ibmPlexSansThai(
            fontSize: 13,
            color: Colors.black87,
            height: 1.4,
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
          "Contact Info",
          style: GoogleFonts.ibmPlexSansThai(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _launchUrlString(googleMapsUrl),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on, size: 18, color: accentPink),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  addressQuery,
                  style: GoogleFonts.ibmPlexSansThai(
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _makePhoneCall(phoneNum),
          child: Row(
            children: [
              const Icon(Icons.phone, size: 18, color: accentPink),
              const SizedBox(width: 8),
              Text(
                phoneNum,
                style: GoogleFonts.ibmPlexSansThai(
                  fontSize: 13,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _sendEmail(emailAddr),
          child: Row(
            children: [
              const Icon(Icons.email, size: 18, color: accentPink),
              const SizedBox(width: 8),
              Text(
                emailAddr,
                style: GoogleFonts.ibmPlexSansThai(
                  fontSize: 13,
                  color: Colors.black87,
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
          "Follow Us",
          style: GoogleFonts.ibmPlexSansThai(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.facebook, color: primaryBlue),
              onPressed: () => _launchUrlString(facebookUrl),
            ),
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.instagram, color: accentPink),
              onPressed: () => _launchUrlString(instagramUrl),
            ),
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.linkedin, color: primaryBlue),
              onPressed: () => _launchUrlString(linkedInUrl),
            ),
          ],
        ),
      ],
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
                    Expanded(flex: 2, child: _buildFooterBrandSection()),
                    const SizedBox(width: 32),
                    Expanded(flex: 2, child: _buildFooterContactSection()),
                    const SizedBox(width: 32),
                    Expanded(flex: 1, child: _buildFooterSocialSection()),
                  ],
                )
                    : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFooterBrandSection(),
                    const SizedBox(height: 28),
                    _buildFooterContactSection(),
                    const SizedBox(height: 28),
                    _buildFooterSocialSection(),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            color: primaryBlue,
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Text(
              "© ${DateTime.now().year} Grow Socialee. All Rights Reserved.",
              textAlign: TextAlign.center,
              style: GoogleFonts.ibmPlexSansThai(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedLogoCard extends StatefulWidget {
  final String imagePath;
  final int index;

  const AnimatedLogoCard({
    super.key,
    required this.imagePath,
    required this.index,
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
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