page 50203 "Loading List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Loading Ticket";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Loading Order No."; Rec."Loading Order No.")
                {
                }
                field("Location Code"; Rec."Location Code")
                {
                }
                field("Item To Load"; Rec."Item To Load")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Loading Order No. Used"; Rec."Loading Order No. Used")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
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
    trigger OnNewRecord(BelowxRec: Boolean)
    var
        myInt: Integer;
    begin
    end;
}
