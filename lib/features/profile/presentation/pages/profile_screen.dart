import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pinkColor = const Color(0xFFD7B3AF);
    final beigeColor = const Color(0xFFE8DAB6);
    final greenColor = const Color(0xFFBACB95);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: pinkColor,
        title: const Text(
          'Mi perfil',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
        elevation: 2,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 24),

            Stack(
              alignment: Alignment.bottomRight,
              children: [
                const CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(
                    'https://cdn-icons-png.flaticon.com/512/706/706830.png',
                  ),
                  backgroundColor: Colors.white,
                ),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: pinkColor, width: 2),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt, size: 16),
                    color: pinkColor,
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            const Text(
              'USUARIO',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            const Text(
              'usuario@gmail.com',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),

            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Información personal',
                          style: TextStyle(
                            color: pinkColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Icon(Icons.edit, color: pinkColor),
                      ],
                    ),
                    const SizedBox(height: 20),

                    const _InputField(
                      icon: Icons.person_outline,
                      label: 'Nombres',
                    ),
                    const SizedBox(height: 16),
                    const _InputField(
                      label: 'Apellidos',
                    ),
                    const SizedBox(height: 16),
                    const _InputField(
                      icon: Icons.location_on_outlined,
                      label: 'Dirección',
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: const [
                        Expanded(
                          child: _InputField(
                            icon: Icons.credit_card_outlined,
                            label: 'Doc. Identidad',
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _InputField(
                            icon: Icons.phone_outlined,
                            label: 'Teléfono',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: beigeColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {},
                        child: const Text(
                          'Guardar cambios',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: greenColor.withOpacity(0.3),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {},
                        child: const Text(
                          'Eliminar cuenta',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: pinkColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        showUnselectedLabels: true,
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) Navigator.pop(context);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home Page'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: 'Pedidos'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Mi Perfil'),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final String label;
  final IconData? icon;

  const _InputField({required this.label, this.icon});

  @override
  Widget build(BuildContext context) {
    final borderColor = const Color(0xFFD7B3AF);

    return TextField(
      decoration: InputDecoration(
        prefixIcon:
            icon != null ? Icon(icon, color: borderColor) : const SizedBox(),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFFF7F1F1),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor.withOpacity(0.4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor, width: 2),
        ),
      ),
    );
  }
}
