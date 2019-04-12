module UART_RX(
input IRX,
input IEN,
input ISCLK,
output reg[7:0] RXDATA=8'h00,
output ORX_BUSY
);
reg[1:0] CSTATE =2'b00 ;
parameter STATE_IDLE = 2'b00;
parameter STATE_START= 2'b01;
parameter STATE_DATA = 2'b10;
parameter STATE_STOP = 2'b11;
reg[3:0] SCOUNTER=4'b0000;
reg[2:0] BITCOUNTER = 3'b000;

always@(posedge ISCLK)
begin

case(CSTATE)

STATE_IDLE: begin
			if(IEN &&(IRX==0)&&(SCOUNTER==0)) begin
				 CSTATE <= STATE_START ; 	
				
			         end else 
					begin CSTATE<= STATE_IDLE ; SCOUNTER=0;BITCOUNTER=0; end




	 end




STATE_START: begin
			
			if(SCOUNTER < 4'b0110)begin
			SCOUNTER = SCOUNTER + 1'b1 ; 
			CSTATE <= STATE_START;
			end else if(SCOUNTER ==4'b0110 ) begin
					CSTATE<= STATE_DATA ;
					SCOUNTER = 0 ; 	
				 end 

	 end



STATE_DATA: begin
			if(SCOUNTER <= 4'b1111 &&BITCOUNTER <= 3'b111)begin
				if(SCOUNTER == 4'b1111)begin
					RXDATA[BITCOUNTER]<=IRX ;	
					BITCOUNTER = BITCOUNTER +1 ; 
					SCOUNTER = 0;
					
					end
					SCOUNTER = SCOUNTER+1 ;
				end 
						else if (BITCOUNTER > 3'b111) begin 
								CSTATE <= STATE_STOP ; 
								SCOUNTER = 0 ;	
								BITCOUNTER = 0 ;
							end
end




STATE_STOP: begin 
if (SCOUNTER==4'b1111 && IRX == 1)begin 
	CSTATE<= STATE_IDLE ;
	SCOUNTER =0 ; BITCOUNTER =0;
end 

else begin SCOUNTER = SCOUNTER +1 ; end
end






endcase


end





endmodule 