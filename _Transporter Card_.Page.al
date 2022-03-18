page 50111 "Transporter Card"
{
    Caption = 'Transporter Card';
    PageType = Card;
    SourceTable = Transporter;

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
                field(Name;Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                    ApplicationArea = All;
                }
                field(Status;Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                    ApplicationArea = All;
                }
                field("No. of Drivers";Rec."No. of Drivers")
                {
                    ToolTip = 'Specifies the value of the No. of Drivers field.';
                    ApplicationArea = All;
                }
            }
            group(Communication)
            {
                field(address;Rec.address)
                {
                    ToolTip = 'Specifies the value of the address field.';
                    ApplicationArea = All;
                }
                field("Contact Name";Rec."Contact Name")
                {
                    ToolTip = 'Specifies the value of the Contact Name field.';
                    ApplicationArea = All;
                }
                field("Contact Email";Rec."Contact Email")
                {
                    ToolTip = 'Specifies the value of the Contact Email field.';
                    ApplicationArea = All;
                }
                field("Contact Phone";Rec."Contact Phone")
                {
                    ToolTip = 'Specifies the value of the Contact Phone field.';
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Enable)
            {
                Enabled = Rec.Status = Rec.Status::Disabled;
                Image = EnableBreakpoint;
                ApplicationArea = All;

                trigger OnAction()begin
                    Rec.ChangeStatus();
                end;
            }
            action(Disable)
            {
                Enabled = Rec.Status = Rec.Status::Enabled;
                Image = DisableBreakpoint;
                ApplicationArea = All;

                trigger OnAction()begin
                    Rec.ChangeStatus();
                end;
            }
        }
    }
}
