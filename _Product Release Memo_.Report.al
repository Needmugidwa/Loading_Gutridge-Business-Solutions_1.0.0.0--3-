report 50104 "Product Release Memo"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Product Release Memo New.rdl';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            column(No_; "No.")
            {
            }
            column(Sell_to_Customer_No_; "Sell-to Customer No.")
            {
            }
            column(Sell_to_Customer_Name; "Sell-to Customer Name")
            {
            }
            column(Blanket_Order_No_; "Blanket Order No.")
            {
            }
            column(Receipt_No_; "Receipt No.")
            {
            }
            column(Payment_Receipt_No_; "Payment Receipt No.")
            {
            }
            column(HQ_Sup__Ref; "HQ Sup. Ref")
            {
            }
            column(Location_Code; "Location Code")
            {
            }
            Column(QtyToLoad; QtyToLoad)
            {
            }
            column(Loading_Authority; "Loading Authority")
            {
            }
            column(Location_Name; "Location Name")
            {
            }
            column(TIME; TIME)
            {
            }
            column(USERID; USERID)
            {
            }
            column(ReportCaption; ReportCaption)
            {
            }
            column(CompanyInfo_Name; CompanyInfo.Name)
            {
            }
            column(CompanyInfo_Picture; CompanyInfo.Picture)
            {
            }
            column(CompanyInfo_Address; CompanyInfo.Address)
            {
            }
            column(CompanyInfo_Address2; CompanyInfo."Address 2")
            {
            }
            column(CompanyInfo_City; CompanyInfo.City)
            {
            }
            column(CompanyInfo_Phone; CompanyInfo."Phone No.")
            {
            }
            column(CompanyInfo1_Picture; CompanyInfo.Picture)
            {
            }
            column(SIGNATURE__Caption; SIGNATURE__CaptionLbl)
            {
            }
            column(Document_Date; "Document Date")
            {
            }
            column(Document_DateLbl; Document_DateLbl)
            {
            }
            column(ConsigneeCaption; ConsigneeCaption)
            {
            }
            column(DescriptionCaption; DescriptionCaption)
            {
            }
            column(Customer_NameCaption; Customer_NameCaption)
            {
            }
            column(itemNo_Caption; itemNo_Caption)
            {
            }
            column(HQ_Ref_CAption; HQ_Ref_CAption)
            {
            }
            column(Product_To_Load; "Product To Load")
            {
            }
            column(QtyToLoad_Caption; QtyToLoad_Caption)
            {
            }
            column(Release_Memo_No_CaptionLbl; Release_Memo_No_CaptionLbl)
            {
            }
            column(CreatedBy; CreatedBy)
            {
            }
            column(FinanceApprover; FinanceApprover)
            {
            }
            column(ApprovedBy; ApprovedBy)
            {
            }
            column(FinanceApproverSignature; User1.Signature)
            {
            }
            column(ApprovedBySignature; User2.Signature)
            {
            }

            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = SORTING("No.") WHERE("Type" = CONST("item"));

                column(Document_No_; "Document No.")
                {
                }
                column(Description; Description)
                {
                }
                column(Quantity; Quantity)
                {
                }
                column(Qty__to_Load; "Qty. to Load")
                {
                }
                column(Item_No_; "No.")
                {
                }
                column(Location_Code1; "Location Code")
                {
                }
                column(Qty__to_Ship; "Qty. to Ship")
                {
                }
            }
            trigger onAfterGetRecord()
            var
                ApprovalEntry: Record 454;
            begin
                //location1.SetRange(Rec."Location Code");
                //>>LAW18.00
                ApprovalEntry.RESET;
                ApprovalEntry.SETRANGE("Sequence No.", 2);
                ApprovalEntry.SETRANGE("Document No.", "Sales Header"."No.");
                IF ApprovalEntry.FINDFIRST THEN BEGIN
                    CreatedBy := ApprovalEntry."Sender ID";
                    FinanceApprover := ApprovalEntry."Approver ID";
                END;
                ApprovalEntry.RESET;
                ApprovalEntry.SETRANGE("Document No.", "Sales Header"."No.");
                IF ApprovalEntry.FINDLAST THEN ApprovedBy := ApprovalEntry."Approver ID";
                User1.RESET;
                User1.SETRANGE("User ID", FinanceApprover);
                IF User1.FINDFIRST THEN
                    User1.CALCFIELDS(Signature);
                User2.RESET;
                User2.SETRANGE("User ID", ApprovedBy);
                IF User2.FINDFIRST THEN
                    User2.CALCFIELDS(Signature);
                //<<LAW18.00
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
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    trigger onPreReport()
    var
        myInt: Integer;
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;

    var
        myInt: Integer;
        CompanyInfo: REcord "Company Information";
        //  User1: Record 2000000120;

        user1: Record "User Setup";
        user2: Record "user setup";


        CreatedBy: Code[50];
        ApprovedBy: Code[50];
        FinanceApprover: Code[10];


        ReportCaption: label 'Product Release Memo';
        TotalCaption: label 'Total Quantity';
        SIGNATURE__CaptionLbl: Label 'SIGNATURE:';
        "Location Name": Text[50];
        location1: Record Location;
        Release_Memo_No_CaptionLbl: Label 'Release Memo No.';
        Document_DateLbl: Label 'Date';
        ConsigneeCaption: label 'Consignee';
        Customer_NoCaption: label 'Customer No.';
        Customer_NameCaption: label 'Customer Name';
        HQ_Ref_CAption: label 'HQ Ref Caption';
        itemNo_Caption: label 'Item No Caption';
        DescriptionCaption: Label 'Discription';
        QtyToLoad_Caption: label 'Quantity to load';
}
