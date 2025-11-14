---
description: Add a new method to an existing ABL class
package: business.logic
---

# New Method Addition Workflow

## Package: `business.logic`

This workflow is part of the `business.logic` package, which contains core business logic components for the application. Methods added using this workflow should follow the package's conventions and standards.

## Adding a New Method to the Current ABL Class

This workflow will add a new method to the currently focused ABL class in Windsurf. You'll need to provide the following information:

1. **Method Name**: Name of the new method
2. **Return Type**: Data type the method returns (use "VOID" if none)
3. **Access Modifier**: PUBLIC, PROTECTED, or PRIVATE
4. **Parameters**: Comma-separated list of parameters in format "name AS type, ..."
5. **Method Body**: The implementation code for the method

## Interactive Steps

1. **Determine Method Name**
   - Enter a descriptive name for your method (e.g., `GetCustomerName`, `CalculateTotal`)
   - Follow ABL naming conventions (PascalCase for method names)

2. **Select Return Type**
   - Choose from common ABL data types:
     - CHARACTER: For text values
     - INTEGER: For whole numbers
     - DECIMAL: For numbers with decimal places
     - LOGICAL: For true/false values
     - HANDLE: For object handles
     - DATASET-HANDLE: For dataset handles
     - VOID: For methods that don't return a value
     - Class name: For returning object instances

3. **Select Method Access Level**
   - PUBLIC: Accessible from anywhere
   - PROTECTED: Accessible only from the class and its subclasses
   - PRIVATE: Accessible only from within the class

4. **Define Parameters**
   - Enter parameters in the format: `parameterName AS dataType`
   - Separate multiple parameters with commas
   - Example: `piCustNum AS INTEGER, pcName AS CHARACTER`
   - Leave blank if no parameters are needed

5. **Method Implementation**
   - Provide the method body code
   - Include necessary variable declarations
   - Add proper error handling
   - Document complex logic with comments

## Best Practices

- Group related methods together in the class
- Use PascalCase for method names
- Document all parameters and return values
- Include parameter validation
- Use named buffers for database access
- Implement proper error handling
- Consider thread safety for shared resources
- Keep methods focused on a single responsibility
- Use FINALLY blocks for cleanup code
- Follow the project's coding standards for variable naming and formatting

## Example

For a method that retrieves a customer's name by ID:

```abl
/*------------------------------------------------------------------------------
    Purpose:  Returns the name of the customer with the specified ID
    Notes:    Returns an empty string if the customer is not found
------------------------------------------------------------------------------*/
METHOD PROTECTED CHARACTER GetCustomerName(piCustomerId AS INTEGER):
    
    DEFINE BUFFER bCustomer FOR Customer.
    DEFINE VARIABLE cName AS CHARACTER NO-UNDO.
    
    FIND FIRST bCustomer NO-LOCK
         WHERE bCustomer.CustNum = piCustomerId
         NO-ERROR.
         
    IF AVAILABLE bCustomer THEN
        cName = bCustomer.Name.
        
    RETURN cName.
    
END METHOD.
```
