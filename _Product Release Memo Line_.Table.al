table 50114 "Product Release Memo Line"
{
    Caption = 'Product Release Memo Line';

    fields
    {
        field(1;"Document Type";Option)
        {
            OptionCaption = ' ,Product Release Memo';
            OptionMembers = " ", "Product Release Memo";
        }
        field(2;"Document No.";Code[20])
        {
        }
        field(3;"Line No.";Integer)
        {
        }
        field(4;Consignee;Code[50])
        {
        }
        field(5;"Customer No.";Code[20])
        {
            TableRelation = IF("Source Type"=FILTER("Sales Order"))Customer;
        }
        field(7;"Order No.";Code[20])
        {
            Editable = false;
            TableRelation = IF("Source Type"=FILTER("Sales Order"))"Sales Header"."No." WHERE("Document Type"=FILTER(Order), "Sell-to Customer No."=FIELD("Customer No."))
            ELSE IF("Source Type"=FILTER("Transfer Order"))"Transfer Header"."No.";
        }
        field(8;"Item No.";Code[10])
        {
            TableRelation = Item;

            trigger OnValidate()begin
                Item.Get("Item No.");
                Description:=Item.Description;
            end;
        }
        field(9;Description;Text[50])
        {
        }
        field(10;Transporter;Text[50])
        {
        }
        field(11;Driver;Text[30])
        {
        }
        field(12;"Qty. to Load";Decimal)
        {
            trigger OnValidate()begin
                if "Qty. to Load" > "Qty. on Order" then Error('You cannot load more than ordered');
                if "Qty. to Load" = 0 then Error('You must specify quantity to load');
                if "Qty. to Load" > "Outstanding Quantity" then Error('You can not load more than what is remaining');
            end;
        }
        field(13;"Sales Receipt No.";Code[20])
        {
            Editable = false;

            trigger OnLookup()begin
                if "Order No." <> '' then begin
                    Clear(CustLedgEntries);
                    Custledg.Reset;
                    CustLedgEntries.LookupMode(false);
                    Custledg.SetCurrentKey("Document No.");
                    Custledg.SetRange("Document No.", "Sales Receipt No.");
                    Custledg.SetRange("Customer No.", "Customer No.");
                    Custledg.FilterGroup(2);
                    CustLedgEntries.SetTableView(Custledg);
                    if ACTION::LookupOK = CustLedgEntries.RunModal then begin
                        CustLedgEntries.GetRecord(Custledg);
                    end;
                end;
            end;
        }
        field(14;"Lot No.";Code[20])
        {
            Editable = false;
        }
        field(15;"Source Type";Option)
        {
            Editable = false;
            OptionCaption = ' ,Sales Order,Transfer Order';
            OptionMembers = " ", "Sales Order", "Transfer Order";
        }
        field(16;"Qty. on Order";Decimal)
        {
            Editable = false;
        }
        field(17;"HQ Ref";Code[20])
        {
            Editable = false;
        }
        field(20;Depot;Code[20])
        {
            Editable = false;
            TableRelation = Location;
        }
        field(21;"Document Date";Date)
        {
            Editable = false;
        }
        field(22;"Location Code";Code[10])
        {
            Caption = 'Location Code';
            Editable = false;
            TableRelation = Location WHERE("Use As In-Transit"=CONST(false));
        }
        field(23;"Outstanding Quantity";Decimal)
        {
            Editable = false;
        }
        field(24;"Quantity Shipped";Decimal)
        {
            Editable = false;
        }
        field(25;"Quantity Invoiced";Decimal)
        {
            Editable = false;
        }
        field(26;"Sales Invoice No.";Code[20])
        {
            Editable = false;

            trigger OnLookup()begin
                ViewSalesInvoice;
            end;
        }
        field(27;"Payment Receipt No.";Code[20])
        {
            Caption = 'Sales Invoice Receipt No.';
            Editable = false;

            trigger OnLookup()begin
                if "Payment Receipt No." <> '' then begin
                    if "Order No." <> '' then begin
                        Clear(CustLedgEntries);
                        Custledg.Reset;
                        CustLedgEntries.LookupMode(false);
                        Custledg.SetCurrentKey("Document No.");
                        Custledg.SetRange("Document No.", "Payment Receipt No.");
                        Custledg.SetRange("Customer No.", "Customer No.");
                        Custledg.FilterGroup(2);
                        CustLedgEntries.SetTableView(Custledg);
                        if ACTION::LookupOK = CustLedgEntries.RunModal then begin
                            CustLedgEntries.GetRecord(Custledg);
                        end;
                    end;
                end;
            end;
        }
        field(28;"Everything invoiced";Boolean)
        {
            Editable = false;

            trigger OnValidate()begin
                ReleaseMemoLine.Reset;
                ReleaseMemoLine.SetRange("Document No.", Rec."Document No.");
                ReleaseMemoLine.SetRange("Document Type", Rec."Document Type");
                ReleaseMemoLine.SetRange("Everything invoiced", false);
                if not ReleaseMemoLine.FindFirst then begin
                    ReleaseMemoHeader.Get(Rec."Document Type", "Document No.");
                    ReleaseMemoHeader.Validate("Everything Invoiced", true);
                    ReleaseMemoHeader.Modify;
                end;
            end;
        }
        field(29;"Order Line No.";Integer)
        {
            Editable = false;
        }
        field(30;"Special Order Type";Option)
        {
            CalcFormula = Lookup("Sales Header"."Special Order Type" WHERE("No."=FIELD("Order No.")));
            Description = 'LAW19.00';
            Editable = false;
            FieldClass = FlowField;
            OptionCaption = ' ,Duty Free,Export,Special Product';
            OptionMembers = " ", "Duty Free", Export, "Special Product";
        }
        field(31;"Zimra Bill of Entry No.";Code[20])
        {
            CalcFormula = Lookup("Sales Header"."Zimra Bill of Entry/Ref. No." WHERE("No."=FIELD("Order No.")));
            Description = 'LAW19.00';
            Editable = false;
            FieldClass = FlowField;
        }
    }
    keys
    {
        key(Key1;"Document Type", "Document No.", "Line No.")
        {
        }
    }
    fieldgroups
    {
    }
    trigger OnDelete()var SHeader: Record "Sales Header";
    LALine: Record "Product Release Memo Line";
    begin
        LALine.Reset;
        LALine.SetRange("Document No.", Rec."Document No.");
        LALine.SetRange("Document Type", Rec."Document Type");
        LALine.SetRange("Order No.", Rec."Order No.");
        LALine.SetFilter("Line No.", '<>%1', Rec."Line No.");
        if LALine.FindFirst then begin
            repeat LALine.Delete;
            until LALine.Next = 0;
        end;
        LoadingAuthorityHeader.Get("Document Type", "Document No.");
        LoadingAuthorityHeader.TestField("Approval Status", LoadingAuthorityHeader."Approval Status"::Open);
        SHeader.Get(SHeader."Document Type"::Order, "Order No.");
        SHeader."Product Release Memo No.":='';
        SHeader.Modify;
    end;
    trigger OnInsert()begin
        LoadingAuthorityLine.Reset;
        LoadingAuthorityLine.SetRange("Document Type", "Document Type");
        LoadingAuthorityLine.SetRange("Document No.", "Document No.");
        if LoadingAuthorityLine.FindLast then "Line No.":=LoadingAuthorityLine."Line No." + 10000
        else
            "Line No.":=10000;
        LoadingAuthorityHeader.Get("Document Type", "Document No.");
        Depot:=LoadingAuthorityHeader."Initial Loading Depot";
        "Document Date":=LoadingAuthorityHeader."Document Date";
        UpdateSalesOrder;
    end;
    trigger OnModify()begin
        LoadingAuthorityHeader.Get("Document Type", "Document No.");
        LoadingAuthorityHeader.TestField("Approval Status", LoadingAuthorityHeader."Approval Status"::Open);
    end;
    var Item: Record Item;
    SalesHeader: Record "Sales Header";
    LoadingAuthorityLine: Record "Product Release Memo Line";
    LoadingAuthorityHeader: Record "Product Release Memo Header";
    CustLedgEntries: Page "Customer Ledger Entries";
    Custledg: Record "Cust. Ledger Entry";
    SalesInvoices: Page "Posted Sales Invoices";
    SalesHeaderInvoice: Record "Sales Invoice Header";
    SalesOrderPage: Page "Sales Order";
    ReleaseMemoHeader: Record "Product Release Memo Header";
    ReleaseMemoLine: Record "Product Release Memo Line";
    procedure GetSalesInvoice()begin
        Clear(SalesInvoices);
        SalesHeaderInvoice.Reset;
        SalesInvoices.LookupMode(true);
        SalesHeaderInvoice.SetRange("Sell-to Customer No.", "Customer No.");
        SalesHeaderInvoice.FilterGroup(2);
        SalesInvoices.SetTableView(SalesHeaderInvoice);
        if ACTION::LookupOK = SalesInvoices.RunModal then begin
            SalesInvoices.GetRecord(SalesHeaderInvoice);
            "Payment Receipt No.":=SalesHeaderInvoice."Receipt No.";
            "Sales Invoice No.":=SalesHeaderInvoice."No.";
        end;
        Validate("Payment Receipt No.");
        Validate("Sales Invoice No.");
    end;
    local procedure UpdateSalesOrder()var LALines: Record "Product Release Memo Line";
    SHeader: Record "Sales Header";
    begin
        ReleaseMemoLine.Reset;
        ReleaseMemoLine.SetFilter(ReleaseMemoLine."Document No.", '<>%1', Rec."Document No.");
        ReleaseMemoLine.SetRange(ReleaseMemoLine."Order No.", Rec."Order No.");
        if ReleaseMemoLine.FindFirst then Error('Sales Order No. %1 has already been assigned to Product Release Memo No %2', "Order No.", ReleaseMemoLine."Document No.");
        SHeader.Get(SHeader."Document Type"::Order, "Order No.");
        SHeader."Product Release Memo No.":="Document No.";
        SHeader.Modify;
    end;
    local procedure CheckIfValidForInsertion()var ReleaseMemoLine: Record "Product Release Memo Line";
    begin
        ReleaseMemoLine.Reset;
        ReleaseMemoLine.SetRange(ReleaseMemoLine."Document No.", Rec."Document No.");
        ReleaseMemoLine.SetRange(ReleaseMemoLine."Document Type", Rec."Document Type"::"Product Release Memo");
        ReleaseMemoLine.SetRange(ReleaseMemoLine."Order No.", Rec."Order No.");
        ReleaseMemoLine.SetRange("Order Line No.", Rec."Order Line No.");
        if ReleaseMemoLine.FindFirst then Error('Sales Order No %1 has already been picked on Product Release Memo No.', "Document No.");
    end;
    procedure DeleteLine()var SHeader: Record "Sales Header";
    begin
        if "Line No." > 0 then if Confirm(StrSubstNo('Are you sure you want to delete Line No. %1 with Sales Order No. %2.', "Line No.", "Order No."), false)then Rec.Delete(true);
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
        if ACTION::LookupOK = SalesInvoices.RunModal then begin
        end;
    end;
}
