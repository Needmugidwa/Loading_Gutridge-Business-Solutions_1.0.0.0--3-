page 50102 "Driver Card"
{
    Caption = 'Driver Card';
    PageType = Card;
    SourceTable = "Transporter Driver";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Code";Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.';
                    ApplicationArea = All;
                }
                field("Driver Full Name";Rec."Driver Full Name")
                {
                    ToolTip = 'Specifies the value of the Full Name field.';
                    ApplicationArea = All;
                }
                field(Status;Rec.Status)
                {
                    ToolTip = 'Specifies the value of the InActive field.';
                    ApplicationArea = All;
                }
                field("Medical Aid Expiration Date";Rec."Medical Aid Expiration Date")
                {
                    ToolTip = 'Specifies the value of the Medical Aid Expiration Date field.';
                    ApplicationArea = All;
                }
                field("National ID No.";Rec."National ID No.")
                {
                    ToolTip = 'Specifies the value of the National ID No. field.';
                    ApplicationArea = All;
                }
                field("Phone No.";Rec."Phone No.")
                {
                    ToolTip = 'Specifies the value of the Phone No. field.';
                    ApplicationArea = All;
                }
                field("Re-Test Expiration Date";Rec."Re-Test Expiration Date")
                {
                    ToolTip = 'Specifies the value of the Re-Test Expiration Date field.';
                    ApplicationArea = All;
                }
                field("Transpoter Code";Rec."Transpoter Code")
                {
                    ToolTip = 'Specifies the value of the Transpoter Code field.';
                    ApplicationArea = All;
                }
                field("Transporter Name";Rec."Transporter Name")
                {
                    ToolTip = 'Specifies the value of the Transporter Name field.';
                    ApplicationArea = All;
                }
                field(Comment;Rec.Comment)
                {
                    ToolTip = 'Specifies the value of the Comment field.';
                    ApplicationArea = All;
                    MultiLine = true;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            group(Driver)
            {
                action(Register)
                {
                    Enabled = Rec.Status = Rec.Status::Disabled;
                    Caption = 'Enable';
                    Image = Register;
                    ApplicationArea = All;

                    trigger OnAction()begin
                        Rec.ChangeDriverStatus();
                    end;
                }
                action(DeRegister)
                {
                    Enabled = Rec.Status = Rec.Status::Enabled;
                    Caption = 'Disable';
                    Image = DisableBreakpoint;
                    ApplicationArea = All;

                    trigger OnAction()begin
                        Rec.ChangeDriverStatus();
                    end;
                }
            }
        }
    }
}
