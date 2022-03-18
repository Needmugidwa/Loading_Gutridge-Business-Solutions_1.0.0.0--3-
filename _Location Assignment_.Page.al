page 50108 "Location Assignment"
{
    Caption = 'Location Assignment';
    // DeleteAllowed = false;
    // InsertAllowed = false;
    PageType = List;
    SaveValues = true;
    SourceTable = "User Setup";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control15)
            {
                ShowCaption = false;

                field("User ID";Rec."User ID")
                {
                    ApplicationArea = All;
                }
                field("IsMember[1]";IsMember[1])
                {
                    CaptionClass = '3,' + MATRIX_Caption[1];
                    ShowCaption = false;
                    Visible = Cell1Visible;
                    ApplicationArea = All;

                    trigger OnValidate()begin
                        UpdateSelection(1);
                    end;
                }
                field("IsMember[2]";IsMember[2])
                {
                    CaptionClass = '3,' + MATRIX_Caption[2];
                    ShowCaption = false;
                    Visible = Cell2Visible;
                    ApplicationArea = All;

                    trigger OnValidate()begin
                        UpdateSelection(2);
                    end;
                }
                field("IsMember[3]";IsMember[3])
                {
                    CaptionClass = '3,' + MATRIX_Caption[3];
                    ShowCaption = false;
                    Visible = Cell3Visible;
                    ApplicationArea = All;

                    trigger OnValidate()begin
                        UpdateSelection(3);
                    end;
                }
                field("IsMember[4]";IsMember[4])
                {
                    CaptionClass = '3,' + MATRIX_Caption[4];
                    ShowCaption = false;
                    Visible = Cell4Visible;
                    ApplicationArea = All;

                    trigger OnValidate()begin
                        UpdateSelection(4);
                    end;
                }
                field("IsMember[5]";IsMember[5])
                {
                    CaptionClass = '3,' + MATRIX_Caption[5];
                    ShowCaption = false;
                    Visible = Cell5Visible;
                    ApplicationArea = All;

                    trigger OnValidate()begin
                        UpdateSelection(5);
                    end;
                }
                field("IsMember[6]";IsMember[6])
                {
                    CaptionClass = '3,' + MATRIX_Caption[6];
                    ShowCaption = false;
                    Visible = Cell6Visible;
                    ApplicationArea = All;

                    trigger OnValidate()begin
                        UpdateSelection(6);
                    end;
                }
                field("IsMember[7]";IsMember[7])
                {
                    CaptionClass = '3,' + MATRIX_Caption[7];
                    ShowCaption = false;
                    Visible = Cell7Visible;
                    ApplicationArea = All;

                    trigger OnValidate()begin
                        UpdateSelection(7);
                    end;
                }
                field("IsMember[8]";IsMember[8])
                {
                    CaptionClass = '3,' + MATRIX_Caption[8];
                    ShowCaption = false;
                    Visible = Cell8Visible;
                    ApplicationArea = All;

                    trigger OnValidate()begin
                        UpdateSelection(8);
                    end;
                }
                field("IsMember[9]";IsMember[9])
                {
                    CaptionClass = '3,' + MATRIX_Caption[9];
                    ShowCaption = false;
                    Visible = Cell9Visible;
                    ApplicationArea = All;

                    trigger OnValidate()begin
                        UpdateSelection(9);
                    end;
                }
                field("IsMember[10]";IsMember[10])
                {
                    CaptionClass = '3,' + MATRIX_Caption[10];
                    ShowCaption = false;
                    Visible = Cell10Visible;
                    ApplicationArea = All;

                    trigger OnValidate()begin
                        UpdateSelection(10);
                    end;
                }
                field("IsMember[11]";IsMember[11])
                {
                    CaptionClass = '3,' + MATRIX_Caption[11];
                    ShowCaption = false;
                    Visible = Cell11Visible;
                    ApplicationArea = All;

                    trigger OnValidate()begin
                        UpdateSelection(11);
                    end;
                }
                field("IsMember[12]";IsMember[12])
                {
                    CaptionClass = '3,' + MATRIX_Caption[12];
                    ShowCaption = false;
                    Visible = Cell12Visible;
                    ApplicationArea = All;

                    trigger OnValidate()begin
                        UpdateSelection(12);
                    end;
                }
                field("IsMember[13]";IsMember[13])
                {
                    CaptionClass = '3,' + MATRIX_Caption[13];
                    ShowCaption = false;
                    Visible = Cell13Visible;
                    ApplicationArea = All;

                    trigger OnValidate()begin
                        UpdateSelection(13);
                    end;
                }
                field("IsMember[14]";IsMember[14])
                {
                    CaptionClass = '3,' + MATRIX_Caption[14];
                    ShowCaption = false;
                    Visible = Cell14Visible;

                    trigger OnValidate()begin
                        UpdateSelection(14);
                    end;
                }
                field("IsMember[15]";IsMember[15])
                {
                    CaptionClass = '3,' + MATRIX_Caption[15];
                    ShowCaption = false;
                    Visible = Cell15Visible;

                    trigger OnValidate()begin
                        UpdateSelection(15);
                    end;
                }
                field("IsMember[16]";IsMember[16])
                {
                    CaptionClass = '3,' + MATRIX_Caption[16];
                    ShowCaption = false;
                    Visible = Cell16Visible;

                    trigger OnValidate()begin
                        UpdateSelection(16);
                    end;
                }
                field("IsMember[17]";IsMember[17])
                {
                    CaptionClass = '3,' + MATRIX_Caption[17];
                    ShowCaption = false;
                    Visible = Cell17Visible;

                    trigger OnValidate()begin
                        UpdateSelection(17);
                    end;
                }
                field("IsMember[18]";IsMember[18])
                {
                    CaptionClass = '3,' + MATRIX_Caption[18];
                    ShowCaption = false;
                    Visible = Cell18Visible;

                    trigger OnValidate()begin
                        UpdateSelection(18);
                    end;
                }
                field("IsMember[19]";IsMember[19])
                {
                    CaptionClass = '3,' + MATRIX_Caption[19];
                    ShowCaption = false;
                    Visible = Cell19Visible;

                    trigger OnValidate()begin
                        UpdateSelection(19);
                    end;
                }
                field("IsMember[20]";IsMember[20])
                {
                    CaptionClass = '3,' + MATRIX_Caption[20];
                    ShowCaption = false;
                    Visible = Cell20Visible;

                    trigger OnValidate()begin
                        UpdateSelection(20);
                    end;
                }
                field("IsMember[21]";IsMember[21])
                {
                    CaptionClass = '3,' + MATRIX_Caption[21];
                    ShowCaption = false;
                    Visible = Cell21Visible;

                    trigger OnValidate()begin
                        UpdateSelection(21);
                    end;
                }
                field("IsMember[22]";IsMember[22])
                {
                    CaptionClass = '3,' + MATRIX_Caption[22];
                    ShowCaption = false;
                    Visible = Cell22Visible;

                    trigger OnValidate()begin
                        UpdateSelection(22);
                    end;
                }
                field("IsMember[23]";IsMember[23])
                {
                    CaptionClass = '3,' + MATRIX_Caption[23];
                    ShowCaption = false;
                    Visible = Cell23Visible;

                    trigger OnValidate()begin
                        UpdateSelection(23);
                    end;
                }
                field("IsMember[24]";IsMember[24])
                {
                    CaptionClass = '3,' + MATRIX_Caption[24];
                    ShowCaption = false;
                    Visible = Cell24Visible;

                    trigger OnValidate()begin
                        UpdateSelection(24);
                    end;
                }
                field("IsMember[25]";IsMember[25])
                {
                    CaptionClass = '3,' + MATRIX_Caption[25];
                    ShowCaption = false;
                    Visible = Cell25Visible;

                    trigger OnValidate()begin
                        UpdateSelection(25);
                    end;
                }
                field("IsMember[26]";IsMember[26])
                {
                    CaptionClass = '3,' + MATRIX_Caption[26];
                    ShowCaption = false;
                    Visible = Cell26Visible;

                    trigger OnValidate()begin
                        UpdateSelection(26);
                    end;
                }
                field("IsMember[27]";IsMember[27])
                {
                    CaptionClass = '3,' + MATRIX_Caption[27];
                    ShowCaption = false;
                    Visible = Cell27Visible;

                    trigger OnValidate()begin
                        UpdateSelection(27);
                    end;
                }
                field("IsMember[28]";IsMember[28])
                {
                    CaptionClass = '3,' + MATRIX_Caption[28];
                    ShowCaption = false;
                    Visible = Cell28Visible;

                    trigger OnValidate()begin
                        UpdateSelection(28);
                    end;
                }
                field("IsMember[29]";IsMember[29])
                {
                    CaptionClass = '3,' + MATRIX_Caption[29];
                    ShowCaption = false;
                    Visible = Cell29Visible;

                    trigger OnValidate()begin
                        UpdateSelection(29);
                    end;
                }
                field("IsMember[30]";IsMember[30])
                {
                    CaptionClass = '3,' + MATRIX_Caption[30];
                    ShowCaption = false;
                    Visible = Cell30Visible;

                    trigger OnValidate()begin
                        UpdateSelection(30);
                    end;
                }
                field("IsMember[31]";IsMember[31])
                {
                    CaptionClass = '3,' + MATRIX_Caption[31];
                    ShowCaption = false;
                    Visible = Cell31Visible;

                    trigger OnValidate()begin
                        UpdateSelection(31);
                    end;
                }
                field("IsMember[32]";IsMember[32])
                {
                    CaptionClass = '3,' + MATRIX_Caption[32];
                    ShowCaption = false;
                    Visible = Cell32Visible;

                    trigger OnValidate()begin
                        UpdateSelection(32);
                    end;
                }
                field("IsMember[33]";IsMember[33])
                {
                    CaptionClass = '3,' + MATRIX_Caption[33];
                    ShowCaption = false;
                    Visible = Cell33Visible;

                    trigger OnValidate()begin
                        UpdateSelection(33);
                    end;
                }
                field("IsMember[34]";IsMember[34])
                {
                    CaptionClass = '3,' + MATRIX_Caption[34];
                    ShowCaption = false;
                    Visible = Cell34Visible;

                    trigger OnValidate()begin
                        UpdateSelection(34);
                    end;
                }
                field("IsMember[35]";IsMember[35])
                {
                    CaptionClass = '3,' + MATRIX_Caption[35];
                    ShowCaption = false;
                    Visible = Cell35Visible;

                    trigger OnValidate()begin
                        UpdateSelection(35);
                    end;
                }
                field("IsMember[36]";IsMember[36])
                {
                    CaptionClass = '3,' + MATRIX_Caption[36];
                    ShowCaption = false;
                    Visible = Cell36Visible;

                    trigger OnValidate()begin
                        UpdateSelection(36);
                    end;
                }
                field("IsMember[37]";IsMember[37])
                {
                    CaptionClass = '3,' + MATRIX_Caption[37];
                    ShowCaption = false;
                    Visible = Cell37Visible;

                    trigger OnValidate()begin
                        UpdateSelection(37);
                    end;
                }
                field("IsMember[38]";IsMember[38])
                {
                    CaptionClass = '3,' + MATRIX_Caption[38];
                    ShowCaption = false;
                    Visible = Cell38Visible;

                    trigger OnValidate()begin
                        UpdateSelection(38);
                    end;
                }
                field("IsMember[39]";IsMember[39])
                {
                    CaptionClass = '3,' + MATRIX_Caption[39];
                    ShowCaption = false;
                    Visible = Cell39Visible;

                    trigger OnValidate()begin
                        UpdateSelection(39);
                    end;
                }
                field("IsMember[40]";IsMember[40])
                {
                    CaptionClass = '3,' + MATRIX_Caption[40];
                    ShowCaption = false;
                    Visible = Cell40Visible;

                    trigger OnValidate()begin
                        UpdateSelection(40);
                    end;
                }
            }
        }
    }
    actions
    {
    }
    trigger OnAfterGetRecord()var MATRIX_CurrentColumnOrdinal: Integer;
    begin
        for MATRIX_CurrentColumnOrdinal:=1 to MATRIX_CurrentNoOfMatrixColumn do MATRIX_OnAfterGetRecord(MATRIX_CurrentColumnOrdinal);
    end;
    trigger OnInit()begin
        SetColumns(0);
    end;
    var UserLocation: Record "User Location";
    IsMember: array[40]of Boolean;
    MATRIX_CurrentNoOfMatrixColumn: Integer;
    MATRIX_Caption: array[40]of Text[80];
    [InDataSet]
    Cell1Visible: Boolean;
    [InDataSet]
    Cell2Visible: Boolean;
    [InDataSet]
    Cell3Visible: Boolean;
    [InDataSet]
    Cell4Visible: Boolean;
    [InDataSet]
    Cell5Visible: Boolean;
    [InDataSet]
    Cell6Visible: Boolean;
    [InDataSet]
    Cell7Visible: Boolean;
    [InDataSet]
    Cell8Visible: Boolean;
    [InDataSet]
    Cell9Visible: Boolean;
    [InDataSet]
    Cell10Visible: Boolean;
    [InDataSet]
    Cell11Visible: Boolean;
    [InDataSet]
    Cell12Visible: Boolean;
    [InDataSet]
    Cell13Visible: Boolean;
    [InDataSet]
    Cell14Visible: Boolean;
    [InDataSet]
    Cell15Visible: Boolean;
    [InDataSet]
    Cell16Visible: Boolean;
    [InDataSet]
    Cell17Visible: Boolean;
    [InDataSet]
    Cell18Visible: Boolean;
    [InDataSet]
    Cell19Visible: Boolean;
    [InDataSet]
    Cell20Visible: Boolean;
    [InDataSet]
    Cell21Visible: Boolean;
    [InDataSet]
    Cell22Visible: Boolean;
    [InDataSet]
    Cell23Visible: Boolean;
    [InDataSet]
    Cell24Visible: Boolean;
    [InDataSet]
    Cell25Visible: Boolean;
    [InDataSet]
    Cell26Visible: Boolean;
    [InDataSet]
    Cell27Visible: Boolean;
    [InDataSet]
    Cell28Visible: Boolean;
    [InDataSet]
    Cell29Visible: Boolean;
    [InDataSet]
    Cell30Visible: Boolean;
    [InDataSet]
    Cell31Visible: Boolean;
    [InDataSet]
    Cell32Visible: Boolean;
    [InDataSet]
    Cell33Visible: Boolean;
    [InDataSet]
    Cell34Visible: Boolean;
    [InDataSet]
    Cell35Visible: Boolean;
    [InDataSet]
    Cell36Visible: Boolean;
    [InDataSet]
    Cell37Visible: Boolean;
    [InDataSet]
    Cell38Visible: Boolean;
    [InDataSet]
    Cell39Visible: Boolean;
    [InDataSet]
    Cell40Visible: Boolean;
    procedure SetColumns(Offset: Integer)var Location: Record Location;
    ColNo: Integer;
    begin
        if Offset = 0 then begin
            Clear(MATRIX_Caption);
            if Location.FindSet then begin
                ColNo:=0;
                repeat ColNo+=1;
                    MATRIX_Caption[ColNo]:=Location.Code;
                until(Location.Next() = 0) or (ColNo >= ArrayLen(MATRIX_Caption));
                MATRIX_CurrentNoOfMatrixColumn:=ColNo;
                Cell1Visible:=MATRIX_Caption[1] <> '';
                Cell2Visible:=MATRIX_Caption[2] <> '';
                Cell3Visible:=MATRIX_Caption[3] <> '';
                Cell4Visible:=MATRIX_Caption[4] <> '';
                Cell5Visible:=MATRIX_Caption[5] <> '';
                Cell6Visible:=MATRIX_Caption[6] <> '';
                Cell7Visible:=MATRIX_Caption[7] <> '';
                Cell8Visible:=MATRIX_Caption[8] <> '';
                Cell9Visible:=MATRIX_Caption[9] <> '';
                Cell10Visible:=MATRIX_Caption[10] <> '';
                Cell11Visible:=MATRIX_Caption[11] <> '';
                Cell12Visible:=MATRIX_Caption[12] <> '';
                Cell13Visible:=MATRIX_Caption[13] <> '';
                Cell14Visible:=MATRIX_Caption[14] <> '';
                Cell15Visible:=MATRIX_Caption[15] <> '';
                Cell16Visible:=MATRIX_Caption[16] <> '';
                Cell17Visible:=MATRIX_Caption[17] <> '';
                Cell18Visible:=MATRIX_Caption[18] <> '';
                Cell19Visible:=MATRIX_Caption[19] <> '';
                Cell20Visible:=MATRIX_Caption[20] <> '';
                Cell21Visible:=MATRIX_Caption[21] <> '';
                Cell22Visible:=MATRIX_Caption[22] <> '';
                Cell23Visible:=MATRIX_Caption[23] <> '';
                Cell24Visible:=MATRIX_Caption[24] <> '';
                Cell25Visible:=MATRIX_Caption[25] <> '';
                Cell26Visible:=MATRIX_Caption[26] <> '';
                Cell27Visible:=MATRIX_Caption[27] <> '';
                Cell28Visible:=MATRIX_Caption[28] <> '';
                Cell29Visible:=MATRIX_Caption[29] <> '';
                Cell30Visible:=MATRIX_Caption[30] <> '';
                Cell31Visible:=MATRIX_Caption[31] <> '';
                Cell32Visible:=MATRIX_Caption[32] <> '';
                Cell33Visible:=MATRIX_Caption[33] <> '';
                Cell34Visible:=MATRIX_Caption[34] <> '';
                Cell35Visible:=MATRIX_Caption[35] <> '';
                Cell36Visible:=MATRIX_Caption[36] <> '';
                Cell37Visible:=MATRIX_Caption[37] <> '';
                Cell38Visible:=MATRIX_Caption[38] <> '';
                Cell39Visible:=MATRIX_Caption[39] <> '';
                Cell40Visible:=MATRIX_Caption[40] <> '';
            //MESSAGE(MATRIX_Caption[30] );
            end;
        end
        else
        begin
            if MATRIX_CurrentNoOfMatrixColumn < ArrayLen(MATRIX_Caption)then exit;
            if Offset < 0 then begin
                Location.Get(MATRIX_Caption[1]);
                Location.Next(Offset);
            end
            else
            begin
                Location.Get(MATRIX_Caption[ArrayLen(MATRIX_Caption)]);
                if Location.Next(Offset) < Offset then begin
                    Location.FindLast;
                end;
                Location.Next(-(ArrayLen(MATRIX_Caption) - 1));
            end;
            ColNo:=0;
            repeat ColNo+=1;
                MATRIX_Caption[ColNo]:=Location.Code;
            until(Location.Next() = 0) or (ColNo >= ArrayLen(MATRIX_Caption));
        end;
    end;
    procedure UpdateMatrix()begin
        CurrPage.Update();
    end;
    procedure UpdateSelection(ColumnNo: Integer)begin
        UserLocation.SetMembership(MATRIX_Caption[ColumnNo], Rec."User ID", IsMember);
    end;
    local procedure MATRIX_OnAfterGetRecord(MATRIX_ColumnOrdinal: Integer)begin
        //MATRIX_MatrixRecord := MatrixRecords[MATRIX_ColumnOrdinal];
        if UserLocation.Get(MATRIX_Caption[MATRIX_ColumnOrdinal], Rec."User ID")then IsMember[MATRIX_ColumnOrdinal]:=true
        else
            IsMember[MATRIX_ColumnOrdinal]:=false;
    end;
}
