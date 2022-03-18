codeunit 50116 "Release Memo Functions"
{
    Permissions = TableData "Sales Invoice Header"=rm,
        TableData "Sales Invoice Line"=rm,
        TableData "Product Release Memo Header"=rimd,
        TableData "Product Release Memo Line"=rimd;

    trigger OnRun()begin
    end;
    var NoWorkflowEnabledError: Label 'There is no workflow enabled.';
    HasBalance: Boolean;
    HasLinesErr: Label 'You cannot change %1 because this Order lines. You must delete the lines first to proceed';
    Text50010: Label 'Product Release Memo No. %1 has been created, do you want to open it?';
    ConfCreateReleaseMemoMsg: Label 'Are you sure you want to create a Product Release Memo for Order %1?';
    OrderHasMultiplePdtsErr: Label 'Multiple products exist on Order %1';
    MissingQtyLocationErr: Label 'You must specify Quantity to Assign and Location to proceed';
    QtyAssignedMsg: Label '%1 Litres of %2 have been assigned to %3';
    ReleaseMemoMstBePrintedMsg: Label 'Product Release Memo must be printed before proceeding to Loading';
    Text50004: Label 'The selected Statutory Invoice No. %1 has not been fully paid.';
    ConfRecreateLinesMsg: Label 'The current order already has lines, do you want to overwrite them with Statutory Invoice Lines?';
    SalesSetup: Record "Sales & Receivables Setup";
    PRMcaption: Label 'Product Release Memo ';
    NotAllowedToReAssignErr: Label 'You are not allowed to re-assign locations';
    procedure ReleaseLADoc(var ReleaseMemoHeader: Record "Product Release Memo Header")var SalesHeader: Record "Sales Header";
    begin
        ReleaseMemoHeader.VALIDATE("Approval Status", ReleaseMemoHeader."Approval Status"::Released);
        ReleaseMemoHeader.MODIFY;
        SalesHeader.GET(SalesHeader."Document Type"::Order, ReleaseMemoHeader."Sales Order No.");
        CODEUNIT.RUN(CODEUNIT::"Release Sales Document", SalesHeader); //<<Release
    end;
    procedure ReOpenLADoc(var ReleaseMemoHeader: Record "Product Release Memo Header")var SalesHeader: Record "Sales Header";
    begin
        ReleaseMemoHeader."Approval Status":=ReleaseMemoHeader."Approval Status"::Open;
        ReleaseMemoHeader.MODIFY;
        //Reopen Order.s
        SalesHeader.GET(SalesHeader."Document Type"::Order, ReleaseMemoHeader."Sales Order No.");
        SalesHeader.VALIDATE(Status, SalesHeader.Status::Open);
        SalesHeader.MODIFY;
    //<<Re-Open Order.e
    end;
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterPostGenJnlLine', '', false, false)]
    // procedure UpdatePostedSalesInvoice(GenJnlLine: Record "Gen. Journal Line")
    // var
    //     PostedSalesInvoice: Record "Sales Invoice Header";
    // begin
    //     IF (GenJnlLine."Document Type"=GenJnlLine."Document Type"::Invoice) AND
    //       (GenJnlLine."Applies-to Doc. Type" = GenJnlLine."Applies-to Doc. Type"::Invoice) AND
    //       (GenJnlLine."Applies-to Doc. No." <> '') THEN
    //         IF PostedSalesInvoice.GET(GenJnlLine."Applies-to Doc. No.") THEN BEGIN
    //           PostedSalesInvoice."Receipt No." := GenJnlLine."Document No.";
    //           PostedSalesInvoice.MODIFY;
    //         END;
    // end;
    // [EventSubscriber(ObjectType::Codeunit, codeunit::"Sales-Post", 'OnAfterPostSalesLine', '', false, false)]
    // procedure UpdateLoadingAuthorityLine(SalesHeader: Record "Sales Header";SalesLine: Record "Sales Line")
    // var
    //     LoadingAuthLine: Record "Product Release Memo Line";
    // begin
    //     //>>LAW18.00 Update Loading Authority Line
    //     IF SalesHeader."Document Type" = SalesHeader."Document Type"::Order THEN BEGIN
    //       LoadingAuthLine.RESET;
    //       LoadingAuthLine.SETRANGE(LoadingAuthLine."Document Type", LoadingAuthLine."Document Type"::"Product Release Memo");
    //       LoadingAuthLine.SETRANGE("Document No.", SalesHeader."Product Release Memo No.");
    //       LoadingAuthLine.SETRANGE("Order No.", SalesHeader."No.");
    //       LoadingAuthLine.SETRANGE("Item No.", SalesLine."No.");
    //       LoadingAuthLine.SETRANGE("Customer No.", SalesHeader."Sell-to Customer No.");
    //       IF LoadingAuthLine.FINDFIRST THEN BEGIN
    //         LoadingAuthLine."Outstanding Quantity" += SalesLine."Qty. to Ship";
    //         LoadingAuthLine."Quantity Shipped" -=  SalesLine."Qty. to Ship";
    //         LoadingAuthLine."Quantity Invoiced" -= SalesLine."Qty. to Invoice";
    //         LoadingAuthLine.MODIFY;
    //       END;
    //     END;
    //     //<<LAW18.00 Update Loading Authority Line
    // end;
    [EventSubscriber(ObjectType::Codeunit, 80, 'OnAfterPostSalesLine', '', false, false)]
    procedure UpdateStatutoryBalance(SalesHeader: Record "Sales Header";
    SalesLine: Record "Sales Line")var PostedSalesInvoiceLine: Record "Sales Invoice Line";
    PostedSalesInvoice: Record "Sales Invoice Header";
    begin
        IF SalesHeader."Statutory Invoice No." <> '' THEN BEGIN
            PostedSalesInvoice.GET(SalesHeader."Statutory Invoice No.");
            PostedSalesInvoiceLine.RESET;
            PostedSalesInvoiceLine.SETRANGE("Document No.", SalesHeader."Statutory Invoice No.");
            PostedSalesInvoiceLine.SETRANGE("Statutory Item No.", SalesLine."No.");
            PostedSalesInvoiceLine.SETRANGE("Is Statutory Line");
            IF PostedSalesInvoiceLine.FINDFIRST THEN BEGIN
                PostedSalesInvoiceLine."Statutory Balance"+=SalesLine."Qty. to Ship";
                PostedSalesInvoiceLine.MODIFY;
                PostedSalesInvoice."Has Statutory Balance":=UpdateStatutoryBalanceStatus(PostedSalesInvoice);
                PostedSalesInvoice.MODIFY;
            END;
        END;
    end;
    local procedure UpdateStatutoryBalanceStatus(PostedSalesInvoice: Record "Sales Invoice Header"): Boolean var PostedSalesInvoiceLine: Record "Sales Invoice Line";
    begin
        PostedSalesInvoiceLine.RESET;
        PostedSalesInvoiceLine.SETRANGE("Document No.", PostedSalesInvoice."No.");
        IF PostedSalesInvoiceLine.FINDFIRST THEN BEGIN
            REPEAT IF PostedSalesInvoiceLine."Statutory Balance" <> 0 THEN EXIT(TRUE);
            UNTIL PostedSalesInvoiceLine.NEXT = 0;
        END;
        EXIT(FALSE);
    end;
    procedure CheckStatutoryQuantityOnOrder(var SalesHeader: Record "Sales Header";
    var SalesLine: Record "Sales Line";
    SalesInvHeader: Record "Sales Invoice Header")var PostedSalesInvoiceLine: Record "Sales Invoice Line";
    PostedSalesInvoice: Record "Sales Invoice Header";
    salesline2: Record "Sales Line";
    TotalQty: Decimal;
    InvoiceNo: Code[20];
    begin
        IF SalesInvHeader."No." = '' THEN InvoiceNo:=SalesHeader."Statutory Invoice No."
        ELSE
            InvoiceNo:=SalesInvHeader."No.";
        IF InvoiceNo <> '' THEN BEGIN
            PostedSalesInvoice.GET(InvoiceNo);
            PostedSalesInvoiceLine.RESET;
            PostedSalesInvoiceLine.SETRANGE("Document No.", InvoiceNo);
            PostedSalesInvoiceLine.SETRANGE("Statutory Item No.", SalesLine."No.");
            PostedSalesInvoiceLine.SETRANGE("Is Statutory Line");
            PostedSalesInvoiceLine.SETRANGE(Type, PostedSalesInvoiceLine.Type::Statutory);
            IF SalesLine.MODIFY THEN;
            IF PostedSalesInvoiceLine.FINDFIRST THEN BEGIN
                salesline2.RESET;
                salesline2.SETCURRENTKEY("No.", "Statutory Invoice No.");
                salesline2.SETRANGE("No.", SalesLine."No.");
                salesline2.SETRANGE("Document Type", salesline2."Document Type"::Order);
                salesline2.SETRANGE("Statutory Invoice No.", SalesLine."Statutory Invoice No.");
                salesline2.CALCSUMS("Outstanding Quantity");
                TotalQty:=salesline2."Outstanding Quantity";
                IF TotalQty > PostedSalesInvoiceLine."Statutory Balance" THEN ERROR('Quantity entered results in exceeding available Statutory quantity by %1 for Item No %2.', TotalQty - PostedSalesInvoiceLine."Statutory Balance", SalesLine."No.");
            END;
        END;
    end;
    procedure UpdateReleaseMemoLinesForSalesOrder(SalesHeader: Record "Sales Header")var ReleaseMemoLine: Record "Product Release Memo Line";
    begin
        ReleaseMemoLine.RESET();
        ReleaseMemoLine.SETRANGE("Document Type", ReleaseMemoLine."Document Type"::"Product Release Memo");
        ReleaseMemoLine.SETRANGE("Document No.", SalesHeader."Product Release Memo No.");
        ReleaseMemoLine.SETRANGE("Customer No.", SalesHeader."Sell-to Customer No.");
        IF ReleaseMemoLine.FINDSET THEN BEGIN
            REPEAT ReleaseMemoLine.VALIDATE("Everything invoiced", TRUE);
                ReleaseMemoLine.MODIFY;
            UNTIL ReleaseMemoLine.NEXT = 0;
        END;
    end;
    procedure IsEverythingInvoiced(SalesHdr: Record "Sales Header"): Boolean var ReleaseMemoHeader: Record "Product Release Memo Header";
    begin
        ReleaseMemoHeader.GET(ReleaseMemoHeader."Document Type"::"Product Release Memo", SalesHdr."Product Release Memo No.");
        EXIT(ReleaseMemoHeader."Everything Invoiced");
    end;
    procedure GetSalesHeaderDate(StatutorySalesHeader: Record "Sales Header"): Date begin
        // WITH StatutorySalesHeader DO BEGIN
        CASE StatutorySalesHeader."Document Type" OF StatutorySalesHeader."Document Type"::Order, StatutorySalesHeader."Document Type"::Quote: BEGIN
            StatutorySalesHeader.TESTFIELD("Order Date");
            EXIT(StatutorySalesHeader."Order Date");
        END;
        StatutorySalesHeader."Document Type"::Invoice: BEGIN
            StatutorySalesHeader.TESTFIELD("Posting Date");
            EXIT(StatutorySalesHeader."Posting Date");
        END;
        END;
    END;
    // end;
    procedure CheckIsProductReleaseMemoReady(SalesHeader: Record "Sales Header";
    CalledFromLoading: Boolean)var LAHeader: Record "Product Release Memo Header";
    SalesSetup: Record "Sales & Receivables Setup";
    Text006: Label ' Product Release Memo No. %1 must be released. Current value is %2.';
    begin
        SalesSetup.GET;
        IF SalesHeader."Document Type" <> SalesHeader."Document Type"::Order THEN EXIT;
        // WITH SalesHeader DO BEGIN
        IF SalesSetup."Product Release Memo Mandatory" OR (SalesHeader."Statutory Invoice No." <> '')THEN BEGIN
            SalesHeader.TESTFIELD("Product Release Memo No.");
            LAHeader.GET(LAHeader."Document Type"::"Product Release Memo", SalesHeader."Product Release Memo No.");
            IF(LAHeader."Approval Status" <> LAHeader."Approval Status"::Released)THEN ERROR(Text006, LAHeader."No.", LAHeader."Approval Status");
            IF CalledFromLoading THEN IF LAHeader."No. Printed" = 0 THEN ERROR(ReleaseMemoMstBePrintedMsg);
        END;
    END;
    // end;
    // [EventSubscriber(ObjectType::Table, 36, 'OnBeforeValidateEvent', 'Special Order Type', false, false)]
    // procedure OnChangeSpecialOrderType(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    // var
    //     SalesLine: Record "Sales Line";
    // begin
    //     WITH Rec DO BEGIN
    //         TESTFIELD(Status, Status::Open);
    //         TESTFIELD("Document Type", "Document Type"::Order);
    //         IF SalesLinesExist THEN
    //             ERROR(HasLinesErr, FIELDCAPTION("Special Order Type"));
    //     END;
    // end;
    [EventSubscriber(ObjectType::Codeunit, 80, 'OnBeforePostSalesDoc', '', false, false)]
    procedure BeforePostOrderCheckStatutoryRequirements(var SalesHeader: Record "Sales Header")var SalesSetup: Record "Sales & Receivables Setup";
    begin
        IF(SalesHeader."Document Type" = SalesHeader."Document Type"::Order) AND SalesHeader.Ship THEN BEGIN
            SalesSetup.GET;
            IF SalesSetup."Product Release Memo Mandatory" THEN SalesHeader.TESTFIELD("Product Release Memo No.");
            IF SalesHeader."Special Order Type" IN[SalesHeader."Special Order Type"::Export, SalesHeader."Special Order Type"::"Duty Free"]THEN SalesHeader.TESTFIELD("Zimra Bill of Entry/Ref. No.");
        END;
    end;
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterApplyCustPayment', '', false, false)]
    // local procedure UpdatePostedInvoiceWithApplicationReceipt(GenJnlLine: Record "Gen. Journal Line";CustLedgerEntry: Record "Cust. Ledger Entry")
    // var
    //     SalesInvHeader: Record "Sales Invoice Header";
    // begin
    //     IF GenJnlLine."Document Type"=GenJnlLine."Document Type"::Invoice THEN BEGIN
    //       IF SalesInvHeader.GET(GenJnlLine."Document No.") THEN BEGIN
    //         SalesInvHeader."Receipt No.":=CustLedgerEntry."Document No.";
    //         SalesInvHeader.MODIFY;
    //       END;
    //     END ELSE BEGIN
    //       IF SalesInvHeader.GET(CustLedgerEntry."Document No.") THEN BEGIN
    //         SalesInvHeader."Receipt No.":=GenJnlLine."Document No.";
    //         SalesInvHeader.MODIFY;
    //       END;
    //     END;
    // end;
    // procedure CreateNewReleaseMemo(SalesHeader: Record "Sales Header")
    // var
    //     ReleaseMemoHeader: Record "Product Release Memo Header";
    //     SalesLine: Record "Sales Line";
    //     Customer: Record Customer;
    // begin
    //     SalesHeader.CALCFIELDS("Total Item Qty");
    //     SalesHeader.TESTFIELD("Total Item Qty");
    //     IF NOT CONFIRM(ConfCreateReleaseMemoMsg, TRUE, SalesHeader."No.") THEN
    //         EXIT;
    //     ReleaseMemoHeader.INIT;
    //     ReleaseMemoHeader."Document Type" := ReleaseMemoHeader."Document Type"::"Product Release Memo";
    //     ReleaseMemoHeader."No." := '';
    //     ReleaseMemoHeader.INSERT(TRUE);
    //     ReleaseMemoHeader.VALIDATE("Customer No.", SalesHeader."Sell-to Customer No.");
    //     ReleaseMemoHeader."Sales Order No." := SalesHeader."No.";
    //     ReleaseMemoHeader."Statutory Invoice No." := SalesHeader."Statutory Invoice No.";
    //     ReleaseMemoHeader."Receipt No." := SalesHeader."Receipt No.";
    //     ReleaseMemoHeader."Special Order Type" := SalesHeader."Special Order Type";
    //     ReleaseMemoHeader."Zimra Bill of Entry/Ref. No." := SalesHeader."Zimra Bill of Entry/Ref. No.";
    //     Customer.GET(ReleaseMemoHeader."Customer No.");
    //     ReleaseMemoHeader."Release Memo Email Recipients" := Customer."E-Mail";
    //     ReleaseMemoHeader.MODIFY;
    //     ReleaseMemoHeader.InsertOrderLine(SalesHeader);
    //     CheckOrderHasMultipleProducts(ReleaseMemoHeader);
    //     SalesLine.RESET;
    //     SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
    //     SalesLine.SETRANGE("Document No.", SalesHeader."No.");
    //     SalesLine.SETRANGE(Type, SalesLine.Type::Item);
    //     SalesLine.MODIFYALL("Release Memo No.", ReleaseMemoHeader."No.");
    //     IF CONFIRM(STRSUBSTNO(Text50010, ReleaseMemoHeader."No."), TRUE) THEN;
    //     // PAGE.RUN(PAGE::Page50023, ReleaseMemoHeader);
    // end;
    // procedure CheckOrderHasMultipleProducts(ReleaseMemoHeader: Record "Product Release Memo Header")
    // var
    //     SalesLine: Record "Sales Line";
    // begin
    //     // WITH ReleaseMemoHeader DO BEGIN
    //         ReleaseMemoHeader.CALCFIELDS("Item No.");
    //         IF (ReleaseMemoHeader."Sales Order No." = '') OR (ReleaseMemoHeader."Item No." = '') THEN
    //             EXIT;
    //         SalesLine.RESET;
    //         SalesLine.SETRANGE("Document Type", SalesLine."Document Type"::Order);
    //         SalesLine.SETRANGE("Document No.", ReleaseMemoHeader."No.");
    //         SalesLine.SETRANGE(Type, SalesLine.Type::Item);
    //         SalesLine.SETFILTER("No.", '<>%1|<>%2', '', "Item No.");
    //         IF SalesLine.FINDFIRST THEN
    //             ERROR(OrderHasMultiplePdtsErr, "Sales Order No.");
    //     END;
    // end;
    // procedure ReAssignOrder(ProductReleaseMemo: Record "Product Release Memo Header")
    // var
    //     // ReAssignOrderPage: Page Page50031;
    //     QtyToAssign: Decimal;
    //     ToLocationCode: Code[10];
    //     SalesLine: Record "Sales Line";
    //     QtyRemainingToAssign: Decimal;
    //     SalesLine2: Record "Sales Line";
    //     LineNo: Integer;
    //     QtyAssigned: Decimal;
    //     TempQtyToAssign: Decimal;
    //     UserSetup: Record "User Setup";
    // begin
    //     IF NOT UserSetup.GET(USERID) OR NOT UserSetup."Allow PRM Re-assign location" THEN
    //         ERROR(NotAllowedToReAssignErr);
    //     ProductReleaseMemo.TESTFIELD("No.");
    //     ProductReleaseMemo.TESTFIELD("Sales Order No.");
    //     CheckOrderHasMultipleProducts(ProductReleaseMemo);
    //     ProductReleaseMemo.TESTFIELD("Sales Order No.");
    //     ProductReleaseMemo.CALCFIELDS("Item No.", "Outstanding Quantity");
    //     ProductReleaseMemo.TESTFIELD("Item No.");
    //     ProductReleaseMemo.TESTFIELD("Approval Status", ProductReleaseMemo."Approval Status"::Open);
    //     ProductReleaseMemo.TESTFIELD("Outstanding Quantity");
    //     // ReAssignOrderPage.InitializePage(ProductReleaseMemo."Sales Order No.",ProductReleaseMemo."Item No.",ProductReleaseMemo."No.",ProductReleaseMemo."Outstanding Quantity");
    //     // IF ReAssignOrderPage.RUNMODAL <> ACTION::OK THEN
    //     EXIT;
    //     // ReAssignOrderPage.GetOutPutValues(QtyToAssign,ToLocationCode);
    //     IF (ToLocationCode = '') OR (QtyToAssign = 0) THEN
    //         ERROR(MissingQtyLocationErr);
    //     IF QtyToAssign > ProductReleaseMemo."Outstanding Quantity" THEN
    //         ERROR('Quantity to assign must be less than or equal to the Total Outstanding Quantity of %1', ProductReleaseMemo."Outstanding Quantity");
    //     SalesLine.RESET;
    //     SalesLine.SETRANGE("Document Type", SalesLine."Document Type"::Order);
    //     SalesLine.SETRANGE("Document No.", ProductReleaseMemo."Sales Order No.");
    //     SalesLine.SETRANGE(Type, SalesLine.Type::Item);
    //     SalesLine.SETFILTER(Quantity, '>0');
    //     SalesLine.SETFILTER("Outstanding Quantity", '>0');
    //     IF SalesLine.FINDFIRST THEN BEGIN
    //         QtyRemainingToAssign := QtyToAssign;
    //         IF QtyToAssign = ProductReleaseMemo."Sales Order Quantity" THEN BEGIN
    //             SalesLine2.RESET;
    //             SalesLine2.COPYFILTERS(SalesLine);
    //             SalesLine2.SETRANGE("Quantity Shipped", 0);
    //             IF SalesLine2.FINDFIRST THEN BEGIN
    //                 SalesLine2."Is Handled" := TRUE;
    //                 SalesLine2.VALIDATE(Quantity, QtyRemainingToAssign);
    //                 SalesLine2.VALIDATE("Location Code", ToLocationCode);
    //                 SalesLine2."Is Handled" := FALSE;
    //                 SalesLine2.MODIFY;
    //                 MESSAGE(QtyAssignedMsg, QtyRemainingToAssign, ProductReleaseMemo."Item No.", ToLocationCode);
    //                 EXIT;
    //             END;
    //         END;
    //         REPEAT
    //             TempQtyToAssign := SalesLine."Outstanding Quantity";
    //             IF TempQtyToAssign > QtyRemainingToAssign THEN BEGIN
    //                 QtyAssigned := QtyRemainingToAssign;
    //                 QtyRemainingToAssign := 0;
    //             END ELSE BEGIN
    //                 QtyRemainingToAssign -= TempQtyToAssign;
    //                 QtyAssigned := TempQtyToAssign;
    //             END;
    //             SalesLine."Is Handled" := TRUE;
    //             SalesLine.VALIDATE(Quantity, SalesLine.Quantity - QtyAssigned);
    //             SalesLine."Is Handled" := FALSE;
    //             SalesLine.MODIFY;
    //             SalesLine.NEXT;
    //         UNTIL QtyRemainingToAssign = 0;
    //         LineNo := 10000;
    //         SalesLine2.RESET;
    //         SalesLine2.SETRANGE("Document Type", SalesLine2."Document Type"::Order);
    //         SalesLine2.SETRANGE("Document No.", ProductReleaseMemo."Sales Order No.");
    //         SalesLine2.SETFILTER("Line No.", '<>0');
    //         IF SalesLine2.FINDLAST THEN
    //             LineNo += SalesLine2."Line No.";
    //         SalesLine2.INIT;
    //         SalesLine2."Document Type" := SalesLine2."Document Type"::Order;
    //         SalesLine2."Document No." := ProductReleaseMemo."Sales Order No.";
    //         SalesLine2."Line No." := LineNo;
    //         SalesLine2.Type := SalesLine2.Type::Item;
    //         SalesLine2.VALIDATE("No.", ProductReleaseMemo."Item No.");
    //         SalesLine2.VALIDATE("Location Code", ToLocationCode);
    //         SalesLine2."Is Handled" := TRUE;
    //         SalesLine2.INSERT(TRUE);
    //         SalesLine2.VALIDATE(Quantity, QtyToAssign);
    //         SalesLine2.VALIDATE("Unit Price", SalesLine."Unit Price");
    //         SalesLine2."Release Memo No." := ProductReleaseMemo."No.";
    //         SalesLine2.MODIFY;
    //         MESSAGE(QtyAssignedMsg, QtyToAssign, SalesLine2.Description, ToLocationCode);
    //     END;
    // end;
    // [EventSubscriber(ObjectType::Table, 36, 'OnAfterDeleteEvent', '', false, false)]
    // procedure CheckArchiveReleaseMemo(var Rec: Record "Sales Header"; RunTrigger: Boolean)
    // var
    //     SalesHeader2: Record "Sales Header";
    //     ReleaseMemoHeader: Record "Product Release Memo Header";
    // begin
    //     WITH Rec DO
    //         IF ("Document Type" = "Document Type"::Order) AND ("Product Release Memo No." <> '') THEN BEGIN
    //             //>>This code is to be removed in the future, it caters for old olders and release memos KG
    //             SalesHeader2.RESET;
    //             SalesHeader2.SETCURRENTKEY("Product Release Memo No.");
    //             SalesHeader2.SETRANGE("Document Type", "Document Type");
    //             SalesHeader2.SETRANGE("Product Release Memo No.", "Product Release Memo No.");
    //             SalesHeader2.SETFILTER("No.", '<>%1', "No."); //<< Exclude the current Order
    //             IF NOT SalesHeader2.FINDFIRST THEN BEGIN //<< This is the Last Order in a Batch
    //                                                      //<<This code is to be removed in the future, it caters for old olders and release memos
    //                 ReleaseMemoHeader.GET(ReleaseMemoHeader."Document Type"::"Product Release Memo", "Product Release Memo No.");
    //                 // ArchiveReleaseMemo(ReleaseMemoHeader);
    //             END;
    //         END;
    // end;
    // procedure ArchiveReleaseMemo(var ReleaseMemoHeader: Record "Product Release Memo Header")
    // var
    //     ReleaseMemoHeaderArchive: Record "Closed Release Memo Header";
    //     ReleaseMemoLine: Record "Product Release Memo Line";
    //     ReleaseMemoLineArchive: Record "Closed Release Memo Line";
    //     ApprovalsMgt1: Codeunit "Approvals Mgmt.";
    // begin
    //     WITH ReleaseMemoHeader DO BEGIN
    //         ReleaseMemoHeaderArchive.INIT;
    //         ReleaseMemoHeaderArchive.TRANSFERFIELDS(ReleaseMemoHeader);
    //         ReleaseMemoHeaderArchive.INSERT;
    //         ReleaseMemoLine.RESET;
    //         ReleaseMemoLine.SETRANGE("Document Type", "Document Type");
    //         ReleaseMemoLine.SETRANGE("Document No.", "No.");
    //         IF ReleaseMemoLine.FINDFIRST THEN
    //             REPEAT
    //                 ReleaseMemoLineArchive.INIT;
    //                 ReleaseMemoLineArchive.TRANSFERFIELDS(ReleaseMemoLine);
    //                 ReleaseMemoLineArchive.INSERT;
    //                 ReleaseMemoLine.DELETE;
    //             UNTIL ReleaseMemoLine.NEXT = 0;
    //         ApprovalsMgt1.PostApprovalEntries(ReleaseMemoHeader.RECORDID, ReleaseMemoHeaderArchive.RECORDID, ReleaseMemoHeaderArchive."No.");
    //         ApprovalsMgt1.DeleteApprovalEntry(ReleaseMemoHeader);
    //         DELETE;
    //     END;
    // end;
    // procedure CheckForUniqueExternalDocumentNo(SalesHeader: Record "Sales Header"; FromPosting: Boolean)
    // var
    //     SalesInvHeader: Record "Sales Invoice Header";
    //     SalesHeader2: Record "Sales Header";
    // begin
    //     //<< Validate Unique Ext doc number << //>>LAW18.00
    //     WITH SalesHeader DO BEGIN
    //         IF "External Document No." <> '' THEN BEGIN
    //             SalesInvHeader.RESET;
    //             SalesInvHeader.SETCURRENTKEY("External Document No.");
    //             SalesInvHeader.SETRANGE("External Document No.", "External Document No.");
    //             SalesInvHeader.SETFILTER(SalesInvHeader."Order No.", '<>%1', "No."); //FM Added
    //             IF NOT SalesInvHeader.ISEMPTY THEN
    //                 ERROR('External Document No. %1 has already been used on Sales Invoice No. %2 with Sales Order No. %3', "External Document No.",
    //                       SalesInvHeader."No.", SalesInvHeader."Order No.");
    //         END;
    //         IF NOT FromPosting THEN BEGIN
    //             SalesHeader.RESET;
    //             SalesHeader.SETRANGE("Document Type", SalesHeader."Document Type"::Order);
    //             SalesHeader.SETRANGE("External Document No.", "External Document No.");
    //             SalesHeader.SETFILTER("No.", '<>%1', "No.");
    //             IF SalesHeader.FINDFIRST THEN
    //                 ERROR('External Document No. has already been used in Sales Order No. %1', SalesHeader."No.");
    //         END;
    //     END;
    //     //<< Validate Unique Ext doc number << //<<LAW18.00
    // end;
    // procedure OpenReleaseMemo(var SalesHeader: Record "Sales Header")
    // var
    //     ReleaseMemoHeader: Record "Product Release Memo Header";
    //     Selection: Integer;
    //     Text000: Label '&Select from existing Product Release Memo and assign Sales Order,&Create new Product Release Memo and assign Sales Order';
    // begin
    //     WITH SalesHeader DO BEGIN
    //         IF "Special Order Type" IN ["Special Order Type"::Export, "Special Order Type"::"Duty Free"] THEN
    //             TESTFIELD("Zimra Bill of Entry/Ref. No.");
    //         IF "Special Order Type" IN ["Special Order Type"::" ", "Special Order Type"::"Duty Free"] THEN //<<LAW19.00
    //             TESTFIELD("Statutory Invoice No.");
    //         IF "Product Release Memo No." <> '' THEN BEGIN
    //             ReleaseMemoHeader.GET(ReleaseMemoHeader."Document Type"::"Product Release Memo", "Product Release Memo No.");
    //             // PAGE.RUNMODAL(PAGE::Page50023, ReleaseMemoHeader);
    //         END ELSE BEGIN
    //             //  Selection := 0;
    //             //  Selection := STRMENU(Text000,2);
    //             //  IF Selection = 0 THEN
    //             //          EXIT;
    //             //  IF Selection = 1 THEN
    //             //    LookupReleaseMemo
    //             //  ELSE
    //             CreateNewReleaseMemo(SalesHeader);
    //         END;
    //     END;
    // end;
    // procedure DettachStatutoryInvoiceFromOrder(var SalesHeader: Record "Sales Header")
    // begin
    //     WITH SalesHeader DO BEGIN
    //         TESTFIELD("Statutory Invoice No.");
    //         TESTFIELD(Status, Status::Open);
    //         TESTFIELD("Product Release Memo No.", '');
    //         IF CONFIRM('You are about to clear Statutory Invoice No. Do you want to continue?', FALSE) THEN BEGIN
    //             "Statutory Invoice No." := '';
    //             "Receipt No." := '';
    //             MODIFY;
    //         END;
    //     END;
    // end;
    // procedure GetSalesInvoice(var SalesHeader: Record "Sales Header")
    // var
    //     SalesInvoices: Page "Posted Sales Invoices";
    //     SalesHeaderInvoice: Record "Sales Invoice Header";
    // begin
    //     WITH SalesHeader DO BEGIN
    //         TESTFIELD("Product Release Memo No.", '');
    //         TESTFIELD(Status, Status::Open);
    //         TESTFIELD("Document Type", "Document Type"::Order);
    //         TESTFIELD("Sell-to Customer No.");
    //         CLEAR(SalesInvoices);
    //         SalesHeaderInvoice.RESET;
    //         SalesInvoices.LOOKUPMODE(TRUE);
    //         SalesHeaderInvoice.SETRANGE("Sell-to Customer No.", "Sell-to Customer No.");
    //         SalesHeaderInvoice.SETRANGE("Has Statutory Balance", TRUE);
    //         SalesHeaderInvoice.FILTERGROUP(2);
    //         SalesInvoices.SETTABLEVIEW(SalesHeaderInvoice);
    //         IF ACTION::LookupOK <> SalesInvoices.RUNMODAL THEN
    //             EXIT;
    //         SalesInvoices.GETRECORD(SalesHeaderInvoice);
    //         SalesHeaderInvoice.CALCFIELDS("Remaining Amount");
    //         IF SalesHeaderInvoice."Remaining Amount" > 0 THEN
    //             ERROR(Text50004, SalesHeaderInvoice."No.");
    //         CALCFIELDS("No. of Lines");
    //         IF NOT SalesHeader.SalesLinesExist THEN
    //             CreateSalesLinesFromStatutoryInvoice(SalesHeader, SalesHeaderInvoice, FALSE)
    //         ELSE
    //             IF CONFIRM(ConfRecreateLinesMsg, TRUE) THEN
    //                 CreateSalesLinesFromStatutoryInvoice(SalesHeader, SalesHeaderInvoice, TRUE);
    //         ValidateSalesLines(SalesHeaderInvoice, SalesHeader);
    //         AssignStatutoryInvoiceNo(SalesHeaderInvoice, SalesHeader);
    //     END;
    // end;
    local procedure ValidateSalesLines(SalesInvHeader: Record "Sales Invoice Header";
    var SalesHeader: Record "Sales Header")var SalesLineToCheck: Record "Sales Line";
    PostedInvoiceLine: Record "Sales Invoice Line";
    ReleaseMemo: Codeunit "Release Memo Functions";
    begin
        SalesLineToCheck.RESET;
        SalesLineToCheck.SETRANGE("Document Type", SalesHeader."Document Type");
        SalesLineToCheck.SETRANGE("Document No.", SalesHeader."No.");
        IF SalesLineToCheck.FINDSET THEN BEGIN
            REPEAT PostedInvoiceLine.RESET;
                PostedInvoiceLine.SETRANGE(PostedInvoiceLine."Document No.", SalesInvHeader."No.");
                PostedInvoiceLine.SETRANGE(PostedInvoiceLine.Type, PostedInvoiceLine.Type::Statutory);
                PostedInvoiceLine.SETRANGE(PostedInvoiceLine."Statutory Item No.", SalesLineToCheck."No.");
                IF NOT PostedInvoiceLine.FINDFIRST THEN ERROR('There is no statutory line for Item No %1 on the selected Statutory Invoice No %2.', SalesLineToCheck."No.", SalesInvHeader."No.")
                ELSE
                BEGIN
                    SalesLineToCheck."Statutory Invoice No.":=SalesInvHeader."No.";
                    ReleaseMemo.CheckStatutoryQuantityOnOrder(SalesHeader, SalesLineToCheck, SalesInvHeader);
                    SalesLineToCheck.MODIFY;
                END;
            UNTIL SalesLineToCheck.NEXT = 0;
        END;
    end;
    // local procedure AssignStatutoryInvoiceNo(SaleInvoiceHeader: Record "Sales Invoice Header"; var SalesHeader: Record "Sales Header")
    // begin
    //     WITH SalesHeader DO BEGIN
    //         VALIDATE("Receipt No.", SaleInvoiceHeader."Receipt No.");
    //         VALIDATE("Statutory Invoice No.", SaleInvoiceHeader."No.");
    //     END;
    // end;
    procedure PrintGlobalPickingSlip(Rec: Record "Product Release Memo Header")var ReleaseMemoHeader: Record "Product Release Memo Header";
    begin
        ReleaseMemoHeader:=Rec;
        ReleaseMemoHeader.TESTFIELD("Approval Status", ReleaseMemoHeader."Approval Status"::Released);
        ReleaseMemoHeader.SETRECFILTER;
    // REPORT.RUNMODAL(REPORT::Report50002,TRUE,FALSE,ReleaseMemoHeader);
    end;
    // local procedure CreateSalesLinesFromStatutoryInvoice(SalesHeader: Record "Sales Header"; SalesInvHeader: Record "Sales Invoice Header"; DeleteExistingLines: Boolean)
    // var
    //     SalesLine: Record "Sales Line";
    //     LineNo: Integer;
    //     SalesInvLine: Record "Sales Invoice Line";
    // begin
    //     IF DeleteExistingLines THEN BEGIN
    //         SalesLine.RESET;
    //         SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
    //         SalesLine.SETRANGE("Document No.", SalesHeader."No.");
    //         IF NOT SalesLine.ISEMPTY THEN
    //             SalesLine.DELETEALL(TRUE);
    //     END;
    //     LineNo := 10000;
    //     SalesInvLine.RESET;
    //     SalesInvLine.SETRANGE("Document No.", SalesInvHeader."No.");
    //     SalesInvLine.SETRANGE(Type, SalesInvLine.Type::Statutory);
    //     SalesInvLine.SETFILTER("No.", '<>%1', '');
    //     SalesInvLine.SETFILTER("Statutory Remaining Qty", '>0');
    //     IF SalesInvLine.FINDFIRST THEN
    //         REPEAT
    //             WITH SalesLine DO BEGIN
    //                 INIT;
    //                 "Document Type" := SalesHeader."Document Type";
    //                 "Document No." := SalesHeader."No.";
    //                 "Line No." := LineNo;
    //                 Type := Type::Item;
    //                 VALIDATE("No.", SalesInvLine."No.");
    //                 VALIDATE(Quantity, SalesInvLine."Statutory Remaining Qty");
    //                 INSERT(TRUE);
    //                 LineNo += 10000;
    //             END;
    //         UNTIL SalesInvLine.NEXT = 0;
    // end;
    // procedure EmailReleaseMemo(var ReleaseMemoHeader: Record "Product Release Memo Header")
    // var
    //     UserSetup: Record "User Setup";
    //     TempEmailItem: Record "Email Item";
    //     OfficeMgt: Codeunit "Office Management";
    //     IsSent: Boolean;
    //     FileName: Text;
    //     AttachmentPath: Text;
    // begin
    //     SalesSetup.GET;
    //     SalesSetup.TESTFIELD("Release Memo Email Subject");
    //     ReleaseMemoHeader.TESTFIELD("No.");
    //     ReleaseMemoHeader.TESTFIELD("Approval Status", ReleaseMemoHeader."Approval Status"::Released);
    //     ReleaseMemoHeader.TESTFIELD("Customer No.");
    //     ReleaseMemoHeader.TESTFIELD("Release Memo Email Recipients");
    //     UserSetup.GET(USERID);
    //     UserSetup.TESTFIELD("E-Mail");
    //     FileName := PRMcaption + ReleaseMemoHeader."No." + '.pdf';
    //     // AttachmentPath := TEMPORARYPATH + FileName;
    //     ReleaseMemoHeader.SETRECFILTER;
    //     // REPORT.SAVEASPDF(REPORT::Report50104,AttachmentPath,ReleaseMemoHeader);
    //     WITH TempEmailItem DO BEGIN
    //         "From Address" := UserSetup."E-Mail";
    //         "Send to" := ReleaseMemoHeader."Release Memo Email Recipients";
    //         Subject := STRSUBSTNO(SalesSetup."Release Memo Email Subject", ReleaseMemoHeader."No.");
    //         "Attachment Name" := FileName;
    //         "Attachment File Path" := AttachmentPath;
    //         SetBodyText(SalesSetup."ReleaseMemo Default Email Body");
    //         IF OfficeMgt.AttachAvailable THEN
    //             // OfficeMgt.AttachDocument("Attachment File Path","Attachment Name",GetBodyText);
    //             COMMIT;
    //         IsSent := Send(FALSE);
    //         IF IsSent AND NOT ReleaseMemoHeader."Release Memo sent to customer" THEN BEGIN
    //             ReleaseMemoHeader.GET(ReleaseMemoHeader."Document Type", ReleaseMemoHeader."No.");
    //             ReleaseMemoHeader."Release Memo sent to customer" := TRUE;
    //             ReleaseMemoHeader.MODIFY;
    //         END;
    //     END;
    // end;
    [EventSubscriber(ObjectType::Codeunit, 80, 'OnBeforePostSalesDoc', '', false, false)]
    local procedure BeforePostSalesOrder(var SalesHeader: Record "Sales Header")var ReleaseMemoHeader: Record "Product Release Memo Header";
    SalesLine: Record "Sales Line";
    begin
        IF(SalesHeader."Product Release Memo No." <> '') AND ReleaseMemoHeader.GET(ReleaseMemoHeader."Document Type"::"Product Release Memo", SalesHeader."Product Release Memo No.")THEN BEGIN
            ReleaseMemoHeader.CALCFIELDS("Sales Order Quantity");
            ReleaseMemoHeader."Total Quantity":=ReleaseMemoHeader."Sales Order Quantity";
            ReleaseMemoHeader.MODIFY;
        END;
        IF(SalesHeader."Document Type" = SalesHeader."Document Type"::Order) AND (SalesHeader."Loading Order No." <> '') AND (SalesHeader."Batch Qty Uplifted" <> 0)THEN IF SalesLine.GET(SalesHeader."Document Type", SalesHeader."No.", SalesHeader."Current Line No. to Load")THEN SalesLine.TESTFIELD("Qty. to Ship", SalesHeader."Batch Qty Uplifted");
    end;
    [EventSubscriber(ObjectType::Codeunit, 414, 'OnBeforeReopenSalesDoc', '', false, false)]
    local procedure BeforeReopenSalesOrder(var SalesHeader: Record "Sales Header")begin
        IF SalesHeader."Document Type" <> SalesHeader."Document Type"::Order THEN EXIT;
        IF SalesHeader."Product Release Memo No." <> '' THEN ERROR('This order is linked to a product release memo, you can re-open it by reopening the release memo');
    end;
}
