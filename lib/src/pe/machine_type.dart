/// Taken from https://learn.microsoft.com/en-us/windows/win32/debug/pe-format#machine-types
enum MachineType {
  unidentified(-1),

  /// The content of this field is assumed to be applicable to any machine type
  unknown(0x0),

  /// Alpha AXP, 32-bit address space
  alpha(0x184),

  /// Alpha 64, 64-bit address space
  alpha64(0x284),

  /// Matsushita AM33
  am33(0x1d3),

  /// x64
  amd64(0x8664),

  /// ARM little endian
  arm(0x1c0),

  /// ARM64 little endian
  arm64(0xaa64),

  /// ARM Thumb-2 little endian
  armnt(0x1c4),

  /// AXP 64 (Same as Alpha 64)
  axp64(0x284),

  /// EFI byte code
  ebc(0xebc),

  /// Intel 386 or later processors and compatible processors
  i386(0x14c),

  /// Intel Itanium processor family
  ia64(0x200),

  /// LoongArch 32-bit processor family
  loongarch32(0x6232),

  /// LoongArch 64-bit processor family
  loongarch64(0x6264),

  /// Mitsubishi M32R little endian
  m32r(0x9041),

  /// MIPS16
  mpis16(0x266),

  /// MIPS with FPU
  mipsfpu(0x366),

  /// MIPS16 with FPU
  mipsfpu16(0x466),

  /// Power PC little endian
  powerpc(0x1f0),

  /// Power PC with floating point support
  powerpcfp(0x1f1),

  /// MIPS little endian
  r4000(0x166),

  /// RISC-V 32-bit address space
  riscv32(0x5032),

  /// RISC-V 64-bit address space
  riscv64(0x5064),

  /// RISC-V 128-bit address space
  riscv128(0x5128),

  /// Hitachi SH3
  sh3(0x1a2),

  /// Hitachi SH3 DSP
  sh3dsp(0x1a3),

  /// Hitachi SH4
  sh4(0x1a6),

  /// Hitachi SH5
  sh5(0x1a8),

  /// Thumb
  thumb(0x1c2),

  /// MIPS little-endian WCE v2
  wcemipsv2(0x169),
  ;

  final int id;

  const MachineType(this.id);

  static MachineType? fromId(int id) => MachineType.values.firstWhere(
        (e) => e.id == id,
        orElse: () => MachineType.unidentified,
      );
}
