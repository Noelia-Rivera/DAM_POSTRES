import '../../domain/entities/producto.dart';

class ProductoMockDataSource {
  Future<List<Producto>> getProductos() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    return [
      Producto(
        id: '1',
        nombre: 'Producto 1',
        precio: 0,
        categoria: 'Categoria 1',
      ),
      Producto(
        id: '2',
        nombre: 'Producto 2',
        precio: 0,
        categoria: 'Categoria 1',
      ),
      Producto(
        id: '3',
        nombre: 'Producto 3',
        precio: 0,
        categoria: 'Categoria 2',
      ),
      Producto(
        id: '4',
        nombre: 'Producto 4',
        precio: 0,
        categoria: 'Categoria 2',
      ),
    ];
  }

  Future<void> createProducto(Producto producto) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> updateProducto(Producto producto) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
