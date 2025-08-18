---
layout: default
title: Optimus Syria
---

<link rel="stylesheet" href="assets/style.css">

<head>
  <meta charset="UTF-8">
  <title>Optimus Syria WEC</title>


  <script type="module">
    import mermaid from 'https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.esm.min.mjs';
    mermaid.initialize({ startOnLoad: true });
  </script>

  
  <style>
    .mermaid {
      margin: 40px auto;
      max-width: 1000px;
      background-color: #f8f9fa;
      border-radius: 12px;
      padding: 20px;
      box-shadow: 0 0 12px rgba(0, 0, 0, 0.1);
      overflow-x: auto;
    }

    .mermaid svg .titleText {
      fill: #28a745 !important;
      font-size: 18px;
      font-weight: bold;
    }

    a {
      color: #c62828;
      text-decoration: none;
    }

    a:hover {
      text-decoration: underline;
    }

    footer {
      display: none;
    }
  </style>
</head>

<body>


  <div style="text-align:center; background:linear-gradient(90deg, #00a859, #00c98d); padding:10px;">
    <a href="index.html">Home</a>
    <a href="week1.html">Reports</a>
    <a href="team.html">Team</a>
    <a href="about.html">About</a>
    <a href="contact.html">Contact</a>
  </div>

  <br>

  
  <h1 style="text-align:center;">Optimus Syria – Wind Energy Converter Project</h1>

  <p>
    Welcome to the official Webpage for the Optimus Syria project. This project is a collaboration between Hochschule Kiel & Flensburg, and Damascus University.
  </p>

  <p>
    <strong>A Sustainable Engineering Mission for Syria's Renewable Future</strong><br>
    Optimus Syria is an international, interdisciplinary project uniting students and academic institutions from Hochschule Flensburg, Hochschule Kiel, and Damascus University. The project is focused on designing, simulating, and preparing a scalable Wind Energy Converter (WEC) specifically adapted to the technical, environmental, and economic conditions of Syria.
  </p>

  <p>
    This initiative was launched not just as an academic challenge, but as a real-world mission: to contribute meaningfully to the development of sustainable energy infrastructure in a region facing both opportunities and limitations in its energy landscape.
  </p>

  <p>Over 15 specialized student teams are working in parallel, covering areas such as:</p>
  <ul>
    <li>Aerodynamics and blade design</li>
    <li>Structural analysis</li>
    <li>Mechanical Drivetrain</li>
    <li>Electrical drivetrain systems</li>
    <li>Control systems and simulation</li>
    <li>Grid integration</li>
    <li>Wind farm layout, storage, and foundation</li>
  </ul>

  <p>
    Each team brings a unique contribution to the overall system development. Weekly reports, timeline tracking, and system integration are all coordinated under a unified vision to ensure technical coherence and collaborative synergy.
  </p>

  <p>
    This website serves as a central hub for:
  </p>
  <ul>
    <li>Monitoring weekly team progress</li>
    <li>Sharing development milestones</li>
    <li>Demonstrating the impact of international academic collaboration in solving real engineering challenges</li>
  </ul>

  <p>
    <strong>The project is coordinated by:</strong><br>
    - Bakhtyar Karimzade (Project Manager)<br>
    - Josef Remberger (Deputy Project Manager)<br>
    - Federico De Mita (System Integrator)
  </p>

  <p><em>We believe that engineering should not only solve problems, but also build bridges across cultures, disciplines, and borders.</em></p>

  
  <h3 id="today-date" style="text-align: center; color: #c62828; margin-bottom: 15px;">
   Loading today’s date...
  </h3>

  
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

  
  <script>
    const today = new Date();
    const options = { day: 'numeric', month: 'long', year: 'numeric' };
    const formattedDate = today.toLocaleDateString('en-GB', options);
    document.getElementById('today-date').innerText = ` Today is: ${formattedDate}`;
  </script>

</body>
