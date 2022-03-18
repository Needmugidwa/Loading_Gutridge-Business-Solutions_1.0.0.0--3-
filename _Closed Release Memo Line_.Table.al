table 50116 "Closed Release Memo Line"
{
    Caption = 'Closed Release Memo Line';

    fields
    {
        field(1;"Document Type";Option)
        {
            OptionCaption = ' ,Loading Authority';
            OptionMembers = " ", "Product Release Memo";
        }
        field(2;"Document No.";Code[20])
        {
        }
        field(3;"Line No.";Integer)
        {
        }
        field(4;Consignee;Code[20])
        {
        }
        field(5;"Customer No.";Code[20])
        {
            TableRelation = IF("Source Type"=FILTER("Sales Order"))Customer;
        }
        field(6;"HQ Ref";Code[20])
        {
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
        }
        field(13;"Sales Receipt No.";Code[20])
        {
            Editable = false;
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
        }
        field(18;"Vehicle Reg. No.";Code[20])
        {
        }
        field(19;"Vehicle Trailer Reg. No.";Code[20])
        {
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
        }
        field(24;"Quantity Shipped";Decimal)
        {
        }
        field(25;"Quantity Invoiced";Decimal)
        {
        }
        field(26;"Sales Invoice No.";Code[20])
        {
            Editable = false;
        }
        field(27;"Payment Receipt No.";Code[20])
        {
            Caption = 'Sales Invoice Receipt No.';
            Editable = false;

            trigger OnLookup()begin
                if "Payment Receipt No." <> '' then begin
                    Clear(CustLedgEntries);
                    Custledg.Reset;
                    CustLedgEntries.LookupMode(true);
                    Custledg.SetRange("Sales Invoice No.", "Sales Invoice No.");
                    Custledg.FilterGroup(2);
                    CustLedgEntries.SetTableView(Custledg);
                    if ACTION::LookupOK = CustLedgEntries.RunModal then begin
                        CustLedgEntries.GetRecord(Custledg);
                    end;
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
        key(Key2;"Item No.")
        {
        }
        key(Key3;"Customer No.", Depot, "Document Date", "Document No.", "Document Type", "Source Type")
        {
        }
    }
    fieldgroups
    {
    }
    var Item: Record Item;
    SalesHeader: Record "Sales Header";
    LoadingAuthorityLine: Record Department;
    CustLedgEntries: Page "Customer Ledger Entries";
    Custledg: Record "Cust. Ledger Entry";
}
