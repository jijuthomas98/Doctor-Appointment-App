import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_turtle_v2/dbHelper/searchData.dart';
import 'package:fast_turtle_v2/models/adminModel.dart';
import 'package:fast_turtle_v2/models/doctorModel.dart';
import 'package:fast_turtle_v2/models/userModel.dart';
import 'package:fast_turtle_v2/screens/adminHomePage.dart';
import 'package:fast_turtle_v2/screens/doctorHomePage.dart';
import 'package:fast_turtle_v2/screens/registerPage.dart';
import 'package:fast_turtle_v2/screens/userHomePage.dart';
import 'package:flutter/material.dart';
import 'package:fast_turtle_v2/mixins/validation_mixin.dart';

class WelcomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WelcomePageState();
  }
}

class WelcomePageState extends State
    with SingleTickerProviderStateMixin, ValidationMixin {
  TabController _tabController;
  final userFormKey = GlobalKey<FormState>();
  final doctorFormKey = GlobalKey<FormState>();
  final adminFormKey = GlobalKey<FormState>();
  User user = User();
  Doctor doctor = Doctor();
  Admin admin = Admin();
  Future<QuerySnapshot> incomingDate;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    this.incomingDate = Firestore.instance.collection('tblUser').getDocuments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Doctor Appointment System",
          textDirection: TextDirection.ltr,
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white70,
          tabs: <Widget>[
            Text(
              "User",
              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
            ),
            Text(
              "Doctor",
              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
            ),
            Text(
              "Admin",
              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                pagePlanWithForm(IDNoField(0, context), passwordField(0),
                    "Welcome", userFormKey),
                registerButton()
              ])),
          pagePlanWithForm(IDNoField(1, context), passwordField(1),
              "Doctor Login", doctorFormKey),
          pagePlanWithForm(adminNicknameField(), passwordField(2),
              "Admin Login", adminFormKey)
        ],
      ),
    );
  }

  void basicNavigator(dynamic page) async {
    bool result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => page));

    if (result != null && result == true) {
      RegisterPageState.alrtDone(context);
    }
  }

  Container registerButton() {
    return Container(
      child: FlatButton(
        child: Text(
          "Register",
          style: TextStyle(fontSize: 15.0),
        ),
        textColor: Colors.black,
        splashColor: Colors.cyanAccent,
        onPressed: () {
          basicNavigator(RegisterPage());
        },
      ),
    );
  }

  /*Container pagePlan(String pageHeader, String labelText) {
    return Container(
        padding: EdgeInsets.only(top: 30.0, left: 10.0, right: 10.0),
        // singlechildscrollview olmazsa, textfield a veri girişi yapılmak istendiğinde ekrana klavye de yerleşiyor ve görüntü bozuluyor, ...
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.only(top: 13.0, bottom: 10.0),
                  child: pageHeaderPlan(pageHeader)),
              TextField(
                  controller: txtTCNO,
                  maxLength: 11,
                  decoration: labelTextPlan(labelText)),
              TextField(
                controller: txtSifre,
                decoration: InputDecoration(labelText: "Şifre"),
              ),
              Container(
                padding: EdgeInsets.only(top: 30.0),
                child: FlatButton(
                  child: Text(
                    "Giriş Yap",
                    style: TextStyle(fontSize: 22.0),
                  ),
                  textColor: Colors.blueAccent,
                  splashColor: Colors.cyanAccent,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ));
  } */

  InputDecoration labelTextPlan(String value) {
    return InputDecoration(labelText: value);
  }

  Text pageHeaderPlan(String value) {
    return Text(
      value,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
      style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
    );
  }

  Container pagePlanWithForm(Widget firstTextField, Widget secondTextField,
      String pageHeader, GlobalKey<FormState> formKey) {
    return Container(
        margin: EdgeInsets.only(top: 25.0, right: 25.0, left: 25.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.only(top: 13.0, bottom: 10.0),
                  child: pageHeaderPlan(pageHeader),
                ),
                firstTextField,
                secondTextField,
                loginButton(formKey)
              ],
            ),
          ),
        ));
  }

  Widget IDNoField(int tabIndex, BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "ID number",
        labelStyle: TextStyle(
            fontSize: 17.0, fontWeight: FontWeight.bold, color: Colors.grey),
      ),
      onSaved: (String value) {
        if (tabIndex == 0) {
          user.IDNo = value;
        } else {
          doctor.kimlikNo = value;
        }
      },
    );
  }

  Widget passwordField(int tabIndex) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Password",
        labelStyle: TextStyle(
            fontSize: 17.0, fontWeight: FontWeight.bold, color: Colors.grey),
      ),
      validator: validatePassword,
      obscureText: true,
      onSaved: (String value) {
        if (tabIndex == 0) {
          user.password = value;
        } else if (tabIndex == 1) {
          doctor.sifre = value;
        } else {
          admin.password = value;
        }
      },
    );
  }

  Widget adminNicknameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "User Name :"),
      validator: validateAdmin,
      onSaved: (String value) {
        admin.nickname = value;
      },
    );
  }

  bool VerifyIDNo = false;
  bool confirmPassword = false;
  var tempSearchStore = [];

  //girilen kimlik numarasına kayıtlı bir kullanıcı olup olmadıpını arayan metot...
  initiateSearch(enteredID, enteredPassword, int tabIndex, String searchWhere,
      String searchPass) {
    SearchService()
        .searchById(enteredID, enteredPassword, tabIndex)
        .then((QuerySnapshot docs) {
      for (int i = 0; i < docs.documents.length; i++) {
        tempSearchStore.add(docs.documents[i].data);

        if (tabIndex == 0) {
          user = User.fromMap(docs.documents[i].data);
        } else if (tabIndex == 1) {
          doctor = Doctor.fromMap(docs.documents[i].data);
        } else if (tabIndex == 2) {
          admin = Admin.fromMap(docs.documents[i].data);
        }
      }
    });
    for (var item in tempSearchStore) {
      if (item[searchWhere] == enteredID &&
          item[searchPass] == enteredPassword) {
        VerifyIDNo = true;
        confirmPassword = true;
      }
    }
  }

  Widget loginButton(GlobalKey<FormState> formKey) {
    return Container(
      padding: EdgeInsets.only(top: 30.0),
      child: FlatButton(
        child: Text(
          "Login",
          style: TextStyle(fontSize: 22.0),
        ),
        textColor: Colors.blueAccent,
        splashColor: Colors.cyanAccent,
        onPressed: () {
          VerifyIDNo = false;
          confirmPassword = false;
          formKey.currentState.validate();
          formKey.currentState.save();
          if (formKey == userFormKey) {
            initiateSearch(user.IDNo, user.password, 0, 'IDNo', 'Password');

            if (VerifyIDNo && confirmPassword) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UserHomePage(user)));
            }
          } else if (formKey == doctorFormKey) {
            initiateSearch(
                doctor.kimlikNo, doctor.sifre, 1, 'IDNo', 'Password');

            if (VerifyIDNo && confirmPassword) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DoctorHomePage(doctor)));
            }
          } else if (formKey == adminFormKey) {
            initiateSearch(
                admin.nickname, admin.password, 2, 'nickname', 'password');

            if (VerifyIDNo && confirmPassword) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AdminHomePage(admin)));
            }
          }
        },
      ),
    );
  }
}
