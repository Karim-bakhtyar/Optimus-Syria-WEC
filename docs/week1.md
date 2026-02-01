---
layout: default
title: Specifications of Optimus Syria
---

<!-- Mermaid.js -->
<script type="module">
  import mermaid from 'https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.esm.min.mjs';
  mermaid.initialize({ startOnLoad: true, securityLevel: 'loose' });
</script>


<!-- Top Navigation -->
<div style="text-align:center; background:linear-gradient(90deg, #00a859, #00c98d); padding:10px;">

  <a href="index.html" style="color:white; margin:0 15px; font-weight:bold; text-decoration:none;">Home</a>
  <a href="week1.html" style="color:white; margin:0 15px; font-weight:bold; text-decoration:none;">Specifications</a>
  <a href="team.html" style="color:white; margin:0 15px; font-weight:bold; text-decoration:none;">Team</a>
  <a href="about.html" style="color:white; margin:0 15px; font-weight:bold; text-decoration:none;">About</a>
  <a href="contact.html" style="color:white; margin:0 15px; font-weight:bold; text-decoration:none;">Contact</a>
</div>

<br>

<link rel="stylesheet" href="assets/style.css">


# Optimus Syria 5MW - Technical Data Sheet

## 1. Primary Component Weights
Mass distribution for structural and logistical planning.

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Simple Wind Turbine Tables</title>
    <style>
        /* دیزاینێکی زۆر سادە تەنها بۆ ئەوەی هێڵەکان دیار بن */
        table {
            border-collapse: collapse;
            width: 100%;
            margin-bottom: 20px;
        }
        th, td {
            border: 1px solid black; /* هێڵی ڕەش */
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2; /* ڕەنگێکی خۆڵەمێشی زۆر کاڵ بۆ سەردێڕەکە */
        }
    </style>
</head>
<body>

    <h3>Nacelle Components</h3>
    <table>
        <thead>
            <tr>
                <th>Component</th>
                <th>Total Weight (kg)</th>
            </tr>
        </thead>
        <tbody>
            <tr><td>Shaft</td><td>31,000.00</td></tr>
            <tr><td>Rotor bearing (total)</td><td>18,000.00</td></tr>
            <tr><td>Gearbox (total)</td><td>40,000.00</td></tr>
            <tr><td>Machine bed (total)</td><td>53,000.00</td></tr>
            <tr><td>Yaw system (total)</td><td>15,000.00</td></tr>
            <tr><td>Transformer</td><td>10,000.00</td></tr>
            <tr><td>Converter</td><td>1,000.00</td></tr>
            <tr><td>Generator</td><td>20,000.00</td></tr>
            <tr><td>Cables and switchgear</td><td>2,600.00</td></tr>
            <tr><td>Nacelle cover</td><td>4,000.00</td></tr>
            <tr><td>Frame structure</td><td>6,000.00</td></tr>
            <tr>
                <th>Total Nacelle</th>
                <th>204,000.00</th>
            </tr>
        </tbody>
    </table>

    <h3>Rotor Components</h3>
    <table>
        <thead>
            <tr>
                <th>Component</th>
                <th>Total Weight (kg)</th>
            </tr>
        </thead>
        <tbody>
            <tr><td>Hub (total)</td><td>44,000.00</td></tr>
            <tr><td>Pitch system (total)</td><td>25,000.00</td></tr>
            <tr><td>Blades</td><td>66,000.00</td></tr>
            <tr>
                <th>Total Rotor</th>
                <th>136,000.00</th>
            </tr>
        </tbody>
    </table>

    <h3>Tower & Foundation</h3>
    <table>
        <thead>
            <tr>
                <th>Component</th>
                <th>Total Weight (kg)</th>
            </tr>
        </thead>
        <tbody>
            <tr><td>Tower</td><td>433,000.00</td></tr>
            <tr><td>Foundation</td><td>3,351,000.00</td></tr>
            <tr>
                <th>Total</th>
                <th>3,784,000.00</th>
            </tr>
        </tbody>
    </table>

    <h2>Total Weight: 4,149,000.00 kg</h2>

</body>
</html>

---

## 2. Drivetrain Engineering (Gearbox & Generator)
The drivetrain is optimized for high-torque transmission and 50Hz grid stability.

### Gearbox Details (3-Stage)
* **Configuration:** 2 Planetary Stages + 1 Spur Stage
* **Overall Ratio:** 1:120
* **Efficiency:** 97.5%
* **1st Stage Ratio:** 4.8
* **2nd Stage Ratio:** 4.92
* **Spur Stage Ratio:** 5.1

### Electrical Generator (DFIG)
* **Rated Power (Active):** 5.16 MW
* **Apparent Power:** 5.73 MVA
* **Stator Voltage (Line-to-Line):** 960 V
* **Rated Speed:** 1200 rpm
* **Synchronous Speed:** 1000 rpm
* **Frequency:** 50 Hz

---



## 3. Nacelle & Yaw System
The nacelle houses the primary mechanical systems and provides active alignment to wind direction.

* **Nacelle Dimensions:** 13.7m (L) x 5.5m (W) x 4.3m (H)
* **Yaw Drives:** 6x Bonfiglioli 716 T4 units
* **Max Yaw Moment:** 19,851.6 kNm
* **Max Tilting Moment:** 21,578.4 kNm
* **Rotor Tilt Angle:** 6 degrees
* **Hub Cone Angle:** 4 degrees

---

## 4. Tower & Foundation Structural Data
Designed to withstand Syrian site conditions (IEC Class II A).

### Tower Sections (Steel Conical)
* **Base Section:** 20m height | 4800mm diameter | 55mm thickness
* **Mid Section 1:** 20m height | 4800mm diameter | 40mm thickness
* **Mid Section 2:** 20m height | 4600mm diameter | 35mm thickness
* **Top Section:** 20m height | 4400mm diameter | 25mm thickness

### Foundation Material Quantities
* **Concrete Volume:** 1121 cubic meters
* **Reinforcement Steel:** 49.4 tons
* **Foundation Area:** 491 square meters
* **Pedestal Diameter:** 7.0 meters

---

## 5. Environmental & Grid Parameters
* **Average Wind Speed:** 8.49 m/s
* **Cut-in / Cut-out Wind Speed:** 3 m/s / 25 m/s
* **Rated Wind Speed:** 10.37 m/s
* **Grid Connection:** 66 kV (Underground)
* **Distance to Substation:** 2500 m
* **Temperature Range:** -2 to +38 degrees Celsius

---

**Project Management Team:** Bakhtyar Karimzade (Project Manager), Federico De Mita (System Integrator), Josef Remberger (Project Coordinator).

<style>
footer { display: none; }
</style>
