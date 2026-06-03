---
description: Add a new property to an existing class
---

# New Property Addition Workflow

This workflow guides you through adding a new property to the currently open ABL class.

## Steps

1. **Determine Property Name**
2. **Select Property Type** (CHARACTER, INTEGER, DECIMAL, LOGICAL, DATE, etc.)
3. **Select Access Level for GET** (PUBLIC, PROTECTED, PRIVATE)
4. **Select Access Level for SET** (PUBLIC, PROTECTED, PRIVATE, NONE for read-only)
5. **Is Property Static?** (YES/NO)
6. **Need Custom Accessor Logic?** (YES/NO)

## Simple Property Template

```abl
DEFINE PUBLIC PROPERTY propertyName AS CHARACTER
    GET.
    PRIVATE SET.
```

## Best Practices

- Group property declarations at the top of the class
- Use private setters for properties that should only be modified internally
- Use consistent naming conventions
