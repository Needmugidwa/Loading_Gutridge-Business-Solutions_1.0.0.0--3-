table 50103 "Department Approval Setup"
{
    fields
    {
        field(1;"Code";Code[20])
        {
            NotBlank = true;
            TableRelation = Department;
        }
        field(2;"Approver ID";Code[20])
        {
            NotBlank = true;
            TableRelation = "User Setup" WHERE("Approver ID"=FILTER(<>''));
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
