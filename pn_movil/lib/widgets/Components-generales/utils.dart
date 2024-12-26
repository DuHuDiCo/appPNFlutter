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


//SwitchListTile de descuento inicial y de estimar flete
                      // SwitchListTile(
                      //   title: const Text('Estimar Flete'),
                      //   value: estimarFlete,
                      //   onChanged: (value) {
                      //     setState(() {
                      //       estimarFlete = value;
                      //     });
                      //   },
                      //   activeColor: Colors.blue.shade800,
                      //   contentPadding: EdgeInsets.zero,
                      // ),
                      // SwitchListTile(
                      //   title: const Text('Descuento Inicial'),
                      //   value: isDescuentoInicial,
                      //   onChanged: (value) {
                      //     setState(() {
                      //       isDescuentoInicial = value;
                      //     });
                      //   },
                      //   activeColor: Colors.blue.shade800,
                      //   contentPadding: EdgeInsets.zero,
                      // ),


  //Plan de pago

    // final TextEditingController _periocidadController = TextEditingController();
  // final TextEditingController _cuotasController = TextEditingController();
  // final TextEditingController _valorCuotaController = TextEditingController();
  // final TextEditingController _fechaCorteController = TextEditingController();
  // DateTime? _selectedDate;

  //   @override
  // void dispose() {
  //   _periocidadController.dispose();
  //   _cuotasController.dispose();
  //   _valorCuotaController.dispose();
  //   _fechaCorteController.dispose();
  //   super.dispose();
  // }


              //          Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     // Primer TextFormField
              //     Expanded(
              //       child: TextFormField(
              //         controller: _fechaCorteController,
              //         readOnly: true,
              //         decoration: InputDecoration(
              //           labelText: 'Fecha de corte',
              //           border: OutlineInputBorder(
              //             borderRadius: BorderRadius.circular(8),
              //           ),
              //           suffixIcon: Icon(Icons.calendar_today),
              //         ),
              //         onTap: () async {
              //           final selectedDate = await showDatePicker(
              //             context: context,
              //             initialDate: DateTime.now(),
              //             firstDate: DateTime(2000),
              //             lastDate: DateTime(2025),
              //           );

              //           if (selectedDate != null) {
              //             setState(() {
              //               _selectedDate = selectedDate;
              //               _fechaCorteController.text =
              //                   "${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}";
              //             });
              //           }
              //         },
              //       ),
              //     ),
              //     const SizedBox(width: 20),
              //     // Segundo TextFormField
              //     Expanded(
              //       child: TextFormField(
              //         controller: _periocidadController,
              //         keyboardType: TextInputType.number,
              //         decoration: InputDecoration(
              //           labelText: 'Periocidad',
              //           border: OutlineInputBorder(
              //             borderRadius: BorderRadius.circular(8),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              // const SizedBox(height: 20),
              // TextFormField(
              //   controller: _cuotasController,
              //   keyboardType: TextInputType.number,
              //   decoration: InputDecoration(
              //     labelText: 'Número de cuotas',
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(8),
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 20),
              // TextFormField(
              //   controller: _valorCuotaController,
              //   keyboardType: TextInputType.number,
              //   decoration: InputDecoration(
              //     labelText: 'Valor de cada cuota',
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(8),
              //     ),
              //   ),
              // ),