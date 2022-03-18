table 50105 "User Location"
{
    fields
    {
        field(1;"Location Code";Code[10])
        {
            NotBlank = true;
            TableRelation = Location.Code;
        }
        field(2;"User ID";Code[50])
        {
            NotBlank = true;
            TableRelation = "User Setup"."User ID";
        }
    }
    keys
    {
        key(Key1;"Location Code", "User ID")
        {
        }
    }
    fieldgroups
    {
    }
    /// <summary>
 
/// SetMembership. 
 
/// </summary>
 
/// <param name="LocationCode">Code[10].</param>
 
/// <param name="UserID">Code[50].</param>
 
/// <param name="IsMember">array [40] of Boolean.</param>
 procedure SetMembership(LocationCode: Code[10];
    UserID: Code[50];
    IsMember: array[40]of Boolean)begin
        if not Get(LocationCode, UserID)then begin
            Init;
            "Location Code":=LocationCode;
            "User ID":=UserID;
            Insert;
        end
        else if Get(LocationCode, UserID)then Delete;
    end;
}
