tableextension 50155 ArchivedSalesHeader extends "Sales Header Archive"
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
            TableRelation = "Meter Codes" WHERE("Location Code"=FIELD("Loading Location"));
        }
        field(50007;Loader;Code[20])
        {
            TableRelation = "Loading Personnel" WHERE("Location Code"=FIELD("Loading Location"));
        }
        field(50008;Dipper;Code[20])
        {
            TableRelation = "Loading Personnel" WHERE("Location Code"=FIELD("Loading Location"));
        }
        field(50009;Sealer;Code[20])
        {
            TableRelation = "Loading Personnel" WHERE("Location Code"=FIELD("Loading Location"));
        }
        field(50010;"Transporter Name";Text[50])
        {
        }
        field(50011;"Horse Registration No.";Code[20])
        {
            Description = 'LoadingW20.10';
            TableRelation = "Truck Registration" WHERE(Type=CONST(Horse));
            ValidateTableRelation = false;

            trigger OnValidate()var TruckRegistration: Record "Truck Registration";
            begin
                if "Horse Registration No." = '' then exit;
                if TruckRegistration.GET("Horse Registration No.")then TruckRegistration.TESTFIELD(Type, TruckRegistration.Type::Horse)
                else
                begin
                    TruckRegistration.INIT;
                    TruckRegistration."Registration No.":="Horse Registration No.";
                    TruckRegistration.Type:=TruckRegistration.Type::Horse;
                    TruckRegistration.INSERT;
                end;
            end;
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
            DecimalPlaces = 6: 6;
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
            BlankZero = true;
        }
        field(50028;"Dip Value 9";Decimal)
        {
            BlankZero = true;
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
        field(50047;"Trans Mode";Option)
        {
            OptionCaption = ' ,Road Tanker,Rail Tanker,Pipe line';
            OptionMembers = " ", "Road Tanker", "Rail Tanker", "Pipe line";
        }
        field(50048;QtyToLoad;Decimal)
        {
            NotBlank = false;
        }
        field(50049;Variance;Decimal)
        {
        }
        field(50050;"Product To Load";Code[20])
        {
            Editable = false;
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
        field(50058;"Blanket Order No.";Code[20])
        {
            Caption = 'Blanket Order No.';
            Editable = false;
        //This property is currently not supported
        //TestTableRelation = false;
        }
        field(50060;"Posting Time";DateTime)
        {
            Editable = false;
        }
        field(50062;"Item Type Exist";Boolean)
        {
            CalcFormula = Exist("Sales Line" WHERE("Document Type"=FIELD("Document Type"), "Document No."=FIELD("No."), Type=CONST(Item)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50070;"Transport Mode";Option)
        {
            OptionCaption = ' ,Road,Rail,Export Road,Export Rail,Pipeline';
            OptionMembers = " ", Road, Rail, "Export Road", "Export Rail", Pipeline;
        }
        field(50076;"Service Charges Incl.";Option)
        {
            OptionCaption = 'Both Charges,Duty Charges,Zinara Charges,No Charges';
            OptionMembers = "Both Charges", "Duty Charges", "Zinara Charges", "No Charges";
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
            Description = 'LAW18.00';
            Editable = false;
        }
        field(50084;"Statutory Invoice No.";Code[20])
        {
            Description = 'LAW18.00';
            Editable = false;
            TableRelation = "Sales Invoice Header"."No." WHERE("Sell-to Customer No."=FIELD("Sell-to Customer No."));
        }
        field(50086;"Statutory Balance";Decimal)
        {
            Description = 'LAW18.00';
        }
        field(50087;"Is Statutory Invoice";Boolean)
        {
            CalcFormula = Exist("Sales Line" WHERE("Document Type"=CONST(Invoice), "Is Statutory Line"=CONST(true), "Document No."=FIELD("No.")));
            Description = 'LAW18.00';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50088;"Has Statutory Balance";Boolean)
        {
            Description = 'LAW18.00';
            Editable = false;
        }
        field(50089;"No. of Lines";Integer)
        {
            CalcFormula = Count("Sales Line" WHERE("Document Type"=FIELD("Document Type"), "Document No."=FIELD("No.")));
            Description = 'LAW18.00';
            FieldClass = FlowField;
        }
        field(50090;"Special Order Type";Option)
        {
            Description = 'LAW19.00';
            OptionCaption = ' ,Duty Free,Export,Special Product';
            OptionMembers = " ", "Duty Free", Export, "Special Product";
        }
        field(50091;"Zimra Bill of Entry/Ref. No.";Code[20])
        {
            Description = 'LAW19.00';

            trigger OnValidate()begin
                TestField(Status, Status::Open);
                TestField("Document Type", "Document Type"::Order);
                TestField("Special Order Type");
            end;
        }
        field(50092;"Total Item Qty";Decimal)
        {
            CalcFormula = Sum("Sales Line".Quantity WHERE("Document Type"=FIELD("Document Type"), "Document No."=FIELD("No."), Type=CONST(Item)));
            Description = 'LAW20.00';
            FieldClass = FlowField;
        }
        field(50093;"Transporter Code";Code[20])
        {
            Description = 'LoadingW20.00';
            TableRelation = Transporter;

            trigger OnValidate()var Transporter: Record Transporter;
            begin
                if Transporter.GET("Transporter Code")then "Transporter Name":=Transporter.Name
                else
                    "Transporter Name":='';
            end;
        }
        field(50094;"Driver Code";Code[20])
        {
            Description = 'LoadingW20.00';
            TableRelation = "Transporter Driver".Code WHERE("Transpoter Code"=FIELD("Transporter Code"), Status=const(Enabled), "National ID No."=FILTER(<>''));

            trigger OnValidate()var TransporterDriver: Record "Transporter Driver";
            begin
                TestField("Transporter Code");
                if TransporterDriver.GET("Driver Code", "Transporter Code")then begin
                    TransporterDriver.TESTFIELD("National ID No.");
                    "Driver Name":=TransporterDriver."Driver Full Name";
                    "Driver ID":=TransporterDriver."National ID No.";
                end
                else
                begin
                    "Driver Name":='';
                    "Driver ID":='';
                end;
            end;
        }
        field(50095;"Loading Location";Code[10])
        {
            Description = 'LoadingW20.00 Current Loading Location Triggered by Loading Authority';
            TableRelation = Location;
        }
        field(50096;"Current Line No. to Load";Integer)
        {
            Description = 'LoadingW20.00';
        }
        field(50097;"Not Completely Invoiced";Boolean)
        {
            CalcFormula = Exist("Sales Line" WHERE("Outstanding Quantity"=FILTER(>0), "Document Type"=FIELD("Document Type"), "Document No."=FIELD("No.")));
            Description = 'LoadingW20.00';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50098;"Trailer Registration No.";Code[20])
        {
            Description = 'LoadingW20.10';
            TableRelation = "Truck Registration" WHERE(Type=CONST(Trailer));
            ValidateTableRelation = false;
        }
        field(50099;"No Trailer";Boolean)
        {
            Description = 'LoadingW20.10';
        }
        field(50100;"Amount (LCY)";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Sales Line"."Amount (LCY)" WHERE("Document Type"=FIELD("Document Type"), "Document No."=FIELD("No.")));
            Caption = 'Amount (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50101;"Amount Including VAT (LCY)";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Sales Line"."Amount Including VAT (LCY)" WHERE("Document Type"=FIELD("Document Type"), "Document No."=FIELD("No.")));
            Caption = 'Amount Including VAT (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50200;"Loading Badge No.";Code[30])
        {
            Description = 'SatamW110.00';
            Editable = false;
        }
        field(50201;"Loading Time";DateTime)
        {
            Description = 'SatamW110.00';
            Editable = false;
        }
        field(50202;"Awaiting Posting";Boolean)
        {
            Description = 'SatamW110.00';
            Editable = false;
        }
        field(50203;"Loaded by User";Text[30])
        {
            Description = 'SatamW110.00';
            Editable = false;
        }
        field(50204;"Forced Deletion";Boolean)
        {
        }
    }
}
