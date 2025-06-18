# ⚙️ 4-Bit × 4-Bit Shift-and-Add Binary Multiplier with ROM in VHDL

This project implements a **4-bit by 4-bit binary multiplier** using the **sequential shift-and-add algorithm**, with operand storage in ROM. It is designed using VHDL with a modular datapath-control architecture.

---

## 📌 Project Description

The multiplier sequentially adds the multiplicand to an accumulator when the LSB of the multiplier is 1, then performs a logical right shift. This operation repeats for 4 cycles (4-bit multiplication), with operand values fetched from a ROM.

---

## 📂 Repository Structure

```bash
multiplier_project/
├── adder_4bit.vhd          # 4-bit binary adder with carry
├── counter_3bit.vhd        # 3-bit counter (max count = 4)
├── control_unit.vhd        # FSM controller for multiplication
├── multiplier_4x4.vhd      # Top-level multiplier module
├── multiplier_core_4x4.vhd # Core datapath logic
├── register_4bit.vhd       # 4-bit registers for A, B, Q
├── rom_32x4.vhd            # 32x4 ROM for operand storage
├── shifter_4bit.vhd        # Right shifter with carry support
├── tb.vhd                  # Testbench
```

---

## 🧠 Architecture Overview
![image](https://github.com/user-attachments/assets/8877b673-f552-46d3-bf06-9443f4787a1e)

### 🔹 Datapath Components

* **4-Bit Adder (`adder_4bit.vhd`)**
  Performs unsigned addition with optional carry-in and carry-out.

* **Registers (`register_4bit.vhd`)**
  Hold intermediate values: accumulator (A), multiplier (Q), and multiplicand (B).

* **3-Bit Counter (`counter_3bit.vhd`)**
  Tracks the iteration count (4 cycles for 4-bit multiplication).

* **Right Shifter (`shifter_4bit.vhd`)**
  Performs shift operations across carry, A, and Q registers.

* **ROM (`rom_32x4.vhd`)**

  * Address 0-15: multiplicand values
  * Address 16-31: multiplier values

### 🔹 Control Unit (`control_unit.vhd`)

Implements a 6-state FSM to control the multiplication flow:

1. **IDLE**: Waits for start
2. **LOAD\_REG**: Loads operand values
3. **CHECK**: Tests Q0 and count
4. **ADD\_STATE**: Performs conditional addition
5. **SHIFT\_STATE**: Performs shift
6. **DONE\_STATE**: Signals completion

### 🔹 Top-Level Integration (`multiplier_4x4.vhd`)

Connects the datapath, control unit, and ROM interface. It coordinates operand loading and operation start.

---

## 🔮 Multiplication Algorithm (Shift-and-Add)

1. Initialize:

   * A = 0000
   * Q = multiplier
   * C = 0
2. For 4 cycles:

   * If Q0 == 1: A ← A + B
   * Shift right (C, A, Q)
3. Result is stored in A\:Q

---

## 🔬 Simulation and Verification

![image](https://github.com/WenaHarle/4-Bit-Shift-and-Add-Binary-Multiplier-Using-ROM/blob/main/Result4x4.png)

Use the provided testbench `tb.vhd` which includes the following cases:

| Test Case | Multiplicand | Multiplier | Expected Product | Binary Product |Hex Product  |
| --------- | ------------ | ---------- | ---------------- | -------------- |--------------
| 1         | 3            | 3          | 9                | `00001001`     |9|
| 2         | 15           | 15         | 225              | `11100001`     |E1|
| 3         | 0            | 5          | 0                | `00000000`     |0|

---

## 🔧 Recommended Tools

| Purpose    | Tool                             |
| ---------- | -------------------------------- |
| Simulation | GHDL, ModelSim, Vivado Simulator |
| Synthesis  | Xilinx Vivado                    |

---

## 🌟 Educational Objectives

This project is suitable for:

* Understanding hardware-level multiplication
* Practicing FSM and datapath integration
* Designing with ROM operand initialization
* Exploring bit-level sequential arithmetic

---

## 🤝 Contributing

Feel free to fork, improve, and share suggestions. Contributions and feedback are welcome!


