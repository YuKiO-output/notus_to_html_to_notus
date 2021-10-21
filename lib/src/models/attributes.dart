class Attributes {
  int? heading = 0;
  String? block = '';
  bool? b = false;
  bool? i = false;
  bool? hr = false;

  /* NotusAttribute.italic
  NotusAttribute.link*/

  Attributes({this.heading, this.block, this.b, this.i, this.hr});

  factory Attributes.fromJson(dynamic json) {
    print("attributesの中身$json");
    return Attributes(
        heading: json['heading'],
        block: json['block'],
        b: json['b'],
        i: json["i"],
        hr: json["hr"]);
  }

  Map<String, dynamic> toJson() {
    return {
      'heading': heading,
      'block': block,
      'b': b,
      'i': i,
      'hr': hr,
    };
  }
}
