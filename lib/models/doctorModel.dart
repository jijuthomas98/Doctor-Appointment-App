import 'package:cloud_firestore/cloud_firestore.dart';

class Doctor {
  String IDNo;
  String name;
  String lastName;
  String password;
  int bolumId;
  int hospitalID;
  var appointments = [];
  int favCounter;
  String DOB;
  String gender;
  String birthPlace;

  DocumentReference reference;

  Doctor(
      {this.IDNo,
      this.name,
      this.lastName,
      this.password,
      this.bolumId,
      this.hospitalID,
      this.appointments,
      this.favCounter,
      this.DOB,
      this.gender,
      this.birthPlace});

  Doctor.fromJson(Map<String, dynamic> json) {
    IDNo = json['IDNo'];
    name = json['name'];
    lastName = json['lastName'];
    password = json['password'];
    bolumId = json['bolumId'];
    hospitalID = json['hospitalID'];
    appointments = List.from(json['appointments']);
    favCounter = json['favCounter'];
    DOB = json['DOB'];
    gender = json['gender'];
    birthPlace = json["birthPlace"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IDNo'] = this.IDNo;
    data['name'] = this.name;
    data['lastName'] = this.lastName;
    data['password'] = this.password;
    data['bolumId'] = this.bolumId;
    data['hospitalID'] = this.hospitalID;
    data['appointments'] = this.appointments;
    data['favCounter'] = this.favCounter;
    data['DOB'] = this.DOB;
    data['gender'] = this.gender;
    data['birthPlace'] = this.birthPlace;
    return data;
  }

  Doctor.fromMap(Map<String, dynamic> map, {this.reference})
      : IDNo = map["IDNo"],
        password = map["password"],
        name = map["name"],
        lastName = map["lastName"],
        bolumId = map["bolumId"],
        hospitalID = map["hospitalID"],
        appointments = List.from(map["appointments"]),
        favCounter = map["favCounter"],
        birthPlace = map["birthPlace"],
        DOB = map["DOB"],
        gender = map["gender"];

  Doctor.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}
