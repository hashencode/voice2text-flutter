---
status: pending
priority: p2
issue_id: "001"
tags: [ui, tabs, design-system]
dependencies: []
---

# Unify Tabs Rail Background Design Spec

Define and apply a consistent design rule for the `Tabs` rail background color across the Flutter BNA showcase.

## Problem Statement

The current `Tabs` implementation uses a working background color, but there is no explicit shared design rule for when the rail should use neutral, brand, tinted, light, or dark surfaces. That makes future components and future `Tabs` variants likely to drift visually.

This matters because:

- `Tabs` is now a foundational navigation primitive in the BNA migration.
- The rail background is visually dominant and affects active state contrast.
- Without a written rule, future pages may pick ad hoc values that break consistency.

## Findings

- Current Flutter `Tabs` rail colors are set via component inputs in `lib/features/ui_showcase/widgets/bna_tabs.dart`.
- Demo pages already use multiple rail treatments:
- Default and disabled sections use the neutral secondary token.
- Styled section uses dynamic brand-colored backgrounds.
- There is no documented mapping between variant intent and allowed background tokens.
- The user explicitly requested a durable todo to standardize the tab bar background color design.

## Proposed Solutions

### Option 1: Token Mapping Spec

**Approach:** Define a small rule set for allowed rail backgrounds, for example neutral/default, brand/styled, and inverse/dark.

**Pros:**
- Fastest path
- Easy to apply to future components
- Keeps visual decisions constrained

**Cons:**
- Still requires manual enforcement
- May not capture every future edge case

**Effort:** 30-60 minutes

**Risk:** Low

---

### Option 2: Token Mapping + Component API Guardrails

**Approach:** Define the design rule and then narrow `BnaTabs` to a smaller set of named styles instead of arbitrary colors for common cases.

**Pros:**
- Stronger consistency
- Reduces future misuse
- Better alignment with a design system mindset

**Cons:**
- Slightly more refactor work
- Less flexible for ad hoc demos

**Effort:** 1-2 hours

**Risk:** Medium

## Recommended Action

**To be filled during triage.** Preferred direction is to first define the visual rule, then decide whether API constraints are needed.

## Technical Details

**Affected files:**
- `lib/features/ui_showcase/widgets/bna_tabs.dart`
- `lib/features/ui_showcase/pages/tabs_component_page.dart`
- Any future BNA showcase pages reusing `Tabs`

**Related components:**
- Button, Segmented controls, and future navigation primitives that may need shared surface-color rules

**Database changes (if any):**
- Migration needed? No
- New columns/tables? None

## Resources

- `lib/features/ui_showcase/widgets/bna_tabs.dart`
- `lib/features/ui_showcase/pages/tabs_component_page.dart`
- RN source reference: `/Users/studio/Documents/GitHub/ui/templates/start/components/ui/tabs.tsx`
- RN compare page: `/Users/studio/Documents/GitHub/ui/templates/start/app/compare-tabs.tsx`

## Acceptance Criteria

- [ ] A written design rule exists for `Tabs` rail background color usage
- [ ] Default, disabled, and styled `Tabs` demos align with that rule
- [ ] Active-state contrast remains acceptable after the rule is applied
- [ ] Future `Tabs` usage can follow the same rule without ad hoc color picking

## Work Log

### 2026-05-15 - Initial Discovery

**By:** Codex

**Actions:**
- Migrated `Tabs` as a Flutter showcase component
- Identified that rail background treatments already vary between neutral and styled cases
- Logged a durable todo to standardize the background-color design rule

**Learnings:**
- The implementation supports multiple background colors today, but the design intent is not yet documented
- This is design-system debt, not a blocking functional bug

## Notes

- This todo is specifically about defining and enforcing background-color rules for the tab rail, not the entire `Tabs` interaction model.
