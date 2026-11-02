import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../../di/injector.dart';
import '../bloc/school_settings_form_bloc.dart';
import '../bloc/settings_bloc.dart';
import '../widgets/location_card.dart';

/// Principal sets where the school is, and how close teachers must be.
/// Expects a [SchoolSettingsFormBloc] and [SettingsBloc] above it.
class SchoolSettingsScreen extends StatefulWidget {
  const SchoolSettingsScreen({super.key});

  /// Opens the screen with the form bloc it needs, for the school as it is.
  static Future<void> open(BuildContext context) {
    final settings = context.read<SettingsBloc>().state.settings;
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider(
          create: (_) =>
              sl<SchoolSettingsFormBloc>(param1: settings)
                ..add(const AddressRequested()),
          child: const SchoolSettingsScreen(),
        ),
      ),
    );
  }

  @override
  State<SchoolSettingsScreen> createState() => _SchoolSettingsScreenState();
}

class _SchoolSettingsScreenState extends State<SchoolSettingsScreen> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _name;
  late final TextEditingController _radius;

  @override
  void initState() {
    super.initState();
    final settings = context.read<SettingsBloc>().state.settings;
    _formKey = GlobalKey<FormState>();
    _name = TextEditingController(text: settings.schoolName);
    _radius = TextEditingController(
      text: settings.radiusMeters?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _name.dispose();
    _radius.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    context.read<SchoolSettingsFormBloc>().add(
      SettingsSubmitted(
        schoolName: _name.text,
        radius: int.parse(_radius.text.trim()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocListener<SchoolSettingsFormBloc, SchoolSettingsFormState>(
      listenWhen: (a, b) => !a.saved && b.saved,
      listener: (context, state) {
        context.read<SettingsBloc>().add(const SettingsLoaded());
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l.messageSettingsSaved)));
        Navigator.of(context).pop();
      },
      child: Scaffold(
        appBar: AppBar(title: Text(l.schoolSettingsTitle)),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: AppSpacing.pageOf(context),
            children: [
              TextFormField(
                controller: _name,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(labelText: l.fieldSchoolName),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? l.errorRequired : null,
              ),
              const SizedBox(height: AppSpacing.lg),
              SectionTitle(l.sectionSchoolLocation),
              const LocationCard(),
              const SizedBox(height: AppSpacing.lg),
              TextFormField(
                controller: _radius,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: l.fieldRadius,
                  helperText: l.helperRadius,
                  suffixText: l.unitMeters,
                ),
                validator: (v) {
                  final n = int.tryParse((v ?? '').trim());
                  return (n == null || n <= 0) ? l.errorRadiusInvalid : null;
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              BlocBuilder<SchoolSettingsFormBloc, SchoolSettingsFormState>(
                buildWhen: (a, b) => a.saving != b.saving,
                builder: (context, state) => FilledButton(
                  onPressed: state.saving ? null : _save,
                  child: Text(l.actionSave),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
