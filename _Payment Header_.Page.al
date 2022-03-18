page 50144 "Payment Header"
{
    Caption = 'Payment Header';
    PageType = Document;
    SourceTable = "Payment Header";

    // Editable = false;
    layout
    {
        area(content)
        {
            group(General)
            {
                field("Document Type";Rec."Document Type")
                {
                    ToolTip = 'Specifies the value of the Document Type field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("No.";Rec."Receipt No.")
                {
                    ToolTip = 'Specifies the value of the Receipt No. field.';
                    ApplicationArea = All;
                }
                field("Posting Date";Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.';
                    ApplicationArea = All;
                }
                field("Currency Code";Rec."Currency Code")
                {
                    ApplicationArea = All;
                }
                field("Total Amount";Rec."Remaining Amount")
                {
                    Caption = 'Remaining Amount';
                }
                field("Blanket Order No.";Rec."Blanket Order No.")
                {
                    ApplicationArea = All;
                }
                field("Remaining Amount";Rec."Remaining Amount")
                {
                    ApplicationArea = All;
                }
            }
            part(Lines;"Payment Lines")
            {
                SubPageLink = "Document No."=field("Receipt No.");
                UpdatePropagation = SubPart;
                ApplicationArea = All;
            // Editable = false;
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Tender)
            {
                Image = PaymentJournal;
                Caption = 'Tender';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()var Tender: Page Tendering;
                PaymentLine2: Record "Payment Line";
                begin
                    Rec.CalcFields("Remaining Amount");
                    Tender.Initialize(Rec."Remaining Amount", Rec."Currency Code");
                    if not(Tender.RunModal() = Action::OK)then exit;
                    Tender.GetDetails(PaymentSubtype, AmtTendered, AmtTenderedLCY, ActualPostingDate, ActualAccountNo, TenderCurrCode);
                    PaymentLine.SetRange("Documnent Type", Rec."Document Type");
                    PaymentLine.SetRange("Document No.", Rec."Receipt No.");
                    if PaymentLine.FindLast()then begin
                        PaymentLine2."Document No.":=Rec."Receipt No.";
                        PaymentLine2."Documnent Type":=Rec."Document Type";
                        PaymentLine2."Line No.":=PaymentLine."Line No." + 10000;
                        PaymentLine2."Line Type":=PaymentLine2."Line Type"::Payment;
                        PaymentLine2."Payment SubType":=PaymentSubtype;
                        PaymentLine2."Line Amount":=-AmtTendered;
                        PaymentLine2."Line Amount LCY":=-AmtTenderedLCY;
                        PaymentLine2."Payment Account No.":=ActualAccountNo;
                        PaymentLine2."Currency Code":=TenderCurrCode;
                        PaymentLine2."Posting Date":=ActualPostingDate;
                        PaymentLine2.Description:='Payment';
                        PaymentLine2.Insert();
                    end;
                end;
            }
            action(Post)
            {
                Caption = 'Post & Print';
                ToolTip = 'Post Payment Lines';
                Image = PostApplication;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()var CustomSalesFunctions: Codeunit "Custom Sales Functions";
                begin
                    CustomSalesFunctions.PostPayment(Rec);
                end;
            }
            action(Print)
            {
                Caption = 'Print Payment Receipt';
                ToolTip = 'Print Payment Receipt';
                Image = Print;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;

                // Visible = false;
                trigger OnAction()var PaymentReceipt: Report "Payment Receipt";
                PaymentHdrRec: record "Payment Header";
                begin
                    Rec.TestField(Closed, true);
                    Rec.SetRange("Receipt No.", Rec."Receipt No.");
                    Rec.SetRecFilter();
                    Report.Run(report::"Payment Receipt", true, false, Rec);
                end;
            }
        }
    }
    var PaymentSubtype: Enum "Payment SubType";
    AmtTendered: Decimal;
    AmtTenderedLCY: Decimal;
    ActualPostingDate: Date;
    ActualAccountNo: Code[20];
    PaymentLine: Record "Payment Line";
    TenderCurrCode: Code[20];
}
