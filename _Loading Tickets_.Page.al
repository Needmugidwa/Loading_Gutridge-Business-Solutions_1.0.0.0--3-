page 50109 "Loading Tickets"
{
    PageType = List;
    SourceTable = "Loading Ticket";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;

                field("Loading Order No.";Rec."Loading Order No.")
                {
                    ApplicationArea = All;
                }
                field(Description;REc.Description)
                {
                    ApplicationArea = All;
                }
                field("Item To Load";Rec."Item To Load")
                {
                    ApplicationArea = All;
                }
                field("Loading Order No. Cancelled";Rec."Loading Order No. Cancelled")
                {
                    ApplicationArea = All;
                }
                field("Cancellation Date";Rec."Cancellation Date")
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
                field("Location Code";Rec."Location Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
    }
    trigger OnNewRecord(BelowxRec: Boolean)begin
        FilterText:=UserMgt.GetUserLocationFilter();
        if FilterText = '' then Error(Text50005, UserId)
        else
        begin
            Location.Reset;
            Location.FilterGroup(2);
            Location.SetFilter(Code, FilterText);
            Location.FilterGroup(0);
            if Location.Count = 1 then Rec.Validate("Location Code", FilterText)
            else
            begin
                if PAGE.RunModal(0, Location) = ACTION::LookupOK then Rec.Validate("Location Code", Location.Code)
                else
                    Error(Text50006);
            end;
        end;
        Item.Reset;
        Item.SetCurrentKey("Product to load");
        Item.FilterGroup(2);
        Item.SetFilter("Product to load", '%1', true);
        Item.FilterGroup(0);
        if PAGE.RunModal(0, Item) = ACTION::LookupOK then Rec.Validate("Item To Load", Item."No.")
        else
            Error('You must specify Item to Load.');
    end;
    trigger OnOpenPage()begin
        FilterText:=UserMgt.GetUserLocationFilter();
        if FilterText = '' then Error(Text50005, UserId)
        else
        begin
            Rec.FilterGroup(2);
            Rec.SetFilter("Location Code", FilterText);
            Rec.FilterGroup(0);
        end;
    end;
    var FilterText: Text[1024];
    Text50005: Label 'User %1 is not allowed for any location.';
    UserMgt: Codeunit "Custom Sales Functions";
    Location: Record Location;
    Text50006: Label 'You must specify a Location Code.';
    Item: Record Item;
}
