// import 'package:flutter/material.dart';
// import 'package:visiq/models/book_visit_model/countrycodes_model.dart';

// class CountryCodeDropdown extends StatelessWidget {
//   final Function(String?) onSelction;
//   final String? selectedCountryCode;
//   final List<CountryCodeData> countryCodes;

//   const CountryCodeDropdown({
//     super.key,
//     required this.selectedCountryCode,
//     required this.onSelction,
//     required this.countryCodes,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         DropdownButtonFormField<String?>(
//           decoration: const InputDecoration(labelText: 'Country Code'),
//           initialValue: selectedCountryCode,
//           isExpanded: true,
//           menuMaxHeight: 300,
//           items: countryCodes.map((code) {
//             return DropdownMenuItem<String?>(
//               value: code.code,
//               child: Text(
//                 '${code.country} (${code.code})',
//                 style: const TextStyle(fontWeight: FontWeight.normal),
//               ),
//             );
//           }).toList(),
//           onChanged: (String? value) {
//             onSelction(value);
//           },
//           validator: (value) {
//             if (value == null) {
//               return 'Country Code is required';
//             }
//             return null;
//           },
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visiq/models/book_visit_model/countrycodes_model.dart';

class CountryCodeDropdown extends StatelessWidget {
  final RxString selectedCountryCode;
  final List<CountryCodeData> countryCodes;

  const CountryCodeDropdown({
    super.key,
    required this.selectedCountryCode,
    required this.countryCodes,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => DropdownButtonFormField<String?>(
        decoration: const InputDecoration(labelText: 'Country Code'),
        value: selectedCountryCode.value.isEmpty
            ? null
            : selectedCountryCode.value,
        isExpanded: true,
        menuMaxHeight: 300,
        items: countryCodes.map((code) {
          return DropdownMenuItem<String?>(
            value: code.code,
            child: Text('${code.country} (${code.code})'),
          );
        }).toList(),
        onChanged: (value) {
          selectedCountryCode.value = value ?? '';
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Country Code is required';
          }
          return null;
        },
      ),
    );
  }
}
