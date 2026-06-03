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

## Best Practices

- Group related methods together in the class
- Use PascalCase for method names
- Document all parameters and return values
- Include parameter validation
- Use named buffers for database access
- Implement proper error handling
- Keep methods focused on a single responsibility

## Example

```abl
/*------------------------------------------------------------------------------
    Purpose:  Returns the name of the customer with the specified ID
    Notes:    Returns an empty string if the customer is not found
    @param piCustomerId INTEGER - The ID of the customer to look up
    @return CHARACTER - The name of the customer or empty string if not found
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
    
END METHOD. /* GetCustomerName */
```
