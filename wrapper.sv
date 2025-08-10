`include "params.svh"
`include "ram.sv"
`include "spi.sv"

module wrapper(sclk,rst_n,ss_n,MOSI,MISO);
  input sclk, rst_n;
  input ss_n;
  input MOSI;
  output MISO;
  
  reg[DATA_SIZE-1:0] tx_data;
  reg[INST_SIZE-1:0] rx_data;
  
  reg tx_valid, rx_valid;
  
  spi_slave dut1(sclk,rst_n,ss_n,MOSI,tx_data,tx_valid,MISO,rx_data,rx_valid);
  
  ram dut2(sclk,rst_n,rx_data,rx_valid,tx_data,tx_valid);
  
endmodule
