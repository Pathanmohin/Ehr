class KYCData {
  final int verificationTypeId;
  final int kycTypeId;
  final int legalFormTypeId;
  final int validationStatusId;
  final String entity;
  final String locale;
  final int documentTypeId;
  final bool isFrontSide;
  final bool isBackSide;
  final bool isDocumentDrivingLicence;
  final bool isOcr;
  final String documentKey;

  KYCData({
    required this.verificationTypeId,
    required this.kycTypeId,
    required this.legalFormTypeId,
    required this.validationStatusId,
    required this.entity,
    required this.locale,
    required this.documentTypeId,
    required this.isFrontSide,
    required this.isBackSide,
    required this.isDocumentDrivingLicence,
    required this.isOcr,
    required this.documentKey,
  });

  factory KYCData.fromJson(Map<String, dynamic> json) => KYCData(
        verificationTypeId: json['verificationTypeId'],
        kycTypeId: json['kycTypeId'],
        legalFormTypeId: json['legalFormTypeId'],
        validationStatusId: json['validationStatusId'],
        entity: json['entity'],
        locale: json['locale'],
        documentTypeId: json['documentTypeId'],
        isFrontSide: json['isFrontSide'],
        isBackSide: json['isBackSide'],
        isDocumentDrivingLicence: json['isDocumentDrivingLicence'],
        isOcr: json['isOcr'],
        documentKey: json['documentKey'],
      );
}

class ClientData {
  final String submittedOnDate;
  final int officeId;
  final int legalFormId;
  final String dateOfBirth;
  final String mobileNo;
  final String dateFormat;
  final bool active;
  final String locale;
  final int salutation;
  final String firstName;
  final String lastName;
  final String middleName;
  final int age;
  final String emailAddress;
  final String fatherName;
  final String motherName;
  final int genderId;
  final int qualification;
  final int maritalStatusId;
  final int cast;
  final int religion;
  final int profession;
  final String activationDate;
  final List<Address> address;

  ClientData({
    required this.submittedOnDate,
    required this.officeId,
    required this.legalFormId,
    required this.dateOfBirth,
    required this.mobileNo,
    required this.dateFormat,
    required this.active,
    required this.locale,
    required this.salutation,
    required this.firstName,
    required this.lastName,
    required this.middleName,
    required this.age,
    required this.emailAddress,
    required this.fatherName,
    required this.motherName,
    required this.genderId,
    required this.qualification,
    required this.maritalStatusId,
    required this.cast,
    required this.religion,
    required this.profession,
    required this.activationDate,
    required this.address,
  });

  factory ClientData.fromJson(Map<String, dynamic> json) => ClientData(
        submittedOnDate: json['submittedOnDate'],
        officeId: json['officeId'],
        legalFormId: json['legalFormId'],
        dateOfBirth: json['dateOfBirth'],
        mobileNo: json['mobileNo'],
        dateFormat: json['dateFormat'],
        active: json['active'],
        locale: json['locale'],
        salutation: json['salutation'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        middleName: json['middleName'],
        age: json['age'],
        emailAddress: json['emailAddress'],
        fatherName: json['fatherName'],
        motherName: json['motherName'],
        genderId: json['genderId'],
        qualification: json['qualification'],
        maritalStatusId: json['maritalStatusId'],
        cast: json['cast'],
        religion: json['religion'],
        profession: json['profession'],
        activationDate: json['activationDate'],
        address: (json['address'] as List)
            .map((e) => Address.fromJson(e))
            .toList(),
      );
}

class Address {
  final String locale;
  final String dateFormat;
  final String country;
  final int addressTypeId;
  final int addressSubTypeId;
  final String addressLine1;
  final String addressLine2;
  final String postalCode;
  final String district;
  final String state;
  final String city;
  final String tehsil;

  Address({
    required this.locale,
    required this.dateFormat,
    required this.country,
    required this.addressTypeId,
    required this.addressSubTypeId,
    required this.addressLine1,
    required this.addressLine2,
    required this.postalCode,
    required this.district,
    required this.state,
    required this.city,
    required this.tehsil,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        locale: json['locale'],
        dateFormat: json['dateFormat'],
        country: json['country'],
        addressTypeId: json['addressTypeId'],
        addressSubTypeId: json['addressSubTypeId'],
        addressLine1: json['addressLine1'],
        addressLine2: json['addressLine2'],
        postalCode: json['postalCode'],
        district: json['district'],
        state: json['state'],
        city: json['city'],
        tehsil: json['tehsil'],
      );
}

class LoanData {
  final int productId;
  final int repaymentEvery;
  final int repaymentFrequencyType;
  final double interestRatePerPeriod;
  final int amortizationType;
  final int interestCalculationPeriodType;
  final int interestType;
  final bool isEqualAmortization;
  final bool allowPartialPeriodInterestCalculation;
  final int transactionProcessingStrategyId;
  final List<Charge> charges;

  LoanData({
    required this.productId,
    required this.repaymentEvery,
    required this.repaymentFrequencyType,
    required this.interestRatePerPeriod,
    required this.amortizationType,
    required this.interestCalculationPeriodType,
    required this.interestType,
    required this.isEqualAmortization,
    required this.allowPartialPeriodInterestCalculation,
    required this.transactionProcessingStrategyId,
    required this.charges,
  });

  factory LoanData.fromJson(Map<String, dynamic> json) => LoanData(
        productId: json['productId'],
        repaymentEvery: json['repaymentEvery'],
        repaymentFrequencyType: json['repaymentFrequencyType'],
        interestRatePerPeriod: json['interestRatePerPeriod'],
        amortizationType: json['amortizationType'],
        interestCalculationPeriodType: json['interestCalculationPeriodType'],
        interestType: json['interestType'],
        isEqualAmortization: json['isEqualAmortization'],
        allowPartialPeriodInterestCalculation:
            json['allowPartialPeriodInterestCalcualtion'],
        transactionProcessingStrategyId:
            json['transactionProcessingStrategyId'],
        charges: (json['charges'] as List)
            .map((e) => Charge.fromJson(e))
            .toList(),
      );
}

class Charge {
  final int chargeId;
  final String name;
  final double amount;
  final bool penalty;

  Charge({
    required this.chargeId,
    required this.name,
    required this.amount,
    required this.penalty,
  });

  factory Charge.fromJson(Map<String, dynamic> json) => Charge(
        chargeId: json['chargeId'],
        name: json['name'],
        amount: json['amount'],
        penalty: json['penalty'],
      );
}
