// TODO: Put public facing types in this file.

import 'dart:io';

import 'package:file_metadata/file_metadata.dart';
import 'package:file_metadata/src/zip/zip_metadata.dart';
import 'package:meta/meta.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';

class FileMetadataBase {
  /// The target file.
  final File file;

  /// This is the default constructor.
  ///
  /// Attempt to ensure that the [file] exists before attempting to call methods that require file access.
  const FileMetadataBase(this.file);

  /// Get mime-type for file.
  ///
  /// This method will attempt to infer the mime-type purely from the file name.
  ///
  /// To get a more comprehensive result, use [FileMetaDatabase.getMimeTypeFromFile] instead.
  String? get mimeTypeFromPath => lookupMimeType(file.path);

  /// Get mime-type for file
  ///
  /// This method will open and read the file.
  ///
  /// If this is undesireable, use [FileMetadataBase.mimeTypeFromPath] instead.
  ///
  /// Throws [FileSystemException] if there is an error opening/reading the file.
  String? getMimeTypeFromFile() {
    List<int> headerBytes = [];
    // Reading the bare minimum number of bytes that the lookup needs.
    file.openRead(0, defaultMagicNumbersMaxLength).forEach(
      (element) {
        headerBytes.addAll(element);
      },
    );
    return lookupMimeType(file.path, headerBytes: headerBytes);
  }

  static Map<Type, Function(File file)> typeConstructorMap = {
    GgufMetadata: (file) => GgufMetadata(file),
    ZipMetadata: (file) => ZipMetadata(file),
  };

  /// Method to get the display name for the type.
  ///
  /// This can be used to show the end user what type the file is.
  @mustBeOverridden
  String get formatname => getMimeTypeFromFile() ?? "";

  /// A method to quickly check if the file can belong to the format specified by this class or not.
  ///
  /// Although this is determined by the header bytes for most formats, note that this is not reqiured.
  /// For example, the check for the ZIP format checks for the End of Central Directory marker that is present towards the end of the file.
  ///
  /// Note that this method in no way guarantee that the metadata in the file is valid.
  /// i.e. It is possible that this method returns `True` but [getMetadataFromFile] throws an exception.
  ///
  /// If called from an instance of [FileMetadataBase], it returns `true` if the file exists, false otherwise.
  @mustBeOverridden
  Future<bool> isFileValid() => file.exists();

  /// Return the file of this instance in an instance of type `T`.
  ///
  /// This can be a useful utility to get cast this file into a more specific type and get the corresponding metadata.
  T asType<T extends FileMetadataBase>() => typeConstructorMap[T]!(file);

  /// Check is file is valid file of type `T`.
  ///
  /// Under the hood, this calls [isFileValid] on the result of [asType].
  Future<bool> isValid<T extends FileMetadataBase>() =>
      asType<T>().isFileValid();

  /// Get all metadata possible from the filename itself.
  ///
  /// This does not attempt to open/read the file.
  ///
  /// In order to get a more exhaustive list of metadata, use [FileMetadataBase.getMetadataFromFile] instead.
  ///
  /// Calling this method on the base class will return a [FilenameMetadata] object based on naive heurestics.
  ///
  /// The extension will be the last part after a `.` while the filename will be the rest of the file in most cases.
  /// If the filename does not have a `.`, the name itself will be both the filename and the extension.
  /// If filename is an empty string, both filename and extension will be an empty string.
  @mustBeOverridden
  FilenameMetadata getMetadataFromPath() {
    String filename = basename(file.path);

    if (filename.isEmpty) {
      return FilenameMetadata("", "");
    }

    List<String> parts = filename.split(".");
    // Note that we don't assert that a `.` exists because a file without a proper extension is assumed to have idential filename and format.
    // e.g. A file named `Justfile` should have name `Justfile` and format `Justfile`.
    String ext = parts.removeLast();
    String name;
    if (parts.isEmpty) {
      name = ext;
    } else {
      name = parts.join(".");
    }
    return FilenameMetadata(name, ext);
  }

  /// Get all metadata from the file.
  ///
  /// This will attempt to open and read the file.
  ///
  /// If this is undesireable, use [FileMetadataBase.getMetadataFromPath] instead.
  ///
  /// Using this method from an instance of the base class will return an empty [FileDataMetadata] object with not fields.
  @mustBeOverridden
  Future<FileDataMetadata> getMetadataFromFile() async => FileDataMetadata();
}

class FilenameMetadata {
  final String _name;
  final String _ext;
  const FilenameMetadata(this._name, this._ext);

  @mustBeOverridden
  String get fileName => _name;

  @mustBeOverridden
  String get fileExtension => _ext;
}

class FileDataMetadata {
  const FileDataMetadata();
}
