module Traffic_Control(
input reset_n, Clk, InN, InE,
output reg [2:0]OutN, OutE,
output EN1, EN2,
output [6:0] HEX
);

reg Clr, Trigger, I;
reg [3:0] state_next,state_reg;

// Counter 
counterr m0 (Clk, I, Trigger, Clr, HEX, EN1, EN2, Done);

//States
localparam YELLOW_STATE_EAST = 4'b0000;
localparam YELLOW_STATE_NORTH = 4'b0001;
localparam CAR_NORTH = 4'b0010;
localparam CAR_EAST = 4'b0011;
localparam RESET_STATE = 4'b0100;
localparam COUNTER_RESET_EAST = 4'b0101;
localparam COUNTER_RESET_NORTH =4'b0110;
localparam COUNTER_RESET_YELLOW_EAST = 4'b0111;
localparam COUNTER_RESET_YELLOW_NORTH = 4'b1000;


//Traffic Light output 
localparam RED = 3'b011;
localparam YELLOW = 3'b101;
localparam GREEN = 3'b110;
 
always@(posedge Clk, negedge reset_n)
	begin
		if (!reset_n)
			begin
				state_reg <= RESET_STATE;
			end
			
		else
			begin
				state_reg <= state_next;
			end
	end
	
//next state
always @(*) 
	begin
		case (state_reg)
			RESET_STATE:
				begin
					Clr = 0;
					Trigger = 0;
					I = 1;
					OutE = RED;
					OutN = RED;
					
					case ({InN,InE})
						2'b00 : state_next = state_reg; 
						2'b01 : state_next = CAR_EAST;
						2'b10 : state_next = CAR_NORTH;
						2'b11 : state_next = CAR_NORTH;
					endcase
				end

			CAR_EAST:
				begin
					Clr = 1;
					Trigger = 1;
					I = 1;
					OutN = RED;
					OutE = GREEN;
					
					if (Done)
						begin
							case ({InN,InE})
								2'b00 : state_next = state_reg; 
								2'b01 : state_next = CAR_EAST;
								2'b10 : state_next = COUNTER_RESET_EAST;
								2'b11 : state_next = COUNTER_RESET_EAST;
							endcase
						end
				end

			COUNTER_RESET_EAST:
				begin
					Clr = 0;
					Trigger = 1;
					I = 0;
					OutN = YELLOW;
					OutE = YELLOW;
					state_next = YELLOW_STATE_EAST;
				end

			YELLOW_STATE_EAST:
				begin
					Clr = 1;
					Trigger = 1;
					I = 0;
					OutN = YELLOW;
					OutE = YELLOW;
					if (Done)
						begin
							state_next = COUNTER_RESET_YELLOW_EAST;
						end	
				end
				
				COUNTER_RESET_YELLOW_EAST:
					begin
						Clr = 0;
						Trigger = 1;
						I = 1;
						OutN = YELLOW;
						OutE = YELLOW;
						state_next = CAR_NORTH;
					end
				
			CAR_NORTH:
				begin
					Clr = 1;
					Trigger = 1;
					I = 1;
					OutN = GREEN;
					OutE = RED;
					
					if (Done)
						begin
							case ({InN,InE})
								2'b00 : state_next = state_reg; 
								2'b01 : state_next = COUNTER_RESET_NORTH;
								2'b10 : state_next = CAR_NORTH;
								2'b11 : state_next = COUNTER_RESET_NORTH;
							endcase
						end
				end
				
			COUNTER_RESET_NORTH:
				begin
					Clr = 0;
					Trigger = 1;
					I = 0;
					OutN = YELLOW;
					OutE = YELLOW;
					state_next = YELLOW_STATE_NORTH;
				end
				
			YELLOW_STATE_NORTH:
				begin
					Clr = 1;
					Trigger = 1;
					I = 0;
					OutN = YELLOW;
					OutE = YELLOW;
					if (Done)
						begin
							state_next = COUNTER_RESET_YELLOW_NORTH;
						end	
				end
				
				COUNTER_RESET_YELLOW_NORTH:
					begin
						Clr = 0;
						Trigger = 1;
						I = 1;
						OutN = YELLOW;
						OutE = YELLOW;
						state_next = CAR_EAST;
					end
					
			default:
				state_next = state_reg;
		endcase
	end
	
endmodule 