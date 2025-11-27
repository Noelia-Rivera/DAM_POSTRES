# Servicios API - PostresAPI

Este documento describe cómo usar los servicios CRUD conectados al backend.

## Configuración Base
- URL Base: `http://localhost:9090`
- Todos los endpoints usan el prefijo `/api/v1/`

## Uso Rápido

```dart
import 'package:dam_postres/core/services/api_services.dart';

// Usar cualquier repositorio
final categorias = await ApiServices.categoriaRepository.getCategorias();
final productos = await ApiServices.productoRepository.getProductos();
final pedidos = await ApiServices.pedidoRepository.getPedidos();
```

## Endpoints Disponibles

### 🔐 Auth (`/api/v1/auth`)
| Método | Endpoint | Descripción |
|--------|----------|-------------|
| POST | `/login` | Login de usuario |
| POST | `/register` | Registro de cliente |
| POST | `/registerAdmin` | Registro de admin |
| POST | `/registerRepartidor` | Registro de repartidor (ADMIN) |
| POST | `/refresh` | Refrescar token |
| POST | `/logout` | Cerrar sesión |
| POST | `/uploadProfileImage/{id}` | Subir foto de perfil |

### 📦 Categorías (`/api/v1/categorias`)
| Método | Endpoint | Descripción |
|--------|----------|-------------|
| GET | `/` | Listar categorías |
| GET | `/{id}` | Obtener por ID |
| POST | `/` | Crear (ADMIN) |
| PUT | `/{id}` | Actualizar (ADMIN) |
| DELETE | `/{id}` | Eliminar (ADMIN) |

### 🍰 Productos (`/api/v1/productos`)
| Método | Endpoint | Descripción |
|--------|----------|-------------|
| GET | `/` | Listar productos |
| GET | `/{id}` | Obtener por ID |
| POST | `/` | Crear (ADMIN) |
| PUT | `/{id}` | Actualizar (ADMIN) |
| DELETE | `/{id}` | Eliminar (ADMIN) |
| POST | `/uploadImage/{id}` | Subir imagen |
| POST | `/createWithImage` | Crear con imagen |

### 📋 Pedidos (`/api/v1/pedidos`)
| Método | Endpoint | Descripción |
|--------|----------|-------------|
| GET | `/` | Listar pedidos |
| GET | `/{id}` | Obtener por ID |
| GET | `/{id}/detalle` | Obtener detalle |
| POST | `/create` | Crear (CLIENTE) |
| POST | `/` | Crear (ADMIN) |
| PUT | `/{id}` | Actualizar (ADMIN) |
| DELETE | `/{id}` | Eliminar (ADMIN) |
| GET | `/cliente/mis-pedidos` | Mis pedidos (CLIENTE) |
| GET | `/repartidor/mis-pedidos` | Mis pedidos (REPARTIDOR) |
| PUT | `/{id}/aceptar` | Aceptar (ADMIN) |
| PUT | `/{id}/en-preparacion` | En preparación (ADMIN) |
| PUT | `/{id}/listo-para-entrega` | Listo (ADMIN) |
| PUT | `/{id}/asignar/{repartidorId}` | Asignar repartidor (ADMIN) |
| PUT | `/{id}/cancelar` | Cancelar (ADMIN) |
| PUT | `/{id}/iniciar-entrega` | Iniciar entrega (REPARTIDOR) |
| PUT | `/{id}/entregado` | Marcar entregado (REPARTIDOR) |
| PUT | `/{id}/estado/{estadoId}` | Actualizar estado |
| POST | `/{id}/detalles/agregar` | Agregar detalles (CLIENTE) |

### 👤 Personas (`/api/v1/personas`)
| Método | Endpoint | Descripción |
|--------|----------|-------------|
| GET | `/` | Listar personas |
| GET | `/{id}` | Obtener por ID |
| POST | `/` | Crear (ADMIN) |
| PUT | `/{id}` | Actualizar (ADMIN) |
| DELETE | `/{id}` | Eliminar (ADMIN) |

### 🚴 Repartidores (`/api/v1/repartidores`)
| Método | Endpoint | Descripción |
|--------|----------|-------------|
| GET | `/` | Listar repartidores |
| GET | `/{id}` | Obtener por ID |
| POST | `/` | Crear (ADMIN) |
| PUT | `/{id}` | Actualizar (ADMIN) |
| DELETE | `/{id}` | Eliminar (ADMIN) |

### 🔑 Roles (`/api/v1/roles`)
| Método | Endpoint | Descripción |
|--------|----------|-------------|
| GET | `/` | Listar roles |
| GET | `/{id}` | Obtener por ID |
| POST | `/` | Crear (ADMIN) |
| PUT | `/{id}` | Actualizar (ADMIN) |
| DELETE | `/{id}` | Eliminar (ADMIN) |

### 👥 Usuarios (`/api/v1/usuarios`)
| Método | Endpoint | Descripción |
|--------|----------|-------------|
| PUT | `/{id}/perfil` | Asignar perfil (ADMIN) |

## Ejemplos de Uso

### Categorías
```dart
// Listar
final categorias = await ApiServices.categoriaRepository.getCategorias();

// Crear
await ApiServices.categoriaRepository.createCategoria(
  Categoria(id: '', nombre: 'Tortas'),
);

// Actualizar
await ApiServices.categoriaRepository.updateCategoria(
  Categoria(id: '1', nombre: 'Postres'),
);

// Eliminar
await ApiServices.categoriaRepository.deleteCategoria('1');
```

### Productos
```dart
// Listar
final productos = await ApiServices.productoRepository.getProductos();

// Crear
await ApiServices.productoRepository.createProducto(
  Producto(
    id: '',
    nombre: 'Cheesecake',
    precio: 25.5,
    descripcion: 'Delicioso',
    categoria: 'Tortas',
    categoriaId: '1',
  ),
);
```

### Pedidos
```dart
// Crear pedido como cliente
final pedido = await ApiServices.pedidoRepository.createPedidoCliente(
  Pedido(
    id: '',
    nombreUsuario: '',
    apodo: '',
    costoTotal: 99.9,
    fechaPedido: DateTime.now(),
    fechaEntrega: DateTime.now().add(Duration(days: 1)),
    repartidor: '',
    direccion: 'Calle 123',
  ),
  [
    {'idProducto': 1, 'cantidad': 2},
  ],
);

// Mis pedidos
final misPedidos = await ApiServices.pedidoRepository.getMisPedidosCliente();

// Cambiar estado (ADMIN)
await ApiServices.pedidoRepository.aceptarPedido('1');
await ApiServices.pedidoRepository.marcarEnPreparacion('1');
await ApiServices.pedidoRepository.asignarRepartidor('1', '2');

// Acciones de repartidor
await ApiServices.pedidoRepository.iniciarEntrega('1');
await ApiServices.pedidoRepository.marcarEntregado('1');
```

### Personas
```dart
// Crear persona
final persona = await ApiServices.personaRepository.createPersona(
  Persona(
    id: '',
    nombres: 'Juan',
    apellidos: 'Pérez',
    dni: '12345678',
    correo: 'juan@email.com',
    telefono: '999888777',
    direccion: 'Av. Principal 123',
  ),
);
```

### Roles
```dart
// Listar roles
final roles = await ApiServices.rolRepository.getRoles();

// Crear rol
await ApiServices.rolRepository.createRol(
  Rol(id: '', nombre: 'SUPERVISOR'),
);
```
