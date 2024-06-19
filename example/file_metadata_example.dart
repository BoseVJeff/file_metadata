import 'dart:io';

import 'package:file_metadata/file_metadata.dart';

// Note that reading a file is an async operation.
void main() async {
  // Reading data from a GGUF file
  GgufMetadata ggufMetadata = GgufMetadata(
    // File("test/deepseek-coder-6.7b-instruct.Q6_K.gguf"),
    File("test/phi-3-mini-4k-instruct-q_4.gguf"),
  );

  // Print metadata from file
  GgufFileMetadata metadata = await ggufMetadata.getMetadataFromFile();

  print("Magic: ${metadata.magicString}");
  print("GGUF version: ${metadata.ggufVersion}");
  print("Tensor Count: ${metadata.tensorCount}");
  print("Metadata KV-Pair Count: ${metadata.metadataKvCount}");
  metadata.kvPairs.forEach((k, v) {
    if (v is List) {
      print("$k : ${v.length} items");
    } else {
      print("$k : $v");
    }
  });
  for (Tensor tensor in metadata.tensors) {
    print(
      "${tensor.name} [${tensor.tensorType.name} ^ ${tensor.nDimensions}] : ${tensor.dimensions.join(" x ")} @ ${tensor.offset.toRadixString(16)}",
    );
  }
}
