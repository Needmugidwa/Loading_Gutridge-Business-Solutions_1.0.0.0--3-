table 50117 Transporter
{
    DrillDownPageID = 50209;
    LookupPageID = 50209;

    fields
    {
        field(1;"Code";Code[20])
        {
        }
        field(2;Name;Text[100])
        {
            trigger OnValidate()begin
                TestField(Code);
            end;
        }
        field(3;"Contact Name";Text[30])
        {
        }
        field(4;"Contact Phone";Code[20])
        {
        }
        field(5;"Contact Email";Text[50])
        {
        }
        field(6;"DateTime Last Modified";DateTime)
        {
            Editable = false;
        }
        field(7;"Last Modified By";Code[50])
        {
            Editable = false;
        }
        field(8;Status;Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Disabled, Enabled;
            Editable = false;
        }
        field(9;address;text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(10;"No. of Drivers";Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Transporter Driver" Where("Transpoter Code"=field(Code)));
        }
        field(11;"No. Series";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
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
    trigger OnInsert()begin
        "DateTime Last Modified":=CurrentDateTime;
        "Last Modified By":=UserId;
    end;
    trigger OnModify()begin
        "DateTime Last Modified":=CurrentDateTime;
        "Last Modified By":=UserId;
    end;
    /// <summary>
 
/// ChangeStatus. 
 
/// </summary>
 procedure ChangeStatus()begin
        if Rec.Status = Rec.Status::Disabled then Rec.Validate(Status, Rec.Status::Enabled)
        else
            Rec.Validate(Status, Rec.Status::Disabled);
    end;
}
