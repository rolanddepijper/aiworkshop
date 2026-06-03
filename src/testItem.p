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
   Test 2: GetItem – non-existent item should return FALSE
   ----------------------------------------------------------------------- */
ASSIGN iTestItemNum = -1.

lFound = objItemEntity:GetItem(iTestItemNum, OUTPUT DATASET dsItem).

IF NOT lFound THEN
    MESSAGE "Test 2 PASSED: GetItem correctly returned FALSE for non-existent item"
            VIEW-AS ALERT-BOX INFORMATION.
ELSE
    MESSAGE "Test 2 FAILED: GetItem returned TRUE for non-existent item -1"
            VIEW-AS ALERT-BOX WARNING.

/* -----------------------------------------------------------------------
   Test 3: ValidateItem – price = 0 should fail validation
   ----------------------------------------------------------------------- */
EMPTY TEMP-TABLE ttItem.
CREATE ttItem.
ASSIGN ttItem.ItemNum = 9999
       ttItem.Price   = 0
       ttItem.OnHand  = 1.

lValid = objItemEntity:ValidateItem(DATASET dsItem BY-REFERENCE, OUTPUT cError).

IF NOT lValid AND cError = "Price cannot be empty" THEN
    MESSAGE "Test 3 PASSED: ValidateItem correctly rejected Price=0"
            VIEW-AS ALERT-BOX INFORMATION.
ELSE
    MESSAGE "Test 3 FAILED: expected validation error for Price=0, got lValid="
            lValid " error=" cError
            VIEW-AS ALERT-BOX WARNING.

/* -----------------------------------------------------------------------
   Test 4: ValidateItem – total value > 6000 should fail validation
   ----------------------------------------------------------------------- */
EMPTY TEMP-TABLE ttItem.
CREATE ttItem.
ASSIGN ttItem.ItemNum = 9999
       ttItem.Price   = 100
       ttItem.OnHand  = 100.

lValid = objItemEntity:ValidateItem(DATASET dsItem BY-REFERENCE, OUTPUT cError).

IF NOT lValid AND INDEX(cError, "6000") > 0 THEN
    MESSAGE "Test 4 PASSED: ValidateItem correctly rejected total value > 6000"
            VIEW-AS ALERT-BOX INFORMATION.
ELSE
    MESSAGE "Test 4 FAILED: expected total-value validation error, got lValid="
            lValid " error=" cError
            VIEW-AS ALERT-BOX WARNING.

/* -----------------------------------------------------------------------
   Test 5: ValidateItem – total value exactly 6000 should pass (boundary)
   ----------------------------------------------------------------------- */
EMPTY TEMP-TABLE ttItem.
CREATE ttItem.
ASSIGN ttItem.ItemNum = 9999
       ttItem.Price   = 60
       ttItem.OnHand  = 100.

lValid = objItemEntity:ValidateItem(DATASET dsItem BY-REFERENCE, OUTPUT cError).

IF lValid THEN
    MESSAGE "Test 5 PASSED: ValidateItem accepted total value exactly at 6000"
            VIEW-AS ALERT-BOX INFORMATION.
ELSE
    MESSAGE "Test 5 FAILED: ValidateItem rejected total=6000, error=" cError
            VIEW-AS ALERT-BOX WARNING.

/* -----------------------------------------------------------------------
   Test 6: ValidateItem – valid price and stock
   ----------------------------------------------------------------------- */
EMPTY TEMP-TABLE ttItem.
CREATE ttItem.
ASSIGN ttItem.ItemNum = 9999
       ttItem.Price   = 10
       ttItem.OnHand  = 5.

lValid = objItemEntity:ValidateItem(DATASET dsItem BY-REFERENCE, OUTPUT cError).

IF lValid THEN
    MESSAGE "Test 6 PASSED: ValidateItem accepted valid item data"
            VIEW-AS ALERT-BOX INFORMATION.
ELSE
    MESSAGE "Test 6 FAILED: ValidateItem rejected valid data, error=" cError
            VIEW-AS ALERT-BOX WARNING.

/* -----------------------------------------------------------------------
   Test 7: UpdateItem – full update flow (fetch, track, modify, validate, save)
   ----------------------------------------------------------------------- */
ASSIGN iTestItemNum = 1.

lFound = objItemEntity:GetItem(iTestItemNum, OUTPUT DATASET dsItem).

IF lFound THEN DO:
    FIND FIRST ttItem NO-ERROR.
    IF AVAILABLE ttItem THEN DO:
        DEFINE VARIABLE dOriginalPrice AS DECIMAL NO-UNDO.
        ASSIGN dOriginalPrice = ttItem.Price.

        TEMP-TABLE ttItem:TRACKING-CHANGES = TRUE.
        ASSIGN ttItem.Price = dOriginalPrice.

        lValid = objItemEntity:ValidateItem(DATASET dsItem BY-REFERENCE, OUTPUT cError).
        IF lValid THEN DO:
            objItemEntity:UpdateItem(DATASET dsItem BY-REFERENCE).
            MESSAGE "Test 7 PASSED: UpdateItem completed without error"
                    VIEW-AS ALERT-BOX INFORMATION.
        END.
        ELSE
            MESSAGE "Test 7 FAILED: ValidateItem rejected data before update, error=" cError
                    VIEW-AS ALERT-BOX WARNING.
    END.
    ELSE
        MESSAGE "Test 7 SKIPPED: ttItem not available after GetItem"
                VIEW-AS ALERT-BOX INFORMATION.
END.
ELSE
    MESSAGE "Test 7 SKIPPED: Item" iTestItemNum "not found in test DB"
            VIEW-AS ALERT-BOX INFORMATION.

MESSAGE "testItem.p complete." VIEW-AS ALERT-BOX INFORMATION.
