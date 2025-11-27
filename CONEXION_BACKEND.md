# Configuración de Conexión al Backend

## Problema del Error de Assertion

El error `element._lifecycleState == _ElementLifecycle.inactive is not true` se ha solucionado removiendo el `redirect` asíncrono del router y usando `AuthGuard` widgets en su lugar.

## Configuración de la URL del Backend

El archivo `lib/core/config/api_config.dart` contiene la configuración de la URL del backend.

### Para diferentes entornos:

1. **Flutter Web (localhost)**: 
   ```dart
   static const String baseUrl = 'http://localhost:9090';
   ```

2. **Android Emulador**: 
   ```dart
   static const String baseUrl = 'http://10.0.2.2:9090';
   ```

3. **Dispositivo Físico**: 
   ```dart
   static const String baseUrl = 'http://TU_IP_LOCAL:9090';
   ```
   Ejemplo: `http://192.168.1.100:9090`

## Problema de CORS

Si estás ejecutando Flutter Web, el backend necesita permitir CORS desde el puerto donde corre Flutter.

El backend actualmente solo permite: `http://localhost:4200`

**Solución temporal (si tienes acceso al backend):**
En `SecurityConfig.java`, cambiar:
```java
config.addAllowedOrigin("http://localhost:4200");
```
Por:
```java
config.addAllowedOriginPattern("http://localhost:*"); // Permite cualquier puerto de localhost
```

O agregar el puerto específico de Flutter web (generalmente 8080 o similar).

## Verificación de Conexión

1. Asegúrate de que el backend Spring Boot esté corriendo en el puerto 9090
2. Verifica que puedas acceder a: `http://localhost:9090/api/v1/auth/login` desde tu navegador (debería dar un error 405 Method Not Allowed, lo cual es normal para GET)
3. Revisa la consola de Flutter para ver los mensajes de debug que muestran la URL a la que intenta conectar

## Credenciales de Prueba

Según la colección de Postman:
- Username: `admin`
- Password: `admin123` (o `password` según la imagen proporcionada)

## Solución de Problemas

### Error: "Tiempo de espera agotado"
- Verifica que el backend esté corriendo
- Verifica que la URL en `api_config.dart` sea correcta para tu entorno
- Verifica tu conexión a internet

### Error: "Servicio no encontrado"
- Verifica que el backend esté en el puerto 9090
- Verifica la URL en `api_config.dart`

### Error de CORS en Web
- El backend necesita permitir el origen de Flutter web
- Ver sección "Problema de CORS" arriba


