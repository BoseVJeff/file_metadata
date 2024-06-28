import 'package:path/path.dart' as p;

import '../base/name_metadata.dart';
import '../util/random_read_file.dart';

class GgufNameMetadata extends NameMetadata {
  const GgufNameMetadata(
    super.filename,
    super.extension, {
    this.modelName,
    this.majorVersion,
    this.minorVersion,
    this.expertsCount,
    this.parameterCount,
    this.encodingScheme,
    this.shardIndex,
    this.shardTotal,
  });

  /// Regex to get model properties from the filename.
  ///
  /// This is taken directly from the docs [in this section](https://github.com/ggerganov/ggml/blob/master/docs/gguf.md#parsing-above-naming-convention).
  static RegExp fileRegex = RegExp(
    r"^(?<model_name>[A-Za-z0-9\s-]+)(?:-v(?<major>\d+)\.(?<minor>\d+))?-(?:(?<experts_count>\d+)x)?(?<parameters>\d+[A-Za-z]?)-(?<encoding_scheme>[\w_]+)(?:-(?<shard>\d{5})-of-(?<shardTotal>\d{5}))?\.gguf$",
    multiLine: false,
  );

  /// Model Name as infered from filename.
  ///
  /// This is an null if no model can be infered.
  final String? modelName;

  /// Major model version.
  /// Use [GgufFilenameMetdata.version] if you want the full model version string.
  ///
  /// This is null and inferred to be `0` if no major version can be infered.
  final String? majorVersion;

  /// Minor model version.
  /// Use [GgufFilenameMetdata.version] if you want the full model version string.
  ///
  /// This is null and inferred to be `0` if no minor version can be infered.
  final String? minorVersion;

  /// The number of experts in the model.
  ///
  /// This is null if the model is not a MoE or if it cannot be infered.
  final int? expertsCount;

  /// The number of model parameters.
  ///
  /// This is null if the number of parameters cannot be infered.
  final String? parameterCount;

  /// The model encoding scheme.
  ///
  /// This is null if it cannot be infered.
  final String? encodingScheme;

  /// The index of this shard in the assembled model.
  /// This ususally starts from 1.
  ///
  /// This is null if the model is not sharded or if it cannot be infered.
  final int? shardIndex;

  /// The total number of shards in the model.
  ///
  /// This is null if the model is not sharded or if it cannot be infered.
  final int? shardTotal;

  factory GgufNameMetadata.fromString(String path) {
    String baseFilename = p.basename(path);

    // Parsing filename and extension.

    List<String> parts = baseFilename.split(".");

    String extension = parts.removeLast();

    String filename = parts.join(".");

    // Parsing more advanced metadata.

    // TODO: Switch to using a proper loop-based structure.
    // This would allow for more robust parsing and pinpoint exact points of error.

    final RegExpMatch? match = fileRegex.firstMatch(baseFilename);

    String? modelName =
        match?.namedGroup("model_name")?.trim().replaceAll("-", " ");

    String? majorVersion = match?.namedGroup("major");
    String? minorVersion = match?.namedGroup("minor");

    int? expertsCount = int.tryParse(
      match?.namedGroup("experts_count") ?? "",
      radix: 10,
    );

    String? parameterCount = match?.namedGroup("parameters");

    String? encodingScheme = match?.namedGroup("encoding_scheme");

    int? shardIndex = int.tryParse(
      match?.namedGroup("shard") ?? "",
      radix: 10,
    );

    int? shardTotal = int.tryParse(
      match?.namedGroup("shardTotal") ?? "",
      radix: 10,
    );

    return GgufNameMetadata(
      filename,
      extension,
      encodingScheme: encodingScheme,
      expertsCount: expertsCount,
      majorVersion: majorVersion,
      minorVersion: minorVersion,
      modelName: modelName,
      parameterCount: parameterCount,
      shardIndex: shardIndex,
      shardTotal: shardTotal,
    );
  }

  factory GgufNameMetadata.fromFile(RandomReadFile file) =>
      GgufNameMetadata.fromString(file.path);

  /// The actual version string as infered from the filename.
  String get version => "v${majorVersion ?? "0"}.${minorVersion ?? "0"}";

  @override
  bool isValid() {
    // Extension is `gguf` in any case and `modelName`, `parameterCount`, and `encodingScheme` are all set.
    return extension.toLowerCase() == "gguf" &&
        modelName != null &&
        parameterCount != null &&
        encodingScheme != null;
  }

  bool isEmpty() {
    return encodingScheme == null &&
        expertsCount == null &&
        majorVersion == null &&
        minorVersion == null &&
        modelName == null &&
        parameterCount == null &&
        shardIndex == null &&
        shardTotal == null;
  }

  @override
  String toString() {
    StringBuffer buffer = StringBuffer();
    if (isEmpty()) {
      // No metadata is available, use the filename itself.
      buffer.write(filename);
    } else {
      if (modelName != null) {
        buffer.write(modelName!.replaceAll(" ", "-"));
      } else {
        buffer.write(filename);
      }

      if (majorVersion != null && minorVersion != null) {
        buffer.writeAll(<String>["-", version]);
      }

      buffer.write("-");

      if (expertsCount != null) {
        buffer.writeAll(<String>[expertsCount!.toRadixString(10), "x"]);
      }

      buffer.write(parameterCount ?? "0B");

      buffer.write("-");

      buffer.write(encodingScheme ?? "X4_2");

      if (shardIndex != null && shardTotal != null) {
        buffer.writeAll(<String>[
          "-",
          shardIndex!.toRadixString(10).padLeft(5, "0"),
          "-of-",
          shardTotal!.toRadixString(10).padLeft(5, "0"),
        ]);
      }
    }

    buffer.writeAll(<String>[".", extension]);

    return buffer.toString();
  }
}
