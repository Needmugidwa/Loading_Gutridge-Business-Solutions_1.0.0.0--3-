tableextension 50143 UserSetup extends "User Setup"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Allow Posting"; Boolean)
        {
        }
        field(50001; "Allow Lookup"; Boolean)
        {
        }
        field(50002; "Allow UnArchiving"; Boolean)
        {
        }
        field(50003; "Allow Gen. Jnl. Posting"; Boolean)
        {
            Description = 'IG Request 13.05.14';
        }
        field(50004; "Allow Pay/Receipt Jnl. Posting"; Boolean)
        {
            Description = 'IG Request 13.05.14';
        }
        field(50005; "Allow Item Jnl. Posting"; Boolean)
        {
            Description = 'IG Request 13.05.14';
        }
        field(50006; "Allow Vendor Card Editing"; Boolean)
        {
            Description = 'IG Request 13.05.14';
        }
        field(50007; "Allow Customer Card Editing"; Boolean)
        {
            Description = 'IG Request 13.05.14';
        }
        field(50008; "Allow Sales Jnl. Posting"; Boolean)
        {
            Description = 'IG Request 19.05.14';
        }
        field(50009; "Allow Purch. Jnl. Posting"; Boolean)
        {
            Description = 'IG Request 19.05.14';
        }
        field(50010; "Allow Purch. Req. Editing"; Boolean)
        {
            Description = 'IG Request 07.07.14';
        }
        field(50011; "View All Sales Orders"; Boolean)
        {
        }
        field(50012; "Allow Stock Req Editing"; Boolean)
        {
        }
        field(50013; "Stock Amount Approval Limit"; Integer)
        {
            BlankZero = true;
        }
        field(50014; "Unlimited Stock Approval"; Boolean)
        {
        }
        field(50015; "Stock Approval ID"; Code[20])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(50016; "Stock Substitute"; Code[20])
        {
            TableRelation = "User Setup";
        }
        field(50017; "Coupon Additional Approver"; Code[20])
        {
            Description = 'KG FCMW18.00';
            TableRelation = "User Setup";
        }
        field(50018; "Allow Product Rel Memo Editing"; Boolean)
        {
        }
        field(50019; "Prd. Rel. Amnt Approval Limit"; Integer)
        {
            BlankZero = true;

            trigger OnValidate()
            begin
                "Unlimited Rel. Memo Approval" := false;
                Modify;
            end;
        }
        field(50020; "Unlimited Rel. Memo Approval"; Boolean)
        {
            trigger OnValidate()
            begin
                "Prd. Rel. Amnt Approval Limit" := 0;
                Modify;
            end;
        }
        field(50021; "Release Memo Approval ID"; Code[20])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(50022; "Release Memo Substitute"; Code[20])
        {
            TableRelation = "User Setup";
        }
        field(50023; "Allow Statutory Setup Editing"; Boolean)
        {
            Description = 'StatutoryW18.00';
        }
        field(50024; "Allow Purch. Order Receiving"; Boolean)
        {
        }
        field(50025; "Allow Purch. Order Invoicing"; Boolean)
        {
        }
        field(50026; "View Loading Signatures"; Boolean)
        {
            Caption = 'View Customer Loading Authorisation Signatures';
            Description = 'LAW20.00';
        }
        field(50027; "Allow PRM Re-assign location"; Boolean)
        {
            Description = 'LoadingW20.10';
        }
        field(50028; "Allow Driver Management"; Boolean)
        {
            Description = 'LoadingW20.10';
        }
        field(50029; "Allow Signature Management"; Boolean)
        {
            Description = 'LoadingW20.10';
        }
        field(50030; "Allow Background Package Proc."; Boolean)
        {
            Description = 'Allow Background Package Processing';
        }
        field(50031; "Allow Posting Without Loading"; Boolean)
        {
            Description = 'LoadingW20.11';
        }
        field(50032; "View All Inv. Posting Groups"; Boolean)
        {
            Description = 'KG';
        }
    }
    var
        myInt: Integer;
}
