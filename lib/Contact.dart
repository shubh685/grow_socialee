import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'About.dart';
import 'Client_Logos.dart';
import 'Services.dart';
import 'home_page.dart';

class Contact extends StatefulWidget {
  const Contact({super.key});

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> with SingleTickerProviderStateMixin {
  int _selectedIndex = 5; // Contact Us active index
  int _selectedFormCategory = 0; // 0: General, 1: Project Quote, 2: Support

  // Theme Palette Colors
  static const Color primaryBlue = Colors.blue;
  static const Color accentPink = Color(0xFFE91E63);
  static const Color bgWhite = Colors.white;
  static const Color lightPink = Color(0xFFFCE4EC);

  // Form Key & Controllers
  final _formKey = GlobalKey<FormState>();
  String? _serviceDr;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  // List of services mapped from Services.dart
  final List<String> _servicesList = [
    "Social Media Strategy Development",
    "Content Creation",
    "Social Media Account Management",
    "Social Media Advertising",
    "Analytics and Reporting",
    "Reputation Management",
  ];

  bool _isSubmitting = false;

  // Animation controller for map radar sweep effect
  late AnimationController _radarAnimationController;

  // URLs & Contact Constants
  final String addressQuery =
      "First Floor, Leela Efcee, 103, Waghawadi Rd., Hill Drive, Bhavnagar, Gujarat 364002";
  final String phoneNum = "+919408518168";
  final String emailAddr = "growsocialee@gmail.com";
  final String googleMapsUrl =
      "https://maps.google.com/?q=Grow+Socialee+Leela+Efcee+Bhavnagar";
  final String googleDirectionsUrl =
      "https://www.google.com/maps/dir/?api=1&destination=Grow+Socialee+Leela+Efcee+Bhavnagar";

  final String facebookUrl = "https://www.facebook.com/growsocialeeofficial/";
  final String instagramUrl = "https://www.instagram.com/growsocialee.official/";
  final String linkedInUrl = "https://in.linkedin.com/company/grow-socialee";

  @override
  void initState() {
    super.initState();
    _radarAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _radarAnimationController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  // URL Launcher Utility Methods
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

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        setState(() {
          _isSubmitting = false;
          _serviceDr = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Thank you! Your inquiry has been dispatched successfully."),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );

        _nameController.clear();
        _emailController.clear();
        _phoneController.clear();
        _messageController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth > 850;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
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
          // Dynamic Hero Banner Section
          SliverToBoxAdapter(
            child: _buildHeroSection(),
          ),

          // Main Layout Area
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1150),
                  child: isDesktop
                      ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 7,
                        child: Column(
                          children: [
                            _buildInteractiveFormCard(),
                            const SizedBox(height: 28),
                            _buildGoogleMapSection(),
                          ],
                        ),
                      ),
                      const SizedBox(width: 32),
                      Expanded(
                        flex: 5,
                        child: _buildInteractiveContactSidebar(),
                      ),
                    ],
                  )
                      : Column(
                    children: [
                      _buildInteractiveContactSidebar(),
                      const SizedBox(height: 28),
                      _buildInteractiveFormCard(),
                      const SizedBox(height: 28),
                      _buildGoogleMapSection(),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Footer
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

  // Hero Section
  Widget _buildHeroSection() {
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
                    Text(
                      "LET'S CONNECT",
                      style: GoogleFonts.ibmPlexSansThai(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: primaryBlue,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              // Main Title updated to use Radley font
              Text("How Can We Help Grow Your Brand?", textAlign: TextAlign.center, style: GoogleFonts.radley(fontSize: 32, fontWeight: FontWeight.bold, color: primaryBlue, height: 1.2)),
              const SizedBox(height: 10),
              // Description kept as GoogleFonts.ibmPlexSansThai
              Text(
                "Have a question, idea, or project in mind? Pick your preferred mode of communication below or drop us a message.",
                textAlign: TextAlign.center,
                style: GoogleFonts.ibmPlexSansThai(
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Interactive Form Component with Filter Pills & Service Dropdown
  Widget _buildInteractiveFormCard() {
    final categories = ["General Inquiry", "Get Quote", "Support"];

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Colors.blue.shade600, Colors.indigo.shade500
        ]),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Subtitle Title inside card uses Radley font
                      Text("Send Us A Message", style: GoogleFonts.radley(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(height: 2),
                      // Subtitle description kept as GoogleFonts.ibmPlexSansThai
                      Text("Fill out the form below and we'll reply shortly.", style: GoogleFonts.ibmPlexSansThai(fontSize: 13, color: Colors.white70)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: lightPink,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.send_rounded, color: accentPink, size: 22),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Form Subject Filter Pills
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(categories.length, (index) {
                  final isSelected = _selectedFormCategory == index;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(categories[index]),
                      selected: isSelected,
                      selectedColor: Colors.white,
                      backgroundColor: Colors.grey[100],
                      labelStyle: GoogleFonts.ibmPlexSansThai(
                        color: isSelected ? Colors.black87 : Colors.pinkAccent,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      onSelected: (bool selected) {
                        if (selected) {
                          setState(() => _selectedFormCategory = index);
                        }
                      },
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 20),

            _buildInputField(
              controller: _nameController,
              label: "Your Name",
              icon: Icons.person_outline,
              validator: (v) => v == null || v.isEmpty ? "Please enter your name" : null,
            ),
            const SizedBox(height: 16),
            _buildInputField(
              controller: _emailController,
              label: "Email Address",
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.isEmpty) return "Please enter your email";
                if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(v)) {
                  return "Please enter a valid email";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildInputField(
              controller: _phoneController,
              label: "Contact Number",
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: (v) => v == null || v.isEmpty ? "Please enter your mobile number" : null,
            ),
            const SizedBox(height: 16),

            // Service Choice Dropdown
            DropdownButtonFormField<String>(
              value: _serviceDr,
              isExpanded: true,
              dropdownColor: Colors.blue.shade600, // Background color for dropdown list items
              style: GoogleFonts.radley(fontSize: 14, color: Colors.black87),
              iconEnabledColor: Colors.blue.shade600,
              decoration: InputDecoration(
                labelText: "Select Service",
                labelStyle: GoogleFonts.ibmPlexSansThai(color: Colors.black54, fontSize: 14),
                prefixIcon: const Icon(Icons.cleaning_services_outlined, color: primaryBlue, size: 20),
                filled: true,
                fillColor: bgWhite,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.black12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: primaryBlue, width: 1.5),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.redAccent),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
                ),
              ),
              items: _servicesList.map((String service) {
                return DropdownMenuItem<String>(
                  value: service,
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(left: 10, right: 8),
                    child: Text(service, overflow: TextOverflow.ellipsis, style: GoogleFonts.radley(color: Colors.pink.shade300, fontSize: 14, fontWeight: FontWeight.w500,),),
                  ),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _serviceDr = newValue;
                });
              },
              validator: (v) => v == null || v.isEmpty ? "Please select a service" : null,
            ),
            const SizedBox(height: 16),

            _buildInputField(
              controller: _messageController,
              label: _selectedFormCategory == 1
                  ? "Describe your project requirements..."
                  : "How can we help you?",
              icon: Icons.chat_bubble_outline,
              maxLines: 4,
              validator: (v) => v == null || v.isEmpty ? "Please enter your message" : null,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: lightPink,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _isSubmitting ? null : _handleSubmit,
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: bgWhite)
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.near_me_rounded, color: accentPink, size: 22),
                    const SizedBox(width: 8),
                    Text("SUBMIT INQUIRY", style: GoogleFonts.radley(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.blue.shade600, letterSpacing: 1.1)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Interactive Contact Details Sidebar
  Widget _buildInteractiveContactSidebar() {
    return Column(
      children: [
        // Response time guarantee card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: primaryBlue,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: primaryBlue.withOpacity(0.25),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: bgWhite.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.timer_rounded, color: bgWhite, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Fast Response Guarantee",
                      style: GoogleFonts.radley(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: bgWhite,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "We usually respond within 2 working hours during business times.",
                      style: GoogleFonts.ibmPlexSansThai(
                        fontSize: 12,
                        color: bgWhite.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Interactive Cards for details
        _buildSidebarDetailCard(
          icon: Icons.location_on_rounded,
          title: "Visit Our Agency",
          subtitle: addressQuery,
          actionLabel: "Get Directions",
          onTap: () => _launchUrlString(googleDirectionsUrl),
        ),
        const SizedBox(height: 14),
        _buildSidebarDetailCard(
          icon: Icons.phone_in_talk_rounded,
          title: "Call Direct",
          subtitle: "+91 94085 18168",
          actionLabel: "Dial Now",
          onTap: () => _makePhoneCall(phoneNum),
        ),
        const SizedBox(height: 14),
        _buildSidebarDetailCard(
          icon: Icons.mark_email_read_rounded,
          title: "Email Support",
          subtitle: emailAddr,
          actionLabel: "Compose Email",
          onTap: () => _sendEmail(emailAddr),
        ),
        const SizedBox(height: 14),
        _buildSidebarDetailCard(
          icon: Icons.access_time_filled_rounded,
          title: "Working Hours",
          subtitle: "9:30 AM to 7:00 PM (Monday - Saturday)",
          actionLabel: "Status: Open Today",
          onTap: null,
          isStatusBadge: true,
        ),
      ],
    );
  }

  Widget _buildSidebarDetailCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String actionLabel,
    required VoidCallback? onTap,
    bool isStatusBadge = false,
  }) {
    return Material(
      color: bgWhite,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black.withOpacity(0.06)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: lightPink,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: accentPink, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.radley(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: primaryBlue,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.ibmPlexSansThai(
                        fontSize: 13,
                        color: Colors.black87,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          actionLabel,
                          style: GoogleFonts.ibmPlexSansThai(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isStatusBadge ? Colors.green[700] : accentPink,
                          ),
                        ),
                        if (!isStatusBadge) ...[
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_forward_rounded, size: 14, color: accentPink),
                        ]
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Maps Widget with Animated Radar Sweep Visual
  Widget _buildGoogleMapSection() {
    return Container(
      width: double.infinity,
      height: 380,
      decoration: BoxDecoration(
        color: bgWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Custom Visual Map Canvas with Radar Animation
            AnimatedBuilder(
              animation: _radarAnimationController,
              builder: (context, child) {
                return Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFE5E9EE), Color(0xFFCCD6E0)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _MapGridPainter(
                            animationValue: _radarAnimationController.value,
                          ),
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: accentPink.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: accentPink,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.location_on_rounded,
                                  size: 28,
                                  color: bgWhite,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            // Top Floating Business Overlay
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: bgWhite.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: lightPink,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.storefront_rounded,
                        color: primaryBlue,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Grow Socialee",
                                style: GoogleFonts.radley(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(
                                Icons.star_rounded,
                                size: 16,
                                color: Colors.amber,
                              ),
                              Text(
                                "4.9 (13)",
                                style: GoogleFonts.ibmPlexSansThai(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Leela Efcee, Waghawadi Rd, Bhavnagar",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.ibmPlexSansThai(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Map Action Controllers
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        foregroundColor: bgWhite,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 3,
                      ),
                      icon: const Icon(Icons.map_rounded, size: 18),
                      label: Text(
                        "View Map",
                        style: GoogleFonts.ibmPlexSansThai(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () => _launchUrlString(googleMapsUrl),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentPink,
                        foregroundColor: bgWhite,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 3,
                      ),
                      icon: const Icon(Icons.directions_rounded, size: 18),
                      label: Text("Get Directions", style: GoogleFonts.radley(fontSize: 13, fontWeight: FontWeight.bold)),
                      onPressed: () => _launchUrlString(googleDirectionsUrl),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      style: GoogleFonts.radley(fontSize: 14, color: Colors.black87),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.radley(color: Colors.black54, fontSize: 14),
        prefixIcon: Icon(icon, color: primaryBlue, size: 20),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryBlue, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
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
                style: GoogleFonts.ibmPlexSansThai(
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

// Map Custom Painter with animated pulse radar effect
class _MapGridPainter extends CustomPainter {
  final double animationValue;

  _MapGridPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Draw horizontal grid lines
    for (double i = 0; i < size.height; i += 35) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), gridPaint);
    }

    // Draw vertical grid lines
    for (double i = 0; i < size.width; i += 45) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), gridPaint);
    }

    // Draw angled roads
    final roadPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..strokeWidth = 6.0
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(0, size.height * 0.65),
      Offset(size.width, size.height * 0.35),
      roadPaint,
    );

    // Draw animated pulse radar wave
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width * 0.35;
    final currentRadius = maxRadius * animationValue;

    final radarPaint = Paint()
      ..color = const Color(0xFFE91E63).withOpacity((1 - animationValue) * 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawCircle(center, currentRadius, radarPaint);
  }

  @override
  bool shouldRepaint(covariant _MapGridPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}