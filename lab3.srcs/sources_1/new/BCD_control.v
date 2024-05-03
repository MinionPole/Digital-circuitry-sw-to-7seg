module BCD_control (
  input [3:0] digit1, // ones
  input [3:0] digit2, // tens
  input [3:0] digit3, // hundreds
  input [3:0] digit4, // thousands
  input [1:0] refreshcounter,
  output reg [3:0] ONE_DIGIT = 0 // choose which digit is to be displayed
);

always @(refreshcounter) begin
  case (refreshcounter)
    2'b00: 
      ONE_DIGIT = digit1; // digit 1 value ON
    2'b01:
      ONE_DIGIT = digit2; // digit 2 value ON
    2'b10:
      ONE_DIGIT = digit3; // digit 3 value ON
    2'b11:
      ONE_DIGIT = digit4; // digit 4 value ON 
  endcase
end




  
endmodule