page 50167 "Tendering"
{
    PageType = StandardDialog;

    layout
    {
        area(Content)
        {
            field(RemainingAmt;RemainingAmt)
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Remaining Amount';
            }
            field(DocCurrency;DocCurrency)
            {
                TableRelation = Currency;
                Editable = false;
                Caption = 'Document Currency';
                ApplicationArea = All;
            }
            field(PaymentSubtype;PaymentSubtype)
            {
                ApplicationArea = All;
                // Editable = false;
                Caption = 'Payment SubType';
            }
            field(PostingDate;PostingDate)
            {
                Caption = 'Posting Date';
                ApplicationArea = All;
            }
            field(AccountNo;AccountNo)
            {
                Caption = 'Account No.';
                TableRelation = "Bank Account";
                ApplicationArea = All;

                trigger OnDrillDown()begin
                    if PaymentSubtype = PaymentSubtype::Cash then Error('Cannot Choose Bank Account when type is Cash');
                end;
            }
            field(TenderCurrency;TenderCurrency)
            {
                TableRelation = Currency;
                Caption = 'Tendering Currency';
                ApplicationArea = All;
            }
            field(Amount;Amount)
            {
                ApplicationArea = All;
                //Editable = ActionType = ActionType::Defer;
                Caption = 'Amount Tendered';

                trigger OnValidate()var CurrExchRate: Record "Currency Exchange Rate";
                Rate: Decimal;
                begin
                    // Rate := CurrExchRate.ExchangeRate(PostingDate, TenderCurrency);
                    AmountLCY:=CurrExchRate.ExchangeAmtFCYToFCY(PostingDate, DocCurrency, TenderCurrency, Amount);
                end;
            }
            field(AmountLCY;AmountLCY)
            {
                ApplicationArea = All;
                //Editable = ActionType = ActionType::Defer;
                Caption = 'Amount LCY';
                Editable = false;
            }
        }
    }
    /// <summary>
 
/// Initialize. 
 
/// </summary>
 
/// <param name="RemainingAmt1">Decimal.</param>
 
/// <param name="DocCurrency1">Code[20].</param>
 procedure Initialize(RemainingAmt1: Decimal;
    DocCurrency1: Code[20])begin
        RemainingAmt:=RemainingAmt1;
        PaymentSubType:=PaymentSubType::" ";
        Amount:=0;
        PostingDate:=0D;
        DocCurrency:=DocCurrency1;
    end;
    /// <summary>
 
/// GetDetails. 
 
/// </summary>
 
/// <param name="Var ActualPaymentSubtype">Enum "Payment SubType".</param>
 
/// <param name="Var ActualTendered">Decimal.</param>
 
/// <param name="Var ActualTenderedLCY">Decimal.</param>
 
/// <param name="ActualPostingDate">VAR Date.</param>
 
/// <param name="ActualAccountNo">VAR Code[20].</param>
 
/// <param name="TenderCurrCode">VAR Code[20].</param>
 procedure GetDetails(Var ActualPaymentSubtype: Enum "Payment SubType";
    Var ActualTendered: Decimal;
    Var ActualTenderedLCY1: Decimal;
    var ActualPostingDate: Date;
    var ActualAccountNo: Code[20];
    var TenderCurrCode: Code[20])begin
        ActualPaymentSubtype:=PaymentSubtype;
        ActualTendered:=Amount;
        ActualTenderedLCY1:=AmountLCY;
        ActualPostingDate:=PostingDate;
        ActualAccountNo:=AccountNo;
    end;
    var PaymentSubtype: Enum "Payment SubType";
    PostingDate: Date;
    Amount: Decimal;
    RemainingAmt: Decimal;
    ActionName: Text;
    AccountNo: Code[20];
    AmountLCY: Decimal;
    TenderCurrency: Code[20];
    DocCurrency: Code[20];
}
