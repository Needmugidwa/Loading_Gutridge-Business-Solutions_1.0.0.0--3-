table 50112 "Statutory Obligations Setup"
{
    fields
    {
        field(1;"Product Code";Code[20])
        {
            NotBlank = true;
            TableRelation = Item;

            trigger OnValidate()begin
                TestField("Charge Type");
                Item.Get("Product Code");
                "Product Description":=Item.Description;
            end;
        }
        field(2;"G/L Account No.";Code[20])
        {
            NotBlank = true;
            TableRelation = "G/L Account";

            trigger OnValidate()begin
                GLAccount.Get("G/L Account No.");
                "G/L Account Name":=GLAccount.Name;
            end;
        }
        field(3;"Product Description";Text[50])
        {
            Editable = false;
        }
        field(4;"G/L Account Name";Text[50])
        {
            Editable = false;
        }
        field(5;"Unit Price";Decimal)
        {
            DecimalPlaces = 2: 5;
        }
        field(6;"Charge Type";Option)
        {
            OptionCaption = ' ,Zinara Charges,Duty Charges,PipeLine fees - Local,Storage & handling - Local,Service Fees,PipeLine fees - Foreign,Storage & handling - Foreign';
            OptionMembers = " ", "Zinara Charges", "Duty Charges", "PipeLine fees - Local", "Storage & handling - Local", "Service Fees", "PipeLine fees - Foreign", "Storage & handling - Foreign";
        }
        field(7;Active;Boolean)
        {
            Description = 'StatutoryW18.00';
        }
        field(8;"Code";Code[10])
        {
            Description = 'StatutoryW19.00';
            Editable = false;

            trigger OnValidate()begin
                if Code <> xRec.Code then begin
                    StatutorySetup.Get;
                    NoSeriesMgt.TestManual(GetNoSeriesCode);
                    "No. Series":='';
                end;
            end;
        }
        field(9;"No. Series";Code[10])
        {
            Description = 'StatutoryW19.00';
            TableRelation = "No. Series";
        }
        field(10;"Start Date";Date)
        {
            Description = 'StatutoryW19.00';
        }
        field(11;"End Date";Date)
        {
            Description = 'StatutoryW19.00';
        }
        field(12;"Creation Date";Date)
        {
            Description = 'StatutoryW19.00';
            Editable = false;
        }
        field(13;"Date Last Modified";DateTime)
        {
            Description = 'StatutoryW19.00';
            Editable = false;
        }
        field(14;"Modified By";Code[50])
        {
            Description = 'StatutoryW19.00';
            Editable = false;
        }
        field(15;"Currency Code";Code[10])
        {
            Description = 'StatutoryW20.00';
            TableRelation = Currency;
        }
    }
    keys
    {
        key(Key1;"Code")
        {
        }
        key(Key2;"Creation Date", "Start Date", "Product Code")
        {
        }
    }
    fieldgroups
    {
    }
    trigger OnDelete()begin
        CheckIsAllowed(1);
    end;
    trigger OnInsert()begin
        CheckIsAllowed(0);
        InitInsert;
        "Creation Date":=Today;
    end;
    trigger OnModify()begin
        CheckIsAllowed(2);
        "Modified By":=UserId;
        "Date Last Modified":=CurrentDateTime;
    end;
    var Item: Record Item;
    GLAccount: Record "G/L Account";
    SalesSetup: Record "Sales & Receivables Setup";
    NoSeriesMgt: Codeunit NoSeriesManagement;
    StatutorySetup: Record "Statutory Obligations Setup";
    procedure InitInsert()begin
        if Code = '' then begin
            TestNoSeries;
            NoSeriesMgt.InitSeries(GetNoSeriesCode, xRec."No. Series", Today, Code, "No. Series");
        end;
    end;
    procedure AssistEdit(OldStatutorySetup: Record "Statutory Obligations Setup"): Boolean var StatutorySetup2: Record "Statutory Obligations Setup";
    Text051: Label 'The Duty Quote %1 already exists.';
    begin
        // with StatutorySetup do begin
        StatutorySetup.Copy(Rec);
        SalesSetup.Get;
        TestNoSeries;
        if NoSeriesMgt.SelectSeries(GetNoSeriesCode, OldStatutorySetup."No. Series", "No. Series")then begin
            NoSeriesMgt.SetSeries(Code);
            //IF StatutorySetup2.GET("No.") THEN
            //ERROR(Text051,LOWERCASE("No."));
            Rec:=StatutorySetup;
            exit(true);
        end;
    end;
    // end;
    // 
    local procedure TestNoSeries()begin
        SalesSetup.Get;
        SalesSetup.TestField("Statutory Obligation Nos.");
    end;
    local procedure GetNoSeriesCode(): Code[10]begin
        exit(SalesSetup."Statutory Obligation Nos.");
    end;
    procedure CheckIsAllowed(ActionToPerfom: Option Create, Delete, Modify)var UserSetup: Record "User Setup";
    begin
        if not UserSetup.Get(UserId)then Error('You must be setup first to %1 Statutory Obligations Setup', Format(ActionToPerfom));
        if not UserSetup."Allow Statutory Setup Editing" then Error('You are not Allowed to %1 Statutory Obligations Setup', Format(ActionToPerfom));
    end;
}
