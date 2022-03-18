page 50113 "Loading Personnel"
{
    PageType = List;
    SourceTable = "Loading Personnel";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;

                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    Caption = 'Loading Personnel';
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
            part("Loading Personnel Signature"; "Loading Personnel Signature")
            {
                ApplicationArea = All;
                SubPageLink = "User ID" = field("User ID");
            }
        }

    }
    actions
    {
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        FilterText := UserMgt.GetUserLocationFilter();
        if FilterText = '' then
            Error(Text50005, UserId)
        else begin
            Location.Reset;
            Location.FilterGroup(2);
            Location.SetFilter(Code, FilterText);
            Location.FilterGroup(0);
            if Location.Count = 1 then
                Rec.Validate("Location Code", FilterText)
            else begin
                if PAGE.RunModal(0, Location) = ACTION::LookupOK then
                    Rec.Validate("Location Code", Location.Code)
                else
                    Error(Text50006);
            end;
        end;
    end;

    trigger OnOpenPage()
    begin
        FilterText := UserMgt.GetUserLocationFilter();
        if FilterText = '' then
            Error(Text50005, UserId)
        else begin
            Rec.FilterGroup(2);
            Rec.SetFilter("Location Code", FilterText);
            Rec.FilterGroup(0);
        end;
    end;

    var
        FilterText: Text[1024];
        UserMgt: Codeunit "Custom Sales Functions";
        Location: Record Location;
        Text50005: Label 'User %1 is not allowed for any location.';
        Text50006: Label 'You must specify a Location Code.';
}
