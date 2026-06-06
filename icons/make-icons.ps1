# Generates app icon PNGs using .NET System.Drawing (Windows).
# Run:  powershell -ExecutionPolicy Bypass -File make-icons.ps1
Add-Type -AssemblyName System.Drawing

function New-Icon {
    param([int]$Size, [string]$Path, [bool]$Maskable)

    $bmp = New-Object System.Drawing.Bitmap($Size, $Size)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = 'AntiAlias'
    $g.InterpolationMode = 'HighQualityBicubic'

    $rect = New-Object System.Drawing.Rectangle(0, 0, $Size, $Size)

    # rounded clip for "any" icons; full bleed for maskable
    if (-not $Maskable) {
        $r = [int]($Size * 0.22)
        $gp = New-Object System.Drawing.Drawing2D.GraphicsPath
        $gp.AddArc(0, 0, $r, $r, 180, 90)
        $gp.AddArc($Size - $r, 0, $r, $r, 270, 90)
        $gp.AddArc($Size - $r, $Size - $r, $r, $r, 0, 90)
        $gp.AddArc(0, $Size - $r, $r, $r, 90, 90)
        $gp.CloseFigure()
        $g.SetClip($gp)
    }

    # sky gradient
    $c1 = [System.Drawing.Color]::FromArgb(11, 5, 48)
    $c2 = [System.Drawing.Color]::FromArgb(90, 35, 80)
    $grad = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rect, $c1, $c2, 90)
    $g.FillRectangle($grad, $rect)

    $pad = if ($Maskable) { [int]($Size * 0.12) } else { 0 }
    $inner = $Size - 2 * $pad
    $ox = $pad; $oy = $pad

    # stars
    $white = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $rng = New-Object System.Random(7)
    for ($i = 0; $i -lt 22; $i++) {
        $sx = $ox + $rng.Next($inner)
        $sy = $oy + $rng.Next([int]($inner * 0.55))
        $ss = [Math]::Max(1, [int]($Size * 0.006))
        $g.FillRectangle($white, $sx, $sy, $ss, $ss)
    }

    # sun glow + body
    $sunX = $ox + $inner * 0.76; $sunY = $oy + $inner * 0.22; $sunR = $inner * 0.11
    $sunBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 224, 102))
    $g.FillEllipse($sunBrush, [single]($sunX - $sunR), [single]($sunY - $sunR), [single]($sunR * 2), [single]($sunR * 2))

    # skyline silhouette
    $sky = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(22, 15, 51))
    $base = $oy + $inner * 0.74
    $bw = $inner / 6.0
    $heights = @(0.30, 0.46, 0.22, 0.52, 0.34, 0.42)
    for ($i = 0; $i -lt 6; $i++) {
        $bx = $ox + $i * $bw
        $bh = $inner * $heights[$i]
        $g.FillRectangle($sky, [single]$bx, [single]($base - $bh), [single]($bw - $inner * 0.012), [single]($bh + $inner * 0.3))
    }

    # banana (thick yellow arc, rounded caps)
    $banPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 225, 77), [single]($inner * 0.085))
    $banPen.StartCap = 'Round'; $banPen.EndCap = 'Round'
    $bcx = $ox + $inner * 0.28; $bcy = $oy + $inner * 0.46; $brad = $inner * 0.14
    $g.DrawArc($banPen, [single]($bcx - $brad), [single]($bcy - $brad), [single]($brad * 2), [single]($brad * 2), 35, 200)
    $banEdge = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(201, 162, 39), [single]($inner * 0.012))
    $banEdge.StartCap = 'Round'; $banEdge.EndCap = 'Round'
    $g.DrawArc($banEdge, [single]($bcx - $brad), [single]($bcy - $brad), [single]($brad * 2), [single]($brad * 2), 35, 200)

    # gorilla head
    $gw = $inner * 0.32; $gh = $inner * 0.34
    $gx = $ox + $inner * 0.52; $gy = $oy + $inner * 0.58
    $fur = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(90, 58, 42))
    $g.FillEllipse($fur, [single]$gx, [single]$gy, [single]$gw, [single]$gh)
    $skin = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(202, 160, 122))
    $g.FillEllipse($skin, [single]($gx + $gw * 0.20), [single]($gy + $gh * 0.32), [single]($gw * 0.60), [single]($gh * 0.55))
    $brow = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(67, 41, 28))
    $g.FillRectangle($brow, [single]($gx + $gw * 0.18), [single]($gy + $gh * 0.30), [single]($gw * 0.64), [single]($gh * 0.10))
    $eye = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(17, 17, 17))
    $er = $gw * 0.07
    $g.FillEllipse($eye, [single]($gx + $gw * 0.34 - $er), [single]($gy + $gh * 0.46 - $er), [single]($er * 2), [single]($er * 2))
    $g.FillEllipse($eye, [single]($gx + $gw * 0.64 - $er), [single]($gy + $gh * 0.46 - $er), [single]($er * 2), [single]($er * 2))

    $g.Dispose()
    $bmp.Save($Path, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
    Write-Host "wrote $Path"
}

$dir = $PSScriptRoot
New-Icon -Size 192 -Path (Join-Path $dir 'icon-192.png') -Maskable $false
New-Icon -Size 512 -Path (Join-Path $dir 'icon-512.png') -Maskable $false
New-Icon -Size 512 -Path (Join-Path $dir 'icon-512-maskable.png') -Maskable $true
Write-Host "done"
