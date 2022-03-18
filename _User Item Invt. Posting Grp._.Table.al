table 50107 "User Item Invt. Posting Grp."
{
    fields
    {
        field(1;"Inventory Posting Group Code";Code[10])
        {
            NotBlank = true;
            TableRelation = Item."No.";
        }
        field(2;"User ID";Code[50])
        {
            NotBlank = true;
            TableRelation = "User Setup"."User ID";
        }
    }
    keys
    {
        key(Key1;"Inventory Posting Group Code", "User ID")
        {
        }
    }
    fieldgroups
    {
    }
    procedure SetMembership(InventoryPostingGroupCode: Code[10];
    UserID: Code[20];
    IsMember: array[25]of Boolean)begin
        if not Get(InventoryPostingGroupCode, UserID)then begin
            Init;
            "Inventory Posting Group Code":=InventoryPostingGroupCode;
            "User ID":=UserID;
            Insert;
        end
        else if Get(InventoryPostingGroupCode, UserID)then Delete;
    end;
}
