import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_turtle_v2/dbHelper/delData.dart';
import 'package:fast_turtle_v2/dbHelper/updateData.dart';
import 'package:fast_turtle_v2/models/activeAppointmentModel.dart';
import 'package:fast_turtle_v2/models/userModel.dart';
import 'package:flutter/material.dart';

class BuildAppointmentList extends StatefulWidget {
  final User user;
  BuildAppointmentList(this.user);
  @override
  _BuildAppointmentListState createState() => _BuildAppointmentListState(user);
}

class _BuildAppointmentListState extends State<BuildAppointmentList> {
  User user;
  _BuildAppointmentListState(this.user);

  String gonder;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Aktif Randevularınız"),
      ),
      body: _buildStremBuilder(context),
    );
  }

  _buildStremBuilder(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection("tblAktifRandevu")
          .where('hastaTCKN', isEqualTo: user.IDNo)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {
          return _buildBody(context, snapshot.data.documents);
        }
      },
    );
  }

  Widget _buildBody(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: EdgeInsets.only(top: 15.0),
      children: snapshot
          .map<Widget>((data) => _buildListItem(context, data))
          .toList(),
    );
  }

  _buildListItem(BuildContext context, DocumentSnapshot data) {
    final randevu = ActiveAppointment.fromSnapshot(data);

    return Padding(
      key: ValueKey(randevu.reference),
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.greenAccent,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10.0)),
        child: ListTile(
          leading: CircleAvatar(
            child: Icon(Icons.healing),
          ),
          title: Row(
            children: <Widget>[
              Text(
                randevu.doktorAdi.toString(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              SizedBox(
                width: 3.0,
              ),
              Text(
                randevu.doktorSoyadi.toString(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
            ],
          ),
          subtitle: Text(randevu.randevuTarihi),
          trailing: Text(
            "İptal Et",
            style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent),
          ),
          onTap: () {
            alrtRandevuIptalEt(context, randevu);
          },
        ),
      ),
    );
  }

  void alrtRandevuIptalEt(BuildContext context, ActiveAppointment rand) {
    var alrtRandevu = AlertDialog(
      title: Text(
        "Randevuyu iptal etmek istediğinize emin misiniz?",
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Hayır"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        SizedBox(
          width: 5.0,
        ),
        FlatButton(
          child: Text(
            "Evet",
            textAlign: TextAlign.center,
          ),
          onPressed: () {
            UpdateService()
                .updateDoctorAppointments(rand.doktorTCKN, rand.randevuTarihi);
            DelService().deleteActiveAppointment(rand);
            Navigator.pop(context);
            Navigator.pop(context, true);
          },
        )
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alrtRandevu;
        });
  }
}
