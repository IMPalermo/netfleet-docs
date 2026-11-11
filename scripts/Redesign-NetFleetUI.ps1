
$ErrorActionPreference = "Stop"

$root = (Get-Location).Path
$utf8 = New-Object System.Text.UTF8Encoding($false)

function Write-ProjectFile {
    param(
        [string]$Path,
        [string]$Content
    )

    $fullPath = Join-Path $root $Path
    $directory = Split-Path $fullPath -Parent

    if (-not (Test-Path $directory)) {
        New-Item -ItemType Directory -Path $directory -Force |
            Out-Null
    }

    [System.IO.File]::WriteAllText(
        $fullPath,
        $Content.TrimStart(),
        $utf8
    )

    Write-Host "Updated: $Path" -ForegroundColor Green
}

# ==========================================
# 1. QUARTO CONFIGURATION
# ==========================================

$quarto = @'
project:
  type: website
  output-dir: _site

website:
  title: "NetFleet Docs"
  description: "Infrastructure Engineering Knowledge Hub"

  navbar:
    title: "NETFLEET"
    left:
      - text: "Home"
        href: index.qmd
      - text: "Networking"
        href: learning/networking/index.qmd

  page-navigation: true

format:
  html:
    theme:
      - darkly
      - styles/custom.scss
    toc: true
    toc-depth: 3
    code-copy: true
    code-overflow: wrap
    smooth-scroll: true
    anchor-sections: true
    link-external-newwindow: true

language:
  title-block-author: "Author"
'@

Write-ProjectFile "_quarto.yml" $quarto

# ==========================================
# 2. HOME DASHBOARD
# ==========================================

$homePage = @'
---
title: "NetFleet Docs"
page-layout: full
toc: false
---

::: {.nf-hero}
<div class="nf-eyebrow">PERSONAL ENGINEERING WORKSPACE</div>

# Build. Understand. Automate.

A structured learning environment for modern infrastructure and network engineering.

[Explore Networking](learning/networking/index.qmd){.nf-primary-link}
:::

## Learning paths

::: {.nf-grid}

::: {.nf-card}
<div class="nf-card-number">01 / ACTIVE</div>

### Networking Engineering

Learn network architecture, protocols, switching, routing, troubleshooting and practical network engineering.

[Open learning path →](learning/networking/index.qmd)
:::

::: {.nf-card}
<div class="nf-card-number">02 / LEARNING PATH</div>

### Python Engineering

Programming fundamentals, scripting, APIs and automation.

[Explore Python →](learning/python/index.qmd)
:::

::: {.nf-card}
<div class="nf-card-number">03 / PLANNED</div>

### Linux Engineering

Linux administration, shell environments, SSH and server operations.

<span class="nf-muted">In development</span>
:::

::: {.nf-card}
<div class="nf-card-number">04 / PLANNED</div>

### Infrastructure Automation

Ansible, infrastructure as code and automated operations.

<span class="nf-muted">In development</span>
:::

:::

::: {.nf-footer}
NETFLEET KNOWLEDGE SYSTEM · ENGINEERING IN PROGRESS
:::
'@

Write-ProjectFile "index.qmd" $homePage

# ==========================================
# 3. NETWORKING CURRICULUM DATA
# ==========================================

$weeks = @(
    @{
        Number = 1
        Title = "Network Foundations"
        Description = "Understand how computer networks communicate, address devices and transfer data."
        Lessons = @(
            "What Is a Computer Network?"
            "OSI and TCP/IP Models"
            "Ethernet, MAC Address and ARP"
            "IPv4 Addressing and Subnetting"
            "TCP, UDP, DNS and DHCP"
        )
    },
    @{
        Number = 2
        Title = "Switching"
        Description = "Explore Ethernet switching, MAC learning, VLAN segmentation and loop prevention."
        Lessons = @(
            "Ethernet Frame Structure"
            "Switch Learning and MAC Tables"
            "VLAN Concepts and Segmentation"
            "Access and Trunk Ports"
            "Spanning Tree Fundamentals"
        )
    },
    @{
        Number = 3
        Title = "Routing"
        Description = "Learn how routers make forwarding decisions and connect different networks."
        Lessons = @(
            "Routing Tables and Next-Hop Logic"
            "Static Routing"
            "Default Routes"
            "Inter-VLAN Routing"
            "Routing Troubleshooting"
        )
    },
    @{
        Number = 4
        Title = "IP Addressing"
        Description = "Develop practical IPv4, subnetting, CIDR and IPv6 design skills."
        Lessons = @(
            "IPv4 Subnetting Practice"
            "CIDR and VLSM Design"
            "IPv6 Address Structure"
            "IPv6 Neighbor Discovery"
            "Dual-Stack Network Design"
        )
    },
    @{
        Number = 5
        Title = "Network Services"
        Description = "Understand essential network services and how they operate in production environments."
        Lessons = @(
            "DNS Resolution in Depth"
            "DHCP Scopes and Leases"
            "NAT and PAT"
            "NTP and Time Synchronization"
            "Network Service Troubleshooting"
        )
    },
    @{
        Number = 6
        Title = "Wireless and Remote Access"
        Description = "Study wireless architecture, authentication, VPNs and remote connectivity."
        Lessons = @(
            "Wi-Fi Architecture and Standards"
            "Wireless Security Basics"
            "802.1X and Network Authentication"
            "VPN Fundamentals"
            "Remote Access Troubleshooting"
        )
    },
    @{
        Number = 7
        Title = "Monitoring and Troubleshooting"
        Description = "Build practical observability, packet analysis and incident investigation skills."
        Lessons = @(
            "Network Diagrams and Documentation"
            "Packet Capture with Wireshark"
            "Latency, Jitter and Packet Loss"
            "Monitoring with SNMP and Syslog"
            "Incident Triage and Root Cause Analysis"
        )
    },
    @{
        Number = 8
        Title = "Network Engineering"
        Description = "Connect the fundamentals through design, resilience and practical engineering."
        Lessons = @(
            "Hierarchical Network Design"
            "Redundancy and High Availability"
            "Capacity Planning"
            "Network Change Management"
            "Networking Fundamentals Practical Assessment"
        )
    }
)

# ==========================================
# 4. NETWORKING DASHBOARD
# ==========================================

$weekCards = foreach ($week in $weeks) {
    $number = "{0:D2}" -f $week.Number
    $weekPath = "week-$number/index.qmd"

    @"
::: {.nf-card}
<div class="nf-card-number">WEEK $number · 05 SESSIONS</div>

### $($week.Title)

$($week.Description)

[Explore week →]($weekPath)
:::
"@
}

$networking = @"
---
title: "Networking Engineering"
page-layout: full
toc: false
---

::: {.nf-hero}
<div class="nf-eyebrow">LEARNING PATH / 01</div>

# Networking Engineering

از مبانی شبکه تا درک معماری، عیب‌یابی و مهندسی شبکه.

<div class="nf-stats">
  <div><strong>08</strong><span>Weeks</span></div>
  <div><strong>40</strong><span>Sessions</span></div>
  <div><strong>01</strong><span>Learning Path</span></div>
</div>
:::

## Curriculum

::: {.nf-grid}
$($weekCards -join "`n")
:::

::: {.nf-footer}
NETWORKING ENGINEERING · 8-WEEK CURRICULUM
:::
"@

Write-ProjectFile "learning/networking/index.qmd" $networking

# ==========================================
# 5. WEEK DASHBOARDS
# ==========================================

foreach ($week in $weeks) {

    $number = "{0:D2}" -f $week.Number
    $sessionCards = @()

    for ($i = 0; $i -lt 5; $i++) {

        $day = "{0:D2}" -f ($i + 1)
        $lesson = $week.Lessons[$i]

        $sessionCards += @"
::: {.nf-card}
<div class="nf-card-number">SESSION $day</div>

### $lesson

[Open session →](day-$day.qmd)
:::
"@
    }

    $weekPage = @"
---
title: "Week $($week.Number) - $($week.Title)"
page-layout: full
toc: false
---

::: {.nf-hero}
<div class="nf-eyebrow">NETWORKING / WEEK $number</div>

# $($week.Title)

$($week.Description)

[← Back to Networking](../index.qmd)
:::

## Weekly sessions

::: {.nf-grid}
$($sessionCards -join "`n")
:::

## Weekly outcome

::: {.nf-outcome}
در پایان این هفته باید بتوانی مفاهیم اصلی را توضیح بدهی، آزمایش‌های عملی را تکرار کنی و نتایج را در قالب یک گزارش فنی کوتاه مستند کنی.
:::

::: {.nf-footer}
NETFLEET · WEEK $number
:::
"@

    $weekPath = "learning/networking/week-$number/index.qmd"
    Write-ProjectFile $weekPath $weekPage
}

# ==========================================
# 6. CUSTOM ENGINEERING DESIGN
# ==========================================

$scss = @'
/*-- scss:defaults --*/

$body-bg: #090D0B;
$body-color: #E5EAE6;
$link-color: #A8D5B6;
$primary: #6FAF88;
$font-family-sans-serif: "Space Grotesk", "Vazirmatn", sans-serif;
$font-family-monospace: "JetBrains Mono", monospace;

/*-- scss:rules --*/

@import url('https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500;600&family=Vazirmatn:wght@400;500;600;700&display=swap');

:root {
  --nf-bg: #090D0B;
  --nf-surface: #111813;
  --nf-card: #151E18;
  --nf-hover: #1B2820;
  --nf-green: #6FAF88;
  --nf-light: #A8D5B6;
  --nf-text: #E5EAE6;
  --nf-muted: #929D94;
  --nf-border: #29352D;
}

html {
  scroll-behavior: smooth;
}

body {
  background: var(--nf-bg);
  color: var(--nf-text);
  font-family: "Space Grotesk", "Vazirmatn", sans-serif;
  line-height: 1.75;
}

.navbar {
  background: rgba(9, 13, 11, 0.96) !important;
  border-bottom: 1px solid var(--nf-border);
  padding: 0.8rem 1.5rem;
  backdrop-filter: blur(12px);
}

.navbar-brand {
  color: var(--nf-light) !important;
  font-family: "JetBrains Mono", monospace;
  font-weight: 700;
  letter-spacing: 0.12em;
}

.navbar .nav-link {
  color: var(--nf-muted) !important;
  transition: color 0.2s ease;
}

.navbar .nav-link:hover {
  color: var(--nf-light) !important;
}

#quarto-content {
  max-width: 1500px;
  margin: 0 auto;
}

main.content {
  padding-top: 2.5rem;
  padding-bottom: 4rem;
}

h1, h2, h3, h4 {
  color: var(--nf-text);
  font-weight: 600;
  letter-spacing: -0.035em;
}

h1 {
  font-size: clamp(2.2rem, 5vw, 3.7rem);
  margin-bottom: 1rem;
}

h2 {
  margin-top: 3rem;
  margin-bottom: 1.5rem;
  font-size: 1.65rem;
}

a {
  color: var(--nf-light);
  text-decoration: none;
}

a:hover {
  color: #D0EBD8;
}

.nf-hero {
  position: relative;
  overflow: hidden;
  background:
    radial-gradient(ellipse at 85% 15%, rgba(111,175,136,0.13), transparent 45%),
    linear-gradient(135deg, #111813, #0D130F);
  border: 1px solid var(--nf-border);
  border-radius: 18px;
  padding: clamp(2rem, 6vw, 4.5rem);
  margin: 1rem 0 3rem;
}

.nf-hero h1 {
  max-width: 850px;
  margin-top: 1rem;
}

.nf-hero p {
  color: var(--nf-muted);
  max-width: 760px;
  font-size: 1.08rem;
}

.nf-eyebrow,
.nf-card-number {
  color: var(--nf-green);
  font-family: "JetBrains Mono", monospace;
  font-size: 0.75rem;
  font-weight: 600;
  letter-spacing: 0.09em;
}

.nf-primary-link {
  display: inline-block;
  margin-top: 1.1rem;
  padding: 0.8rem 1.2rem;
  border-radius: 8px;
  background: var(--nf-green);
  color: #08110B !important;
  font-weight: 700;
  transition: transform 0.2s ease, background 0.2s ease;
}

.nf-primary-link:hover {
  background: var(--nf-light);
  transform: translateY(-2px);
}

.nf-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 1rem;
  margin: 1.5rem 0 3rem;
}

.nf-card {
  min-width: 0;
  background: var(--nf-card);
  border: 1px solid var(--nf-border);
  border-radius: 13px;
  padding: 1.5rem;
  transition: border-color 0.2s ease, background 0.2s ease, transform 0.2s ease;
}

.nf-card:hover {
  background: var(--nf-hover);
  border-color: var(--nf-green);
  transform: translateY(-3px);
}

.nf-card h3 {
  font-size: 1.2rem;
  margin: 1rem 0 0.6rem;
}

.nf-card p {
  color: var(--nf-muted);
  font-size: 0.94rem;
}

.nf-card a {
  display: inline-block;
  margin-top: 0.7rem;
  font-weight: 600;
}

.nf-muted {
  display: inline-block;
  margin-top: 0.7rem;
  color: var(--nf-muted);
  font-size: 0.9rem;
}

.nf-stats {
  display: flex;
  flex-wrap: wrap;
  gap: 3rem;
  margin-top: 2rem;
}

.nf-stats div {
  display: flex;
  flex-direction: column;
}

.nf-stats strong {
  color: var(--nf-light);
  font-family: "JetBrains Mono", monospace;
  font-size: 2rem;
}

.nf-stats span {
  color: var(--nf-muted);
  font-size: 0.85rem;
}

.nf-outcome {
  background: var(--nf-surface);
  border: 1px solid var(--nf-border);
  border-left: 3px solid var(--nf-green);
  border-radius: 9px;
  padding: 1.3rem 1.5rem;
  color: var(--nf-muted);
}

.nf-footer {
  border-top: 1px solid var(--nf-border);
  padding-top: 1.2rem;
  margin-top: 4rem;
  color: var(--nf-muted);
  font-family: "JetBrains Mono", monospace;
  font-size: 0.7rem;
  letter-spacing: 0.08em;
}

.persian {
  direction: rtl;
  text-align: right;
  font-family: "Vazirmatn", sans-serif;
  line-height: 2.1;
}

.persian h1,
.persian h2,
.persian h3,
.persian p,
.persian li {
  font-family: "Vazirmatn", sans-serif;
}

.persian pre,
.persian code,
pre,
code {
  direction: ltr;
  text-align: left;
  font-family: "JetBrains Mono", monospace;
}

pre {
  background: #0C120E !important;
  border: 1px solid var(--nf-border);
  border-radius: 10px;
  padding: 1rem;
}

table {
  border-color: var(--nf-border) !important;
}

th {
  color: var(--nf-light);
}

td, th {
  padding: 0.7rem !important;
}

#TOC {
  border-left: 1px solid var(--nf-border);
}

#TOC a {
  color: var(--nf-muted);
}

#TOC a:hover,
#TOC .active {
  color: var(--nf-light);
}

blockquote {
  border-left: 3px solid var(--nf-green);
  color: var(--nf-muted);
  padding-left: 1rem;
}

::selection {
  background: rgba(111, 175, 136, 0.3);
  color: white;
}

::-webkit-scrollbar {
  width: 8px;
}

::-webkit-scrollbar-track {
  background: var(--nf-bg);
}

::-webkit-scrollbar-thumb {
  background: #34483A;
  border-radius: 10px;
}

@media (max-width: 768px) {
  .nf-grid {
    grid-template-columns: 1fr;
  }

  .nf-hero {
    padding: 2rem 1.4rem;
  }

  .nf-stats {
    gap: 1.5rem;
  }

  main.content {
    padding-top: 1.5rem;
  }
}
'@

Write-ProjectFile "styles/custom.scss" $scss

# ==========================================
# 7. FINISH
# ==========================================

Write-Host ""
Write-Host "============================================" -ForegroundColor Green
Write-Host " NETFLEET UI REDESIGN COMPLETED" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green
Write-Host "Updated: 12 interface files"
Write-Host "Preserved: All 40 lesson files"
Write-Host ""
Write-Host "Next step: quarto render" -ForegroundColor Cyan
