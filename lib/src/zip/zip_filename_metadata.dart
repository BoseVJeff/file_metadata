import '../file_metadata_base.dart';

class ZipFilenameMetadata implements FilenameMetadata {
  final String _filename;

  const ZipFilenameMetadata(this._filename);

  (String name, String ext) _parts() {
    List<String> parts = _filename.split(".");
    String ext = parts.removeLast();
    // Extension list reffered from [Wikipedia](https://en.wikipedia.org/wiki/List_of_archive_formats)
    if (ext == "gz") {
      if (parts.last == "tar") {
        String secExt = parts.removeLast();
        return (parts.join("."), [secExt, ext].join("."));
      } else {
        return (parts.join("."), ext);
      }
    }
    return (parts.join("."), ext);
  }

  @override
  String get fileName => _parts().$1;

  @override
  String get fileExtension => _parts().$2;
}
