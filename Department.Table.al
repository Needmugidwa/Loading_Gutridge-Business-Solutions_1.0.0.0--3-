table 50104 Department
{
    fields
    {
        field(1;"Code";Code[20])
        {
            NotBlank = true;
        }
        field(2;Name;Text[50])
        {
            NotBlank = true;
        }
    }
    keys
    {
        key(Key1;"Code")
        {
        }
    }
    fieldgroups
    {
    }
}
