import 'dart:convert';

class ContactUsContact {
  int id;
  String title;
  String subTitle;
  String address;
  String link;
  bool titleTranslate;
  bool subtitleTranslate;
  List<ContactUsContact> subContacts;

  ContactUsContact._();

  factory ContactUsContact.fromJSON(Map<String, dynamic> jsonData) {
//    print(jsonData);
    ContactUsContact contact = ContactUsContact._();
    contact.id = jsonData['id'];
    contact.title = jsonData['title'];
    contact.subTitle = jsonData['sub_title'];
    contact.link = jsonData['link'];
    contact.address = jsonData['address'];
    contact.titleTranslate = jsonData['title_translate'];
    contact.subtitleTranslate = jsonData['subtitle_translate'];

    if (jsonData["sub"] != null) {
      List<ContactUsContact> subContacts = List();
      for (var subContact in jsonData["sub"]) {
        subContacts.add(ContactUsContact.fromJSON(subContact));
      }
      contact.subContacts = subContacts;
    }

    return contact;
  }
}
