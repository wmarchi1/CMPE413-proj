# CMPE 413 — Direct-Mapped Cache Design (VHDL Project)

**Authors:** Muhammad Umar and William Marchineck  
**Instructor:** Dr. Islam  
**Course:** CMPE 413 — Fall 2025  
**VHDL Demo Date:** October 31  
**Report Submission Date:** November 3  

---

## Overview

This project implements a **direct-mapped, byte-addressable cache system** using VHDL.  
The cache connects a **CPU** to **main memory** and temporarily stores frequently accessed data to improve performance.

The system models CPU–memory interactions such as **read hit**, **read miss**, **write hit**, and **write miss**, verified via waveform simulation in Vivado.

---

## Download & Setup

1. Download the ZIP archive named **`finalproj.zip`**, which includes:
   - All required `.vhd` source files  
   - Lower-level gate modules already compiled  
   - Testbenches and simulation scripts  

2. Extract the contents into a working directory.

3. Run the following command to launch the Vivado simulation:
   ```bash
   /umbc/software/scripts/launch_xilinx_vivado.sh -mode batch -source vivado_sim.tcl
   ```

## ⚙️ Running `chip_tb.vhd` (Main Testbench)

To compile and run the top-level testbench, use **Vivado** in batch mode with the provided TCL commands.

### `vivado_sim.tcl` contents

```tcl
exec xvhdl and3.vhd and5.vhd dff_neg.vhd xor2.vhd mux42.vhd vt_regs.vhd program_counter.vhd cache_fsm.vhd peripheral_interface2.vhd cache_controller_top.vhd chip.vhd chip_tb.vhd
exec xelab chip_tb -debug typical -s sim_out
exec xsim sim_out -gui
```
### Command to Launch Vivado Simulation

```bash
/umbc/software/scripts/launch_xilinx_vivado.sh -mode batch -source vivado_sim.tcl
```

## Running Other Testbenches

### 1. `tb_cache_controller_top.vhd`

To run this testbench, use the following Vivado TCL script:

```tcl
exec xvhdl inv.vhd and2.vhd and3.vhd and5.vhd or2.vhd xor2.vhd nand2.vhd mux21.vhd dlatch.vhd dff.vhd dff_neg.vhd program_counter.vhd cache_fsm.vhd cache_controller_top.vhd tb_cache_controller_top.vhd
exec xelab tb_cache_controller_top -debug typical -s sim_out
exec xsim sim_out -gui
```

### 2. `peripheral_interface2_tb.vhd`

To run this testbench, use the following Vivado TCL script:

```tcl
exec xvhdl inv.vhd mux21.vhd mux212.vhd mux218.vhd dff8bit_pos.vhd cache_interface.vhd vt_interface.vhd peripheral_interface2.vhd peripheral_interface2_tb.vhd
exec xelab peripheral_interface2_tb -debug typical -s sim_out
exec xsim sim_out -gui
```


### 3. `vt_interface_tb.vhd`

To run this testbench, use the following Vivado TCL script:

```tcl
exec xvhdl mux413HML.vhd vt_regs.vhd vt_interface.vhd vt_interface_tb.vhd
exec xelab vt_interface_tb -debug typical -s sim_out
exec xsim sim_out -gui
```
/afs/umbc.edu/users/m/u/mumar2/home/cadence/cadence_setup

