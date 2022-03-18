page 50200 "Loading Personnel List"
{
    DeleteAllowed = false;
    Editable = false;
    // InsertAllowed = false;
    // ModifyAllowed = false;
    SourceTable = "Loading Personnel";
    UsageCategory = Lists;
    ApplicationArea = All;
    PageType = List;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;

                field("User ID"; Rec."User ID")
                {
                    Caption = 'Loading Personnel';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                }
            }

        }
        area(factboxes)
        {
            part(UserSignature; "User Signature")
            {
                ApplicationArea = All;
                SubPageLink = "User ID" = field("User ID");
            }
        }
    }
    actions
    {
    }
}
