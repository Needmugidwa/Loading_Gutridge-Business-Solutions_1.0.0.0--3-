tableextension 50149 SalesInvHeader extends "Sales Invoice Header"
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
        }
        field(50003;"Loading Date";Date)
        {
        }
        field(50004;"Opening Meter Reading";Decimal)
        {
        }
        field(50005;"Closing Meter Reading";Decimal)
        {
        }
        field(50006;"Meter Code";Code[20])
        {
            TableRelation = "Responsibility Center";
        }
        field(50007;Loader;Code[20])
        {
            TableRelation = "Responsibility Center";
        }
        field(50008;Dipper;Code[20])
        {
            TableRelation = "Responsibility Center";
        }
        field(50009;Sealer;Code[20])
        {
            TableRelation = "Responsibility Center";
        }
        field(50010;"Transporter Name";Text[50])
        {
            NotBlank = true;
        }
        field(50011;"Horse Registration No.";Code[20])
        {
            Description = 'LoadingW20.10';
            TableRelation = "Truck Registration";
            ValidateTableRelation = false;
        }
        field(50012;"Driver Name";Text[50])
        {
        }
        field(50013;"Driver ID";Code[20])
        {
        }
        field(50014;"Batch Qty Uplifted";Decimal)
        {
        }
        field(50015;"Compartments with Dips";Decimal)
        {
        }
        field(50016;"Qty Per Compartment";Decimal)
        {
        }
        field(50017;"Quantity At 20 Degrees";Decimal)
        {
        }
        field(50018;"Conversion Factor";Decimal)
        {
        }
        field(50019;"Dip Temperature";Decimal)
        {
        }
        field(50020;"Dip Value 1";Decimal)
        {
        }
        field(50021;"Dip Value 2";Decimal)
        {
        }
        field(50022;"Dip Value 3";Decimal)
        {
        }
        field(50023;"Dip Value 4";Decimal)
        {
        }
        field(50024;"Dip Value 5";Decimal)
        {
        }
        field(50025;"Dip Value 6";Decimal)
        {
        }
        field(50026;"Dip Value 7";Decimal)
        {
        }
        field(50027;"Dip Value 8";Decimal)
        {
        }
        field(50028;"Dip Value 9";Decimal)
        {
        }
        field(50029;"Dip Value 10";Decimal)
        {
        }
        field(50030;"Dip Value 11";Decimal)
        {
        }
        field(50031;"Dip Value 12";Decimal)
        {
        }
        field(50032;"Conv Qty 1";Decimal)
        {
        }
        field(50033;"Conv Qty 2";Decimal)
        {
        }
        field(50034;"Conv Qty 3";Decimal)
        {
        }
        field(50035;"Conv Qty 4";Decimal)
        {
        }
        field(50036;"Conv Qty 5";Decimal)
        {
        }
        field(50037;"Conv Qty 6";Decimal)
        {
        }
        field(50038;"Conv Qty 7";Decimal)
        {
        }
        field(50039;"Conv Qty 8";Decimal)
        {
        }
        field(50040;"Conv Qty 9";Decimal)
        {
        }
        field(50041;"Conv Qty 10";Decimal)
        {
        }
        field(50042;"Conv Qty 11";Decimal)
        {
        }
        field(50043;"Conv Qty 12";Decimal)
        {
        }
        field(50044;AddToLines;Boolean)
        {
        }
        field(50045;AddToLinesRec;Boolean)
        {
        }
        field(50046;ApplyToAll;Boolean)
        {
        }
        field(50047;TransMode;Option)
        {
            OptionCaption = ',Road Tanker, Rail Tanker';
            OptionMembers = , "Road Tanker", " Rail Tanker";
        }
        field(50048;QtyToLoad;Decimal)
        {
        }
        field(50049;Variance;Decimal)
        {
        }
        field(50050;"Product To Load";Code[20])
        {
            TableRelation = Item."No." WHERE("Product to load"=CONST(true));
        }
        field(50051;"Uplift Date";Date)
        {
            Editable = false;
        }
        field(50052;"HQ Sup. Ref";Code[20])
        {
        }
        field(50053;"Depot DEL. Note No.";Code[20])
        {
        }
        field(50054;"PETROTRADE DEL. Note No.";Code[20])
        {
        }
        field(50055;"Drv Name";Text[30])
        {
            TableRelation = "Salesperson/Purchaser";
        }
        field(50056;"Loading Authority";Code[20])
        {
        }
        field(50057;"Item Loaded";Code[20])
        {
            CalcFormula = Lookup("Sales Invoice Line"."No." WHERE("Document No."=FIELD("No."), Type=FILTER(Item), Quantity=FILTER(<>0)));
            FieldClass = FlowField;
        }
        field(50058;"Blanket Order No.";Code[20])
        {
            Caption = 'Blanket Order No.';
        //This property is currently not supported
        //TestTableRelation = false;
        }
        field(50060;"Posting Time";DateTime)
        {
            Editable = false;
        }
        field(50070;"Transport Mode";Option)
        {
            Editable = false;
            OptionCaption = ' ,Road,Rail,Export Road,Export Rail,Pipeline';
            OptionMembers = " ", Road, Rail, "Export Road", "Export Rail", Pipeline;
        }
        field(50076;"Service Charges Incl.";Option)
        {
            OptionCaption = 'Both Charges,Duty Charges,Zinara Charges,No Charges';
            OptionMembers = "Both Charges", "Duty Charges", "Zinara Charges", "No Charges";

            trigger OnValidate()var StatutoryLines: Record "Sales Line";
            confirm: Boolean;
            begin
            end;
        }
        field(50077;"Nav 2009 Ref No.";Code[20])
        {
            Description = 'SORDREF';
        }
        field(50078;"Zinara Charges";Boolean)
        {
            Description = 'StatutoryW18.00';
        }
        field(50079;"Duty Charges";Boolean)
        {
            Description = 'StatutoryW18.00';
        }
        field(50080;"Pipeline Fee Charges";Boolean)
        {
            Description = 'StatutoryW18.00';
        }
        field(50081;"Storage and Handling Charges";Boolean)
        {
            Description = 'StatutoryW18.00';
        }
        field(50082;"All Service Charges";Boolean)
        {
            Description = 'StatutoryW18.00';
        }
        field(50083;"Product Release Memo No.";Code[20])
        {
            Caption = 'Product Release Memo No.';
            TableRelation = "Product Release Memo Line"."Document No." WHERE("Customer No."=FIELD("Sell-to Customer No."));
        }
        field(50084;"Statutory Invoice No.";Code[20])
        {
            Editable = false;
            TableRelation = "Sales Invoice Header"."No.";
        }
        field(50085;"Statutory Receipt No.";Code[20])
        {
            Editable = false;
        }
        field(50086;"Statutory Balance";Decimal)
        {
        }
        field(50087;"Is Statutory Invoice";Boolean)
        {
            CalcFormula = Exist("Sales Invoice Line" WHERE("Document No."=FIELD("No."), "Sell-to Customer No."=FIELD("Sell-to Customer No."), "Is Statutory Line"=FILTER(true)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50088;"Has Statutory Balance";Boolean)
        {
            Editable = false;
        }
        field(50090;"Special Order Type";Option)
        {
            Description = 'LAW19.00';
            OptionCaption = ' ,Duty Free,Export,Special Product';
            OptionMembers = " ", "Duty Free", Export, "Special Product";
        }
        field(50091;"Zimra Bill of Entry No.";Code[20])
        {
            Description = 'LAW19.00';
        }
        field(50093;"Transporter Code";Code[20])
        {
            Description = 'LAW20.00';
            TableRelation = Transporter;
        }
        field(50094;"Driver Code";Code[20])
        {
            Description = 'LAW20.00';
            TableRelation = "Transporter Driver".Code WHERE("Transpoter Code"=FIELD("Transporter Code"));
        }
        field(50098;"Trailer Registration No.";Code[20])
        {
            Description = 'LoadingW20.10';
            TableRelation = "Truck Registration";
            ValidateTableRelation = false;
        }
        field(50100;"Amount (LCY)";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Sales Invoice Line"."Amount (LCY)" WHERE("Document No."=FIELD("No.")));
            Caption = 'Amount (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50101;"Amount Including VAT (LCY)";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Sales Invoice Line"."Amount Including VAT (LCY)" WHERE("Document No."=FIELD("No.")));
            Caption = 'Amount Including VAT (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
    }
}
