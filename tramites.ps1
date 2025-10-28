# Script: tramites.ps1
# Autor: Doutor ChatGPT 👨‍⚖️
# Função:
# - Detecta quando o jogo "League of Legends.exe" é iniciado.
# - Aguarda 10 segundos e fecha LeagueClient.exe, RiotClientServices.exe e LeagueCrashHandler64.exe.
# - Quando o jogo é fechado, reabre o RiotClientServices.exe com os argumentos corretos.

# Caminhos e configurações
$processoJogo = "League of Legends"
$processosFechar = @("LeagueClient", "RiotClientServices", "LeagueCrashHandler64")
$riotPath = "C:\Riot Games\Riot Client\RiotClientServices.exe"
$riotArgs = "--launch-product=league_of_legends --launch-patchline=live"

# Variáveis de estado
$iniciado = $false
$encerrado = $false

Write-Host "$(Get-Date -Format 'HH:mm:ss') - Monitorando League of Legends..." -ForegroundColor Cyan

# Loop principal
while ($true) {
    Start-Sleep -Seconds 2
    $jogoRodando = Get-Process -Name $processoJogo -ErrorAction SilentlyContinue

    # Quando o jogo for detectado
    if ($jogoRodando -and -not $iniciado) {
        $iniciado = $true
        Write-Host "$(Get-Date -Format 'HH:mm:ss') - League of Legends detectado. Aguardando 10 segundos..." -ForegroundColor Yellow
        Start-Sleep -Seconds 10

        # Fecha os processos do cliente
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

    # Quando o jogo for encerrado
    if (-not $jogoRodando -and $iniciado -and -not $encerrado) {
        $encerrado = $true
        Write-Host "$(Get-Date -Format 'HH:mm:ss') - Jogo fechado. Reabrindo Riot Client..." -ForegroundColor Cyan

        Start-Process -FilePath $riotPath -ArgumentList $riotArgs
        Write-Host "$(Get-Date -Format 'HH:mm:ss') - Riot Client iniciado com sucesso." -ForegroundColor Green
        break
    }
}
