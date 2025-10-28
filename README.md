o conteudo do gist esta assim, preciso colocar o procedimento para os usuarios criarem o atalho na area de trabalho do jeito que fizemos? 

# AutoLeague-Tramites.ps1
# Autor: JUÍZ DO LOL 👨‍⚖️
# Descrição:

#  - Detecta o "League of Legends.exe"
#  - Aguarda 10 segundos
#  - Fecha LeagueClient.exe, RiotClientServices.exe e LeagueCrashHandler64.exe
#  - Ao fechar o jogo, reabre o Riot Client automaticamente

#  - Apoie: https://pixgg.com/juiz_2026
#  - Apoie com Sub: https://twitch.tv/juiz_do_lol_2026

$processoJogo = "League of Legends"
$processosFechar = @("LeagueClient", "RiotClientServices", "LeagueCrashHandler64")
$riotPath = "C:\Riot Games\Riot Client\RiotClientServices.exe"
$riotArgs = "--launch-product=league_of_legends --launch-patchline=live"

$iniciado = $false
$encerrado = $false

Write-Host "$(Get-Date -Format 'HH:mm:ss') - Monitorando League of Legends..." -ForegroundColor Cyan

while ($true) {
    Start-Sleep -Seconds 2
    $jogoRodando = Get-Process -Name $processoJogo -ErrorAction SilentlyContinue

    if ($jogoRodando -and -not $iniciado) {
        $iniciado = $true
        Write-Host "$(Get-Date -Format 'HH:mm:ss') - League of Legends detectado. Aguardando 10 segundos..." -ForegroundColor Yellow
        Start-Sleep -Seconds 10

        foreach ($p in $processosFechar) {
            try {
                Stop-Process -Name $p -Force -ErrorAction Stop
                Write-Host "$(Get-Date -Format 'HH:mm:ss') - Processo $p encerrado." -ForegroundColor Green
            } catch {
                $erro = $_.Exception.Message
                Write-Host ("{0} - Erro ao matar {1}: {2}" -f (Get-Date -Format 'HH:mm:ss'), $p, $erro) -ForegroundColor DarkRed
            }
        }
    }

    if (-not $jogoRodando -and $iniciado -and -not $encerrado) {
        $encerrado = $true
        Write-Host "$(Get-Date -Format 'HH:mm:ss') - Jogo fechado. Reabrindo Riot Client..." -ForegroundColor Cyan

        Start-Process -FilePath $riotPath -ArgumentList $riotArgs
        Write-Host "$(Get-Date -Format 'HH:mm:ss') - Riot Client iniciado com sucesso." -ForegroundColor Green
        break
    }
}
#  - Apoie: https://pixgg.com/juiz_2026
#  - Apoie com Sub: https://twitch.tv/juiz_do_lol_2026
