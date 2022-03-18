page 50101 "Meter Code List"
{
    DeleteAllowed = false;
    Editable = false;
    // InsertAllowed = false;
    // ModifyAllowed = false;
    PageType = List;
    SourceTable = "Meter Codes";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;

                field("Code";Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description;Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Location Code";Rec."Location Code")
                {
                }
            }
        }
    }
    actions
    {
    }
}
