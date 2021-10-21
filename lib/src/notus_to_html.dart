import 'dart:convert';

import 'package:zefyrka/zefyrka.dart';

import 'models/notus_node.dart';

class NotusToHTML {
  static NotusNode checkInsartIsString(i) {
    if (i.toString().contains("{_type: hr, _inline: false}") == false) {
      var note = NotusNode.fromJson(i);
      return note;
    } else {
      var map = {
        "insert": "",
        "attributes": {"hr": true}
      };
      var note = NotusNode.fromJson(map);
      return note;
    }
  }

  static List<NotusNode> _getJsonLine(var node) {
    String childString = jsonEncode(node.toDelta());
    List<NotusNode> line =
        List<NotusNode>.from(jsonDecode(childString).map((i) {
      //An error occurs because hr is a Map type. Avoidance processing.
      print("：${i.toString()}");
      NotusNode note = checkInsartIsString(i);
      return note;
    }));
    return line;
  }

  static getHtmlFromNotus(NotusDocument notusDocument) {
    String html = '';
    for (int i = 0; i < notusDocument.root.children.length; i++) {
      List<NotusNode> notusDocLine =
          _getJsonLine(notusDocument.root.children.elementAt(i));
      if (notusDocument.root.children.elementAt(i).runtimeType == LineNode) {
        if (notusDocLine.elementAt(notusDocLine.length - 1) == null) {
          return;
        }
        html = html + _decodeNotusLine(notusDocLine);
      } else if (notusDocument.root.children.elementAt(i).runtimeType ==
          BlockNode) {
        html = html + _decodeNotusBlock(notusDocLine);
      }
    }
    return html;
  }

  static _getLineAttributes(NotusNode notusModel) {
    if (notusModel.attributes == null) {
      return ['<p>', '</p>'];
    } else if (notusModel.attributes!.heading == 1) {
      return ['<h1>', '</h1>'];
    } else if (notusModel.attributes!.heading == 2) {
      return ['<h2>', '</h2>'];
    } else if (notusModel.attributes!.heading == 3) {
      return ['<h3>', '</h3>'];
    } else if (notusModel.attributes!.b == true) {
      return ['<b>', '</b>'];
    } else if (notusModel.attributes!.i == true) {
      return ['<i>', '</i>'];
    } else if (notusModel.attributes!.hr == true) {
      return ['<hr>', ''];
    }
  }

  static _getBlockAttributes(NotusNode notusModel) {
    if (notusModel.attributes == null) {
      return ["", ""];
    } else if (notusModel.attributes!.block == 'ul') {
      return ['<ul>', '</ul>'];
    } else if (notusModel.attributes!.block == 'ol') {
      return ['<ol>', '</ol>'];
    } else if (notusModel.attributes!.block == 'code') {
      return ['<code>', '</code>'];
    } else if (notusModel.attributes!.block == 'quote') {
      return ['<blockquote>', '</blockquote>'];
    }
  }

  static _decodeNotusLine(List<NotusNode> notusDocLine) {
    String html = '';
    List<String> attributes =
        _getLineAttributes(notusDocLine.elementAt(notusDocLine.length - 1)) ??
            ['', ''];
    html = attributes[0] + _decodeLineChildren(notusDocLine) + attributes[1];
    return html;
  }

  static String _decodeLineChildren(List<NotusNode> notusDocLine) {
    String html = '';
    for (int i = 0; i < notusDocLine.length; i++) {
      if (notusDocLine.elementAt(i).attributes == null) {
        html = html + notusDocLine.elementAt(i).insert!;
      } else if (notusDocLine.elementAt(i).attributes!.b == true) {
        html = html + '<b>' + notusDocLine.elementAt(i).insert! + '</b>';
      } else if (notusDocLine.elementAt(i).attributes!.i == true) {
        //add italic
        html = html + '<i>' + notusDocLine.elementAt(i).insert! + '</i>';
      } else if (notusDocLine.elementAt(i).attributes!.hr == true) {
        //add hr
        html = html + '<hr>';
      }
    }
    return html;
  }

  static String _decodeNotusBlock(List<NotusNode> notusDocLine) {
    String html = '';
    String childrenHtml = '';
    List<List<NotusNode>> blockLinesList = _splitBlockIntoLines(notusDocLine);

    List<String> attributes =
        _getBlockAttributes(notusDocLine.elementAt(notusDocLine.length - 1)) ??
            ["", ""];
    for (int i = 0; i < blockLinesList.length; i++) {
      childrenHtml = childrenHtml +
          '<li>' +
          _decodeNotusLine(blockLinesList.elementAt(i)) +
          '</li>';
    }

    html = attributes[0] + childrenHtml + attributes[1];
    return html;
  }

  static _splitBlockIntoLines(List<NotusNode> notusDocLine) {
    List<List<NotusNode>> blockLinesList = [];
    List<int> sublistBreakPoints = [];

    for (int i = 0; i < notusDocLine.length; i++) {
      if (notusDocLine.elementAt(i).insert == '\n') {
        sublistBreakPoints.add(i);
      }
    }

    for (int i = 0; i < sublistBreakPoints.length; i++) {
      if (i == 0) {
        blockLinesList
            .add(notusDocLine.sublist(i, sublistBreakPoints.elementAt(i)));
      } else {
        if (i < sublistBreakPoints.length - 1) {
          blockLinesList.add(notusDocLine.sublist(
              sublistBreakPoints.elementAt(i - 1),
              sublistBreakPoints.elementAt(i)));
        } else {
          blockLinesList.add(notusDocLine.sublist(
              sublistBreakPoints.elementAt(i - 1), notusDocLine.length - 1));
        }
      }
    }
    return blockLinesList;
  }
}
