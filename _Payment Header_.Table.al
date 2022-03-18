table 50160 "Payment Header"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1;"Document Type";Enum "Payment Header Document Type")
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(3;"Receipt No.";Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;

            trigger OnValidate()begin
                if "Receipt No." <> xRec."Receipt No." then begin
                    SalesSetup.Get;
                    NoSeriesMgt.TestManual(GetNoSeriesCode);
                    "No. Series":='';
                end;
            end;
        }
        field(5;"Posting Date";Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(7;"Remaining Amount";Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Payment Line"."Line Amount LCY" where("Document No."=field("Receipt No."), "Documnent Type"=field("Document Type")));
            Editable = false;
        }
        field(8;"Customer No.";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer;
            Editable = false;
        }
        field(9;"Blanket Order No.";Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(10;"Currency Code";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Currency;
            Editable = false;
        }
        field(18;"No. Series";Code[10])
        {
            Description = 'StatutoryW19.00';
            TableRelation = "No. Series";
            Editable = false;
        }
        field(20;"Source No.";Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(25;Closed;Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }
    keys
    {
        key(PK;"Document Type", "Receipt No.")
        {
            Clustered = true;
        }
    }
    var myInt: Integer;
    trigger OnInsert()begin
        InitInsert;
    end;
    trigger OnModify()begin
    end;
    trigger OnDelete()begin
    end;
    trigger OnRename()begin
    end;
    var SalesSetup: Record "Sales & Receivables Setup";
    NoSeriesMgt: Codeunit NoSeriesManagement;
    // StatutorySetup: Record "Statutory Obligations Setup";
    procedure InitInsert()begin
        if "Receipt No." = '' then begin
            TestNoSeries;
            NoSeriesMgt.InitSeries(GetNoSeriesCode, xRec."No. Series", Today, "Receipt No.", "No. Series");
        end;
    end;
    procedure AssistEdit(OldSalesSetup: Record "Sales & Receivables Setup"): Boolean var PaymentHeader: Record "Payment Header";
    Text051: Label 'The Duty Quote %1 already exists.';
    begin
        // with SalesSetup do begin
        SalesSetup.Copy(Rec);
        SalesSetup.Get;
        TestNoSeries;
        if NoSeriesMgt.SelectSeries(GetNoSeriesCode, OldSalesSetup."Payment Nos", "No. Series")then begin
            NoSeriesMgt.SetSeries("Receipt No.");
            //IF StatutorySetup2.GET("No.") THEN
            //ERROR(Text051,LOWERCASE("No."));
            Rec:=PaymentHeader;
            exit(true);
        end;
    end;
    // end;
    local procedure TestNoSeries()begin
        SalesSetup.Get;
        SalesSetup.TestField("Payment Nos");
    end;
    local procedure GetNoSeriesCode(): Code[10]begin
        exit(SalesSetup."Payment Nos");
    end;
    procedure CheckIsAllowed(ActionToPerfom: Option Create, Delete, Modify)var UserSetup: Record "User Setup";
    begin
        if not UserSetup.Get(UserId)then Error('You must be setup first to %1 Statutory Obligations Setup', Format(ActionToPerfom));
        if not UserSetup."Allow Statutory Setup Editing" then Error('You are not llowed to %1 Statutory Obligations Setup', Format(ActionToPerfom));
    end;
}
