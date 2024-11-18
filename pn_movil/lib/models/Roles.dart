enum Role { admin, vendedor, cliente, guest }

class Permisos {
  static const Map<Role, List<String>> modulosAcceso = {
    Role.admin: [
      'home',
      'compras-solicitar',
      'realizar-pago',
      'listar',
      'clasificacion-productos',
      'productos',
      'crearProduct'
    ],
    Role.vendedor: [
      'home',
      'compras-solicitar',
      'clasificacion-productos',
      'productos',
    ],
    Role.cliente: [
      'home',
      'compras-solicitar',
    ],
    Role.guest: [],
  };

  static const Map<Role, List<String>> AccionesPermisos = {
    Role.admin: ['crear', 'editar', 'eliminar', 'visualizar'],
    Role.vendedor: ['crear', 'editar', 'visualizar'],
    Role.cliente: ['visualizar'],
    Role.guest: [],
  };
}
