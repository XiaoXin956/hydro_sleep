import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydro_sleep/core/bluetooth/ble_connect_cubit.dart';
import 'package:hydro_sleep/core/bluetooth/ble_data_cubit.dart';
import 'package:hydro_sleep/data/storage/secure_storage_service.dart';

/// 设备 ID 测试卡片 — 查看已保存/内存中的设备 ASCII ID（bytes[4..13]）
class DeviceIdTestCard extends StatefulWidget {
  const DeviceIdTestCard({super.key});

  @override
  State<DeviceIdTestCard> createState() => _DeviceIdTestCardState();
}

class _DeviceIdTestCardState extends State<DeviceIdTestCard> {
  bool _loading = false;
  String? _error;
  List<int>? _storedId; // SecureStorage 中缓存的 ID
  List<int>? _memoryId; // BleDataCubit 内存中的 ID
  List<int>? _convertedId; // 由 remoteId 转换的 ID（00 补充 + remoteId）

  Future<void> _queryDeviceId() async {
    setState(() {
      _loading = true;
      _error = null;
      _storedId = null;
      _memoryId = null;
      _convertedId = null;
    });

    try {
      final connectCubit = context.read<BleConnectCubit>();
      final dataCubit = context.read<BleDataCubit>();
      final remoteId = connectCubit.state.remoteId;

      // 1. SecureStorage 缓存（key=device_ascii_id_{remoteId}）
      final stored =
          remoteId != null ? await SecureStorageService().getDeviceAsciiId(remoteId) : null;
      // 2. BleDataCubit 内存中当前命令帧使用的 ID
      final memory = dataCubit.deviceAsciiId;
      // 3. 由 remoteId 转换的 ID（前 4 字节 00 + 后 6 字节 remoteId hex）
      final converted =
          remoteId != null ? BleDataCubit.buildDeviceIdFromRemoteId(remoteId) : null;

      if (mounted) {
        setState(() {
          _loading = false;
          if (stored == null || stored.isEmpty) {
            _error = remoteId == null
                ? '未连接设备，无缓存可查'
                : 'SecureStorage 无该设备 ID 缓存（key=device_ascii_id_$remoteId）';
          }
          _storedId = stored;
          _memoryId = memory;
          _convertedId = converted;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = '异常: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final remoteId = context.watch<BleConnectCubit>().state.remoteId;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('设备 ID 测试', style: theme.textTheme.titleMedium),
                const Spacer(),
                ElevatedButton(
                  onPressed: _loading ? null : _queryDeviceId,
                  child: _loading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('查看设备ID'),
                ),
              ],
            ),
            if (remoteId != null) ...[
              const SizedBox(height: 4),
              Text(
                '蓝牙地址: $remoteId',
                style: const TextStyle(fontSize: 12, fontFamily: 'monospace', color: Colors.blueGrey),
              ),
            ],
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(
                _error!,
                style: const TextStyle(color: Colors.red, fontSize: 13),
              ),
            ],
            if (_memoryId != null) ...[
              const SizedBox(height: 12),
              _buildIdSection(theme, '内存 ID（命令帧实际使用）', _memoryId!),
            ],
            if (_storedId != null) ...[
              const SizedBox(height: 12),
              _buildIdSection(theme, '本地缓存（SecureStorage）', _storedId!),
            ],
            if (_convertedId != null) ...[
              const SizedBox(height: 12),
              _buildIdSection(theme, '转换 ID（00补充+remoteId）', _convertedId!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIdSection(ThemeData theme, String title, List<int> id) {
    final hex = id.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ');
    final ascii = String.fromCharCodes(id.where((b) => b >= 0x20 && b <= 0x7E));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          '字节数: ${id.length}',
          style: const TextStyle(fontSize: 12),
        ),
        const SizedBox(height: 2),
        Text(
          'HEX: $hex',
          style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
        ),
        const SizedBox(height: 2),
        Text(
          'ASCII: "$ascii"',
          style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
        ),
        if (id.length != 10) ...[
          const SizedBox(height: 2),
          const Text(
            '警告: 位数不是 10 字节！',
            style: TextStyle(color: Colors.orange, fontSize: 12),
          ),
        ],
      ],
    );
  }
}