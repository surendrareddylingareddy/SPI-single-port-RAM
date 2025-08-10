module spi_slave(sclk,rst_n,ss_n,MOSI,tx_data,tx_valid,MISO,rx_data,rx_valid);
  
  input sclk, rst_n;
  input ss_n;
  input MOSI;
  input tx_valid;
  input[DATA_SIZE-1:0] tx_data;
  
  output reg MISO;
  output reg[INST_SIZE-1:0] rx_data; 
  output reg rx_valid;
  
  typedef enum {IDLE, 
                WRITE_READ, 
                WRITE_ADDR, 
                READ_ADDR, 
                WRITE_DATA, 
                READ_DATA} STATE_s;
  
  int count_rx,count_tx;
  
  STATE_s curr, next;
  
  always@(posedge sclk or negedge rst_n)begin
    if(~rst_n)begin
      curr <= IDLE;
    end
    else begin
      curr <= next;
    end
  end
  
  //fsm for next state
  always@(*)begin
    case(curr)
      IDLE : begin
        if(!ss_n)begin
          next = WRITE_READ;
        end
        else begin
          next = IDLE;
        end
      end
      WRITE_READ : begin
        if((ss_n == 0) && (MOSI == 1))begin
          next = WRITE_ADDR;
        end
        else if((ss_n == 0)&&(MOSI == 0))begin
          next = READ_ADDR;
        end
        else begin
          next = IDLE;
        end
      end
      WRITE_ADDR : begin
        if((ss_n == 0)&&(count_rx < 8))begin
          next = WRITE_ADDR;
        end
        else if((ss_n == 0)&&(count_rx >= 8))begin
          next = WRITE_DATA;
        end
        else begin
          next = IDLE;
        end
      end
      WRITE_DATA : begin
        if(ss_n == 0)begin
          next = WRITE_DATA;
        end
        else begin
          next = IDLE;
        end
      end
      READ_ADDR : begin
        if((ss_n == 0)&&(count_rx < 7))begin
          next = READ_ADDR;
        end
        else if((ss_n == 0)&&(count_rx >= 7))begin
          next = READ_DATA;
        end
        else begin
          next = IDLE;
        end
      end
      READ_DATA : begin
        if(ss_n == 0)begin
          next = READ_DATA;
        end
        else begin
          next = IDLE;
        end
      end
    endcase  
  end
  
  //fsm for output
  always@(posedge sclk or negedge rst_n)begin
    if(!rst_n)begin
      count_rx <= 0;
      count_tx <= 0;
      MISO <= 0;
      rx_data <= 0;
      rx_valid <= 0;
    end
    else begin
      case(curr)
        IDLE : begin
          count_rx <= 0;
          count_tx <= 0;
          MISO <= 0;
          rx_data <= 0;
          rx_valid <= 0;
        end
        WRITE_READ : begin
          rx_data[15-count_rx] <= MOSI;
          count_rx <= count_rx + 1;
        end
        WRITE_ADDR : begin
          rx_data[15-count_rx] <= MOSI;
          count_rx <= count_rx + 1;
        end
        WRITE_DATA : begin
          if(count_rx < 16)begin
            rx_data[15-count_rx] <= MOSI;
            count_rx <= count_rx + 1;
          end
          else begin
            rx_valid <= 1;
          end
        end
        READ_ADDR : begin
          rx_data[15-count_rx] <= MOSI;
          count_rx <= count_rx + 1;
        end
        READ_DATA : begin
          rx_valid <= 1;
          if(tx_valid && (count_tx < 8))begin
            MISO <= tx_data[count_tx];
            count_tx <= count_tx + 1;
          end
        end
      endcase     
    end   
  end
  
endmodule
