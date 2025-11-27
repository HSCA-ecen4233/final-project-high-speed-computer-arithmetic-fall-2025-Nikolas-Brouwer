/* verilator lint_off STMTDLY */
module tb_fma16;
   logic        clk, reset;
   logic [15:0] x, y, z, rexpected, result;
   logic [7:0] 	ctrl;
   logic        mul, add, negp, negz;
   logic [1:0] 	roundmode;
   logic [31:0] vectornum, errors;
   logic [75:0] testvectors[10000:0];
   logic [3:0] 	flags, flagsexpected; // Invalid, Overflow, Underflow, Inexact
   logic [4:0]  ExponentExpected, ResultExponent;
   
   integer 	handle3;
   integer timestamp = 0;
   
  // instantiate device under test
   fma16 dut(x, y, z, mul, add, negp, negz, roundmode, result, flags);
   assign ResultExponent = result[14:10];
   // generate clock
   always 
     begin
	clk = 1; #5; clk = 0; #5;
  timestamp +=10;
     end
   
   // Define the output file
   initial
     begin
	handle3 = $fopen("fma16.out");
	vectornum = 0;
	errors = 0;		
     end   

  // at start of test, load vectors and pulse reset
  initial
    begin
      $readmemh("tests/fma_2.tv", testvectors);
      vectornum = 0; errors = 0;
      reset = 1; #22; reset = 0;
    end

  // apply test vectors on rising edge of clk
  always @(posedge clk)
    begin
      #1; {x, y, z, ctrl, rexpected, flagsexpected} = testvectors[vectornum];
      {roundmode, mul, add, negp, negz} = ctrl[5:0];
      ExponentExpected = rexpected[14:10];

    end

   // check results on falling edge of clk
   always @(negedge clk)
     if (~reset) begin // skip during reset
	if (result !== rexpected /* | flags !== flagsexpected */) begin  // check result
           $fdisplay(handle3, "Error: inputs %h * %h + %h", x, y, z);
           $fdisplay(handle3, "  result = %h (%h expected) flags = %b (%b expected), timestamp %d", 
		     result, rexpected, flags, flagsexpected, timestamp);
           $fdisplay(handle3, "          sign match : %b || exp match : %b || frac match : %b", 
		       (result[15] == rexpected[15]), (result[14:10] == rexpected[14:10]), (result[9:0] == rexpected[9:0]));
           errors = errors + 1;
	end
	vectornum = vectornum + 1;
	if (testvectors[vectornum] === 'x) begin 
           $fdisplay(handle3, "%d tests completed with %d errors", 
	             vectornum, errors);
           $stop;
	end
     end
endmodule
