table 50108 "Does not Require Loadings"
{
    fields
    {
        field(1;"Sales Order No.";Code[20])
        {
            NotBlank = true;
            TableRelation = "Sales Header"."No." WHERE("Document Type"=CONST(Order));
        }
    }
    keys
    {
        key(Key1;"Sales Order No.")
        {
        }
    }
    fieldgroups
    {
    }
}
