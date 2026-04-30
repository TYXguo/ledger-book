# Repository guidelines

This repository is organized as a monorepo.

## Structure
- `server/` contains backend code only
- `mobile/` contains mobile client code only

## Conventions
- Keep database schema as the source of truth
- Prefer explicit domain boundaries over ad-hoc helpers
- Prefer stable, query-friendly models for finance data
- Keep money-related fields decimal-safe and never use floating point
- Always support both member-scoped and family-scoped analytics
