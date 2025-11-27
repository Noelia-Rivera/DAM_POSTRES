import 'package:flutter/material.dart';

class RepartidorDashboardScreen extends StatelessWidget {
  const RepartidorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFAF8),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Encabezado
                _EncabezadoSection(),
                const SizedBox(height: 24),
                
                // Resumen del día
                _ResumenDelDiaSection(),
                const SizedBox(height: 24),
                
                // Notificaciones importantes
                _NotificacionesSection(),
                const SizedBox(height: 24),
                
                // Botón principal
                _BotonPrincipalSection(),
                const SizedBox(height: 24),
                
                // Acceso rápido
                _AccesoRapidoSection(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _BottomNavigationBar(),
    );
  }
}

// Encabezado con saludo personalizado
class _EncabezadoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hola, repartidor',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF8B4B3B),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Aquí tienes el resumen de tu día',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFFB8968C),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF0ED),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.cake_outlined,
            color: Color(0xFFD4A574),
            size: 28,
          ),
        ),
      ],
    );
  }
}

// Sección de resumen del día con tres cards
class _ResumenDelDiaSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ResumenCard(
            title: 'Pedidos entregados hoy',
            value: '3',
            icon: Icons.inventory_2_outlined,
            backgroundColor: const Color(0xFFFFF0ED),
            iconColor: const Color(0xFFD4A574),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ResumenCard(
            title: 'Ganancias del día',
            value: 'S/ 56.00',
            icon: Icons.attach_money_rounded,
            backgroundColor: const Color(0xFFFFF8F0),
            iconColor: const Color(0xFFE8B86D),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ResumenCard(
            title: 'Pedidos activos',
            value: '1',
            icon: Icons.access_time_rounded,
            backgroundColor: const Color(0xFFF8FFF8),
            iconColor: const Color(0xFFB8D4A8),
          ),
        ),
      ],
    );
  }
}

// Card individual del resumen
class _ResumenCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  const _ResumenCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B4B3B).withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF8B4B3B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: const Color(0xFFB8968C),
              fontSize: 11,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// Sección de notificaciones importantes
class _NotificacionesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8F5),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B4B3B).withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0ED),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.notifications_active_outlined,
                  color: Color(0xFFD4A574),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Notificaciones importantes',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF8B4B3B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _NotificationItem(text: 'Tienes nuevos pedidos disponibles'),
          _NotificationItem(text: 'Tu turno empezó hace 15 minutos'),
          _NotificationItem(text: 'Recuerda actualizar tus datos'),
        ],
      ),
    );
  }
}

// Item individual de notificación
class _NotificationItem extends StatelessWidget {
  final String text;

  const _NotificationItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFFD4A574),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF8B4B3B),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Botón principal destacado
class _BotonPrincipalSection extends StatefulWidget {
  @override
  State<_BotonPrincipalSection> createState() => _BotonPrincipalSectionState();
}

class _BotonPrincipalSectionState extends State<_BotonPrincipalSection> {
  bool enTurno = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: (enTurno ? const Color(0xFF4CAF50) : const Color(0xFFD4A574))
                .withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: FilledButton.icon(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 18),
          backgroundColor: enTurno ? const Color(0xFF4CAF50) : const Color(0xFFD4A574),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 0,
        ),
        onPressed: () {
          setState(() {
            enTurno = !enTurno;
          });
        },
        icon: Icon(
          enTurno ? Icons.stop_circle_outlined : Icons.play_circle_fill_rounded,
          size: 28,
          color: Colors.white,
        ),
        label: Text(
          enTurno ? 'Finalizar turno' : 'Iniciar turno',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// Sección de acceso rápido
class _AccesoRapidoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickActionCard(
            title: 'Pedidos disponibles',
            icon: Icons.format_list_bulleted_rounded,
            backgroundColor: const Color(0xFFFFF8F5),
            iconColor: const Color(0xFFD4A574),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _QuickActionCard(
            title: 'Mi último pedido',
            icon: Icons.location_on_outlined,
            backgroundColor: const Color(0xFFF8FFF8),
            iconColor: const Color(0xFFB8D4A8),
          ),
        ),
      ],
    );
  }
}

// Card de acceso rápido
class _QuickActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  const _QuickActionCard({
    required this.title,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B4B3B).withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF8B4B3B),
            ),
          ),
        ],
      ),
    );
  }
}

// Barra de navegación inferior
class _BottomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B4B3B).withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _BottomNavItem(
                icon: Icons.home_filled,
                label: 'Inicio',
                selected: true,
              ),
              _BottomNavItem(
                icon: Icons.receipt_long_outlined,
                label: 'Pedidos',
              ),
              _BottomNavItem(
                icon: Icons.person_outline,
                label: 'Perfil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Item de navegación inferior
class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? const Color(0xFFD4A574) : const Color(0xFFB8968C);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFFFF0ED) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: color,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
