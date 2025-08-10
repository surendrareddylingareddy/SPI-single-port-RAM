module ram(clk,rst_n,rx_data,rx_valid,tx_data,tx_valid);
  
  input clk, rst_n;
  input[INST_SIZE-1:0] rx_data;
  input rx_valid;
  
  output reg[DATA_SIZE-1:0] tx_data;
  output reg tx_valid;
  
  reg[DATA_SIZE-1:0] mem [MEM_DEPTH-1:0];
  
  always@(posedge clk or negedge rst_n)begin
    if(~rst_n)begin
      tx_valid <= 0;
      tx_data <= 0;
    end
    else begin
      if(rx_valid)begin
        tx_valid <= (!rx_data[15] & rx_valid);
        case(rx_data[15])
          1 : mem[rx_data[14:8]] <= rx_data[7:0];
          0 : tx_data <= mem[rx_data[14:8]];
        endcase
      end
    end
  end
  
endmodule
