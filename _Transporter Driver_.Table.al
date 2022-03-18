table 50118 "Transporter Driver"
{
    DrillDownPageID = 50211;
    LookupPageID = 50211;

    fields
    {
        field(1;"Code";Code[20])
        {
        }
        field(2;"Transpoter Code";Code[20])
        {
            TableRelation = Transporter;
        }
        field(3;"Transporter Name";Text[100])
        {
            CalcFormula = Lookup(Transporter.Name WHERE(Code=FIELD("Transpoter Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(5;"Driver Full Name";Text[250])
        {
            trigger OnValidate()begin
                TestField(Code);
            end;
        }
        field(6;Status;Option)
        {
            OptionMembers = Disabled, Enabled;
            Editable = false;

            trigger OnValidate()begin
                Rec.TestField("Medical Aid Expiration Date");
                Rec.TestField("Re-Test Expiration Date");
                Rec.TestField("Transpoter Code");
                rec.TestField("National ID No.");
            end;
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
        field(11;"National ID No.";Code[20])
        {
        }
        field(12;"Phone No.";Code[20])
        {
            ExtendedDatatype = PhoneNo;
        }
        field(15;"Medical Aid Expiration Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(16;"Re-Test Expiration Date";Date)
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(Key1;"Code", "Transpoter Code")
        {
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown;"Code", "Transpoter Code", "Driver Full Name")
        {
        }
        fieldgroup(LookUp;"Code", "Transpoter Code", "Driver Full Name")
        {
        }
    }
    trigger OnDelete()begin
        CheckIsAllowed(3);
    end;
    trigger OnInsert()begin
        CheckIsAllowed(0);
        "DateTime Last Modified":=CurrentDateTime;
        "Last Modified By":=UserId;
    end;
    trigger OnModify()begin
        CheckIsAllowed(1);
        "DateTime Last Modified":=CurrentDateTime;
        "Last Modified By":=UserId;
    end;
    trigger OnRename()begin
        CheckIsAllowed(4);
    end;
    var MustBeSetupErr: Label 'You are not allowed to %1 Driver Details';
    local procedure CheckIsAllowed(ActionTask: Option Create, Modify, Rename, Delete)var UserSetup: Record "User Setup";
    begin
        if not UserSetup.Get(UserId) or not UserSetup."Allow Driver Management" then Error(MustBeSetupErr, ActionTask);
    end;
    /// <summary>
 
/// EnableDriver. 
 
/// </summary>
 procedure ChangeDriverStatus()begin
        if Rec.Status = Rec.Status::Disabled then Rec.Validate(Status, Rec.Status::Enabled)
        else
            Rec.Validate(Status, Rec.Status::Disabled);
    end;
}
