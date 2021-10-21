class Attributes {
  int? heading = 0;
  String? block = '';
  bool? b = false;
  bool? i = false;

  /* NotusAttribute.italic
  NotusAttribute.link*/

  Attributes({this.heading, this.block, this.b, this.i});

  factory Attributes.fromJson(dynamic json) {
    print("attributesの中身$json");
    return Attributes(
      heading: json['heading'],
      block: json['block'],
      b: json['b'],
      i: json["i"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'heading': heading,
      'block': block,
      'b': b,
      'i': i,
    };
  }
}
