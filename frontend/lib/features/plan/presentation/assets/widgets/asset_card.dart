import 'package:flutter/material.dart';
import 'package:ssyok_finance/core/extensions/double_extensions.dart';
import 'package:ssyok_finance/features/plan/domain/asset.dart';

class AssetCard extends StatelessWidget {
  final Asset asset;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AssetCard({
    super.key,
    required this.asset,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _typeIcon(asset.type),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          asset.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          asset.type.displayName,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') onEdit();
                      if (value == 'delete') onDelete();
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 18),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline,
                                size: 18, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete',
                                style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _infoChip(
                      context,
                      label: 'Value',
                      value: asset.value.toRinggit(),
                      color: Colors.green,
                    ),
                  ),
                  if (asset.monthlyContribution > 0) ...[
                    const SizedBox(width: 8),
                    Expanded(
                      child: _infoChip(
                        context,
                        label: 'Monthly',
                        value: '+${asset.monthlyContribution.toRinggit()}',
                        color: Colors.blue,
                      ),
                    ),
                  ],
                  if (asset.growthRate > 0) ...[
                    const SizedBox(width: 8),
                    Expanded(
                      child: _infoChip(
                        context,
                        label: 'Growth',
                        value: '${asset.growthRate.toStringAsFixed(1)}%/yr',
                        color: Colors.teal,
                      ),
                    ),
                  ],
                ],
              ),
              if (asset.isEmergencyFund) ...[
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.shield, size: 14, color: Colors.amber),
                      SizedBox(width: 4),
                      Text('Emergency Fund',
                          style: TextStyle(
                              fontSize: 12, color: Colors.amber)),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _typeIcon(AssetType type) {
    final (icon, color) = switch (type) {
      AssetType.savings => (Icons.savings, Colors.green),
      AssetType.investment => (Icons.trending_up, Colors.blue),
      AssetType.property => (Icons.home, Colors.brown),
      AssetType.retirement => (Icons.account_balance, Colors.purple),
      AssetType.other => (Icons.category, Colors.grey),
    };

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }

  Widget _infoChip(
    BuildContext context, {
    required String label,
    required String value,
    required Color color,
  }) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: theme.textTheme.labelSmall
                  ?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
          Text(value,
              style: theme.textTheme.labelMedium
                  ?.copyWith(color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
