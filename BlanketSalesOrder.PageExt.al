pageextension 50140 BlanketSalesOrder extends "Blanket Sales Order"
{
    layout
    {
        addafter(Status)
        {
            field("Statutory Invoice No.";Rec."Statutory Invoice No.")
            {
                ApplicationArea = All;
            }
            field("Completely Shipped";Rec."Completely Shipped")
            {
                ApplicationArea = All;
            }
            field("Blanket Order No.";Rec."Blanket Order No.")
            {
                ApplicationArea = All;
                Caption = 'Transfered from Blanket Order No.';
            }
            field("HQ Sup. Ref";Rec."HQ Sup. Ref")
            {
                ApplicationArea = All;
            }
        }
        addafter("Foreign Trade")
        {
            group(Statistics)
            {
                field("No. Of Active Quotes";Rec."No. Of Active Quotes")
                {
                    ApplicationArea = All;

                    trigger OnDrillDown()var SalesHeader: Record "Sales Header";
                    begin
                        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Quote);
                        SalesHeader.SetRange("Blanket Order No.", Rec."No.");
                        Page.RunModal(Page::"Sales Quotes", SalesHeader);
                    end;
                }
                field("No. Of Archived Quotes";Rec."No. Of Archived Quotes")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        modify(MakeOrder)
        {
            Visible = false;
        }
        modify(Reopen)
        {
            trigger OnBeforeAction()begin
                if Rec.BlanketOrderPaidForQty()then Error('Cannot Reopen Blanket Order which has quantities that were paid for');
            end;
        }
        addafter(MakeOrder)
        {
            action(CreateQuote)
            {
                ApplicationArea = All;
                Caption = 'Create &Proforma Invoice';
                Image = Quote;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Create Proforma Invoice For Customer.';

                trigger OnAction()var ChangePMStatus: Page "Process Blanket Order";
                ActionType: Enum "Blanket Order Actions";
                BlanketSalesOrderLine: Record "Sales Line";
                NothingToQuoteErr: Label 'There is Nothing to Create';
                begin
                    Rec.testfield(Status, Rec.Status::Released);
                    if not BlanketSalesOrderLine.BlanketOrderHasQtyToQuote(Rec."No.")then Error(NothingToQuoteErr);
                    ChangePMStatus.Initialize(Rec."No.", ActionType::Quote, 0D);
                    if not(ChangePMStatus.RunModal() = Action::OK)then exit;
                    ChangePMStatus.GetDetails(AllServiceCharges1, ZinaraCharges1, PipelineCharges1, StorageCharges1, DutyCharges1, PipelineForeign1, StorageForeign1);
                    CustomSalesFunctions.CreateSalesQuote(Rec, AllServiceCharges1, ZinaraCharges1, PipelineCharges1, StorageCharges1, DutyCharges1, PipelineForeign1, StorageForeign1);
                end;
            }
            action(Transfer)
            {
                ApplicationArea = All;
                Caption = 'Transfer';
                Image = TransferOrder;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Transfer Quantities.';

                trigger OnAction()var ChangePMStatus: Page "Transfer-to";
                ActionType: Enum "Blanket Order Actions";
                BlanketSalesOrderLine: Record "Sales Line";
                NothingToQuoteErr: Label 'There is Nothing to Transfer';
                begin
                    Rec.testfield(Status, Rec.Status::Released);
                    if not BlanketSalesOrderLine.BlanketOrderHasQtyToTransfer(Rec."No.")then Error(NothingToQuoteErr);
                    ChangePMStatus.Initialize();
                    if not(ChangePMStatus.RunModal() = Action::OK)then exit;
                    ChangePMStatus.GetDetails(CustomerNo);
                    CustomSalesFunctions.TransferQuantities(Rec, CustomerNo);
                end;
            }
            action(MakeOrder2)
            {
                ApplicationArea = Suite;
                Caption = 'Make &Order';
                Image = MakeOrder;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Convert the blanket sales order to a sales order.';

                trigger OnAction()var ApprovalsMgmt1: Codeunit "Approvals Mgmt.";
                salesLine: Record "Sales Line";
                Text50001: Label 'Product %1 has No Qty To Ship. Do you want to proceed?';
                begin
                    Rec.testfield(Status, Rec.Status::Released);
                    // Rec.TestField("Location Code");
                    salesLine.SetRange("Document Type", salesLine."Document Type"::"Blanket Order");
                    SalesLine.SETRANGE("Document No.", Rec."No.");
                    IF SalesLine.FindSet()THEN REPEAT IF SalesLine.Type = SalesLine.Type::Item THEN IF SalesLine."Qty. to Ship" = 0 THEN IF NOT CONFIRM(Text50001, FALSE, SalesLine.Description)THEN EXIT;
                        UNTIL SalesLine.NEXT = 0;
                    if ApprovalsMgmt1.PrePostApprovalCheckSales(Rec)then CODEUNIT.Run(CODEUNIT::"Blnkt Sales Ord. to Ord. (Y/N)", Rec);
                end;
            }
        }
    }
    var CustomSalesFunctions: Codeunit "Custom Sales Functions";
    AllServiceCharges1: Boolean;
    ZinaraCharges1: Boolean;
    PipelineCharges1: Boolean;
    StorageCharges1: Boolean;
    DutyCharges1: Boolean;
    CustomerNo: Code[20];
    PipelineForeign1: Boolean;
    StorageForeign1: Boolean;
}
