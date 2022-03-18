page 50114 "Cancel Loading Ticket"
{
    PageType = Card;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(Control1)
            {
                ShowCaption = false;

                field(LoadingTicketNo;LoadingTicketNo)
                {
                    Caption = 'Loading Ticket No';
                }
            }
        }
    }
    actions
    {
    }
    var LoadingTicketNo: Code[20];
    procedure GetLoadingTicketNo(): Code[20]begin
        exit(LoadingTicketNo);
    end;
}
