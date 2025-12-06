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

module unpack (X, SgnX, ExpX, ManX, XNaN, XSNaN, XZero, XInf, XExpMax, XSubnorm);

   input logic [15:0]   X;
   output logic         SgnX;
   output logic [4:0]   ExpX;
   output logic [10:0]  ManX;
   output logic         XNaN;
   output logic         XSNaN;
   output logic         XZero;
   output logic         XInf;
   output logic         XExpMax;
   output logic         XSubnorm;

   logic [9:0]          XFrac;
   logic                XFracZero;
   logic                ExpNonZero;

   assign SgnX = X[15];
   assign XFrac = X[9:0];
   assign ExpNonZero = |X[14:10];
   assign ManX = {ExpNonZero, XFrac};
   assign XExpMax = &X[14:10];
   assign XFracZero = ~|XFrac;
   assign XNaN = XExpMax & ~XFracZero;
   assign XSNaN = XNaN & XFrac[9];
   assign XZero = ~ExpNonZero & XFracZero;
   assign XSubnorm = ~ExpNonZero & ~XFracZero;
   assign XInf = XExpMax & XFracZero;
   assign ExpX = {X[14:11], X[10]|(~ExpNonZero)};
   
   
 
endmodule

