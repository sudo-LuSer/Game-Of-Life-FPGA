# 🧬 Conway’s Game of Life on FPGA (VHDL + VGA)

![VHDL](https://img.shields.io/badge/VHDL-HDL-orange)
![FPGA](https://img.shields.io/badge/FPGA-Implementation-blue)
![Game of Life](https://img.shields.io/badge/Game%20of%20Life-Turing%20Complete-green)

A complete **hardware implementation** of **Conway’s Game of Life** on FPGA with **real-time VGA display (320×240)**.  
This project demonstrates cellular automata simulation **fully in hardware**, using VHDL and FPGA parallelism.

---

## 📋 Project Overview

This system implements Conway’s Game of Life on an FPGA with:
- Real-time VGA visualization
- Interactive grid editing via push buttons
- Random initialization using LFSR
- Hardware-accelerated neighbor counting and state updates
- A global FSM coordinating all operations

---

## 🎮 Features

- **VGA Display**
  - Resolution: 320×240
  - Color depth: 12-bit RGB
- **Interactive Editing**
  - Move cursor with directional buttons
  - Toggle cells with center button
- **Random Initialization**
  - LFSR-based random grid generation
- **Hardware Acceleration**
  - Parallel neighbor counting
  - Synchronous cell updates
- **Multiple Modes**
  - Simulation mode
  - Edit mode
  - Initialization mode
- **Configurable Update Rate**
  - Adjustable via clock divider

---

## 🛠️ Hardware Requirements

- FPGA board (Xilinx Spartan-6 / Spartan-7 or compatible)
- VGA output connector
- Push buttons (Up, Down, Left, Right, Center)
- Slide switches for mode selection
- 100 MHz system clock

---

## 📁 Project Structure

```text
├── affichage_vga.vhd           # Top-level entity
├── VGA_bitmap_320x240.vhd      # VGA controller
├── address_counter.vhd         # VGA address generator
├── LFSR.vhd                    # Random generator
├── lfsr_init.vhd               # LFSR initialization controller
├── compteur_Seed.vhd           # Seed counter
├── Ram.vhd                     # Dual-port RAM (current state)
├── Ram_copy.vhd                # Next-generation buffer
├── neighbor_count.vhd          # Live neighbor counter
├── verif_cellule.vhd           # Game of Life rules
├── compteur_game.vhd           # Grid traversal counter
├── conversion_bit_pixel.vhd    # Cell-to-color mapping
├── Gest_Freq.vhd               # Update rate controller
├── Copy.vhd                    # Memory copy controller
├── FSM.vhd                     # Main finite state machine
├── game_edit.vhd               # Interactive editing logic
├── Reg_Button.vhd              # Button debouncing
└── tb_top_level.vhd            # Testbench
