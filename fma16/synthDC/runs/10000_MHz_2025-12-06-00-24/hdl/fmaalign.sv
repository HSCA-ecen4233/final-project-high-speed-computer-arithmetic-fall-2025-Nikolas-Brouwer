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

module fmaalign (Ze, Zm, XZero, YZero, ZZero, Xe, Ye, Am, ASticky, KillProd);
   
   input logic [4:0]       Ze, Xe, Ye;
   input logic [10:0]      Zm;
   input logic             XZero, YZero, ZZero;
   output logic            ASticky, KillProd;
   output logic [33:0]     Am;
   logic [6:0]             Acnt;
   logic                   KillZ;
   logic [43:0]            ZmPreShift;
   logic [43:0]            ZmShift;


   //Acnt = Xe + Ye - Bias - Ze + Nf + 2
   //     = Xe + Ye - 15   - Ze + 10 + 2
   //     = Xe + Ye - Ze - 3
   assign Acnt = (Xe + Ye) - Ze - 3;
   //KillZ = Acnt > (3Nf + 3) = (3*10 + 3) = 33
   assign KillZ = $signed(Acnt) > $signed(7'd35);
   assign KillProd = ($signed(Acnt) <= $signed('d0)) | XZero | YZero;
   assign ZmPreShift = {Zm, 33'b0};
   //Zm if Kill product, 0 if Kill Z, ZmPreShift shifted by Acnt otherwise
   assign ZmShift = KillZ ? 44'b0 : (KillProd ? {12'b0, Zm, 21'b0} : (ZmPreShift >> Acnt));
   assign Am = ZmShift >> 10;
   assign ASticky = KillProd ? ~(XZero | YZero) : (KillZ ? ~ZZero : (|ZmShift[9:0]));

endmodule

