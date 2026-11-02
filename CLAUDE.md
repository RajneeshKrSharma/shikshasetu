# Shiksha Setu — Project Rules

Flutter school-management app (Principal + Teachers). Offline-first, local SQLite.

## Architecture (mandatory, everywhere)

Feature-first folders with Clean Architecture. Every feature follows exactly:

```
lib/features/<feature>/
├── data/
│   ├── dto/          # storage/JSON shapes: fromMap / toMap (no business logic)
│   ├── models/       # extend domain entities; fromDto / toDto / fromEntity
│   └── repository/   # implements the domain repository contracts
├── domain/
│   ├── entities/     # pure Dart business objects
│   ├── repository/   # abstract contracts (what the domain needs)
│   └── usecases/     # one class per action, single `call()`
└── presentation/
    ├── bloc/         # *_bloc.dart, *_event.dart, *_state.dart (or Cubit)
    ├── screen/       # screens (Scaffold + bloc wiring)
    └── widgets/      # reusable widgets / dialogs / sheets
```

Dependency rule: `presentation → domain ← data`. Domain imports nothing from
data or presentation. Presentation never touches repositories directly; it
only dispatches events to blocs, and blocs call use cases.

Shared code lives in `lib/core/` (theme, widgets, utils, usecase base) and
`lib/l10n/`. Dependency injection: `get_it` in `lib/di/`.

## Rules (non-negotiable)

1. **No `setState`. Ever.** Data, selections, filters, lists, loading and error
   state live in a bloc/cubit. A purely visual local toggle (e.g. password
   visibility) uses a `ValueNotifier` + `ValueListenableBuilder`.
2. **UI only consumes data and shows it.** Widgets read bloc state and dispatch
   events. No business logic, no role checks, no calculations, no formatting
   rules, no repository/DB/service calls in `presentation/screen` or `widgets`.
3. **Blocs carry the minimum logic**: map events to use-case calls and emit
   states. Anything that is a business decision lives in a use case.
4. **OOP, strictly.** Model the domain with classes: abstract base classes and
   interfaces, inheritance for "is-a", composition for "has-a", polymorphism
   instead of `if/switch` on a type. No god classes, no static helper piles,
   no top-level business functions.
5. **SOLID.** One responsibility per class; open for extension, closed for
   modification (add a feature by adding a class, not editing a switch); a
   subclass must be usable wherever its base is; small focused interfaces;
   depend on abstractions and inject them through constructors.
6. **Layers: data → domain (use cases) → presentation.** `presentation →
   domain ← data`. Domain imports nothing from data or presentation.
   Presentation never touches repositories; blocs call use cases.

Also:

- **State = BLoC** (`flutter_bloc`). States are immutable (`Equatable`).
- **Lifecycle**: create controllers/focus nodes/notifiers in `initState`, free
  them in `dispose`. Blocs are created by `BlocProvider` (it closes them).
  Trigger initial loads from the bloc's creation (`..add(Started())`), not
  from `build`.
- Strings only through `context.l10n` (ARB files, English + Hindi). Colors
  and spacing only from `core/theme`. No hardcoded UI text or colors.
- Don't invent business rules or numbers; ask first.

## App structure: School → Principal → three parents

Everything a Principal manages belongs to one of three parents, and each
parent shows all of its features in one place (its workspace):

| Parent   | Features |
|----------|----------|
| Students | Add/edit/delete (CRUD), Dress, Books, Fees, Academic performance |
| Teachers | Add/edit/delete (CRUD), Teacher payment, Question bank, Exam papers |
| Others (driver, helper, ...) | Add/edit/delete (CRUD), Payment, Bills (petrol/diesel) |

The three parents share one base (`Person` entity, `MemberRepository<T>`,
generic CRUD use cases, one workspace/list/form/profile UI) and each overrides
only what differs. A new parent or a new feature is added by adding classes,
never by branching on the kind in existing code. The full plan and the
current-to-new mapping is in `docs/revamp-plan.md`.

## Commands

```bash
flutter pub get
flutter gen-l10n          # after editing lib/l10n/*.arb
# new strings: python3 -c "from tool.add_l10n import add; add({'key': ('English', 'हिन्दी')})"
flutter analyze
flutter test
flutter run
```

## Tests

Tests mirror `lib/`. Repository tests use the real schema on in-memory SQLite
(`test/helpers/test_database.dart`). Use cases and blocs are tested with
fake repositories + `bloc_test`.
