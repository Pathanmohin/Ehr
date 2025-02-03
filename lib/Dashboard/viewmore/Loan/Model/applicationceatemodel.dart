class LoanApplication {
  final List<KycData> kycData;
  final Map<String, dynamic> clientData;
  final Map<String, dynamic> loanData;
  final List<String> identifiers; // or any object type, depending on your needs
  final String entity;
  final String entityType;

  LoanApplication({
    required this.kycData,
    required this.clientData,
    required this.loanData,
    required this.identifiers,
    required this.entity,
    required this.entityType,
  });

  // Convert JSON to LoanApplication object
  factory LoanApplication.fromJson(Map<String, dynamic> json) {
    var kycDataList = json['kycData'] as List;
    List<KycData> kycDataItems = kycDataList.map((i) => KycData.fromJson(i)).toList();

    return LoanApplication(
      kycData: kycDataItems,
      clientData: json['clientData'],
      loanData: json['loanData'],
      identifiers: json['identifiers'],
      entity: json['entity'],
      entityType: json['entityType'],
    );
  }

  // Convert LoanApplication object to JSON
  Map<String, dynamic> toJson() {
    return {
      'kycData': kycData.map((i) => i.toJson()).toList(),
      'clientData': clientData,
      'loanData': loanData,
      'identifiers': identifiers,
      'entity': entity,
      'entityType': entityType,
    };
  }
}

class KycData {
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
  final bool? isOcr;
  final String documentKey;

  KycData({
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
     this.isOcr,
    required this.documentKey,
  });

  // Convert JSON to KycData object
  factory KycData.fromJson(Map<String, dynamic> json) {
    return KycData(
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

  // Convert KycData object to JSON
  Map<String, dynamic> toJson() {
    return {
      'verificationTypeId': verificationTypeId,
      'kycTypeId': kycTypeId,
      'legalFormTypeId': legalFormTypeId,
      'validationStatusId': validationStatusId,
      'entity': entity,
      'locale': locale,
      'documentTypeId': documentTypeId,
      'isFrontSide': isFrontSide,
      'isBackSide': isBackSide,
      'isDocumentDrivingLicence': isDocumentDrivingLicence,
      'isOcr': isOcr,
      'documentKey': documentKey,
    };
  }
}


class ClientData {
  final String submittedOnDate;
  final int officeId;
  final int legalFormId;
  final String dateOfBirth;
  final String mobileNo;
  final String dateFormat;
  final bool active;
  final List<dynamic> familyMembers;  // Empty list, adjust if needed
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
    required this.familyMembers,
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

  Map<String, dynamic> toJson() {
    return {
      'submittedOnDate': submittedOnDate,
      'officeId': officeId,
      'legalFormId': legalFormId,
      'dateOfBirth': dateOfBirth,
      'mobileNo': mobileNo,
      'dateFormat': dateFormat,
      'active': active,
      'familyMembers': familyMembers,
      'locale': locale,
      'salutation': salutation,
      'firstName': firstName,
      'lastName': lastName,
      'middleName': middleName,
      'age': age,
      'emailAddress': emailAddress,
      'fatherName': fatherName,
      'motherName': motherName,
      'genderId': genderId,
      'qualification': qualification,
      'maritalStatusId': maritalStatusId,
      'cast': cast,
      'religion': religion,
      'profession': profession,
      'activationDate': activationDate,
      'address': address.map((e) => e.toJson()).toList(),
    };
  }
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

  Map<String, dynamic> toJson() {
    return {
      'locale': locale,
      'dateFormat': dateFormat,
      'country': country,
      'addressTypeId': addressTypeId,
      'addressSubTypeId': addressSubTypeId,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'postalCode': postalCode,
      'district': district,
      'state': state,
      'city': city,
      'tehsil': tehsil,
    };
  }
}


class LoanData {
  int productId;
  int repaymentEvery;
  int repaymentFrequencyType;
  int interestRatePerPeriod;
  int amortizationType;
  int interestCalculationPeriodType;
  int interestType;
  bool isEqualAmortization;
  bool allowPartialPeriodInterestCalcualtion;
  int transactionProcessingStrategyId;
  List<Charge> charges;
  List<dynamic> checklistTemplate;
  List<LoanPurposeOption> loanPurposeOptions;
  int principalThresholdForLastInstallmentofLoan;
  String AddPartialPeriodInterest;
  int loanTermFrequencyType;
  List<DisbursementData> disbursementData;
  String locale;
  String dateFormat;
  String loanType;
  bool isLoanApplication;
  bool isBrokenPeriodInterestUpfront;
  bool interestUpfront;
  bool useSop;
  int internalSalesId;
  String channelType;
  String principal;
  String numberOfRepayments;
  bool isSelfSourced;
  String maxOutstandingLoanBalance;
  String? submittedOnDate;
  String loanTermFrequency;
  int source;
  int subSource;
  int comfortableEmi;
  int loanPurposeId;
  String externalId;

  LoanData({
    required this.productId,
    required this.repaymentEvery,
    required this.repaymentFrequencyType,
    required this.interestRatePerPeriod,
    required this.amortizationType,
    required this.interestCalculationPeriodType,
    required this.interestType,
    required this.isEqualAmortization,
    required this.allowPartialPeriodInterestCalcualtion,
    required this.transactionProcessingStrategyId,
    required this.charges,
    required this.checklistTemplate,
    required this.loanPurposeOptions,
    required this.principalThresholdForLastInstallmentofLoan,
    required this.AddPartialPeriodInterest,
    required this.loanTermFrequencyType,
    required this.disbursementData,
    required this.locale,
    required this.dateFormat,
    required this.loanType,
    required this.isLoanApplication,
    required this.isBrokenPeriodInterestUpfront,
    required this.interestUpfront,
    required this.useSop,
    required this.internalSalesId,
    required this.channelType,
    required this.principal,
    required this.numberOfRepayments,
    required this.isSelfSourced,
    required this.maxOutstandingLoanBalance,
     this.submittedOnDate,
    required this.loanTermFrequency,
    required this.source,
    required this.subSource,
    required this.comfortableEmi,
    required this.loanPurposeId,
    required this.externalId
  });

  factory LoanData.fromJson(Map<String, dynamic> json) {
    return LoanData(
      productId: json['productId'],
      repaymentEvery: json['repaymentEvery'],
      repaymentFrequencyType: json['repaymentFrequencyType'],
      interestRatePerPeriod: json['interestRatePerPeriod'],
      amortizationType: json['amortizationType'],
      interestCalculationPeriodType: json['interestCalculationPeriodType'],
      interestType: json['interestType'],
      isEqualAmortization: json['isEqualAmortization'],
      allowPartialPeriodInterestCalcualtion: json['allowPartialPeriodInterestCalcualtion'],
      transactionProcessingStrategyId: json['transactionProcessingStrategyId'],
      charges: (json['charges'] as List).map((i) => Charge.fromJson(i)).toList(),
      checklistTemplate: json['checklistTemplate'],
      loanPurposeOptions: (json['loanPurposeOptions'] as List).map((i) => LoanPurposeOption.fromJson(i)).toList(),
      principalThresholdForLastInstallmentofLoan: json['principalThresholdForLastInstallmentofLoan'],
      AddPartialPeriodInterest: json['AddPartialPeriodInterest'],
      loanTermFrequencyType: json['loanTermFrequencyType'],
      disbursementData: (json['disbursementData'] as List).map((i) => DisbursementData.fromJson(i)).toList(),
      locale: json['locale'],
      dateFormat: json['dateFormat'],
      loanType: json['loanType'],
      isLoanApplication: json['isLoanApplication'],
      isBrokenPeriodInterestUpfront: json['isBrokenPeriodInterestUpfront'],
      interestUpfront: json['interestUpfront'],
      useSop: json['useSop'],
      internalSalesId: json['internalSalesId'],
      channelType: json['channelType'],
      principal: json['principal'],
      numberOfRepayments: json['numberOfRepayments'],
      isSelfSourced: json['isSelfSourced'],
      maxOutstandingLoanBalance: json['maxOutstandingLoanBalance'],
      submittedOnDate: json['submittedOnDate'],
      loanTermFrequency: json['loanTermFrequency'],
      source:json['source'],
      subSource:json['subSource'],
      comfortableEmi:json['comfortableEmi'],
      loanPurposeId:json['loanPurposeId'],
      externalId:json['externalId']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'repaymentEvery': repaymentEvery,
      'repaymentFrequencyType': repaymentFrequencyType,
      'interestRatePerPeriod': interestRatePerPeriod,
      'amortizationType': amortizationType,
      'interestCalculationPeriodType': interestCalculationPeriodType,
      'interestType': interestType,
      'isEqualAmortization': isEqualAmortization,
      'allowPartialPeriodInterestCalcualtion': allowPartialPeriodInterestCalcualtion,
      'transactionProcessingStrategyId': transactionProcessingStrategyId,
      'charges': charges.map((i) => i.toJson()).toList(),
      'checklistTemplate': checklistTemplate,
      'loanPurposeOptions': loanPurposeOptions.map((i) => i.toJson()).toList(),
      'principalThresholdForLastInstallmentofLoan': principalThresholdForLastInstallmentofLoan,
      'AddPartialPeriodInterest': AddPartialPeriodInterest,
      'loanTermFrequencyType': loanTermFrequencyType,
      'disbursementData': disbursementData.map((i) => i.toJson()).toList(),
      'locale': locale,
      'dateFormat': dateFormat,
      'loanType': loanType,
      'isLoanApplication': isLoanApplication,
      'isBrokenPeriodInterestUpfront': isBrokenPeriodInterestUpfront,
      'interestUpfront': interestUpfront,
      'useSop': useSop,
      'internalSalesId': internalSalesId,
      'channelType': channelType,
      'principal': principal,
      'numberOfRepayments': numberOfRepayments,
      'isSelfSourced': isSelfSourced,
      'maxOutstandingLoanBalance': maxOutstandingLoanBalance,
      'submittedOnDate': submittedOnDate,
      'loanTermFrequency': loanTermFrequency,
      'source':source,
      'subSource':subSource,
      'comfortableEmi':comfortableEmi,
      'loanPurposeId':loanPurposeId,
      'externalId' : externalId
    };
  }
}

class Charge {
  int chargeId;
  String name;
  ChargeTimeType chargeTimeType;
  ChargeCalculationType chargeCalculationType;
  Currency currency;
  double amount;
  double amountPaid;
  double amountWaived;
  double amountWrittenOff;
  double amountOutstanding;
  double amountOrPercentage;
  bool penalty;
  ChargePaymentMode chargePaymentMode;
  bool paid;
  bool waived;
  bool chargePayable;
  bool taxInclusive;
  bool isSlabBased;
  SlabChargeType slabChargeType;
  double? percentage;

  Charge({
    required this.chargeId,
    required this.name,
    required this.chargeTimeType,
    required this.chargeCalculationType,
    required this.currency,
    required this.amount,
    required this.amountPaid,
    required this.amountWaived,
    required this.amountWrittenOff,
    required this.amountOutstanding,
    required this.amountOrPercentage,
    required this.penalty,
    required this.chargePaymentMode,
    required this.paid,
    required this.waived,
    required this.chargePayable,
    required this.taxInclusive,
    required this.isSlabBased,
     this.percentage,
    required this.slabChargeType,
  });

  factory Charge.fromJson(Map<String, dynamic> json) {
    return Charge(
      chargeId: json['chargeId'],
      name: json['name'],
      chargeTimeType: ChargeTimeType.fromJson(json['chargeTimeType']),
      chargeCalculationType: ChargeCalculationType.fromJson(json['chargeCalculationType']),
      currency: Currency.fromJson(json['currency']),
      amount: json['amount'].toDouble(),
      amountPaid: json['amountPaid'].toDouble(),
      amountWaived: json['amountWaived'].toDouble(),
      amountWrittenOff: json['amountWrittenOff'].toDouble(),
      amountOutstanding: json['amountOutstanding'].toDouble(),
      amountOrPercentage: json['amountOrPercentage'].toDouble(),
      penalty: json['penalty'],
      chargePaymentMode: ChargePaymentMode.fromJson(json['chargePaymentMode']),
      paid: json['paid'],
      waived: json['waived'],
      chargePayable: json['chargePayable'],
      taxInclusive: json['taxInclusive'],
      isSlabBased: json['isSlabBased'],
      slabChargeType: SlabChargeType.fromJson(json['slabChargeType']),
      percentage:json['percentage'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chargeId': chargeId,
      'name': name,
      'chargeTimeType': chargeTimeType.toJson(),
      'chargeCalculationType': chargeCalculationType.toJson(),
      'currency': currency.toJson(),
      'amount': amount,
      'amountPaid': amountPaid,
      'amountWaived': amountWaived,
      'amountWrittenOff': amountWrittenOff,
      'amountOutstanding': amountOutstanding,
      'amountOrPercentage': amountOrPercentage,
      'penalty': penalty,
      'chargePaymentMode': chargePaymentMode.toJson(),
      'paid': paid,
      'waived': waived,
      'chargePayable': chargePayable,
      'taxInclusive': taxInclusive,
      'isSlabBased': isSlabBased,
      'slabChargeType': slabChargeType.toJson(),
      'percentage': percentage,
    };
  }
}

class ChargeTimeType {
  int id;
  String code;
  String value;

  ChargeTimeType({required this.id, required this.code, required this.value});

  factory ChargeTimeType.fromJson(Map<String, dynamic> json) {
    return ChargeTimeType(
      id: json['id'],
      code: json['code'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'value': value,
    };
  }
}

class ChargePaymentMode {
  int id;
  String code;
  String value;

  ChargePaymentMode({required this.id, required this.code, required this.value});

  factory ChargePaymentMode.fromJson(Map<String, dynamic> json) {
    return ChargePaymentMode(
      id: json['id'],
      code: json['code'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'value': value,
    };
  }
}

class SlabChargeType {
  int id;
  String code;
  String value;

  SlabChargeType({required this.id, required this.code, required this.value});

  factory SlabChargeType.fromJson(Map<String, dynamic> json) {
    return SlabChargeType(
      id: json['id'],
      code: json['code'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'value': value,
    };
  }
}

class LoanPurposeOption {
  int id;
  String name;
  int position;
  String description;
  bool active;
  bool mandatory;

  LoanPurposeOption({
    required this.id,
    required this.name,
    required this.position,
    required this.description,
    required this.active,
    required this.mandatory,
  });

  factory LoanPurposeOption.fromJson(Map<String, dynamic> json) {
    return LoanPurposeOption(
      id: json['id'],
      name: json['name'],
      position: json['position'],
      description: json['description'],
      active: json['active'],
      mandatory: json['mandatory'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'position': position,
      'description': description,
      'active': active,
      'mandatory': mandatory,
    };
  }
}

class DisbursementData {
  String expectedDisbursementDate;
  String principal;

  DisbursementData({required this.expectedDisbursementDate, required this.principal});

  factory DisbursementData.fromJson(Map<String, dynamic> json) {
    return DisbursementData(
      expectedDisbursementDate: json['expectedDisbursementDate'],
      principal: json['principal'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'expectedDisbursementDate': expectedDisbursementDate,
      'principal': principal,
    };
  }
}

class Currency {
  String code;
  String name;
  int decimalPlaces;
  String displaySymbol;
  String nameCode;
  String displayLabel;

  Currency({
    required this.code,
    required this.name,
    required this.decimalPlaces,
    required this.displaySymbol,
    required this.nameCode,
    required this.displayLabel,
  });

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      code: json['code'],
      name: json['name'],
      decimalPlaces: json['decimalPlaces'],
      displaySymbol: json['displaySymbol'],
      nameCode: json['nameCode'],
      displayLabel: json['displayLabel'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'decimalPlaces': decimalPlaces,
      'displaySymbol': displaySymbol,
      'nameCode': nameCode,
      'displayLabel': displayLabel,
    };
  }
}

class ChargeCalculationType {
  int id;
  String code;
  String value;

  ChargeCalculationType({required this.id, required this.code, required this.value});

  factory ChargeCalculationType.fromJson(Map<String, dynamic> json) {
    return ChargeCalculationType(
      id: json['id'],
      code: json['code'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'value': value,
    };
  }
}


class AddressType {
  final String label;
  final String value;

  AddressType({required this.label, required this.value});

  // Factory method to create a list of AddressType objects from a map
  static List<AddressType> fromMap(Map<String, String> map) {
    return map.entries
        .map((entry) => AddressType(label: entry.key, value: entry.value))
        .toList();
  }

  @override
  String toString() => 'AddressType(label: $label, value: $value)';
}

class Qualification {
  final String label;
  final int value;

  Qualification({required this.label, required this.value});

  // Factory method to create a list of Qualification objects from a map
  static List<Qualification> fromMap(Map<String, int> map) {
    return map.entries
        .map((entry) => Qualification(label: entry.key, value: entry.value))
        .toList();
  }

  @override
  String toString() => 'Qualification(label: $label, value: $value)';
}

class Gender {
  final String label;
  final int value;

  Gender({required this.label, required this.value});

  // Factory method to create a list of Gender objects from a map
  static List<Gender> fromMap(Map<String, int> map) {
    return map.entries
        .map((entry) => Gender(label: entry.key, value: entry.value))
        .toList();
  }

  @override
  String toString() => 'Gender(label: $label, value: $value)';
}

class MaritalStatus {
  final String label;
  final int value;

  MaritalStatus({required this.label, required this.value});

  // Factory method to create a list of MaritalStatus objects from a map
  static List<MaritalStatus> fromMap(Map<String, int> map) {
    return map.entries
        .map((entry) => MaritalStatus(label: entry.key, value: entry.value))
        .toList();
  }

  @override
  String toString() => 'MaritalStatus(label: $label, value: $value)';
}

class Caste {
  final String label;
  final int value;

  Caste({required this.label, required this.value});

  // Factory method to create a list of MaritalStatus objects from a map
  static List<Caste> fromMap(Map<String, int> map) {
    return map.entries
        .map((entry) => Caste(label: entry.key, value: entry.value))
        .toList();
  }

  @override
  String toString() => 'Caste(label: $label, value: $value)';
}

class Religion {
  final String label;
  final int value;

  Religion({required this.label, required this.value});

  // Factory method to create a list of MaritalStatus objects from a map
  static List<Religion> fromMap(Map<String, int> map) {
    return map.entries
        .map((entry) => Religion(label: entry.key, value: entry.value))
        .toList();
  }

  @override
  String toString() => 'Religion(label: $label, value: $value)';
}

