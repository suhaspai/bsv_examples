// Can you provide an example code in Bluespec SystemVerilog for generating n-th Fibonacci sequence output?
// ChatGPT said:
// Absolutely! Here's a simple and clear Bluespec SystemVerilog (BSV) example that generates the n-th Fibonacci number using an FSM-style approach.
// ✅ Goal:
//     Input: n (as a parameter or register)
//     Output: The n-th Fibonacci number
//     Fibonacci sequence: 0, 1, 1, 2, 3, 5, 8, 13, ...


// File: Fibonacci.bsv
package Fibonacci;

import RegFile::*;
//import Reg::*;       <-- commented - part of primitive libary
import FIFO::*;
import Vector::*;

// Interface
interface FibonacciGen;
   method Action start(UInt#(32) n);
   method Bool done();
   method UInt#(32) result();
endinterface

// Module
module mkFibonacciGen(FibonacciGen);

   Reg#(UInt#(32)) a <- mkReg(0);
   Reg#(UInt#(32)) b <- mkReg(1);
   Reg#(UInt#(32)) count <- mkReg(0);
   Reg#(UInt#(32)) target <- mkReg(0);
   Reg#(Bool) running <- mkReg(False);

   // FSM rule to calculate Fibonacci iteratively
   rule computeFibo(running && (count < target));
      let next = a + b;
      a <= b;
      b <= next;
      count <= count + 1;
      if (count + 1 == target) begin
         running <= False;
      end
   endrule

   //  Change from orig chat gpt code:  Methods and subinterfaces must be at end of block
   method Action start(UInt#(32) n);
      a <= 0;
      b <= 1;
      count <= 0;
      target <= n;
      running <= True;
   endmethod

   method Bool done();
      return (running == False);
   endmethod

   method UInt#(32) result();
      return a;
   endmethod

endmodule

endpackage
