import 'package:flutter/material.dart';
import 'package:visiq/views/viewvisitors/customisable_column_invisitor_card.dart';

class VisitorCard extends StatelessWidget {
  final String visitorId;
  final String firstname;
  final String lastname;
  final String email;
  final String purposeofvisit;
  final String time;
  final String action;
  final String status;
  final String visitorcode;
  final String dateOfVisit;
  final bool isButtonEnabled;
  final VoidCallback? onStatusChanged;
  final String startDate;
  final String startTime;
  final String endTime;
  final String endDate;
  final String phNo;
  final String phExt;
  final String roleName;

  const VisitorCard({
    super.key,
    required this.visitorId,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.purposeofvisit,
    required this.time,
    required this.action,
    required this.status,
    required this.visitorcode,
    required this.dateOfVisit,
    required this.isButtonEnabled,
    required this.onStatusChanged,
    required this.startDate,
    required this.startTime,
    required this.endTime,
    required this.endDate,
    required this.phNo,
    required this.phExt,
    required this.roleName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('Visitor card tapped');
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8, left: 16, right: 16, top: 8),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 0.30,
              strokeAlign: BorderSide.strokeAlignOutside,
              color: Colors.black.withOpacity(0.10),
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          shadows: const [
            BoxShadow(
              color: Color.fromARGB(255, 249, 214, 185),
              blurRadius: 4,
              offset: Offset(0, 0),
              spreadRadius: 1,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Visitor Id
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    CustomisableColumnInVisitorCard(
                      title: 'Visitor Id',
                      value: visitorId,
                    ),
                  ],
                ),
              ),
              // First + Last Name
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomisableColumnInVisitorCard(
                      title: 'First Name',
                      value: firstname,
                    ),
                    CustomisableColumnInVisitorCard(
                      title: 'Last Name',
                      value: lastname,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    CustomisableColumnInVisitorCard(
                      title: 'Email',
                      value: email,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomisableColumnInVisitorCard(
                      title: 'Purpose of Visit',
                      value: purposeofvisit,
                    ),
                    CustomisableColumnInVisitorCard(
                      title: 'Category',
                      value: roleName,
                    ),
                  ],
                ),
              ),
              // Phone
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    CustomisableColumnInVisitorCard(
                      title: 'Phone Number',
                      value: '$phExt $phNo',
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomisableColumnInVisitorCard(
                      title: 'Start Time',
                      value: startTime,
                    ),
                    CustomisableColumnInVisitorCard(
                      title: 'Start Date',
                      value: startDate,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomisableColumnInVisitorCard(
                      title: 'End Time',
                      value: endTime,
                    ),
                    CustomisableColumnInVisitorCard(
                      title: 'End Date',
                      value: endDate,
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Divider(
                  color: Color(0xFFBFBFBF),
                  height: 1,
                  thickness: 0.5,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    CustomisableColumnInVisitorCard(
                      title: 'Status',
                      value: status,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}