---
layout: default
title: Optimus Syria
---

<script type="module">
  import mermaid from 'https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.esm.min.mjs';
  mermaid.initialize({ startOnLoad: true });
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

# Optimus Syria – Wind Energy Converter Project

Welcome to the official Webpage for the Optimus Syria project.  
This project is a collaboration between Hochschule Kiel & Flensburg, and Damascus University.

A Sustainable Engineering Mission for Syria's Renewable Future

Optimus Syria is an international, interdisciplinary project uniting students and academic institutions from Hochschule Flensburg, Hochschule Kiel, and Damascus University. The project is focused on designing, simulating, and preparing a scalable Wind Energy Converter (WEC) specifically adapted to the technical, environmental, and economic conditions of Syria.

This initiative was launched not just as an academic challenge, but as a real-world mission: to contribute meaningfully to the development of sustainable energy infrastructure in a region facing both opportunities and limitations in its energy landscape.

Over 15 specialized student teams are working in parallel, covering areas such as:
- Aerodynamics and blade design
- Structural analysis
- Mechanical Drivetrain
- Electrical drivetrain systems
- Control systems and simulation
- Grid integration
- Wind farm layout, storage, and foundation

Each team brings a unique contribution to the overall system development. Weekly reports, timeline tracking, and system integration are all coordinated under a unified vision to ensure technical coherence and collaborative synergy.

This website serves as a central hub for:
- Monitoring weekly team progress
- Sharing development milestones
- Demonstrating the impact of international academic collaboration in solving real engineering challenges

The project is coordinated by:
- Bakhtyar Karimzade (Project Manager)
- Josef Remberger (Deputy Project Manager)
- Federico De Mita (System Integrator).

We believe that engineering should not only solve problems, but also build bridges across cultures, disciplines, and borders.

<div class="mermaid">
gantt
    title Optimus Syria Project Timeline (WS 2025/26)
    dateFormat  YYYY-MM-DD
    axisFormat  %d %b
    section Planning Phase
    Initial Preparations         :a1, 2025-09-01, 14d
    Concept Freeze               :a2, 2025-09-15, 5d
    Project Start (Kick-off)     :milestone, a3, 2025-09-23, 0d

    section Load & Interface
    Load Principle Measurements  :b1, 2025-10-01, 14d
    Interface Freeze             :milestone, c1, 2025-11-04, 0d
    Input Freeze for Simulation  :milestone, c2, 2025-11-25, 0d

    section Design & Validation
    Design Freeze                :milestone, d1, 2025-12-16, 0d

    section Reporting & Delivery
    Final Report Submission      :e1, 2026-01-20, 7d
    Final Presentation           :e2, 2026-01-27, 5d
</div>

.mermaid {
  margin: 40px auto;
  max-width: 1000px;
  background-color: #f8f9fa;
  border-radius: 12px;
  padding: 20px;
  box-shadow: 0 0 12px rgba(0,0,0,0.1);
}
 
<style>
footer { display: none; }
</style>
