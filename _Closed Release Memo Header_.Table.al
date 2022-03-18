table 50115 "Closed Release Memo Header"
{
    Caption = 'Closed Product Release Memo';

    fields
    {
        field(1;"Document Type";Option)
        {
            OptionCaption = ' ,Product Release Memo';
            OptionMembers = " ", "Product Release Memo";
        }
        field(2;"No.";Code[20])
        {
        }
        field(3;Depot;Code[20])
        {
            TableRelation = Location;
        }
        field(4;"Document Date";Date)
        {
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
            OptionCaption = 'Open,Pending Approval,Released';
            OptionMembers = Open, "Pending Approval", Released;
        }
        field(10;"Document No.";Code[20])
        {
            Caption = 'Sales Order No.';
            Editable = false;
            TableRelation = "Sales Header"."No." WHERE("Document Type"=CONST(Order));
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
            TableRelation = "Sales Header"."No." WHERE("Document Type"=CONST(Invoice));
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
            TableRelation = Customer."No.";
        }
        field(18;"Customer Name";Text[250])
        {
            Editable = false;
        }
        field(50000;"Used in Sales";Boolean)
        {
            Editable = false;
        }
        field(50001;"Used in Transfers";Boolean)
        {
            Editable = false;
        }
        field(50002;"Sales Order No.";Code[20])
        {
            TableRelation = "Sales Header"."No." WHERE("Document Type"=CONST(Order));
        }
        field(50003;"Sales Order Quantity";Decimal)
        {
            CalcFormula = Sum("Sales Line".Quantity WHERE("Document Type"=CONST(Order), "Document No."=FIELD("Sales Order No."), Type=CONST(Item)));
            FieldClass = FlowField;
        }
        field(50005;"Item No.";Code[20])
        {
            CalcFormula = Lookup("Sales Shipment Header"."Product To Load" WHERE("Product Release Memo No."=FIELD("No.")));
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
    }
    fieldgroups
    {
    }
    var CustLedgEntries: Page "Customer Ledger Entries";
    Custledg: Record "Cust. Ledger Entry";
}
