# https://www.gnu.org/software/make/manual/html_node/File-Name-Functions.html

#--------------------------- verilator w/o -Wall ----------------------------
top=$(basename $(notdir ${MAIN}))
verilator_dir=./
verilator_bin: ${MAIN}
	mkdir -p ${verilator_dir}
	cd ${verilator_dir} && verilator --binary -j 0+incdir+${PWD} $<
verilator_exe:
	cd ${verilator_dir}/obj_dir && ./V${top}

verilator_clean:
	rm -rf ${verilator_dir}/obj_dir

#------------------ Synopsys.vcs
waves_rc=-sswr ../waves.rc
obj_dir = ./obj
targets: compile simulate debug
compile: ${obj_dir}/simv
${obj_dir}/simv: ${MAIN}
	mkdir -p ${obj_dir}
	cd ${obj_dir} && vcs -full64 -debug_all -kdb -lca -sverilog +libext+.v +incdir+${PWD}  $< -o simv
simulate: ${obj_dir}/simv
	cd ${obj_dir} && simv +vcs+lic+wait -ucli -i ../batch.tcl
debug: ${obj_dir}/novas.fsdb
	cd ${obj_dir} && verdi -simflow -simBin simv ${waves_rc} -nologo -ssf novas.fsdb &
clean:
	rm -rf ${obj_dir}

#------------------ Xilinx.vivado.xsim
x_obj_dir = ./x_obj
x_targets: x_compile x_simulate x_debug
x_compile: ${MAIN}
	mkdir -p ${x_obj_dir}
	cd ${x_obj_dir} && xvlog --sv --sourcelibext .v --sourcelibdir ${PWD} -i ${PWD}  -v 0 $< |& tee x_compile.txt
x_link:
	cd ${x_obj_dir} && xelab --timescale=1ns/1ps -debug typical -t work.mkTb -s out |& tee x_link.txt
x_simulate:
	cd ${x_obj_dir} && xsim out -tclbatch ${PWD}/out.tcl |& tee x_simulate.txt
x_gui:
	cd ${x_obj_dir} && xsim out -gui
x_clean:
	rm -rf ${x_obj_dir}


