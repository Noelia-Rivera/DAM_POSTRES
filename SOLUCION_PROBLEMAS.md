# Solución de Problemas - Conexión API y Restricciones

## ✅ Problemas Solucionados

### 1. **Rutas sin Protección**
   - **Problema**: Podías acceder a `/home`, `/pedidos`, `/profile`, `/admin/agregar`, `/admin/categorias` sin autenticación
   - **Solución**: Todas las rutas ahora están protegidas con `AuthGuard`

### 2. **CORS en Backend**
   - **Problema**: El backend solo permitía CORS desde `localhost:4200` (Angular)
   - **Solución**: Actualizado `SecurityConfig.java` para permitir cualquier puerto de localhost (Flutter Web)

### 3. **Verificación de Sesión**
   - **Problema**: No se verificaba la sesión al iniciar la app
   - **Solución**: `WelcomeScreen` ahora verifica si hay sesión guardada y redirige automáticamente

## 🔒 Rutas Protegidas

Todas estas rutas ahora requieren autenticación:

- `/home` - Requiere autenticación
- `/cliente` - Requiere autenticación + rol CLIENTE
- `/admin` - Requiere autenticación + rol ADMIN
- `/admin/agregar` - Requiere autenticación + rol ADMIN
- `/admin/categorias` - Requiere autenticación + rol ADMIN
- `/repartidor` - Requiere autenticación + rol REPARTIDOR
- `/pedidos` - Requiere autenticación
- `/profile` - Requiere autenticación

## 🚀 Pasos para Probar

1. **Reinicia el Backend** (importante para aplicar cambios de CORS):
   ```bash
   cd postresAPI
   mvn spring-boot:run
   ```

2. **Verifica que el backend esté corriendo**:
   - Abre: `http://localhost:9090/api/v1/auth/login` en el navegador
   - Debería dar error 405 (Method Not Allowed) porque es GET, pero confirma que el servidor responde

3. **Ejecuta Flutter**:
   ```bash
   cd DAM_POSTRES
   flutter run
   ```

4. **Intenta acceder sin login**:
   - Intenta ir directamente a `/admin` o `/cliente` desde la URL
   - Debería redirigirte automáticamente a `/login`

5. **Prueba el login**:
   - Username: `admin`
   - Password: `password` (según la imagen)
   - Deberías ver en la consola:
     - `🔗 [AUTH] Intentando conectar a: ...`
     - `📡 [AUTH] Respuesta recibida: 200`
     - `✅ [AUTH] Login exitoso para usuario: admin`

## 🐛 Debug

Si no funciona, revisa la consola de Flutter:

- **Si ves `🔗 [AUTH] Intentando conectar`**: La app está intentando conectar
- **Si ves `❌ [AUTH]`**: Hay un error, revisa el mensaje
- **Si NO ves ningún mensaje**: El login no se está ejecutando

### Errores Comunes:

1. **"Tiempo de espera agotado"**:
   - El backend no está corriendo
   - La URL está mal configurada en `api_config.dart`

2. **"Servicio no encontrado"**:
   - Verifica que el backend esté en el puerto 9090
   - Verifica la URL en `lib/core/config/api_config.dart`

3. **Error de CORS (solo en web)**:
   - Asegúrate de haber reiniciado el backend después de cambiar `SecurityConfig.java`

4. **"Credenciales inválidas"**:
   - Verifica username: `admin` y password: `password`
   - O las credenciales que tengas en tu base de datos

## 📝 Configuración de URL

Edita `lib/core/config/api_config.dart` según tu entorno:

- **Flutter Web**: `http://localhost:9090` ✅
- **Android Emulador**: `http://10.0.2.2:9090`
- **Dispositivo Físico**: `http://TU_IP:9090` (ej: `http://192.168.1.100:9090`)

## ✅ Verificación Final

Después de hacer login:
1. ✅ Deberías ser redirigido según tu rol
2. ✅ Si intentas ir a otra ruta protegida sin el rol correcto, debería redirigirte
3. ✅ Si cierras sesión, no deberías poder acceder a rutas protegidas
4. ✅ La sesión se guarda, así que si cierras y abres la app, deberías seguir logueado


