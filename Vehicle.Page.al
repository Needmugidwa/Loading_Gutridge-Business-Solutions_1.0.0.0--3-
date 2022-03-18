page 50103 Vehicle
{
    Caption = 'Vehicle';
    PageType = Card;
    SourceTable = "Truck Registration";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Registration No.";Rec."Registration No.")
                {
                    ToolTip = 'Specifies the value of the Registration No. field.';
                    ApplicationArea = All;
                }
                field(Description;Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field("Type";Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.';
                    ApplicationArea = All;
                }
                field("Horse Id";Rec."Horse Id")
                {
                    ToolTip = 'Specifies the value of the Horse Id field.';
                    ApplicationArea = All;
                }
                field("Transporter Code";Rec."Transporter Code")
                {
                    ToolTip = 'Specifies the value of the Transporter Code field.';
                    ApplicationArea = All;
                }
                field(Tonnage;Rec.Tonnage)
                {
                    ToolTip = 'Specifies the value of the Tonnage field.';
                    ApplicationArea = All;
                }
                field(Status;Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                    ApplicationArea = All;
                }
                field(Comment;Rec.Comment)
                {
                    ToolTip = 'Specifies the value of the Comment field.';
                    ApplicationArea = All;
                }
                field("Fitness Test Exp Date";Rec."Fitness Test Exp Date")
                {
                    ToolTip = 'Specifies the value of the Fitness Test Exp Date field.';
                    ApplicationArea = All;
                }
                field("Tank Calibration Exp Date";Rec."Tank Calibration Exp Date")
                {
                    ToolTip = 'Specifies the value of the Tank Calibration Exp Date field.';
                    ApplicationArea = All;
                }
                field("ZINARA Exp Date";Rec."ZINARA Exp Date")
                {
                    ToolTip = 'Specifies the value of the ZINARA Exp Date field.';
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Register)
            {
                Enabled = Rec.Status = Rec.Status::Disabled;
                Caption = 'Enable';
                Image = Register;
                ApplicationArea = All;

                trigger OnAction()begin
                    Rec.ChangeStatus();
                end;
            }
            action(DeRegister)
            {
                Enabled = Rec.Status = Rec.Status::Enabled;
                Caption = 'Disable';
                Image = DisableBreakpoint;
                ApplicationArea = All;

                trigger OnAction()begin
                    Rec.ChangeStatus();
                end;
            }
        }
    }
}
