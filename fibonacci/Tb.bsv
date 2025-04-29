// Features
//     Iterative (no recursion stack overflow risk)
//     Handles n = 0 correctly
//     Easy to wrap in pipelined or FSM logic

import Fibonacci::*;
import StmtFSM::*;
import Fibonacci::*;
import GetPut::*;
import StmtFSM::*;

typedef UInt#(32)  FIBNUM;      // added

(* synthesize *)
module mkTb();

   FIBNUM num = 'h0a;           // added
   
   FibonacciGen fib <- mkFibonacciGen;

   Reg#(UInt#(32)) n <- mkReg(num); // Change this value as needed

   Stmt test = seq
                  $display("Starting Fibonacci for %d at time ", num, $time);
                  fib.start(n);
                  while (!fib.done) noAction;
                  $display("Fibonacci(%0d) = %0d at time", n, fib.result(), $time);
                  $finish;
               endseq;

   mkAutoFSM(test);

endmodule

