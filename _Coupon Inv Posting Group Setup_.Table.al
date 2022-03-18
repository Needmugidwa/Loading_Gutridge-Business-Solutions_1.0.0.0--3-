table 50109 "Coupon Inv Posting Group Setup"
{
    fields
    {
        field(1;"Inventory Posting Group";Code[20])
        {
            TableRelation = "Inventory Posting Group".Code;
        }
        field(2;"Yes/No";Boolean)
        {
        }
    }
    keys
    {
        key(Key1;"Inventory Posting Group")
        {
        }
    }
    fieldgroups
    {
    }
}
