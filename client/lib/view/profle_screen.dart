import 'package:client/core/services/session_manager.dart';
import 'package:client/view/login_screen.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController(text: "Pankaj Ram");
  final emailController = TextEditingController(text: "pankaj@gmail.com");
  final phoneController = TextEditingController(text: "+91 98765 43210");
  final roleController = TextEditingController(text: "Admin");

  bool isEditing = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    roleController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() => isEditing = !isEditing);

    if (!isEditing) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Profile Updated Successfully")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isMobile = size.width < 800;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("Profile"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        automaticallyImplyLeading: isMobile,
        actions: [
          TextButton.icon(
            onPressed: _toggleEdit,
            icon: Icon(isEditing ? Icons.save : Icons.edit),
            label: Text(isEditing ? "Save" : "Edit"),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: isMobile ? _mobileLayout() : _webLayout(),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- WEB Layout ----------------
  Widget _webLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 3, child: _profileCard()),
        const SizedBox(width: 18),
        Expanded(flex: 5, child: _profileForm()),
      ],
    );
  }

  // ---------------- Mobile Layout ----------------
  Widget _mobileLayout() {
    return Column(
      children: [_profileCard(), const SizedBox(height: 18), _profileForm()],
    );
  }

  // ---------------- PROFILE CARD ----------------
  Widget _profileCard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage("https://i.pravatar.cc/300"),
          ),
          const SizedBox(height: 14),
          Text(
            nameController.text,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          Text(
            roleController.text,
            style: const TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 18),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.camera_alt_outlined),
              label: const Text("Change Photo"),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () async {
                await SessionManager.instance.logout().then((_) {
                  if (!mounted) return;

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Logout clicked")),
                  );
                });
              },
              icon: const Icon(Icons.logout_rounded),
              label: const Text("Logout"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- PROFILE FORM ----------------
  Widget _profileForm() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Profile Details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 16),

            _inputField(
              label: "Full Name",
              controller: nameController,
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 14),

            _inputField(
              label: "Email",
              controller: emailController,
              icon: Icons.email_outlined,
              keyboard: TextInputType.emailAddress,
            ),
            const SizedBox(height: 14),

            _inputField(
              label: "Phone",
              controller: phoneController,
              icon: Icons.phone_outlined,
              keyboard: TextInputType.phone,
            ),
            const SizedBox(height: 14),

            _inputField(
              label: "Role",
              controller: roleController,
              icon: Icons.badge_outlined,
            ),

            const SizedBox(height: 24),

            const Divider(),

            const SizedBox(height: 14),

            // Change Password section
            const Text(
              "Security",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Change Password clicked"),
                          ),
                        );
                      },
                      icon: const Icon(Icons.lock_reset_rounded),
                      label: const Text("Change Password"),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color(0xFF1D4ED8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      enabled: isEditing,
      keyboardType: keyboard,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: isEditing
            ? const Color(0xFFF9FAFB)
            : const Color(0xFFF3F4F6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "$label is required";
        }
        return null;
      },
    );
  }
}
