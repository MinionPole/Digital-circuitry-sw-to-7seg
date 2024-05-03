module mru
#(
    parameter BUF_SIZE = 8,
    parameter WIDTH  = 16
    )
(
    input clk,
    input rst,
    input set,
    input [15:0] data,
    reg getData, // flagToGetData
    input enable,
    output[15:0] dataToOut,
    output [3:0] dataSize
    );
    localparam [1:0] IDLE = 2'b00, CHECKING_HIT = 2'b01, HIT_UPDATING = 2'b10, WRITE_VALUE = 2'b11;

    reg [15:0] dataCopy;
    reg [WIDTH - 1 :0] outs[BUF_SIZE - 1:0];
    reg[1:0] state;

    reg [2:0] hitIndex; // reg to counting
    reg [2:0] index; // last in MRU
    reg [3:0] freeEl = 3'b0; // first free_el 

    assign dataSize = freeEl;
 
    always @ (posedge clk, negedge rst) begin
        if(enable)
        begin
            if (!rst) begin
                outs[0] <= 16'd0;
                outs[1] <= 16'd0;
                outs[2] <= 16'd0;
                outs[3] <= 16'd0;
                
                outs[4] <= 16'd0;
                outs[5] <= 16'd0;
                outs[6] <= 16'd0;
                outs[7] <= 16'd0;
                
                dataCopy <= 16'd0;
 
                hitIndex <= 3'd0;
                index <= 3'd0;
                freeEl <= 4'd0;
                
                dataToOut <= 16'd0;

                state <= IDLE;
            end else
            case(state)
                IDLE: begin
                    if(getData) begin 
                        case data
                        0: dataToOut <= outs[0];
                        1: dataToOut <= outs[1];
                        2: dataToOut <= outs[2];
                        3: dataToOut <= outs[3];
                        4: dataToOut <= outs[4];
                        5: dataToOut <= outs[5];
                        6: dataToOut <= outs[6];
                        7: dataToOut <= outs[7];                        
                        endcase
                    end
                    if(set) begin 
                        state <= CHECKING_HIT;
                        dataCopy <= data;
                        hitIndex <= 0;
                    end
                end
                CHECKING_HIT: begin
                    if(hitIndex > 3) begin
                    state <= WRITE_VALUE;
                    if(freeEl < 8)
                    begin
                        index <= freeEl;
                        freeEl <= freeEl + 1;
                    end
                    end
                    else begin
                        case(hitIndex)
                                0:  begin
                                    if(outs[0] == dataCopy) state <= HIT_UPDATING;
                                    else hitIndex <= hitIndex + 1;  
                                end
                                1:  begin  
                                    if(outs[1] == dataCopy) state <= HIT_UPDATING;
                                    else hitIndex <= hitIndex + 1;  
                                end
                                2:  begin
                                    if(outs[2] == dataCopy) state <= HIT_UPDATING;
                                    else hitIndex <= hitIndex + 1;  
                                end                            
                                3:  begin
                                    if(outs[3] == dataCopy) state <= HIT_UPDATING;
                                    else hitIndex <= hitIndex + 1;  
                                end
                                4:  begin
                                    if(outs[4] == dataCopy) state <= HIT_UPDATING;
                                    else hitIndex <= hitIndex + 1;  
                                end
                                5:  begin
                                    if(outs[5] == dataCopy) state <= HIT_UPDATING;
                                    else hitIndex <= hitIndex + 1;  
                                end
                                6:  begin
                                    if(outs[6] == dataCopy) state <= HIT_UPDATING;
                                    else hitIndex <= hitIndex + 1;  
                                end
                                7:  begin
                                    if(outs[7] == dataCopy) state <= HIT_UPDATING;
                                    else hitIndex <= hitIndex + 1;  
                                end                                                        
                        endcase                                 
                    end
                end
                HIT_UPDATING: begin
                    index <= hitIndex;
                end
                WRITE_VALUE: begin
                    case (index)
                    0: outs[0] <= dataCopy;
                    1: outs[1] <= dataCopy;
                    2: outs[2] <= dataCopy;
                    3: outs[3] <= dataCopy;
                    4: outs[4] <= dataCopy;
                    5: outs[5] <= dataCopy;
                    6: outs[6] <= dataCopy;
                    7: outs[7] <= dataCopy;
                    endcase
                end
            endcase            
        end
 
    end
endmodule