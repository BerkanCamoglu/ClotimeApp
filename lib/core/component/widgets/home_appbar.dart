import 'package:clotimeapp/view/authentication/login/login_view.dart';
import 'package:flutter/material.dart';
import '../../../service/auth_service.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  Future<void> _logout(BuildContext context) async {
    await AuthService().signOut();
    await Navigator.pushAndRemoveUntil(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(
        builder: (context) => const LoginView(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        "Clotime",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF4C53A5),
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () => _logout(context),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
