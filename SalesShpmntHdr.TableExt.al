tableextension 50148 SalesShpmntHdr extends "Sales Shipment Header"
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
            TableRelation = "Shipping Agent Services";
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
            TableRelation = "Shipping Agent Services";
        }
        field(50007;Loader;Code[20])
        {
            TableRelation = "Shipping Agent Services";
        }
        field(50008;Dipper;Code[20])
        {
            TableRelation = "Shipping Agent Services";
        }
        field(50009;Sealer;Code[20])
        {
            TableRelation = "Shipping Agent Services";
        }
        field(50010;"Transporter Name";Text[50])
        {
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
        field(50050;"Product To Load";Code[20])
        {
            TableRelation = Item."No." WHERE("Product to load"=CONST(true));
        }
        field(50057;"Blanket Order No";Code[20])
        {
            Caption = 'Not  in use';
        //This property is currently not supported
        //TestTableRelation = false;
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
            Description = 'LAW20.00';
            TableRelation = "Product Release Memo Line"."Document No." WHERE("Customer No."=FIELD("Sell-to Customer No."));
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
    }
}
