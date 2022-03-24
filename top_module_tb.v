
module top_module_tb;
    reg clk, rst_n;
    reg [3:1] s;
    wire fr3, fr2, fr1, dfr;

    top_module u_top_module(clk, rst_n, s, fr3, fr2, fr1, dfr);

    parameter CLK_PERIOD = 2;
    initial begin
        clk = 0;
        forever begin
            #(CLK_PERIOD/2) clk = ~clk;
        end
    end

    always @ (posedge rst_n or negedge rst_n) begin
        if (!rst_n) begin
        $display("%t:%m: resetting ......", $time); 
        end
        else begin
        $display("%t:%m: resetting finish", $time); 
        end
    end

    initial begin
        rst_n = 1;
        #2 
        rst_n = 0;
        s = 0;
        #2 
        rst_n = 1;
        #6 s = 1;
        #2 s = 3;
        #2 s = 7;
        #2 s = 1;
        #2 s = 0;
        #2 s = 1;
        #6 s = 3;
        #2 s = 0;
    end


    initial begin
        #40 $finish;
    end


    initial begin
        $vcdpluson; 
    end

endmodule