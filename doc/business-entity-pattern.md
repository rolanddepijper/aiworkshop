# ABL Business Entity Architecture Pattern

## Overview

The Business Entity pattern provides a standardized, maintainable approach to data access in OpenEdge ABL applications. It separates UI logic from database operations through a layered architecture that promotes reusability, testability, and consistency.

## Architecture Layers

### 1. UI Layer (Windows/Forms)
- **Responsibility**: User interaction and presentation
- **Access**: Never directly accesses database tables
- **Communication**: Calls Business Entity methods with datasets

### 2. Business Entity Layer
- **Responsibility**: Data access, business rules, validation
- **Inheritance**: Extends `OpenEdge.BusinessLogic.BusinessEntity`
- **Management**: Instantiated through EntityFactory (singleton pattern)

### 3. Database Layer
- **Responsibility**: Persistent storage
- **Access**: Only through data-sources attached to business entities

## Key Components

### EntityFactory (Singleton Pattern)

Centralized management of business entity lifecycle. Prevents duplicate instances and enables centralized cleanup.

### Dataset Definition (.i Include Files)

Defines temp-tables and datasets for data transfer between layers. Uses BEFORE-TABLE for change tracking.

### Business Entity Class

Encapsulates all data operations for a specific entity. Must inherit from `OpenEdge.BusinessLogic.BusinessEntity`.

## Standard CRUD Operations

### Read Operations
- Use `OUTPUT DATASET` parameter (NOT `BY-REFERENCE`)
- Build filter as string with WHERE clause
- Call parent's `ReadData()` method
- Return success/failure indicator

### Create Operations
- Caller populates temp-table with new record
- Call `CreateData()` with `BY-REFERENCE`

### Update Operations
- Enable `TRACKING-CHANGES` on temp-table
- Modify temp-table fields
- Validate changes
- Call `UpdateData()` with `BY-REFERENCE`

### Delete Operations
- Enable `TRACKING-CHANGES`
- Mark record for deletion
- Call `DeleteData()` with `BY-REFERENCE`

## Validation Pattern

Always validate before Create/Update operations. Return specific error messages for UI display.

## Common Pitfalls

1. **Using BY-REFERENCE on OUTPUT DATASET for Read Operations** - Causes handle mismatch
2. **Forgetting Change Tracking for Updates** - Changes not detected
3. **Missing Data-Source Assignment** - ProDataSource not set in constructor
4. **Direct Database Access from UI** - Breaks separation of concerns
5. **Not Using Named Buffers** - Poor code clarity

## Benefits

- **Maintainability**: Centralized data access logic
- **Reusability**: Business entities shared across UI components
- **Testability**: Business logic isolated from UI
- **Consistency**: All data access follows same pattern
- **Scalability**: Easy to add new entities

## References

- Project Examples:
  - `src/business/CustomerEntity.cls`
  - `src/business/EntityFactory.cls`
  - `src/CustomerWin.w`
