// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// void showDatePickerSheet(BuildContext context, DateTime dateTime,
//     Function(DateTime) onDateTimeChanged, Function() onSave) {
//   showModalBottomSheet(
//     context: context,
//     builder: (context) {
//       return SizedBox(
//         height: 300,
//         width: double.infinity,
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Expanded(
//                 child: CupertinoDatePicker(
//                   initialDateTime: dateTime,
//                   minimumYear: 2024,
//                   onDateTimeChanged: onDateTimeChanged,
//                   mode: CupertinoDatePickerMode.dateAndTime,
//                 ),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   onSave();
//                 },
//                 child: const Text("Save"),
//               ),
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }

// void showCustomBottomSheet(
//     BuildContext context,
//     TextEditingController textController,
//     TextEditingController descriptionTextController,
//     DateTime dateTime,
//     List<String> categories,
//     String selectedValue,
//     Function(String) onCategoryChanged,
//     Function() onDatePicker,
//     Function() onSave) {
//   showModalBottomSheet(
//     context: context,
//     showDragHandle: true,
//     elevation: 0,
//     builder: (context) {
//       return SizedBox(
//         height: 300,
//         width: double.infinity,
//         child: Padding(
//           padding: const EdgeInsets.only(left: 12),
//           child: Column(
//             children: [
//               TextField(
//                 style: const TextStyle(fontSize: 22),
//                 controller: textController,
//                 decoration: const InputDecoration(
//                   hintText: "Add a new ToDo",
//                   hintStyle: TextStyle(fontSize: 22, color: Colors.grey),
//                   border: InputBorder.none,
//                   enabledBorder: InputBorder.none,
//                 ),
//                 keyboardType: TextInputType.name,
//               ),
//               TextField(
//                 style: const TextStyle(fontSize: 18),
//                 controller: descriptionTextController,
//                 decoration: const InputDecoration(
//                   hintText: "Description",
//                   hintStyle: TextStyle(fontSize: 18, color: Colors.grey),
//                   border: InputBorder.none,
//                   enabledBorder: InputBorder.none,
//                 ),
//               ),
//               Row(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(top: 12),
//                     child: ElevatedButton.icon(
//                       onPressed: onDatePicker,
//                       label: const Text("Bitiş Tarihi seç"),
//                       icon: const Icon(Icons.flag),
//                     ),
//                   ),
//                 ],
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 12),
//                 child: Align(
//                   alignment: Alignment.bottomLeft,
//                   child: DropdownButton<String>(
//                     value: categories.contains(selectedValue)
//                         ? selectedValue
//                         : null,
//                     onChanged: (String? newValue) {
//                       onCategoryChanged(newValue ?? "");
//                     },
//                     hint: const Text('Kategori seçin'),
//                     items: categories.map((String category) {
//                       return DropdownMenuItem<String>(
//                         value: category,
//                         child: Text(category),
//                       );
//                     }).toList(),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 12),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     IconButton.filled(
//                       onPressed: () {
//                         Navigator.pop(context);
//                         textController.clear();
//                         descriptionTextController.clear();
//                       },
//                       icon: const Icon(Icons.close),
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         onSave();
//                         Navigator.pop(context);
//                       },
//                       child: const Text("Save"),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }
