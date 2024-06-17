import 'package:file_metadata/src/file_metadata_base.dart';

class GgufFilenameMetdata implements FilenameMetadata {
  /// Model Name as infered from filename.
  ///
  /// This is an empty string of no model can be infered.
  final String modelName;

  /// Major model version.
  /// Use [GgufFilenameMetdata.version] if you want the full model version string.
  ///
  /// This is equal to 0 if no major version can be infered.
  final String majorVersion;

  /// Minor model version.
  /// Use [GgufFilenameMetdata.version] if you want the full model version string.
  ///
  /// This is equal to 0 if no minor version can be infered.
  final String minorVersion;

  /// The number of experts in the model.
  ///
  /// This is null if the model is not a MoE or if it cannot be infered.
  final int? expertsCount;

  /// The number of model parameters.
  ///
  /// This is an empty string if the number of parameters cannot be infered.
  final String parameterCount;

  /// The model encoding scheme.
  ///
  /// This is an empty string if it cannot be infered.
  final String encodingScheme;

  /// The index of this shard in the assembled model.
  /// This ususally starts from 1.
  ///
  /// This is null if the model is not sharded or if it cannot be infered.
  final int? shardIndex;

  /// The total number of shards in the model.
  ///
  /// This is null if the model is not sharded or if it cannot be infered.
  final int? shardTotal;

  /// The metadata as inferred from the filename of a GGUF file.
  ///
  /// This is typically obtained as a product of
  const GgufFilenameMetdata(
    this.modelName,
    this.majorVersion,
    this.minorVersion,
    this.expertsCount,
    this.parameterCount,
    this.encodingScheme,
    this.shardIndex,
    this.shardTotal,
  );

  /// The actual version string as infered from the filename.
  ///
  /// Note that this property must only be accessed AFTER calling [GgmlMetadata.parseFilename].
  String get version => "v$majorVersion.$minorVersion";
}
