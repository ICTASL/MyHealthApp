import 'dart:convert';

class Registration {
  final String name;
  final String email;
  final String address;
  final double lattitude;
  final double longitude;
  final String mobileImei;
  final List<String> caseList;
  final String nic;
  final String passport;
  final String country;
  final String age;
  final String gender;
  Registration({
    this.name,
    this.email,
    this.address,
    this.lattitude,
    this.longitude,
    this.mobileImei,
    this.caseList,
    this.nic = "",
    this.passport = "",
    this.country = "",
    this.age,
    this.gender,
  });

  Registration copyWith({
    String name,
    String email,
    String address,
    double lattitude,
    double longitude,
    String mobileImei,
    List<String> caseList,
    String nic,
    String passport,
    String country,
    String age,
    String gender,
  }) {
    return Registration(
      name: name ?? this.name,
      email: email ?? this.email,
      address: address ?? this.address,
      lattitude: lattitude ?? this.lattitude,
      longitude: longitude ?? this.longitude,
      mobileImei: mobileImei ?? this.mobileImei,
      caseList: caseList ?? this.caseList,
      nic: nic ?? this.nic,
      passport: passport ?? this.passport,
      country: country ?? this.country,
      age: age ?? this.age,
      gender: gender ?? this.gender,
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'name': name,
      'email': email,
      'address': address,
      'lattitude': lattitude,
      'longitude': longitude,
      'mobileImei': mobileImei,
      'caseList': caseList,
      'nic': nic,
      'passport': passport,
      'country': country,
      'age': age,
      'gender': gender,
    };
    return map;
  }

  static Registration fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Registration(
      name: map['name'],
      email: map['email'],
      address: map['address'],
      lattitude: map['lattitude'],
      longitude: map['longitude'],
      mobileImei: map['mobileImei'],
      caseList: List<String>.from(map['caseList']),
      nic: map['nic'],
      passport: map['passport'],
      country: map['country'],
      age: map['age'],
      gender: map['gender'],
    );
  }

  String toJson() => json.encode(toMap());

  static Registration fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'Registration(name: $name, email: $email, address: $address, lattitude: $lattitude, longitude: $longitude, mobileImei: $mobileImei, caseList: $caseList, nic: $nic, passport: $passport, country: $country, age: $age, gender: $gender)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Registration &&
        o.name == name &&
        o.email == email &&
        o.address == address &&
        o.lattitude == lattitude &&
        o.longitude == longitude &&
        o.mobileImei == mobileImei &&
        o.caseList == caseList &&
        o.nic == nic &&
        o.passport == passport &&
        o.country == country &&
        o.age == age &&
        o.gender == gender;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        email.hashCode ^
        address.hashCode ^
        lattitude.hashCode ^
        longitude.hashCode ^
        mobileImei.hashCode ^
        caseList.hashCode ^
        nic.hashCode ^
        passport.hashCode ^
        country.hashCode ^
        age.hashCode ^
        gender.hashCode;
  }
}
