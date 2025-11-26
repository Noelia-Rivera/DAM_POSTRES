import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/pedido_bloc.dart';
import '../widgets/pedido_card.dart';
import '../../domain/entities/pedido.dart';

class PedidosScreen extends StatefulWidget {
  const PedidosScreen({super.key});

  @override
  State<PedidosScreen> createState() => _PedidosScreenState();
}

class _PedidosScreenState extends State<PedidosScreen> {
  @override
  void initState() {
    super.initState();
    // Load pedidos when the screen initializes
    context.read<PedidoBloc>().add(LoadPedidos());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // Open drawer or menu
          },
        ),
        title: const Text('Pedidos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {
              // Navigate to notifications
            },
          ),
        ],
      ),
      body: BlocBuilder<PedidoBloc, PedidoState>(
        builder: (context, state) {
          if (state is PedidoLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PedidoError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is PedidoLoaded) {
            if (state.pedidos.isEmpty) {
              return const Center(child: Text('No hay pedidos disponibles'));
            }
            // For demo purposes, showing the first pedido
            // In a real app, you might want to show a list of pedidos
            final pedido = state.pedidos.first;
            return SingleChildScrollView(
              child: PedidoCard(
                pedido: pedido,
                onConfirmar: () {
                  // Handle confirm button press
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pedido confirmado')),
                  );
                },
              ),
            );
          }
          return const Center(child: Text('Selecciona un pedido'));
        },
      ),
    );
  }
}
