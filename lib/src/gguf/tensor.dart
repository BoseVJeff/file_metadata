import 'package:file_metadata/src/gguf/tensor_types.dart';

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
