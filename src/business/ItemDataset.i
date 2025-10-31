/*------------------------------------------------------------------------
  File        : ItemDataset.i
  Purpose     : Dataset definition for Item entity
  Syntax      : 
  Description : 
  Author(s)   : 
  Created     : Fri Oct 31 16:15:00 CET 2025
  Notes       : 
------------------------------------------------------------------------*/

/* Define temp-table for Item */
DEFINE TEMP-TABLE ttItem BEFORE-TABLE bttItem
    FIELD ItemNum AS INTEGER LABEL "Item Num"
    FIELD ItemName AS CHARACTER LABEL "Item Name"
    FIELD Price AS DECIMAL LABEL "Price"
    FIELD OnHand AS INTEGER LABEL "On Hand"
    FIELD Allocated AS INTEGER LABEL "Allocated"
    FIELD ReOrder AS INTEGER LABEL "Re Order"
    FIELD OnOrder AS INTEGER LABEL "On Order"
    FIELD CatPage AS INTEGER LABEL "Cat Page"
    FIELD CatDescription AS CHARACTER LABEL "Cat Description"
    FIELD Category1 AS CHARACTER LABEL "Category1"
    FIELD Category2 AS CHARACTER LABEL "Category2"
    FIELD Special AS CHARACTER LABEL "Special"
    FIELD Weight AS DECIMAL LABEL "Weight"
    FIELD Minqty AS INTEGER LABEL "Minqty"
    INDEX ItemNum IS PRIMARY UNIQUE ItemNum ASCENDING.

/* Define dataset for Item */
DEFINE DATASET dsItem FOR ttItem.
