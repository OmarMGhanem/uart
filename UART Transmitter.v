module UART_TX 
  (input  wire [7:0] IDATA ,
   input  wire       IEN ,
   input  wire       ICLK_50 ,
   input  wire       ICLKEN ,
   output reg        OTX ,
   output wire       OTX_BUSY);

initial
  begin
   OTX = 1'b1;
  end

parameter STATE_IDLE = 2'b00;
parameter STATE_START= 2'b01;
parameter STATE_DATA = 2'b10;
parameter STATE_STOP = 2'b11;

reg [7:0] DATA   = 8'h00;
reg [2:0] BITPOS = 3'h0;
reg [1:0] STATE  = STATE_IDLE ;

always @(posedge ICLK_50)
 begin
  case (STATE)
    STATE_IDLE  : begin 
                    if (IEN) 
                       begin 
                          STATE <= STATE_START; 
                          DATA  <= IDATA;
                          BITPOS = 3'h0;
                       end
                  end
    STATE_START : begin 
                    if (ICLKEN) 
                       begin 
                          OTX   <= 1'b0 ;
                          STATE <= STATE_DATA;
                       end
                  end
    STATE_DATA  : begin 
                    if (ICLKEN) 
                       begin 
                          if (BITPOS == 3'h7)
                                 STATE <= STATE_STOP;
                          else
                             BITPOS <= BITPOS + 3'h1;
                             OTX    <= DATA[BITPOS] ; 
                       end
                  end
    STATE_STOP : begin 
                    if (ICLKEN) 
                       begin 
                          OTX <= 1'b1;
                          STATE <= STATE_IDLE;
                       end
                  end
    default    : begin 
                   OTX <= 1'b1;
                   STATE <= STATE_IDLE;
                 end
  endcase
 end

assign OTX_BUSY = (STATE != STATE_IDLE );

endmodule
