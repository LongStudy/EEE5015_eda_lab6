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
Above S3            S[3:1]=7 // S[3]=1
Between S3 and S2   S[3:1]=3 // S[2]=1  
Between S2 and S1   S[3:1]=1 // S[1]=1
Below S1            S[3:1]=0 // S[3:1]=1
*/

parameter // State variable enumeration
    state_upper = 2'b00, // S[3:1]>last_s
    state_equal = 2'b01, // S[3:1]=last_s
    state_lower = 2'b10, // S[3:1]<last_s

reg [1:0] state; // State variable
reg [1:0] nextstate;// Next state register
reg [3:1] last_s; // last_s[3:1] is the last s[3:1] value

always @(posedge clk)begin
	if(!rst_n)
        last_s <= s;
		state <= state_equal;
    else
        state <= nextstate;

end

always @(state) begin
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
            last_s = s;
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
            last_s = s;
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
            last_s = s;
        end
        default: begin
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
            last_s = s;
    endcase
end


endmodule