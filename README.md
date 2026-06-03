# AI Workshop - OpenEdge ABL Project

This repository contains the OpenEdge ABL project used for the AI Workshop.

## Project Structure

- `src/` - ABL source files (classes, windows, procedures)
- `src/business/` - Business entity layer (EntityFactory, CustomerEntity, ItemEntity)
- `dump/` - Database schema (.df file)
- `doc/` - Architecture documentation
- `.windsurf/rules/` - Windsurf coding rules
- `.windsurf/workflows/` - Windsurf workflow definitions

## Architecture

This project demonstrates the **Business Entity Pattern** for OpenEdge ABL applications.
See `doc/business-entity-pattern.md` for full documentation.

## Database

Uses the Sports2000 demo database. Schema is in `dump/sports2000.df`.
