report 50002 "Release Memo Global Pick Slip"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Release Memo Global Pick Slip.rdl';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Sales Header";"Sales Header")
        {
            column(ReportCaption;ReportCaption)
            {
            }
            column(CompanyInfo_Name;CompanyInfo.Name)
            {
            }
            column(CompanyInfo_Picture;CompanyInfo.Picture)
            {
            }
            column(CompanyInfo_Address;CompanyInfo.Address)
            {
            }
            column(CompanyInfo_Address2;CompanyInfo."Address 2")
            {
            }
            column(CompanyInfo_City;CompanyInfo.City)
            {
            }
            column(CompanyInfo_Phone;CompanyInfo."Phone No.")
            {
            }
            column(HQ_Sup__Ref;"HQ Sup. Ref")
            {
            }
            column(Receipt_No_;"Receipt No.")
            {
            }
            column(Sell_to_Customer_Name;"Sell-to Customer Name")
            {
            }
            column(Sell_to_Post_Code;"Sell-to Post Code")
            {
            }
            column(Document_Date;"Document Date")
            {
            }
            column(No_;"No.")
            {
            }
            column(Blanket_Order_No_;"Blanket Order No.")
            {
            }
            column(Zimra_Bill_of_Entry_Ref__No_;"Zimra Bill of Entry/Ref. No.")
            {
            }
            column(Product_To_Load;"Product To Load")
            {
            }
            dataitem("Sales Line";"Sales Line")
            {
                DataItemLink = "Document No."=FIELD("No.");
                DataItemTableView = WHERE(Type=CONST(Item), "Document Type"=CONST(Order));

                column(Quantity_SalesLine;"Sales Line".Quantity)
                {
                }
                column(OutstandingQuantity_SalesLine;"Sales Line"."Outstanding Quantity")
                {
                }
                column(UnitofMeasure_SalesLine;"Sales Line"."Unit of Measure")
                {
                }
                column(No_SalesLine;"Sales Line"."No.")
                {
                }
                column(LocationCode_SalesLine;"Sales Line"."Location Code")
                {
                }
                column(Description_SalesLine;"Sales Line".Description)
                {
                }
                column(QuantityShipped_SalesLine;"Sales Line"."Quantity Shipped")
                {
                }
            }
            trigger OnAfterGetRecord()begin
                BalanceAt20:="Sales Header".QtyToLoad;
                BalanceAtAmbient:=BalanceAt20;
            end;
        }
    }
    requestpage
    {
        layout
        {
        }
        actions
        {
        }
    }
    labels
    {
    }
    trigger OnInitReport()begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;
    trigger OnPreReport()begin
        BalanceAt20:=0;
        BalanceAtAmbient:=0;
    end;
    var Item: Record item;
    CompanyInfo: Record "Company Information";
    ReportCaption: Label 'Product Release Memo Global Pick Slip';
    BalanceAtAmbient: Decimal;
    BalanceAt20: Decimal;
}
