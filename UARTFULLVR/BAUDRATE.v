module BAUDGEN(
input CLK,
input[1:0] BD_RATE,
output wire BDCLK,
output wire BDSAM 
);

parameter BD0=2'b00,BD1=2'b01,BD2=2'b10,BD3=2'b11 ; // 1200 2400 4800 9600 baud rates 
integer BDAFAC = 0,BDFAC=0 ;
integer TXSIZE,RXSIZE;
reg[31:0] RX_C=0;
reg[31:0] TX_C =0; // counter reg
assign BDCLK =(TX_C==0);
assign BDSAM =(RX_C==0);

always@(posedge CLK)
begin

	case(BD_RATE)
	BD0:begin BDAFAC=50000000/(1200*16) ;
			BDFAC=50000000/(1200);
end
	BD1:begin BDAFAC=50000000/(2400*16) ;
			BDFAC=50000000/(2400);
end
	BD2:begin BDAFAC=50000000/(4800*16) ;
			BDFAC=50000000/(4800);
end
	BD3:begin BDAFAC=50000000/(9600*16) ;	
			BDFAC=50000000/(9600);
end
	endcase
/**TXSIZE=$clog2(BDFAC);
RXSIZE=$clog2(BDAFAC);**/

end




always@(posedge CLK)
begin
if(TX_C==BDFAC)
	TX_C <= 6'd0 ;
else
	TX_C <= TX_C + 6'd1 ;

end


always@(posedge CLK)
begin
if(RX_C==BDAFAC)
	RX_C <= 6'd0 ;
else
	RX_C <= RX_C + 6'd1 ;

end






endmodule
