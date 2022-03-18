page 50209 "Transporter"
{
    ApplicationArea = All;
    Caption = 'Transporter';
    PageType = List;
    SourceTable = Transporter;
    UsageCategory = Lists;
    InsertAllowed = false;
    ModifyAllowed = false;
    CardPageId = 50111;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Code";Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.';
                    ApplicationArea = All;
                }
                field("Contact Email";Rec."Contact Email")
                {
                    ToolTip = 'Specifies the value of the Contact Email field.';
                    ApplicationArea = All;
                }
                field("Contact Name";Rec."Contact Name")
                {
                    ToolTip = 'Specifies the value of the Contact Name field.';
                    ApplicationArea = All;
                }
                field("Contact Phone";Rec."Contact Phone")
                {
                    ToolTip = 'Specifies the value of the Contact Phone field.';
                    ApplicationArea = All;
                }
                field(Name;Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
