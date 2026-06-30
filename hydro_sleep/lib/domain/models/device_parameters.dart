import 'dart:typed_data';

/// 设备参数模型 — 解析 0x8A 读取响应中的 64 字节参数（16 个 float，LE）
class DeviceParameters {
  final List<double> values;

  const DeviceParameters({required this.values});

  static const int count = 16;
  static const int byteSize = count * 4; // 64 bytes

  /// 从 64 字节解析 16 个 float（小端序）
  factory DeviceParameters.fromBytes(List<int> bytes) {
    final bd = ByteData(64);
    for (var i = 0; i < 64 && i < bytes.length; i++) {
      bd.setUint8(i, bytes[i]);
    }
    final values = <double>[];
    for (var i = 0; i < count; i++) {
      values.add(bd.getFloat32(i * 4, Endian.little));
    }
    return DeviceParameters(values: values);
  }

  /// 将 16 个 float 编码为 64 字节（小端序）
  List<int> toBytes() {
    final bd = ByteData(64);
    for (var i = 0; i < count && i < values.length; i++) {
      bd.setFloat32(i * 4, values[i], Endian.little);
    }
    return List.generate(64, (i) => bd.getUint8(i));
  }

  /// 各参数名称
  static const List<String> names = [
    'P1: 离入床动态阈值',
    'P2: 体动动态阈值',
    'P3: 离入床静态阈值',
    'P4: 打鼾灵敏度',
    'P5: 弱呼吸灵敏度',
    'P6: 实时分期阈值①',
    'P7: 实时分期阈值②',
    'P8: 实时分期阈值③',
    'P9: 整晚分期阈值①',
    'P10: 整晚分期阈值②',
    'P11: 分期算法阈值',
    'P12: 报表生成时间(0~23)',
    'P13: 自动调整',
    'P14: 分期算法阈值',
    'P15: 备用参数',
    'P16: 硬件参数(勿改)',
  ];

  /// 各参数默认值（仅可修改的参数有默认值）
  static const List<double?> defaults = [
    null, // P1: 设备自动调整
    null, // P2: 设备自动调整
    null, // P3: 设备自动调整
    18.5, // P4
    5.0,  // P5
    2.3,  // P6
    17.0, // P7
    4.0,  // P8
    13.0, // P9
    3.0,  // P10
    9.3,  // P11
    9.0,  // P12
    null, // P13: 设备自动调整
    5.0,  // P14
    1.0,  // P15
    1.0,  // P16
  ];

  @override
  String toString() {
    final parts = <String>[];
    for (var i = 0; i < count && i < values.length; i++) {
      parts.add('${names[i]}: ${values[i]}');
    }
    return 'DeviceParameters(\n  ${parts.join('\n  ')})';
  }
}
