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
.
├── README.md
├── .github/
│   └── dependabot.yml
│
├── docs/                     # Documentation
│   └── architecture.md
│
├── src/                      # All synthesizable VHDL
│   ├── top/
│   │   └── affichage_vga.vhd
│   │
│   ├── vga/
│   │   ├── VGA_bitmap_320x240.vhd
│   │   └── conversion_bit_pixel.vhd
│   │
│   ├── memory/
│   │   ├── Ram.vhd
│   │   └── Ram_copy.vhd
│   │
│   ├── game_of_life/
│   │   ├── neighbor_count.vhd
│   │   ├── verif_cellule.vhd
│   │   ├── compteur_game.vhd
│   │   └── Copy.vhd
│   │
│   ├── random/
│   │   ├── LFSR.vhd
│   │   ├── lfsr_init.vhd
│   │   └── compteur_Seed.vhd
│   │
│   ├── control/
│   │   ├── FSM.vhd
│   │   ├── Gest_Freq.vhd
│   │   └── address_counter.vhd
│   │
│   └── io/
│       ├── game_edit.vhd
│       └── Reg_Button.vhd
│
├── sim/                      # Simulation files
│   ├── tb_top_level.vhd
│   └── waveforms/
│
└── scripts/                  # Optional (build, synthesis scripts)
    └── run_sim.tcl
