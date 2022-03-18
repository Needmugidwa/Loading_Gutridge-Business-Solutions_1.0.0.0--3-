page 50106 "Pick Instruction List"
{
    ApplicationArea = All;
    Caption = 'Pick Instruction List';
    PageType = List;
    SourceTable = "Pick Instruction Header";
    UsageCategory = Lists;
    ModifyAllowed = false;
    CardPageId = 50104;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No.";Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                }
                field("Customer Name";Rec."Customer Name")
                {
                    ApplicationArea = All;
                }
                field("Document Date";Rec."Document Date")
                {
                    ToolTip = 'Specifies the value of the Document Date field.';
                    ApplicationArea = All;
                }
                field("Approval Status";Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
