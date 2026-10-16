/// JSON answers of the partner API for widget tests (same shapes as docs/api/openapi.json).
library;

Map<String, dynamic> requiredDoc(
  String type, {
  bool mandatory = true,
  String numberRule = 'NONE',
  bool hasExpiry = false,
}) => {
  'id': 'r-$type',
  'role': 'COMPANION',
  'docType': type,
  'label': type == 'AADHAAR'
      ? 'Aadhaar card'
      : type == 'PAN'
      ? 'PAN card'
      : type,
  'labelHi': '',
  'labelOr': '',
  'help': '',
  'mandatory': mandatory,
  'condition': '',
  'hasExpiry': hasExpiry,
  'numberRule': numberRule,
  'cameraOnly': false,
  'sort': 1,
  'isActive': true,
};

Map<String, dynamic> document(String type, String status, {String reason = ''}) => {
  'id': 'd-$type',
  'docType': type,
  'status': status,
  'mime': 'application/pdf',
  'numberMasked': '',
  'expiresOn': null,
  'rejectReason': reason,
  'isCurrent': true,
  'reviewedBy': null,
  'reviewedAt': null,
  'createdAt': '2026-10-08T10:00:00Z',
};

Map<String, dynamic> docState(Map<String, dynamic> required, String status, {String reason = ''}) => {
  'required': required,
  'status': status,
  'document': status == 'MISSING' ? null : document(required['docType'] as String, status, reason: reason),
  'replacement': null,
};

Map<String, dynamic> profile({
  String status = 'REGISTERING',
  String suspendedReason = '',
  bool emailVerified = false,
  bool alternate = false,
  bool availableToday = false,
  bool filled = false,
  bool addedByAdmin = false,
}) => {
  'id': 'u-1',
  'role': 'COMPANION',
  'status': status,
  'suspendedReason': suspendedReason,
  'fullName': 'Asha Behera',
  'dob': filled ? '1996-01-17' : null,
  'gender': filled ? 'FEMALE' : '',
  'photoKey': filled ? 'partners/photos/u-1/p.jpg' : '',
  'photoUrl': null,
  'email': emailVerified || addedByAdmin ? 'asha@example.com' : '',
  'emailVerified': emailVerified,
  'address': filled ? 'Plot 12, Saheed Nagar, Bhubaneswar' : '',
  'lat': filled ? '20.2961' : null,
  'lng': filled ? '85.8245' : null,
  'languages': filled ? ['or'] : <String>[],
  'skills': <String>[],
  'emergencyName': filled ? 'Ravi Behera' : '',
  'emergencyPhone': filled ? '+919876500001' : '',
  'availableToday': availableToday,
  'addedByAdmin': addedByAdmin,
  'phones': [
    {'kind': 'PRIMARY', 'phone': '+919876543210', 'verified': true},
    if (alternate || addedByAdmin) {'kind': 'ALTERNATE', 'phone': '+919876500000', 'verified': alternate},
  ],
  'createdAt': '2026-10-08T10:00:00Z',
  'approvedAt': null,
};

Map<String, dynamic> kyc({
  String status = 'REGISTERING',
  String suspendedReason = '',
  bool done = false,
  bool canSubmit = false,
  List<Map<String, dynamic>>? documents,
  String? applicationStatus,
  String notes = '',
  bool availableToday = false,
  bool filled = false,
  bool addedByAdmin = false,
}) => {
  'profile': profile(
    filled: filled,
    addedByAdmin: addedByAdmin,
    status: status,
    suspendedReason: suspendedReason,
    emailVerified: done,
    alternate: done,
    availableToday: availableToday,
  ),
  'steps': {'role': true, 'alternatePhone': done, 'email': done, 'profile': done, 'documents': done},
  'canEdit': const {'REGISTERING', 'REGISTERED', 'CHANGES_REQUESTED'}.contains(status),
  'canSubmit': canSubmit,
  'documents':
      documents ??
      [
        docState(requiredDoc('AADHAAR', numberRule: 'AADHAAR'), 'MISSING'),
        docState(requiredDoc('PAN', numberRule: 'PAN'), 'MISSING'),
      ],
  'application': applicationStatus == null
      ? null
      : {
          'id': 'a-1',
          'status': applicationStatus,
          'submittedAt': '2026-10-08T10:00:00Z',
          'firstSubmittedAt': '2026-10-08T10:00:00Z',
          'notes': notes,
          'claimedBy': null,
          'claimedUntil': null,
          'decidedBy': null,
          'decidedAt': null,
        },
};
