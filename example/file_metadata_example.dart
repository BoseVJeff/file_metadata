import 'dart:io';

import 'package:file_metadata/file_metadata.dart';

// Note that reading a file is an async operation.
void main() async {
  // Initialise a base object for a file of unknown type.
  FileMetadataBase metadataBase = FileMetadataBase(
    File("test/phi-3-mini-4k-instruct-q_4.gguf"),
  );

  // Call `metadataBase.isValid<T>` for each `T` that you are interested in.
  // Note that this is a `Future<bool>` as this method attempts to read the file and comes to a decision on the basis of the file contents.
  // Here, since we are checking for a GGUF file, we check for the type.

  // For the purposes of this demonstration, we are asserting that the file in question is a valid GGUF file.
  // In a more practical usecase, you may want to use an `if...else` block instead to either cancel an operation or check for another type if the file is not of the current type.

  assert(await metadataBase.isValid<GgufMetadata>());

  // We now know that the file is a valid GGUF file.
  // We therefore convert this object into a more specific type to get GGUF-specific properties.
  GgufMetadata ggufMetadata = metadataBase.asType<GgufMetadata>();

  // Now we can read all metadata from this file.

  // Note that the casting in the previous step is necessary as file metadata is not standardised.
  // This allows us to get metadata specific to a particular format.

  GgufFileMetadata metadata = await ggufMetadata.getMetadataFromFile();

  // Now we print all of the GGUF-specific metadata stored in the file to the console.
  // Note that the information printed below is only a subset of the full metadata that is obtained from the file.
  // To get a full list of all the fields available for each type, look for the corresponding `*FileMetadata` class and its various properties.
  // All of those classes implement `FileDataMetadata` so checking it out is a great way to discover all of the formats that this library can currently read metadata from.

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
