# Copyright 1991-2024 Mentor Graphics Corporation
# 
# Modification by Oklahoma State University
# Use with Testbench 
# James Stine, 2008
# Go Cowboys!!!!!!
#
# All Rights Reserved.
#
# THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION
# WHICH IS THE PROPERTY OF MENTOR GRAPHICS CORPORATION
# OR ITS LICENSORS AND IS SUBJECT TO LICENSE TERMS.

# Use this run.do file to run this example.
# Either bring up ModelSim and type the following at the "ModelSim>" prompt:
#     do run.do
# or, to run from a shell, type the following at the shell prompt:
#     vsim -do run.do -c
# (omit the "-c" to see the GUI while running from the shell)

onbreak {resume}

# create library
if [file exists work] {
    vdel -all
}
vlib work

# compile source files
 vlog -lint fma16.sv testbench.sv unpack.sv fmaexpadd.sv fmamult.sv fmasign.sv fmaalign.sv fmaadd.sv fmalza.sv
# vlog fma16.sv testbench.sv unpack.sv fmaexpadd.sv

# start and run simulation
vsim -voptargs=+acc work.tb_fma16

# Diplays All Signals recursively
# add wave -hex -r /stimulus/*
add wave -hex /tb_fma16/dut/result
add wave -hex /tb_fma16/dut/Me
add wave -hex /tb_fma16/dut/Pe
add wave -hex /tb_fma16/dut/Xe
add wave -hex /tb_fma16/dut/Ye
add wave -hex /tb_fma16/dut/Ze
add wave -hex /tb_fma16/dut/Mm
add wave -hex /tb_fma16/dut/SmNormal
add wave -hex /tb_fma16/dut/Zm
add wave -hex /tb_fma16/dut/align/ZmShift
add wave -hex /tb_fma16/dut/align/ZmPreShift
add wave -hex /tb_fma16/dut/align/Acnt
add wave -hex /tb_fma16/dut/align/KillZ
add wave -hex /tb_fma16/dut/align/KillProd
add wave -hex /tb_fma16/dut/FMAadd/PreSum
add wave -hex /tb_fma16/dut/FMAadd/Am
add wave -hex /tb_fma16/dut/FMAadd/Pm
add wave -hex /tb_fma16/dut/FMAadd/PmKilled
add wave -hex /tb_fma16/dut/FMAadd/Sm
add wave -hex /tb_fma16/dut/Se
add wave -hex /tb_fma16/dut/CountE
add wave -hex /tb_fma16/dut/lza/CountTemp
add wave -hex /tb_fma16/dut/sign/*
add wave -hex /tb_fma16/dut/align/Acnt
add wave -hex /tb_fma16/dut/ASticky
add wave -noupdate -divider -height 32 "fma16"
add wave -color gold -hex /tb_fma16/clk
add wave -hex /tb_fma16/reset
add wave -hex /tb_fma16/x
add wave -hex /tb_fma16/y
add wave -hex /tb_fma16/z
add wave -hex /tb_fma16/result
add wave -hex /tb_fma16/rexpected
add wave -hex /tb_fma16/ExponentExpected
add wave -hex /tb_fma16/ResultExponent
add wave -hex /tb_fma16/flagsexpected

run -all
quit

