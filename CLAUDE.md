# CLAUDE.md

<!--
Golden Test before adding any rule:
"Would removing this rule cause Claude to make mistakes?"
If not — cut it. Only override defaults or encode project-specific decisions.
-->

---

# Section A — General Engineering Rules

## 1) Architecture
- Strict layer boundaries: **presentation → domain → data**. Never bypass or mix.
- Presentation layer: zero business logic — only rendering, interaction, state observation.
- Business logic in domain. Data access (APIs, DB, storage) in data layer.
- Feature-first architecture only. No new abstractions without justification.

## 2) Shared Code
- Anything reused in 2+ places goes in `core/`.
- Check `core/` before creating new shared code — never duplicate across features.

## 3) Error Handling
- Catch errors at the data-layer boundary, not deep inside business logic.
- Errors flow across layers — never skip layers.
- Handle null, empty, loading, and error states explicitly.

## 4) Dependencies
- New packages must be: latest stable, well-maintained, production-grade.
- Justify any new package added.

## 5) Testing
- Test domain and data layers.
- Bug fixes must include a reproducing test.
- Tests must be deterministic. One behavior per test case.

## 6) Workflow (Mandatory)
- Before marking any task done → run the `/code-review` skill.
- After approval → run the `/create-pr` skill.
- PR descriptions must be in markdown.

---

# Section B — Flutter / Dart Rules

## 1) State Management
- Use **Cubit/Bloc**. Not Riverpod, Provider, or GetX.
- Cubits depend ONLY on use cases — never on repositories or data sources directly.
- `setState` allowed only for local UI state (toggles, focus). Never for business logic.
- Never put business logic inside `BlocBuilder`, `BlocConsumer`, or `BlocListener`.

## 2) No Code Generation
- **No Freezed. No build_runner.** Use Dart 3+ natively:
  - `sealed class` for state unions with exhaustive pattern matching
  - `switch` expressions and records for lightweight data

## 3) Domain Layer Purity
- Zero Flutter imports in `domain/`. No `package:flutter/...` anywhere under it.

## 4) Folder Structure
- `features/{feature_name}/data/`
- `features/{feature_name}/domain/`
- `features/{feature_name}/presentation/`

## 5) Error Contract Across Layers
- Data: catch exceptions, map to typed `Failure` classes.
- Domain: return `ApiResult<T>` from use cases and repositories.
- Presentation: map failures to user-friendly messages and UI states.

## 6) Dependency Injection
- Use **`get_it`** as the service locator. Not Provider or constructor-only injection.
- Register everything in a single `core/di/` setup file.
- Cubits, use cases, and repositories are resolved via `get_it` — never instantiated manually.

## 7) Build Method Discipline
- Never create `TextEditingController`, `AnimationController`, or `FocusNode` inside `build()`.
- Dispose all controllers and focus nodes in `dispose()`.
- Use `BlocBuilder` / `BlocSelector` on the smallest widget that needs the state.

## 8) Animations
- Prefer implicit animations first: `AnimatedContainer`, `AnimatedOpacity`, `AnimatedSwitcher`, `AnimatedAlign`, `Hero`. Reach for `AnimationController` only when implicit widgets can't express the motion.
- When using `AnimationController`: always `dispose()` it, and use `vsync: this` with `SingleTickerProviderStateMixin` (or `TickerProviderStateMixin` for multiple).
- Animations must be purposeful — feedback, continuity, hierarchy. No decorative motion for its own sake.
- Respect `MediaQuery.disableAnimations` for accessibility — skip or shorten motion when true.
- Standard durations: short **150–200ms**, medium **250–300ms**, long **400–500ms**. Don't invent new durations per screen.
- Default curves: `Curves.easeInOut`, `Curves.easeOutCubic`, or the design-system curve. Avoid `Curves.linear` for UI motion.
- Centralize shared durations and curves in `core/constants/`.

## 9) UI Consistency
- Reuse shared widgets before creating new ones.
- Never hardcode colors, text styles, spacing, or radius values — pull from the design system.

## 10) Responsive Design
- Use `flutter_screenutil` consistently. Avoid fixed width/height unless required by the design.

## 11) Networking
- Single networking client configuration across the app.
- Centralize interceptors, headers, timeouts, and logging.
- Map all network exceptions to typed failures.

## 12) Localization
- All user-visible text goes through localization keys. Never hardcode strings in widgets.

## 13) Models
- Keep DTOs, domain entities, and UI models separate.
- Repositories return domain entities — never expose API response models to presentation.

## 14) Naming
- Cubits: `FeatureCubit`. States: `FeatureState`.
- Use cases: action-named — `GetEventsUseCase`, `CreateBookingUseCase`, `UpdateProfileUseCase`.

## 15) Constants
- Shared constants (durations, curves, sizes, keys) belong in `core/constants/`.
