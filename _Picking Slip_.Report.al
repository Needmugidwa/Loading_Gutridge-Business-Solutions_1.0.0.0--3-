report 50003 "Picking Slip"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './Picking Instruction.rdl';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Pick Instruction Header"; "Pick Instruction Header")
        {
            column(No_; "No.")
            {
            }
            column(Source_Type; "Source Type")
            {
            }
            column(Document_Date; "Document Date")
            {
            }
            column(Total_Qty_to_Load; "Total Qty to Load")
            {
            }
            column(Item_No_; "Item No.")
            {
            }
            column(item_Name; "Item Name")
            {
            }
            column(Outstanding_Quantity; "Outstanding Quantity")
            {
            }
            column(Meter_Code; "Meter Code")
            {
            }
            column(Loader; Loader)
            {
            }
            column(Dipper; Dipper)
            {
            }
            column(Sealer; Sealer)
            {
            }
            column(Transporter_Code; "Transporter Code")
            {
            }
            column(Transporter_Name; "Transporter Name")
            {
            }
            column(Horse_Registration_No_; "Horse Registration No.")
            {
            }

            column(Driver_Code; "Driver Code")
            {
            }
            column(TrailerRegistrationNo_PickInstructionHeader; "Trailer Registration No.")
            {
            }
            column(Driver_ID; "Driver ID")
            {
            }
            column(Driver_Name; "Driver Name")
            {
            }
            column(Customer_Name; "Customer Name")
            {
            }
            column(Customer_No_; "Customer No.")
            {
            }
            column(Customer_Group; "Customer Group")
            {
            }
            column(Loading_Authority_No_; "Loading Authority No.")
            {
            }
            column(Loading_Location; "Loading Location")
            {
            }
            column(companyName; CompInfo.Name)
            {
            }
            column(CompanyAddress1; Compinfo.Address)
            {
            }
            column(CompanyAddress2; compinfo."Address 2")
            {
            }
            column(CompanyCity; Compinfo.City)
            {
            }
            column(CompanyEmail; Compinfo."E-Mail")
            {
            }
            column(CompanyPhone; Compinfo."Phone No.")
            {
            }
            column(CompanyPicture; CompInfo.Picture)
            {
            }
            column(LoaderSignature; Person1.Signature)
            {

            }
            column(DipperSignature; person2.signature)
            {

            }
            column(SealerSignature; person3.Signature)
            {

            }
            dataitem("Pick Instruction Line"; "Pick Instruction Line")
            {
                DataItemLink = "Document No." = field("No.");

                // DataItemLinkReference = "Pick Instruction Header";
                column(Document_No_; "Document No.")
                {
                }
                column(Line_No_; "Line No.")
                {
                }
                column(Qty_To_Load; "Qty To Load")
                {
                }
                column(Order_No_; "Order No.")
                {
                }
                column(Qty__Loaded_____20; "Qty. Loaded - @ 20")
                {
                }
                column(Qty__Loaded___Ambient; "Qty. Loaded - Ambient")
                {
                }
                column(Customer_No_line; "Customer No.")
                {
                }
            }
            trigger OnPreDataItem()
            var
            Begin
                CompInfo.get();
            End;

            trigger OnAfterGetRecord()
            begin
                item.GET("Item No.");
                "Item Name" := item.Description;
                Cust.GET("Customer No.");
                "Customer Group" := Cust."Customer Posting Group";

                Person1.Reset();
                Person1.SetRange("User ID", Loader);
                if Person1.FindFirst() then
                    Person1.CalcFields(Signature);

                Person2.Reset();
                Person2.SetRange("User ID", Dipper);

                Person3.Reset();
                Person3.SetRange("User ID", Sealer);

            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
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
    trigger OnInitReport()
    begin
        CompInfo.Get;
        CompInfo.SetAutoCalcFields(Picture);
    end;

    var
        myInt: Integer;
        CompInfo: Record "Company Information";
        "Item Name": Text[100];
        item: record item;
        Cust: record Customer;
        "Customer Group": Code[20];
        Person1: Record "Loading Personnel";
        person2: Record "Loading Personnel";
        Person3: Record "Loading Personnel";
}
