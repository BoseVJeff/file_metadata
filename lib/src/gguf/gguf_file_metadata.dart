import 'package:file_metadata/file_metadata.dart';
import 'package:file_metadata/src/gguf/file_type.dart';

import 'tensor_types.dart';

/// The metadata for the GGUF file as obtained by parsing the file itself.
///
/// This is specifically for the GGUF v3 format.
class GgufFileMetadata implements FileDataMetadata {
  /// The magic bytes encoded as a UTF-8 String
  ///
  /// Remember to check that this is equal to `GGUF` for a valid GGUF model file.
  final String magicString;

  /// The version of GGUF the file was created with.
  ///
  /// At the time of writing, the latest version is `3`.
  final int ggufVersion;

  /// The `tensor_count` of the model.
  final int tensorCount;

  /// The number of metadata key-value pairs
  final int metadataKvCount;

  /// Metadata key-value pairs.
  final Map<String, Object> kvPairs;

  /// The byte alignment width
  ///
  /// This must be a multiple of 8 according to the docs.
  /// The default value used here is `32//8=4` as mentioned in the docs.
  final int alignment;

  /// The info for all tensors in the file.
  ///
  /// This contains tensor information and the tensor offsets where they can be loaded from.
  ///
  /// Note that the offsets are from `tensor_data` as mentioned in the docs.
  final List<Tensor> tensors;

  /// The file type.
  ///
  /// This is an indicator of what type of data the file usually contains.
  ///
  /// For a list of all possible file types, look at the values of [FileType].
  FileType get fileType => FileType.fromId(
        (kvPairs["general.file_type"] as int?) ?? -1,
      );

  const GgufFileMetadata(
    this.magicString,
    this.ggufVersion,
    this.tensorCount,
    this.metadataKvCount, {
    this.alignment = 8,
    this.kvPairs = const {},
    this.tensors = const [],
  });
}

class Tensor {
  // TODO: Look into having a method that can load/unload the tensor at the offset stored in this class from the file provided.
  final String name;
  final int nDimensions;
  final List<int> dimensions;
  final TensorType tensorType;
  final int offset;

  const Tensor(
    this.name,
    this.nDimensions,
    this.dimensions,
    this.tensorType,
    this.offset,
  );
}
