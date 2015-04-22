//                              -*- Mode: Verilog -*-
// Filename        : fifo.v
// Description     : FIFO
// Author          : Philip Tracton
// Created On      : Tue May 27 16:03:26 2014
// Last Modified By: Philip Tracton
// Last Modified On: Tue May 27 16:03:26 2014
// Update Count    : 0
// Status          : Unknown, Use with caution!

module fifo (/*AUTOARG*/
	     // Outputs
	     DATA_OUT, FULL, EMPTY,
	     // Inputs
	     CLK, RESET, ENABLE, FLUSH, DATA_IN, PUSH, POP
	     ) ;


   //---------------------------------------------------------------------------
   //
   // PARAMETERS
   //
   //---------------------------------------------------------------------------
   parameter DATA_WIDTH = 32;               // Width of input and output data
   parameter ADDR_EXP   = 3;                // Width of our address, FIFO depth is 2^^ADDR_EXP
   parameter ADDR_DEPTH = 2 ** ADDR_EXP;    // DO NOT DIRECTLY SET THIS ONE!
   
   //---------------------------------------------------------------------------
   //
   // PORTS
   //
   //---------------------------------------------------------------------------
   input CLK;                           // Clock for all logic
   input RESET;                         // Synchronous Active High Reset
   input ENABLE;                        // When asserted (1'b1), this block is active
   input FLUSH;                         // When asserted (1'b1), the FIFO is dumped out and reset to all 0
   input [DATA_WIDTH - 1:0] DATA_IN;    // Input data stored when PUSHed
   input                    PUSH;       // When asserted (1'b1), DATA_IN is stored into FIFO
   input                    POP;        // When asserted (1'b1), DATA_OUT is the next value in the FIFO
   
   output [DATA_WIDTH - 1:0] DATA_OUT;  // Output data from FIFO
   output                    FULL;      // Asseted when there is no more space in FIFO
   output                    EMPTY;     // Asserted when there is nothing in the FIFO
   

   //---------------------------------------------------------------------------
   //
   // Registers 
   //
   //---------------------------------------------------------------------------
   /*AUTOREG*/
   // Beginning of automatic regs (for this module's undeclared outputs)
   reg 			     EMPTY;
   reg 			     FULL;
   // End of automatics

   reg [DATA_WIDTH -1:0]     memory[0:ADDR_DEPTH-1];   // The memory for the FIFO
   reg [ADDR_EXP:0] 	     write_ptr;                // Location to write to
   reg [ADDR_EXP:0] 	     read_ptr;                 // Location to read from 
   
   //---------------------------------------------------------------------------
   //
   // WIRES
   //
   //---------------------------------------------------------------------------
   /*AUTOWIRE*/
   wire [DATA_WIDTH-1:0]     DATA_OUT;          // Top of the FIFO driven out of the module
   wire [ADDR_EXP:0] 	     next_write_ptr;    // Next location to write to
   wire [ADDR_EXP:0] 	     next_read_ptr;     // Next location to read from
   wire 		     accept_write;      // Asserted when we can accept this write (PUSH)
   wire 		     accept_read;       // Asserted when we can accept this read (POP)
   
   //---------------------------------------------------------------------------
   //
   // COMBINATIONAL LOGIC
   //
   //---------------------------------------------------------------------------

   //
   // Read and write pointers increment by one unless at the last address.  In that
   // case wrap around to the beginning (0)
   //
   assign next_write_ptr = (write_ptr == ADDR_DEPTH-1) ? 0  :write_ptr + 1;
   assign next_read_ptr  = (read_ptr  == ADDR_DEPTH-1) ? 0  :read_ptr  + 1;

   //
   // Only write if enabled, no flushing and not full or at the same time as a pop
   //
   assign accept_write = (PUSH && ENABLE && !FLUSH && !FULL) || (PUSH && POP && ENABLE);

   //
   // Only read if not flushing and not empty or at the same time as a push
   //
   assign accept_read = (POP && ENABLE && !FLUSH && !EMPTY) || (PUSH && POP && ENABLE);

   //
   // We are always driving the data out to be read.  Pop will move to the next location
   // in memory
   //
   assign DATA_OUT = (ENABLE) ? memory[read_ptr]: 'b0;
   
   //---------------------------------------------------------------------------
   //
   // SEQUENTIAL LOGIC
   //
   //---------------------------------------------------------------------------

   //
   // Write Pointer Logic
   //
   always @(posedge CLK)
     if (RESET) begin
        write_ptr <= 'b0;       
     end else if (ENABLE) begin
        if (FLUSH) begin
           write_ptr <= 'b0;       
        end else begin
           if (accept_write) begin
              write_ptr <= next_write_ptr;            
           end
        end        
     end else begin
        write_ptr <= 'b0;       
     end

   //
   // Read Pointer Logic
   //
   always @(posedge CLK)
     if (RESET) begin
        read_ptr <= 'b0;        
     end else if (ENABLE) begin
        if (FLUSH) begin
           read_ptr <= 'b0;        
        end else begin
           if (accept_read) begin
              read_ptr <= next_read_ptr;              
           end
        end     
     end else begin
        read_ptr <= 'b0;        
     end

   //
   // Empty Logic
   //
   always @(posedge CLK)
     if (RESET) begin
        EMPTY <= 1'b1;  
     end else if (ENABLE) begin
        if (FLUSH) begin
           EMPTY <= 1'b1;          
        end else begin
           if (EMPTY && accept_write) begin
              EMPTY <= 1'b0;          
           end
           if (accept_read && (next_read_ptr == write_ptr)) begin
              EMPTY <= 1'b1;          
           end
        end
     end else begin
        EMPTY <= 1'b1;   
     end

   //
   // Full Logic 
   //
   always @(posedge CLK)
     if (RESET) begin
        FULL <= 1'b0;   
     end else if (ENABLE) begin
        if (FLUSH) begin
           FULL <= 1'b0;        
        end else begin
           if (accept_write && (next_write_ptr == read_ptr)) begin
              FULL <= 1;
           end else if (FULL && accept_read) begin
              FULL <= 0;              
           end
        end
     end else begin
        FULL <= 1'b0;   
     end // else: !if(ENABLE)
   

   //
   // FIFO Write Logic
   //
   
   integer               i;   
   always @(posedge CLK)
     if (RESET) begin
        for (i=0; i< (ADDR_DEPTH); i=i+1) begin
           memory[i] <= 'b0;       
        end
     end else if (ENABLE) begin
        if (FLUSH) begin
           for (i=0; i< (ADDR_DEPTH); i=i+1) begin
              memory[i] <= 'b0;    
           end
        end
        else if (accept_write) begin
           memory[write_ptr] <= DATA_IN;           
        end
     end
   
   
endmodule 
