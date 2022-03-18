table 50100 "Loading Personnel"
{
    DrillDownPageID = 50113;
    LookupPageID = 50113;

    fields
    {
        field(1; "User ID"; Code[50])
        {
            // Editable = false;
            // TableRelation = "User Setup";
            //This property is currently not supported
            //TestTableRelation = false;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;
        }
        field(2; Description; Text[50])
        {
        }
        field(50000; "Location Code"; Code[10])
        {
            Editable = false;
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(50001; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(50002; Signature; MediaSet)
        {

        }

    }
    keys
    {
        key(Key1; "User ID")
        {
        }
        key(Key2; "Location Code")
        {
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "User ID", Description, "Location Code")
        {
        }
        fieldgroup(LookUp; "User ID", Description, "Location Code")
        {
        }
    }
    trigger OnInsert()
    begin
        Location.Get("Location Code");
        if "User ID" = '' then begin
            TestNoSeries;
            NoSeriesMgt.InitSeries(GetNoSeriesCode, xRec."No. Series", Today, "User ID", "No. Series");
        end;
    end;

    var
        Location: Record Location;
        NoSeriesMgt: Codeunit NoSeriesManagement;

    local procedure TestNoSeries(): Boolean
    begin
        Location.TestField("Loading Nos.");
    end;

    local procedure GetNoSeriesCode(): Code[10]
    begin
        exit(Location."Loading Nos.");
    end;
}
