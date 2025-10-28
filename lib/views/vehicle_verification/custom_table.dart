import 'package:flutter/material.dart';

class CustomTable extends StatelessWidget {
  const CustomTable({
    super.key,
    required this.columnNames,
    required this.data,
  });

  final List<String> columnNames;
  final List<DataRow> data;

  @override
  Widget build(BuildContext context) {
    final ScrollController horizontalController = ScrollController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 12),
          child: Text(
            "Material Details",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(83, 213, 227, 1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              (data.length > 1) ? '${data.length} Items' : '${data.length} Item',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color.fromRGBO(72, 76, 175, 1),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Scrollbar(
            controller: horizontalController,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: horizontalController,
              scrollDirection: Axis.horizontal,
              child: Scrollbar(
                thumbVisibility: true,
                controller: horizontalController,
                thickness: 10,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(Colors.grey[200]),
                    border: TableBorder.all(
                      color: const Color.fromRGBO(224, 231, 255, 1),
                      style: BorderStyle.solid,
                      width: 1,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    columns: columnNames
                        .map(
                          (name) => DataColumn(
                            label: Text(
                              name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    rows: data,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
