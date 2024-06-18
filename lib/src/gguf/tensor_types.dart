// ignore_for_file: constant_identifier_names, deprecated_member_use_from_same_package

enum TensorType {
  F32(0),
  F16(1),
  Q4_0(2),
  Q4_1(3),
  @Deprecated("Support has been removed")
  Q4_2(4),
  @Deprecated("Support has been removed")
  Q4_3(5),
  Q5_0(6),
  Q5_1(7),
  Q8_0(8),
  Q8_1(9),
  Q2_k(10),
  Q3_k(11),
  Q4_k(12),
  Q5_k(13),
  Q6_k(14),
  Q8_k(15),
  IQ2_XXS(16),
  IQ2_XS(17),
  IQ3_XXS(18),
  IQ1_S(19),
  IQ4_NL(20),
  IQ3_S(21),
  IQ2_S(22),
  IQ4_XS(23),
  I8(24),
  I16(25),
  I32(26),
  I64(27),
  F64(28),
  IQ1_M(29),
  // The next type does not have an ID associated with it and is thus being commented out
  // GGML_TYPE_COUNT
  ;

  final int typeId;

  const TensorType(this.typeId);

  factory TensorType.fromId(int id) {
    switch (id) {
      case 0:
        return TensorType.F32;
      case 1:
        return TensorType.F16;
      case 2:
        return TensorType.Q4_0;
      case 3:
        return TensorType.Q4_1;
      case 4:
        return TensorType.Q4_2;
      case 5:
        return TensorType.Q4_3;
      case 6:
        return TensorType.Q5_0;
      case 7:
        return TensorType.Q5_1;
      case 8:
        return TensorType.Q8_0;
      case 9:
        return TensorType.Q8_1;
      case 10:
        return TensorType.Q2_k;
      case 11:
        return TensorType.Q3_k;
      case 12:
        return TensorType.Q4_k;
      case 13:
        return TensorType.Q5_k;
      case 14:
        return TensorType.Q6_k;
      case 15:
        return TensorType.Q8_k;
      case 16:
        return TensorType.IQ2_XXS;
      case 17:
        return TensorType.IQ2_XS;
      case 18:
        return TensorType.IQ3_XXS;
      case 19:
        return TensorType.IQ1_S;
      case 20:
        return TensorType.IQ4_NL;
      case 21:
        return TensorType.IQ3_S;
      case 22:
        return TensorType.IQ2_S;
      case 23:
        return TensorType.IQ4_XS;
      case 24:
        return TensorType.I8;
      case 25:
        return TensorType.I16;
      case 26:
        return TensorType.I32;
      case 27:
        return TensorType.I64;
      case 28:
        return TensorType.F64;
      case 29:
        return TensorType.IQ1_M;
      default:
        throw UnknownTensorType(id);
    }
  }
}

class UnknownTensorType {
  final int id;

  const UnknownTensorType(this.id);
}
