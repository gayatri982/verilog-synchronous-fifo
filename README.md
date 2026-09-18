# verilog-synchronous-fifo
Parameterized synchronous FIFO design in Verilog with a self-checking testbench.
# Parameterized Synchronous FIFO in Verilog

## Project Overview

Designed and verified a parameterized synchronous FIFO using Verilog HDL.

## Features

- Parameterized FIFO data width and depth
- Synchronous write and read operations
- Full and empty flag generation
- Write and read pointer management
- Circular buffer operation with pointer wrap-around
- Overflow and underflow protection
- Simultaneous read and write support
- Self-checking Verilog testbench

## FIFO Parameters

- Data width: 16 bits
- FIFO depth: 16 entries

## Tools Used

- Verilog HDL
- Vivado / EDA Playground
- Digital simulation and waveform analysis

## Files

- `fifo.v` – FIFO RTL design
- `fifo_tb.v` – Testbench for functional verification

## Verification

The testbench verifies:

- Reset and empty condition
- FIFO write and read operations
- FIFO ordering
- Full condition
- Empty condition
- Overflow protection
- Underflow protection
- Simultaneous read and write
- Pointer wrap-around
- Circular FIFO operation
