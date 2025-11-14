# ABL Business Entity Architecture Pattern

## Overview

The Business Entity pattern provides a standardized, maintainable approach to data access in OpenEdge ABL applications. It separates UI logic from database operations through a layered architecture.

## Architecture Layers

### 1. UI Layer
- Never directly accesses database tables
- Calls Business Entity methods with datasets

### 2. Business Entity Layer
- Handles data access, business rules, validation
- Extends `OpenEdge.BusinessLogic.BusinessEntity`
- Managed through EntityFactory (singleton pattern)

### 3. Database Layer
- Accessed only through data-sources attached to business entities

## Key Components

### EntityFactory (Singleton)

Centralized management of business entity instances:

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

### Dataset Definition

Defines temp-tables with change tracking:

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
    
    METHOD PUBLIC LOGICAL GetCustomerByNumber(INPUT ipiCustNum AS INTEGER,
                                              OUTPUT DATASET dsCustomer):
        VAR CHARACTER cFilter = "WHERE Customer.CustNum = " + STRING(ipiCustNum).
        THIS-OBJECT:ReadData(cFilter).
        RETURN CAN-FIND(FIRST ttCustomer).
    END METHOD.
    
    METHOD PUBLIC VOID UpdateCustomer(INPUT-OUTPUT DATASET dsCustomer):
        THIS-OBJECT:UpdateData(DATASET dsCustomer BY-REFERENCE).
    END METHOD.
    
    METHOD PUBLIC LOGICAL ValidateCustomer(INPUT-OUTPUT DATASET dsCustomer,
                                           OUTPUT errorMessage AS CHARACTER):
        VAR LOGICAL isValid = TRUE.
        FIND FIRST ttCustomer NO-ERROR.
        IF AVAILABLE ttCustomer THEN DO:
            IF ttCustomer.Name = "" THEN DO:
                isValid = FALSE.
                errorMessage = "Customer name cannot be empty".
            END.
        END.
        RETURN isValid.
    END METHOD.
END CLASS.
```

## UI Integration Pattern

### Read Operation

```abl
VAR INTEGER iCustomerNumber = INTEGER(CustomerNumber:screen-value).
VAR EntityFactory objFactory = EntityFactory:GetInstance().
VAR CustomerEntity objCustomerEntity = objFactory:GetCustomerEntity().
VAR LOGICAL lCustomerFound = objCustomerEntity:GetCustomerByNumber(iCustomerNumber, OUTPUT DATASET dsCustomer).

IF lCustomerFound THEN DO:
    FIND FIRST ttCustomer.
    IF AVAILABLE ttCustomer THEN DO:
        CustomerName = ttCustomer.Name.
        DISPLAY CustomerName WITH FRAME {&frame-name}.
    END.
END.
```

### Update with Validation

```abl
VAR EntityFactory objFactory = EntityFactory:GetInstance().
VAR CustomerEntity objCustomerEntity = objFactory:GetCustomerEntity().
VAR LOGICAL lFound = objCustomerEntity:GetCustomerByNumber(iCustNum, OUTPUT DATASET dsCustomer).
VAR CHARACTER cErrorMessage = "".
VAR LOGICAL isValid = TRUE.

IF lFound THEN DO:
    FIND FIRST ttCustomer NO-ERROR.
    IF AVAILABLE ttCustomer THEN DO:
        /* Enable change tracking */
        TEMP-TABLE ttCustomer:TRACKING-CHANGES = TRUE.
        
        /* Modify data */
        ttCustomer.Name = CustomerName.
        
        /* Validate */
        isValid = objCustomerEntity:ValidateCustomer(DATASET dsCustomer BY-REFERENCE, OUTPUT cErrorMessage).
        
        IF isValid THEN
            objCustomerEntity:UpdateCustomer(DATASET dsCustomer BY-REFERENCE).
        ELSE
            MESSAGE cErrorMessage VIEW-AS ALERT-BOX.
    END.
END.
```

## Benefits

1. **Separation of Concerns**: UI, business logic, and data access are clearly separated
2. **Reusability**: Entities can be used by multiple UI components
3. **Testability**: Business logic can be tested independently
4. **Maintainability**: Changes to business rules are centralized
5. **Consistency**: Single source of truth for data operations
6. **Change Tracking**: Efficient updates with before-tables

## Best Practices

- Always use buffers for database access
- Enable change tracking before modifying temp-tables for updates
- Validate data before calling Create/Update methods
- Use factory singleton for entity management
- Keep UI logic separate from business logic
- Pass datasets BY-REFERENCE for Create/Update/Delete operations
- Use OUTPUT (not BY-REFERENCE) for Read operations
