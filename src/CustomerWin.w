&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
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

/* Include business entity classes */
USING business.CustomerEntity FROM PROPATH.
USING business.EntityFactory FROM PROPATH.

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Include dataset definitions */
{business/CustomerDataset.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS CustomerNumber CustomerName GetCustomer ~
UpdateCustomerName 
&Scoped-Define DISPLAYED-OBJECTS CustomerNumber CustomerName 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VARIABLE C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON GetCustomer 
     LABEL "Get Customer" 
     SIZE 15 BY 1.14.

DEFINE BUTTON UpdateCustomerName 
     LABEL "Save" 
     SIZE 15 BY 1.14.

DEFINE VARIABLE CustomerName AS CHARACTER FORMAT "X(256)":U 
     LABEL "Name" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE CustomerNumber AS CHARACTER FORMAT "X(256)":U 
     LABEL "CustNr" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     CustomerNumber AT ROW 2.67 COL 8 COLON-ALIGNED WIDGET-ID 4
     CustomerName AT ROW 2.67 COL 29 COLON-ALIGNED WIDGET-ID 6
     GetCustomer AT ROW 4.81 COL 10 WIDGET-ID 2
     UpdateCustomerName AT ROW 4.81 COL 31 WIDGET-ID 8
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

&Scoped-define SELF-NAME GetCustomer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL GetCustomer C-Win
ON CHOOSE OF GetCustomer IN FRAME DEFAULT-FRAME /* Get Customer */
DO:
  VAR INTEGER iCustomerNumber          = INTEGER(CustomerNumber:screen-value).
  VAR EntityFactory objFactory         = EntityFactory:GetInstance().
  VAR CustomerEntity objCustomerEntity = objFactory:GetCustomerEntity().
  VAR LOGICAL lCustomerFound           = objCustomerEntity:GetCustomerByNumber(iCustomerNumber, OUTPUT DATASET dsCustomer).
  
  IF lCustomerFound THEN DO:
    FIND FIRST ttCustomer.
    IF AVAILABLE ttCustomer THEN DO:
      CustomerName = ttCustomer.Name.
      DISPLAY CustomerName WITH FRAME {&frame-name}.
    END.
  END.
  ELSE 
    MESSAGE "Customer not found" VIEW-AS ALERT-BOX.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME UpdateCustomerName
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL UpdateCustomerName C-Win
ON CHOOSE OF UpdateCustomerName IN FRAME DEFAULT-FRAME /* Save */
DO:
  VAR INTEGER iCustomerNumber          = INTEGER(CustomerNumber:screen-value).
  VAR EntityFactory objFactory         = EntityFactory:GetInstance().
  VAR CustomerEntity objCustomerEntity = objFactory:GetCustomerEntity().
  VAR LOGICAL lCustomerFound           = objCustomerEntity:GetCustomerByNumber(iCustomerNumber, OUTPUT DATASET dsCustomer).
  VAR CHARACTER cErrorMessage          = "".
  VAR LOGICAL isValid                  = TRUE.
  
  ASSIGN CustomerName.
  
  IF lCustomerFound THEN DO:
    FIND FIRST ttCustomer NO-ERROR.
    IF AVAILABLE ttCustomer THEN DO:
      TEMP-TABLE ttCustomer:TRACKING-CHANGES = TRUE.
      ttCustomer.Name = CustomerName.
      isValid = objCustomerEntity:ValidateCustomer(DATASET dsCustomer BY-REFERENCE, OUTPUT cErrorMessage).
      IF isValid THEN
        objCustomerEntity:UpdateCustomer(DATASET dsCustomer BY-REFERENCE).
      ELSE
        MESSAGE cErrorMessage VIEW-AS ALERT-BOX.
    END.
  END.
  ELSE
    MESSAGE "Customer not found" VIEW-AS ALERT-BOX.
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
  DISPLAY CustomerNumber CustomerName 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE CustomerNumber CustomerName GetCustomer UpdateCustomerName 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
