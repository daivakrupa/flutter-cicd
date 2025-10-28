import 'package:flutter/material.dart';

class ChipInputField extends StatefulWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final Function(List<String>) getChipEntries;

  const ChipInputField({
    super.key,
    required this.label,
    required this.icon,
    required this.controller,
    required this.getChipEntries,
  });

  @override
  State<ChipInputField> createState() => _ChipInputFieldState();
}

class _ChipInputFieldState extends State<ChipInputField> {
  List<String> entries = [];

  void _addEntry() {
    final text = widget.controller.text.trim();
    if (text.isNotEmpty && !entries.contains(text)) {
      setState(() {
        entries.add(text);
      });
      widget.controller.clear();
      widget.getChipEntries(entries);
    }
  }

  void _removeEntry(String entry) {
    setState(() {
      entries.remove(entry);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            style: const TextStyle(color: Colors.white),
            controller: widget.controller,
            onFieldSubmitted: (_) => _addEntry(),
            decoration: InputDecoration(
              hintStyle: const TextStyle(color: Colors.white),
              label: RichText(
                text: TextSpan(
                  text: widget.label,
                  style: const TextStyle(color: Colors.white),
                  // children: const [
                  //   TextSpan(
                  //     text: ' *',
                  //     style: TextStyle(color: Colors.white),
                  //   ),
                  // ],
                ),
              ),
              labelStyle: const TextStyle(color: Colors.white),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 6,
                horizontal: 10,
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.arrow_forward, color: Colors.white),
                onPressed: _addEntry,
              ),
            ),
          ),
          const SizedBox(height: 10),
          const SizedBox(height: 10),
          SizedBox(
            //height: 150, // You can adjust this height as needed
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: entries
                    .map(
                      (entry) => Chip(
                        label: Text(entry),
                        backgroundColor: Colors.white,
                        labelStyle: const TextStyle(color: Colors.black),
                        deleteIcon: const Icon(
                          Icons.cancel,
                          color: Colors.black,
                        ),
                        onDeleted: () => _removeEntry(entry),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
