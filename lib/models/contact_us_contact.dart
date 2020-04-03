import 'dart:convert';

class ContactUsContact {
  int _id;
  String _title;
  String _phoneNumber;
  String _address;
  List<ContactUsContact> _subs;

  ContactUsContact._();

  factory ContactUsContact.fromJSON(Map<String, dynamic> jsonData) {
//    print(jsonData);
    ContactUsContact contact = ContactUsContact._();
    contact.id = jsonData['id'];
    contact.title = jsonData['title'];
    contact.phoneNumber = jsonData['phone_number'];
    contact.address = jsonData['address'];

    if (jsonData["sub"] != null) {
      List<ContactUsContact> subContacts = List();
      for (var subContact in jsonData["sub"]) {
        subContacts.add(ContactUsContact.fromJSON(subContact));
      }
      contact._subs = subContacts;
    }

    return contact;
  }

  int get id => _id;

  set id(int id) {
    _id = id;
  }

  String get address => _address;

  set address(String address) {
    _address = address;
  }

  String get phoneNumber => _phoneNumber;

  set phoneNumber(String phoneNumber) {
    _phoneNumber = phoneNumber;
  }

  String get title => _title;
  List<ContactUsContact> get subContacts => _subs;

  set title(String title) {
    _title = title;
  }
}
