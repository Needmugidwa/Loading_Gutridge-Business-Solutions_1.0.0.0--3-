codeunit 50140 "Custom Sales Functions"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Blanket Sales Order to Order", 'OnBeforeSalesOrderHeaderModify', '', false, false)]
    local procedure UpdateSalesOrder(var SalesOrderHeader: Record "Sales Header";
    BlanketOrderSalesHeader: Record "Sales Header")begin
        SalesOrderHeader."HQ Sup. Ref":=BlanketOrderSalesHeader."HQ Sup. Ref";
        SalesOrderHeader."Blanket Order No.":=BlanketOrderSalesHeader."No.";
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post", 'OnBeforeCode', '', false, false)]
    local procedure HideJnlDialog(var GenJournalLine: Record "Gen. Journal Line";
    var HideDialog: Boolean)begin
        HideDialog:=true;
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post (Yes/No)", 'OnBeforeConfirmSalesPost', '', false, false)]
    local procedure HideInvDialogOnBeforeConfirmSalesPost(var SalesHeader: Record "Sales Header";
    var HideDialog: Boolean;
    var IsHandled: Boolean;
    var DefaultOption: Integer;
    var PostAndSend: Boolean)begin
        if SalesHeader."Statutory Document" then HideDialog:=true;
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Preview", 'OnRunPreview', '', false, false)]
    local procedure HideJnlLinePreview(var Result: Boolean;
    Subscriber: Variant;
    RecVar: Variant)begin
        Result:=false;
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Blnkt Sales Ord. to Ord. (Y/N)", 'OnAfterCreateSalesOrder', '', false, false)]
    local procedure UpdateQtyRemainingBlanketOrder(var SalesHeader: Record "Sales Header";
    var SkipMessage: Boolean)var BlanketSalesOrderLine: Record "Sales Line";
    begin
        BlanketSalesOrderLine.SetRange("Document Type", BlanketSalesOrderLine."Document Type"::"Blanket Order");
        BlanketSalesOrderLine.SetRange("Document No.", SalesHeader."Blanket Order No.");
        if BlanketSalesOrderLine.FindSet()then repeat BlanketSalesOrderLine.CalcFields("Qty. On Sales Order");
                BlanketSalesOrderLine.Validate("Qty. Paid For");
                BlanketSalesOrderLine.Modify();
            until BlanketSalesOrderLine.Next() = 0;
    end;
    /// <summary>
 
/// CreateSalesQuote. 
 
/// </summary>
 
/// <param name="BlanketSalesOrder">VAR Record "Sales Header".</param>
 
/// <param name="AllServiceCharges1">Boolean.</param>
 
/// <param name="ZinaraCharges1">Boolean.</param>
 
/// <param name="PipelineCharges1">Boolean.</param>
 
/// <param name="StorageCharges1">Boolean.</param>
 
/// <param name="DutyCharges1">Boolean.</param>
 
/// <param name="StorageForeign1">Boolean.</param>
 
/// <param name="PipelineForeign1">Boolean.</param>
 procedure CreateSalesQuote(var BlanketSalesOrder: Record "Sales Header";
    AllServiceCharges1: Boolean;
    ZinaraCharges1: Boolean;
    PipelineCharges1: Boolean;
    StorageCharges1: Boolean;
    DutyCharges1: Boolean;
    StorageForeign1: Boolean;
    PipelineForeign1: Boolean)var SalesQuoteHeader: Record "Sales Header";
    SalesQuoteLine: Record "Sales Line";
    BlanketSalesOrderLine: Record "Sales Line";
    ReleaseSalesDoc: Codeunit "Release Sales Document";
    StatutoryQuotrCreatedLbl: Label 'Proforma Invoice %1 has been created. Do you want to open the created proforma invoice?';
    begin
        SalesQuoteHeader.TransferFields(BlanketSalesOrder);
        SalesQuoteHeader."Document Type":=SalesQuoteHeader."Document Type"::Quote;
        SalesQuoteHeader."No.":='';
        SalesQuoteHeader.Status:=SalesQuoteHeader.Status::Open;
        SalesQuoteHeader."Order Date":=Today;
        SalesQuoteHeader."Document Date":=Today;
        SalesQuoteHeader."Blanket Order No.":=BlanketSalesOrder."No.";
        if AllServiceCharges1 then SalesQuoteHeader.Validate("All Service Charges", AllServiceCharges1)
        else
        begin
            SalesQuoteHeader.Validate("Zinara Charges", ZinaraCharges1);
            SalesQuoteHeader.Validate("Pipeline Local Fee Charges", PipelineCharges1);
            SalesQuoteHeader.Validate("Storage and Handling - Local", StorageCharges1);
            SalesQuoteHeader.Validate("Pipeline Foreign Fee Charges", PipelineForeign1);
            SalesQuoteHeader.Validate("Storage and Handling - Foreign", StorageForeign1);
            SalesQuoteHeader.Validate("Duty Charges", DutyCharges1);
        end;
        if SalesQuoteHeader.Insert(true)then begin
            BlanketSalesOrderLine.SetRange("Document Type", BlanketSalesOrderLine."Document Type"::"Blanket Order");
            BlanketSalesOrderLine.SetRange("Document No.", BlanketSalesOrder."No.");
            BlanketSalesOrderLine.SetFilter("Statutory Qty. to Quote", '<>%1', 0);
            if BlanketSalesOrderLine.FindSet()then begin
                repeat // SalesQuoteLine.Reset();
                    SalesQuoteLine.TransferFields(BlanketSalesOrderLine);
                    SalesQuoteLine."Document Type":=SalesQuoteLine."Document Type"::Quote;
                    SalesQuoteLine."Document No.":=SalesQuoteHeader."No.";
                    // SalesQuoteLine."Line No." += 10000;
                    SalesQuoteLine.Quantity:=BlanketSalesOrderLine."Statutory Qty. to Quote";
                    SalesQuoteLine."Outstanding Quantity":=BlanketSalesOrderLine."Statutory Qty. to Quote";
                    Clear(SalesQuoteLine."Qty. to Ship");
                    SalesQuoteLine.Insert(true);
                until BlanketSalesOrderLine.Next() = 0;
                ReleaseSalesDoc.PerformManualRelease(SalesQuoteHeader);
                BlanketSalesOrderLine.ModifyAll("Statutory Qty. to Quote", 0);
                if confirm(StatutoryQuotrCreatedLbl, true, SalesQuoteHeader."No.")then Page.Run(Page::"Sales Quote", SalesQuoteHeader);
            // Message('Created');
            end
            else
                Error('Nothing to create');
        end;
    end;
    procedure PostPayment(var Rec: Record "Payment Header")var PaymentLine: Record "Payment Line";
    PaymentLine2: Record "Payment Line";
    GenJnlLine: Record "Gen. Journal Line";
    GenJnlLine1: Record "Gen. Journal Line";
    LineNo: Integer;
    BlanketSalesOrderLine: Record "Sales Line";
    SalesHeader: Record "Sales Header";
    CustomSalesFunctions: Codeunit "Custom Sales Functions";
    PaymentPost: Codeunit "Gen. Jnl.-Post";
    begin
        Rec.Testfield(Closed, false);
        Rec.CalcFields("Remaining Amount");
        // Rec.TestField("Total Amount", 0);
        if Rec."Remaining Amount" > 0 then Error('Document not fully settled');
        PaymentLine.SetRange("Documnent Type", Rec."Document Type");
        PaymentLine.SetRange("Document No.", Rec."Receipt No.");
        PaymentLine.SetRange("Line Type", PaymentLine."Line Type"::Payment);
        if PaymentLine.FindSet()then begin
            repeat GenJnlLine1.SetCurrentKey("Line No.");
                if GenJnlLine1.FindLast()then LineNo:=GenJnlLine1."Line No." + 10000
                else
                    LineNo:=10000;
                GenJnlLine.Init();
                GenJnlLine."Journal Template Name":='Payment';
                GenJnlLine."Journal Batch Name":='General';
                GenJnlLine."Line No.":=LineNo;
                GenJnlLine."Posting Date":=PaymentLine."Posting Date";
                GenJnlLine."Document Type":=GenJnlLine."Document Type"::Payment;
                GenJnlLine."Document No.":=PaymentLine."Document No.";
                GenJnlLine."External Document No.":=Rec."Blanket Order No.";
                case PaymentLine."Payment SubType" of PaymentLine."Payment SubType"::Cash: GenJnlLine."Account Type":=GenJnlLine."Account Type"::"G/L Account";
                PaymentLine."Payment SubType"::Swipe, PaymentLine."Payment SubType"::RTGS: GenJnlLine."Account Type":=GenJnlLine."Account Type"::"Bank Account";
                end;
                GenJnlLine."Account No.":=PaymentLine."Payment Account No.";
                GenJnlLine.Description:=PaymentLine.Description;
                GenJnlLine.Amount:=ABS(PaymentLine."Line Amount");
                GenJnlLine."Amount (LCY)":=Abs(PaymentLine."Line Amount LCY");
                GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::Customer;
                GenJnlLine.Validate("Bal. Account No.", Rec."Customer No.");
                GenJnlLine.Validate("Currency Code", PaymentLine."Currency Code");
                GenJnlLine.Insert();
            until PaymentLine.Next() = 0;
            PaymentPost.Run(GenJnlLine);
            SalesHeader.Get(SalesHeader."Document Type"::Quote, Rec."Source No.");
            CustomSalesFunctions.CreateSalesInvoice(SalesHeader);
            Rec.Validate(Closed, true);
            Rec.Modify();
            PaymentLine2.SetRange("Documnent Type", PaymentLine2."Documnent Type"::Payment);
            PaymentLine2.SetRange("Document No.", Rec."Receipt No.");
            PaymentLine2.SetRange("Line Type", PaymentLine2."Line Type"::Item);
            if PaymentLine2.FindSet()then begin
                repeat BlanketSalesOrderLine.SetRange("Document Type", BlanketSalesOrderLine."Document Type"::"Blanket Order");
                    BlanketSalesOrderLine.SetRange("Document No.", Rec."Blanket Order No.");
                    BlanketSalesOrderLine.SetRange(Type, BlanketSalesOrderLine.Type::Item);
                    BlanketSalesOrderLine.SetRange("No.", PaymentLine2."No.");
                    if BlanketSalesOrderLine.FindFirst()then begin
                        BlanketSalesOrderLine.Validate("Qty. Paid For", BlanketSalesOrderLine."Qty. Paid For" + PaymentLine2.Quantity);
                        BlanketSalesOrderLine.Modify();
                    end;
                until PaymentLine2.Next() = 0;
                //  Rec.SetRange("Receipt No.", Rec."Receipt No.");
                Rec.SetRecFilter();
                Report.Run(Report::"Payment Receipt", false, false, Rec);
            end;
        end;
    end;
    /// <summary>
 
/// AddPayment. 
 
/// </summary>
 
/// <param name="BlanketSalesOrder">VAR Record "Sales Header".</param>
 procedure AddPayment(var BlanketSalesOrder: Record "Sales Header")var PaymentHeader: Record "Payment Header";
    PaymentLines: Record "Payment Line";
    BlanketSalesOrderLine: Record "Sales Line";
    PaymentHeaderPage: Page "Payment Header";
    begin
        PaymentHeader.Validate("Document Type", PaymentHeader."Document Type"::Payment);
        PaymentHeader.Validate("Receipt No.", '');
        PaymentHeader.Validate("Posting Date", BlanketSalesOrder."Posting Date");
        PaymentHeader.Validate("Customer No.", BlanketSalesOrder."Sell-to Customer No.");
        PaymentHeader."Blanket Order No.":=BlanketSalesOrder."Blanket Order No.";
        PaymentHeader.Validate("Currency Code", BlanketSalesOrder."Currency Code");
        PaymentHeader.Validate("Posting Date", BlanketSalesOrder."Document Date");
        PaymentHeader."Source No.":=BlanketSalesOrder."No.";
        BlanketSalesOrderLine.SetRange("Document Type", BlanketSalesOrder."Document Type");
        BlanketSalesOrderLine.SetRange("Document No.", BlanketSalesOrder."No.");
        BlanketSalesOrderLine.SetFilter(Type, '<>%1', BlanketSalesOrderLine.Type::" ");
        if BlanketSalesOrderLine.FindSet()then if PaymentHeader.Insert(true)then begin
                repeat PaymentLines.Validate("Documnent Type", PaymentLines."Documnent Type"::Payment);
                    PaymentLines.Validate("Document No.", PaymentHeader."Receipt No.");
                    case BlanketSalesOrderLine.Type of BlanketsalesOrderLine.Type::Item: PaymentLines.Validate("Line Type", PaymentLines."Line Type"::Item);
                    BlanketsalesOrderLine.Type::"G/L Account": PaymentLines.Validate("Line Type", PaymentLines."Line Type"::"G/L Account");
                    end;
                    PaymentLines.Validate("No.", BlanketSalesOrderLine."No.");
                    PaymentLines.Validate(Description, BlanketSalesOrderLine.Description);
                    PaymentLines.Validate("Line Amount", BlanketSalesOrderLine."Line Amount");
                    PaymentLines.Validate("Line No.", BlanketSalesOrderLine."Line No.");
                    PaymentLines.Validate("Currency Code", BlanketSalesOrder."Currency Code");
                    PaymentLines.Validate(Quantity, BlanketSalesOrderLine.Quantity);
                    PaymentLines.Insert(true);
                until BlanketSalesOrderLine.Next() = 0;
            end;
        Page.Run(Page::"Payment Header", PaymentHeader);
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnBeforeModifySalesDoc', '', false, false)]
    local procedure CreateStatutories(var SalesHeader: Record "Sales Header";
    PreviewMode: Boolean;
    var IsHandled: Boolean)var StatutorySalesLine: Record "Sales Line";
    ReleaseMemoFunctions: Codeunit "Release Memo Functions";
    StatutoryDate: Date;
    begin
        if not SalesHeader."Statutory Document" then IF SalesHeader."Document Type" IN[SalesHeader."Document Type"::Order, SalesHeader."Document Type"::Invoice, SalesHeader."Document Type"::Quote]THEN BEGIN
                //>>StatutoryW18.00 >> KG
                StatutorySalesLine.RESET;
                StatutorySalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
                StatutorySalesLine.SETRANGE("Document No.", SalesHeader."No.");
                StatutorySalesLine.SETRANGE("Statutory Line", TRUE);
                IF StatutorySalesLine.FINDSET THEN StatutorySalesLine.DELETEALL(TRUE);
                StatutorySalesLine.RESET;
                StatutorySalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
                StatutorySalesLine.SETRANGE("Document No.", SalesHeader."No.");
                StatutorySalesLine.SETFILTER(Type, '%1|%2', StatutorySalesLine.Type::Item, StatutorySalesLine.Type::Statutory);
                IF StatutorySalesLine.FINDSET THEN BEGIN
                    CLEAR(ReleaseMemoFunctions);
                    StatutoryDate:=ReleaseMemoFunctions.GetSalesHeaderDate(SalesHeader); //<<StatutoryW19.00<<
                    REPEAT IF SalesHeader."All Service Charges" THEN CreateStatutoryLine(SalesHeader, 7, StatutorySalesLine."Line No.", StatutoryDate)
                        ELSE
                        BEGIN
                            IF SalesHeader."Zinara Charges" THEN CreateStatutoryLine(SalesHeader, 1, StatutorySalesLine."Line No.", StatutoryDate);
                            IF SalesHeader."Duty Charges" THEN CreateStatutoryLine(SalesHeader, 2, StatutorySalesLine."Line No.", StatutoryDate);
                            IF SalesHeader."Pipeline Local Fee Charges" THEN CreateStatutoryLine(SalesHeader, 3, StatutorySalesLine."Line No.", StatutoryDate);
                            IF SalesHeader."Storage and Handling - Local" THEN CreateStatutoryLine(SalesHeader, 4, StatutorySalesLine."Line No.", StatutoryDate);
                            IF SalesHeader."Pipeline Foreign Fee Charges" THEN CreateStatutoryLine(SalesHeader, 5, StatutorySalesLine."Line No.", StatutoryDate);
                            IF SalesHeader."Storage and Handling - Foreign" THEN CreateStatutoryLine(SalesHeader, 6, StatutorySalesLine."Line No.", StatutoryDate);
                        END;
                    UNTIL StatutorySalesLine.NEXT = 0;
                END;
            END;
    //>>Statutory---kuda-7-2-17
    end;
    procedure CreateStatutoryLine(var StatutorySalesHeader: Record "Sales Header";
    ChargeType: Option;
    SalesLineNo: Integer;
    SalesHeaderDate: Date)var SalesLine: Record "Sales Line";
    StatutorySalesLine: Record "Sales Line";
    StatutoryOblicationsSetup: Record "Statutory Obligations Setup";
    LineNo: Integer;
    StatutoryLineDescriptionText: Text;
    StatutoryLine: Record "Sales Line";
    begin
        // with StatutorySalesHeader do begin
        LineNo:=10000;
        SalesLine.Reset;
        SalesLine.SetRange("Document Type", StatutorySalesHeader."Document Type"); //<<FM replaced SalesHeader with StatutorySalesHeader
        SalesLine.SetRange("Document No.", StatutorySalesHeader."No."); //<<FM replaced SalesHeader with StatutorySalesHeader
        if SalesLine.FindLast then LineNo:=SalesLine."Line No." + 10000;
        StatutoryOblicationsSetup.Reset;
        SalesLine.Get(StatutorySalesHeader."Document Type", StatutorySalesHeader."No.", SalesLineNo);
        SalesLine.TestField(Quantity); //FM Added--- Avoid release without quantity
        if ChargeType <> 7 then begin
            StatutoryOblicationsSetup.SetRange("Charge Type", ChargeType);
        end;
        if SalesLine.Type in[SalesLine.Type::Item, SalesLine.Type::Statutory]then //<< FM Added Statutory
 StatutoryOblicationsSetup.SetRange("Product Code", SalesLine."No.");
        //>>StatutoryW19.00>>
        StatutoryOblicationsSetup.SetFilter("End Date", '%1|>=%2', 0D, SalesHeaderDate);
        StatutoryOblicationsSetup.SetRange("Start Date", 0D, SalesHeaderDate);
        //<<StatutoryW19.00<<
        StatutoryOblicationsSetup.SetRange("Currency Code", StatutorySalesHeader."Currency Code"); //<<StatutoryW20.00
        StatutoryOblicationsSetup.SetRange(Active, true);
        if StatutoryOblicationsSetup.FindSet()then begin
            StatutoryLineDescriptionText:=CopyStr('**' + SalesLine.Description + '**', 1, MaxStrLen(StatutoryLineDescriptionText));
            StatutoryLine.Reset;
            StatutoryLine.SetRange("Document Type", StatutorySalesHeader."Document Type");
            StatutoryLine.SetRange("Document No.", StatutorySalesHeader."No.");
            StatutoryLine.SetRange("Statutory Line", true);
            StatutoryLine.SetRange(Description, StatutoryLineDescriptionText);
            if not StatutoryLine.FindFirst then begin
                StatutorySalesLine.Init;
                StatutorySalesLine."Document Type":=StatutorySalesHeader."Document Type";
                StatutorySalesLine."Document No.":=StatutorySalesHeader."No.";
                StatutorySalesLine."Line No.":=LineNo;
                StatutorySalesLine.Type:=StatutorySalesLine.Type::" ";
                StatutorySalesLine.Description:=StatutoryLineDescriptionText;
                StatutorySalesLine."Statutory Line":=true;
                StatutorySalesLine.Insert(true);
                LineNo+=10000;
            end;
            repeat //StatutorySalesLine.RESET;
                StatutorySalesLine.Init;
                StatutorySalesLine."Document Type":=StatutorySalesHeader."Document Type";
                StatutorySalesLine."Document No.":=StatutorySalesHeader."No.";
                StatutorySalesLine."Line No.":=LineNo;
                StatutorySalesLine.Type:=StatutorySalesLine.Type::"G/L Account";
                StatutorySalesLine.Validate("No.", StatutoryOblicationsSetup."G/L Account No.");
                //>> DELETED >> StatutorySalesLine.VALIDATE(Quantity,SalesLine.Quantity);
                StatutorySalesLine.Validate(Quantity, SalesLine."Outstanding Quantity"); //<< NEWCODE <<
                StatutorySalesLine.Validate("Unit of Measure Code", SalesLine."Unit of Measure Code");
                StatutorySalesLine.Validate("Unit Price", StatutoryOblicationsSetup."Unit Price");
                StatutorySalesLine."Statutory Line":=true;
                StatutorySalesLine."Location Code":=SalesLine."Location Code";
                StatutorySalesLine."Statutory Item No.":=StatutoryOblicationsSetup."Product Code";
                StatutorySalesLine.Insert(true);
                LineNo+=10000;
            until StatutoryOblicationsSetup.Next = 0;
        end;
    end;
    // end;
    procedure CreateSalesInvoice(var BlanketSalesOrder: Record "Sales Header")var SalesQuoteHeader: Record "Sales Header";
    SalesQuoteLine: Record "Sales Line";
    BlanketSalesOrderLine: Record "Sales Line";
    ReleaseSalesDoc: Codeunit "Release Sales Document";
    SalesPost: Codeunit "Sales-Post (Yes/No)";
    begin
        SalesQuoteHeader.TransferFields(BlanketSalesOrder);
        SalesQuoteHeader."Document Type":=SalesQuoteHeader."Document Type"::Invoice;
        SalesQuoteHeader."No.":='';
        SalesQuoteHeader.Status:=SalesQuoteHeader.Status::Open;
        SalesQuoteHeader."Order Date":=Today;
        SalesQuoteHeader."Document Date":=Today;
        SalesQuoteHeader."Posting Date":=Today;
        SalesQuoteHeader.Validate("All Service Charges", false);
        SalesQuoteHeader.Validate("Statutory Document", true);
        if SalesQuoteHeader.Insert(true)then begin
            BlanketSalesOrderLine.SetRange("Document Type", BlanketSalesOrderLine."Document Type"::Quote);
            BlanketSalesOrderLine.SetRange("Document No.", BlanketSalesOrder."No.");
            // BlanketSalesOrderLine.SetFilter("Statutory Qty. to Quote", '<>%1', 0);
            BlanketSalesOrderLine.SetFilter(Type, '<>%1', BlanketSalesOrderLine.Type::Item);
            if BlanketSalesOrderLine.FindSet()then begin
                repeat // SalesQuoteLine.Reset();
                    SalesQuoteLine.TransferFields(BlanketSalesOrderLine);
                    SalesQuoteLine."Document Type":=SalesQuoteLine."Document Type"::Invoice;
                    SalesQuoteLine."Document No.":=SalesQuoteHeader."No.";
                    SalesQuoteLine.Validate("Qty. to Ship", BlanketSalesOrderLine.Quantity);
                    // SalesQuoteLine."Line No." += 10000;
                    // SalesQuoteLine.Quantity := BlanketSalesOrderLine."Statutory Qty. to Quote";
                    // SalesQuoteLine."Outstanding Quantity" := BlanketSalesOrderLine."Statutory Qty. to Quote";
                    // Clear(SalesQuoteLine."Qty. to Ship");
                    SalesQuoteLine.Insert(true);
                until BlanketSalesOrderLine.Next() = 0;
                ReleaseSalesDoc.PerformManualRelease(SalesQuoteHeader);
                SalesPost.Run(SalesQuoteHeader);
            // Message('Done');
            end;
        end;
    end;
    /// <summary>
 
/// TransferQuantities. 
 
/// </summary>
 
/// <param name="BlanketSalesOrder">VAR Record "Sales Header".</param>
 procedure TransferQuantities(var BlanketSalesOrder: Record "Sales Header";
    CustomerNo: Code[20])var SalesQuoteHeader: Record "Sales Header";
    SalesQuoteLine: Record "Sales Line";
    BlanketSalesOrderLine: Record "Sales Line";
    ReleaseSalesDoc: Codeunit "Release Sales Document";
    StatutoryQuotrCreatedLbl: Label 'Transferred Blanket Order %1 has been created. Do you want to open the created Order?';
    begin
        BlanketSalesOrder.TestField(Status, BlanketSalesOrder.Status::Released);
        // SalesQuoteHeader.TransferFields(BlanketSalesOrder);
        // SalesQuoteHeader."Document Type" := SalesQuoteHeader."Document Type"::"Blanket Order";
        // SalesQuoteHeader."No." := '';
        // SalesQuoteHeader.Status := SalesQuoteHeader.Status::Open;
        // SalesQuoteHeader.Validate("Sell-to Customer No.", CustomerNo);
        // SalesQuoteHeader."Order Date" := Today;
        // SalesQuoteHeader."Document Date" := Today;
        // SalesQuoteHeader."Blanket Order No." := BlanketSalesOrder."No.";
        SalesQuoteHeader."No.":='';
        SalesQuoteHeader."document type":=SalesQuoteHeader."Document Type"::"Blanket Order";
        SalesQuoteHeader.Validate("Sell-to Customer No.", CustomerNo);
        SalesQuoteHeader."HQ Sup. Ref":=BlanketSalesOrder."HQ Sup. Ref";
        SalesQuoteHeader.Validate("Order Date", Today);
        SalesQuoteHeader.validate("Blanket Order No.", BlanketSalesOrder."No.");
        // Clear(SalesQuoteHeader."HQ Sup. Ref");
        if SalesQuoteHeader.Insert(true)then begin
            BlanketSalesOrderLine.SetRange("Document Type", BlanketSalesOrderLine."Document Type"::"Blanket Order");
            BlanketSalesOrderLine.SetRange("Document No.", BlanketSalesOrder."No.");
            BlanketSalesOrderLine.SetFilter("Qty. To Transfer", '<>%1', 0);
            if BlanketSalesOrderLine.FindSet()then begin
                repeat // SalesQuoteLine.Reset();
                    // SalesQuoteLine.TransferFields(BlanketSalesOrderLine);
                    SalesQuoteLine."Document Type":=SalesQuoteLine."Document Type"::"Blanket Order";
                    SalesQuoteLine.Validate("Document No.", SalesQuoteHeader."No.");
                    // SalesQuoteLine."Line No." += 10000;
                    SalesQuoteLine.Validate(Type, BlanketSalesOrderLine.Type);
                    SalesQuoteLine.Validate("No.", BlanketSalesOrderLine."No.");
                    SalesQuoteLine.Quantity:=BlanketSalesOrderLine."Qty. To Transfer";
                    SalesQuoteLine."Outstanding Quantity":=BlanketSalesOrderLine."Qty. To Transfer";
                    SalesQuoteLine."Blanket Order No.":=BlanketSalesOrder."No.";
                    SalesQuoteLine.Insert(true);
                until BlanketSalesOrderLine.Next() = 0;
                //ReleaseSalesDoc.PerformManualRelease(SalesQuoteHeader);
                BlanketSalesOrderLine.ModifyAll("Qty. To Transfer", 0);
                if confirm(StatutoryQuotrCreatedLbl, true, SalesQuoteHeader."No.")then Page.Run(Page::"Blanket Sales Order", SalesQuoteHeader);
            // Message('Created');
            end
            else
                Error('Nothing to create');
        end;
    end;
    procedure GetUserLocationFilter(): Code[1024]var UserLocation: Record "User Location";
    FilterString: Text[1024];
    begin
        UserLocation.Reset;
        UserLocation.SetRange("User ID", UserId);
        if UserLocation.FindFirst then begin
            if UserLocation.Count = 1 then exit(UserLocation."Location Code") //<< Only Allowed to view a SINGLE Location
            else
            begin
                FilterString:=''; //<< Initialize
                FilterString:=UserLocation."Location Code";
                UserLocation.Next;
                repeat FilterString+='|' + UserLocation."Location Code";
                until UserLocation.Next = 0;
                exit(FilterString);
            end;
        end
        else
            exit(''); //<< No Filters - Meaning Not Allowed to view ANY <<
    end;
    procedure GetUserInventoryGrpFilter(): Code[1024]var UserInventoryGroup: Record "User Item Invt. Posting Grp.";
    FilterString: Text[1024];
    begin
        UserInventoryGroup.Reset;
        UserInventoryGroup.SetRange("User ID", UserId);
        if UserInventoryGroup.FindFirst then begin
            if UserInventoryGroup.Count = 1 then exit(UserInventoryGroup."Inventory Posting Group Code") //<< Only Allowed to view a SINGLE Inventory Group <<
            else
            begin
                FilterString:=''; //<< Initialize
                FilterString:=UserInventoryGroup."Inventory Posting Group Code";
                UserInventoryGroup.Next;
                repeat FilterString+='|' + UserInventoryGroup."Inventory Posting Group Code";
                until UserInventoryGroup.Next = 0;
                exit(FilterString);
            end;
        end
        else
            exit(''); //<< No Filters - Meaning Not Allowed to view ANY <<
    end;
}
