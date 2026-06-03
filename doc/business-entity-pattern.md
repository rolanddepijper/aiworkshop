# ABL Business Entity Architecture Pattern

## Overview

The Business Entity pattern provides a standardized, maintainable approach to data access in OpenEdge ABL applications. It separates UI logic from database operations through a layered architecture that promotes reusability, testability, and consistency across the application.

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

**Purpose**: Centralized management of business entity lifecycle

```abl
CLASS business.EntityFactory:
    VAR PRIVATE STATIC EntityFactory objInstance.
    VAR PRIVATE CustomerEntity objCustomerEntityInstance.
    
    CONSTRUCTOR PRIVATE EntityFactory():
    END CONSTRUCTOR.
    
    METHOD PUBLIC STATIC EntityFactory GetInstance():
        IF objInstance = ? THEN
            objInstance = NEW EntityFactory().
        RETURN objInstance.
    END METHOD.
    
    METHOD PUBLIC CustomerEntity GetCustomerEntity():
        IF objCustomerEntityInstance = ? THEN
            objCustomerEntityInstance = NEW CustomerEntity().
        RETURN objCustomerEntityInstance.
    END METHOD.
END CLASS.
```

### Dataset Definition (.i Include Files)

```abl
DEFINE TEMP-TABLE ttCustomer BEFORE-TABLE bttCustomer
    FIELD CustNum AS INTEGER INITIAL "0" LABEL "Cust Num"
    FIELD Name AS CHARACTER LABEL "Name"
    INDEX CustNum IS PRIMARY UNIQUE CustNum ASCENDING.

DEFINE DATASET dsCustomer FOR ttCustomer.
```

### Business Entity Class

```abl
CLASS business.CustomerEntity INHERITS BusinessEntity USE-WIDGET-POOL:
    
    {business/CustomerDataset.i}
    DEFINE DATA-SOURCE srcCustomer FOR Customer.
    
    CONSTRUCTOR PUBLIC CustomerEntity():
        SUPER(DATASET dsCustomer:HANDLE).
        VAR HANDLE[1] hDataSourceArray = DATA-SOURCE srcCustomer:HANDLE.
        VAR CHARACTER[1] cSkipListArray = [""].
        THIS-OBJECT:ProDataSource = hDataSourceArray.
        THIS-OBJECT:SkipList = cSkipListArray.
    END CONSTRUCTOR.
    
END CLASS.
```

## Standard CRUD Operations

### Read
```abl
METHOD PUBLIC LOGICAL GetCustomerByNumber(INPUT ipiCustNum AS INTEGER,
                                          OUTPUT DATASET dsCustomer):
    VAR CHARACTER cFilter = "WHERE Customer.CustNum = " + STRING(ipiCustNum).
    THIS-OBJECT:ReadData(cFilter).
    RETURN CAN-FIND(FIRST ttCustomer).
END METHOD.
```

### Update
```abl
METHOD PUBLIC VOID UpdateCustomer(INPUT-OUTPUT DATASET dsCustomer):
    THIS-OBJECT:UpdateData(DATASET dsCustomer BY-REFERENCE).
END METHOD.
```

### Validate
```abl
METHOD PUBLIC LOGICAL ValidateCustomer(INPUT-OUTPUT DATASET dsCustomer,
                                     OUTPUT errorMessage AS CHARACTER):
    FIND FIRST ttCustomer NO-ERROR.
    IF AVAILABLE ttCustomer THEN DO:
        IF ttCustomer.Name = "" THEN DO:
            errorMessage = "Customer name cannot be empty".
            RETURN FALSE.
        END.
    END.
    RETURN TRUE.
END METHOD.
```

## UI Integration Pattern

```abl
USING business.CustomerEntity FROM PROPATH.
USING business.EntityFactory FROM PROPATH.
{business/CustomerDataset.i}

ON CHOOSE OF GetCustomer IN FRAME DEFAULT-FRAME:
    VAR EntityFactory objFactory = EntityFactory:GetInstance().
    VAR CustomerEntity objEntity = objFactory:GetCustomerEntity().
    VAR LOGICAL lFound = objEntity:GetCustomerByNumber(
        INTEGER(CustomerNumber:screen-value), OUTPUT DATASET dsCustomer).
    
    IF lFound THEN DO:
        FIND FIRST ttCustomer.
        CustomerName = ttCustomer.Name.
        DISPLAY CustomerName WITH FRAME {&frame-name}.
    END.
    ELSE 
        MESSAGE "Customer not found" VIEW-AS ALERT-BOX.
END.
```

### Update Flow (UI)
```abl
/* 1. Fetch */
lFound = objEntity:GetCustomerByNumber(iNum, OUTPUT DATASET dsCustomer).
IF lFound THEN DO:
    FIND FIRST ttCustomer NO-ERROR.
    /* 2. Enable change tracking */
    TEMP-TABLE ttCustomer:TRACKING-CHANGES = TRUE.
    /* 3. Modify */
    ttCustomer.Name = CustomerName.
    /* 4. Validate */
    isValid = objEntity:ValidateCustomer(DATASET dsCustomer BY-REFERENCE, OUTPUT cErrorMessage).
    /* 5. Save */
    IF isValid THEN
        objEntity:UpdateCustomer(DATASET dsCustomer BY-REFERENCE).
    ELSE
        MESSAGE cErrorMessage VIEW-AS ALERT-BOX.
END.
```

## Common Pitfalls

| Pitfall | Wrong | Correct |
|---|---|---|
| OUTPUT DATASET for reads | `OUTPUT DATASET ds BY-REFERENCE` | `OUTPUT DATASET ds` |
| Change tracking | Modify then update | `TRACKING-CHANGES = TRUE` before modify |
| Direct DB access in UI | `FIND FIRST Customer NO-LOCK` | Use entity `GetXxx()` method |
| Direct instantiation | `NEW CustomerEntity()` | `EntityFactory:GetInstance():GetCustomerEntity()` |

## Refactoring Checklist

1. Create `business/XxxDataset.i` — temp-table + dataset mirroring DB table
2. Create `business/XxxEntity.cls` — inherits BusinessEntity, wires ProDataSource/SkipList
3. Register in `EntityFactory.cls` — add instance field + `GetXxxEntity()` + cleanup in `ResetInstances()`
4. Update UI — replace FIND/FOR EACH with factory+entity calls, remove all locks
5. Test — create `src/testXxx.p` per ABL testing guidelines

## Codebase Reference

| File | Role |
|---|---|
| `src/business/CustomerEntity.cls` | Reference entity implementation |
| `src/business/ItemEntity.cls` | Second entity example |
| `src/business/EntityFactory.cls` | Singleton factory |
| `src/CustomerWin.w` | Reference UI (read + update) |
| `src/ItemWin.w` | Second UI example |
| `.windsurf/rules/abl-syntax-rules.md` | Buffer usage rules |
