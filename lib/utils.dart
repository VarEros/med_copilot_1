const months = [
  'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 
  'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
];

String getDateString(DateTime date) => '${date.day} de ${getMonthName(date.month)}, ${date.year}';
String getMonthName(int month) => months[month - 1];
