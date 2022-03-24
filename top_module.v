module top_module (
    input clk,
    input rst_n,
    input [3:1] s,
    output fr3,
    output fr2,
    output fr1,
    output dfr
);


/* 
Above S3            S[3:1]=7
Between S3 and S2   S[3:1]=3
Between S2 and S1   S[3:1]=1
Below S1            S[3:1]=0
*/

parameter // State variable enumeration
    state_Below_S1      = 2'b00,
    state_Between_S2_S1 = 2'b01,
    state_Between_S3_S2 = 2'b10,
    state_Above_S3      = 2'b11;

reg [1: 0] state; // Status register
reg [1: 0] nextstate;


always @(posedge clk)begin
	if(!rst_n)
		state <= state_Below_S1;
    else
        state <= nextstate;

end

always @(state) begin
    case (state)
        state_Below_S1: begin
            nextstate = stateB;
            { fr3, fr2, fr1, dfr} <= {1'b0, 1'b0, 1'b0, 1'b0};
        end
        state_Between_S2_S1: begin
            nextstate = stateC;
            out = 2'b11;
        end
        state_Between_S3_S2: begin
            nextstate = stateD;
            out = 2'b10;
        end
        state_Above_S3: begin
            nextstate = stateA;
            out = 2'b00;
            end
    endcase
end


endmodule