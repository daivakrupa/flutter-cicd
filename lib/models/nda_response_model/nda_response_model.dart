// nda_response_model.dart

class NDAResponse {
  final String message;
  final String orgId;
  final String ndaDoc;
  final String policies;

  NDAResponse({
    required this.message,
    required this.orgId,
    required this.ndaDoc,
    required this.policies,
  });

  factory NDAResponse.fromJson(Map<String, dynamic> json) {
    return NDAResponse(
      message: json['message'],
      orgId: json['org_id'],
      ndaDoc: json['ndaDoc'] ?? '',
      policies: json['policies'],
    );
  }
}
