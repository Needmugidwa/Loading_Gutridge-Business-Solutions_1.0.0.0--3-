table 50161 "Payment Line"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1;"Documnent Type";Enum "Payment Header Document Type")
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(3;"Document No.";Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5;"Line No.";Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(7;"Line Type";Enum "Payment Line Type")
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(9;"No.";Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(10;Description;Text[250])
        {
            DataClassification = ToBeClassified;
        // Editable = false;
        }
        field(13;Quantity;Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(15;"Unit Price";Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(19;"Line Amount";Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;

            trigger OnValidate()var CurrExchRate: Record "Currency Exchange Rate";
            Rate: Decimal;
            begin
                Rate:=CurrExchRate.ExchangeRate(Today, Rec."Currency Code");
                "Line Amount LCY":=CurrExchRate.ExchangeAmtFCYToLCY(Today, Rec."Currency Code", Rec."Line Amount", Rate);
            end;
        }
        field(20;"Payment SubType";Enum "Payment SubType")
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(22;"Payment Account No.";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Bank Account";
            Editable = false;
        }
        field(25;"Currency Code";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Currency;
            Editable = false;
        }
        field(28;"Line Amount LCY";Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(30;"Posting Date";Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }
    keys
    {
        key(Key1;"Documnent Type", "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }
    var myInt: Integer;
    trigger OnInsert()begin
        PaymentHeader.Get(Rec."Documnent Type", Rec."Document No.");
        Rec."Posting Date":=PaymentHeader."Posting Date";
    end;
    trigger OnModify()begin
        TestStatusOpen();
    end;
    trigger OnDelete()begin
        if Rec."Line Type" <> Rec."Line Type"::Payment then Error('Cannot Delete this Line');
    end;
    trigger OnRename()begin
    end;
    var PaymentHeader: Record "Payment Header";
    /// <summary>
 
/// TestStatusOpen. 
 
/// </summary>
 procedure TestStatusOpen()var PaymentHeader: Record "Payment Header";
    begin
        if PaymentHeader.Get(Rec."Documnent Type", Rec."Document No.")then PaymentHeader.TestField(Closed, false);
    end;
}
