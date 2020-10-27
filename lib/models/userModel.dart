import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String IDNo;
  String name;
  String lastName;
  String password;
  String DOB;
  String gender;
  String birthPlace;

  DocumentReference reference;

  User(
      {this.IDNo,
      this.name,
      this.lastName,
      this.password,
      this.DOB,
      this.gender,
      this.birthPlace});

  User.fromJson(Map<String, dynamic> json) {
    IDNo = json['IDNo'];
    name = json['name'];
    lastName = json['lastName'];
    DOB = json['DOB'];
    gender = json['gender'];
    password = json['password'];
    birthPlace = json["birthPlace"];
  }

  User.fromMap(Map<String, dynamic> map, {this.reference})
      : IDNo = map["IDNo"],
        password = map["password"],
        name = map["name"],
        lastName = map["LastName"],
        birthPlace = map["birthPlace"],
        DOB = map["DOB"],
        gender = map["gender"];

  User.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IDNo'] = this.IDNo;
    data['name'] = this.name;
    data['lastName'] = this.lastName;
    data['DOB'] = this.DOB;
    data['gender'] = this.gender;
    data['password'] = this.password;
    data['birthPlace'] = this.birthPlace;
    return data;
  }
}
