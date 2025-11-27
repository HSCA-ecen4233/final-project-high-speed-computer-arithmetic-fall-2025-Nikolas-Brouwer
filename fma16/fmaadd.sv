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

module fmaadd (Am, Pm, Ze, Pe, Ps, KillProd, ASticky, InvA, Sm, Se, Ss);
   input logic [33:0]      Am;
   input logic [21:0]      Pm;
   input logic [4:0]       Ze;
   input logic [6:0]       Pe;
   input logic             Ps, KillProd, ASticky, InvA;
   output logic [33:0]     Sm;
   output logic [6:0]      Se;
   output logic            Ss;

   logic [33:0]            AmInv;
   logic [21:0]            PmKilled;
   logic [33:0]            PreSum, NegPreSum;
   logic                   NegSum;

   assign AmInv = InvA ? ~Am : Am;
   assign PmKilled = KillProd ? 22'b0 : Pm;
   assign PreSum = {11'b0, PmKilled, 1'b0} + AmInv + {33'b0, ((~ASticky)|KillProd)&InvA};
   assign NegPreSum = Am + (~{11'b0, PmKilled, 1'b0}) + {33'b0, ((~ASticky)|(~KillProd))};
   assign NegSum = PreSum[33];

   assign Ss = Ps ^ NegSum;
   assign Se = KillProd ? {2'b0, Ze} : Pe;
   assign Sm =  NegSum ? NegPreSum : PreSum;
   
endmodule

