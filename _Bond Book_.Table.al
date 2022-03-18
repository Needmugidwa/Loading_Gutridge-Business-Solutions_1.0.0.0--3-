table 50106 "Bond Book"
{
    fields
    {
        field(1;"Item No.";Code[20])
        {
            Editable = false;
            NotBlank = true;
            TableRelation = Item;
        }
        field(2;Date;Date)
        {
            Editable = false;
        }
        field(3;"Opening Stock Date Filter";Text[50])
        {
            Editable = false;
        }
        field(4;"Closing Stock Date Filter";Text[50])
        {
            Editable = false;
        }
        field(5;"Purchase Receipts (Qty.)";Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No."=FIELD("Item No."), "Posting Date"=FIELD(Date), "Entry Type"=FILTER(Purchase), Positive=FILTER(true), "Location Code"=FIELD("Location Code")));
            Caption = 'Total Receipts';
            Description = 'Receipts';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6;"Positive Adjustments (Qty.)";Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No."=FIELD("Item No."), "Posting Date"=FIELD(Date), "Location Code"=FIELD("Location Code"), "Entry Type"=FILTER("Positive Adjmt.")));
            Description = 'Receipts';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7;"Transfer Receipts (Qty.)";Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No."=FIELD("Item No."), "Posting Date"=FIELD(Date), "Entry Type"=FILTER(Transfer), Positive=FILTER(true), "Location Code"=FIELD("Location Code")));
            Description = 'Receipts';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8;"I/R Receipts (Qty.)";Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No."=FIELD("Item No."), "Posting Date"=FIELD(Date), "Entry Type"=FILTER("Assembly Output"), "Location Code"=FIELD("Location Code")));
            Caption = 'Own Use Receipts';
            Description = 'Receipts';
            Editable = false;
            FieldClass = FlowField;
        }
        field(9;"Sales Returns (Qty.)";Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No."=FIELD("Item No."), "Posting Date"=FIELD(Date), "Entry Type"=FILTER(Sale), "Location Code"=FIELD("Location Code"), Positive=FILTER(true)));
            Caption = 'Suckback';
            Description = 'Receipts';
            Editable = false;
            FieldClass = FlowField;
        }
        field(20;"Sales (Qty.)";Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No."=FIELD("Item No."), "Posting Date"=FIELD(Date), "Entry Type"=FILTER(Sale), "Location Code"=FIELD("Location Code"), Positive=FILTER(false)));
            Caption = 'Total Withdrawals';
            Description = 'Withdrawals';
            Editable = false;
            FieldClass = FlowField;
        }
        field(21;"Negative Adjustments (Qty.)";Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No."=FIELD("Item No."), "Posting Date"=FIELD(Date), "Location Code"=FIELD("Location Code"), "Entry Type"=FILTER("Negative Adjmt.")));
            Description = 'Withdrawals';
            Editable = false;
            FieldClass = FlowField;
        }
        field(22;"Transfer Shipments (Qty.)";Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No."=FIELD("Item No."), "Posting Date"=FIELD(Date), "Entry Type"=FILTER(Transfer), Positive=FILTER(false), "Location Code"=FIELD("Location Code")));
            Description = 'Withdrawals';
            Editable = false;
            FieldClass = FlowField;
        }
        field(23;"I/R Issues (Qty.)";Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No."=FIELD("Item No."), "Posting Date"=FIELD(Date), "Entry Type"=FILTER("Assembly Consumption"), "Location Code"=FIELD("Location Code")));
            Caption = 'Own Use Withdrawals';
            Description = 'Withdrawals';
            Editable = false;
            FieldClass = FlowField;
        }
        field(24;"Purchases Returns (Qty.)";Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No."=FIELD("Item No."), "Posting Date"=FIELD(Date), "Entry Type"=FILTER(Purchase), Positive=FILTER(false), "Location Code"=FIELD("Location Code")));
            Caption = 'Purchase Fuel Returns';
            Description = 'Withdrawals';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50;"Opening Stock (Qty.)";Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No."=FIELD("Item No."), "Location Code"=FIELD("Location Code"), "Posting Date"=FIELD(FILTER("Opening Stock Date Filter"))));
            Editable = false;
            FieldClass = FlowField;
        }
        field(51;"Closing Stock (Qty.)";Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No."=FIELD("Item No."), "Location Code"=FIELD("Location Code"), "Posting Date"=FIELD(FILTER("Closing Stock Date Filter"))));
            Editable = false;
            FieldClass = FlowField;
        }
        field(100;"Location Code";Code[20])
        {
            Editable = false;
        }
        field(50000;"Purchase Receipts (CPMZ)";Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No."=FIELD("Item No."), "Posting Date"=FIELD(Date), "Entry Type"=FILTER(Purchase), Positive=FILTER(true), "Location Code"=FIELD("Location Code"), "Receipts Transport Mode"=CONST(CPMZ)));
            Caption = 'Fuel Receipts (CPMZ)';
            Description = 'Receipts';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50001;"Purchase Receipts (PZL)";Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No."=FIELD("Item No."), "Posting Date"=FIELD(Date), "Entry Type"=FILTER(Purchase), Positive=FILTER(true), "Location Code"=FIELD("Location Code"), "Receipts Transport Mode"=CONST(PZL)));
            Caption = 'Fuel Receipts (PZL)';
            Description = 'Receipts';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50002;"Purchase Receipts (Road)";Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No."=FIELD("Item No."), "Posting Date"=FIELD(Date), "Entry Type"=FILTER(Purchase), Positive=FILTER(true), "Location Code"=FIELD("Location Code"), "Receipts Transport Mode"=CONST(Road)));
            Caption = 'Fuel Receipts (Road)';
            Description = 'Receipts';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50003;"Purchase Receipts (Rail)";Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No."=FIELD("Item No."), "Posting Date"=FIELD(Date), "Entry Type"=FILTER(Purchase), Positive=FILTER(true), "Location Code"=FIELD("Location Code"), "Receipts Transport Mode"=CONST(Rail)));
            Caption = 'Fuel Receipts (Rail)';
            Description = 'Receipts';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50004;"Purchase Receipts (Mabvuku)";Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No."=FIELD("Item No."), "Posting Date"=FIELD(Date), "Entry Type"=FILTER(Purchase), Positive=FILTER(true), "Location Code"=FIELD("Location Code"), "Receipts Transport Mode"=CONST("Msasa and Mabvuku")));
            Caption = 'Fuel Receipts (Mabvuku - Msasa)';
            Description = 'Receipts';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50015;"Sales (Road)";Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No."=FIELD("Item No."), "Posting Date"=FIELD(Date), "Entry Type"=FILTER(Sale), "Location Code"=FIELD("Location Code"), Positive=FILTER(false), "Withdrawals Transport Mode"=CONST(Road)));
            Caption = 'Fuel Withdrawals (Road)';
            Description = 'Withdrawals';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50016;"Sales (Rail)";Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No."=FIELD("Item No."), "Posting Date"=FIELD(Date), "Entry Type"=FILTER(Sale), "Location Code"=FIELD("Location Code"), Positive=FILTER(false), "Withdrawals Transport Mode"=CONST(Rail)));
            Caption = 'Fuel Withdrawals (Rail)';
            Description = 'Withdrawals';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50017;"Sales (Export Road)";Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No."=FIELD("Item No."), "Posting Date"=FIELD(Date), "Entry Type"=FILTER(Sale), "Location Code"=FIELD("Location Code"), Positive=FILTER(false), "Withdrawals Transport Mode"=CONST("Export Road")));
            Caption = 'Fuel Withdrawals (Export Road)';
            Description = 'Withdrawals';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50018;"Sales (Export Rail)";Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No."=FIELD("Item No."), "Posting Date"=FIELD(Date), "Entry Type"=FILTER(Sale), "Location Code"=FIELD("Location Code"), Positive=FILTER(false), "Withdrawals Transport Mode"=CONST("Export Rail")));
            Caption = 'Fuel Withdrawals (Export Rail)';
            Description = 'Withdrawals';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50019;"Sales (Pipeline)";Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No."=FIELD("Item No."), "Posting Date"=FIELD(Date), "Entry Type"=FILTER(Sale), "Location Code"=FIELD("Location Code"), Positive=FILTER(false), "Withdrawals Transport Mode"=CONST(Pipeline)));
            Caption = 'Fuel Withdrawals (Pipeline)';
            Description = 'Withdrawals';
            Editable = false;
            FieldClass = FlowField;
        }
    }
    keys
    {
        key(Key1;"Item No.", "Location Code", Date)
        {
        }
    }
    fieldgroups
    {
    }
}
