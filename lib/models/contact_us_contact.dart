class ContactUsContact {
  int _id;
  String _title;
  String _phoneNumber;
  String _address;

  ContactUsContact._();

  factory ContactUsContact.fromJSON(Map<String, dynamic> jsonData) {
    ContactUsContact contact = ContactUsContact._();
    contact.id = jsonData['id'];
    contact.title = jsonData['title'];
    contact.phoneNumber = jsonData['phone_number'];
    contact.address = jsonData['address'];
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

  set title(String title) {
    _title = title;
  }
}
