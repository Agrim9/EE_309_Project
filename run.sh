#!/bin/bash
# My first script
ghdl -m Grand_Test
./grand_test --stop-time=4000ns --vcd=risc.vcd
