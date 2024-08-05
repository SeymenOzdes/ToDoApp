// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// void showBottomSheett(BuildContext context,
//                      TextEditingController textController,
//                      TextEditingController descriptionTextController, 
//                      DateTime dateTime, 
//                      ValueChanged<DateTime> onDateTimeChanged,

// ) {
//       showModalBottomSheet(
//           context: context,
//           showDragHandle: true,
//           elevation: 0,
//           builder: (context) {
//             return SizedBox(
//                 height: 400,
//                 width: double.infinity,
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 12),
//                   child: Column(
//                     children: [
//                       TextField(
//                         style: const TextStyle(fontSize: 22),
//                         controller: textController,
//                         decoration: const InputDecoration(
//                             hintText: "Add a new ToDo",
//                             hintStyle:
//                                 TextStyle(fontSize: 22, color: Colors.grey),
//                             border: InputBorder.none,
//                             enabledBorder: InputBorder.none),
//                         keyboardType: TextInputType.name,
//                       ),
//                       TextField(
//                         style: const TextStyle(fontSize: 18),
//                         controller: descriptionTextController,
//                         decoration: const InputDecoration(
//                           hintText: "Description",
//                           hintStyle:
//                               TextStyle(fontSize: 18, color: Colors.grey),
//                           border: InputBorder.none,
//                           enabledBorder: InputBorder.none,
//                         ),
//                       ),
//                       // buraya
//                       SizedBox(
//                         height: 200,
//                         child: CupertinoDatePicker(
//                             initialDateTime: dateTime,
//                             onDateTimeChanged: onDateTimeChanged
//                       )
//                       )
//                     ],
//                   ),
//                 ));
//           });
//     }