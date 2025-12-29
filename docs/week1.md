---
layout: default
title: Weekly Reports of Optimus Syria
---

<!-- Mermaid.js -->
<script type="module">
  import mermaid from 'https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.esm.min.mjs';
  mermaid.initialize({ startOnLoad: true, securityLevel: 'loose' });
</script>


<!-- Top Navigation -->
<div style="text-align:center; background:linear-gradient(90deg, #00a859, #00c98d); padding:10px;">

  <a href="index.html" style="color:white; margin:0 15px; font-weight:bold; text-decoration:none;">Home</a>
  <a href="week1.html" style="color:white; margin:0 15px; font-weight:bold; text-decoration:none;">Reports</a>
  <a href="team.html" style="color:white; margin:0 15px; font-weight:bold; text-decoration:none;">Team</a>
  <a href="about.html" style="color:white; margin:0 15px; font-weight:bold; text-decoration:none;">About</a>
  <a href="contact.html" style="color:white; margin:0 15px; font-weight:bold; text-decoration:none;">Contact</a>
</div>

<br>

<link rel="stylesheet" href="assets/style.css">

# Optimus Syria 5MW - Engineering Data Repository

## 1. Aerodynamic Blade Profile
The rotor system is designed with a series of high-performance airfoils, transitioning from circular roots to aerodynamic profiles optimized for the 160m rotor diameter.

| Radial Position [m] | Chord Length [m] | Twist [deg] | Airfoil Type |
|:---|:---:|:---:|:---|
| **0.00 (Root)** | $3.47$ | $18.0$ | Circular Foil |
| **6.28** | $4.00$ | $17.5$ | Interpolated t52.8 |
| **8.31 (Max Chord)**| $4.20$ | $17.0$ | Interpolated t45.0 |
| **12.36** | $4.15$ | $16.0$ | DU40B Flatback |
| **20.72** | $3.80$ | $12.0$ | DU40B Flatback |
| **77.75 (Tip)** | $\approx 1.1$ | $0.0$ | Optimized Tip Profile |

---

## 2. Yaw & Control System
The yaw system ensures precise alignment with the wind direction using a multi-drive active system.

- **Drives:** 6x Bonfiglioli 716 T4 planetary drives.
- **Motors:** BE160 series (11-15 kW) controlled by DGM Inverters.
- **Bearing Type:** Double-row 4-point contact bearing with external gearing.
- **Structural Limits:**
  - **Max Yaw Moment:** $19,851.6 \text{ kNm}$
  - **Operational Yaw Moment:** $7,164 \text{ kNm}$
  - **Max Tilting Moment:** $21,578.4 \text{ kNm}$
- **Brake System:** Svendborg hydraulic calipers acting on a 3.8m diameter disk.

---

## 3. Civil Engineering & Quantities
Foundation calculations based on the site-specific soil analysis in Syria.

- **Foundation Area:** $491 \text{ m}^2$
- **Total Concrete Volume:** $1121 \text{ m}^3$
- **Reinforcement Steel:** $49.4 \text{ tons}$ (High-tensile Grade)
- **Anchor Bolt Cage:** $4.0 \text{ tons}$ (M36 Bolt configuration)
- **Total Foundation Cost Estimate:** $\approx 128,240 \text{ EUR}$

---

## 4. Site-Specific Environmental Design
The Optimus Syria is engineered for the specific wind regime of the project site.

| Parameter | Value | Details |
|:---|:---|:---|
| **Avg. Wind Speed** | $8.49 \text{ m/s}$ | Measured at 100m hub height |
| **Prevailing Wind** | $270^\circ \text{ (West)}$ | Primary energy direction |
| **Turbulence Int.** | $0.16$ | Category A (High Turbulence) |
| **Roughness Length**| $0.002 \text{ m}$ | Low terrain roughness |
| **Grid Voltage** | $66 \text{ kV}$ | Regional transmission level |
| **Substation Dist.** | $2500 \text{ m}$ | Underground cable connection |

---

## 5. Major Component Weight Breakdown
Total nacelle and tower mass distribution for structural loading analysis.

- **Rotor Hub:** $40,000 \text{ kg}$
- **Rotor Shaft:** $30,785 \text{ kg}$
- **Main Gearbox:** $11,600 \text{ kg}$
- **Tower Total:** $394,100 \text{ kg}$ (Steel Structure)
- **Main Bearing:** $7,160 \text{ kg}$
- **Blade Bearings (x3):** $\approx 19,800 \text{ kg}$
- **Nacelle Cover:** $\approx 5.1 \text{ tons}$

---

## 6. Noise Emissions
The turbine is designed to comply with local noise regulations for nearby settlements.

- **Villages (Day):** $\le 60 \text{ dB (A)}$
- **Villages (Night):** $\le 45 \text{ dB (A)}$
- **Industrial Zones:** $\le 60 \text{ dB (A)}$

<style>
footer { display: none; }
</style>
