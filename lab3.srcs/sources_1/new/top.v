module top (
  input wire clk,
  input wire [15:0] switch,
  output wire [3:0] anode,
  output wire [7:0] cathode
);
  wire refresh_clock;
  wire [1:0] refreshcounter;
  wire [3:0] ONE_DIGIT;

  reg rst = 0;
  reg enable = 1;
  freq_div refreshclk_wapper (
    .clk(clk),
    .rst(rst),
    .enable(enable),
    .div_clk(refresh_clock)
  );

  refreshcounter refreshcnt_wapper (
    .refresh_clock(refresh_clock),
    .refreshcounter(refreshcounter)
  );

  anode_control anode_ctrl_wapper (
    .refreshcounter(refreshcounter),
    .anode(anode)
  );

  BCD_control BCD_ctrl_wapper (
    .digit1(switch[3:0]),
    .digit2(switch[7:4]),
    .digit3(switch[11:8]),
    .digit4(switch[15:12]),
    .refreshcounter(refreshcounter),
    .ONE_DIGIT(ONE_DIGIT)
  );

  BCD_to_Cathodes BCD2Ctds (
    .digit(ONE_DIGIT),
    .cathode(cathode)
  );
  
endmodule
/*
*                 ____      4    digit1       _____________                ____________
*   switch[3:0]  |____|-----/----------------|             |              |            |
*                 ____     4     digit2      |             |              |            |
*   switch[7:4]  |____|----/-----------------|    BCD      |  4           |   BCD to   |   8             ____
*                 ____     4     digit3      |   Control   |--/-----------|  Cathodes  |---/------------|____| cathode[7:0]
*   switch[11:8] |____|----/-----------------|             |ONE_DIGIT[3:0]|            |                 
*                 ____     4     digit4      |             |              |            |
*   switch[15:12]|____|----/-----------------|             |              |____________|
*                                            |_____________|            
*                                                   |
*                                                   |
*                                   __________      |
*                                  |          |     |
*                    refresh_clock |  Refresh |  2  |
*                             _____|  Counter |__/__| refreshcounter[1:0]
*                            |     |__________|     |
*                            |                      |   
*                            |__________            |
*                                       |           |
*                           _________   |     ______|_____      
*                 ____     |  Freq   |  |    |  Anode     |                     4 anode[3:0]          ____
*            clk |____|____|  Div    |__|    |  Control   |---------------------/--------------------|____| anode[3:0]
*                          |_________|       |____________|                                           
*                               
*/