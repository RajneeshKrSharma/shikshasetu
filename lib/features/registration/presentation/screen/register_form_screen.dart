import '../../../../core/validation/email_rule.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/widgets/picker_field.dart';
import '../../../../core/domain/gender.dart';
import '../../../../core/utils/aadhaar.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../attendance/presentation/bloc/attendance_bloc.dart';
import '../../../attendance/presentation/bloc/attendance_event.dart';
import '../../../auth/domain/repository/auth_repository.dart';
import '../../../auth/presentation/widgets/auth_l10n.dart';
import '../../../../di/injector.dart';
import '../../../classes/presentation/bloc/classes_bloc.dart';
import '../../../students/domain/entities/student.dart';
import '../../../staff/presentation/bloc/staff_bloc.dart';
import '../../domain/entities/dob_rules.dart';
import '../../domain/entities/person.dart';
import '../../domain/entities/staff_role.dart';
import '../bloc/register_form_bloc.dart';
import '../bloc/registration_bloc.dart';
import '../widgets/aadhaar_widgets.dart';
import 'aadhaar_scan_screen.dart';
import '../widgets/person_type_l10n.dart';

const _subjects = [
  'Mathematics',
  'Science',
  'English',
  'Hindi',
  'Social Studies',
];

/// Registers a student, teacher or other staff member, or changes a student.
/// The kind of person is fixed by where the form was opened from.
/// Expects a [RegisterFormBloc] above it.
class RegisterFormScreen extends StatefulWidget {
  const RegisterFormScreen({super.key});

  /// Opens the form to add a person of [type], or, with [studentId], to
  /// change that student.
  static Future<void> open(
    BuildContext context,
    PersonType type, {
    String? studentId,
  }) => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => BlocProvider(
        create: (_) => sl<RegisterFormBloc>(
          param1: RegisterFormArgs(type, studentId: studentId),
        )..add(const RegisterFormStarted()),
        child: const RegisterFormScreen(),
      ),
    ),
  );

  @override
  State<RegisterFormScreen> createState() => _RegisterFormScreenState();
}

class _RegisterFormScreenState extends State<RegisterFormScreen> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _name;
  late final TextEditingController _aadhaar;
  late final TextEditingController _aadhaarReason;
  late final TextEditingController _address;
  late final TextEditingController _phone;
  late final TextEditingController _guardian;
  late final TextEditingController _role;
  late final TextEditingController _vehicle;
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _name = TextEditingController();
    _aadhaar = TextEditingController();
    _aadhaarReason = TextEditingController();
    _address = TextEditingController();
    _phone = TextEditingController();
    _guardian = TextEditingController();
    _role = TextEditingController();
    _vehicle = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();
  }

  /// A student being changed was read: put their details in the fields.
  void _fill(Student s) {
    _name.text = s.name;
    _address.text = s.address ?? '';
    _phone.text = s.phone.replaceFirst('+91 ', '');
    _guardian.text = s.guardian;
  }

  @override
  void dispose() {
    for (final c in [
      _name,
      _aadhaar,
      _aadhaarReason,
      _address,
      _phone,
      _guardian,
      _role,
      _vehicle,
      _email,
      _password, //
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    final state = context.read<RegisterFormBloc>().state;
    final dobBad =
        state.dateOfBirth != null &&
        DobRules.check(state.dateOfBirth!, state.type, DateTime.now()) != null;
    // The date of birth shows its own error under the field.
    if (!_formKey.currentState!.validate() || dobBad) return;
    context.read<RegisterFormBloc>().add(
      RegisterSubmitted(
        RegistrationFields(
          name: _name.text,
          aadhaar: _aadhaar.text,
          aadhaarReason: _aadhaarReason.text,
          address: _address.text,
          phone: _phone.text,
          guardian: _guardian.text,
          roleTitle: _role.text,
          vehicleNumber: _vehicle.text,
          email: _email.text,
          password: _password.text,
        ),
      ),
    );
  }

  Future<void> _pickDob(DateTime? current) async {
    final bloc = context.read<RegisterFormBloc>();
    final now = DateTime.now();
    final type = bloc.state.type;
    // The calendar only offers dates that are acceptable for this kind of
    // person: never after today, and within the age limits.
    final first = DobRules.earliest(type, now);
    final last = DobRules.latest(type, now);
    var initial = current ?? DateTime(now.year - 10);
    if (initial.isAfter(last)) initial = last;
    if (initial.isBefore(first)) initial = first;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: last,
    );
    if (picked != null) bloc.add(RegisterDobChosen(picked));
  }

  /// Opens the front-and-back scan, then puts into the form whatever it found:
  /// number, name, gender and date of birth from the front, the address from
  /// the back.
  Future<void> _scanCard() async {
    final bloc = context.read<RegisterFormBloc>();
    final l = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final reading = await AadhaarScanScreen.open(context);
    if (reading == null || !mounted) return;

    final filled = <String>[];
    if (reading.number != null) {
      // A number that fails the check is still put in, so the one wrong digit
      // can be corrected by hand; the field's own check will flag it.
      _setAadhaar(reading.number!);
      if (reading.problem == AadhaarProblem.none) {
        filled.add(l.aadhaarItemNumber);
      }
    }
    // Cards carry both languages; the form gets the one the app is in.
    final hindi = Localizations.localeOf(context).languageCode == 'hi';
    final name = hindi
        ? (reading.nameHi ?? reading.name)
        : (reading.name ?? reading.nameHi);
    // The address is kept in Hindi whenever the card has it in Hindi.
    final address = reading.addressHi ?? reading.address;
    if (name != null) {
      _name.text = name;
      filled.add(l.aadhaarItemName);
    }
    if (reading.gender != null) {
      bloc.add(RegisterGenderChosen(reading.gender));
      filled.add(l.aadhaarItemGender);
    }
    if (reading.dateOfBirth != null) {
      bloc.add(RegisterDobChosen(reading.dateOfBirth));
      filled.add(l.aadhaarItemDob);
    }
    if (address != null) {
      _address.text = address;
      filled.add(l.aadhaarItemAddress);
    }
    _formKey.currentState?.validate();
    if (filled.isNotEmpty) {
      messenger.showSnackBar(
        SnackBar(content: Text(l.aadhaarFilledFromCard(filled.join(', ')))),
      );
    }
  }

  /// Puts 12 digits in the field, shown as typed: 1234 5678 9012.
  void _setAadhaar(String digits) {
    _aadhaar.text = AadhaarInputFormatter()
        .formatEditUpdate(
          TextEditingValue.empty,
          TextEditingValue(text: digits),
        )
        .text;
    _formKey.currentState!.validate();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    String? required(String? v) =>
        (v == null || v.trim().isEmpty) ? l.errorRequired : null;

    return MultiBlocListener(
      listeners: [
        BlocListener<RegisterFormBloc, RegisterFormState>(
          listenWhen: (a, b) => a.editing == null && b.editing != null,
          listener: (context, state) => _fill(state.editing!),
        ),
        BlocListener<RegisterFormBloc, RegisterFormState>(
          listenWhen: (a, b) => !a.done && b.done,
          listener: (context, state) {
            // New people show up in the registry, rosters and staff list.
            context.read<RegistrationBloc>().add(const PeopleLoaded());
            context.read<ClassesBloc>().add(const ClassesLoaded());
            context.read<AttendanceBloc>().add(const AttendanceRefreshed());
            context.read<StaffBloc>().add(const StaffLoaded());
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  context.read<RegisterFormBloc>().state.editing != null
                      ? l.messageSaved
                      : l.messageRegistered,
                ),
              ),
            );
            Navigator.of(context).pop();
          },
        ),
        BlocListener<RegisterFormBloc, RegisterFormState>(
          listenWhen: (a, b) => a.failure != b.failure && b.failure != null,
          listener: (context, state) =>
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.failureMessage ?? state.failure!.message(l),
                  ),
                ),
              ),
        ),
        BlocListener<RegisterFormBloc, RegisterFormState>(
          // Show "email already used" on the email field.
          listenWhen: (a, b) => !a.emailTaken && b.emailTaken,
          listener: (context, state) => _formKey.currentState!.validate(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<RegisterFormBloc, RegisterFormState>(
            buildWhen: (a, b) => a.editing != b.editing,
            builder: (context, state) => Text(
              state.editing != null
                  ? l.editStudentTitle
                  : state.type.addTitle(l),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: AppSpacing.pageOf(context),
                  children: [
                    if (context.select(
                      (RegisterFormBloc b) => b.state.editing == null,
                    )) ...[
                      InkWell(
                        onTap: _scanCard,
                        borderRadius: AppRadius.lgAll,
                        child: Container(
                          width: double.infinity,
                          padding: AppSpacing.card,
                          decoration: BoxDecoration(
                            color: context.brand.primaryLight,
                            borderRadius: AppRadius.lgAll,
                            border: Border.all(
                              color: context.brand.primary.withValues(
                                alpha: 0.5,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.document_scanner_outlined,
                                color: context.brand.primary,
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l.aadhaarScanCardTitle,
                                      style: context.text.titleSmall,
                                    ),
                                    Text(
                                      l.aadhaarScanCardHint,
                                      style: context.text.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],
                    TextFormField(
                      controller: _name,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(labelText: l.fieldFullName),
                      validator: required,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    // One field on each line.
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _phone,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          decoration: InputDecoration(
                            labelText: l.fieldPhone,
                            prefixText: '+91 ',
                          ),
                          validator: (v) => (v ?? '').length == 10
                              ? null
                              : l.errorPhoneInvalid,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        BlocBuilder<RegisterFormBloc, RegisterFormState>(
                          buildWhen: (a, b) => a.gender != b.gender,
                          builder: (context, state) =>
                              DropdownButtonFormField<Gender?>(
                                key: ValueKey(state.gender),
                                initialValue: state.gender,
                                isExpanded: true,
                                decoration: InputDecoration(
                                  labelText: l.fieldGender,
                                ),
                                items: [
                                  const DropdownMenuItem<Gender?>(
                                    value: null,
                                    child: Text('–'),
                                  ),
                                  DropdownMenuItem<Gender?>(
                                    value: Gender.male,
                                    child: Text(l.genderMale),
                                  ),
                                  DropdownMenuItem<Gender?>(
                                    value: Gender.female,
                                    child: Text(l.genderFemale),
                                  ),
                                  DropdownMenuItem<Gender?>(
                                    value: Gender.other,
                                    child: Text(l.genderOther),
                                  ),
                                ],
                                onChanged: (g) => context
                                    .read<RegisterFormBloc>()
                                    .add(RegisterGenderChosen(g)),
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    BlocBuilder<RegisterFormBloc, RegisterFormState>(
                      buildWhen: (a, b) =>
                          a.dateOfBirth != b.dateOfBirth || a.type != b.type,
                      builder: (context, state) => PickerField(
                        label: l.fieldDob,
                        prefixIcon: Icons.cake_outlined,
                        value: state.dateOfBirth == null
                            ? null
                            : formatShortDate(context, state.dateOfBirth!),
                        onTap: () => _pickDob(state.dateOfBirth),
                        // Checked as soon as it is set (picked or read from the
                        // card) and again when the kind of person changes.
                        errorText: state.dateOfBirth == null
                            ? null
                            : switch (DobRules.check(
                                state.dateOfBirth!,
                                state.type,
                                DateTime.now(),
                              )) {
                                DobProblem.future => l.dobErrFuture,
                                DobProblem.tooYoung => l.dobErrYoung(
                                  DobRules.minAge(state.type),
                                ),
                                DobProblem.tooOld => l.dobErrOld(
                                  DobRules.maxAge(state.type),
                                ),
                                null => null,
                              },
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    BlocBuilder<RegisterFormBloc, RegisterFormState>(
                      buildWhen: (a, b) => a.type != b.type,
                      builder: (context, state) => switch (state.type) {
                        PersonType.student => _studentFields(l, required),
                        PersonType.teacher => _teacherFields(l),
                        PersonType.other => Column(
                          children: [
                            TextFormField(
                              controller: _role,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                labelText: l.fieldRole,
                              ),
                              validator: required,
                            ),
                            // A driver's van number appears once the role
                            // says driver.
                            ValueListenableBuilder<TextEditingValue>(
                              valueListenable: _role,
                              builder: (context, role, _) =>
                                  StaffRole.drivesVehicle(role.text)
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                        top: AppSpacing.md,
                                      ),
                                      child: TextFormField(
                                        controller: _vehicle,
                                        textCapitalization:
                                            TextCapitalization.characters,
                                        decoration: InputDecoration(
                                          labelText: l.fieldVanNumber,
                                          hintText: l.hintVanNumber,
                                          prefixIcon: const Icon(
                                            Icons.directions_bus_outlined,
                                          ),
                                        ),
                                        validator: required,
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ],
                        ),
                      },
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    TextFormField(
                      controller: _address,
                      minLines: 2,
                      maxLines: 4,
                      textCapitalization: TextCapitalization.words,
                      keyboardType: TextInputType.streetAddress,
                      decoration: InputDecoration(
                        labelText: l.fieldAddress,
                        alignLabelWithHint: true,
                        prefixIcon: const Icon(Icons.home_outlined),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const SizedBox(height: AppSpacing.md),
                    if (context.select(
                      (RegisterFormBloc b) => b.state.editing == null,
                    )) ...[
                      TextFormField(
                        controller: _aadhaar,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        inputFormatters: [AadhaarInputFormatter()],
                        decoration: InputDecoration(
                          labelText: l.fieldAadhaar,
                          prefixIcon: const Icon(Icons.fingerprint),
                          suffixIcon: IconButton(
                            tooltip: l.aadhaarScan,
                            icon: const Icon(Icons.document_scanner_outlined),
                            onPressed: _scanCard,
                          ),
                        ),
                        // Optional: left empty, the reason is asked for below.
                        validator: (v) =>
                            Aadhaar.digitsOnly(v ?? '').isEmpty ||
                                Aadhaar.isValid(v ?? '')
                            ? null
                            : l.errorAadhaarInvalid,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      const AadhaarNote(),
                      ValueListenableBuilder<TextEditingValue>(
                        valueListenable: _aadhaar,
                        builder: (context, value, _) =>
                            Aadhaar.digitsOnly(value.text).isNotEmpty
                            ? const SizedBox.shrink()
                            : Padding(
                                padding: const EdgeInsets.only(
                                  top: AppSpacing.md,
                                ),
                                child: TextFormField(
                                  controller: _aadhaarReason,
                                  minLines: 2,
                                  maxLines: 4,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  decoration: InputDecoration(
                                    labelText: l.fieldAadhaarReason,
                                    hintText: l.hintAadhaarReason,
                                    alignLabelWithHint: true,
                                    prefixIcon: const Icon(
                                      Icons.edit_note_outlined,
                                    ),
                                  ),
                                  validator: required,
                                ),
                              ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],
                    const SizedBox(height: AppSpacing.lg),
                    BlocBuilder<RegisterFormBloc, RegisterFormState>(
                      buildWhen: (a, b) =>
                          a.saving != b.saving || a.editing != b.editing,
                      builder: (context, state) => FilledButton(
                        onPressed: state.saving ? null : _submit,
                        child: state.saving
                            ? SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: context.brand.onPrimary,
                                ),
                              )
                            : Text(
                                state.editing != null
                                    ? l.actionSave
                                    : state.type.saveLabel(l),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _studentFields(
    AppLocalizations l,
    String? Function(String?) required,
  ) {
    return Column(
      children: [
        BlocBuilder<ClassesBloc, ClassesState>(
          builder: (context, classes) => DropdownButtonFormField<String>(
            initialValue: context.read<RegisterFormBloc>().state.classSection,
            decoration: InputDecoration(labelText: l.fieldClass),
            items: [
              for (final c in classes.classes)
                DropdownMenuItem(value: c.name, child: Text(c.name)),
            ],
            onChanged: (v) =>
                context.read<RegisterFormBloc>().add(RegisterClassChosen(v)),
            validator: (v) => v == null ? l.errorRequired : null,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          controller: _guardian,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(labelText: l.fieldGuardian),
          validator: required,
        ),
        BlocBuilder<RegisterFormBloc, RegisterFormState>(
          buildWhen: (a, b) =>
              a.vehicles != b.vehicles || a.vehicleNumber != b.vehicleNumber,
          builder: (context, s) => s.vehicles.isEmpty
              ? const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.md),
                  child: DropdownButtonFormField<String?>(
                    key: ValueKey(s.vehicleNumber),
                    initialValue: s.vehicleNumber,
                    decoration: InputDecoration(
                      labelText: l.fieldVan,
                      prefixIcon: const Icon(Icons.directions_bus_outlined),
                    ),
                    items: [
                      DropdownMenuItem<String?>(
                        value: null,
                        child: Text(l.fieldNoVan),
                      ),
                      for (final v in s.vehicles)
                        DropdownMenuItem<String?>(value: v, child: Text(v)),
                    ],
                    onChanged: (v) => context.read<RegisterFormBloc>().add(
                      RegisterVehicleChosen(v),
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _teacherFields(AppLocalizations l) {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          initialValue: context.read<RegisterFormBloc>().state.subject,
          decoration: InputDecoration(labelText: l.fieldSubject),
          items: [
            for (final s in _subjects)
              DropdownMenuItem(value: s, child: Text(s)),
          ],
          onChanged: (v) =>
              context.read<RegisterFormBloc>().add(RegisterSubjectChosen(v)),
          validator: (v) => v == null ? l.errorRequired : null,
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          controller: _email,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(labelText: l.fieldLoginEmail),
          validator: (v) {
            if (v == null || !const EmailRule().isValid(v)) {
              return l.errorEmailInvalid;
            }
            if (context.read<RegisterFormBloc>().state.emailTaken) {
              return l.errorEmailTaken;
            }
            return null;
          },
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          controller: _password,
          decoration: InputDecoration(
            labelText: l.fieldTempPassword,
            helperText: l.helperTempPassword,
          ),
          validator: (v) => (v ?? '').length < kMinPasswordLength
              ? l.errorPasswordShort(kMinPasswordLength)
              : null,
        ),
      ],
    );
  }
}
