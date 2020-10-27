import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_turtle_v2/dbHelper/addData.dart';
import 'package:fast_turtle_v2/dbHelper/searchData.dart';
import 'package:fast_turtle_v2/models/adminModel.dart';
import 'package:fast_turtle_v2/models/doctorModel.dart';
import 'package:fast_turtle_v2/models/hospitalModel.dart';
import 'package:fast_turtle_v2/models/sectionModel.dart';
import 'package:fast_turtle_v2/models/userModel.dart';
import 'package:fast_turtle_v2/screens/showAppoTimesForAdmin.dart';
import 'package:fast_turtle_v2/screens/showHospitals.dart';
import 'package:fast_turtle_v2/screens/showSections.dart';
import 'package:flutter/material.dart';

import 'showDoctors.dart';

class OpenAppointment extends StatefulWidget {
  final Admin admin;
  OpenAppointment(this.admin);
  @override
  OpenAppointmentState createState() => OpenAppointmentState(admin);
}

class OpenAppointmentState extends State<OpenAppointment> {
  Admin _admin;
  OpenAppointmentState(this._admin);
  bool hospitalName = false;
  bool episode = false;
  bool doctorSelected = false;
  bool dateSelected = false;
  bool appointmentControl1;
  bool appointmentControl2;

  double drImage = 0.0;
  double image = 0.0;

  Hospital hospital = Hospital();
  Section section = Section();
  Doctor doctor = Doctor();
  User user = User();

  String textMessage = " ";

  var appointmentDate;
  var raisedButtonText = "Click and select";

  var dateTimeCombination;

  double displayClock = 0.0;

  @override
  Widget build(BuildContext context) {
    setState(() {
      Firestore.instance
          .collection('tblAdmin')
          .getDocuments()
          .then((QuerySnapshot docs) {
        _admin.reference = docs.documents[0].reference;
      });
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Open Doctor appointment",
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 20.0, left: 9.0, right: 9.0),
            child: Form(
              child: Column(
                children: <Widget>[
                  RaisedButton(
                    child: Text("Click to choose a hospital"),
                    onPressed: () {
                      episode = false;
                      doctorSelected = false;
                      dateSelected = false;
                      hospitalNavigator(BuildHospitalList());
                    },
                  ),
                  SizedBox(height: 13.0),
                  showSelectedHospital(hospitalName),
                  SizedBox(
                    height: 30.0,
                  ),
                  RaisedButton(
                    child: Text("Click to select section "),
                    onPressed: () {
                      if (hospitalName) {
                        doctorSelected = false;
                        drImage = 0.0;
                        dateSelected = false;
                        sectionNavigator(BuildSectionList(hospital));
                      } else {
                        alrtHospital(context,
                            "You cant choose department without choosing hospital");
                      }
                    },
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  _showSelectedSection(episode),
                  SizedBox(
                    height: 30.0,
                  ),
                  RaisedButton(
                    child: Text("Click to select doctor"),
                    onPressed: () {
                      if (hospitalName && episode) {
                        doctorNavigator(BuildDoctorList(section, hospital));
                      } else {
                        alrtHospital(context,
                            "You cannot choose a doctor without choosing a hospital and department.");
                      }
                    },
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  showSelectedDoctor(doctorSelected),
                  SizedBox(
                    height: 25.0,
                  ),
                  dateOfAppointment(),
                  SizedBox(
                    height: 16.0,
                  ),
                  RaisedButton(
                    child: Text("Click to Select Transaction Time"),
                    onPressed: () {
                      if (appointmentDate != null &&
                          hospitalName &&
                          episode &&
                          doctorSelected) {
                        basicNavigator(AppointmentTimesForAdmin(
                            appointmentDate.toString(), doctor, _admin));
                        dateSelected = true;
                      } else {
                        alrtHospital(context,
                            "Time selection cannot be started until the above selections are completed");
                      }
                    },
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  showSelectedDate(dateSelected),
                  SizedBox(
                    height: 16.0,
                  ),
                  _buildDoneButton()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void hospitalNavigator(dynamic page) async {
    hospital = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => page));

    if (hospital == null) {
      hospitalName = false;
    } else {
      hospitalName = true;
    }
  }

  showSelectedHospital(bool selected) {
    String textMessage = " ";
    if (selected) {
      setState(() {
        textMessage = this.hospital.hastaneAdi.toString();
      });
      image = 1.0;
    } else {
      image = 0.0;
    }

    return Container(
        decoration: BoxDecoration(),
        child: Row(
          children: <Widget>[
            Text(
              "Selected Hospital : ",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            Opacity(
                opacity: image,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    textMessage,
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ))
          ],
        ));
  }

  void alrtHospital(BuildContext context, String message) {
    var alertDoctor = AlertDialog(
      title: Text(
        "Warning!",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text(message),
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDoctor;
        });
  }

  void sectionNavigator(dynamic page) async {
    section = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => page));

    if (section == null) {
      episode = false;
    } else {
      episode = true;
    }
  }

  _showSelectedSection(bool selected) {
    double image = 0.0;

    if (selected) {
      setState(() {
        textMessage = this.section.bolumAdi.toString();
      });
      image = 1.0;
    } else {
      image = 0.0;
    }

    return Container(
        decoration: BoxDecoration(),
        child: Row(
          children: <Widget>[
            Text(
              "selected episode : ",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            Opacity(
                opacity: image,
                child: Container(
                    alignment: Alignment.center,
                    child: _buildTextMessage(textMessage)))
          ],
        ));
  }

  _buildTextMessage(String incomingText) {
    return Text(
      textMessage,
      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
    );
  }

  void doctorNavigator(dynamic page) async {
    doctor = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => page));

    if (doctor == null) {
      doctorSelected = false;
    } else {
      doctorSelected = true;
    }
  }

  showSelectedDoctor(bool selectedH) {
    String textMessage = " ";
    if (selectedH) {
      setState(() {
        textMessage = this.doctor.name.toString() + " " + this.doctor.lastName;
      });
      drImage = 1.0;
    } else {
      drImage = 0.0;
    }

    return Container(
        decoration: BoxDecoration(),
        child: Row(
          children: <Widget>[
            Text(
              "Selected Doctor : ",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            Opacity(
                opacity: image,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    textMessage,
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ))
          ],
        ));
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2021),
    );
    appointmentDate = picked;
    dateTimeCombination = null;
    dateSelected = false;
  }

  Widget dateOfAppointment() {
    return Container(
      padding: EdgeInsets.only(top: 5.0),
      child: Row(
        children: <Widget>[
          Text(
            "Transaction date: ",
            style: TextStyle(fontSize: 19.0),
          ),
          RaisedButton(
            child: Text(raisedButtonText),
            onPressed: () {
              _selectDate(context).then((result) => setState(() {
                    if (appointmentDate == null) {
                      raisedButtonText = "Click and select";
                      dateSelected = false;
                    } else {
                      raisedButtonText =
                          appointmentDate.toString().substring(0, 10);
                    }
                  }));
            },
          )
        ],
      ),
    );
  }

  showSelectedDate(bool dateSelected) {
    String textMessage = " ";
    if (dateSelected) {
      setState(() {
        textMessage = dateTimeCombination.toString();
      });
      displayClock = 1.0;
    } else {
      displayClock = 0.0;
    }

    return Container(
        decoration: BoxDecoration(),
        child: Row(
          children: <Widget>[
            Text(
              "Transaction date and time : ",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            Opacity(
                opacity: displayClock,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    textMessage,
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ))
          ],
        ));
  }

  void basicNavigator(dynamic page) async {
    dateTimeCombination = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => page));
  }

  void alrtAppointment(BuildContext context) {
    var alertAppointment = AlertDialog(
        contentPadding: const EdgeInsets.fromLTRB(5.0, 50.0, 5.0, 50.0),
        title: Text(
          "Transaction summery",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Container(
          padding: EdgeInsets.only(bottom: 50.0),
          child: Column(
            children: <Widget>[
              showSelectedHospital(hospitalName),
              _showSelectedSection(episode),
              showSelectedDoctor(doctorSelected),
              showSelectedDate(dateSelected),
              SizedBox(
                height: 13.0,
              ),
              Container(
                child: FlatButton(
                  child: Text(
                    "OK",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context, true);
                    AddService().addDoctorAppointment(doctor);
                    AddService().closeDoctorAppointment(_admin);
                  },
                ),
              ),
            ],
          ),
        ));

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertAppointment;
        });
  }

  _buildDoneButton() {
    return Container(
      child: RaisedButton(
        child: Text("Complete"),
        onPressed: () {
          if (hospitalName &&
              episode &&
              doctorSelected &&
              dateSelected &&
              dateTimeCombination != null) {
            SearchService()
                .searchDoctorById(doctor.IDNo)
                .then((QuerySnapshot docs) {
              Doctor temp = Doctor.fromMap(docs.documents[0].data);
              if (temp.appointments.contains(dateTimeCombination)) {
                doctor.appointments.remove(dateTimeCombination);
                _admin.kapatilanSaatler.remove(dateTimeCombination);
                alrtAppointment(context);
              } else {
                alrtHospital(context, "This section is full");
              }
            });
          } else {
            alrtHospital(context, "There is missing information");
          }
        },
      ),
    );
  }
}
