import 'dart:typed_data';

class ExtraField {
  final int headerId;
  final Uint8List data;

  const ExtraField(this.headerId, this.data);

  static List<ExtraField> fieldsFromBytes(Uint8List bytes) {
    List<ExtraField> fields = [];

    // TODO: Implement logic
    int idx = 0;
    int len = bytes.length;
    while (idx < len) {
      int id = bytes.sublist(idx, idx + 2).buffer.asUint16List().single;
      idx += 2;
      int dataLen = bytes.sublist(idx, idx + 2).buffer.asUint16List().single;
      idx += 2;
      Uint8List data = bytes.sublist(idx, idx + dataLen);
      idx += dataLen;

      fields.add(ExtraField(id, data));
    }

    return fields;
  }
}
