$ErrorActionPreference = "Stop"

$root = "C:\Netfleet-Docs"

$paths = @{
    "python" = @{
        Title = "Python Engineering"
        Weeks = 8
        LessonsPerWeek = 5
    }
    "networking" = @{
        Title = "Networking Engineering"
        Weeks = 8
        LessonsPerWeek = 5
    }
    "linux" = @{
        Title = "Linux Engineering"
        Weeks = 8
        LessonsPerWeek = 5
    }
    "automation" = @{
        Title = "Infrastructure Automation"
        Weeks = 6
        LessonsPerWeek = 5
    }
    "infrastructure" = @{
        Title = "Infrastructure Management"
        Weeks = 6
        LessonsPerWeek = 5
    }
    "backend" = @{
        Title = "Backend Engineering"
        Weeks = 8
        LessonsPerWeek = 5
    }
    "security" = @{
        Title = "Security & Reliability"
        Weeks = 6
        LessonsPerWeek = 5
    }
}

foreach ($path in $paths.GetEnumerator()) {

    $folder = Join-Path $root "learning\$($path.Key)"

    New-Item -ItemType Directory -Path $folder -Force | Out-Null

    $index = Join-Path $folder "index.qmd"

    if (!(Test-Path $index)) {
        @"
---
title: "$($path.Value.Title)"
---

# $($path.Value.Title)

Learning path for NetFleet engineering.
"@ | Set-Content -Path $index -Encoding UTF8
    }

    for ($week = 1; $week -le $path.Value.Weeks; $week++) {

        $weekName = "week-{0:D2}" -f $week
        $weekFolder = Join-Path $folder $weekName

        New-Item -ItemType Directory -Path $weekFolder -Force | Out-Null

        for ($day = 1; $day -le $path.Value.LessonsPerWeek; $day++) {

            $dayName = "day-{0:D2}.qmd" -f $day
            $file = Join-Path $weekFolder $dayName

            if (!(Test-Path $file)) {
                @"
---
title: "Week $week | Day $day"
---

# Week $week - Day $day

::: {.persian}

## موضوع جلسه

محتوای این جلسه در آینده تکمیل خواهد شد.

:::
"@ | Set-Content -Path $file -Encoding UTF8
            }
        }
    }

    Write-Host "Created: $($path.Value.Title)" -ForegroundColor Green
}

Write-Host "`nNetFleet curriculum structure created successfully!" -ForegroundColor Cyan