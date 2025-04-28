// Chat-GPT Prompt: show me an example of a bypass fifo in bluespec system verilog
//--------------------------------------------------------------------------------
package BypassFIFO_MODIFIED;

import FIFOF::*; // Import FIFO utilities

module mkBypassFIFO_MODIFIED#(parameter Integer depth)(FIFOF#(a))
   provisos(Bits#(a,as), Eq#(a), Literal#(a));
   
   // FIFO instantiation
   FIFOF#(a) fifo <- mkSizedFIFOF(depth);

   // Bypass logic register
   Reg#(Maybe#(a)) bypass_reg <- mkReg(Invalid);
   
   // Enqueue method with bypass handling
   method Action enq(a data);
      if (fifo.notFull) 
         fifo.enq(data);
      else 
         bypass_reg <= tagged Valid data;
   endmethod

   // Dequeue method with bypass handling
   method a first();
      if (isValid(bypass_reg))
         return fromMaybe(?, bypass_reg);
      else
         return fifo.first;
   endmethod

   method Action deq();
      if (isValid(bypass_reg))
         bypass_reg <= tagged Invalid;
      else
         fifo.deq();
   endmethod

   method Action clear();
      fifo.clear();
   endmethod
   
   method Bool notFull();
      return fifo.notFull();
   endmethod
   
   method Bool notEmpty();
      return fifo.notEmpty();
   endmethod
   
endmodule

endpackage

