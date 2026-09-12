class CreateCvRequest {
  final String fullName;
  final String passportNumber;

  final String countryId;

  final String experience;
  final String maritalStatus;

  final int age;
  final num salary;
  final String religion;

  const CreateCvRequest({
    required this.fullName,
    required this.passportNumber,
    required this.countryId,
    required this.experience,
    required this.maritalStatus,
    required this.age,
    required this.salary,
    required this.religion,
  });

  Map<String, dynamic> toMap() {
    return {
      'FullName': fullName,
      'PassportNumber': passportNumber,
      'CountryId': countryId,
      'Experience': experience,
      'MaritalStatus': maritalStatus,
      'Age': age,
      'Salary': salary,
      'Religion': religion,
    };
  }
}