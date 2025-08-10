`include "wrapper.sv"
module top;
  reg sclk,rst_n,ss_n,MOSI;
  wire MISO;
  
  wrapper dut(sclk,rst_n,ss_n,MOSI,MISO);
  
  initial begin
    sclk = 0;
    forever #5 sclk = ~sclk;
  end
  
  initial begin
    rst_n = 0;
    ss_n = 1;
    #15;
    rst_n = 1;
    #5; 
    ss_n = 0;
    #10;
    @(posedge sclk);
    MOSI = 1;
    @(posedge sclk);
    MOSI = 1;
    @(posedge sclk);
    MOSI = 1;
    @(posedge sclk);
    MOSI = 1;
    @(posedge sclk);
    MOSI = 1;
    @(posedge sclk);
    MOSI = 1;
    @(posedge sclk);
    MOSI = 1;
    @(posedge sclk);
    MOSI = 1;
    @(posedge sclk);
    MOSI = 1;
    @(posedge sclk);
    MOSI = 1;
    @(posedge sclk);
    MOSI = 1;
    @(posedge sclk);
    MOSI = 1;
    @(posedge sclk);
    MOSI = 1;
    @(posedge sclk);
    MOSI = 1;
    @(posedge sclk);
    MOSI = 1;
    @(posedge sclk);
    MOSI = 1;
    
    repeat(5)begin
      @(posedge sclk);
    end
    ss_n = 1;
    
    @(posedge sclk);
    ss_n = 0;
    
    @(posedge sclk);
    MOSI = 0;
    @(posedge sclk);
    MOSI = 1;
    @(posedge sclk);
    MOSI = 1;
    @(posedge sclk);
    MOSI = 1;
    @(posedge sclk);
    MOSI = 1;
    @(posedge sclk);
    MOSI = 1;
    @(posedge sclk);
    MOSI = 1;
    @(posedge sclk);
    MOSI = 1;
    
  end
  
  initial begin
    #500;
    $finish;
  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
  
endmodule
