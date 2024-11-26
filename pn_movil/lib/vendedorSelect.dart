         // Consumer<UserProvider>(
          //   builder: (context, userProvider, child) {
          //     if (userProvider.isLoading) {
          //       return const CircularProgressIndicator();
          //     }

          //     if (userProvider.usuarios.isEmpty) {
          //       return const Text("No hay vendedores disponibles");
          //     }

          //     final usuarios = userProvider.usuarios;

          //     final dropdownItems = usuarios.map((usuario) {
          //       return DropdownMenuItem<String>(
          //         value: usuario['id'].toString(),
          //         child: Text(usuario['nombre']),
          //       );
          //     }).toList();

          //     return Padding(
          //       padding: const EdgeInsets.symmetric(vertical: 10),
          //       child: InputDecorator(
          //         decoration: InputDecoration(
          //           labelText: 'Selecciona un Vendedor',
          //           border: OutlineInputBorder(
          //             borderRadius: BorderRadius.circular(12),
          //           ),
          //           filled: true,
          //           fillColor: Colors.grey[100]?.withOpacity(0.8),
          //           prefixIcon: const Icon(Icons.person),
          //         ),
          //         child: DropdownButton<String>(
          //           isExpanded: true,
          //           value: _proveedorSeleccionado,
          //           hint: const Text('Selecciona un vendedor'),
          //           onChanged: (String? newValue) {
          //             setState(() {
          //               _proveedorSeleccionado = newValue;
          //             });
          //           },
          //           items: dropdownItems,
          //         ),
          //       ),
          //     );
          //   },
          // ),
