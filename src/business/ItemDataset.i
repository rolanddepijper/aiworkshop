/*------------------------------------------------------------------------
  File        : ItemDataset.i
  Purpose     : Dataset definition for Item entity
  Syntax      : 
  Description : 
  Author(s)   : 
  Created     : Thu Nov 14 15:35:00 CEST 2025
  Notes       : 
----------------------------------------------------------------------*/

/* Define temp-table for Item */
DEFINE TEMP-TABLE ttItem BEFORE-TABLE bttItem
    FIELD ItemNum AS INTEGER INITIAL "0" LABEL "Item Num"
    FIELD Price AS DECIMAL LABEL "Price"
    FIELD OnHand AS INTEGER LABEL "On Hand"
    INDEX ItemNum IS PRIMARY UNIQUE ItemNum ASCENDING.

/* Define dataset for Item */
DEFINE DATASET dsItem FOR ttItem.
