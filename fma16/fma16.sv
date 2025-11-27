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

module fma16 (x, y, z, mul, add, negr, negz,
	      roundmode, result, flags);
   
   input logic [15:0]  x, y, z;   
   input logic 	       mul, add, negr, negz;
   input logic [1:0]   roundmode;
   
   output logic [15:0] result;
   output logic [3:0]  flags;

   logic [4:0] 	       Xe, Ye, Ze;
   logic [10:0] 	       Xm, Ym, Zm;
   logic 	             Xs, Ys, Zs;
   logic         XNaN, YNaN, ZNaN;
   logic         XSNaN, YSNaN, ZSNaN;
   logic         XZero, YZero, ZZero;
   logic         XInf, YInf, ZInf;
   logic         XExpMax, YExpMax, ZExpMax;
   logic         XSubnorm, YSubnorm, ZSubnorm;

   logic [33:0]         Am;
   logic                KillProd, ASticky, As, InvA;

   logic [6:0]          Pe;
   logic [21:0]         Pm;
   logic                Ps;

   logic [6:0]          Me;
   logic [21:0]         Mm;
   logic                Ms;

   logic [6:0]          Se, CountE;
   logic [33:0]         Sm, SmNormal;
   logic                Ss;
   // stubbed ideas for instantiation ideas
   
   unpack XUnpack(x, Xs, Xe, Xm, XNaN, XSNaN, XZero, XInf, XExpMax, XSubnorm);
   unpack YUnpack(y, Ys, Ye, Ym, YNaN, YSNaN, YZero, YInf, YExpMax, YSubnorm);
   unpack ZUnpack(z, Zs, Ze, Zm, ZNaN, ZSNaN, ZZero, ZInf, ZExpMax, ZSubnorm);

   // fmaexpadd expadd(.Xe, .Ye, .XZero, .YZero, .Pe);

   fmaexpadd expadd(Xe, Ye, XZero, YZero, Pe);

   // fmamult mult(.Xm, .Ym, .Pm);
   fmamult mult(Xm, Ym, Pm);
   // fmasign sign(.OpCtrl, .Xs, .Ys, .Zs, .Ps, .As, .InvA);
   fmasign sign(negz, Xs, Ys, Zs, Ps, As, InvA);
   // fmaalign align(.Ze, .Zm, .XZero, .YZero, .ZZero, .Xe, .Ye, .Am, .ASticky, .KillProd);
   fmaalign align(Ze, Zm, XZero, YZero, ZZero, Xe, Ye, Am, ASticky, KillProd);
   // fmaadd add(.Am, .Pm, .Ze, .Pe, .Ps, .KillProd, .ASticky, .AmInv, .PmKilled, .InvA, .Sm, .Se, .Ss);
   fmaadd FMAadd(Am, Pm, Ze, Pe, Ps, KillProd, ASticky, InvA, Sm, Se, Ss);
   // fmalza lza (.A(AmInv), .Pm(PmKilled), .Cin(InvA & (~ASticky | KillProd)), .sub(InvA), .SCnt);
   fmalza lza(Sm, SmNormal, CountE);

   //assign Ms = Ps;
   //assign Mm = (Pm[21] ? Pm : {Pm[20:0], 1'b0});
   //assign Me = (Pm[21] ? (Pe + 1) : Pe);
   
   assign Ms = Ss;
   assign Me = Se - CountE;
   assign Mm = SmNormal[33:12];

   assign result = {Ms, Me[4:0], Mm[20: 11]};
 
endmodule

