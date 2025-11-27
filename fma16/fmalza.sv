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

module fmalza (Sm, SmShifted, CountE);
   
   input logic [33:0]      Sm;
   output logic [33:0]     SmShifted;
   output logic [6:0]      CountE;
   logic [33:0]            Sm1, Sm2, Sm3, Sm4, Sm5;
   logic [6:0]             CountTemp;

   assign Sm1 = (|Sm[33:2]) ? Sm : (Sm << 32);
   assign Sm2 = (|Sm1[33:18]) ? Sm1 : (Sm1 << 16);
   assign Sm3 = (|Sm2[33:26]) ? Sm2 : (Sm2 << 8);
   assign Sm4 = (|Sm3[33:30]) ? Sm3 : (Sm3 << 4);
   assign Sm5 = (|Sm4[33:32]) ? Sm4 : (Sm4 << 2);
   assign SmShifted = Sm5[33] ? Sm5 : (Sm5 << 1);
   assign CountTemp = {1'b0, ~(|Sm[33:2]), ~(|Sm1[33:18]), ~(|Sm2[33:26]), ~(|Sm3[33:30]), ~(|Sm4[33:32]), ~Sm5[33]};
   assign CountE = CountTemp - 7'd12;
endmodule

