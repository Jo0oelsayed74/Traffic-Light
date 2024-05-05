module counterr (clk_50, i, trigger ,clr, HEX, EN1, EN2,done);

input clk_50;
input trigger;
input clr;
input i;
output done;
wire [7:0] value;
wire [25:0] CYCLES;
reg ones, tens;
wire x2, y2;
reg x1, y1;
assign x2 = x1 & clr;
assign y2 = y1 & clr;
integer k1 = 50000000;
reg [3:0] k2,k3;

wire en;
reg triggerp;
assign en=trigger & triggerp;
assign done = ~en ;

counter_modk C0 (k1, clk_50, 1'b1 ,clr, CYCLES); //counter for 1 sec intervals
	defparam C0.n = 26;
counter_modk C1 (k2, ones, en, x2, value[3:0]); //counter for BCD ones
	defparam C1.n = 4;
counter_modk C2 (k3, tens, en, y2, value[7:4]); //counter for BCD tens
	defparam C2.n = 4;

always @(i) begin
	if(i) begin
		k2=9;
		k3=2;end
	else begin
		k2=5;
		k3=0;end
end


always @ (posedge clk_50 or negedge clr) begin
	if (~clr)begin
		triggerp=1'b1;
		x1=1'b1;
		y1=1'b1;
		ones=1'b0;
		tens=1'b0;end
	else begin
		if (CYCLES == 49999999)
			ones = 1;
		else
			ones = 0;
		if (value[3:0] == 4'b1111) begin
			tens = 1;
			x1 = 0;
		end else begin
			tens = 0;
			x1 = 1;
		end
		if((value[7:4]==4'b0000 || value[7:4]==4'b1111) && value[3:0] == 4'b1111)begin
			y1=0;
			triggerp=1'b0;end
		else
			y1=1;end

end

output reg [6:0] HEX;
output reg EN1, EN2;
wire clk_d;
reg count;
wire [6:0] HEX0, HEX1;
counter_divider_9_2 C4 (clr, clk_50, clk_d); //counter for 7seg enables
defparam C4.N = 6;
b2d_ssd H1 (en, value[7:4], HEX1);
b2d_ssd H0 (en, value [3:0], HEX0);

always @(posedge clk_d or negedge clr) begin
	if(~clr)
		count<=1'b0;
	else begin
		case (count)
			1'b0: begin
				EN1 <= 1;
				EN2 <= 0;
				HEX <= HEX0;
				count <= 1'b1;
			end
				1'b1: begin
				EN1 <= 0;
				EN2 <= 1;
				HEX <= HEX1;
				count <= 1'b0;
			end
			default: count <= 1'b0;
		endcase
	end
	end
endmodule 