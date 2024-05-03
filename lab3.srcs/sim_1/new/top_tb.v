`timescale 1ns / 1ps

module top_tb;
    reg clk = 0;
    wire [3:0] anode;
    wire [7:0] cathode;
    reg [15:0] switch = 0;
 
top uut (
    .clk(clk),
    .anode(anode),
    .cathode(cathode),
    .switch(switch)
);
always #5 clk = ~clk;

initial
begin
    #100 switch[3:0] = 4;
    #100 switch[7:4] = 8;
    #100 switch[11:8] = 1;
    #100 switch[15:12] = 3;
end

endmodule
