page 50202 "Loading Ticket List"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = true;
    ModifyAllowed = true;
    PageType = List;
    SourceTable = "Loading Ticket";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;

                field("Loading Order No.";Rec."Loading Order No.")
                {
                    ApplicationArea = All;
                }
                field("Location Code";Rec."Location Code")
                {
                    ApplicationArea = All;
                }
                field("Item To Load";Rec."Item To Load")
                {
                    ApplicationArea = All;
                }
                field(Description;Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Loading Order No. Used";Rec."Loading Order No. Used")
                {
                    ApplicationArea = All;
                }
                field("Posting Date";Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
    }
}
