unit uConst;

interface

const
    __C_IQ_SP_SUCC      = 0;
    __C_IQ_SP_NODATA    = -1;
    __C_IQ_SP_FAIL      = -2;

    __C_ESC = #27;
    __C_STX =  #2;
    __C_ETX =  #3;
    __C_ENQ =  #5;
    __C_CAN = #24;
    __C_ACK =  #6;
    __C_NAK = #21;
    __C_EN1 = #$D;   // Enter 01
    __C_EN2 = #$A;   // Enter 02

    __C_LF  = #$A;

    __C_PRINT_HW_STATUS_OK          = '������ ���� ����';

    __C_PRINT_HW_ERROR_OFFLINE      = '�����Ͱ� Offline����!';  //-2
    __C_PRINT_HW_ERROR_HEAD_OPEN    = '������ Head Open!';      //-3
    __C_PRINT_HW_ERROR_PAPER_END    = '������ Paper End!';      //-4
    __C_PRINT_HW_ERROR_RIBBON_OPEN  = '������ Ribbon Open!';    //-5
    __C_PRINT_HW_ERROR_MEDIA_ERROR  = '������ Media Error!';    //-6
    __C_PRINT_HW_ERROR_SENSOR_OPEN  = '������ Sensor Open!';    //-7
    __C_PRINT_HW_ERROR_HEAD_ERROR   = '������ Head Error!';     //-8
    __C_PRINT_HW_ERROR_CUTTER_ERROR = '������ Cutter Error!';   //-9
    __C_PRINT_HW_ERROR_OTHER_ERROR  = '������ Other Error!';    //-10

    __C_INSPECTION_COUNT            = 13;    


    __C_SERIAL_START = '<02>';
    __C_SERIAL_END   = #13#10;

implementation

end.
