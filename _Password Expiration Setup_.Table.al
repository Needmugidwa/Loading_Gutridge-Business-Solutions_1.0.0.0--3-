table 50110 "Password Expiration Setup"
{
    DataPerCompany = false;

    fields
    {
        field(1;"Primary Key";Code[10])
        {
        }
        field(2;"Default  Expiration Period";Integer)
        {
        }
        field(3;"First Notification Day(s)";Integer)
        {
        }
        field(4;"Second Notification Day(s)";Integer)
        {
        }
        field(5;"Third Notification Day";Integer)
        {
        }
        field(6;"Admin Email Address";Text[30])
        {
        }
        field(7;"Email Subject";Text[50])
        {
        }
        field(8;"Admin Username";Code[10])
        {
            TableRelation = "User Setup";

            trigger OnValidate()var UserSetup: Record "User Setup";
            begin
                if UserSetup.Get("Admin Username")then "Admin Email Address":=UserSetup."E-Mail";
            end;
        }
        field(9;"Send Notifications as Email";Boolean)
        {
        }
        field(10;"Send Notifications as Notes";Boolean)
        {
        }
    }
    keys
    {
        key(Key1;"Primary Key")
        {
        }
    }
    fieldgroups
    {
    }
}
