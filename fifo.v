`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.08.2026 05:52:04
// Design Name: 
// Module Name: fifo
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fifo #(
parameter width = 16,
parameter depth = 16,
parameter ALMOST_FULL_THRESHOLD = depth-1,
parameter ALMOST_EMPTY_THRESHOLD = 1

    )(
    input[width-1 :0]wdata,
    input clk,
    input rst,
    input wr_en,
    input rd_en,
    output reg[width-1 :0]rdata,
    output full,
    output empty
    
    );
   // memory declaration
   reg[width-1 :0]mem[0:depth-1];
   reg [$clog2(depth)-1:0] wr_ptr;
   reg [$clog2(depth)-1:0] rd_ptr;
   reg [$clog2(depth+1)-1:0] count;
    wire do_write;
    wire do_read;
    assign full = (count == depth);
    assign empty = (count ==0);
    assign almost_full  = (count >= ALMOST_FULL_THRESHOLD);
assign almost_empty = (count <= ALMOST_EMPTY_THRESHOLD);
    assign do_write = wr_en &&!full;
    assign do_read = rd_en && !empty;
    
   always@(posedge clk) begin
     if(rst) begin                  //reset condition internal ports are 0 in design
     wr_ptr <= 0;
     rd_ptr<= 0;
     rdata<=0;
     count<=0; 
    end 
     else begin
     // write logic
     if(do_write)begin
     mem[wr_ptr]<= wdata;
     wr_ptr <= wr_ptr+1;
     end
     //read
     if(do_read) begin
     rdata<= mem[rd_ptr];
     rd_ptr<= rd_ptr+1;
     end
     
  
      //count
      if(do_write && !do_read)begin
      count <= count +1'b1;
      end
      else if(do_read && !do_write) begin
      count <= count-1'b1;
      end
      end
     end
                        
endmodule
