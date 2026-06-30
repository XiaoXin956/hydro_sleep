import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydro_sleep/core/bluetooth/ble_data_cubit.dart';
import 'package:hydro_sleep/core/theme/app_colors.dart';
import 'package:hydro_sleep/domain/models/retransmit30_record.dart';

/// 重传测试卡片（30分钟数据） — 临时调试用
class Retransmit30TestCard extends StatefulWidget {
  const Retransmit30TestCard({super.key});

  @override
  State<Retransmit30TestCard> createState() => _Retransmit30TestCardState();
}

class _Retransmit30TestCardState extends State<Retransmit30TestCard> {
  bool _loading = false;
  List<Retransmit30Record> _records = [];
  String? _error;

  Future<void> _sendRetransmit30() async {
    final dataCubit = context.read<BleDataCubit>();
    if (dataCubit.state.status != BleDataStatus.streaming) {
      setState(() => _error = '未连接设备');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
      _records = [];
    });

    try {
      final records = await dataCubit.sendRetransmit30Command();
      if (mounted) {
        setState(() {
          _records = records;
          _loading = false;
          if (records.isEmpty) {
            _error = '未收到重传数据(30分钟)';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = '$e';
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '重传指令(30分钟)',
                  style: theme.textTheme.titleMedium,
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _loading ? null : _sendRetransmit30,
                  child: _loading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('请求重传'),
                ),
              ],
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(
                _error!,
                style: const TextStyle(color: Colors.red, fontSize: 13),
              ),
            ],
            if (_records.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                '收到 ${_records.length} 条记录',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              _buildRecordList(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRecordList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _records.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final r = _records[index];
        final timeStr = r.timestamp != null
            ? '${r.timestamp!.hour.toString().padLeft(2, '0')}:'
                '${r.timestamp!.minute.toString().padLeft(2, '0')}:'
                '${r.timestamp!.second.toString().padLeft(2, '0')}'
            : '无效';
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              SizedBox(
                width: 28,
                child: Text(
                  '${r.sequenceNo}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontFamily: 'monospace',
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              SizedBox(
                width: 60,
                child: Text(
                  timeStr,
                  style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
                ),
              ),
              SizedBox(
                width: 42,
                child: Text(
                  'HR:${r.heartRate}',
                  style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
                ),
              ),
              SizedBox(
                width: 42,
                child: Text(
                  'BR:${r.breathRate}',
                  style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
                ),
              ),
              Expanded(
                child: Text(
                  'mv:${r.bodyMovement} sn:${r.snoreCount} obs:${r.respiratoryObstruction}',
                  style: const TextStyle(fontSize: 10, fontFamily: 'monospace'),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
