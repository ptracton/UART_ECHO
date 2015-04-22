vlib work

vlog ../../tasks/uart_tasks.v +incdir+../../tasks/
vlog ../../testbench/testbench.v +incdir+../../tasks/
vlog ../../testbench/dump.v

vlog ../../behavioral/wb_uart/raminfr.v +incdir+../../behavioral/wb_uart/
vlog ../../behavioral/wb_uart/uart_debug_if.v +incdir+../../behavioral/wb_uart/
vlog ../../behavioral/wb_uart/uart_receiver.v +incdir+../../behavioral/wb_uart/ 
vlog ../../behavioral/wb_uart/uart_regs.v +incdir+../../behavioral/wb_uart/
vlog ../../behavioral/wb_uart/uart_rfifo.v +incdir+../../behavioral/wb_uart/
vlog ../../behavioral/wb_uart/uart_sync_flops.v +incdir+../../behavioral/wb_uart/
vlog ../../behavioral/wb_uart/uart_tfifo.v +incdir+../../behavioral/wb_uart/
vlog ../../behavioral/wb_uart/uart_top.v +incdir+../../behavioral/wb_uart/
vlog ../../behavioral/wb_uart/uart_transmitter.v +incdir+../../behavioral/wb_uart/
vlog ../../behavioral/wb_uart/uart_wb.v +incdir+../../behavioral/wb_uart/

vlog ../../behavioral/wb_master/wb_mast_model.v +incdir+../../behavioral/wb_master/


vlog ../../rtl/uart.v
vlog ../../rtl/uart_echo.v
vlog ../../rtl/uart_fifo.v
vlog ../../rtl/fifo.v

vsim -voptargs=+acc work.testbench +define+ALTERA  
run -all
