import 'package:flutter/material.dart';

const months = [
  'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 
  'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
];

String getDateString(DateTime date) => '${date.day} de ${getMonthName(date.month)}, ${date.year}';
String getMonthName(int month) => months[month - 1];

Future showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String message,
  required VoidCallback onConfirm, // Función que se ejecutará si el usuario confirma
  String cancelButtonText = 'Cancelar',
  String confirmButtonText = 'Aceptar',
}) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text('¿Seguro que desea $message?'),
        actions: <Widget>[
          TextButton(
            child: Text(cancelButtonText),
            onPressed: () {
              Navigator.of(context).pop(); // Cierra el diálogo sin hacer nada
            },
          ),
          TextButton(
            child: Text(confirmButtonText),
            onPressed: () {
              Navigator.of(context).pop(); // Cierra el diálogo
              onConfirm(); // Ejecuta la función proporcionada al confirmar
            },
          ),
        ],
      );
    },
  );
}

Widget getAddButton(
  BuildContext context,
  VoidCallback onPressed,
  String text
) {
  return FloatingActionButton.extended(
    onPressed: onPressed,
    isExtended: MediaQuery.of(context).size.width > 600,
    label: Text('Añadir $text'),
    tooltip: MediaQuery.of(context).size.width > 600 ? '' : 'Añadir $text',
    icon: const Icon(Icons.add),
  );
}