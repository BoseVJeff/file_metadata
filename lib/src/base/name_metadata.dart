import '../util/random_read_file.dart';

abstract class NameMetadata {
  final String filename;

  final String extension;

  const NameMetadata(this.filename, this.extension);

  factory NameMetadata.fromString(String path) => throw UnimplementedError();

  factory NameMetadata.fromFile(RandomReadFile file) =>
      throw UnimplementedError();

  bool isValid();
}
