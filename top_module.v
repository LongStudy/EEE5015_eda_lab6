module top_module (
    input clk,
    input rst_n,
    input [3:1] s,
    output reg fr3,
    output reg fr2,
    output reg fr1,
    output reg dfr
);

/* 
Above S3            S[3:1]=7 // S[3]=1
Between S3 and S2   S[3:1]=3 // S[2]=1  
Between S2 and S1   S[3:1]=1 // S[1]=1
Below S1            S[3:1]=0 // S[3:1]=1
*/

parameter // State variable enumeration
    state_upper = 2'b00, // S[3:1]>last_s
    state_equal = 2'b01, // S[3:1]=last_s
    state_lower = 2'b10, // S[3:1]<last_s
    state_start = 2'b11;


reg [1:0] state; // State variable
reg [3:1] last_s; // last_s[3:1] is the last s[3:1] value
reg [1:0] nextstate;// Next state register


always @(posedge clk)begin
	if(!rst_n) begin
		state <= state_start;
    end
    else
        state <= nextstate;
end

always @(posedge clk) begin
    case (state)
        state_upper: begin
            dfr = 1'b0; //if upper, then dfr=0
            fr1 = (s[3] == 0) ? 1'b1 : 1'b0; //if s[3]==0, then fr1=1, else fr1=0
            fr2 = (s[3:2]==0) ? 1'b1 : 1'b0; //if s[3:2]=0, fr2=1, else fr2=0
            fr3 = (s[3:1]==0) ? 1'b1 : 1'b0; // if s[3:1]==0, fr3=1, else fr3=0
            if(s > last_s)begin
                nextstate = state_upper;
            end
            else if(s == last_s)begin
                nextstate = state_equal;
            end
            else begin
                nextstate = state_lower;
            end
            last_s <= s;
        end
        state_equal: begin
            fr1 = (s[3] == 0) ? 1'b1 : 1'b0; //if s[3]==0, then fr1=1, else fr1=0
            fr2 = (s[3:2]==0) ? 1'b1 : 1'b0; //if s[3:2]=0, fr2=1, else fr2=0
            fr3 = (s[3:1]==0) ? 1'b1 : 1'b0; // if s[3:1]==0, fr3=1, else fr3=0
            if(s > last_s)begin
                nextstate = state_upper;
            end
            else if(s == last_s)begin
                nextstate = state_equal;
            end
            else begin
                nextstate = state_lower;
            end
            last_s <= s;
        end
        state_lower: begin
            dfr = 1'b1; //if lower, then dfr=1
            fr1 = (s[3] == 0) ? 1'b1 : 1'b0; //if s[3]==0, then fr1=1, else fr1=0
            fr2 = (s[3:2]==0) ? 1'b1 : 1'b0; //if s[3:2]=0, fr2=1, else fr2=0
            fr3 = (s[3:1]==0) ? 1'b1 : 1'b0; // if s[3:1]==0, fr3=1, else fr3=0
            if(s > last_s)begin
                nextstate = state_upper;
            end
            else if(s == last_s)begin
                nextstate = state_equal;
            end
            else begin
                nextstate = state_lower;
            end
            last_s <= s;
        end
        state_start: begin
            dfr = 1'b0;
            fr1 = 1'b0;
            fr2 = 1'b0;
            fr3 = 1'b0;
            if(s > last_s)begin
                nextstate = state_upper;
            end
            else if(s == last_s)begin
                nextstate = state_equal;
            end
            else begin
                nextstate = state_lower;
            end
            last_s <= s;
        end
    endcase
end


endmodule