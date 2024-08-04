import 'dart:typed_data';

/// This extension method contains utils to perform an XOR operation on a [Uint8List].
/// This is implemented as an extension on [Uint8List] for purely convenience and ease of access purposes.
/// The end goal here is to have semantics similar to performing this operation on integers.
extension ByteXor on Uint8List {
  /// This performs an XOR operation on each element of the current list with each element of [other].
  ///
  /// If [other] is smaller in length than this list, then the list is looped over.
  /// i.e. `[0xa,0xb,0xc]^[0xd,0de] == [0xa,0xb,0xc]^[0xd,0xe,0xd]`
  ///
  /// If [other] is larger than this list, only the first `this.length` elements of [other] are used.
  /// i.e. `[0xa,0xb]^[0xc,0xd,0xe] == [0xa,0xb]^[0xc,0xd]`
  Uint8List operator ^(Uint8List other) {
    int len = length;
    int otherLen = other.length;
    Uint8List res = Uint8List(len);

    for (var i = 0; i < len; i++) {
      res[i] = this[i] ^ other[i % otherLen];
    }

    return res;
  }

  bool deepEquals(Uint8List other) {
    List<int> thisList = toList(growable: false);
    List<int> otherList = other.toList(growable: false);
    for (var i = 0; i < length; i++) {
      if (thisList[i] != otherList[i]) {
        return false;
      }
    }
    return true;
  }
}
