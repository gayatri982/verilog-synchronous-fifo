`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.08.2026 05:52:25
// Design Name: 
// Module Name: fifo_tb
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


module fifo_tb(

    );
    parameter width = 16;
parameter depth = 16;
  reg clk;
  reg rst;
  reg wr_en;
  reg rd_en;
  reg [width-1:0]wdata;
  wire [width-1:0]rdata;
  wire full;
  wire empty;
  reg [width-1:0] read_data;
  integer i;
  //DUT
  fifo #(
    .width(width),
    .depth(depth)
) dut (
    .clk(clk),
    .rst(rst),
    .wr_en(wr_en),
    .rd_en(rd_en),
    .wdata(wdata),
    .rdata(rdata),
    .full(full),
    .empty(empty)
);
//clk
initial begin
clk =0;
forever #5 clk = ~clk;
end
 

 //write task
 task write_fifo(input[width-1:0]data);
 begin
 wdata = data;
 wr_en = 1;
 @(posedge clk);
 #1;
 wr_en =0;
 end
 endtask
 
 //read task
 task read_fifo(output[width-1:0] data);
 begin
 rd_en = 1;

 @(posedge clk);
 #1;
 data = rdata;
 rd_en =0;
 end
 endtask
  task read_and_check(input [width-1:0] expected_data);

        begin

            read_fifo(read_data);

            if (read_data === expected_data)

                $display(
                    "READ CHECK PASS : Expected=%h Got=%h",
                    expected_data,
                    read_data
                );

            else

                $display(
                    "READ CHECK FAIL : Expected=%h Got=%h",
                    expected_data,
                    read_data
                );

        end

    endtask


 //TEST
 initial
 begin
 rst = 1;
 wr_en =0;
 rd_en =0;
 wdata =0;
 
 repeat(2) @(posedge clk);
 #5;
 rst =0;
 
 //TEST 1 :RESET/EMPTY
 if(empty && !full) 
 $display("reset/empty test :pass");
 else
 $display("reset/empty test : fail");
 
 //TEST 2: write 4 data
 
 
 
   write_fifo(16'hA5);
    write_fifo(16'hB6);
    write_fifo(16'hC7);
    write_fifo(16'hD8);
    
    //TEST 3: READ 4 DATA
    read_fifo(read_data);
    if(read_data == 16'hA5)
    $display("Read 1 : Pass");
    else
    $display("Read 1 : Fail");
    
    read_fifo(read_data);
    if(read_data == 16'hB6)
    $display("Read 2 : Pass");
    else
    $display("Read 2 : Fail");
    
    read_fifo(read_data);
    if(read_data == 16'hC7)
    $display("Read 3 : Pass");
    else
    $display("Read 3 : Fail");
    
    read_fifo(read_data);
    if(read_data == 16'hD8)
    $display("Read 4 : Pass");
    else
    $display("Read 4 : Fail");
    
    //TEST 4: FIFO Is EMPTY 
    if(empty && !full)
    $display("Fifo empty test : pass");
    else
    $display("Fifo empty test : Fail");
    
    //TEST 5: WRITE FULL FIFO
    
    write_fifo(16'h00);
    write_fifo(16'h11);
    write_fifo(16'h22);
    write_fifo(16'h33);
    write_fifo(16'h44);
    write_fifo(16'h55);
    write_fifo(16'h66);
    write_fifo(16'h77);
    write_fifo(16'h88);
    write_fifo(16'h99);
    write_fifo(16'hAA);
    write_fifo(16'hBB);
    write_fifo(16'hCC);
    write_fifo(16'hDD);
    write_fifo(16'hEE);
    write_fifo(16'hFF);
    
    
    
    
    
    
    
    
    if(full && !empty)
    $display("Fifo full test : pass");
    else
    $display("Fifo full test : Fail");
    
    //TEST 6: FIFO OVERFULL PROTECTIONS
   write_fifo(8'hAA);
   if(dut.count == depth)
   $display("Fifo overflow test : Pass");
   else
   $display("Fifo overflow test : Fail");
   
   //TEST 7: Read all data
   read_fifo(read_data);
   read_fifo(read_data);
   read_fifo(read_data);
   read_fifo(read_data);
   read_fifo(read_data);
   read_fifo(read_data);
   read_fifo(read_data);
   read_fifo(read_data);
   read_fifo(read_data);
   read_fifo(read_data);
   read_fifo(read_data);
   read_fifo(read_data);
   read_fifo(read_data);
   read_fifo(read_data);
   read_fifo(read_data);
   read_fifo(read_data);
   
   //TEST 8:Empty Again
   if(empty && !full)
   $display("Fifo empty test : Pass");
   else
   $display("Fifo empty test : Fail");
   
   //TEST 9 : Underflow protection
   
  read_fifo(read_data);
  if(dut.count == 0)
  $display("Underflow protection : Pass");
  else 
  $display("Underflow Protection : Fail");
  
  
  // SIMULTANEOUS READ + WRITE

// Reset FIFO
rst = 1;

@(posedge clk);
#1;

rst = 0;

// Write 4 data
write_fifo(16'hA5);
write_fifo(16'hB6);
write_fifo(16'hC7);
write_fifo(16'hD8);

// Now:
// count  = 4
// wr_ptr = 4
// rd_ptr = 0

// Simultaneous READ + WRITE

wdata = 16'hEE;
wr_en = 1;
rd_en = 1;

@(posedge clk);
#1;

wr_en = 0;
rd_en = 0;

if ((rdata == 16'hA5) && (dut.count == 4)) begin

    $display("SIMULTANEOUS READ/WRITE : PASS");
    $display("rdata=%h count=%0d wr_ptr=%0d rd_ptr=%0d",
             rdata, dut.count, dut.wr_ptr, dut.rd_ptr);

end
else begin

    $display("SIMULTANEOUS READ/WRITE : FAIL");
    $display("rdata=%h count=%0d wr_ptr=%0d rd_ptr=%0d",
             rdata, dut.count, dut.wr_ptr, dut.rd_ptr);

end

if ((rdata == 16'hA5) &&
    (dut.count == 4) &&
    (dut.wr_ptr == 5) &&
    (dut.rd_ptr == 1)) begin

    $display("SIMULTANEOUS READ/WRITE : PASS");
    $display("rdata=%h count=%0d wr_ptr=%0d rd_ptr=%0d",
             rdata, dut.count, dut.wr_ptr, dut.rd_ptr);

end
else begin

    $display("SIMULTANEOUS READ/WRITE : FAIL");
    $display("rdata=%h count=%0d wr_ptr=%0d rd_ptr=%0d",
             rdata, dut.count, dut.wr_ptr, dut.rd_ptr);

end

// TEST 10: WRITE POINTER WRAP-AROUND


// Reset FIFO
rst = 1;
@(posedge clk);
#1;
rst = 0;

// Write 6 values
write_fifo(16'h10);
write_fifo(16'h11);
write_fifo(16'h12);
write_fifo(16'h13);
write_fifo(16'h14);
write_fifo(16'h15);

// Check wr_ptr = 6
if (dut.wr_ptr == 6)
    $display("WRITE POINTER BEFORE WRAP : PASS");
else
    $display("WRITE POINTER BEFORE WRAP : FAIL | wr_ptr=%0d",
             dut.wr_ptr);

// Write at mem[7]
write_fifo(16'h16);

if (dut.wr_ptr == 7)
    $display("WRITE POINTER = 7 : PASS");
else
    $display("WRITE POINTER = 7 : FAIL");


// Fill locations 7 through 15
for (i = 7; i < 16; i = i + 1)
    write_fifo(i);

// After writing at address 15, pointer wraps to 0
if (dut.wr_ptr == 0)
    $display("WRITE POINTER WRAP-AROUND : PASS");
else
    $display("WRITE POINTER WRAP-AROUND : FAIL | wr_ptr=%0d",
             dut.wr_ptr);
             
             


// TEST 11: READ POINTER WRAP-AROUND


// Read 6 data
repeat(6)
    read_fifo(read_data);

if (dut.rd_ptr == 6)
    $display("READ POINTER BEFORE WRAP : PASS");
else
    $display("READ POINTER BEFORE WRAP : FAIL | rd_ptr=%0d",
             dut.rd_ptr);

// Read from mem[7]
read_fifo(read_data);

if (dut.rd_ptr == 7)
    $display("READ POINTER = 7 : PASS");
else
    $display("READ POINTER = 7 : FAIL");
   // Fill locations 7 through 15 
    for (i = 7; i < 16; i = i + 1)
    read_fifo(i);

// After reading at address 15, pointer wraps to 0
if (dut.rd_ptr == 0)
    $display("READ POINTER WRAP-AROUND : PASS");
else
    $display("READ POINTER WRAP-AROUND : FAIL | rd_ptr=%0d",
             dut.rd_ptr);
             
             
 
// TEST 12: TRUE CIRCULAR FIFO WRAP-AROUND



// Reset FIFO
rst = 1;
@(posedge clk);
#1;
rst = 0;


// STEP 1: Write 16 data
write_fifo(16'hA0);
write_fifo(16'hA1);
write_fifo(16'hA2);
write_fifo(16'hA3);
write_fifo(16'hA4);
write_fifo(16'hA5);
write_fifo(16'hA6);
write_fifo(16'hA7);
write_fifo(16'hA8);
write_fifo(16'hA9);
write_fifo(16'hA10);
write_fifo(16'hA11);
write_fifo(16'hA12);
write_fifo(16'hA13);
write_fifo(16'hA14);
write_fifo(16'hA15);


// Check FIFO full
if (full)
    $display("FIFO FULL AFTER 16 WRITES : PASS");
else
    $display("FIFO FULL AFTER 16 WRITES : FAIL");


// STEP 2: Read first 8 data
read_and_check(16'hA0);
read_and_check(16'hA1);
read_and_check(16'hA2);
read_and_check(16'hA3);
read_and_check(16'hA4);
read_and_check(16'hA5);
read_and_check(16'hA6);
read_and_check(16'hA7);



// Expected state:
// wr_ptr = 0
// rd_ptr = 8
// count = 8


if ((dut.wr_ptr == 0) &&
    (dut.rd_ptr == 8) &&
    (dut.count == 8))
    $display("FIRST READ POINTER CHECK : PASS");
else
    $display("FIRST READ POINTER CHECK : FAIL");


// STEP 3: Write new data (wrap-around)
write_fifo(16'hB0);
write_fifo(16'hB1);
write_fifo(16'hB2);
write_fifo(16'hB3);
write_fifo(16'hB4);
write_fifo(16'hB5);
write_fifo(16'hB6);
write_fifo(16'hB7);



// Expected:
// B0 → mem[0]
// B1 → mem[1]
// B2 → mem[2]
// B3 → mem[3]

if ((dut.wr_ptr == 8) &&
    (dut.rd_ptr == 8) &&
    (dut.count == 16))
    $display("WRITE WRAP-AROUND CHECK : PASS");
else
    $display("WRITE WRAP-AROUND CHECK : FAIL");


// STEP 4: Read remaining data in FIFO order

read_and_check(16'hA8);
read_and_check(16'hA9);
read_and_check(16'hA10);
read_and_check(16'hA11);
read_and_check(16'hA12);
read_and_check(16'hA13);
read_and_check(16'hA14);
read_and_check(16'hA15);

read_and_check(16'hB0);
read_and_check(16'hB1);
read_and_check(16'hB2);
read_and_check(16'hB3);
read_and_check(16'hB4);
read_and_check(16'hB5);
read_and_check(16'hB6);
read_and_check(16'hB7);


// STEP 5: Final empty check

if (empty && (dut.count == 0))
    $display("CIRCULAR FIFO FINAL EMPTY : PASS");
else
    $display("CIRCULAR FIFO FINAL EMPTY : FAIL");


//TEST 13: Single write and read

rst = 1'b1;
@(posedge clk);
#1;
rst = 1'b0;

write_fifo(16'h1234);

if (dut.count == 1)
    $display("PASS: Count is 1");
else
    $display("FAIL: Count is %0d, Expected 1", dut.count);

read_and_check(16'h1234);

if (empty)
    $display("PASS: FIFO is empty after reading one item");
else
    $display("FAIL: FIFO is not empty");

//TEST 14: FIFO ordering

rst = 1'b1;
@(posedge clk);
#1;
rst = 1'b0;

write_fifo(16'h1111);
write_fifo(16'h2222);
write_fifo(16'h3333);
write_fifo(16'h4444);

read_and_check(16'h1111);
read_and_check(16'h2222);
read_and_check(16'h3333);
read_and_check(16'h4444);


//TEST 15: Partial read and write

rst = 1'b1;
@(posedge clk);
#1;
rst = 1'b0;

write_fifo(16'hAAAA);
write_fifo(16'hBBBB);
write_fifo(16'hCCCC);

read_and_check(16'hAAAA);

write_fifo(16'hDDDD);

read_and_check(16'hBBBB);
read_and_check(16'hCCCC);
read_and_check(16'hDDDD);

//TEST 16: Full flag

rst = 1'b1;
@(posedge clk);
#1;
rst = 1'b0;

for (i = 0; i < depth; i = i + 1)
    write_fifo(16'h1000 + i);

if (full)
    $display("PASS: Full flag asserted");
else
    $display("FAIL: Full flag not asserted");

if (dut.count == depth)
    $display("PASS: Count reached depth");
else
    $display("FAIL: Count = %0d, Expected %0d", dut.count, depth);
    
    
   //TEST 17: Empty flag

rst = 1'b1;
@(posedge clk);
#1;
rst = 1'b0;

if (empty)
    $display("PASS: Empty flag asserted after reset");
else
    $display("FAIL: Empty flag not asserted");

write_fifo(16'h5555);

if (!empty)
    $display("PASS: Empty flag deasserted after write");
else
    $display("FAIL: Empty flag still asserted");

read_and_check(16'h5555);

if (empty)
    $display("PASS: Empty flag asserted after read");
else
    $display("FAIL: Empty flag not asserted after read");
    
 //TEST 18: Simultaneous read and write when FIFO is partially full

rst = 1'b1;
@(posedge clk);
#1;
rst = 1'b0;

write_fifo(16'hAAAA);
write_fifo(16'hBBBB);
write_fifo(16'hCCCC);

@(negedge clk);
wr_en = 1'b1;
rd_en = 1'b1;
wdata = 16'hDDDD;

@(posedge clk);
#1;

wr_en = 1'b0;
rd_en = 1'b0;

if (rdata == 16'hAAAA)
    $display("PASS: Correct data read during simultaneous operation");
else
    $display("FAIL: Expected AAAA, Got %h", rdata);

if (dut.count == 3)
    $display("PASS: Count remains unchanged");
else
    $display("FAIL: Count = %0d, Expected 3", dut.count);

read_and_check(16'hBBBB);
read_and_check(16'hCCCC);
read_and_check(16'hDDDD);

//TEST 19: Write while full

rst = 1'b1;
@(posedge clk);
#1;
rst = 1'b0;

for (i = 0; i < depth; i = i + 1)
    write_fifo(16'h2000 + i);

if (!full)
    $display("FAIL: FIFO should be full");

write_fifo(16'hFFFF);

if (dut.count == depth)
    $display("PASS: Overflow write rejected");
else
    $display("FAIL: Count changed during overflow");
    
  //TEST 20: Read while empty

rst = 1'b1;
@(posedge clk);
#1;
rst = 1'b0;

if (!empty)
    $display("FAIL: FIFO should be empty");

rd_en = 1'b1;

@(posedge clk);
#1;

rd_en = 1'b0;

if (dut.count == 0)
    $display("PASS: Underflow read rejected");
else
    $display("FAIL: Count changed during underflow");
$finish;

end

endmodule
  
