table 50111 "Customer Loading Signatory"
{
    fields
    {
        field(1;"Code";Code[20])
        {
        }
        field(2;"Customer No.";Code[20])
        {
            TableRelation = Customer;
        }
        field(3;"Customer Name";Text[100])
        {
            CalcFormula = Lookup(Customer.Name WHERE("No."=FIELD("Customer No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(5;"Full Name";Text[100])
        {
        }
        field(6;InActive;Boolean)
        {
        }
        field(7;"DateTime Last Modified";DateTime)
        {
            Editable = false;
        }
        field(8;"Last Modified By";Code[50])
        {
            Editable = false;
        }
        field(9;Comment;Text[100])
        {
        }
        field(10;Signature;Media)
        {
        }
        field(11;"National ID No.";Code[20])
        {
        }
        field(12;"Phone No.";Code[20])
        {
            ExtendedDatatype = PhoneNo;
        }
        field(13;Email;Text[50])
        {
            ExtendedDatatype = EMail;
        }
        field(14;"Has Signature Uploaded";Boolean)
        {
        }
    }
    keys
    {
        key(Key1;"Code", "Customer No.")
        {
        }
    }
    fieldgroups
    {
    }
    trigger OnDelete()begin
        CheckIsAllowed(3);
    end;
    trigger OnInsert()begin
        CheckIsAllowed(0);
        "Last Modified By":=UserId;
        "DateTime Last Modified":=CurrentDateTime;
        "Has Signature Uploaded":=Signature.HasValue;
    end;
    trigger OnModify()begin
        CheckIsAllowed(1);
        "Last Modified By":=UserId;
        "DateTime Last Modified":=CurrentDateTime;
        "Has Signature Uploaded":=Signature.HasValue;
    end;
    trigger OnRename()begin
        CheckIsAllowed(2);
    end;
    var MustBeSetupErr: Label 'You are not allowed to %1 Customer Signatory details';
    local procedure CheckIsAllowed(ActionTask: Option Create, Modify, Rename, Delete)var UserSetup: Record "User Setup";
    begin
        if not UserSetup.Get(UserId) or not UserSetup."Allow Signature Management" then Error(MustBeSetupErr, ActionTask);
    end;
}
