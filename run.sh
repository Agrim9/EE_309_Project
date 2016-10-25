#!/bin/bash
# My first script
ghdl -m Grand_Test
./grand_test --stop-time=10000ns --vcd=risc.vcd
