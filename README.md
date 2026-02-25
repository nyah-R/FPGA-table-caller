# FPGA Table Caller 🚀

Circular FIFO queue system for real-time table calling, built as a group project for the **Digital Design** course — Electronic Engineering, ORT Uruguay. Third semester.

## Description

Implements a circular FIFO memory in VHDL that manages table call requests in real time. The system receives a table number via switches, queues it on button press, and displays the current and next table on 7-segment displays. Built and synthesized for the DE0 FPGA board using Quartus II.

## Features

- Circular FIFO queue for table management
- Table number input via 4-bit switch
- Call and attend buttons for queue control
- Dual 7-segment display output (BCD encoding)
- LED indicators for call and attention status
- Testbench included for simulation

## Components

- `sistema.vhd` — Top-level entity
- `FIFO.vhd` — Circular FIFO queue logic
- `BCDselector.vhd` — Input selection and BCD encoding
- `BCDout.vhd` — 7-segment display output
- `tb_sistema.vhd` — System testbench
- `tb_LlamadorMesas.vhd` — Table caller testbench

## Tech Stack

- VHDL
- Quartus II
- ModelSim
- DE0 FPGA Board (Altera Cyclone III)
