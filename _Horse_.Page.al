page 50110 "Horse"
{
    ApplicationArea = All;
    Caption = 'Vehicle';
    PageType = List;
    SourceTable = "Truck Registration";
    UsageCategory = Lists;
    CardPageId = 50103;
    InsertAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Registration No.";Rec."Registration No.")
                {
                    ToolTip = 'Specifies the value of the Registration No. field.';
                    ApplicationArea = All;
                }
                field("Type";Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
