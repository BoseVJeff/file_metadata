// ignore_for_file: constant_identifier_names, deprecated_member_use_from_same_package

enum FileType {
  ALL_F32(0),
  MOSTLY_F16(1),
  MOSTLY_Q4_0(2),
  MOSTLY_Q4_1(3),
  MOSTLY_Q4_1_SOME_F16(4),
  @Deprecated("Support has been removed")
  MOSTLY_Q4_2(5),
  @Deprecated("Support has been removed")
  MOSTLY_Q4_3(6),
  MOSTLY_Q8_0(7),
  MOSTLY_Q5_0(8),
  MOSTLY_Q5_1(9),
  MOSTLY_Q2_K(10),
  MOSTLY_Q3_K_S(11),
  MOSTLY_Q3_K_M(12),
  MOSTLY_Q3_K_L(13),
  MOSTLY_Q4_K_S(14),
  MOSTLY_Q4_K_M(15),
  MOSTLY_Q5_K_S(16),
  MOSTLY_Q5_K_M(17),
  MOSTLY_Q6_K(18);

  final int typeId;

  const FileType(this.typeId);

  static FileType fromId(int id) {
    switch (id) {
      case 0:
        return FileType.ALL_F32;
      case 1:
        return FileType.MOSTLY_F16;
      case 2:
        return FileType.MOSTLY_Q4_0;
      case 3:
        return FileType.MOSTLY_Q4_1;
      case 4:
        return FileType.MOSTLY_Q4_1_SOME_F16;
      case 5: // support removed
        return FileType.MOSTLY_Q4_2;
      case 6: // support removed
        return FileType.MOSTLY_Q4_3;
      case 7:
        return FileType.MOSTLY_Q8_0;
      case 8:
        return FileType.MOSTLY_Q5_0;
      case 9:
        return FileType.MOSTLY_Q5_1;
      case 10:
        return FileType.MOSTLY_Q2_K;
      case 11:
        return FileType.MOSTLY_Q3_K_S;
      case 12:
        return FileType.MOSTLY_Q3_K_M;
      case 13:
        return FileType.MOSTLY_Q3_K_L;
      case 14:
        return FileType.MOSTLY_Q4_K_S;
      case 15:
        return FileType.MOSTLY_Q4_K_M;
      case 16:
        return FileType.MOSTLY_Q5_K_S;
      case 17:
        return FileType.MOSTLY_Q5_K_M;
      case 18:
        return FileType.MOSTLY_Q6_K;
      default:
        throw UnknownFileType(id);
    }
  }
}

class UnknownFileType implements Exception {
  final int id;
  const UnknownFileType(this.id);
}
