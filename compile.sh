#!/bin/bash
# My first script
ghdl -a ALU_Components.vhd
ghdl -a IITB_RISC_Components.vhd
ghdl -a ALU.vhd
ghdl -a RAM.vhd
ghdl -a PriorityEncoder.vhd
ghdl -a regfile.vhd
ghdl -a ControlPath.vhd
ghdl -a Datapath.vhd
ghdl -a IITB_RISC.vhdl
ghdl -a TestBench_app2.vhd
