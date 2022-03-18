codeunit 50100 "Cancel Loading Ticket"
{
    trigger OnRun()begin
        Clear(PromptPage);
        if PromptPage.RunModal = ACTION::OK then begin
            if PromptPage.GetLoadingTicketNo() <> '' then begin
                if Confirm('Are you sure you want to cancel Loading Ticket No. %1?', false, PromptPage.GetLoadingTicketNo())then begin
                    LoadingTicket.Reset;
                    LoadingTicket.SetRange("Loading Order No.", PromptPage.GetLoadingTicketNo());
                    if LoadingTicket.FindFirst then begin
                        if(not LoadingTicket."Loading Order No. Used")then begin
                            LoadingTicket."Loading Order No. Used":=true;
                            LoadingTicket."Loading Order No. Cancelled":=true;
                            LoadingTicket."Cancellation Date":=Today;
                            LoadingTicket.Modify;
                            Message('Loading Ticket No. %1 cancelled successfully.', PromptPage.GetLoadingTicketNo());
                        end
                        else
                        begin
                            if LoadingTicket."Loading Order No. Cancelled" then Error('Loading Ticket No. %1 already Cancelled.', PromptPage.GetLoadingTicketNo())
                            else
                                Error('Loading Ticket No. %1 is already used.', PromptPage.GetLoadingTicketNo());
                        end;
                    end
                    else
                        Error('Loading ticket No. %1 does not exist.', PromptPage.GetLoadingTicketNo());
                end;
            end
            else
                Error('Please enter a valid Loading ticket');
        end;
    end;
    var LoadingTicket: Record "Loading Ticket";
    PromptPage: Page "Cancel Loading Ticket";
}
