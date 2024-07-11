Source: [pinvoke.net](http://www.pinvoke.net/default.aspx/Structures.IMAGE_DOS_HEADER)

<!--
MARK: C#
-->
C# Definition:

```c#
  [StructLayout(LayoutKind.Sequential)]
  public struct IMAGE_DOS_HEADER
  {
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 2)]
      public char[] e_magic;       // Magic number
      public UInt16 e_cblp;    // Bytes on last page of file
      public UInt16 e_cp;      // Pages in file
      public UInt16 e_crlc;    // Relocations
      public UInt16 e_cparhdr;     // Size of header in paragraphs
      public UInt16 e_minalloc;    // Minimum extra paragraphs needed
      public UInt16 e_maxalloc;    // Maximum extra paragraphs needed
      public UInt16 e_ss;      // Initial (relative) SS value
      public UInt16 e_sp;      // Initial SP value
      public UInt16 e_csum;    // Checksum
      public UInt16 e_ip;      // Initial IP value
      public UInt16 e_cs;      // Initial (relative) CS value
      public UInt16 e_lfarlc;      // File address of relocation table
      public UInt16 e_ovno;    // Overlay number
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 4)]
      public UInt16[] e_res1;    // Reserved words
      public UInt16 e_oemid;       // OEM identifier (for e_oeminfo)
      public UInt16 e_oeminfo;     // OEM information; e_oemid specific
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 10)]
      public UInt16[] e_res2;    // Reserved words
      public Int32 e_lfanew;      // File address of new exe header

      private string _e_magic
      {
      get { return new string(e_magic); }
      }

      public bool isValid
      {
      get { return _e_magic == "MZ"; }
      }
  }
  ```

<!--
MARK: C# Unsafe
-->
Unsafe C# Definition:

```c#
StructLayout(LayoutKind.Sequential)]

public struct IMAGE_DOS_HEADER

{

    public fixed byte e_magic_byte[2];       // Magic number
    public UInt16 e_cblp;    // Bytes on last page of file
    public UInt16 e_cp;      // Pages in file
    public UInt16 e_crlc;    // Relocations
    public UInt16 e_cparhdr;     // Size of header in paragraphs
    public UInt16 e_minalloc;    // Minimum extra paragraphs needed
    public UInt16 e_maxalloc;    // Maximum extra paragraphs needed
    public UInt16 e_ss;      // Initial (relative) SS value
    public UInt16 e_sp;      // Initial SP value
    public UInt16 e_csum;    // Checksum
    public UInt16 e_ip;      // Initial IP value
    public UInt16 e_cs;      // Initial (relative) CS value
    public UInt16 e_lfarlc;      // File address of relocation table
    public UInt16 e_ovno;    // Overlay number
    public fixed UInt16 e_res1[4];    // Reserved words
    public UInt16 e_oemid;       // OEM identifier (for e_oeminfo)
    public UInt16 e_oeminfo;     // OEM information; e_oemid specific
    public fixed UInt16 e_res2[10];    // Reserved words
    public Int32 e_lfanew;      // File address of new exe header
}
```

<!--
MARK: VB
-->
VB Definition:

```vb
  <StructLayout(LayoutKind.Sequential, Pack:=1)> _
  Public Structure IMAGE_DOS_HEADER
    ''' <summary>
    ''' Magic number. This is the "magic number" of an EXE file.
    ''' The first byte of the file is 0x4d and the second is 0x5a.
    ''' </summary>
    ''' <remarks></remarks>
    Public e_magic As UInt16
    ''' <summary>
    ''' Bytes on last page of file. The number of bytes in the last block of the
    ''' program that are actually used. If this value is zero, that means the entire
    ''' last block is used (i.e. the effective value is 512).
    ''' </summary>
    ''' <remarks></remarks>
    Public e_cblp As UInt16
    ''' <summary>
    ''' Pages in file. Number of blocks in the file that are part of the EXE file.
    ''' If [02-03] is non-zero, only that much of the last block is used.
    ''' </summary>
    ''' <remarks></remarks>
    Public e_cp As UInt16
    ''' <summary>
    ''' Relocations. Number of relocation entries stored after the header. May be zero.
    ''' </summary>
    ''' <remarks></remarks>
    Public e_crlc As UInt16
    ''' <summary>
    ''' Size of header in paragraphs. Number of paragraphs in the header.
    ''' The program's data begins just after the header, and this field can be used
    ''' to calculate the appropriate file offset. The header includes the relocation entries.
    ''' Note that some OSs and/or programs may fail if the header is not a multiple of 512 bytes.
    ''' </summary>
    ''' <remarks></remarks>
    Public e_cparhdr As UInt16
    ''' <summary>
    ''' Minimum extra paragraphs needed. Number of paragraphs of additional memory that the
    ''' program will need. This is the equivalent of the BSS size in a Unix program.
    ''' The program can't be loaded if there isn't at least this much memory available to it.
    ''' </summary>
    ''' <remarks></remarks>
    Public e_minalloc As UInt16
    ''' <summary>
    ''' Maximum extra paragraphs needed. Maximum number of paragraphs of additional memory.
    ''' Normally, the OS reserves all the remaining conventional memory for your program,
    ''' but you can limit it with this field.
    ''' </summary>
    ''' <remarks></remarks>
    Public e_maxalloc As UInt16
    ''' <summary>
    ''' Initial (relative) SS value. Relative value of the stack segment. This value is
    ''' added to the segment the program was loaded at, and the result is used to
    ''' initialize the SS register.
    ''' </summary>
    ''' <remarks></remarks>
    Public e_ss As UInt16
    ''' <summary>
    ''' Initial SP value. Initial value of the SP register.
    ''' </summary>
    ''' <remarks></remarks>
    Public e_sp As UInt16
    ''' <summary>
    ''' Checksum. Word checksum. If set properly, the 16-bit sum of all words in the
    ''' file should be zero. Usually, this isn't filled in.
    ''' </summary>
    ''' <remarks></remarks>
    Public e_csum As UInt16
    ''' <summary>
    ''' Initial IP value. Initial value of the IP register.
    ''' </summary>
    ''' <remarks></remarks>
    Public e_ip As UInt16
    ''' <summary>
    ''' Initial (relative) CS value. Initial value of the CS register, relative to
    ''' the segment the program was loaded at.
    ''' </summary>
    ''' <remarks></remarks>
    Public e_cs As UInt16
    ''' <summary>
    ''' File address of relocation table. Offset of the first relocation item in the file.
    ''' </summary>
    ''' <remarks></remarks>
    Public e_lfarlc As UInt16
    ''' <summary>
    ''' Overlay number. Overlay number. Normally zero, meaning that it's the main program.
    ''' </summary>
    ''' <remarks></remarks>
    Public e_ovno As UInt16
    ''' <summary>
    ''' reserved
    ''' </summary>
    ''' <remarks></remarks>
    Public e_res_0 As UInt16
    ''' <summary>
    ''' reserved
    ''' </summary>
    ''' <remarks></remarks>
    Public e_res_1 As UInt16
    ''' <summary>
    ''' reserved
    ''' </summary>
    ''' <remarks></remarks>
    Public e_res_2 As UInt16
    ''' <summary>
    ''' reserved
    ''' </summary>
    ''' <remarks></remarks>
    Public e_res_3 As UInt16
    ''' <summary>
    ''' reserved
    ''' </summary>
    ''' <remarks></remarks>
    Public e_oemid As UInt16
    ''' <summary>
    ''' OEM identifier (for e_oeminfo)
    ''' </summary>
    ''' <remarks></remarks>
    Public e_oeminfo As UInt16
    ''' <summary>
    ''' OEM information; e_oemid specific
    ''' </summary>
    ''' <remarks></remarks>
    Public e_res2_0 As UInt16
    ''' <summary>
    ''' reserved
    ''' </summary>
    ''' <remarks></remarks>
    Public e_res2_1 As UInt16
    ''' <summary>
    ''' reserved
    ''' </summary>
    ''' <remarks></remarks>
    Public e_res2_2 As UInt16
    ''' <summary>
    ''' reserved
    ''' </summary>
    ''' <remarks></remarks>
    Public e_res2_3 As UInt16
    ''' <summary>
    ''' reserved
    ''' </summary>
    ''' <remarks></remarks>
    Public e_res2_4 As UInt16
    ''' <summary>
    ''' reserved
    ''' </summary>
    ''' <remarks></remarks>
    Public e_res2_5 As UInt16
    ''' <summary>
    ''' reserved
    ''' </summary>
    ''' <remarks></remarks>
    Public e_res2_6 As UInt16
    ''' <summary>
    ''' reserved
    ''' </summary>
    ''' <remarks></remarks>
    Public e_res2_7 As UInt16
    ''' <summary>
    ''' reserved
    ''' </summary>
    ''' <remarks></remarks>
    Public e_res2_8 As UInt16
    ''' <summary>
    ''' reserved
    ''' </summary>
    ''' <remarks></remarks>
    Public e_res2_9 As UInt16
    ''' <summary>
    ''' File address of new exe header
    ''' </summary>
    ''' <remarks></remarks>
    Public e_lfanew As UInt32
  End Structure
```

<!--
MARK: VB6
-->
VB 6 Definition:

```vb
  Public Type IMAGE_DOS_HEADER
     ' This is the "magic number" of an EXE file.  The first byte is 0x4d and the second is 0x5a.
     e_magic As Integer
     ' Bytes on last page of file. The number of bytes in the last block of the file that are
     ' actually used.  If zero, it means the entire last block is used (i.e. effectively 512).
     e_cblp As Integer
     ' Pages in file. Number of blocks in the file that are part of the EXE file.
     ' If [02-03] is non-zero, only that much of the last block is used.
     e_cp As Integer
     ' Relocations. Number of relocation entries stored after the header. May be zero.
     e_crlc As Integer
     ' Size of header in paragraphs. Number of paragraphs in the header.
     ' The program's data begins just after the header, and this field can be used to calculate
     ' the appropriate file offset.  The header includes the relocation entries.
     ' Note that some OSes and/or programs may fail if the header is not a multiple of 512 bytes.
     e_cparhdr As Integer
     ' Minimum extra paragraphs needed. Number of paragraphs of additional memory that the
     ' program will need.  This is the equivalent of the BSS size in a Unix program.
     ' The program can't be loaded if there isn't at least this much memory available to it.
     e_minalloc As Integer
     ' Maximum extra paragraphs needed. Maximum number of paragraphs of additional memory.
     ' Normally, the OS reserves all the remaining conventional memory for your program, but
     ' you can limit it with this field.
     e_maxalloc As Integer
     ' Initial (relative) SS value. (Relative value of the stack segment)  This value is added to
     ' the segment the file was loaded at, and the result is used to initialize the SS register.
     e_ss As Integer
     ' Initial SP value. Initial value of the SP register.
     e_sp As Integer
     ' Checksum. Word checksum. If set properly, the 16-bit sum of all words in the file
     ' should be zero. Usually, this isn't filled in.
     e_csum As Integer
     ' Initial IP value. Initial value of the IP register.
     e_ip As Integer
     ' Initial (relative) CS value. Initial value of the CS register, relative to the
     ' segment the program was loaded at.
     e_cs As Integer
     ' File address of relocation table. Offset of the first relocation item in the file.
     e_lfarlc As Integer
     ' Overlay number. Overlay number. Normally zero, meaning that it's the main program.
     e_ovno As Integer
     ' reserved
     e_res(3) As Integer
     ' reserved
     e_oemid As Integer
     ' OEM identifier (for e_oeminfo)
     e_oeminfo As Integer
     ' Index 0: OEM information - e_oemid specific; Indexes 1 - 9: reserved
     e_res2(9) As Integer
     ' File address of new exe header
     e_lfanew As Long
   End Type
```

Note:
  Possible alternates:
   Instead of:
      e_res(3) As Integer
    can use 4 integer variables
      e_res_0 AS Integer
      ...
      e_res_3 As Integer
   Instead of:
      e_res2(9) As Integer
    can use 10 integer variables
      e_res2_0 As Integer
      ...
      e_res2_9 As Integer
