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



//botton guardar ultima vista de compras 

            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       SizedBox(
            //         width: 160,
            //         child: ElevatedButton(
            //           onPressed: () {},
            //           style: ElevatedButton.styleFrom(
            //             backgroundColor: const Color.fromARGB(255, 12, 12, 12),
            //           ),
            //           child: Text(
            //             'Total: ',
            //             style: const TextStyle(
            //               color: Color.fromARGB(255, 244, 245, 246),
            //             ),
            //           ),
            //         ),
            //       ),
            //       const SizedBox(width: 20),
            //       SizedBox(
            //         width: 160,
            //         child: ElevatedButton(
            //           onPressed: null,
            //           style: ElevatedButton.styleFrom(
            //             backgroundColor: Colors.blue.shade700,
            //             disabledForegroundColor:
            //                 Colors.blue.shade200.withOpacity(0.38),
            //             disabledBackgroundColor:
            //                 const Color.fromARGB(255, 33, 119, 189)
            //                     .withOpacity(0.12),
            //           ),
            //           child: const Text(
            //             'Guardar',
            //             style: TextStyle(
            //               color: Color.fromARGB(255, 255, 255, 255),
            //             ),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),