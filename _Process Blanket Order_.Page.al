page 50166 "Process Blanket Order"
{
    PageType = StandardDialog;

    layout
    {
        area(Content)
        {
            field(BlanketOrderNo;BlanketOrderNo)
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Blanket Sales Order No.';
                visible = false;
            }
            field(ActionType;ActionType)
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Type';
                visible = false;
            }
            field(ActionDate;PostingDate)
            {
                ApplicationArea = All;
                // Editable = ActionType = ActionType::Defer;
                Visible = false;
                Caption = ' Posting Date';
            }
            field(AllServiceCharges;AllServiceCharges)
            {
                Caption = 'All Service Charges';
                Visible = ActionType = ActionType::Quote;
                ApplicationArea = All;

                trigger OnValidate()begin
                    if AllServiceCharges then begin
                        ZinaraCharges:=true;
                        DutyCharges:=true;
                        PipelineCharges:=true;
                        StorageCharges:=true;
                        StorageForeign:=true;
                        PipelineForeign:=true;
                    end
                    else
                    begin
                        ZinaraCharges:=false;
                        DutyCharges:=false;
                        PipelineCharges:=false;
                        StorageCharges:=false;
                        StorageForeign:=false;
                        PipelineForeign:=false;
                    end;
                end;
            }
            field(DutyCharges;DutyCharges)
            {
                Caption = 'Duty Charges';
                Visible = ActionType = ActionType::Quote;
                ApplicationArea = All;

                trigger OnValidate()begin
                    if not DutyCharges then AllServiceCharges:=false;
                end;
            }
            field(StorageCharges;StorageCharges)
            {
                Caption = 'Storage And Handling Charges - Local';
                Visible = ActionType = ActionType::Quote;
                ApplicationArea = All;

                trigger OnValidate()begin
                    if not StorageCharges then AllServiceCharges:=false;
                end;
            }
            field(StorageForeign;StorageForeign)
            {
                Caption = 'Storage And Handling Charges - Foreign';
                Visible = ActionType = ActionType::Quote;
                ApplicationArea = All;

                trigger OnValidate()begin
                    if not StorageForeign then AllServiceCharges:=false;
                end;
            }
            field(ZinaraCharges;ZinaraCharges)
            {
                Caption = 'Zinara Charges';
                Visible = ActionType = ActionType::Quote;
                ApplicationArea = All;

                trigger OnValidate()begin
                    if not ZinaraCharges then AllServiceCharges:=false;
                end;
            }
            field(PipelineCharges;PipelineCharges)
            {
                Caption = 'Pipeline Charges - Local';
                Visible = ActionType = ActionType::Quote;
                ApplicationArea = All;

                trigger OnValidate()begin
                    if not PipelineCharges then AllServiceCharges:=false;
                end;
            }
            field(PipelineForeign;PipelineForeign)
            {
                Caption = 'Pipeline Charges - Foreign';
                ApplicationArea = All;

                trigger OnValidate()begin
                    if not PipelineForeign then AllServiceCharges:=false;
                end;
            }
            field(AccountType;AccountType)
            {
                Caption = 'Account Type';
                Visible = false;
                ApplicationArea = All;
            }
            field(AccountNo;AccountNo)
            {
                Caption = 'Account No.';
                Visible = false;
                ApplicationArea = All;
            }
            field(ShortcutDim1Code;ShortcutDim1Code)
            {
                CaptionClass = '1,2,1';
                Visible = false;
            // TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1), Blocked = const(false));
            }
            field(ShortcutDim2Code;ShortcutDim2Code)
            {
                CaptionClass = '1,2,2';
                Visible = false;
                TableRelation = "Dimension Value".Code where("Global Dimension No."=const(2), Blocked=const(false));
            }
        }
    }
    /// <summary>
 
/// Initialize. 
 
/// </summary>
 
/// <param name="PMNo">Code[20].</param>
 
/// <param name="ActType">Enum "Blanket Order Actions".</param>
 
/// <param name="ActDate">Date.</param>
 procedure Initialize(PMNo: Code[20];
    ActType: Enum "Blanket Order Actions";
    ActDate: Date)begin
        BlanketOrderNo:=PMNo;
        ActionType:=ActType;
        PostingDate:=ActDate;
        AllServiceCharges:=false;
        ZinaraCharges:=false;
        PipelineCharges:=false;
        StorageCharges:=false;
        DutyCharges:=false;
        PipelineForeign:=false;
        StorageForeign:=false;
    end;
    /// <summary>
 
/// GetDetails. 
 
/// </summary>
 
/// <param name="Var AllServiceCharges1">Boolean.</param>
 
/// <param name="Var ZinaraCharges1">Boolean.</param>
 
/// <param name="Var PipelineCharges1">Boolean.</param>
 
/// <param name="Var StorageCharges1">Boolean.</param>
 
/// <param name="Var DutyCharges1">Boolean.</param>
 
/// <param name="PipelineForeign1">VAR Boolean.</param>
 
/// <param name="StorageForeign1">VAR Boolean.</param>
 procedure GetDetails(Var AllServiceCharges1: Boolean;
    Var ZinaraCharges1: Boolean;
    Var PipelineCharges1: Boolean;
    Var StorageCharges1: Boolean;
    Var DutyCharges1: Boolean;
    var PipelineForeign1: Boolean;
    var StorageForeign1: Boolean)begin
        AllServiceCharges1:=AllServiceCharges;
        ZinaraCharges1:=ZinaraCharges;
        PipelineCharges1:=PipelineCharges;
        StorageCharges1:=StorageCharges;
        DutyCharges1:=DutyCharges;
        PipelineForeign1:=PipelineForeign;
        StorageForeign1:=StorageForeign;
    end;
    var ActionType: Enum "Blanket Order Actions";
    PostingDate: Date;
    Amount: Decimal;
    BlanketOrderNo: Code[20];
    ActionName: Text;
    AllServiceCharges: Boolean;
    ZinaraCharges: Boolean;
    PipelineCharges: Boolean;
    StorageCharges: Boolean;
    DutyCharges: Boolean;
    PaymentMethod: Code[20];
    AccountType: Enum "Gen. Journal Account Type";
    AccountNo: Code[20];
    ShortcutDim1Code: Code[20];
    ShortcutDim2Code: Code[20];
    PipelineForeign: Boolean;
    StorageForeign: Boolean;
}
