import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grow_socialee/Client_Logos.dart';
import 'package:grow_socialee/Services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'contact.dart';
import 'home_page.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  int _selectedIndex = 1; // 1 for About Page active index

  // Key to locate and trigger stats animation when scrolling into view
  final GlobalKey<_StatsSectionState> _statsKey = GlobalKey<_StatsSectionState>();
  final GlobalKey<_ValuesSectionState> _valuesKey = GlobalKey<_ValuesSectionState>();
  final GlobalKey<_TeamSectionState> _teamKey = GlobalKey<_TeamSectionState>();

  // Theme Constants
  static const Color primaryBlue = Colors.blue;
  static const Color accentPink = Color(0xFFE91E63);
  static const Color bgWhite = Colors.white;
  static const Color lightPink = Color(0xFFFCE4EC);

  // Agency Contact Constants
  final String addressQuery =
      "First Floor, Leela Efcee, 103, Waghawadi Rd., Hill Drive, Bhavnagar, Gujarat 364002";
  final String phoneNum = "+919408518168";
  final String emailAddr = "growsocialee@gmail.com";
  final String googleMapsUrl =
      "https://maps.google.com/?q=Leela+Efcee+Bhavnagar+Gujarat";

  final String facebookUrl = "https://www.facebook.com/growsocialeeofficial/";
  final String instagramUrl = "https://www.instagram.com/growsocialee.official/";
  final String linkedInUrl = "https://in.linkedin.com/company/grow-socialee";

  // URL Launchers
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
              Colors.indigo.shade700,
              Colors.blue.shade400,
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
                            builder: (context) => const Contact(),
                          ),
                        );
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
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          _statsKey.currentState?.checkVisibility();
          _valuesKey.currentState?.checkVisibility();
          _teamKey.currentState?.checkVisibility();
          return false;
        },
        child: CustomScrollView(
          slivers: [
            // Banner Section
            SliverToBoxAdapter(
              child: _buildHeroSection(isDesktop),
            ),

            // Overview & Vision Section
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
                    Expanded(child: _buildAboutImageCard()),
                    const SizedBox(width: 40),
                    Expanded(child: _buildAboutDescription()),
                  ],
                )
                    : Column(
                  children: [
                    _buildAboutImageCard(),
                    const SizedBox(height: 30),
                    _buildAboutDescription(),
                  ],
                ),
              ),
            ),

            // Statistics Counter Bar with dynamic scroll trigger
            SliverToBoxAdapter(
              child: StatsSection(key: _statsKey, isDesktop: isDesktop),
            ),

            // Core Value Cards Section with Equal Height and Directed Animations
            SliverToBoxAdapter(
              child: ValuesSection(key: _valuesKey, isDesktop: isDesktop),
            ),

            // Team Details Cards Section
            SliverToBoxAdapter(
              child: TeamSection(key: _teamKey, isDesktop: isDesktop),
            ),

            // Footer
            SliverToBoxAdapter(
              child: _buildFooter(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoHeader() {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 36,
            child: Image.asset(
              "assets/photos/Gro_Soc_Image.png",
              color: bgWhite,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.business, color: bgWhite, size: 30),
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
              color: isSelected ? Colors.pink.shade400 : Colors.transparent,
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
                  child: Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.bold, color: isSelected ? bgWhite : Colors.black87, letterSpacing: 1.1)),
                ),
                if (isSelected)
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: bgWhite,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Hero Section
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
                    const Icon(Icons.bolt_rounded, size: 16, color: primaryBlue),
                    const SizedBox(width: 6),
                    Text("WHO WE ARE", style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.bold, color: primaryBlue, letterSpacing: 1.2)),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Text("Empowering Brands in the Digital Era", textAlign: TextAlign.center, style: GoogleFonts.cormorantGaramond(fontSize: isDesktop ? 36 : 28, fontWeight: FontWeight.bold, color: Colors.indigo.shade900, height: 1.2)),
              const SizedBox(height: 10),
              Text(
                  "Grow Socialee is Bhavnagar's premier marketing agency dedicated to scaling local businesses through strategic digital experiences and high-converting creative media.",
                  textAlign: TextAlign.center, style: GoogleFonts.cormorantGaramond(fontSize: 16, color: Colors.black87, height: 1.5)),
            ],
          ),
        ),
      ),
    );
  }

  // About Image Section
  Widget _buildAboutImageCard() {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 450),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.indigo.shade200.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            "assets/photos/image.png",
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 280,
              color: Colors.grey[200],
              child: const Icon(Icons.business, size: 60, color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }

  // About Text Content
  Widget _buildAboutDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Grow Socialee – The Best Social Media Marketing Agency in Bhavnagar",
          textAlign: TextAlign.justify,
          style: GoogleFonts.cormorantGaramond(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.indigo.shade900,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Text("We are Grow Socialee, a dedicated social media marketing agency in Bhavnagar, focused on helping small "
            "and medium-sized businesses build their online presence", textAlign: TextAlign.justify,
            style: GoogleFonts.cormorantGaramond(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black87, height: 1.2)),
        const SizedBox(height: 12),
        Text("In today’s digital landscape, having a strong online identity is essential for business success, and we are here to simplify that journey for you.", textAlign: TextAlign.justify,
            style: GoogleFonts.cormorantGaramond(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black87, height: 1.2)),
        const SizedBox(height: 12),
        Text("At Grow Socialee, we understand that the digital world can be complicated, but we make it easy for businesses to navigate. Our expertise lies in various areas, including branding, content creation, creative design, social media management, & digital advertising campaigns. We are committed to helping you reach your goals and ensuring your business stands out from the crowd. Start your digital marketing journey with us!", textAlign: TextAlign.justify,
            style: GoogleFonts.cormorantGaramond(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black87, height: 1.2)),
      ],
    );
  }

  // Footer Section
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
        Text(
          "Contact Info",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () => _launchUrlString(googleMapsUrl),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on_outlined, size: 18, color: Colors.white70),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  addressQuery,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: Colors.white,
                    height: 1.4,
                  ),
                ),
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
              Text(
                phoneNum,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: Colors.white,
                ),
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
              Text(
                emailAddr,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: Colors.white,
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
        Text("Follow Us", style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(12),
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
                child: VerticalDivider(color: Colors.black87, thickness: 2.5),
              ),
              IconButton(
                icon: const Icon(FontAwesomeIcons.instagram, size: 20, color: accentPink),
                onPressed: () => _launchUrlString(instagramUrl),
              ),
              const SizedBox(
                height: 15,
                child: VerticalDivider(color: Colors.black87, thickness: 2.5),
              ),
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

// State Management for Values Section Animations with Visibility Detection
class ValuesSection extends StatefulWidget {
  final bool isDesktop;

  const ValuesSection({super.key, required this.isDesktop});

  @override
  State<ValuesSection> createState() => _ValuesSectionState();
}

class _ValuesSectionState extends State<ValuesSection> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<Offset> _leftToRightAnimation; // Our Mission
  late Animation<Offset> _topToBottomAnimation; // Our Vision
  late Animation<Offset> _rightToLeftAnimation; // Our Brand Pillars
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
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic));

    _topToBottomAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic));

    _rightToLeftAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic));

    _fadeAnimation = CurvedAnimation(parent: _animController, curve: Curves.easeIn);

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

      if (position.dy < screenHeight - 100 && (position.dy + renderObject.size.height) > 0) {
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
    const Color accentPink = Color(0xFFE91E63);

    final missionCard = _buildCard(
      icon: Icons.trending_up_rounded,
      title: "Our Mission",
      content: Text(
        "To simplify digital growth for local businesses by delivering impactful branding, creative design, engaging content, strategic social media management, and data-driven advertising campaigns that drive real results.",
        style: GoogleFonts.cormorantGaramond(fontSize: 15, color: Colors.black87, height: 1.4),
      ),
    );

    final visionCard = _buildCard(
      icon: Icons.movie_creation_outlined,
      title: "Our Vision",
      content: Text(
        "To empower small and medium-sized businesses to build strong, distinct online identities and confidently succeed in an ever-evolving digital world.",
        style: GoogleFonts.cormorantGaramond(fontSize: 15, color: Colors.black87, height: 1.4),
      ),
    );

    final pillarsCard = _buildCard(
      icon: Icons.movie_creation_outlined,
      title: "Our Brand Pillars",
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPillarPoint("1. Simplicity First:", " We demystify the complex digital marketing landscape so business owners can focus on running their operations."),
          const SizedBox(height: 6),
          _buildPillarPoint("2. Tailored Digital Growth:", " We craft customized solutions across creative content, management, and ads to make your business stand out."),
          const SizedBox(height: 6),
          _buildPillarPoint("3. Dedicated Partnership:", " We are committed to guiding you every step of the way on your journey toward long-term digital success."),
        ],
      ),
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      color: Colors.white,
      child: Column(
        children: [
          Text("Why Choose Us", style: GoogleFonts.cormorantGaramond(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.indigo.shade900)),
          const SizedBox(height: 6),
          Container(
            height: 3,
            width: 60,
            decoration: BoxDecoration(
              color: accentPink,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 30),
          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: widget.isDesktop
                  ? IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: SlideTransition(
                        position: _leftToRightAnimation,
                        child: FadeTransition(opacity: _fadeAnimation, child: missionCard),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: SlideTransition(
                        position: _topToBottomAnimation,
                        child: FadeTransition(opacity: _fadeAnimation, child: visionCard),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: SlideTransition(
                        position: _rightToLeftAnimation,
                        child: FadeTransition(opacity: _fadeAnimation, child: pillarsCard),
                      ),
                    ),
                  ],
                ),
              )
                  : Column(
                children: [
                  SlideTransition(
                    position: _leftToRightAnimation,
                    child: FadeTransition(opacity: _fadeAnimation, child: missionCard),
                  ),
                  const SizedBox(height: 20),
                  SlideTransition(
                    position: _topToBottomAnimation,
                    child: FadeTransition(opacity: _fadeAnimation, child: visionCard),
                  ),
                  const SizedBox(height: 20),
                  SlideTransition(
                    position: _rightToLeftAnimation,
                    child: FadeTransition(opacity: _fadeAnimation, child: pillarsCard),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPillarPoint(String boldTitle, String text) {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.cormorantGaramond(fontSize: 14, color: Colors.black87, height: 1.4),
        children: [
          TextSpan(
            text: boldTitle,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
          ),
          TextSpan(text: text),
        ],
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required Widget content,
  }) {
    const Color lightPink = Color(0xFFFCE4EC);
    const Color accentPink = Color(0xFFE91E63);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: lightPink,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: accentPink, size: 28),
          ),
          const SizedBox(height: 16),
          Text(title, style: GoogleFonts.cormorantGaramond(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo.shade900)),
          const SizedBox(height: 10),
          content,
        ],
      ),
    );
  }
}

// State Management for Team Section Animations with Matching Motion Rules
class TeamSection extends StatefulWidget {
  final bool isDesktop;

  const TeamSection({super.key, required this.isDesktop});

  @override
  State<TeamSection> createState() => _TeamSectionState();
}

class _TeamSectionState extends State<TeamSection> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<Offset> _leftToRightAnimation; // Founder Card
  late Animation<Offset> _topToBottomAnimation; // Manager Card
  late Animation<Offset> _rightToLeftAnimation; // Sub Manager Card
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
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic));

    _topToBottomAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic));

    _rightToLeftAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic));

    _fadeAnimation = CurvedAnimation(parent: _animController, curve: Curves.easeIn);

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

      if (position.dy < screenHeight - 100 && (position.dy + renderObject.size.height) > 0) {
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
    const Color accentPink = Color(0xFFE91E63);

    final founderCard = _buildTeamCard(
      name: "Shaily Shah",
      designation: "Founder",
    );

    final managerCard = _buildTeamCard(
      name: "Umesh Parmar",
      designation: "Manager",
    );

    final subManagerCard = _buildTeamCard(
      name: "Vaibhavsinh Jadeja",
      designation: "Sub Manager",
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      color: Colors.grey[50],
      child: Column(
        children: [
          Text("Meet Our Leadership", style: GoogleFonts.cormorantGaramond(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.indigo.shade900)),
          const SizedBox(height: 6),
          Container(
            height: 3,
            width: 60,
            decoration: BoxDecoration(
              color: accentPink,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 30),
          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: widget.isDesktop
                  ? IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: SlideTransition(
                        position: _leftToRightAnimation,
                        child: FadeTransition(opacity: _fadeAnimation, child: founderCard),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: SlideTransition(
                        position: _topToBottomAnimation,
                        child: FadeTransition(opacity: _fadeAnimation, child: managerCard),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: SlideTransition(
                        position: _rightToLeftAnimation,
                        child: FadeTransition(opacity: _fadeAnimation, child: subManagerCard),
                      ),
                    ),
                  ],
                ),
              )
                  : Column(
                children: [
                  SlideTransition(
                    position: _leftToRightAnimation,
                    child: FadeTransition(opacity: _fadeAnimation, child: founderCard),
                  ),
                  const SizedBox(height: 20),
                  SlideTransition(
                    position: _topToBottomAnimation,
                    child: FadeTransition(opacity: _fadeAnimation, child: managerCard),
                  ),
                  const SizedBox(height: 20),
                  SlideTransition(
                    position: _rightToLeftAnimation,
                    child: FadeTransition(opacity: _fadeAnimation, child: subManagerCard),
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
  }) {
    const Color lightPink = Color(0xFFFCE4EC);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: lightPink,
            child: Icon(
              Icons.person_rounded,
              size: 45,
              color: Colors.indigo.shade700,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            name,
            textAlign: TextAlign.center,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.indigo.shade900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            designation,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.pink.shade600,
              letterSpacing: 0.8,
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
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade600,
            Colors.indigo.shade500,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 10),
      child: widget.isDesktop
          ? Container(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(_stats.length, (index) {
            final item = _stats[index];
            return Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return _buildStatColumn(item, _animation.value);
                      },
                    ),
                  ),
                  if (index != _stats.length - 1)
                    Container(
                      height: 50,
                      width: 1,
                      color: Colors.white30,
                    ),
                ],
              ),
            );
          }),
        ),
      )
          : SizedBox(
        height: 100,
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
                return Row(
                  children: [
                    SizedBox(
                        width: 180,
                        child: _buildStatColumn(item, _animation.value)
                    ),
                    Container(
                      height: 45,
                      width: 1,
                      color: Colors.white30,
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatColumn(StatData item, double progress) {
    double currentValue = item.endValue * progress;
    String formattedValue = item.isDecimal
        ? currentValue.toStringAsFixed(1)
        : currentValue.toInt().toString();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("$formattedValue${item.suffix}", style: GoogleFonts.cormorantGaramond(fontSize: widget.isDesktop ? 38 : 30, fontWeight: FontWeight.bold, color: Colors.white, height: 1.0)),
        const SizedBox(height: 6),
        Text(item.label.toUpperCase(), textAlign: TextAlign.center, style: GoogleFonts.plusJakartaSans(fontSize: widget.isDesktop ? 12 : 10, color: Colors.white.withOpacity(0.85), fontWeight: FontWeight.w600, letterSpacing: 1.1)),
      ],
    );
  }
}