import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ssyok_finance/features/auth/presentation/providers/auth_provider.dart';
import 'package:ssyok_finance/features/plan/domain/debt.dart';
import 'package:ssyok_finance/features/plan/presentation/providers/plan_providers.dart';

class DebtFormModal extends ConsumerStatefulWidget {
  final Debt? debt;

  const DebtFormModal({super.key, this.debt});

  @override
  ConsumerState<DebtFormModal> createState() => _DebtFormModalState();
}

class _DebtFormModalState extends ConsumerState<DebtFormModal> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _balanceController;
  late final TextEditingController _interestController;
  late final TextEditingController _paymentController;

  late DebtType _selectedType;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final d = widget.debt;
    _selectedType = d?.type ?? DebtType.ptptn;
    _nameController = TextEditingController(text: d?.name ?? '');
    _balanceController = TextEditingController(
        text: d != null ? d.balance.toStringAsFixed(2) : '');
    _interestController = TextEditingController(
        text: d != null ? d.interestRate.toStringAsFixed(1) : '');
    _paymentController = TextEditingController(
        text: d != null ? d.monthlyPayment.toStringAsFixed(2) : '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    _interestController.dispose();
    _paymentController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final user = ref.read(authStateProvider).value;
    if (user == null) return;

    setState(() => _isSaving = true);

    try {
      final repo = ref.read(debtsRepositoryProvider);
      final balance = double.parse(_balanceController.text.replaceAll(',', ''));
      final interest = double.parse(_interestController.text);
      final payment = double.parse(_paymentController.text.replaceAll(',', ''));

      final now = DateTime.now();
      if (widget.debt == null) {
        await repo.add(Debt(
          id: '',
          userId: user.uid,
          type: _selectedType,
          name: _nameController.text.trim(),
          balance: balance,
          interestRate: interest,
          monthlyPayment: payment,
          createdAt: now,
          updatedAt: now,
        ));
      } else {
        await repo.update(widget.debt!.copyWith(
          type: _selectedType,
          name: _nameController.text.trim(),
          balance: balance,
          interestRate: interest,
          monthlyPayment: payment,
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
    final isEdit = widget.debt != null;

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
                  isEdit ? 'Edit Debt' : 'Add Debt',
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

            // Debt type selector
            Text('Type', style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: DebtType.values.map((type) {
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
                hintText: 'e.g. PTPTN Loan, CIMB Credit Card',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Name is required' : null,
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _balanceController,
              decoration: const InputDecoration(
                labelText: 'Outstanding Balance (RM) *',
                prefixText: 'RM ',
                border: OutlineInputBorder(),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d.,]')),
              ],
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Required';
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
                    controller: _interestController,
                    decoration: const InputDecoration(
                      labelText: 'Interest Rate *',
                      suffixText: '% /yr',
                      hintText: '3.5',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
                    ],
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Required';
                      final val = double.tryParse(v);
                      if (val == null || val < 0) return 'Invalid';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _paymentController,
                    decoration: const InputDecoration(
                      labelText: 'Monthly Payment *',
                      prefixText: 'RM ',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[\d.,]')),
                    ],
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Required';
                      final val = double.tryParse(v.replaceAll(',', ''));
                      if (val == null || val <= 0) return 'Must be > 0';
                      return null;
                    },
                  ),
                ),
              ],
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
                  : Text(isEdit ? 'Save Changes' : 'Add Debt'),
            ),
          ],
        ),
      ),
    );
  }
}

void showDebtForm(BuildContext context, {Debt? debt}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => DebtFormModal(debt: debt),
  );
}
