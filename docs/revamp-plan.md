# Revamp plan: School → Principal → Students / Teachers / Others

## Status (built so far)

| Phase | State |
|---|---|
| 1–3 Foundation (`members`: `Member`, `MemberKind`, `MemberRepository<T>`, `MemberDirectory`, `MemberWorkspace`, workspace/list UI) | done |
| 4 Students: list, add, edit, make inactive, profile, Fees (heads, setup, proof, own dates), Accessories (Dress sizes, issue with signature, Books, issue log), Attendance (All / Present / Absent / Late) | done |
| Teachers workspace: list, add, assign class, subjects, Question bank, Exam papers, Attendance (All / Present / Absent), Teacher payment | done on the common base; teacher edit and the Teacher-app question bank / paper maker are not built yet |
| Others workspace: list, add (driver van number), Attendance (marked by the Principal), Payment | done; Bills, bill approval, settlement proof and staff profile are not built yet |
| 9 New shell: Home / Students / Teachers / Others / Profile, drawer and shortcut grid removed for the Principal | done |
| Approvals: search, kind filters with counts, Waiting / Answered tabs, visible scroll bar and "Scroll to view more" | done |
| School day (timing, assembly, period schedule), Teacher app (unit-wise question bank, photo to bank, paper maker, exam types) | not built yet |
| 11 Tests for the new structure | not written yet (features first) |

Decisions taken: the question bank gets its own per-teacher unit-wise bank; deleting a person makes them inactive; the Principal adds and approves bills.

## 1. Why we are doing this

Today the app is organised by **feature**, and the Principal reaches features
through a drawer of 14 unrelated entries and a grid of shortcuts. To find
"everything about a student" you have to visit Registration, Profiles, Classes,
Fees, Exams, Attendance and Analytics separately.

The flow diagram says the opposite: the Principal thinks in **people**.

```
School
  └─ Principal
       ├─ Students  → Add(CRUD) · Dress · Books · Fees · Academic performance
       ├─ Teachers  → Add(CRUD) · Teacher payment · Question bank · Exam papers
       └─ Others    → Add(CRUD) · Payment · Bills (petrol/diesel)      (driver…)
```

**Goal:** open *Students* and see every student feature; open *Teachers* and see
every teacher feature; same for *Others*. One shared base, three overrides.

## 2. What exists today (audit)

| Finding | Where | Why it hurts |
|---|---|---|
| Role/kind decisions inside UI | `home/widgets/shortcuts.dart` (`if (principal)`, class-teacher snackbar), `person_type_picker.dart`, `fee_group_view.dart` | Breaks "UI only shows data" and OCP |
| Home loads 11 blocs by hand | `home_shell.dart` `initState` | Hidden coupling, loads data nobody opened |
| Same concept split over 4 features | `registration`, `staff`, `profiles`, `students` | Students have use cases but **no screens**; teachers live in `staff` + `registration` + `profiles` |
| Three register use cases, copy-pasted | `register_teacher.dart`, `register_other.dart`, `students/add_student.dart` | No base class |
| Fees already polymorphic in the DB (`group_type` student/teacher/other) but UI is one screen with a group switch | `fees` | Teacher payment / staff payment are hidden inside "Fees" |
| `setState` | 1 file (`face_capture_screen.dart`); 29 `StatefulWidget`s (mostly controllers) | Rule 1 |
| Drawer + quick grid + tabs all duplicate navigation | `dashboard_drawer.dart`, `quick_actions.dart` | Lost-in-place feeling |

Not in the diagram yet (new features): **Dress, Books, Bills**.

## 3. Target navigation (UX)

Principal bottom bar (replaces drawer + shortcut grid):

```
 Home        Students     Teachers      Others       Profile
 (School)
```

- **Home (School hub):** today's summary, approvals inbox, notices, calendar &
  holidays, classes, analytics, settings, backup. Things that are about the
  *school*, not one kind of person.
- **Students / Teachers / Others:** one **Workspace** screen each. Top: search +
  "Add". Below: the feature tiles of that parent, then its list of people.
  Tapping a person opens one **Member profile** showing the same feature tiles
  for that person.
- **Teacher login** keeps its small app (check-in, mark attendance, my subjects,
  exams, question bank); it reuses the same feature screens, just fewer tiles.

## 4. Object model (OOP)

### 4.1 People: one base, three subclasses

```
domain/entities
  abstract class Person                 id, name, phone, gender, dob, address, aadhaar…
    ├─ Student      extends Person      rollNo, className, guardian
    ├─ Teacher      extends Person      email, employeeId, subject, active, classTeacherOf
    └─ OtherStaff   extends Person      roleTitle (Driver, Helper, …)
  enum MemberKind { student, teacher, other }
```

### 4.2 CRUD: one contract, one SQL base, three thin subclasses

```
domain/repository
  abstract interface class MemberRepository<T extends Person>
        create(T) · update(T) · delete(id) · get(id) · list({query, filter})

data/repository
  abstract class SqlMemberRepository<T, D>          // template method:
        table, toDto(T), fromDto(D) are the only abstract parts
    ├─ StudentRepositoryImpl
    ├─ TeacherRepositoryImpl                         // + creates the login account
    └─ OtherStaffRepositoryImpl

domain/usecases  (generic, one class per action)
  AddMember<T> · UpdateMember<T> · DeleteMember<T> · GetMembers<T> · GetMember<T>
```

Registered in `get_it` once per kind (`AddMember<Student>`, `AddMember<Teacher>`…).
The three existing register use cases and `add_student` disappear.

### 4.3 Which features belong to which parent (a business rule → domain, not UI)

```
enum MemberFeature { profile, dress, books, fees, performance,
                     payment, questionBank, examPapers, bills, … }

abstract class MemberWorkspace            // what a parent offers
  MemberKind kind;  List<MemberFeature> features;
    ├─ StudentWorkspace   [dress, books, fees, performance]
    ├─ TeacherWorkspace   [payment, questionBank, examPapers]
    └─ OtherWorkspace     [payment, bills]

GetWorkspace(kind) → MemberWorkspace      // use case; UI never decides
```

Presentation owns only a **registry** `MemberFeature → (label, icon, screen)`.
Adding a feature = new enum value + new feature folder + one registry line.
No existing code is edited (OCP).

### 4.4 Payments: already polymorphic, make it explicit

`fee_accounts.group_type` stays. Introduce `abstract class PaymentPolicy` with
`StudentFeePolicy`, `TeacherPaymentPolicy`, `StaffPaymentPolicy` (labels, due
rules, who can be assigned). `FeesBloc` becomes `PaymentsBloc(kind)`; the same
screen is reached from three parents with a different `kind`. Receipts and
history are reused.

### 4.5 Presentation base (no logic, bloc is thin)

```
MemberListBloc<T>      events: Started, SearchChanged, Delete → calls GetMembers/DeleteMember
MemberFormBloc<T>      validation is a use case (ValidateMember<T>), bloc only emits
WorkspaceBloc          Started(kind) → GetWorkspace(kind)
shared widgets         MemberListScreen · MemberFormScreen · MemberProfileScreen
                       (fields come from a `MemberFormSpec` supplied per kind)
```

Aadhaar scan, photo, gender and date-of-birth rules are already shared; they
move into the form base once.

## 5. Where everything goes (current → new)

| Today | Becomes | Parent |
|---|---|---|
| `registration` (person-type picker, register form) | `members` base + per-kind form spec; picker removed | all three |
| `students` (use cases only) | `students/` with Student, repo, list/profile screens | Students |
| `classes` | `students/` sub-feature (class list, class teacher) | Students |
| `profiles` (student/teacher profile screens) | `members` profile screen + per-kind sections | all three |
| `staff` (teachers list, activate, assign class) | `teachers/` | Teachers |
| `fees` – student accounts | `payments` with `StudentFeePolicy` | Students → Fees |
| `fees` – teacher accounts | `payments` with `TeacherPaymentPolicy` | Teachers → Teacher payment |
| `fees` – other accounts | `payments` with `StaffPaymentPolicy` | Others → Payment |
| `master_questions` | unchanged feature, opened from Teachers | Teachers → Question bank |
| `exams` – set / submit / approve paper | unchanged feature, opened from Teachers | Teachers → Exam papers |
| `exams` – marks, `analytics` – class results | "Academic performance" view | Students → Academic performance |
| `attendance` – class marking, reports | student attendance, in the class view | Students |
| `attendance` – check-in, `face_id`, teacher report | teacher attendance | Teachers |
| `teaching` (subject allotment, requests) | teacher profile section | Teachers |
| `approvals` | School hub inbox | School |
| `school_calendar`, `notices`, `settings`, `backup`, `cloud_sync`, `demo_data`, `profile` (self) | unchanged | School / Profile |
| *new* `student_items` (Dress, Books) | new feature | Students |
| *new* `staff_bills` (Petrol/Diesel) | new feature | Others |

## 6. Folder layout after the revamp

```
lib/features/
  members/            Person, MemberKind, MemberRepository<T>, SqlMemberRepository,
                      generic usecases, MemberWorkspace, list/form/profile base UI
  students/           Student, StudentRepository, StudentWorkspace, class views
  teachers/           Teacher, TeacherRepository, TeacherWorkspace
  other_staff/        OtherStaff, OtherStaffRepository, OtherWorkspace
  payments/           PaymentPolicy + 3 policies (was `fees`)
  student_items/      Dress, Books            (new)
  staff_bills/        Petrol / Diesel bills   (new)
  exams/ master_questions/ attendance/ teaching/ analytics/ approvals/
  school_calendar/ notices/ settings/ backup/ cloud_sync/ face_id/ …  (kept)
  home/               School hub + bottom-nav shell only
```

Every folder keeps the mandatory `data/{dto,models,repository}`,
`domain/{entities,repository,usecases}`, `presentation/{bloc,screen,widgets}`.

## 7. Phases (the app builds and runs after each one)

| # | Phase | Result |
|---|---|---|
| 0 | Rules saved in `CLAUDE.md`; this plan agreed | done / pending your OK |
| 1 | **Domain foundation:** `Person` hierarchy, `MemberKind`, `MemberRepository<T>`, generic use cases, `MemberWorkspace` + `GetWorkspace`. Add DB-free unit tests for the model. | No UI change |
| 2 | **Data:** `SqlMemberRepository` + 3 impls over the *existing* tables (no migration), replacing register/add/staff/profile reads | Same behaviour, one path |
| 3 | **Presentation base:** `WorkspaceBloc`, `MemberListBloc<T>`, form/profile base, feature registry | Reusable screens |
| 4 | **Students parent first** (template): workspace, list, form, profile, Fees, Performance, class views | First complete parent |
| 5 | **Teachers parent:** list, form, profile, Teacher payment, Question bank, Exam papers, subjects | Second parent |
| 6 | **Others parent:** list, form, profile, Payment | Third parent |
| 7 | **Payments refactor:** `PaymentPolicy` + `PaymentsBloc(kind)` (can be folded into 4–6) | One engine, three faces |
| 8 | **New features:** Dress, Books, Bills (needs your answers, §9) with additive DB migrations v13+ | Diagram complete |
| 9 | **New shell:** bottom bar Home / Students / Teachers / Others / Profile; School hub; remove drawer, quick grid, `shortcuts.dart`, `person_type_picker`, old `staff` / `registration` / `profiles` screens; remove the 11-bloc preload from `home_shell` | Old paths gone |
| 10 | **Clean-up and audit:** grep for `setState`, logic in widgets, `switch` on kind in UI; l10n keys; `flutter analyze` clean | Rules verified |
| 11 | **Tests** rewritten for the new structure (existing ones are stale already) | Green suite |

Each phase ends with: `flutter analyze` clean and the app runnable. Phases 4–6
are the template repeated, so after phase 4 the rest is mostly configuration.

## 8. Rule checklist applied to every phase

1. No `setState` (one existing use in `face_capture_screen.dart` is replaced
   by a cubit/`ValueNotifier`).
2. Widgets only read state and send events.
3. Blocs map event → use case → state; decisions live in use cases.
4. OOP: abstract bases + subclasses; no `switch (kind)` in UI or blocs.
5. SOLID: new feature = new class, not an edited `if`.
6. data → domain → presentation, nothing skipping a layer.

## 9. Decisions needed from you (I will not invent these)

1. **Dress:** is it an item *sold* to the student (price, size, paid or not) or
   only *issued* (given, with a date)? Is the price one fixed list or per item?
   Does it feed into the student's fee account?
2. **Books:** same question; also set per class (a class book list) or free
   entry per student?
3. **Bills (petrol/diesel):** fields wanted: date, vehicle, litres, rate,
   amount, bill photo, paid/unpaid? One vehicle per driver? Who approves?
4. **Teacher payment / Other payment:** is this salary (monthly, fixed) or the
   current "amount due and instalments" model? Today it is the latter.
5. **Delete:** should deleting a person be a real delete (cascades attendance,
   marks, fees) or "archive / inactive"? Teachers already have inactive.
6. **Teacher app:** keep the current teacher screens as they are, only moved
   under the new structure?
7. **LKG / UKG** between Nursery and Class 1: keep (as in the demo data)?
8. **Order:** start with phase 1–4 (Students end to end) and review it before
   building Teachers and Others?

## Status — teacher app

- Done: shell (Home | My class | Exams | Profile); Home (check-in card, class
  attendance alert, today's periods with "+ Question", assembly duty);
  My class (Attendance | Students | Subjects); Exams tab (Drafts | Sent |
  Approved | Done, "+ New paper" → from my bank / write myself); Profile
  (check-in history, Face ID, calendar and holidays, notices, change email /
  password, language).
- Question bank (`lib/features/question_bank`): per-teacher, class + subject,
  then units. Add by photo (unit → pages → read → review → fix → save),
  from the gallery, or typed. Schema v19 (`question_units`,
  `master_questions.unit_id`, `exam_papers.exam_type`).
- Paper maker (5 steps): exam type → units → question types (units, count,
  marks each) → auto set with Replace → save draft / send to the Principal.
- Demo data: every teacher gets a bank (4 units, the last empty) for each
  class and subject they teach; demo papers carry an exam type.
- Left out on purpose: crop/rotate of the photo and the cropped photo piece in
  the fix screen (the system camera/gallery picker is used), a note to the
  Principal with the paper, half marks (marks are whole numbers).
