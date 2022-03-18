tableextension 50111 "Sales Shipment Line Ext" extends "Sales Shipment Line"
{
    fields
    {
        field(50000;"Receipt No.";Code[20])
        {
        }
        field(50001;"Batch No.";Code[20])
        {
        }
        field(50002;"Loading Order No.";Code[20])
        {
        }
        field(50003;"Qty Ordered";Decimal)
        {
            trigger OnValidate()begin
                "Outstanding Qty":="Qty Ordered" - (Quantity + "Qty Before Shipment");
            end;
        }
        field(50004;"Outstanding Qty";Decimal)
        {
        }
        field(50005;"Qty Before Shipment";Decimal)
        {
        }
        field(50010;"Statutory Line";Boolean)
        {
            Editable = false;
        }
        field(50011;"Statutory Item No.";Code[20])
        {
            Editable = false;
            TableRelation = Item;
        }
        field(50012;"Order Date";Date)
        {
            Caption = 'Order Date';
            Editable = false;
        }
    }
    keys
    {
        key(Key7;"Loading Order No.")
        {
        }
    }
    trigger OnDelete()var ServItem: Record "Service Item";
    SalesDocLineComments: Record "Sales Comment Line";
    begin
        ServItem.Reset();
        ServItem.SetCurrentKey("Sales/Serv. Shpt. Document No.", "Sales/Serv. Shpt. Line No.");
        ServItem.SetRange("Sales/Serv. Shpt. Document No.", "Document No.");
        ServItem.SetRange("Sales/Serv. Shpt. Line No.", "Line No.");
        ServItem.SetRange("Shipment Type", ServItem."Shipment Type"::Sales);
        if ServItem.Find('-')then repeat ServItem.Validate("Sales/Serv. Shpt. Document No.", '');
                ServItem.Validate("Sales/Serv. Shpt. Line No.", 0);
                ServItem.Modify(true);
            until ServItem.Next() = 0;
        SalesDocLineComments.SetRange("Document Type", SalesDocLineComments."Document Type"::Shipment);
        SalesDocLineComments.SetRange("No.", "Document No.");
        SalesDocLineComments.SetRange("Document Line No.", "Line No.");
        if not SalesDocLineComments.IsEmpty()then SalesDocLineComments.DeleteAll();
        PostedATOLink.DeleteAsmFromSalesShptLine(Rec);
    end;
    var Text000: Label 'Shipment No. %1:';
    Text001: Label 'The program cannot find this Sales line.';
    Currency: Record Currency;
    SalesShptHeader: Record "Sales Shipment Header";
    PostedATOLink: Record "Posted Assemble-to-Order Link";
    DimMgt: Codeunit DimensionManagement;
    UOMMgt: Codeunit "Unit of Measure Management";
    CurrencyRead: Boolean;
    // procedure InsertInvLineFromShptLine(var SalesLine: Record "Sales Line")
    // var
    //     SalesInvHeader: Record "Sales Header";
    //     SalesOrderHeader: Record "Sales Header";
    //     SalesOrderLine: Record "Sales Line";
    //     TempSalesLine: Record "Sales Line" temporary;
    //     TransferOldExtLines: Codeunit "Transfer Old Ext. Text Lines";
    //     ItemTrackingMgt: Codeunit "Item Tracking Management";
    //     TranslationHelper: Codeunit "Translation Helper";
    //     PrepaymentMgt: Codeunit "Prepayment Mgt.";
    //     ExtTextLine: Boolean;
    //     NextLineNo: Integer;
    //     IsHandled: Boolean;
    //     SalesSetup: Record 311;
    //     SalesCalcDiscount: Codeunit 60;
    // begin
    //     IsHandled := false;
    //     OnBeforeCodeInsertInvLineFromShptLine(Rec, SalesLine, IsHandled);
    //     if IsHandled then
    //         exit;
    //     SetRange("Document No.", "Document No.");
    //     TempSalesLine := SalesLine;
    //     if SalesLine.Find('+') then
    //         NextLineNo := SalesLine."Line No." + 10000
    //     else
    //         NextLineNo := 10000;
    //     if SalesInvHeader."No." <> TempSalesLine."Document No." then
    //         SalesInvHeader.Get(TempSalesLine."Document Type", TempSalesLine."Document No.");
    //     if SalesLine."Shipment No." <> "Document No." then begin
    //         OnInsertInvLineFromShptLineOnBeforeInsertDescriptionLine(
    //             Rec, SalesLine, TempSalesLine, SalesInvHeader, NextLineNo);
    //         SalesLine.Init();
    //         SalesLine."Line No." := NextLineNo;
    //         SalesLine."Document Type" := TempSalesLine."Document Type";
    //         SalesLine."Document No." := TempSalesLine."Document No.";
    //         TranslationHelper.SetGlobalLanguageByCode(SalesInvHeader."Language Code");
    //         SalesLine.Description := StrSubstNo(Text000, "Document No.");
    //         TranslationHelper.RestoreGlobalLanguage;
    //         IsHandled := false;
    //         OnBeforeInsertInvLineFromShptLineBeforeInsertTextLine(Rec, SalesLine, NextLineNo, IsHandled);
    //         if not IsHandled then begin
    //             SalesLine.Insert();
    //             OnAfterDescriptionSalesLineInsert(SalesLine, Rec, NextLineNo);
    //             NextLineNo := NextLineNo + 10000;
    //         end;
    //     end;
    //     TransferOldExtLines.ClearLineNumbers;
    //     repeat
    //         ExtTextLine := (TransferOldExtLines.GetNewLineNumber("Attached to Line No.") <> 0);
    //         if (Type <> Type::" ") and SalesOrderLine.Get(SalesOrderLine."Document Type"::Order, "Order No.", "Order Line No.")
    //         then begin
    //             if (SalesOrderHeader."Document Type" <> SalesOrderLine."Document Type"::Order) or
    //                (SalesOrderHeader."No." <> SalesOrderLine."Document No.")
    //             then
    //                 SalesOrderHeader.Get(SalesOrderLine."Document Type"::Order, "Order No.");
    //             PrepaymentMgt.TestSalesOrderLineForGetShptLines(SalesOrderLine);
    //             InitCurrency("Currency Code");
    //             if SalesInvHeader."Prices Including VAT" then begin
    //                 if not SalesOrderHeader."Prices Including VAT" then
    //                     SalesOrderLine."Unit Price" :=
    //                       Round(
    //                         SalesOrderLine."Unit Price" * (1 + SalesOrderLine."VAT %" / 100),
    //                         Currency."Unit-Amount Rounding Precision");
    //             end else begin
    //                 if SalesOrderHeader."Prices Including VAT" then
    //                     SalesOrderLine."Unit Price" :=
    //                       Round(
    //                         SalesOrderLine."Unit Price" / (1 + SalesOrderLine."VAT %" / 100),
    //                         Currency."Unit-Amount Rounding Precision");
    //             end;
    //         end else begin
    //             SalesOrderHeader.Init();
    //             if ExtTextLine or (Type = Type::" ") then begin
    //                 SalesOrderLine.Init();
    //                 SalesOrderLine."Line No." := "Order Line No.";
    //                 SalesOrderLine.Description := Description;
    //                 SalesOrderLine."Description 2" := "Description 2";
    //                 OnInsertInvLineFromShptLineOnAfterAssignDescription(Rec, SalesOrderLine);
    //             end else
    //                 Error(Text001);
    //         end;
    //         SalesLine := SalesOrderLine;
    //         SalesLine."Line No." := NextLineNo;
    //         SalesLine."Document Type" := TempSalesLine."Document Type";
    //         SalesLine."Document No." := TempSalesLine."Document No.";
    //         SalesLine."Variant Code" := "Variant Code";
    //         SalesLine."Location Code" := "Location Code";
    //         SalesLine."Quantity (Base)" := 0;
    //         SalesLine.Quantity := 0;
    //         SalesLine."Outstanding Qty. (Base)" := 0;
    //         SalesLine."Outstanding Quantity" := 0;
    //         SalesLine."Quantity Shipped" := 0;
    //         SalesLine."Qty. Shipped (Base)" := 0;
    //         SalesLine."Quantity Invoiced" := 0;
    //         SalesLine."Qty. Invoiced (Base)" := 0;
    //         SalesLine.Amount := 0;
    //         SalesLine."Amount Including VAT" := 0;
    //         SalesLine."Purchase Order No." := '';
    //         SalesLine."Purch. Order Line No." := 0;
    //         SalesLine."Drop Shipment" := "Drop Shipment";
    //         SalesLine."Special Order Purchase No." := '';
    //         SalesLine."Special Order Purch. Line No." := 0;
    //         SalesLine."Special Order" := FALSE;
    //         SalesLine."Shipment No." := "Document No.";
    //         SalesLine."Shipment Line No." := "Line No.";
    //         SalesLine."Appl.-to Item Entry" := 0;
    //         SalesLine."Appl.-from Item Entry" := 0;
    //         if not ExtTextLine and (SalesLine.Type <> SalesLine.Type::" ") then begin
    //             IsHandled := false;
    //             OnInsertInvLineFromShptLineOnBeforeValidateQuantity(Rec, SalesLine, IsHandled);
    //             if not IsHandled then
    //                 SalesLine.Validate(Quantity, Quantity - "Quantity Invoiced");
    //             CalcBaseQuantities(SalesLine, "Quantity (Base)" / Quantity);
    //             OnInsertInvLineFromShptLineOnAfterCalcQuantities(SalesLine, SalesOrderLine);
    //             SalesLine.Validate("Unit Price", SalesOrderLine."Unit Price");
    //             SalesLine."Allow Line Disc." := SalesOrderLine."Allow Line Disc.";
    //             SalesLine."Allow Invoice Disc." := SalesOrderLine."Allow Invoice Disc.";
    //             SalesOrderLine."Line Discount Amount" :=
    //               Round(
    //                 SalesOrderLine."Line Discount Amount" * SalesLine.Quantity / SalesOrderLine.Quantity,
    //                 Currency."Amount Rounding Precision");
    //             if SalesInvHeader."Prices Including VAT" then begin
    //                 if not SalesOrderHeader."Prices Including VAT" then
    //                     SalesOrderLine."Line Discount Amount" :=
    //                       Round(
    //                         SalesOrderLine."Line Discount Amount" *
    //                         (1 + SalesOrderLine."VAT %" / 100), Currency."Amount Rounding Precision");
    //             end else begin
    //                 if SalesOrderHeader."Prices Including VAT" then
    //                     SalesOrderLine."Line Discount Amount" :=
    //                       Round(
    //                         SalesOrderLine."Line Discount Amount" /
    //                         (1 + SalesOrderLine."VAT %" / 100), Currency."Amount Rounding Precision");
    //             end;
    //             SalesLine.Validate("Line Discount Amount", SalesOrderLine."Line Discount Amount");
    //             SalesLine."Line Discount %" := SalesOrderLine."Line Discount %";
    //             SalesLine.UpdatePrePaymentAmounts;
    //             OnInsertInvLineFromShptLineOnAfterUpdatePrepaymentsAmounts(SalesLine, SalesOrderLine, Rec);
    //             if SalesOrderLine.Quantity = 0 then
    //                 SalesLine.Validate("Inv. Discount Amount", 0)
    //             else
    //                 SalesLine.Validate(
    //                   "Inv. Discount Amount",
    //                   Round(
    //                     SalesOrderLine."Inv. Discount Amount" * SalesLine.Quantity / SalesOrderLine.Quantity,
    //                     Currency."Amount Rounding Precision"));
    //             OnInsertInvLineFromShptLineOnAfterValidateInvDiscountAmount(SalesLine, SalesOrderLine, Rec, SalesInvHeader);
    //         end;
    //         SalesLine."Attached to Line No." :=
    //           TransferOldExtLines.TransferExtendedText(
    //             SalesOrderLine."Line No.",
    //             NextLineNo,
    //             "Attached to Line No.");
    //         SalesLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
    //         SalesLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
    //         SalesLine."Dimension Set ID" := "Dimension Set ID";
    //         IsHandled := false;
    //         OnBeforeInsertInvLineFromShptLine(Rec, SalesLine, SalesOrderLine, IsHandled);
    //         if not IsHandled then
    //             SalesLine.Insert();
    //         OnAfterInsertInvLineFromShptLine(SalesLine, SalesOrderLine, NextLineNo, Rec);
    //         SalesSetup.GET;
    //         IF SalesSetup."Calc. Inv. Discount" THEN
    //             SalesCalcDiscount.CalculateInvoiceDiscountOnLine(SalesLine);
    //         ItemTrackingMgt.CopyHandledItemTrkgToInvLine(SalesOrderLine, SalesLine);
    //         NextLineNo := NextLineNo + 10000;
    //         if "Attached to Line No." = 0 then
    //             SetRange("Attached to Line No.", "Line No.");
    //     until (Next() = 0) or ("Attached to Line No." = 0);
    //     if SalesOrderHeader.Get(SalesOrderHeader."Document Type"::Order, "Order No.") then begin
    //         SalesOrderHeader."Get Shipment Used" := true;
    //         SalesOrderHeader.Modify();
    //     end;
    // end;
    // procedure ShowLineComments()
    // var
    //     SalesCommentLine: Record "Sales Comment Line";
    //     SalesDocLineComments: Record 44;
    //     SalesDocCommentSheet: Page 67;
    // begin
    //     SalesDocLineComments.SETRANGE("Document Type", SalesDocLineComments."Document Type"::Shipment);
    //     SalesDocLineComments.SETRANGE("No.", "Document No.");
    //     SalesDocLineComments.SETRANGE("Document Line No.", "Line No.");
    //     SalesDocCommentSheet.SETTABLEVIEW(SalesDocLineComments);
    //     SalesDocCommentSheet.RUNMODAL;
    //     // SalesCommentLine.ShowComments(SalesCommentLine."Document Type"::Shipment.AsInteger(), "Document No.", "Line No.");
    // end;
    local procedure InitCurrency(CurrencyCode: Code[10])begin
        IF(Currency.Code = CurrencyCode) AND CurrencyRead THEN EXIT;
        IF CurrencyCode <> '' THEN Currency.GET(CurrencyCode)
        ELSE
            Currency.InitRoundingPrecision;
        CurrencyRead:=TRUE;
    end;
    local procedure CalcBaseQuantities(var SalesLine: Record "Sales Line";
    QtyFactor: Decimal)begin
        SalesLine."Quantity (Base)":=Round(SalesLine.Quantity * QtyFactor, UOMMgt.QtyRndPrecision);
        SalesLine."Qty. to Asm. to Order (Base)":=Round(SalesLine."Qty. to Assemble to Order" * QtyFactor, UOMMgt.QtyRndPrecision);
        SalesLine."Outstanding Qty. (Base)":=Round(SalesLine."Outstanding Quantity" * QtyFactor, UOMMgt.QtyRndPrecision);
        SalesLine."Qty. to Ship (Base)":=Round(SalesLine."Qty. to Ship" * QtyFactor, UOMMgt.QtyRndPrecision);
        SalesLine."Qty. Shipped (Base)":=Round(SalesLine."Quantity Shipped" * QtyFactor, UOMMgt.QtyRndPrecision);
        SalesLine."Qty. Shipped Not Invd. (Base)":=Round(SalesLine."Qty. Shipped Not Invoiced" * QtyFactor, UOMMgt.QtyRndPrecision);
        SalesLine."Qty. to Invoice (Base)":=Round(SalesLine."Qty. to Invoice" * QtyFactor, UOMMgt.QtyRndPrecision);
        SalesLine."Qty. Invoiced (Base)":=Round(SalesLine."Quantity Invoiced" * QtyFactor, UOMMgt.QtyRndPrecision);
        SalesLine."Return Qty. to Receive (Base)":=Round(SalesLine."Return Qty. to Receive" * QtyFactor, UOMMgt.QtyRndPrecision);
        SalesLine."Return Qty. Received (Base)":=Round(SalesLine."Return Qty. Received" * QtyFactor, UOMMgt.QtyRndPrecision);
        SalesLine."Ret. Qty. Rcd. Not Invd.(Base)":=Round(SalesLine."Return Qty. Rcd. Not Invd." * QtyFactor, UOMMgt.QtyRndPrecision);
    end;
    local procedure GetFieldCaption(FieldNumber: Integer): Text[100]var "Field": Record "Field";
    begin
        Field.Get(DATABASE::"Sales Shipment Line", FieldNumber);
        exit(Field."Field Caption");
    end;
    local procedure UpdateDocumentNo()var SalesShipmentHeader: Record "Sales Shipment Header";
    begin
        if IsNullGuid(Rec."Document Id")then begin
            Clear(Rec."Document No.");
            exit;
        end;
        if not SalesShipmentHeader.GetBySystemId(Rec."Document Id")then exit;
        "Document No.":=SalesShipmentHeader."No.";
    end;
    [IntegrationEvent(false, false)]
    local procedure OnAfterClearSalesLineValues(var SalesShipmentLine: Record "Sales Shipment Line";
    var SalesLine: Record "Sales Line")begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnAfterDescriptionSalesLineInsert(var SalesLine: Record "Sales Line";
    SalesShipmentLine: Record "Sales Shipment Line";
    var NextLineNo: Integer)begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnAfterInitFromSalesLine(SalesShptHeader: Record "Sales Shipment Header";
    SalesLine: Record "Sales Line";
    var SalesShptLine: Record "Sales Shipment Line")begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnAfterInsertInvLineFromShptLine(var SalesLine: Record "Sales Line";
    SalesOrderLine: Record "Sales Line";
    NextLineNo: Integer;
    SalesShipmentLine: Record "Sales Shipment Line")begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnBeforeCalcShippedSaleNotReturned(var SalesShipmentLine: Record "Sales Shipment Line";
    var ShippedQtyNotReturned: Decimal;
    var RevUnitCostLCY: Decimal;
    ExactCostReverse: Boolean;
    var IsHandled: Boolean)begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertInvLineFromShptLine(var SalesShptLine: Record "Sales Shipment Line";
    var SalesLine: Record "Sales Line";
    SalesOrderLine: Record "Sales Line";
    var IsHandled: Boolean)begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertInvLineFromShptLineBeforeInsertTextLine(var SalesShptLine: Record "Sales Shipment Line";
    var SalesLine: Record "Sales Line";
    var NextLineNo: Integer;
    var Handled: Boolean)begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnBeforeCodeInsertInvLineFromShptLine(var SalesShipmentLine: Record "Sales Shipment Line";
    var SalesLine: Record "Sales Line";
    var IsHandled: Boolean)begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnInsertInvLineFromShptLineOnAfterAssignDescription(var SalesShipmentLine: Record "Sales Shipment Line";
    var SalesOrderLine: Record "Sales Line")begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnInsertInvLineFromShptLineOnAfterCalcQuantities(var SalesLine: Record "Sales Line";
    SalesOrderLine: Record "Sales Line")begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnInsertInvLineFromShptLineOnAfterUpdatePrepaymentsAmounts(var SalesLine: Record "Sales Line";
    var SalesOrderLine: Record "Sales Line";
    var SalesShipmentLine: Record "Sales Shipment Line")begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnInsertInvLineFromShptLineOnBeforeValidateQuantity(SalesShipmentLine: Record "Sales Shipment Line";
    var SalesLine: Record "Sales Line";
    var IsHandled: Boolean)begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnInsertInvLineFromShptLineOnBeforeInsertDescriptionLine(SalesShipmentLine: Record "Sales Shipment Line";
    var SalesLine: Record "Sales Line";
    TempSalesLine: Record "Sales Line" temporary;
    var SalesInvHeader: Record "Sales Header";
    var NextLineNo: integer)begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnInsertInvLineFromShptLineOnAfterValidateInvDiscountAmount(var SalesLine: Record "Sales Line";
    SalesOrderLine: Record "Sales Line";
    SalesShipmentLine: Record "Sales Shipment Line";
    SalesInvHeader: Record "Sales Header")begin
    end;
}
