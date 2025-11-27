// fma16.sv
// David_Harris@hmc.edu 26 February 2022

// Operation: general purpose multiply, add, fma, with optional negation
//   If mul=1, p = x * y.  Else p = x.
//   If add=1, result = p + z.  Else result = p.
//   If negr or negz = 1, negate result or z to handle negations and subtractions
//   fadd: mul = 0, add = 1, negr = negz = 0
//   fsub: mul = 0, add = 1, negr = 0, negz = 1
//   fmul: mul = 1, add = 0, negr = 0, negz = 0
//   fmadd:  mul = 1, add = 1, negr = 0, negz = 0
//   fmsub:  mul = 1, add = 1, negr = 0, negz = 1
//   fnmadd: mul = 1, add = 1, negr = 1, negz = 0
//   fnmsub: mul = 1, add = 1, negr = 1, negz = 1

module fmaexpadd (Xe, Ye, XZero, YZero, Pe);
   
   input logic [4:0]    Xe;
   input logic [4:0]    Ye;
   input logic          XZero;
   input logic          YZero;
   output logic [6:0]   Pe;
   logic                PZero;
   
   assign PZero = XZero | YZero;
   assign Pe = PZero ? 7'h0 : ({2'b0, Xe} + {2'b0, Ye} -{2'b0, 5'b0_1111});
endmodule

