import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:visiq/controllers/visitor_card_controller.dart';
import 'package:visiq/views/viewvisitors/status_card_widget.dart';
import 'package:visiq/views/viewvisitors/visitor_card.dart';
class VisitorCardList extends StatelessWidget {
   VisitorCardList({super.key});

final VisitorCardController controller = Get.put(VisitorCardController());

  @override
  Widget build(BuildContext context) {

    return LoaderOverlay(
      overlayColor: Colors.grey.withOpacity(0.1),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Visitor List'),
          actions: [
            IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () => controller.pickDate(context),
            ),
          ],
        ),
        body: Obx(() {
          final statusData = [
            {'title': 'Total Branches', 'count': controller.totalBranches.value},
            {'title': 'Total Entries', 'count': controller.totalEntries.value},
            {'title': 'Total Check-Ins', 'count': controller.totalCheckIns.value},
            {'title': 'Total Check-Outs', 'count': controller.totalCheckOuts.value},
            {
              'title': controller.noShowVisitorsDate.value
                  ? 'No Show Visitors'
                  : 'Expected Visitors',
              'count': controller.expectedVisitors.value
            },
            {'title': 'Arrived Visitors', 'count': controller.arrivedVisitors.value},
          ];

          return Column(
            children: [
              SizedBox(
                height: 110,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: statusData.length,
                  itemBuilder: (context, index) {
                    return StatusCardsWidget(
                      title: statusData[index]['title'] as String,
                      count: statusData[index]['count'] as int,
                    );
                  },
                ),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: controller.visitorList.isEmpty &&
                        controller.arrivedVisitorList.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/no visitors.png',
                              width: 300,
                              height: 300,
                            ),
                            const Text(
                              'No visitors found',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: controller.visitorList.length +
                            controller.arrivedVisitorList.length,
                        itemBuilder: (context, index) {
                          if (index < controller.visitorList.length) {
                            final visitor = controller.visitorList[index];
                            return VisitorCard(
                              visitorId: visitor.visitorId!,
                              firstname: visitor.firstName!,
                              lastname: visitor.lastName!,
                              email: visitor.email!,
                              purposeofvisit: visitor.purposeOfVisit!,
                              time: visitor.bookingTime!,
                              action: visitor.action!,
                              status: visitor.isVisited == true
                                  ? 'Arrived'
                                  : 'Yet to Arrive',
                              visitorcode: visitor.visitorCode!,
                              dateOfVisit: visitor.dateOfVisit!,
                              isButtonEnabled: visitor.isVisited == false,
                              startDate: visitor.startDate!,
                              startTime: visitor.timeOfVisit!,
                              endTime: visitor.timeToExit!,
                              endDate: visitor.endDate!,
                              phNo: visitor.phNo!,
                              phExt: visitor.phExt!,
                              roleName: visitor.roleName ?? '',
                              onStatusChanged: () => controller.fetchVisitorsData(true),
                            );
                          } else {
                            final arrivedVisitor = controller.arrivedVisitorList[
                                index - controller.visitorList.length];
                            return VisitorCard(
                              visitorId: arrivedVisitor.visitorId!,
                              firstname: arrivedVisitor.firstName!,
                              lastname: arrivedVisitor.lastName!,
                              email: arrivedVisitor.email!,
                              purposeofvisit: arrivedVisitor.purposeOfVisit!,
                              time: arrivedVisitor.bookingTime!,
                              action: arrivedVisitor.action!,
                              status: 'Arrived',
                              visitorcode: arrivedVisitor.visitorCode!,
                              dateOfVisit: arrivedVisitor.dateOfVisit!,
                              isButtonEnabled: false,
                              onStatusChanged: () => controller.fetchVisitorsData(true),
                              startDate: arrivedVisitor.startDate!,
                              startTime: arrivedVisitor.timeOfVisit!,
                              endTime: arrivedVisitor.timeToExit!,
                              endDate: arrivedVisitor.endDate!,
                              phNo: arrivedVisitor.phNo!,
                              phExt: arrivedVisitor.phExt!,
                              roleName: arrivedVisitor.roleName!,
                            );
                          }
                        },
                      ),
              ),
            ],
          );
        }),
      ),
    );
  }
}