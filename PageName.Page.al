page 50128 PageName
{
    Caption = 'PageName';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Product Release Memo Header";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No.";Rec."No.")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(Factboxes)
        {
        }
    }
    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin
                end;
            }
        }
    }
}
