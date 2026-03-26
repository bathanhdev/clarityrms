function Remove-Comments {
    param([string]$code)
    $i = 0
    $n = $code.Length
    $state = 'normal'
    $res = ''
    while ($i -lt $n) {
        $c = $code[$i]
        switch ($state) {
            'normal' {
                if ($i + 1 -lt $n -and $code.Substring($i,2) -eq '/*') {
                    $state = 'block'; $i += 2; continue
                } elseif ($i + 1 -lt $n -and $code.Substring($i,2) -eq '//') {
                    $state = 'line'; $i += 2; continue
                } elseif ($c -eq '"') {
                    $res += $c; $state = 'double'; $i++
                } elseif ($c -eq "'") {
                    $res += $c; $state = 'single'; $i++
                } else {
                    $res += $c; $i++
                }
            }
            'block' {
                if ($i + 1 -lt $n -and $code.Substring($i,2) -eq '*/') { $state = 'normal'; $i += 2 } else { $i++ }
            }
            'line' {
                if ($c -eq "`n") { $res += $c; $state = 'normal' }
                $i++
            }
            'double' {
                if ($c -eq '\\' -and $i + 1 -lt $n) { $res += $code.Substring($i,2); $i += 2 }
                elseif ($c -eq '"') { $res += $c; $state = 'normal'; $i++ }
                else { $res += $c; $i++ }
            }
            'single' {
                if ($c -eq '\\' -and $i + 1 -lt $n) { $res += $code.Substring($i,2); $i += 2 }
                elseif ($c -eq "'") { $res += $c; $state = 'normal'; $i++ }
                else { $res += $c; $i++ }
            }
        }
    }
    return $res
}

Get-ChildItem -Recurse -Path .\lib -Filter *.dart | ForEach-Object {
    $path = $_.FullName
    $text = Get-Content -Raw -Encoding UTF8 $path
    $newText = Remove-Comments $text
    if ($newText -ne $text) {
        Set-Content -Path $path -Value $newText -Encoding UTF8
        Write-Host "Stripped: $path"
    }
}
Write-Host 'Done strip comments in lib/**/*.dart'