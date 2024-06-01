import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../models/user_model.dart';

class SettingsPage extends StatefulWidget {
  final UserModel user;

  const SettingsPage({super.key, required this.user});

  @override
  // ignore: library_private_types_in_public_api
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController _fullnameController;
  late TextEditingController _emailController;
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    _fullnameController = TextEditingController(text: widget.user.fullname);
    _emailController = TextEditingController(text: widget.user.email);
    _selectedGender = widget.user.gender;
  }

  @override
  void dispose() {
    _fullnameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.user.uid)
          .update({
        'fullname': _fullnameController.text,
        'email': _emailController.text,
        'gender': _selectedGender,
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ayarlar güncellendi')),
      );

      // Update local user model after successful save
      setState(() {
        widget.user.fullname = _fullnameController.text;
        widget.user.email = _emailController.text;
        widget.user.gender = _selectedGender ?? widget.user.gender;
      });
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ayarlar güncellenirken bir hata oluştu')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              label: 'Ad Soyad',
              controller: _fullnameController,
              hintText: 'Ad Soyad',
              icon: Icons.person,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'E-posta',
              controller: _emailController,
              hintText: 'E-posta',
              icon: Icons.email,
            ),
            const SizedBox(height: 16),
            const Text('Cinsiyet',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4C53A5),
                )),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: const Color(0xFFE0F7FA),
              ),
              child: DropdownButton<String>(
                value: _selectedGender,
                isExpanded: true,
                underline: const SizedBox(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGender = newValue;
                  });
                },
                items: <String>['Erkek', 'Kadın', 'Diğer']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text('Değişiklikleri Kaydet'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4C53A5),
            )),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: const Color(0xFFE0F7FA),
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(color: Color(0xFF4C53A5)),
              border: InputBorder.none,
              prefixIcon: Icon(icon, color: const Color(0xFF4C53A5)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            style: const TextStyle(color: Color(0xFF4C53A5)),
          ),
        ),
      ],
    );
  }
}
