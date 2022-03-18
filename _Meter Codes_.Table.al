table 50101 "Meter Codes"
{
    DrillDownPageID = 50112;
    LookupPageID = 50112;

    fields
    {
        field(1;"Code";Code[20])
        {
            NotBlank = true;
        }
        field(2;Description;Text[30])
        {
        }
        field(50000;"Location Code";Code[10])
        {
            Editable = false;
            TableRelation = Location WHERE("Use As In-Transit"=CONST(false));
        }
    }
    keys
    {
        key(Key1;"Code")
        {
        }
        key(Key2;"Location Code")
        {
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown;"Code", Description, "Location Code")
        {
        }
        fieldgroup(LookUp;"Code", Description, "Location Code")
        {
        }
    }
}
