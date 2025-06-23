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

    __C_PRINT_HW_STATUS_OK          = '프린터 상태 정상';

    __C_PRINT_HW_ERROR_OFFLINE      = '프린터가 Offline상태!';  //-2
    __C_PRINT_HW_ERROR_HEAD_OPEN    = '프린터 Head Open!';      //-3
    __C_PRINT_HW_ERROR_PAPER_END    = '프린터 Paper End!';      //-4
    __C_PRINT_HW_ERROR_RIBBON_OPEN  = '프린터 Ribbon Open!';    //-5
    __C_PRINT_HW_ERROR_MEDIA_ERROR  = '프린터 Media Error!';    //-6
    __C_PRINT_HW_ERROR_SENSOR_OPEN  = '프린터 Sensor Open!';    //-7
    __C_PRINT_HW_ERROR_HEAD_ERROR   = '프린터 Head Error!';     //-8
    __C_PRINT_HW_ERROR_CUTTER_ERROR = '프린터 Cutter Error!';   //-9
    __C_PRINT_HW_ERROR_OTHER_ERROR  = '프린터 Other Error!';    //-10

    __C_INSPECTION_COUNT            = 13;    


    __C_SERIAL_START = '<02>';
    __C_SERIAL_END   = #13#10;

implementation

end.
