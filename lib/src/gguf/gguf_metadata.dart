import 'package:file_metadata/src/file_metadata_base.dart';
import 'package:path/path.dart';

import 'gguf_filename_metdata.dart';

class GgufMetadata extends FileMetadataBase {
  GgufMetadata(super.file);

  /// Regex to get model properties from the filename.
  ///
  /// This is taken directly from the docs [in this section](https://github.com/ggerganov/ggml/blob/master/docs/gguf.md#parsing-above-naming-convention).
  static RegExp fileRegex = RegExp(
    r"^(?<model_name>[A-Za-z0-9\s-]+)(?:-v(?<major>\d+)\.(?<minor>\d+))?-(?:(?<experts_count>\d+)x)?(?<parameters>\d+[A-Za-z]?)-(?<encoding_scheme>[\w_]+)(?:-(?<shard>\d{5})-of-(?<shardTotal>\d{5}))?\.gguf$",
    multiLine: false,
  );

  @override
  GgufFilenameMetdata getMetadataFromPath() {
    String filename = basename(file.path);
    final RegExpMatch? match = fileRegex.firstMatch(filename);

    String modelName =
        match?.namedGroup("model_name")?.trim().replaceAll("-", " ") ?? "";

    String majorVersion = match?.namedGroup("major") ?? "0";
    String minorVersion = match?.namedGroup("minor") ?? "0";

    int? expertsCount = int.tryParse(
      match?.namedGroup("experts_count") ?? "",
      radix: 10,
    );

    String parameterCount = match?.namedGroup("parameters") ?? "";

    String encodingScheme = match?.namedGroup("encoding_scheme") ?? "";

    int? shardIndex = int.tryParse(
      match?.namedGroup("shard") ?? "",
      radix: 10,
    );

    int? shardTotal = int.tryParse(
      match?.namedGroup("shardTotal") ?? "",
      radix: 10,
    );

    return GgufFilenameMetdata(
      modelName,
      majorVersion,
      minorVersion,
      expertsCount,
      parameterCount,
      encodingScheme,
      shardIndex,
      shardTotal,
    );
  }
}
