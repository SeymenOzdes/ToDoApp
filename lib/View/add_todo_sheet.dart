import 'package:first_app/cubits/todos_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/web.dart';

class CustomBottomSheet extends StatefulWidget {
  final TodosCubit todosCubit;

  const CustomBottomSheet({
    super.key,
    required this.todosCubit,
  });

  @override
  CustomBottomSheetState createState() => CustomBottomSheetState();
}

class CustomBottomSheetState extends State<CustomBottomSheet> {
  late String selectedCategoryValue;
  late TextEditingController textController;
  late TextEditingController descriptionTextController;
  late final TodosCubit _todosCubit;
  late final List<String> categories;
  DateTime? initialDateTime;
  Logger log = Logger();

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
    descriptionTextController = TextEditingController();
    selectedCategoryValue = "";
    categories = ["Gündelik", "İş", "Okul"];
    // initialDateTime = DateTime.now();
    _todosCubit = widget.todosCubit;
  }

  void showDatePickerSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 300,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: CupertinoDatePicker(
                    initialDateTime: initialDateTime ?? DateTime.now(),
                    minimumYear: 2024,
                    onDateTimeChanged: (DateTime newTime) {
                      setState(() {
                        initialDateTime = newTime;
                      });
                    },
                    mode: CupertinoDatePickerMode.dateAndTime,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      if (initialDateTime != null) {
                        initialDateTime = initialDateTime!;
                      } else {
                        initialDateTime = DateTime.now();
                      }
                    });
                  },
                  child: const Text("Save"),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Column(
          children: [
            TextField(
              style: const TextStyle(fontSize: 22),
              controller: textController,
              decoration: const InputDecoration(
                hintText: "Add a new ToDo",
                hintStyle: TextStyle(fontSize: 22, color: Colors.grey),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
              ),
              keyboardType: TextInputType.name,
            ),
            TextField(
              style: const TextStyle(fontSize: 18),
              controller: descriptionTextController,
              decoration: const InputDecoration(
                hintText: "Description",
                hintStyle: TextStyle(fontSize: 18, color: Colors.grey),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: ElevatedButton.icon(
                    onPressed: showDatePickerSheet,
                    label: Text(initialDateTime != null
                        ? DateFormat('yyyy-MM-dd HH:mm')
                            .format(initialDateTime!)
                        : "Select due date"),
                    icon: const Icon(Icons.flag),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, top: 12),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: DropdownButton<String>(
                  value: selectedCategoryValue.isNotEmpty
                      ? selectedCategoryValue
                      : null,
                  onChanged: (String? newValue) {
                    _todosCubit.updateDropdownValue(newValue,
                        selectedCategoryValue); // OnValueChanged değişicek.

                    setState(() {
                      selectedCategoryValue = newValue ?? "";
                    });
                  },
                  hint: const Text('Select Category'),
                  items: categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton.filled(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {});
                    },
                    icon: const Icon(Icons.close),
                  ),
                  IconButton.filled(
                    onPressed: () async {
                      await _todosCubit.saveTask(
                          textController.value.text,
                          descriptionTextController.value.text,
                          selectedCategoryValue,
                          initialDateTime!);

                      if (!context.mounted) return;
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.check),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    textController.dispose(); // dispose yanlış olabilir.
    descriptionTextController.dispose();
    super.dispose();
  }
}
