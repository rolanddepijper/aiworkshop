USING business.ItemEntity.
USING business.EntityFactory.

&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          sports           PROGRESS
*/
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

{business/ItemDataset.i}

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS FILL-IN_ItemNum FILL-IN_Price BUTTON-4 ~
BUTTON-3 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN_ItemNum FILL-IN_Price 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VARIABLE C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-3 
     LABEL "Get Item" 
     SIZE 15 BY 1.14.

DEFINE BUTTON BUTTON-4 
     LABEL "Save" 
     SIZE 15 BY 1.14.

DEFINE VARIABLE FILL-IN_ItemNum AS INTEGER FORMAT "zzzzzzzzz9" INITIAL 0 
     LABEL "Item Num" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN_Price AS DECIMAL FORMAT "->,>>>,>>9.99" INITIAL 0 
     LABEL "Price" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     FILL-IN_ItemNum AT ROW 2.19 COL 14 COLON-ALIGNED HELP
          "Please enter the item  number ." WIDGET-ID 4
     FILL-IN_Price AT ROW 2.19 COL 38 COLON-ALIGNED HELP
          "Please enter a Price." WIDGET-ID 8
     BUTTON-4 AT ROW 3.86 COL 39 WIDGET-ID 10
     BUTTON-3 AT ROW 4.1 COL 16 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 1 ROW 1
         SIZE 80 BY 16 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert window title>"
         HEIGHT             = 16
         WIDTH              = 80
         MAX-HEIGHT         = 16
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 16
         VIRTUAL-WIDTH      = 80
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   FRAME-NAME                                                           */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* <insert window title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* <insert window title> */
DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 C-Win
ON CHOOSE OF BUTTON-3 IN FRAME DEFAULT-FRAME /* Get Item */
DO:
  VAR EntityFactory objFactory   = EntityFactory:GetInstance().
  VAR ItemEntity    objItemEntity = objFactory:GetItemEntity().
  VAR LOGICAL       lFound        = FALSE.

  ASSIGN FILL-IN_ItemNum.
  lFound = objItemEntity:GetItem(INTEGER(FILL-IN_ItemNum), OUTPUT DATASET dsItem).
  IF lFound THEN DO:
     FIND FIRST ttItem NO-ERROR.
     IF AVAILABLE ttItem THEN DO:
         FILL-IN_Price = ttItem.Price.
         DISPLAY FILL-IN_Price WITH FRAME {&frame-name}.
     END.
  END.
  ELSE
     MESSAGE 'Item not found' VIEW-AS ALERT-BOX.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 C-Win
ON CHOOSE OF BUTTON-4 IN FRAME DEFAULT-FRAME /* Save */
DO:
  VAR EntityFactory objFactory   = EntityFactory:GetInstance().
  VAR ItemEntity    objItemEntity = objFactory:GetItemEntity().
  VAR LOGICAL       lFound        = FALSE.
  VAR LOGICAL       isValid       = FALSE.
  VAR CHARACTER     cErrorMessage = "".

  ASSIGN FILL-IN_ItemNum FILL-IN_Price.
  lFound = objItemEntity:GetItem(INTEGER(FILL-IN_ItemNum), OUTPUT DATASET dsItem).
  IF lFound THEN DO:
     FIND FIRST ttItem NO-ERROR.
     IF AVAILABLE ttItem THEN DO:
         TEMP-TABLE ttItem:TRACKING-CHANGES = TRUE.
         ASSIGN ttItem.Price = FILL-IN_Price.
         isValid = objItemEntity:ValidateItem(DATASET dsItem BY-REFERENCE, OUTPUT cErrorMessage).
         IF NOT isValid THEN DO:
             MESSAGE cErrorMessage VIEW-AS ALERT-BOX.
             RETURN NO-APPLY.
         END.
         objItemEntity:UpdateItem(DATASET dsItem BY-REFERENCE).
     END.
  END.
  ELSE
     MESSAGE 'Item not found' VIEW-AS ALERT-BOX.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

PAUSE 0 BEFORE-HIDE.

MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
PROCEDURE enable_UI :
  DISPLAY FILL-IN_ItemNum FILL-IN_Price 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE FILL-IN_ItemNum FILL-IN_Price BUTTON-4 BUTTON-3 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
