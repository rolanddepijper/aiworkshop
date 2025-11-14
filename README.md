# AI Workshop - OpenEdge ABL Project

This repository contains an OpenEdge ABL project demonstrating the Business Entity architecture pattern.

## Overview

This project showcases a three-tier architecture for OpenEdge ABL applications:
- **Presentation Layer**: UI windows (.w files)
- **Business Logic Layer**: Entity classes (.cls files)
- **Data Access Layer**: ProDataSource with temp-table/dataset binding

## Project Structure

- `src/` - Source code
  - `business/` - Business entity classes and dataset definitions
  - `*.w` - UI window files
- `dump/` - Database schema files
- `doc/` - Documentation
- `.windsurf/` - AI assistant rules and workflows

## Features

- Customer management with business entity pattern
- Item management with validation rules
- Singleton factory pattern for entity management
- Dataset-based data contracts
- Change tracking for efficient updates

## Database

The project uses the sports2000 database schema.
