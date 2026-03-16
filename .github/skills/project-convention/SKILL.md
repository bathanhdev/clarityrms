---

name: project-convention
description: Enforce UI, DI, networking and repository conventions for Clarity RMS. Use this
skill during PR review or automation to detect common violations and recommend
fixes based on the project's README and conventions.

---

# Skill Instructions

Purpose

- Provide a concise, actionable set of checks and reviewer guidance for PRs
  touching `lib/` (especially `features/*/presentation/*`, `core/*`, `shared/*`).

When to use

- Run on every PR or when reviewing changes that affect UI, DI, routing, or
  generated code.

Automatable checks (patterns + expected action)

- DI misuse
  - Pattern: `\bsl\s*\(|GetIt.instance` in `lib/features/**` (exclude `lib/core/di/**`).
  - Action: flag violation; recommend constructor injection and registering in
    `lib/core/di/injection_container.dart`.

- Hard-coded colors & theming
  - Pattern: `Color(` or `0x[0-9A-Fa-f]{6,8}` inside `lib/features/**/presentation/**`.
  - Action: recommend `Theme.of(context).colorScheme` or `AppColors` tokens.

- Magic numbers for layout
  - Pattern: numeric literals used for padding/width/height/radius in UI files.
  - Action: recommend `AppSpacing`, `AppDimensions`, `AppRadius`. If token is
    missing, suggest adding it to the appropriate token file.

- Navigation
  - Pattern: `Navigator.` in presentation pages.
  - Action: suggest `GoRouter.of(context).push(...)` or `GoRouter.of(context).pop()` and route constants.

- Repeated literals (keys/tags)
  - Pattern: repeated string literals used as keys or hero tags (e.g. `'app_logo'`).
  - Action: centralize to `lib/shared/constants/` and use constants.

- Generated code changes
  - Pattern: Freezed/Envied model edits without generated files changed or CI codegen step.
  - Action: require codegen in CI or include generated outputs when appropriate.

Reviewer checklist (manual)

- Run `flutter analyze` and ensure no errors or high-severity warnings.
- Confirm no `sl()`/`GetIt.instance` calls outside composition root (`lib/core/di`).
- Confirm use of tokens: `AppSpacing`, `AppRadius`, `AppDimensions` for layout.
- Confirm theming: colors via `Theme.of(context)` or `AppColors` tokens.
- Confirm navigation uses `GoRouter` and route constants where applicable.
- Confirm reusable widgets moved to `presentation/widgets/` if used across pages.
- Confirm no secrets (`assets/env/*`) in the commit.

Quick repair examples

- Row overflow: wrap the label with `Flexible` or use `Expanded` for the flexible child.
- Hard-coded hero tag: add `lib/shared/constants/hero_tags.dart` and replace literal with `HeroTags.appLogo`.
- Magic card width: replace `BoxConstraints(maxWidth: 560)` with `AppDimensions.cardMaxWidth` or add a new token.

CI integration suggestions

- Workflow `.github/workflows/analyze.yml` (basic):
  - name: Analyze
    on: [pull_request]
    jobs:
    analyze:
    runs-on: ubuntu-latest
    steps: - uses: actions/checkout@v4 - uses: subosito/flutter-action@v2
    with:
    flutter-version: 'stable' - run: flutter pub get - run: dart format --output=none --set-exit-if-changed . - run: flutter analyze

- Optional: run `flutter pub run build_runner build --delete-conflicting-outputs`
  when PR touches generated/model files.

Automation script idea

- A lightweight script (bash/PowerShell/Dart) that:
  1. Reads changed files from `git diff --name-only origin/main...HEAD`.
  2. Greps for the patterns above (`sl(`, `Color(`, `Navigator.`, magic numbers).
  3. Outputs a JSON report with file, line, pattern, and suggested fix.

Policy for agents

- Agents may _report_ violations and optionally create candidate patches for
  low-risk fixes (e.g., replace hard-coded hero tag with constant) but should
  not perform broad UI tokenization or refactors without human review.

Contacts

- If rules are unclear, tag module owners or `@maintainers` in PR description.

---

End of skill instructions.
