report 50101 "Payment Receipt 1"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = './Payment Receipt 2.rdl';
    Caption = 'Payment Receipt';
    PreviewMode = PrintLayout;
    dataset
    {
        dataitem(Payment_Header; "Payment Header")
        {

            column(Receipt_No; "Receipt No.")
            {

            }
            column(DocumentType; "Document Type")
            {

            }
            column(Total_Amount; "Document Type")
            {

            }
            column(Customer_No; "Customer No.")
            {

            }
            column(CustomerNoLbl; CustomerNoLbl)
            {

            }
            column(Blanket_Order_No_; "Blanket Order No.")
            {

            }
            column(Source_No_; "Source No.") { }

            column(Currency_Code; "Currency Code")
            {

            }
            column(Posting_Date; "Posting Date")
            {

            }
            column(Customer_Address; Customer_Address)
            {

            }
            column(Customer_Name; Customer_Name)
            {

            }
            column(Customer_Name2; Customer_Name2)
            {

            }
            column(companyName; CompanyInfo.Name)
            {

            }
            column(CompanyAddress1; CompanyAddr[1])
            {
            }
            column(CompanyAddress2; CompanyAddr[2])
            {
            }
            column(CompanyAddress3; CompanyAddr[3])
            {
            }
            column(CompanyAddress4; CompanyAddr[4])
            {
            }
            column(CompanyAddress5; CompanyAddr[5])
            {
            }
            column(CompanyAddress6; CompanyAddr[6])
            {
            }
            column(CompanyAddress7; CompanyAddr[7])
            {
            }
            column(CompanyAddress8; CompanyAddr[8])
            {
            }



            column(CompanyHomePage; CompanyInfo."Home Page")

            {
            }
            column(companyPicture; companyInfo.Picture)
            {

            }
            column(CompanyEMail; CompanyInfo."E-Mail")
            {
            }

            column(CompanyPhoneNo; CompanyInfo."Phone No.")
            {
            }

            column(CompanyGiroNo; CompanyInfo."Giro No.")
            {
            }

            column(CompanyBankName; CompanyInfo."Bank Name")
            {
            }

            column(CompanyBankBranchNo; CompanyInfo."Bank Branch No.")
            {
            }
            column(CompanyBankBranchNo_Lbl; CompanyInfo.FieldCaption("Bank Branch No."))
            {
            }
            column(CompanyBankAccountNo; CompanyInfo."Bank Account No.")
            {
            }

            column(CompanyIBAN; CompanyInfo.IBAN)
            {
            }
            column(CompanyIBAN_Lbl; CompanyInfo.FieldCaption(IBAN))
            {
            }
            column(CompanySWIFT; CompanyInfo."SWIFT Code")
            {
            }
            column(CompanySWIFT_Lbl; CompanyInfo.FieldCaption("SWIFT Code"))
            {
            }

            column(CompanyRegistrationNumber; CompanyInfo.GetRegistrationNumber)
            {
            }
            column(CompanyRegistrationNumber_Lbl; CompanyInfo.GetRegistrationNumberLbl)
            {
            }
            column(CompanyVATRegNo; CompanyInfo.GetVATRegistrationNumber)
            {
            }
            column(CompanyVATRegNo_Lbl; CompanyInfo.GetVATRegistrationNumberLbl)
            {
            }
            column(CompanyVATRegistrationNo; CompanyInfo.GetVATRegistrationNumber)
            {
            }
            column(CompanyVATRegistrationNo_Lbl; CompanyInfo.GetVATRegistrationNumberLbl)
            {
            }
            column(CompanyLegalOffice; CompanyInfo.GetLegalOffice)
            {
            }
            column(CompanyLegalOffice_Lbl; CompanyInfo.GetLegalOfficeLbl)
            {
            }
            column(CompanyCustomGiro; CompanyInfo.GetCustomGiro)
            {
            }
            column(CompanyCustomGiro_Lbl; CompanyInfo.GetCustomGiroLbl)
            {
            }
            column(DocumentTittlelbl; DocumentTittlelbl)
            {

            }
            column(Receipt_NoLbl; Receipt_NoLbl)
            {

            }
            column(ReceiptDateLbl; ReceiptDateLbl)
            {

            }
            column(TotalAmountlbl; TotalAmountlbl)
            {

            }
            dataitem("Payment line"; "Payment Line")
            {

                DataItemLink = "Documnent Type" = FIELD("Document Type"), "Document No." = FIELD("Receipt No.");
                DataItemLinkReference = Payment_Header;
                DataItemTableView = SORTING("Document No.") where("LIne Type" = Const("Payment"));


                column(Document_No_; "Document No.")
                {

                }
                column(No_; "No.")
                {

                }
                column(Document_Type; "Documnent Type")
                {

                }

                column(Description; Description)
                {

                }
                column(Quantity; Quantity)
                {

                }
                column(Unit_Price; "Unit Price")
                {

                }
                column(Line_Amount; "Line Amount")
                {

                }
                Column(Payment_SubType; "Payment SubType")
                {

                }
                column(Payment_Account_No_; "Payment Account No.")
                {

                }



            }
            trigger OnPreDataItem()
            var
            Begin

                CompanyInfo.get();
                FormatAddr.Company(CompanyAddr, CompanyInfo);

            End;

            trigger OnAfterGetRecord()
            var

            begin
                //Customer1.SetFilter("No.", "Customer No.");
                customerInfo.Get("Customer No.");
                Customer_Name := customerInfo.Name;
                Customer_Name2 := Customerinfo."Name 2";

            end;

        }
    }

    trigger OnInitReport()
    begin

        CompanyInfo.SetAutoCalcFields(Picture);

    end;

    var
        myInt: Integer;
        CompanyInfo: Record "Company Information";
        CompanyAddr: array[8] of Text[100];
        customerInfo: Record customer;

        Customer_Name: Text[100];
        Customer_Name2: Text[100];
        Customer_Address: Text[100];
        Customer_Address2: Text[100];
        DocumentDatelbl: label 'Document Date';
        DocumentTittlelbl: label 'Payment Receipt';
        ReceiptNoLbl: label 'Receipt No';

        TotalAmountlbl: label 'Total Amount';

        Receipt_NoLbl: label 'Receipt No';

        ReceiptDateLbl: label 'Receipt Date';
        CustomerNoLbl: label 'Customer No';

        Paymentreceipt: Label 'Payment Receipt';

        FormatAddr: Codeunit "Format Address";

}