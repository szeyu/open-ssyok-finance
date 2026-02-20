import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ssyok_finance/features/auth/presentation/providers/auth_provider.dart';
import 'package:ssyok_finance/features/plan/domain/goal.dart';
import 'package:ssyok_finance/features/plan/presentation/providers/plan_providers.dart';

class GoalFormModal extends ConsumerStatefulWidget {
  final Goal? goal;

  const GoalFormModal({super.key, this.goal});

  @override
  ConsumerState<GoalFormModal> createState() => _GoalFormModalState();
}

class _GoalFormModalState extends ConsumerState<GoalFormModal> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _targetController;
  late final TextEditingController _currentController;

  late GoalType _selectedType;
  late DateTime _targetDate;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final g = widget.goal;
    _selectedType = g?.type ?? GoalType.emergencyFund;
    _targetDate = g?.targetDate ?? DateTime.now().add(const Duration(days: 365));
    _nameController = TextEditingController(text: g?.name ?? '');
    _targetController = TextEditingController(
        text: g != null ? g.targetAmount.toStringAsFixed(2) : '');
    _currentController = TextEditingController(
        text: g != null ? g.currentAmount.toStringAsFixed(2) : '0.00');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _targetController.dispose();
    _currentController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _targetDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 30)),
    );
    if (picked != null) setState(() => _targetDate = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final user = ref.read(authStateProvider).value;
    if (user == null) return;

    setState(() => _isSaving = true);

    try {
      final repo = ref.read(goalsRepositoryProvider);
      final target = double.parse(_targetController.text.replaceAll(',', ''));
      final current = double.parse(_currentController.text.replaceAll(',', ''));

      final now = DateTime.now();
      if (widget.goal == null) {
        await repo.add(Goal(
          id: '',
          userId: user.uid,
          type: _selectedType,
          name: _nameController.text.trim(),
          targetAmount: target,
          currentAmount: current,
          targetDate: _targetDate,
          createdAt: now,
          updatedAt: now,
        ));
      } else {
        await repo.update(widget.goal!.copyWith(
          type: _selectedType,
          name: _nameController.text.trim(),
          targetAmount: target,
          currentAmount: current,
          targetDate: _targetDate,
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
    final isEdit = widget.goal != null;
    final dateFmt = DateFormat('dd MMM yyyy');

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
                  isEdit ? 'Edit Goal' : 'Add Goal',
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

            // Goal type selector
            Text('Type', style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: GoalType.values.map((type) {
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
                labelText: 'Goal Name *',
                hintText: 'e.g. Emergency Fund, Down Payment',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Name is required' : null,
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _targetController,
                    decoration: const InputDecoration(
                      labelText: 'Target Amount (RM) *',
                      prefixText: 'RM ',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[\d.,]')),
                    ],
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Required';
                      }
                      final val = double.tryParse(v.replaceAll(',', ''));
                      if (val == null || val <= 0) return 'Must be > 0';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _currentController,
                    decoration: const InputDecoration(
                      labelText: 'Current Saved (RM)',
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
              ],
            ),
            const SizedBox(height: 12),

            // Target date picker
            InkWell(
              onTap: _pickDate,
              borderRadius: BorderRadius.circular(8),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Target Date',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(dateFmt.format(_targetDate)),
              ),
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
                  : Text(isEdit ? 'Save Changes' : 'Add Goal'),
            ),
          ],
        ),
      ),
    );
  }
}

void showGoalForm(BuildContext context, {Goal? goal}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => GoalFormModal(goal: goal),
  );
}
