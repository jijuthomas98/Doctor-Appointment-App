import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_turtle_v2/dbHelper/searchData.dart';
import 'package:fast_turtle_v2/models/activeAppointmentModel.dart';
import 'package:fast_turtle_v2/models/passiveAppoModel.dart';
import 'package:fast_turtle_v2/models/sectionModel.dart';
import 'package:fast_turtle_v2/models/userModel.dart';
import 'package:fast_turtle_v2/models/doctorModel.dart';
import 'package:fast_turtle_v2/models/adminModel.dart';
import 'package:fast_turtle_v2/models/hospitalModel.dart';

class AddService {
  String saveUser(User user) {
    Firestore.instance.collection('tblKullanici').document().setData({
      'ad': user.name,
      'soyad': user.lastName,
      'kimlikNo': user.IDNo,
      'cinsiyet': user.gender,
      'dogumTarihi': user.DOB,
      'dogumYeri': user.birthPlace,
      'sifre': user.password
    });
    return 'kullanıcı ekleme işlemi Tamamlandı';
  }

  void saveDoctor(Doctor dr, Section bolumu, Hospital hastanesi) {
    var randevular = [];
    Firestore.instance.collection('tblDoktor').document().setData({
      'kimlikNo': dr.IDNo,
      'ad': dr.name,
      'soyad': dr.lastName,
      'sifre': dr.password,
      'bolumId': bolumu.bolumId,
      'hastaneId': hastanesi.hastaneId,
      'cinsiyet': dr.gender,
      'dogumTarihi': dr.DOB,
      'dogumYeri': dr.birthPlace,
      'favoriSayaci': 0,
      'randevular': randevular
    });
  }

  void addActiveAppointment(Doctor dr, User user, String tarih) {
    Firestore.instance.collection('tblAktifRandevu').document().setData({
      'doktorTCKN': dr.IDNo,
      'hastaTCKN': user.IDNo,
      'randevuTarihi': tarih,
      'doktorAdi': dr.name,
      'doktorSoyadi': dr.lastName,
      'hastaAdi': user.name,
      'hastaSoyadi': user.lastName
    });
  }

  void addDoctorToUserFavList(PassAppointment rand) {
    Firestore.instance.collection('tblFavoriler').document().setData({
      'doktorTCKN': rand.doktorTCKN,
      'hastaTCKN': rand.hastaTCKN,
      'doktorAdi': rand.doktorAdi,
      'doktorSoyadi': rand.doktorSoyadi,
      'hastaAdi': rand.hastaAdi,
      'hastaSoyadi': rand.hastaSoyadi
    });
  }

  void addPastAppointment(ActiveAppointment randevu) {
    Firestore.instance.collection('tblRandevuGecmisi').document().setData({
      'doktorTCKN': randevu.doktorTCKN,
      'hastaTCKN': randevu.hastaTCKN,
      'islemTarihi': randevu.randevuTarihi,
      'doktorAdi': randevu.doktorAdi,
      'doktorSoyadi': randevu.doktorSoyadi,
      'hastaAdi': randevu.hastaAdi,
      'hastaSoyadi': randevu.hastaSoyadi
    });
  }

  addDoctorAppointment(Doctor doktor) {
    Firestore.instance
        .collection("tblDoktor")
        .document(doktor.reference.documentID)
        .setData({'randevular': doktor.appointments}, merge: true);
  }

  closeDoctorAppointment(Admin admin) {
    Firestore.instance
        .collection("tblAdmin")
        .document(admin.reference.documentID)
        .setData({'kapatilanSaatler': admin.kapatilanSaatler}, merge: true);
  }

  String saveAdmin(Admin admin) {
    Firestore.instance.collection("tblAdmin").document().setData({
      'Id': admin.id,
      'nicname': admin.nickname,
      'password': admin.password
    });
    return 'Admin ekleme işlem tamamlandı';
  }

  String saveHospital(Hospital hastane) {
    SearchService().getLastHospitalId().then((QuerySnapshot docs) {
      Firestore.instance.collection("tblHastane").document().setData({
        'hastaneAdi': hastane.hastaneAdi,
        'hastaneId': docs.documents[0]['hastaneId'] + 1,
      });
    });

    return 'Hastane kaydı tamamlandı';
  }

  String saveSection(Section bolum, Hospital hastane) {
    SearchService().getLastSectionId().then((QuerySnapshot docs) {
      Firestore.instance.collection("tblBolum").document().setData({
        "bolumAdi": bolum.bolumAdi,
        "bolumId": docs.documents[0]["bolumId"] + 1,
        "hastaneId": hastane.hastaneId
      });
    });
    return "Bölüm ekleme tamamlandı";
  }
}
