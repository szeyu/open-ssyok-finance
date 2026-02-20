import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ssyok_finance/features/auth/presentation/providers/auth_provider.dart';
import 'package:ssyok_finance/features/plan/domain/asset.dart';
import 'package:ssyok_finance/features/plan/presentation/providers/plan_providers.dart';

class AssetFormModal extends ConsumerStatefulWidget {
  final Asset? asset;

  const AssetFormModal({super.key, this.asset});

  @override
  ConsumerState<AssetFormModal> createState() => _AssetFormModalState();
}

class _AssetFormModalState extends ConsumerState<AssetFormModal> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _valueController;
  late final TextEditingController _monthlyController;
  late final TextEditingController _growthController;

  late AssetType _selectedType;
  late bool _isEmergencyFund;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final a = widget.asset;
    _selectedType = a?.type ?? AssetType.savings;
    _isEmergencyFund = a?.isEmergencyFund ?? false;
    _nameController = TextEditingController(text: a?.name ?? '');
    _valueController =
        TextEditingController(text: a != null ? a.value.toStringAsFixed(2) : '');
    _monthlyController = TextEditingController(
        text: a != null && a.monthlyContribution > 0
            ? a.monthlyContribution.toStringAsFixed(2)
            : '');
    _growthController = TextEditingController(
        text: a != null && a.growthRate > 0
            ? a.growthRate.toStringAsFixed(1)
            : '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _valueController.dispose();
    _monthlyController.dispose();
    _growthController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final user = ref.read(authStateProvider).value;
    if (user == null) return;

    setState(() => _isSaving = true);

    try {
      final repo = ref.read(assetsRepositoryProvider);
      final value = double.parse(_valueController.text.replaceAll(',', ''));
      final monthly = _monthlyController.text.isEmpty
          ? 0.0
          : double.parse(_monthlyController.text.replaceAll(',', ''));
      final growth = _growthController.text.isEmpty
          ? 0.0
          : double.parse(_growthController.text);
      final now = DateTime.now();

      if (widget.asset == null) {
        await repo.add(Asset(
          id: '',
          userId: user.uid,
          type: _selectedType,
          name: _nameController.text.trim(),
          value: value,
          monthlyContribution: monthly,
          growthRate: growth,
          isEmergencyFund: _isEmergencyFund,
          createdAt: now,
          updatedAt: now,
        ));
      } else {
        await repo.update(widget.asset!.copyWith(
          type: _selectedType,
          name: _nameController.text.trim(),
          value: value,
          monthlyContribution: monthly,
          growthRate: growth,
          isEmergencyFund: _isEmergencyFund,
          updatedAt: now,
        ));
      }

      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEdit = widget.asset != null;

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(
                  isEdit ? 'Edit Asset' : 'Add Asset',
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Type', style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: AssetType.values.map((type) {
                return ChoiceChip(
                  label: Text(type.displayName),
                  selected: _selectedType == type,
                  onSelected: (_) => setState(() => _selectedType = type),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name *',
                hintText: 'e.g. ASB, Maybank Savings',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Name is required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _valueController,
              decoration: const InputDecoration(
                labelText: 'Current Value (RM) *',
                hintText: '0.00',
                prefixText: 'RM ',
                border: OutlineInputBorder(),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d.,]')),
              ],
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Value is required';
                final val = double.tryParse(v.replaceAll(',', ''));
                if (val == null || val < 0) return 'Enter a valid amount';
                return null;
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _monthlyController,
                    decoration: const InputDecoration(
                      labelText: 'Monthly Contribution',
                      hintText: '0.00',
                      prefixText: 'RM ',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[\d.,]')),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _growthController,
                    decoration: const InputDecoration(
                      labelText: 'Growth Rate',
                      hintText: '0.0',
                      suffixText: '% /yr',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Emergency Fund'),
              subtitle: const Text('Mark as emergency savings'),
              value: _isEmergencyFund,
              onChanged: (v) => setState(() => _isEmergencyFund = v),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _isSaving ? null : _save,
              child: _isSaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(isEdit ? 'Save Changes' : 'Add Asset'),
            ),
          ],
        ),
      ),
    );
  }
}

void showAssetForm(BuildContext context, {Asset? asset}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => AssetFormModal(asset: asset),
  );
}
