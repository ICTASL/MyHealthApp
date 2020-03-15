class FCMMessage {
  String title;
  String body;
  String type;

  FCMMessage({this.title, this.body, this.type});

  factory FCMMessage.decode(Map<String, dynamic> json) {
    return FCMMessage(
        title: json['notification']['title'],
        body: json['notification']['body'],
        type: json['data']['type']);
  }
}
