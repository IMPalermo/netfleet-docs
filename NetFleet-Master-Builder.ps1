# NetFleet Docs - Master Curriculum Builder
# Creates the complete 50-week / 250-session curriculum structure.
# Existing lesson files are preserved unless -Force is explicitly supplied.
# Run from PowerShell:
#   Set-ExecutionPolicy -Scope Process Bypass
#   .\NetFleet-Master-Builder.ps1

param(
    [switch]$Force
)

$ErrorActionPreference = "Stop"
$ProjectRoot = "C:\Netfleet-Docs"

if (-not (Test-Path (Join-Path $ProjectRoot "_quarto.yml"))) {
    throw "Quarto project not found at $ProjectRoot. Edit `$ProjectRoot in this script if needed."
}

$Curriculum = @(
    @{
        Path="networking"; Title="Networking Fundamentals"; Weeks=@(
            @{Theme="Network Foundations"; Days=@("What Is a Computer Network?","OSI and TCP/IP Models","Ethernet, MAC Address and ARP","IPv4 Addressing and Subnetting","TCP, UDP, DNS and DHCP")},
            @{Theme="Switching Fundamentals"; Days=@("Ethernet Frame Structure","Switch Learning and MAC Tables","VLAN Concepts and Segmentation","Access and Trunk Ports","Spanning Tree Fundamentals")},
            @{Theme="Routing Fundamentals"; Days=@("Routing Tables and Next-Hop Logic","Static Routing","Default Routes","Inter-VLAN Routing","Routing Troubleshooting")},
            @{Theme="IPv4 and IPv6"; Days=@("IPv4 Subnetting Practice","CIDR and VLSM Design","IPv6 Address Structure","IPv6 Neighbor Discovery","Dual-Stack Network Design")},
            @{Theme="Core Network Services"; Days=@("DNS Resolution in Depth","DHCP Scopes and Leases","NAT and PAT","NTP and Time Synchronization","Network Service Troubleshooting")},
            @{Theme="Wireless and Network Access"; Days=@("Wi-Fi Architecture and Standards","Wireless Security Basics","802.1X and Network Authentication","VPN Fundamentals","Remote Access Troubleshooting")},
            @{Theme="Network Operations"; Days=@("Network Diagrams and Documentation","Packet Capture with Wireshark","Latency, Jitter and Packet Loss","Monitoring with SNMP and Syslog","Incident Triage and Root Cause Analysis")},
            @{Theme="Network Design and Review"; Days=@("Hierarchical Network Design","Redundancy and High Availability","Capacity Planning","Network Change Management","Networking Fundamentals Practical Assessment")}
        )
    },
    @{
        Path="linux"; Title="Linux and Systems"; Weeks=@(
            @{Theme="Linux Environment"; Days=@("Linux Distributions and Architecture","Shell and Terminal Fundamentals","Filesystem Hierarchy","Working with Files and Directories","Getting Help with man and --help")},
            @{Theme="Users and Permissions"; Days=@("Users and Groups","Ownership and Permission Bits","sudo and Privilege Boundaries","Processes and Signals","Environment Variables and Shell Profiles")},
            @{Theme="Linux Administration"; Days=@("Package Management","Systemd and Service Management","Logs with journalctl","Storage, Partitions and Filesystems","Mounts, fstab and Disk Usage")},
            @{Theme="Linux Networking"; Days=@("Linux Network Interfaces","IP Addressing with iproute2","Routes and Neighbor Tables","DNS Resolution on Linux","Socket Inspection with ss")},
            @{Theme="SSH and Remote Operations"; Days=@("SSH Client and Server","SSH Keys and Agent","Secure Copy and Rsync","SSH Hardening","Remote Administration Lab")},
            @{Theme="Bash Automation"; Days=@("Bash Variables and Quoting","Conditions and Loops","Functions and Exit Codes","Pipes, Redirection and Text Processing","Reliable Shell Scripts")},
            @{Theme="System Observability"; Days=@("CPU and Memory Inspection","Disk and I/O Monitoring","Process and Service Troubleshooting","Log Analysis and Rotation","Baseline and Performance Investigation")},
            @{Theme="Linux Operations Project"; Days=@("Cron and Scheduled Tasks","System Backup and Restore","Firewall Basics with nftables","Secure Server Baseline","Linux Administration Practical Assessment")}
        )
    },
    @{
        Path="python"; Title="Python for Network Engineers"; Weeks=@(
            @{Theme="Python Foundations"; Days=@("Python Runtime and Development Environment","Variables and Core Data Types","Strings and Formatting","Numbers, Booleans and Operators","Input, Output and Type Conversion")},
            @{Theme="Control Flow"; Days=@("Conditions and Boolean Logic","For Loops and Iteration","While Loops and Loop Control","Lists and Tuples","Dictionaries and Sets")},
            @{Theme="Functions and Structure"; Days=@("Defining and Calling Functions","Parameters, Return Values and Scope","Modules and Imports","Exceptions and Error Handling","Writing Readable and Testable Code")},
            @{Theme="Working with Data"; Days=@("Reading and Writing Text Files","JSON Data Processing","CSV Data Processing","Regular Expressions","Pathlib and Filesystem Automation")},
            @{Theme="Network Programming"; Days=@("IP Address Handling with ipaddress","DNS Lookups with Python","TCP Client and Server Basics","HTTP Requests and REST APIs","Timeouts, Retries and Network Errors")},
            @{Theme="Engineering Python"; Days=@("Virtual Environments and pip","Dependency and Project Management","Logging and Structured Diagnostics","Unit Testing with pytest","Type Hints and Code Quality")},
            @{Theme="Data Models and Automation"; Days=@("Dataclasses and Structured Inventory","Parsing Command Output","Configuration Data Validation","Concurrent Tasks and Thread Pools","Safe Automation Patterns")},
            @{Theme="Python Network Project"; Days=@("Build a Network Inventory CLI","Add Reachability Checks","Export JSON and CSV Reports","Add Tests and Logging","Python Network Tool Practical Assessment")}
        )
    },
    @{
        Path="backend"; Title="Backend and APIs"; Weeks=@(
            @{Theme="Web and HTTP Foundations"; Days=@("How the Web Works","HTTP Request and Response","Methods, Status Codes and Headers","TLS and HTTPS Fundamentals","Cookies, Sessions and Statelessness")},
            @{Theme="API Design"; Days=@("REST Architectural Constraints","Resource and Endpoint Design","JSON Schemas and Validation","Pagination, Filtering and Sorting","API Error Design and Versioning")},
            @{Theme="Python API Development"; Days=@("Flask Application Structure","Routing and Request Handling","Input Validation and Serialization","Configuration and Environment Variables","Application Logging and Error Handling")},
            @{Theme="Data Persistence"; Days=@("Relational Database Fundamentals","SQL Queries and Joins","Schema Design and Constraints","Transactions and ACID","SQLite to PostgreSQL Concepts")},
            @{Theme="API Security"; Days=@("Authentication and Authorization","API Keys and Bearer Tokens","Password Hashing Fundamentals","Input Validation and Injection Risks","CORS, Rate Limits and Secure Defaults")},
            @{Theme="API Engineering"; Days=@("OpenAPI and API Documentation","Automated API Testing","Database Migrations","Background Jobs and Task Queues","Caching and Performance Basics")},
            @{Theme="Deployment"; Days=@("Application Configuration for Deployment","WSGI and Production Servers","Reverse Proxies","Environment Secrets and Deployment Safety","Health Checks and Observability")},
            @{Theme="Backend Project"; Days=@("Design a Network Inventory API","Implement CRUD Endpoints","Connect Persistent Storage","Add Authentication and Tests","Backend API Practical Assessment")}
        )
    },
    @{
        Path="automation"; Title="Network Automation"; Weeks=@(
            @{Theme="Automation Foundations"; Days=@("Why Network Automation Matters","Automation Workflows and Control Loops","CLI Automation Risks and Guardrails","Inventory and Source of Truth","Idempotency and Desired State")},
            @{Theme="Device Connectivity"; Days=@("SSH Automation Concepts","Paramiko and Secure Connections","Netmiko Device Sessions","Structured Command Output","Connection Pools and Timeouts")},
            @{Theme="Network APIs"; Days=@("Network Device APIs","RESTCONF Fundamentals","NETCONF and YANG Concepts","Authentication and API Sessions","Working with API Responses")},
            @{Theme="Configuration Automation"; Days=@("Configuration Templates","Jinja2 for Network Configurations","Pre-Change Validation","Safe Configuration Deployment","Rollback and Change Verification")},
            @{Theme="Automation Quality"; Days=@("Parsing and Normalizing Device Data","Concurrency and Rate Control","Retries and Failure Handling","Testing Automation with Mocks","Audit Trails and Change Reports")},
            @{Theme="Automation Project"; Days=@("Build a Multi-Device Inventory Collector","Collect Interface and Routing Data","Generate Configuration Proposals","Validate and Compare Device State","Network Automation Capstone Assessment")}
        )
    },
    @{
        Path="infrastructure"; Title="Infrastructure Engineering"; Weeks=@(
            @{Theme="Infrastructure Foundations"; Days=@("Infrastructure as Code Concepts","Git Workflows for Infrastructure","Configuration Management Principles","Secrets and Configuration Separation","Infrastructure Documentation")},
            @{Theme="Containers"; Days=@("Container Concepts and Images","Dockerfiles and Build Context","Container Networking","Volumes and Persistent Data","Docker Compose for Services")},
            @{Theme="Virtualization and Cloud"; Days=@("Virtual Machines and Hypervisors","Virtual Networking","Cloud Networking Fundamentals","Identity and Access in Cloud Platforms","Hybrid Infrastructure Concepts")},
            @{Theme="Infrastructure as Code"; Days=@("Terraform Core Workflow","Providers, Resources and State","Variables, Outputs and Modules","Plan Review and Safe Apply","Drift Detection and State Management")},
            @{Theme="Delivery and Observability"; Days=@("CI/CD Pipeline Concepts","Automated Validation in CI","Metrics, Logs and Traces","Prometheus and Grafana Concepts","Backup, Recovery and Reliability")},
            @{Theme="Infrastructure Project"; Days=@("Design a Small Lab Environment","Provision Services Reproducibly","Automate Configuration","Add Monitoring and Recovery","Infrastructure Capstone Assessment")}
        )
    },
    @{
        Path="security"; Title="Network and Systems Security"; Weeks=@(
            @{Theme="Security Foundations"; Days=@("Security Principles and Threat Modeling","CIA Triad and Risk","Identity, Authentication and Authorization","Least Privilege and Zero Trust Concepts","Security Baselines and Asset Inventory")},
            @{Theme="Network Security"; Days=@("Firewalls and Rule Design","Network Segmentation","VPN Security Concepts","TLS, Certificates and PKI","Secure Management Protocols")},
            @{Theme="Linux and Host Security"; Days=@("Linux Hardening Principles","SSH Security and Access Control","Host Firewalls","Patch and Vulnerability Management","Audit Logs and Detection")},
            @{Theme="Application and API Security"; Days=@("OWASP Top 10 Overview","Secrets Management","API Authentication Risks","Input Validation and Injection","Dependency and Supply Chain Security")},
            @{Theme="Monitoring and Response"; Days=@("Security Logging Fundamentals","Indicators and Detection Logic","Incident Response Lifecycle","Containment and Evidence Handling","Vulnerability Prioritization")},
            @{Theme="Security Project"; Days=@("Threat Model a Network Lab","Create a Secure Configuration Baseline","Validate Firewall and Access Rules","Build a Basic Security Audit Report","Security Practical Assessment")}
        )
    }
)

function Convert-ToSlug([string]$Text) {
    $slug = $Text.ToLowerInvariant() -replace '[^a-z0-9]+','-'
    return $slug.Trim('-')
}

function Get-LessonBody($Track, $WeekNumber, $WeekTheme, $DayNumber, $LessonTitle) {
    $domain = switch ($Track) {
        "networking" { "شبکه" }
        "linux" { "لینوکس و مدیریت سیستم" }
        "python" { "پایتون برای مهندسان شبکه" }
        "backend" { "Backend و API" }
        "automation" { "اتوماسیون شبکه" }
        "infrastructure" { "مهندسی زیرساخت" }
        "security" { "امنیت شبکه و سیستم" }
        default { "مهندسی فناوری اطلاعات" }
    }

    $lab = switch ($Track) {
        "networking" { @'
### آزمایشگاه پایه

```powershell
Get-NetAdapter
Get-NetIPConfiguration
Get-NetRoute -AddressFamily IPv4
Test-NetConnection 1.1.1.1 -Port 443
```

خروجی را ثبت کن، فیلدهای مهم را توضیح بده و مشخص کن کدام بخش از موضوع امروز را نشان می‌دهد.
'@ }
        "linux" { @'
### آزمایشگاه پایه

```bash
uname -a
ip -brief address
ip route
ss -tulpen
```

دستورها را روی یک ماشین Linux یا محیط آزمایشگاهی اجرا کن. اگر Linux در دسترس نیست، ابتدا یک محیط امن آزمایشگاهی آماده کن.
'@ }
        "python" { @'
### آزمایشگاه پایه

```python
def main():
    print("NetFleet Python Lab")

if __name__ == "__main__":
    main()
```

برنامه را اجرا کن، ورودی و خروجی آن را بررسی کن و برای حالت خطا یک تست کوچک بنویس.
'@ }
        "backend" { @'
### آزمایشگاه پایه

یک endpoint آزمایشی طراحی کن. ورودی، خروجی، status code و حالت‌های خطا را مستند کن. سپس رفتار آن را با یک درخواست HTTP آزمایش کن.
'@ }
        "automation" { @'
### آزمایشگاه پایه

یک سناریوی آزمایشگاهی با حداقل دو دستگاه یا دو داده نمونه تعریف کن. ابتدا فقط اطلاعات را جمع‌آوری کن؛ قبل از هر تغییر پیکربندی، pre-check، تأیید و روش rollback را مشخص کن.
'@ }
        "infrastructure" { @'
### آزمایشگاه پایه

یک محیط کوچک و قابل بازسازی طراحی کن. فایل‌های پیکربندی را در Git نگه دار، ورودی‌ها را مستند کن و قبل از اعمال هر تغییر، خروجی plan یا diff را بررسی کن.
'@ }
        "security" { @'
### آزمایشگاه پایه

یک سناریوی آزمایشگاهی مجاز تعریف کن. دارایی، تهدید، سطح دسترسی و شواهد قابل مشاهده را ثبت کن. فقط روی سیستم‌هایی آزمایش کن که مالک آن‌ها هستی یا مجوز صریح داری.
'@ }
    }

    return @"
::: {.persian}
# $LessonTitle

**مسیر:** $domain  
**هفته:** $WeekNumber، $WeekTheme  
**جلسه:** $DayNumber از ۵

## اهداف یادگیری

در پایان این جلسه باید بتوانی:
- مفهوم $LessonTitle را با زبان خودت توضیح بدهی.
- اجزای اصلی و واژگان فنی مرتبط را تشخیص بدهی.
- کاربرد این موضوع را در یک محیط واقعی مهندسی تحلیل کنی.
- یک آزمایش کنترل‌شده اجرا و نتیجه آن را مستند کنی.
- خطاها، محدودیت‌ها و ملاحظات امنیتی را توضیح بدهی.

## 1. جایگاه موضوع در مسیر مهندسی

این جلسه بخشی از مسیر **$domain** است. موضوع «$LessonTitle» را باید در ارتباط با مباحث قبلی و بعدی ببینی، نه به‌عنوان یک دستور یا مفهوم جداافتاده.

در کار مهندسی، هدف فقط حفظ کردن اصطلاحات نیست. باید بتوانی مسئله را تعریف کنی، شواهد جمع‌آوری کنی، فرضیه بسازی، آن را آزمایش کنی و نتیجه را با دقت گزارش بدهی.

## 2. مفاهیم کلیدی

هنگام مطالعه این موضوع، این پرسش‌ها را پاسخ بده:

1. این فناوری یا مفهوم چه مسئله‌ای را حل می‌کند؟
2. اجزای اصلی آن چیست و هر جزء چه مسئولیتی دارد؟
3. ورودی، خروجی و وابستگی‌های آن کدام‌اند؟
4. در چه شرایطی درست کار نمی‌کند؟
5. چه خطاهای پیکربندی یا عملیاتی در آن رایج‌اند؟
6. چه داده‌ای برای تشخیص وضعیت آن باید جمع‌آوری شود؟

واژگان جدید را در یک واژه‌نامه شخصی ثبت کن. برای هر اصطلاح، تعریف فارسی، نام انگلیسی و یک مثال فنی بنویس.

## 3. دیدگاه مهندسی

برای تحلیل درست، بین این سه مورد تفاوت بگذار:

- **Configuration:** چیزی که تنظیم شده است.
- **Operational State:** وضعیتی که سیستم واقعاً در آن قرار دارد.
- **Observed Evidence:** شواهدی که از خروجی ابزارها، لاگ‌ها یا تست‌ها به دست می‌آیند.

این سه مورد همیشه یکسان نیستند. یک پیکربندی صحیح لزوماً تضمین نمی‌کند سرویس در عمل سالم باشد.

## 4. آزمایشگاه عملی

$lab

### گزارش آزمایشگاه

گزارش خود را با این قالب تکمیل کن:

| بخش | چیزی که باید ثبت شود |
|---|---|
| هدف | چه چیزی را می‌خواهی بررسی کنی؟ |
| محیط | سیستم‌عامل، ابزار و نسخه |
| فرضیه | انتظار داری چه اتفاقی بیفتد؟ |
| اجرا | مراحل و دستورهای اجراشده |
| مشاهده | خروجی واقعی |
| تحلیل | نتیجه چه معنایی دارد؟ |
| محدودیت | چه چیزی هنوز اثبات نشده است؟ |

## 5. سناریوی عیب‌یابی

فرض کن بخشی از زیرساخت مطابق انتظار کار نمی‌کند.

1. محدوده مشکل را مشخص کن.
2. آخرین تغییرات را بررسی کن.
3. وضعیت فعلی را بدون ایجاد تغییر جمع‌آوری کن.
4. فرضیه‌های محتمل را از ساده به پیچیده مرتب کن.
5. هر فرضیه را با یک آزمایش مشخص بررسی کن.
6. نتیجه و شواهد را مستند کن.

از تغییر هم‌زمان چند متغیر خودداری کن؛ در غیر این صورت تشخیص علت واقعی دشوار می‌شود.

## 6. ارتباط با NetFleet

در پروژه NetFleet باید بتوانیم دانش این جلسه را به یک قابلیت قابل اندازه‌گیری تبدیل کنیم.

به این پرسش پاسخ بده:

**اگر بخواهیم موضوع «$LessonTitle» را در NetFleet خودکار کنیم، چه داده‌ای باید جمع‌آوری شود، چه قانونی باید بررسی شود و چه گزارشی باید تولید شود؟**

طرح اولیه خود را با سه بخش بنویس:
- Data Source
- Validation Rule
- Expected Output

## 7. تمرین و ارزیابی

1. موضوع امروز را در پنج جمله توضیح بده.
2. سه اصطلاح مهم آن را تعریف کن.
3. یک کاربرد واقعی و یک محدودیت آن را نام ببر.
4. یک خطای رایج را توضیح بده و روش تشخیص آن را بنویس.
5. مشخص کن چه چیزی را می‌توان خودکار کرد و چه چیزی به تأیید انسانی نیاز دارد.

## 8. تکلیف

یک گزارش کوتاه فنی تهیه کن که شامل هدف، معماری یا مفهوم، مراحل آزمایش، شواهد، نتیجه‌گیری و منابع باشد. از ادعایی که با آزمایش یا منبع معتبر پشتیبانی نمی‌شود خودداری کن.

## معیار تکمیل جلسه

- [ ] می‌توانم مفهوم را بدون نگاه به جزوه توضیح بدهم.
- [ ] می‌توانم آزمایش را دوباره اجرا کنم.
- [ ] خروجی را می‌توانم تفسیر کنم.
- [ ] محدودیت‌ها و ریسک‌ها را می‌شناسم.
- [ ] می‌توانم کاربرد آن را در NetFleet شرح بدهم.

## منابع پیشنهادی برای مطالعه بیشتر

منابع رسمی و مستندات ابزارها را در اولویت قرار بده. نسخه و تاریخ دسترسی را در گزارش ثبت کن. لینک‌های این جلسه باید پیش از انتشار نهایی توسط مدرس یا بازبین بررسی شوند.
:::
"@
}

$created = 0
$preserved = 0
$total = 0

foreach ($track in $Curriculum) {
    $trackRoot = Join-Path $ProjectRoot ("learning\" + $track.Path)
    New-Item -ItemType Directory -Path $trackRoot -Force | Out-Null

    $indexPath = Join-Path $trackRoot "index.qmd"
    if (-not (Test-Path $indexPath) -or $Force) {
        $weekLinks = for ($w = 1; $w -le $track.Weeks.Count; $w++) {
            $weekFolder = "week-{0:D2}" -f $w
            "- [Week $w`: $($track.Weeks[$w-1].Theme)]($weekFolder/index.qmd)"
        }
        $index = @"
---
title: "$($track.Title)"
---

::: {.persian}
# $($track.Title)

این مسیر آموزشی بخشی از برنامه مهندسی NetFleet است. مباحث به‌صورت مرحله‌ای از مفاهیم پایه تا تمرین‌های عملی و پروژه پیش می‌روند.

## برنامه هفتگی

$($weekLinks -join "`n")

## روش مطالعه

برای هر جلسه ابتدا اهداف یادگیری را مرور کن، سپس مفاهیم را مطالعه و آزمایشگاه را اجرا کن. در پایان، گزارش و ارزیابی را تکمیل کن.
:::
"@
        Set-Content -Path $indexPath -Value $index -Encoding utf8
    }

    for ($w = 1; $w -le $track.Weeks.Count; $w++) {
        $week = $track.Weeks[$w-1]
        $weekFolder = "week-{0:D2}" -f $w
        $weekRoot = Join-Path $trackRoot $weekFolder
        New-Item -ItemType Directory -Path $weekRoot -Force | Out-Null

        $weekIndex = Join-Path $weekRoot "index.qmd"
        if (-not (Test-Path $weekIndex) -or $Force) {
            $dayLinks = for ($d = 1; $d -le 5; $d++) {
                $dayFile = "day-{0:D2}.qmd" -f $d
                "- [Day $d`: $($week.Days[$d-1])]($dayFile)"
            }
            $weekContent = @"
---
title: "Week $w - $($week.Theme)"
---

::: {.persian}
# هفته ${w}: $($week.Theme)

این هفته روی موضوع **$($week.Theme)** تمرکز دارد.

## جلسات

$($dayLinks -join "`n")

## خروجی هفتگی

در پایان هفته باید بتوانی مفاهیم را توضیح بدهی، آزمایش‌ها را تکرار کنی و یک گزارش فنی کوتاه همراه با شواهد ارائه بدهی.
:::
"@
            Set-Content -Path $weekIndex -Value $weekContent -Encoding utf8
        }

        for ($d = 1; $d -le 5; $d++) {
            $total++
            $dayFile = "day-{0:D2}.qmd" -f $d
            $dayPath = Join-Path $weekRoot $dayFile
            if (Test-Path $dayPath) {
                $existing = Get-Item $dayPath
                # Preserve substantial lessons (including existing Day 01 content).
                # Replace only short generated skeletons, unless -Force is supplied.
                if (-not $Force -and $existing.Length -gt 1800) {
                    $preserved++
                    continue
                }
            }

            $lessonTitle = $week.Days[$d-1]
            $slug = Convert-ToSlug $lessonTitle
            $body = Get-LessonBody $track.Path $w $week.Theme $d $lessonTitle
            $frontMatter = @"
---
title: "$lessonTitle"
subtitle: "$($track.Title) | Week $w | Day $d"
---

"@
            Set-Content -Path $dayPath -Value ($frontMatter + $body) -Encoding utf8
            $created++
        }
    }
}

Write-Host ""
Write-Host "NetFleet curriculum structure processed." -ForegroundColor Cyan
Write-Host "Tracks: $($Curriculum.Count)" -ForegroundColor Green
Write-Host "Weeks: 50" -ForegroundColor Green
Write-Host "Lesson files checked: $total" -ForegroundColor Green
Write-Host "New lesson files created: $created" -ForegroundColor Green
Write-Host "Existing lesson files preserved: $preserved" -ForegroundColor Yellow
Write-Host ""
Write-Host "IMPORTANT: This builder creates the full curriculum map and structured lesson drafts." -ForegroundColor Yellow
Write-Host "It does not claim that all 250 lessons have been fully authored or technically reviewed." -ForegroundColor Yellow
Write-Host "Do not publish until lesson content, references, and labs have been expanded and reviewed." -ForegroundColor Yellow
