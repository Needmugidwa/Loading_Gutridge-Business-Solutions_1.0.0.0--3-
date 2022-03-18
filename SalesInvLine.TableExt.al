tableextension 50151 SalesInvLine extends "Sales Invoice Line"
{
    fields
    {
        field(50000;"Receipt No.";Code[20])
        {
        }
        field(50001;"Batch No.";Code[20])
        {
        }
        field(50002;"Loading Order No.";Code[20])
        {
            TableRelation = "Customer Discount Group";
        }
        field(50003;"Qty Ordered";Decimal)
        {
            trigger OnValidate()begin
                "Outstanding Qty":="Qty Ordered" - (Quantity + "Qty Before Invoicing");
            end;
        }
        field(50004;"Outstanding Qty";Decimal)
        {
        }
        field(50005;"Qty Before Invoicing";Decimal)
        {
        }
        field(50006;"Uplift Date";Date)
        {
            Editable = false;
        }
        field(50007;"Make Order Date";Date)
        {
        }
        field(50008;"Sales Order No.";Code[20])
        {
            TableRelation = "Sales Invoice Line"."Sales Order No.";
            ValidateTableRelation = false;
        }
        field(50010;"Statutory Line";Boolean)
        {
            Editable = false;
        }
        field(50011;"Statutory Item No.";Code[20])
        {
            Editable = false;
            TableRelation = Item;
        }
        field(50012;"Order Date";Date)
        {
            Caption = 'Order Date';
            Editable = false;
        }
        field(50013;"Fiscal VAT G/L";Boolean)
        {
            CalcFormula = Lookup("G/L Account"."Fiscal VAT" WHERE("No."=FIELD("No.")));
            FieldClass = FlowField;
        }
        field(50014;"Customer Posting Group";Code[20])
        {
            CalcFormula = Lookup(Customer."Customer Posting Group" WHERE("No."=FIELD("Sell-to Customer No.")));
            FieldClass = FlowField;

            trigger OnValidate()begin
            //"Cust. Posting Group Normal" := "Customer Posting Group";
            end;
        }
        field(50018;"Require Loading Authority";Boolean)
        {
            Editable = false;
        }
        field(50019;"Is Statutory Line";Boolean)
        {
        }
        field(50020;"Statutory Balance";Decimal)
        {
        }
        field(50021;"Statutory Qty on Order";Decimal)
        {
            Editable = true;

            trigger OnValidate()begin
                if "Statutory Qty on Order" > Quantity then Error('The quantity %1 entered exceeds the remaining quantity that can be ordered on Statutory Invoice No. %2, \' + 'acceptable maximum quantity that can be applied is %3', "Statutory Qty on Order", "Document No.", "Statutory Remaining Qty");
                Validate("Statutory Remaining Qty", Quantity - "Statutory Qty on Order");
                Modify;
            end;
        }
        field(50022;"Has Updated Qty on Order";Boolean)
        {
        }
        field(50023;"Statutory Remaining Qty";Decimal)
        {
            trigger OnValidate()begin
                if "Statutory Remaining Qty" < 0 then Error('Remaining Quantity on order can not be less than Zero on Statutory Invoice No %1 Line No. %2', "Document No.", "Line No.");
            end;
        }
        field(50025;"Does not require Statutory Inv";Boolean)
        {
            Description = 'LAW19.00';
        }
        field(50101;"Amount (LCY)";Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            Caption = 'Amount (LCY)';
            DataClassification = ToBeClassified;
        }
        field(50102;"Amount Including VAT (LCY)";Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            Caption = 'Amount Including VAT (LCY)';
            DataClassification = ToBeClassified;
        }
    }
}
