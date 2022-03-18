table 50119 "Truck Registration"
{
    DrillDownPageID = 50110;
    LookupPageID = 50110;

    fields
    {
        field(1;"Registration No.";Code[20])
        {
        }
        field(2;Type;Option)
        {
            OptionCaption = ' ,Horse,Trailer';
            OptionMembers = " ", Horse, Trailer;
        }
        field(5;"Transporter Code";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Transporter;
        }
        field(7;"Horse Id";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Truck Registration" where(Type=const(Horse));

            trigger OnValidate()begin
                Rec.TestField(Type, Rec.Type::Trailer);
            end;
        }
        field(8;"Tank Calibration Exp Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(10;"ZINARA Exp Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(12;"Fitness Test Exp Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(14;Description;Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(16;Tonnage;Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(18;Comment;Text[1024])
        {
            DataClassification = ToBeClassified;
        }
        field(19;Status;Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Disabled, Enabled;
            Editable = false;
        }
    }
    keys
    {
        key(Key1;"Registration No.")
        {
        }
    }
    fieldgroups
    {
    }
    /// <summary>
 
/// ChangeStatus. 
 
/// </summary>
 procedure ChangeStatus()begin
        if Rec.Status = Rec.Status::Disabled then Rec.Validate(Status, Rec.Status::Enabled)
        else
            Rec.Validate(Status, Rec.Status::Disabled);
    end;
}
