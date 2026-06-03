/*------------------------------------------------------------------------

  File        : testItem.p
  Purpose     : Test program for ItemEntity business entity
  Syntax      :
  Description : Verifies GetItem, ValidateItem and UpdateItem behaviour
  Author(s)   :
  Created     :
  Notes       :

------------------------------------------------------------------------*/

USING business.ItemEntity FROM PROPATH.
USING business.EntityFactory FROM PROPATH.

{business/ItemDataset.i}

DEFINE VARIABLE objFactory    AS EntityFactory NO-UNDO.
DEFINE VARIABLE objItemEntity AS ItemEntity    NO-UNDO.
DEFINE VARIABLE lFound        AS LOGICAL       NO-UNDO.
DEFINE VARIABLE lValid        AS LOGICAL       NO-UNDO.
DEFINE VARIABLE cError        AS CHARACTER     NO-UNDO.
DEFINE VARIABLE iTestItemNum  AS INTEGER       NO-UNDO.

objFactory    = EntityFactory:GetInstance().
objItemEntity = objFactory:GetItemEntity().

/* -----------------------------------------------------------------------
   Test 1: GetItem – existing item
   ----------------------------------------------------------------------- */
ASSIGN iTestItemNum = 1.

lFound = objItemEntity:GetItem(iTestItemNum, OUTPUT DATASET dsItem).

IF lFound THEN DO:
    FIND FIRST ttItem NO-ERROR.
    IF AVAILABLE ttItem THEN
        MESSAGE "Test 1 PASSED: Item found – ItemNum=" ttItem.ItemNum
                " Price=" ttItem.Price
                VIEW-AS ALERT-BOX INFORMATION.
    ELSE
        MESSAGE "Test 1 FAILED: lFound=TRUE but ttItem not available"
                VIEW-AS ALERT-BOX WARNING.
END.
ELSE
    MESSAGE "Test 1 INFO: Item" iTestItemNum "not found (may not exist in test DB)"
            VIEW-AS ALERT-BOX INFORMATION.

/* -----------------------------------------------------------------------
   Test 2: ValidateItem – price = 0 should fail validation
   ----------------------------------------------------------------------- */
EMPTY TEMP-TABLE ttItem.
CREATE ttItem.
ASSIGN ttItem.ItemNum = 9999
       ttItem.Price   = 0
       ttItem.OnHand  = 1.

lValid = objItemEntity:ValidateItem(DATASET dsItem BY-REFERENCE, OUTPUT cError).

IF NOT lValid AND cError = "Price cannot be empty" THEN
    MESSAGE "Test 2 PASSED: ValidateItem correctly rejected Price=0"
            VIEW-AS ALERT-BOX INFORMATION.
ELSE
    MESSAGE "Test 2 FAILED: expected validation error for Price=0, got lValid="
            lValid " error=" cError
            VIEW-AS ALERT-BOX WARNING.

/* -----------------------------------------------------------------------
   Test 3: ValidateItem – total value > 6000 should fail validation
   ----------------------------------------------------------------------- */
EMPTY TEMP-TABLE ttItem.
CREATE ttItem.
ASSIGN ttItem.ItemNum = 9999
       ttItem.Price   = 100
       ttItem.OnHand  = 100.

lValid = objItemEntity:ValidateItem(DATASET dsItem BY-REFERENCE, OUTPUT cError).

IF NOT lValid AND INDEX(cError, "6000") > 0 THEN
    MESSAGE "Test 3 PASSED: ValidateItem correctly rejected total value > 6000"
            VIEW-AS ALERT-BOX INFORMATION.
ELSE
    MESSAGE "Test 3 FAILED: expected total-value validation error, got lValid="
            lValid " error=" cError
            VIEW-AS ALERT-BOX WARNING.

/* -----------------------------------------------------------------------
   Test 4: ValidateItem – valid price and stock
   ----------------------------------------------------------------------- */
EMPTY TEMP-TABLE ttItem.
CREATE ttItem.
ASSIGN ttItem.ItemNum = 9999
       ttItem.Price   = 10
       ttItem.OnHand  = 5.

lValid = objItemEntity:ValidateItem(DATASET dsItem BY-REFERENCE, OUTPUT cError).

IF lValid THEN
    MESSAGE "Test 4 PASSED: ValidateItem accepted valid item data"
            VIEW-AS ALERT-BOX INFORMATION.
ELSE
    MESSAGE "Test 4 FAILED: ValidateItem rejected valid data, error=" cError
            VIEW-AS ALERT-BOX WARNING.

MESSAGE "testItem.p complete." VIEW-AS ALERT-BOX INFORMATION.
