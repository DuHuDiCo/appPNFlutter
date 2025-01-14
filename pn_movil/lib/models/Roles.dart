enum Role { admin, vendedor, guest }

class Permisos {
  // Este mapa ahora asigna módulos y sus permisos específicos.
  static const Map<Role, Map<String, List<String>>> modulosAcceso = {
    Role.admin: {
      'home': ['visualizar'],
      'compras-solicitar': ['visualizar', 'crear', 'editar', 'eliminar'],
      'compras-solicitar-crear': ['crear'],
      'compras-solicitar-editar': ['editar'],
      'compras-solicitar-detalle': ['visualizar'],
      'compras-solicitar-agregar-flete': ['editar'],
      'realizar-pago': ['crear'],
      'crear-pago': ['crear'],
      'pagos-clientes': ['visualizar', 'crear'],
      'crear-pagos-clientes': ['crear'],
      'facturacion': ['visualizar', 'crear'],
      'productos-sin-facturacion': ['visualizar'],
      'productos-facturacion-detalle': ['visualizar'],
      'inventario': ['visualizar', 'editar'],
      'detalle-inventario': ['visualizar'],
      'crear-plan-pago': ['crear'],
      'plan-pago': ['visualizar', 'editar'],
      'tipo-venta': ['crear', 'visualizar'],
      'abono-normal': ['crear'],
      'resumen-cuenta': ['visualizar'],
      'clasificacion-productos': ['editar'],
      'productos': ['visualizar', 'editar'],
      'crearProduct': ['crear'],
    },
    Role.vendedor: {
      'home': ['visualizar'],
      'compras-solicitar': ['visualizar', 'crear'],
      'clasificacion-productos': ['editar'],
      'productos': ['visualizar'],
    },
    Role.guest: {
      'home': ['visualizar'],
    },
  };

  static bool tienePermiso(Role role, String modulo, String accion) {
    return modulosAcceso[role]?[modulo]?.contains(accion) ?? false;
  }
}
