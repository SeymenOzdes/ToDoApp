import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/web.dart';

class CustomBottomSheet extends StatefulWidget {
  final TextEditingController textController;
  final TextEditingController descriptionTextController;
  final String selectedCategoryValue;
  final List<String> categories;
  final Future<void> Function() onSaveTask;
  final void Function(String?) onValueChanged;
  final void Function(DateTime) onDateSelected;
  final DateTime initialDateTime;

  CustomBottomSheet({
    required this.textController,
    required this.descriptionTextController,
    required this.selectedCategoryValue,
    required this.categories,
    required this.onSaveTask,
    required this.onValueChanged,
    required this.onDateSelected,
    required this.initialDateTime,
  });

  @override
  _CustomBottomSheetState createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  DateTime selectedDateTime = DateTime.now();
  String selectedCategoryValue = "";
  Logger log = Logger();
                        
  @override
  void initState() {
    super.initState();
    selectedDateTime = widget.initialDateTime;
    selectedCategoryValue = widget.selectedCategoryValue;
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
                    initialDateTime: selectedDateTime,
                    minimumYear: 2024,
                    onDateTimeChanged: (DateTime newTime) {
                      setState(() {
                        selectedDateTime = newTime;
                      });
                    },
                    mode: CupertinoDatePickerMode.dateAndTime,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    widget.onDateSelected(selectedDateTime);
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
    print(widget.selectedCategoryValue);

    return SizedBox(
      height: 300,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Column(
          children: [
            TextField(
              style: const TextStyle(fontSize: 22),
              controller: widget.textController,
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
              controller: widget.descriptionTextController,
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
                    label: const Text("Select Due Date"),
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
                    widget.onValueChanged(newValue);
                    setState(() {
                      selectedCategoryValue = newValue ?? "";
                    });
                  },
                  hint: const Text('Select Category'),
                  items: widget.categories.map((String category) {
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
                      widget.textController.clear();
                      widget.descriptionTextController.clear();
                      setState(() {
                        selectedCategoryValue = "";
                      });
                    },
                    icon: const Icon(Icons.close),
                  ),
                  IconButton.filled(
                    onPressed: () async {
                      await widget.onSaveTask();
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
}
