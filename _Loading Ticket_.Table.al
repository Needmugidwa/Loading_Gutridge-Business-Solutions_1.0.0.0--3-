table 50102 "Loading Ticket"
{
    Caption = 'Loading Tickets';
    DrillDownPageID = 50202;
    LookupPageID = 50202;

    fields
    {
        field(1;"Loading Order No.";Code[20])
        {
            NotBlank = true;
        }
        field(2;Description;Text[50])
        {
        }
        field(3;"Loading Order No. Used";Boolean)
        {
            Editable = false;
        }
        field(4;"Posting Date";Date)
        {
            Editable = false;
        }
        field(50000;"Location Code";Code[10])
        {
            Editable = false;
            TableRelation = Location WHERE("Use As In-Transit"=CONST(false));
        }
        field(50001;"Loading Order No. Cancelled";Boolean)
        {
            Editable = false;
        }
        field(50002;"Cancellation Date";Date)
        {
            Editable = false;
        }
        field(50003;"Item To Load";Code[20])
        {
            Editable = false;
            TableRelation = Item;
        }
    }
    keys
    {
        key(Key1;"Loading Order No.")
        {
        }
        key(Key2;"Posting Date")
        {
        }
        key(Key3;"Location Code", "Loading Order No. Used")
        {
        }
    }
    fieldgroups
    {
    }
    trigger OnDelete()begin
    //ERROR(Text001);
    end;
    var Text001: Label 'You are not allowed to delete Loading Order No.s';
}
