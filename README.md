# AI Workshop - OpenEdge ABL Project

This repository contains an OpenEdge ABL project demonstrating the Business Entity pattern for data access and management.

## Project Structure

- `src/business/` - Business entity classes and dataset definitions
- `src/` - UI windows and application code
- `.windsurf/` - Windsurf IDE configuration and workflows
- `dump/` - Database schema files
- `doc/` - Documentation

## Key Components

- **CustomerEntity** - Business entity for customer data access
- **EntityFactory** - Singleton factory for managing entity instances
- **CustomerWin.w** - Customer management window
- **ItemWin.w** - Item management window

## Getting Started

1. Ensure OpenEdge 12.8 or later is installed
2. Review the database schema in `dump/sports2000.df`
3. Check the documentation in `doc/business-entity-pattern.md`

## Architecture

This project follows the Business Entity pattern with:
- Separation of UI and data access layers
- Dataset-based data transfer
- Singleton factory pattern for entity management
- Validation and business rules in entity classes
