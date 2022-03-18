table 50113 "Product Release Memo Header"
{
    Caption = 'Product Release Memo Header';

    fields
    {
        field(1;"Document Type";Option)
        {
            OptionCaption = ' ,Product Release Memo';
            OptionMembers = " ", "Product Release Memo";
        }
        field(2;"No.";Code[20])
        {
            TableRelation = "Product Release Memo Header"."No.";
        }
        field(3;"Initial Loading Depot";Code[20])
        {
            TableRelation = Location;

            trigger OnValidate()begin
                UserSetup.Get(UserId);
                if not UserSetup."Allow Product Rel Memo Editing" then TestField("Approval Status", "Approval Status"::Open);
            end;
        }
        field(4;"Document Date";Date)
        {
            trigger OnValidate()begin
                UserSetup.Get(UserId);
                if not UserSetup."Allow Product Rel Memo Editing" then TestField("Approval Status", "Approval Status"::Open);
            end;
        }
        field(5;"No. Series";Code[20])
        {
            TableRelation = "No. Series";
        }
        field(6;"No. Printed";Integer)
        {
            Caption = 'No. Printed';
            Editable = false;
        }
        field(7;"Source Type";Option)
        {
            Editable = false;
            OptionCaption = ' ,Sales Order,Transfer Order,All';
            OptionMembers = " ", "Sales Order", "Transfer Order", All;
        }
        field(8;"HQ Ref";Code[20])
        {
        }
        field(9;"Approval Status";Option)
        {
            Editable = false;
            OptionCaption = 'Open,Pending Approval,Released';
            OptionMembers = Open, "Pending Approval", Released;

            trigger OnValidate()var LALine: Record "Product Release Memo Line";
            SalesHeader: Record "Sales Header";
            ReleaseSalesDocument: Codeunit "Release Sales Document";
            begin
                //>>>this block of code will be removed in the future as it caters for the 1st release of release memo
                LALine.Reset;
                LALine.SetRange(LALine."Document Type", "Document Type");
                LALine.SetRange("Document No.", "No.");
                if LALine.FindFirst and (LALine.Count > 1)then repeat if Modify then;
                        SalesHeader.Get(SalesHeader."Document Type"::Order, LALine."Order No.");
                        case "Approval Status" of "Approval Status"::Open: ReleaseSalesDocument.PerformManualReopen(SalesHeader);
                        "Approval Status"::Released: ReleaseSalesDocument.PerformManualRelease(SalesHeader);
                        end;
                    until LALine.Next = 0;
            //<<this block of code will be removed in the future as it caters for the 1st release of release memo
            end;
        }
        field(10;"Document No.";Code[20])
        {
            Caption = 'Sales Order No.';
            Editable = false;
            TableRelation = "Sales Header"."No." WHERE("Document Type"=CONST(Order));

            trigger OnValidate()begin
                LAHeader.Reset;
                LAHeader.SetFilter(LAHeader."No.", '<>%1', "No.");
                LAHeader.SetRange(LAHeader."Document No.", "Document No.");
                if LAHeader.FindFirst then Error('Sales Order No. %1 has already been assigned to Product Release Memo No %2', "Document No.", LAHeader."No.");
                SHeader.Get(SHeader."Document Type"::Order, "Document No.");
                SHeader."Product Release Memo No.":="No.";
                SHeader.Modify;
                if(xRec."Document No." <> Rec."Document No.") and (xRec."Document No." <> '')then begin
                    SHeader.Get(SHeader."Document Type"::Order, xRec."Document No.");
                    SHeader.Validate("Product Release Memo No.", '');
                    SHeader.Modify;
                end;
            end;
        }
        field(11;"Receipt No.";Code[20])
        {
            Caption = 'Sales Order Receipt No.';
            Editable = false;

            trigger OnLookup()begin
                if "Document No." <> '' then begin
                    Clear(CustLedgEntries);
                    Custledg.Reset;
                    CustLedgEntries.LookupMode(true);
                    Custledg.SetCurrentKey("Sales Order No.");
                    Custledg.SetRange("Sales Order No.", "Document No.");
                    Custledg.FilterGroup(2);
                    CustLedgEntries.SetTableView(Custledg);
                    if ACTION::LookupOK = CustLedgEntries.RunModal then begin
                        CustLedgEntries.GetRecord(Custledg);
                    end;
                end;
            end;
        }
        field(12;"Statutory Invoice No.";Code[20])
        {
            Editable = false;
            TableRelation = "Sales Invoice Header"."No.";
        }
        field(13;"Payment Receipt No.";Code[20])
        {
            Caption = 'Sales Invoice Receipt No.';
            Editable = false;

            trigger OnLookup()begin
                if "Payment Receipt No." <> '' then begin
                    Clear(CustLedgEntries);
                    Custledg.Reset;
                    CustLedgEntries.LookupMode(true);
                    Custledg.SetRange("Sales Invoice No.", "Statutory Invoice No.");
                    Custledg.FilterGroup(2);
                    CustLedgEntries.SetTableView(Custledg);
                    if ACTION::LookupOK = CustLedgEntries.RunModal then begin
                        CustLedgEntries.GetRecord(Custledg);
                    end;
                end;
            end;
        }
        field(14;"Total Qty to Load";Decimal)
        {
            CalcFormula = Sum("Product Release Memo Line"."Qty. to Load" WHERE("Document Type"=FIELD("Document Type"), "Document No."=FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(15;"Customer No.";Code[20])
        {
            TableRelation = Customer;

            trigger OnValidate()begin
                TestField("Approval Status", "Approval Status"::Open);
                if(xRec."Customer No." <> "Customer No.") and (xRec."Customer No." <> '')then begin
                    CalcFields("Has Lines");
                    if "Has Lines" then if Confirm('Changing Customer No. on a Product Release Memo with lines will clear the lines. Do you want to continue?', false)then ResetDocument(xRec."Customer No.")
                        else
                            "Customer No.":=xRec."Customer No.";
                end;
                Cust.Get("Customer No.");
                "Customer Name":=Cust.Name;
                Modify;
            end;
        }
        field(16;"Number of Orders";Integer)
        {
            CalcFormula = Count("Product Release Memo Line" WHERE("Document Type"=FIELD("Document Type"), "Document No."=FIELD("No.")));
            FieldClass = FlowField;
        }
        field(17;"Everything Invoiced";Boolean)
        {
        }
        field(18;"Customer Name";Text[250])
        {
            Editable = false;
        }
        field(19;"Has Lines";Boolean)
        {
            CalcFormula = Exist("Product Release Memo Line" WHERE("Document Type"=FIELD("Document Type"), "Document No."=FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50000;"Used in Sales";Boolean)
        {
            CalcFormula = Exist("Sales Invoice Header" WHERE("Loading Authority"=FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50001;"Used in Transfers";Boolean)
        {
            CalcFormula = Exist("Transfer Receipt Header" WHERE("Loading Authority No"=FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50002;"Sales Order No.";Code[20])
        {
            Editable = false;
            TableRelation = "Sales Header"."No." WHERE("Document Type"=CONST(Order));
        }
        field(50003;"Sales Order Quantity";Decimal)
        {
            CalcFormula = Sum("Sales Line".Quantity WHERE("Document Type"=CONST(Order), "Document No."=FIELD("Sales Order No."), Type=CONST(Item)));
            FieldClass = FlowField;
        }
        field(50005;"Item No.";Code[20])
        {
            CalcFormula = Lookup("Sales Line"."No." WHERE("Document Type"=CONST(Order), "Document No."=FIELD("Sales Order No."), Type=CONST(Item)));
            Editable = false;
            FieldClass = FlowField;
            TableRelation = Item;
        }
        field(50006;"Outstanding Quantity";Decimal)
        {
            CalcFormula = Sum("Sales Line"."Outstanding Quantity" WHERE("Document Type"=CONST(Order), "Document No."=FIELD("Sales Order No."), Type=CONST(Item), "Release Memo No."=FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50007;"Special Order Type";Option)
        {
            Editable = false;
            OptionCaption = ' ,Duty Free,Export,Special Product';
            OptionMembers = " ", "Duty Free", Export, "Special Product";
        }
        field(50008;"Zimra Bill of Entry/Ref. No.";Code[20])
        {
            Editable = false;
        }
        field(50009;"Release Memo Email Recipients";Text[250])
        {
            Description = 'LoadingW20.10';
        }
        field(50010;"Release Memo sent to customer";Boolean)
        {
            Description = 'LoadingW20.10';
            Editable = false;
        }
        field(50011;"Total Quantity";Decimal)
        {
            Description = 'LoadingW20.00';
        }
    }
    keys
    {
        key(Key1;"Document Type", "No.")
        {
        }
        key(Key2;"Document No.")
        {
        }
    }
    fieldgroups
    {
    }
    trigger OnDelete()var // ApprovalsMgt: Codeunit "Approvals Mgmt.";
    begin
        TestField("Approval Status", "Approval Status"::Open);
    // ApprovalsMgt.DeleteApprovalEntry(Rec);
    end;
    trigger OnInsert()begin
        SalesSetup.Get;
        if "No." = '' then begin
            TestNoSeries;
            NoSeriesMgt.InitSeries(GetNoSeriesCode, xRec."No. Series", 0D, "No.", "No. Series");
        end;
        "Document Date":=WorkDate;
        "Source Type":="Source Type"::"Sales Order";
    end;
    var NoSeriesMgt: Codeunit NoSeriesManagement;
    SalesSetup: Record "Sales & Receivables Setup";
    UserSetup: Record "User Setup";
    CustLedgEntries: Page "Customer Ledger Entries";
    Custledg: Record "Cust. Ledger Entry";
    SalesHeader: Record "Sales Header";
    SalesInvoices: Page "Sales Invoice List";
    SalesHeaderInvoice: Record "Sales Header";
    LAHeader: Record "Product Release Memo Header";
    SHeader: Record "Sales Header";
    SalesList: Page "Sales Order List";
    SHeaderList: Record "Sales Header";
    Cust: Record Customer;
    procedure AssistEdit(OldLoadAuthHeader: Record "Product Release Memo Header"): Boolean var LoadingAuthHeader: Record "Product Release Memo Header";
    OldAuthHeader: Record "Product Release Memo Header";
    begin
        // with LoadingAuthHeader do begin
        LoadingAuthHeader.Copy(Rec);
        SalesSetup.Get;
        TestNoSeries;
        if NoSeriesMgt.SelectSeries(GetNoSeriesCode, OldAuthHeader."No. Series", "No. Series")then begin
            NoSeriesMgt.SetSeries("No.");
            Rec:=LoadingAuthHeader;
            exit(true);
        end;
    end;
    // end;
    local procedure TestNoSeries(): Boolean begin
        case "Document Type" of "Document Type"::"Product Release Memo": SalesSetup.TestField("Product Release Memo Nos.");
        end;
    end;
    local procedure GetNoSeriesCode(): Code[10]begin
        case "Document Type" of "Document Type"::"Product Release Memo": exit(SalesSetup."Product Release Memo Nos.");
        end;
    end;
    procedure GetSalesInvoice()begin
        Clear(SalesInvoices);
        SalesHeaderInvoice.Reset;
        SalesInvoices.LookupMode(true);
        SalesHeaderInvoice.SetRange("Document Type", SalesHeaderInvoice."Document Type"::Invoice);
        SalesHeaderInvoice.FilterGroup(2);
        SalesInvoices.SetTableView(SalesHeaderInvoice);
        if ACTION::LookupOK = SalesInvoices.RunModal then begin
            SalesInvoices.GetRecord(SalesHeaderInvoice);
            "Payment Receipt No.":=SalesHeaderInvoice."Receipt No.";
            "Statutory Invoice No.":=SalesHeaderInvoice."No.";
        end;
        Validate("Payment Receipt No.");
        Validate("Statutory Invoice No.");
    end;
    procedure ValidateRequiredFields()begin
        TestField("Source Type");
        TestField("Approval Status", "Approval Status"::Open);
        TestField("Customer No.");
    end;
    procedure GetSalesOrder()var SalesOrderList: Page "Sales Order List";
    SHeader: Record "Sales Header";
    begin
        ValidateRequiredFields;
        Clear(SalesOrderList);
        SHeader.Reset;
        SalesOrderList.LookupMode(true);
        SHeader.SetRange("Document Type", SHeader."Document Type"::Order);
        SHeader.SetRange("Sell-to Customer No.", "Customer No.");
        SHeader.SetRange(Status, SHeader.Status::Open);
        //SHeader.SETRANGE("Product Release Memo No.", '');
        SHeader.FilterGroup(2);
        SalesOrderList.SetTableView(SHeader);
        if ACTION::LookupOK = SalesOrderList.RunModal then begin
            SalesOrderList.GetRecord(SHeader);
            SHeader.TestField("Statutory Invoice No.");
            InsertOrderLine(SHeader);
        end;
    end;
    procedure InsertOrderLine(SalesHeadr: Record "Sales Header")var ReleaseMemoLine: Record "Product Release Memo Line";
    SalesLine: Record "Sales Line";
    begin
        if SalesHeadr."Product Release Memo No." <> '' then Error('Sales Order No %1 has already been picked on Product Release Memo No. %2', SalesHeadr."No.", SalesHeadr."Product Release Memo No.");
        SalesLine.Reset;
        SalesLine.SetRange("Document Type", SalesHeadr."Document Type");
        SalesLine.SetRange("Document No.", SalesHeadr."No.");
        if SalesLine.FindSet then begin
            repeat ReleaseMemoLine.Reset;
                ReleaseMemoLine.SetRange("Document No.", "No.");
                ReleaseMemoLine.SetRange("Document Type", "Document Type"::"Product Release Memo");
                ReleaseMemoLine.SetRange("Order No.", SalesHeadr."No.");
                ReleaseMemoLine.SetRange("Order Line No.", SalesLine."Line No.");
                if ReleaseMemoLine.FindFirst then Error('Sales Order No %1 has already been picked on the current Product Release Memo No. %2.', SalesHeadr."No.", ReleaseMemoLine."Document No.");
                ReleaseMemoLine.Reset;
                ReleaseMemoLine.Init;
                ReleaseMemoLine."Document Type":="Document Type";
                ReleaseMemoLine."Document No.":="No.";
                ReleaseMemoLine."Customer No.":=SalesHeadr."Sell-to Customer No.";
                ReleaseMemoLine."Order No.":=SalesHeadr."No.";
                ReleaseMemoLine."Sales Receipt No.":=SalesHeadr."Receipt No.";
                ReleaseMemoLine."Sales Invoice No.":=SalesHeadr."Statutory Invoice No.";
                ReleaseMemoLine."Payment Receipt No.":=SalesHeadr."Receipt No.";
                ReleaseMemoLine.Validate("Item No.", SalesLine."No.");
                ReleaseMemoLine."Qty. to Load":=SalesLine."Outstanding Quantity";
                SalesLine.TestField(Quantity);
                ReleaseMemoLine."Qty. on Order":=SalesLine.Quantity;
                ReleaseMemoLine."Lot No.":='';
                ReleaseMemoLine."Source Type":=ReleaseMemoLine."Source Type"::"Sales Order";
                ReleaseMemoLine."HQ Ref":=SalesHeadr."HQ Sup. Ref";
                ReleaseMemoLine."Location Code":=SalesLine."Location Code";
                ReleaseMemoLine."Outstanding Quantity":=SalesLine."Outstanding Quantity";
                ReleaseMemoLine."Quantity Shipped":=SalesLine."Quantity Shipped";
                ReleaseMemoLine."Quantity Invoiced":=SalesLine."Quantity Invoiced";
                ReleaseMemoLine."Order Line No.":=SalesLine."Line No.";
                ReleaseMemoLine.Insert(true);
                if "Source Type" <> "Source Type"::"Sales Order" then "Source Type":="Source Type"::All;
                Modify;
            until SalesLine.Next = 0;
        end
        else
            Error('There must be at least one line on Sales Order to assign to Product Release Memo.');
    end;
    procedure ValidateOrderLines()begin
        CalcFields("Number of Orders");
        if "Number of Orders" = 0 then Error('Document must have at least one Sales Order to send for approval');
    end;
    procedure ResetDocument(CustNo: Code[20])var LALine: Record "Product Release Memo Line";
    begin
        TestField("Approval Status", "Approval Status"::Open);
        if Confirm('Are you sure you want to Reset Document ?', false)then begin
            LALine.Reset;
            LALine.SetRange("Document Type", LALine."Document Type"::"Product Release Memo");
            LALine.SetRange("Document No.", "No.");
            LALine.SetRange("Customer No.", CustNo);
            if LALine.FindSet then begin
                repeat LALine.Delete(true);
                until LALine.Next = 0;
            end;
        end;
    end;
    procedure ViewSalesInvoice()var SalesInvoices: Page "Posted Sales Invoices";
    SalesHeaderInvoice: Record "Sales Invoice Header";
    begin
        Clear(SalesInvoices);
        SalesHeaderInvoice.Reset;
        SalesInvoices.LookupMode(false);
        SalesHeaderInvoice.SetRange("Sell-to Customer No.", "Customer No.");
        SalesHeaderInvoice.SetRange("Has Statutory Balance", true);
        SalesHeaderInvoice.FilterGroup(2);
        SalesInvoices.SetTableView(SalesHeaderInvoice);
        if ACTION::LookupOK = SalesInvoices.RunModal then;
    end;
    procedure ReOpenDocument()var ReleaseMemoFunctions: Codeunit "Release Memo Functions";
    begin
        // IF "No. Printed" > 0 THEN
        //  ERROR('Printed product Release Memo can not be re-opened');
        TestField("Approval Status", "Approval Status"::Released);
        if Confirm('You are about to re-open Product Release Memo. Do you want to continue?', false)then ReleaseMemoFunctions.ReOpenLADoc(Rec);
    end;
}
