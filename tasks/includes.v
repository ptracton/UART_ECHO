//                              -*- Mode: Verilog -*-
// Filename        : includes.v
// Description     : include file for the defines
// Author          : Philip Tracton
// Created On      : Tue Apr 21 18:01:11 2015
// Last Modified By: Philip Tracton
// Last Modified On: Tue Apr 21 18:01:11 2015
// Update Count    : 0
// Status          : Unknown, Use with caution!

`define testbench testbench
`define test_failed `testbench.test_failed
`define UART_MASTER0      `testbench.uart_master0
`define UART_MASTER1      `testbench.uart_master1
`define UART_CLK          `testbench.clk_tb
`define UART_CONFIG uart_tasks.uart_config
`define UART_WRITE_CHAR uart_tasks.uart_write_char
`define UART_READ_CHAR uart_tasks.uart_read_char

// general defines
`define mS *1000000
`define nS *1
`define uS *1000
`define Wait #
`define wait #
`define khz *1000



// Taken from http://asciitable.com/
//
`define LINE_FEED       8'h0A
`define CARRIAGE_RETURN 8'h0D
`define SPACE_CHAR      8'h20
`define NUMBER_0        8'h30
`define NUMBER_9        8'h39
`define LETTER_A        8'h41
`define LETTER_Z        8'h5A
`define LETTER_a        8'h61
`define LETTER_f        8'h66
`define LETTER_z        8'h7a
