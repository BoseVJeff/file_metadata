@TestOn("windows")

import 'dart:ffi';

import 'package:file_metadata/src/util/dos_date_time.dart';
import 'package:test/test.dart';
import 'package:win32/win32.dart';
import 'package:ffi/ffi.dart';

void main() {
  test('Misc', () {
    // 09:08:32
    // int time = 0x1049;
    int time = 0x4910;
    // 06-06-2024
    // int date = 0xC658;
    int date = 0x58C6;

    DateTime? win32DateTime = win32DateTimeFromInt(date, time);

    DateTime dartDateTime = DosDateTime.fromInt(date, time);
    // print(dartDateTime);

    expect(dartDateTime, equals(win32DateTime));
  });

  test('DOS Timestamp', () {
    expect(
      DosDateTime.fromTimestamp(0x665b12d2),
      equals(DateTime.utc(2024, 06, 01, 12, 23, 46)),
    );
  });
}

DateTime? win32DateTimeFromInt(int date, int time) {
  Pointer<FILETIME> fileTime = calloc<FILETIME>();
  Pointer<SYSTEMTIME> systemTime = calloc<SYSTEMTIME>();

  DateTime? win32DateTime;

  try {
    int status = DosDateTimeToFileTime(date, time, fileTime);

    if (status == 0) {
      throw Exception("Failed to convert to FileTime!");
    } else {
      status = FileTimeToSystemTime(fileTime, systemTime);

      if (status == 0) {
        throw Exception("Failed to convert to SystemTime!");
      } else {
        SYSTEMTIME t = systemTime.ref;
        win32DateTime = DateTime(
          t.wYear,
          t.wMonth,
          t.wDay,
          t.wHour,
          t.wMinute,
          t.wSecond,
          t.wMilliseconds,
        );
        // print(win32DateTime);
      }
    }
  } finally {
    free(systemTime);
    free(fileTime);
  }

  return win32DateTime;
}
