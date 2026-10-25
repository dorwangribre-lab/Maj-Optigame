# =====================================================================
#  OPTIGAME - Application d'optimisation PC Gaming
#  Lancer via "Lancer_OptiGame.bat" (droits administrateur demandes)
# =====================================================================
# OptiGame version: 3.0
# OptiGame source: https://raw.githubusercontent.com/dorwangribre-lab/Maj-Optigame/main/manifest.json
# NOTE: v3 - Grosse mise a jour : 12 jeux optimises (Valorant, LoL, CS2, Minecraft, GTA V, Apex, EA FC en plus).
# NOTE: Mises a jour en ligne : l'operateur publie, les autres PC installent ou mettent de cote (verification anti-modification).
# NOTE: Apparence : couleurs (vert, bleu, rose, violet, rouge, orange, cyan, noir et blanc, perso), fonds et image de fond.
# NOTE: Score et conseils plus approfondis (souris, demarrage, TRIM, mises a jour, BIOS...) avec etapes et boutons Regler pour moi.
# NOTE: Ce qui a change : explication de chaque reglage et bouton qui l'a fait. La memoire liberee n'y apparait plus.
# NOTE: OptiGame demarre plus vite (code C# mis en cache, analyse par etapes, detection des jeux plus legere).
# NOTE: Timer Resolution peut rester au maximum en permanence, meme OptiGame ferme (petit programme invisible au demarrage du PC).
# NOTE: Mode OLED (page Apparence) : Windows sombre, fond noir pur, noirs renforces, remis comme avant en un clic.
# NOTE: Alt+Entree desactive dans Fortnite (son plein ecran Alt+Entree bugue avec 2 ecrans) : le plein ecran se regle dans le menu de Fortnite.
# NOTE: Vrai plein ecran : si le plein ecran est deja active dans les parametres d'un jeu, OptiGame enleve le sien pour ce jeu (plus de double plein ecran).
# NOTE: Vrai plein ecran corrige : il ne touche plus du tout Fortnite (plus d'ecran noir ni de plein ecran sur les 2 ecrans), Fortnite garde son anti-bug.
# NOTE: Mises a jour cherchees toutes les 15 secondes ; notification Windows + barre des taches qui clignote quand une version sort.
# NOTE: Souris bloquee et touche Windows : seulement quand le jeu est en plein ecran (en fenetre, tout est libre).
# NOTE: Les interrupteurs ne posent plus de questions : un petit message confirme, c'est tout.
# NOTE: Page Jeux : anti-bug 2 ecrans pour tous les jeux, vrai plein ecran, souris bloquee meme dans les menus, touche Windows desactivee en jeu.
# NOTE: Icone OptiGame dans la barre des taches.
# NOTE: Souris bloquee renforcee : elle ne passe plus du tout sur l'autre ecran pendant le jeu.
# NOTE: En arriere-plan, OptiGame reste dans la barre des taches (un clic le fait revenir).
# NOTE: Mises a jour cherchees toutes les 2 minutes, avec notification Windows pour les amis.
# NOTE: Souris bloquee sur l'ecran du jeu (2 ecrans) : interrupteur en haut de la page Jeux.
# NOTE: Menu reorganise : Ecran juste sous Composants, Apparence et Versions en haut de la partie Application.
# NOTE: Nouvel onglet Reseau : etat de la connexion, speed test et DNS le plus rapide (teste et mis en un clic).
# NOTE: Temperatures a l'Accueil (carte graphique) avec alerte si ca chauffe, meme en jeu.
# NOTE: Sante des disques dans Composants : usure, temperature, heures, erreurs.
# NOTE: Vrai plein ecran (exclusif) pour tous les jeux : interrupteur en haut de la page Jeux.
# NOTE: Fenetre Nouveautes apres une mise a jour (et bouton dans Versions).
# NOTE: Speed test refait : la mesure tourne dans un programme a part (Ookla, ou secours Cloudflare), jauge et chiffres animes par WPF a 60 images/s.
# NOTE: Speed test avec l'outil officiel Speedtest by Ookla (programme a part : fenetre fluide, memes resultats que speedtest.net) ; bouton Reparer les captures a l'Accueil.
# NOTE: Speed test plus precis (vrai ping TCP, 8 connexions) et fluide ; captures d'ecran reparees si elles etaient bloquees.
# NOTE: Nouvel onglet Speed test : ping, stabilite, ping en charge (bufferbloat), descendant, montant, verdict pour jouer et historique.
# NOTE: Au lancement, OptiGame demande s'il doit installer la nouvelle version (un clic : installe + redemarre dessus).
# NOTE: Nouvelles versions cherchees toutes les 10 minutes (et a la reouverture) : banniere a l'Accueil + notification Windows.
# NOTE: Mode test ami (bouton Voir comme un ami ou Tester_comme_un_ami.bat) : OptiGame tel que le voit un ami, sans toucher au vrai.
# NOTE: Bouton Bords ultra lisses (onglet Ecran) : anticrenelage 8x, textures max, eclairage Future (Roblox), MSAA 8x (Rocket League), TAA haute qualite + accentuation (Palworld).
# NOTE: Onglet Ecran : image plus nette (resolution native + frequence max avec retour auto, ClearType, applis floues, guide AMD Image Sharpening, Edge videos).
# NOTE: Onglet Ecran (ex Ecran OLED) : anti-banding (analyse des ecrans, test des degrades, guide AMD, lissage mpv, noirs OLED doux).
# NOTE: Jeu deja lance avant OptiGame : la priorite elevee est appliquee tout de suite.
# NOTE: Clic sur OptiGame alors qu'il est deja ouvert : sa fenetre revient a l'ecran, sans question ni relance.
# NOTE: 2 raccourcis : OptiGame (ouvre directement la derniere version utilisee) et OptiGame - Lanceur (nom qui commence par OptiGame pour la recherche Windows).
# NOTE: Garde tout ce qui existait avant : Timer Resolution, Spicetify, Antivirus, anti-bug 2 ecrans, reglages caches des jeux...

param([switch]$Reprise, [switch]$Cache, [switch]$TestAmi)
# -TestAmi : OptiGame comme le verrait un ami (pas operateur), dans un dossier de test a part.
# Rien de ce qui est fait dans ce mode ne touche a ton vrai OptiGame (versions, raccourcis, mode operateur).
$SuffixeInst = if ($TestAmi) { '_TestAmi' } else { '' }
$ArgTest = if ($TestAmi) { ' -TestAmi' } else { '' }
$DossierTestAmi = Join-Path $env:ProgramData 'OptiGame\TestAmi'

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase, System.Xaml

# Laisse l'interface respirer pendant les taches longues (remplace DoEvents)
function Pump-Ui {
    try {
        $cadre = New-Object System.Windows.Threading.DispatcherFrame
        $null = [System.Windows.Threading.Dispatcher]::CurrentDispatcher.BeginInvoke([System.Windows.Threading.DispatcherPriority]::Background,
            [Action]{ $cadre.Continue = $false }.GetNewClosure())
        [System.Windows.Threading.Dispatcher]::PushFrame($cadre)
    } catch {}
}
[System.Windows.Forms.Application]::EnableVisualStyles()

# Code C# compile une seule fois puis garde en cache (DLL) : OptiGame demarre beaucoup plus vite
function Charger-Type([string]$nom, [string]$code) {
    if ($nom -as [type]) { return }
    try {
        $sha = [BitConverter]::ToString([Security.Cryptography.SHA1]::Create().ComputeHash([Text.Encoding]::UTF8.GetBytes($code))).Replace('-', '').Substring(0, 12)
        $dir = Join-Path $env:ProgramData 'OptiGame\cache'
        $dll = Join-Path $dir "$nom-$sha.dll"
        if (-not (Test-Path -LiteralPath $dll)) {
            New-Item -ItemType Directory -Path $dir -Force | Out-Null
            Get-ChildItem -LiteralPath $dir -Filter "$nom-*.dll" -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
            Add-Type -TypeDefinition $code -Language CSharp -OutputAssembly $dll -OutputType Library -ErrorAction Stop
        }
        if (-not ($nom -as [type])) { Add-Type -Path $dll -ErrorAction Stop }
    } catch {}
    if (-not ($nom -as [type])) { Add-Type -TypeDefinition $code -Language CSharp }
}

# ---------- OptiGame deja ouvert ? On remet juste sa fenetre a l'ecran ----------
# (pas de question, pas de relance : un clic sur OptiGame = la fenetre s'affiche)
$CodePremierPlan = @'
using System;
using System.Runtime.InteropServices;
public static class OptiGamePremierPlan {
    [DllImport("user32.dll")] public static extern bool AllowSetForegroundWindow(int id);
}
'@
function Montrer-OptiGameOuvert {
    $m = $null; $existe = $false
    try { $existe = [System.Threading.Mutex]::TryOpenExisting("Global\OptiGame_Instance$SuffixeInst", [ref]$m); if ($m) { $m.Dispose() } }
    catch [System.UnauthorizedAccessException] { $existe = $true } catch {}
    if (-not $existe) { return $false }
    # Autorise la fenetre deja ouverte a passer devant (sinon Windows la fait juste clignoter)
    try { Charger-Type 'OptiGamePremierPlan' $CodePremierPlan; [void][OptiGamePremierPlan]::AllowSetForegroundWindow(-1) } catch {}
    try {
        $ev = [System.Threading.EventWaitHandle]::OpenExisting("Global\OptiGame_Montrer$SuffixeInst", [System.Security.AccessControl.EventWaitHandleRights]'Modify, Synchronize')
        [void]$ev.Set()
        Start-Sleep -Milliseconds 1500
        [void]$ev.Reset(); $ev.Dispose()
        return $true
    } catch { return $false }
}
if (Montrer-OptiGameOuvert) { exit }

# ---------- Droits administrateur ----------
$principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    $extra = if ($Reprise) { ' -Reprise' } else { '' }
    $extra += $ArgTest
    Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$PSCommandPath`"$extra" -Verb RunAs
    exit
}
# Mode test ami : on se copie dans le dossier de test (comme un ami qui n'a que cette version), et on se lance de la-bas
if ($TestAmi -and (Split-Path $PSCommandPath) -ne $DossierTestAmi) {
    New-Item -ItemType Directory -Path $DossierTestAmi -Force | Out-Null
    Get-ChildItem -LiteralPath $DossierTestAmi -Filter 'OptiGame*.ps1' -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
    $copie = Join-Path $DossierTestAmi (Split-Path $PSCommandPath -Leaf)
    Copy-Item -LiteralPath $PSCommandPath -Destination $copie -Force
    Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$copie`" -TestAmi"
    exit
}
$script:CheminScript = $PSCommandPath

# =====================================================================
#  VERSIONS : chaque fichier OptiGame_vX.X.ps1 du dossier est une version.
#  La version active est memorisee ; une nouvelle version deposee
#  dans le dossier devient active automatiquement. Rien n'est supprime.
# =====================================================================
$NomFichierApp = [IO.Path]::GetFileNameWithoutExtension($PSCommandPath)
$VersionApp = if ($NomFichierApp -match '^OptiGame_v(\d+(\.\d+)*)$') { $Matches[1] } else { '1.0' }
$FichierVersions = if ($TestAmi) { Join-Path $DossierTestAmi 'versions.json' } else { Join-Path $env:ProgramData 'OptiGame\versions.json' }

function Version-DeNom([string]$nom) {
    $v = if ($nom -match '^OptiGame_v(\d+(\.\d+)*)\.ps1$') { $Matches[1] } else { '1.0' }
    if ($v -notmatch '\.') { $v += '.0' }
    return [version]$v
}

function Lister-Versions {
    $d = Split-Path $PSCommandPath
    return @(Get-ChildItem -LiteralPath $d -File -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -match '^OptiGame_v\d+(\.\d+)*\.ps1$' } |
        Sort-Object { Version-DeNom $_.Name } -Descending)
}

function Lire-EtatVersions {
    if (Test-Path $FichierVersions) { try { return (Get-Content $FichierVersions -Raw | ConvertFrom-Json) } catch {} }
    return [pscustomobject]@{ Active = $null; Vues = @() }
}

function Sauver-EtatVersions([string]$active, $vues) {
    New-Item -ItemType Directory -Path (Split-Path $FichierVersions) -Force | Out-Null
    [pscustomobject]@{ Active = $active; Vues = @($vues | Select-Object -Unique) } | ConvertTo-Json | Out-File -FilePath $FichierVersions -Encoding UTF8
}

function Choisir-Version {
    $liste = Lister-Versions
    if ($liste.Count -eq 0) { return $PSCommandPath }
    $etat = Lire-EtatVersions
    $vues = @($etat.Vues | Where-Object { $_ })
    $noms = @($liste | ForEach-Object { $_.Name })
    $active = $etat.Active
    $nouvelles = @($noms | Where-Object { $vues -notcontains $_ })
    # Une version jamais vue et plus recente que l'active : on passe dessus automatiquement
    if ($nouvelles.Count -gt 0 -and $vues.Count -gt 0) {
        $plusNeuve = $liste | Where-Object { $nouvelles -contains $_.Name } | Select-Object -First 1
        if (-not $active -or (Version-DeNom $plusNeuve.Name) -gt (Version-DeNom $active)) { $active = $plusNeuve.Name }
    }
    if (-not $active -or $noms -notcontains $active) { $active = $liste[0].Name }
    Sauver-EtatVersions $active ($vues + $noms)
    return ($liste | Where-Object { $_.Name -eq $active } | Select-Object -First 1).FullName
}

# Si une autre version est active, on la lance a la place de celle-ci
if (-not $Reprise -and -not $TestAmi) {
    try {
        $cible = Choisir-Version
        if ($cible -and $cible -ne $PSCommandPath) {
            $extra = ''
            if ($Cache -and (Select-String -LiteralPath $cible -Pattern 'switch\]\$Cache' -Quiet)) { $extra = ' -Cache' }
            Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$cible`"$extra"
            exit
        }
    } catch {}
}


# ---------- Une seule fenetre OptiGame a la fois ----------
function Signal-OptiGame([string]$nom) {
    try {
        $ev = New-Object System.Threading.EventWaitHandle($false, [System.Threading.EventResetMode]::ManualReset, "Global\$nom")
        [void]$ev.Set()
        return $ev
    } catch { return $null }
}
function Tuer-AutresOptiGame {
    Get-CimInstance Win32_Process -Filter "Name='powershell.exe'" -ErrorAction SilentlyContinue |
        Where-Object { $_.ProcessId -ne $PID -and "$($_.CommandLine)" -match 'OptiGame(_v[\d.]+)?\.ps1' } |
        ForEach-Object { Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue }
}
$nouvelleInstance = $false
$script:Mutex = New-Object System.Threading.Mutex($true, "Global\OptiGame_Instance$SuffixeInst", [ref]$nouvelleInstance)
if (-not $nouvelleInstance) {
    # Deja ouvert : on affiche simplement la fenetre ouverte, sans rien demander
    try { Charger-Type 'OptiGamePremierPlan' $CodePremierPlan; [void][OptiGamePremierPlan]::AllowSetForegroundWindow(-1) } catch {}
    $ev = Signal-OptiGame "OptiGame_Montrer$SuffixeInst"
    Start-Sleep -Milliseconds 1500
    if ($ev) { $ev.Reset() }
    exit
}

# =====================================================================
#  OPTIMISATIONS PAR JEU
#  Pour ajouter un script a un jeu : remplace $null par un bloc { ... }
#  Exemple :
#     'Fortnite' = {
#         Write-Log 'Nettoyage du cache Fortnite...'
#         Clear-Folder "$env:LOCALAPPDATA\FortniteGame\Saved\Logs"
#     }
# =====================================================================
$Jeux = [ordered]@{
    # ---------------------------------------------------------------
    'Fortnite' = @{
        Process = @('FortniteClient-Win64-Shipping', 'FortniteLauncher')
        Config  = { Join-Path $env:LOCALAPPDATA 'FortniteGame\Saved\Config\WindowsClient\GameUserSettings.ini' }
        Exe     = { Trouver-ExeFortnite }
        Video   = 'meilleurs parametres Fortnite PC FPS AMD'
        Options = @(
            @{ Nom = 'Anti-bug 2 ecrans : plein ecran sans changement de resolution'; Defaut = $false
               Desc = 'Pour les PC a 2 ecrans : le jeu passe en plein ecran fenetre a la resolution exacte de ton ecran principal. L''ecran ne se rallume plus, Windows ne bascule plus sur le 2e ecran, plus de resolution folle ni de crash en quittant le plein ecran. Change le mode d''affichage du jeu (c''est le but) : decoche pour le regler toi-meme.'
               Action = { Set-AntiBugUE 'Fortnite' (& $Jeux['Fortnite'].Config) } }
            @{ Nom = 'Desactiver l''acceleration de la souris'; Defaut = $true
               Desc = 'Reglage cache (absent du menu de Fortnite) : le meme geste donne toujours le meme mouvement, visee plus reguliere.'
               Action = { Set-IniJeu 'Fortnite' (& $Jeux['Fortnite'].Config) '/Script/FortniteGame.FortGameUserSettings' 'bDisableMouseAcceleration' 'True' 'Acceleration souris desactivee' } }
            @{ Nom = 'Priorite processeur elevee pour Fortnite'; Defaut = $true
               Desc = 'Reglage Windows : a chaque lancement, Windows donne la priorite a Fortnite sur les applis en arriere-plan (moins de chutes de FPS).'
               Action = { Set-PrioriteJeu 'Fortnite' @('FortniteClient-Win64-Shipping.exe') } }
            @{ Nom = 'Carte graphique haute performance pour Fortnite'; Defaut = $true
               Desc = 'Reglage Windows (Parametres > Ecran > Graphiques) : force la carte graphique principale pour ce jeu.'
               Action = { Set-GpuJeu 'Fortnite' @(Trouver-ExeFortnite) } }
            @{ Nom = 'Vider les logs et caches web de Fortnite'; Defaut = $true
               Desc = 'Supprime des fichiers temporaires du jeu. Sans risque.'
               Action = {
                   $s = Join-Path $env:LOCALAPPDATA 'FortniteGame\Saved'
                   Clear-Folder (Join-Path $s 'Logs')
                   Get-ChildItem $s -Directory -Filter 'webcache*' -ErrorAction SilentlyContinue | ForEach-Object { Clear-Folder $_.FullName }
                   Write-Log '   Logs et caches vides.' 'Gray' } }
        )
        Conseils = @"
REGLAGES CONSEILLES DANS FORTNITE (ton PC : {CONFIG})
OptiGame ne touche pas a ces reglages : ils sont a toi, change-les librement dans le jeu.

Affichage
- Mode de rendu : DirectX 12 (beau) ou Performance (FPS max, competition).
- Limite de FPS : la frequence de ton ecran (144, 165...) ou un peu au-dessus.
- Synchro verticale : desactivee.  Flou de mouvement : desactive.
- Resolution 3D : 100 %.

Qualite (DirectX 12)
- Ombres : desactivees. Occlusion ambiante, reflets : desactives.
- Lumen et Nanite : desactives (tres gourmands).
- Effets, post-traitement : faible. Textures : moyen (haut si ta carte a 8 Go de VRAM ou plus ; la tienne : {VRAM}).
- Anti-crenelage : TSR faible ou desactive.

Pilote AMD (AMD Software > Jeux > Fortnite)
- Radeon Anti-Lag : active.  Radeon Chill : desactive.

Epic Games Launcher
- Fortnite > Options : decoche "Textures haute resolution" (libere plus de 15 Go).
"@
    }
    # ---------------------------------------------------------------
    'Rocket League' = @{
        Process = @('RocketLeague')
        Config  = { Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'My Games\Rocket League\TAGame\Config\TASystemSettings.ini' }
        Exe     = { Trouver-ExeRocketLeague }
        Video   = 'meilleurs parametres Rocket League PC FPS input lag'
        Options = @(
            @{ Nom = 'Anti-bug 2 ecrans : plein ecran sans changement de resolution'; Defaut = $false
               Desc = 'Pour les PC a 2 ecrans : le jeu passe en plein ecran fenetre a la resolution exacte de ton ecran principal. L''ecran ne se rallume plus, Windows ne bascule plus sur le 2e ecran, plus de resolution folle ni de crash en quittant le plein ecran. Change le mode d''affichage du jeu (c''est le but) : decoche pour le regler toi-meme. Si tu as coche "Desactiver les optimisations plein ecran", decoche-le.'
               Action = { Set-AntiBugRL } }
            @{ Nom = 'Une image de latence en moins (OneFrameThreadLag)'; Defaut = $true
               Desc = 'Reglage cache : l''image affichee correspond plus vite a ce que tu fais. Coute quelques FPS, sans souci avec ton processeur.'
               Action = { Set-IniCache 'Rocket League' (& $Jeux['Rocket League'].Config) 'SystemSettings' 'OneFrameThreadLag' 'False' 'Latence d''une image' } }
            @{ Nom = 'Couper les effets de distorsion caches'; Defaut = $true
               Desc = 'Reglages caches (distorsion de chaleur, flou radial des boosts) : image plus nette et un peu plus de FPS.'
               Action = {
                   $f = & $Jeux['Rocket League'].Config
                   Set-IniCache 'Rocket League' $f 'SystemSettings' 'Distortion' 'False' 'Distorsion'
                   Set-IniCache 'Rocket League' $f 'SystemSettings' 'FilteredDistortion' 'False' 'Distorsion filtree'
                   Set-IniCache 'Rocket League' $f 'SystemSettings' 'DropParticleDistortion' 'True' 'Distorsion des particules'
                   Set-IniCache 'Rocket League' $f 'SystemSettings' 'AllowRadialBlur' 'False' 'Flou radial' } }
            @{ Nom = 'Textures nettes au loin (filtrage anisotrope 16x)'; Defaut = $true
               Desc = 'Reglage cache : le terrain reste net au loin. Ne coute quasiment aucun FPS sur ta carte graphique.'
               Action = { Set-IniCache 'Rocket League' (& $Jeux['Rocket League'].Config) 'SystemSettings' 'MaxAnisotropy' '16' 'Filtrage anisotrope' } }
            @{ Nom = 'Qualite max : bords lisses (anticrenelage MSAA 8x)'; Defaut = $false
               Desc = 'Reglage cache : anticrenelage 8x, bords des voitures et du terrain sans escaliers. Coute des FPS. Seulement si ta version du jeu a ce reglage.'
               Action = { Set-IniCache 'Rocket League' (& $Jeux['Rocket League'].Config) 'SystemSettings' 'MaxMultiSamples' '8' 'Anticrenelage 8x' } }
            @{ Nom = 'Priorite processeur elevee pour Rocket League'; Defaut = $true
               Desc = 'Reglage Windows : priorite au jeu sur les applis en arriere-plan (moins de micro-saccades).'
               Action = { Set-PrioriteJeu 'Rocket League' @('RocketLeague.exe') } }
            @{ Nom = 'Carte graphique haute performance pour Rocket League'; Defaut = $true
               Desc = 'Reglage Windows (Parametres > Ecran > Graphiques) : force la carte graphique principale pour ce jeu.'
               Action = { Set-GpuJeu 'Rocket League' @(Trouver-ExeRocketLeague) } }
            @{ Nom = 'Desactiver les optimisations plein ecran de Windows'; Defaut = $false
               Desc = 'Reglage Windows (Proprietes > Compatibilite). Rocket League (DirectX 11) en profite souvent en plein ecran. Essaie, et decoche si tu ne sens rien.'
               Action = { Set-FsoJeu 'Rocket League' @(Trouver-ExeRocketLeague) } }
            @{ Nom = 'Vider les logs de Rocket League'; Defaut = $true
               Desc = 'Supprime les anciens journaux du jeu. Sans risque.'
               Action = { Clear-Folder (Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'My Games\Rocket League\TAGame\Logs'); Write-Log '   Logs vides.' 'Gray' } }
        )
        Conseils = @"
REGLAGES CONSEILLES DANS ROCKET LEAGUE (ton PC : {CONFIG})
OptiGame ne touche pas a ces reglages : change-les librement dans le jeu, ils sont sauvegardes normalement.

Video
- Mode d'affichage : Plein ecran.  Synchro verticale : desactivee.
- FPS maximum : la frequence de ton ecran ou plus (vise 240 FPS si ton PC suit).
- Qualite de rendu : Haute performance. Detail du monde : Performance.
- Particules : Performance. Shaders haute qualite : desactive.
- Flou de mouvement, profondeur de champ, bloom, ombres dynamiques, occlusion ambiante : desactives.
- Effets meteo : desactives (pluie et neige genent la vue).

Reseau (Options > Reseau, si ta connexion est stable)
- Client Send Rate : High.  Server Send Rate : High.  Bandwidth Limit : High.
- Input Buffer : STS (par defaut).

Pilote AMD
- Radeon Anti-Lag : active.  Radeon Chill : desactive.
"@
    }
    # ---------------------------------------------------------------
    'Roblox' = @{
        Process = @('RobloxPlayerBeta')
        Config  = { Join-Path $env:LOCALAPPDATA 'Roblox\GlobalBasicSettings_13.xml' }
        Exe     = { Trouver-ExeRoblox }
        Video   = 'augmenter FPS Roblox PC parametres'
        Options = @(
            @{ Nom = 'Vrai plein ecran avec Alt+Entree (moins de latence)'; Defaut = $false
               Desc = 'FastFlag officiel : Alt+Entree passe en plein ecran exclusif, plus reactif que F11. A EVITER avec 2 ecrans (changement de resolution qui fait tout buguer) : avec 2 ecrans, utilise F11.'
               Action = { Set-FlagsRoblox @{ 'FFlagHandleAltEnterFullscreenManually' = 'False' } 'Plein ecran exclusif (Alt+Entree)' } }
            @{ Nom = 'Priorite processeur elevee pour Roblox'; Defaut = $true
               Desc = 'Reglage Windows : priorite a Roblox sur les applis en arriere-plan.'
               Action = { Set-PrioriteJeu 'Roblox' @('RobloxPlayerBeta.exe') } }
            @{ Nom = 'Carte graphique haute performance pour Roblox'; Defaut = $true
               Desc = 'Reglage Windows pour RobloxPlayerBeta.exe. Roblox change de dossier a chaque mise a jour : OptiGame le refait tout seul.'
               Action = { Set-GpuJeu 'Roblox' @(Trouver-ExeRoblox) } }
            @{ Nom = 'Fermer Roblox completement quand tu le quittes'; Defaut = $true
               Desc = 'Roblox reste parfois ouvert en fond (sans fenetre) apres avoir quitte une partie. OptiGame le ferme pour liberer la memoire.'
               Action = { Write-Log '   Active : Roblox sera ferme completement quand tu quittes le jeu.' 'Gray'; Fermer-RobloxEnFond } }
            @{ Nom = 'Vider les logs et le cache de Roblox'; Defaut = $true
               Desc = 'Roblox accumule beaucoup de journaux. Sans risque.'
               Action = {
                   Clear-Folder (Join-Path $env:LOCALAPPDATA 'Roblox\logs')
                   Clear-Folder (Join-Path $env:TEMP 'Roblox')
                   Write-Log '   Logs et cache vides.' 'Gray' } }
            @{ Nom = 'Plus de FPS : couper l''anticrenelage (MSAA)'; Defaut = $false
               Desc = 'FastFlag officiel. Les bords sont un peu moins lisses, mais gros gain dans les jeux charges.'
               Action = { Set-FlagsRoblox @{ 'FIntDebugForceMSAASamples' = '1' } 'Anticrenelage coupe' } }
            @{ Nom = 'Plus de FPS : enlever l''herbe'; Defaut = $false
               Desc = 'FastFlags officiels. L''herbe animee ne s''affiche plus : utile dans les grandes maps.'
               Action = { Set-FlagsRoblox @{ 'FIntFRMMinGrassDistance' = '0'; 'FIntFRMMaxGrassDistance' = '0'; 'FIntGrassMovementReducedMotionFactor' = '0' } 'Herbe' } }
            @{ Nom = 'Image nette si Windows est zoome (125 %, 150 %)'; Defaut = $false
               Desc = 'FastFlag officiel : Roblox ignore le zoom de Windows. Interface plus petite mais plus nette.'
               Action = { Set-FlagsRoblox @{ 'DFFlagDisableDPIScale' = 'True' } 'Zoom Windows ignore' } }
            @{ Nom = 'Qualite max : bords ultra lisses (anticrenelage MSAA 8x)'; Defaut = $false
               Desc = 'FastFlag : force l''anticrenelage au maximum, plus aucun escalier sur les bords. Coute des FPS. Ne coche pas en meme temps que "couper l''anticrenelage" (c''est l''inverse).'
               Action = { Set-FlagsRoblox @{ 'FIntDebugForceMSAASamples' = '8' } 'Anticrenelage 8x' } }
            @{ Nom = 'Qualite max : textures au maximum'; Defaut = $false
               Desc = 'FastFlags : textures toujours en qualite maximale, meme quand la qualite graphique est basse. Ta carte a {VRAM} de memoire : ca passe.'
               Action = { Set-FlagsRoblox @{ 'DFFlagTextureQualityOverrideEnabled' = 'True'; 'DFIntTextureQualityOverride' = '3' } 'Textures au maximum' } }
            @{ Nom = 'Qualite max : eclairage le plus realiste (Future)'; Defaut = $false
               Desc = 'FastFlag : force l''eclairage "Future" de Roblox (ombres et lumieres calculees pixel par pixel, reflets plus realistes) : le plus proche du ray tracing sur Roblox. Si Roblox n''accepte plus ce FastFlag, il est simplement ignore.'
               Action = { Set-FlagsRoblox @{ 'FFlagDebugForceFutureIsBrightPhase3' = 'True' } 'Eclairage Future' } }
        )
        Conseils = @"
REGLAGES CONSEILLES DANS ROBLOX
OptiGame ne touche pas a ces reglages : change-les librement dans le jeu.

Dans le jeu (Echap > Parametres)
- Mode graphique : Manuel.
- Qualite graphique : 3 a 5 barres en competition, plus si tu veux du beau et que les FPS restent hauts (ta carte : {GPU}).
- Limite de FPS : 240 (ou la frequence de ton ecran).
- Plein ecran : Alt+Entree (vrai plein ecran grace a OptiGame) ou F11.

A savoir
- Installe Roblox depuis roblox.com plutot que depuis le Microsoft Store.
- Depuis 2025, Roblox n'accepte qu'une petite liste de FastFlags officiels : OptiGame n'utilise que ceux-la.
- Si tu utilises Bloxstrap ou Fishstrap, ils peuvent remplacer ces FastFlags a chaque lancement.
"@
    }
    # ---------------------------------------------------------------
    'Call of Duty BO7' = @{
        Process = @('cod', 'cod25', 'BlackOps7')
        Config  = { Join-Path $env:LOCALAPPDATA 'Activision\Call of Duty\Players' }
        Exe     = { Trouver-ExeCod }
        Video   = 'meilleurs parametres Black Ops 7 PC FPS'
        Options = @(
            @{ Nom = 'Carte graphique haute performance pour Call of Duty'; Defaut = $true
               Desc = 'Reglage Windows pour cod.exe (Battle.net, Steam ou Xbox).'
               Action = { Set-GpuJeu 'Call of Duty BO7' @(Trouver-ExeCod) } }
            @{ Nom = 'Priorite processeur elevee pour Call of Duty'; Defaut = $false
               Desc = 'Reglage Windows : priorite au jeu sur les applis en arriere-plan. Decoche par prudence (anti-triche Ricochet) : active-le seulement si tu as des chutes de FPS.'
               Action = { Set-PrioriteJeu 'Call of Duty BO7' @('cod.exe', 'cod25.exe', 'BlackOps7.exe') } }
            @{ Nom = 'Desactiver les optimisations plein ecran de Windows'; Defaut = $false
               Desc = 'Reglage Windows (Proprietes > Compatibilite). Sans effet sur la version Microsoft Store.'
               Action = { Set-FsoJeu 'Call of Duty BO7' @(Trouver-ExeCod) } }
            @{ Nom = 'Threads de rendu = nombre de coeurs du processeur'; Defaut = $false
               Desc = 'Reglage cache RendererWorkerCount. Le jeu le fait souvent deja tout seul ({COEURS} coeurs chez toi). Sur la version Microsoft Store, modifier ce fichier peut declencher une demande de mise a jour : a eviter si c''est ton cas.'
               Action = { Set-CodWorkers } }
            @{ Nom = 'Vider le cache de shaders (seulement si saccades)'; Defaut = $false
               Desc = 'Utile apres une mise a jour du pilote AMD. Au lancement suivant, le jeu recompile ses shaders pendant plusieurs minutes : laisse-le finir.'
               Action = {
                   $sc = Join-Path $env:ProgramData 'Activision\Call of Duty\shadercache'
                   if (Test-Path $sc) { Clear-Folder $sc; Write-Log '   Cache de shaders vide.' 'Gray' }
                   else { Write-Log '   Dossier de cache introuvable : rien a vider.' 'Gray' } } }
        )
        Conseils = @"
REGLAGES CONSEILLES DANS BLACK OPS 7 (ton PC : {CONFIG})
OptiGame ne touche pas a ces reglages : change-les librement dans le jeu.

Affichage
- Mode : Plein ecran exclusif.  Synchro verticale : desactivee.
- Limite de FPS personnalisee : la frequence de ton ecran.

Qualite
- Upscaling : FSR (AMD FidelityFX) en mode Qualite, ou desactive si les FPS suffisent.
- Echelle cible de VRAM : 70 a 80 %.
- Streaming de textures a la demande : Minimal (ou desactive) pour eviter les saccades.
- Ombres, occlusion ambiante, reflets : bas.
- Flou de mouvement et profondeur de champ : desactives.
- AMD Anti-Lag 2 : active s'il est propose dans le menu.

Important
- Laisse le jeu finir l'optimisation des shaders au premier lancement (barre en bas du menu).
- OptiGame ne touche jamais aux fichiers du jeu (anti-triche Ricochet).
"@
    }
    # ---------------------------------------------------------------
    'Palworld' = @{
        Process = @('Palworld-Win64-Shipping', 'Palworld-WinGDK-Shipping')
        Config  = { Dossier-ConfigPalworld }
        Exe     = { Trouver-ExePalworld }
        Video   = 'Palworld meilleurs parametres PC FPS saccades AMD'
        Options = @(
            @{ Nom = 'Anti-bug 2 ecrans : plein ecran sans changement de resolution'; Defaut = $false
               Desc = 'Pour les PC a 2 ecrans : le jeu passe en plein ecran fenetre a la resolution exacte de ton ecran principal. L''ecran ne se rallume plus, Windows ne bascule plus sur le 2e ecran, plus de resolution folle ni de crash en quittant le plein ecran. Change le mode d''affichage du jeu (c''est le but) : decoche pour le regler toi-meme.'
               Action = { Set-AntiBugUE 'Palworld' (Join-Path (Dossier-ConfigPalworld) 'GameUserSettings.ini') } }
            @{ Nom = 'Moins de freezes : memoire des textures adaptee a ta carte graphique'; Defaut = $true
               Desc = 'Reglage cache : "streaming" des textures selon ta VRAM (ta carte : {VRAM}). Reduit les freezes en se deplacant et les crashs "World Streaming".'
               Action = { Set-PalworldStreaming } }
            @{ Nom = 'Chargement en arriere-plan sans a-coups'; Defaut = $true
               Desc = 'Reglage cache : le jeu charge le monde sur un fil separe au lieu de bloquer l''image.'
               Action = {
                   $f = Fichier-EnginePalworld
                   if (-not $f) { return }
                   Set-IniJeu 'Palworld' $f '/Script/Engine.StreamingSettings' 's.AsyncLoadingThreadEnabled' 'True' 'Chargement asynchrone' } }
            @{ Nom = 'Moins de micro-saccades (cache des shaders)'; Defaut = $true
               Desc = 'Reglage cache : garde en memoire les shaders deja compiles pour ne pas les recompiler en pleine partie.'
               Action = {
                   $f = Fichier-EnginePalworld
                   if (-not $f) { return }
                   Set-IniJeu 'Palworld' $f 'SystemSettings' 'r.ShaderPipelineCache.Enabled' '1' 'Cache des shaders'
                   Set-IniJeu 'Palworld' $f 'SystemSettings' 'r.ShaderPipelineCache.ReportPSO' '1' 'Enregistrement des shaders' } }
            @{ Nom = 'Couper profondeur de champ et aberration chromatique'; Defaut = $true
               Desc = 'Reglages caches (absents du menu de Palworld) : image plus nette, un peu plus de FPS.'
               Action = {
                   $f = Fichier-EnginePalworld
                   if (-not $f) { return }
                   Set-IniJeu 'Palworld' $f 'SystemSettings' 'r.DepthOfFieldQuality' '0' 'Profondeur de champ'
                   Set-IniJeu 'Palworld' $f 'SystemSettings' 'r.SceneColorFringeQuality' '0' 'Aberration chromatique' } }
            @{ Nom = 'Qualite max : bords lisses et image accentuee'; Defaut = $false
               Desc = 'Reglages caches : lissage temporel en haute qualite (bords plus lisses), accentuation de l''image (contours plus traces) et textures nettes au loin (filtrage 16x). Coute quelques FPS.'
               Action = {
                   $f = Fichier-EnginePalworld
                   if (-not $f) { return }
                   Set-IniJeu 'Palworld' $f 'SystemSettings' 'r.TemporalAA.Quality' '2' 'Lissage temporel haute qualite'
                   Set-IniJeu 'Palworld' $f 'SystemSettings' 'r.TSR.History.ScreenPercentage' '200' 'Lissage TSR haute qualite'
                   Set-IniJeu 'Palworld' $f 'SystemSettings' 'r.Tonemapper.Sharpen' '0.8' 'Accentuation de l''image'
                   Set-IniJeu 'Palworld' $f 'SystemSettings' 'r.MaxAnisotropy' '16' 'Filtrage anisotrope 16x' } }
            @{ Nom = 'Priorite processeur elevee pour Palworld'; Defaut = $true
               Desc = 'Reglage Windows : priorite au jeu sur les applis en arriere-plan (Palworld utilise beaucoup le processeur).'
               Action = { Set-PrioriteJeu 'Palworld' @('Palworld-Win64-Shipping.exe', 'Palworld-WinGDK-Shipping.exe') } }
            @{ Nom = 'Carte graphique haute performance pour Palworld'; Defaut = $true
               Desc = 'Reglage Windows (Parametres > Ecran > Graphiques) : force la carte graphique principale pour ce jeu.'
               Action = { Set-GpuJeu 'Palworld' @(Trouver-ExePalworld) } }
            @{ Nom = 'Vider les logs et rapports de crash de Palworld'; Defaut = $true
               Desc = 'Supprime les journaux du jeu. Ne touche JAMAIS a tes sauvegardes (dossier SaveGames).'
               Action = {
                   $s = Join-Path $env:LOCALAPPDATA 'Pal\Saved'
                   Clear-Folder (Join-Path $s 'Logs')
                   Clear-Folder (Join-Path $s 'Crashes')
                   Write-Log '   Logs et rapports de crash vides (sauvegardes intactes).' 'Gray' } }
        )
        Conseils = @"
REGLAGES CONSEILLES DANS PALWORLD (ton PC : {CONFIG})
OptiGame ne touche pas a ces reglages : change-les librement dans le jeu.

Graphismes
- Mode d'affichage : Plein ecran.  Synchro verticale : desactivee.
- Limite de FPS : la frequence de ton ecran.
- Upscaling : AMD FSR en mode Qualite (gros gain, image quasi identique).
- Distance d'affichage : Moyenne. Ombres : Moyennes (tres gourmandes).
- Herbe / vegetation : Bas ou Moyen (grosse source de chute de FPS).
- Effets, post-traitement : Bas. Textures : Haut si ta carte a 8 Go de VRAM ou plus, sinon Moyen (la tienne : {VRAM}).
- Flou de mouvement : desactive.

Moins de freezes
- Installe le jeu sur ton SSD NVMe (pas sur un disque dur).
- Les bases avec beaucoup de Pals et de constructions font chuter les FPS : c'est le jeu, pas ton PC.
- En multijoueur, un ping eleve donne des saccades : joue en cable Ethernet.

Pilote AMD
- Radeon Anti-Lag : active.  Radeon Chill : desactive.

Important : OptiGame ne touche jamais a tes sauvegardes (SaveGames).
"@
    }
    # ---------------------------------------------------------------
    'Valorant' = @{
        Process = @('VALORANT-Win64-Shipping')
        Config  = { Join-Path $env:LOCALAPPDATA 'VALORANT\Saved\Config' }
        Exe     = { Trouver-ExeJeu 'Valorant' @() @('Riot Games\VALORANT\live\ShooterGame\Binaries\Win64\VALORANT-Win64-Shipping.exe') }
        Video   = 'meilleurs parametres Valorant PC FPS input lag'
        Options = @(
            @{ Nom = 'Anti-bug 2 ecrans : plein ecran sans changement de resolution'; Defaut = $false
               Desc = 'Pour les PC a 2 ecrans : Valorant passe en plein ecran fenetre a la resolution de ton ecran principal. Plus d''ecran qui se coupe ni de bascule sur le 2e ecran. Change le mode d''affichage du jeu (c''est le but).'
               Action = { Set-AntiBugValorant } }
            @{ Nom = 'Priorite processeur elevee pour Valorant'; Defaut = $false
               Desc = 'Reglage Windows : a chaque lancement, Windows donne plus de temps processeur au jeu qu''aux applis en arriere-plan (moins de chutes de FPS). Decoche par prudence avec l''anti-triche Vanguard : active-le si tu as des chutes de FPS.'
               Action = { Set-PrioriteJeu 'Valorant' @('VALORANT-Win64-Shipping.exe') } }
            @{ Nom = 'Carte graphique haute performance pour Valorant'; Defaut = $true
               Desc = 'Reglage Windows (Parametres > Ecran > Graphiques) : force la carte graphique principale pour ce jeu.'
               Action = { Set-GpuJeu 'Valorant' @(& $Jeux['Valorant'].Exe) } }
            @{ Nom = 'Desactiver les optimisations plein ecran de Windows'; Defaut = $false
               Desc = 'Reglage Windows (Proprietes > Compatibilite). Peut reduire la latence en plein ecran exclusif. Si tu ne sens pas de difference, laisse decoche.'
               Action = { Set-FsoJeu 'Valorant' @(& $Jeux['Valorant'].Exe) } }
            @{ Nom = 'Vider les logs de Valorant'; Defaut = $true
               Desc = 'Supprime les journaux et rapports de crash du jeu. Sans risque.'
               Action = { $s = Join-Path $env:LOCALAPPDATA 'VALORANT\Saved'; Clear-Folder (Join-Path $s 'Logs'); Clear-Folder (Join-Path $s 'Crashes'); Write-Log '   Logs et rapports de crash vides.' 'Gray' } }
        )
        Conseils = @"
REGLAGES CONSEILLES DANS VALORANT (ton PC : {CONFIG})
OptiGame ne touche pas a ces reglages : ils sont a toi.

General
- Mode d'affichage : Plein ecran.  Limite de FPS : desactivee (ou 2x la frequence de ton ecran).
- NVIDIA Reflex / AMD Anti-Lag : active (Activer + Boost si propose).

Qualite graphique
- Rendu multithread : active.  Qualite des materiaux, textures, details : Faible ou Moyen.
- Qualite de l'interface : Faible.  Vignette, flou, distorsion, ombres : desactives.
- Anti-crenelage : MSAA 2x (ou aucun).  Filtrage anisotrope : 4x.
- Ameliorer la clarte : active si ta carte graphique suit.

Pilote AMD
- Radeon Anti-Lag : active.  Radeon Chill : desactive.
"@
    }
    # ---------------------------------------------------------------
    'League of Legends' = @{
        Process = @('League of Legends')
        Config  = { $null }
        Exe     = { Trouver-ExeJeu 'League of Legends' @() @('Riot Games\League of Legends\Game\League of Legends.exe') }
        Video   = 'meilleurs parametres League of Legends PC FPS'
        Options = @(
            @{ Nom = 'Priorite processeur elevee pour League of Legends'; Defaut = $true
               Desc = 'Reglage Windows : a chaque lancement, Windows donne plus de temps processeur au jeu qu''aux applis en arriere-plan (moins de chutes de FPS).'
               Action = { Set-PrioriteJeu 'League of Legends' @('League of Legends.exe') } }
            @{ Nom = 'Carte graphique haute performance pour League of Legends'; Defaut = $true
               Desc = 'Reglage Windows (Parametres > Ecran > Graphiques) : force la carte graphique principale pour ce jeu.'
               Action = { Set-GpuJeu 'League of Legends' @(& $Jeux['League of Legends'].Exe) } }
            @{ Nom = 'Desactiver les optimisations plein ecran de Windows'; Defaut = $false
               Desc = 'Reglage Windows (Proprietes > Compatibilite). Peut reduire la latence en plein ecran exclusif. Si tu ne sens pas de difference, laisse decoche.'
               Action = { Set-FsoJeu 'League of Legends' @(& $Jeux['League of Legends'].Exe) } }
            @{ Nom = 'Vider les logs de League of Legends'; Defaut = $true
               Desc = 'Supprime les journaux et rapports de crash du jeu. Sans risque.'
               Action = { foreach ($d in @(Get-PSDrive -PSProvider FileSystem -ErrorAction SilentlyContinue)) { Clear-Folder (Join-Path $d.Root 'Riot Games\League of Legends\Logs') }; Write-Log '   Logs vides.' 'Gray' } }
        )
        Conseils = @"
REGLAGES CONSEILLES DANS LEAGUE OF LEGENDS (ton PC : {CONFIG})
OptiGame ne touche pas a ces reglages : ils sont a toi.

Video
- Mode : Plein ecran.  Synchro verticale : desactivee.
- Limite d'images : la frequence de ton ecran ou plus (240 si ton ecran suit).
- Personnages, effets, environnement : Moyen a Tres eleve (LoL est leger pour ton PC).
- Ombres : desactivees (plus de lisibilite).  Anti-crenelage : au choix.

Interface
- Afficher les FPS : Ctrl + F en partie pour verifier.
"@
    }
    # ---------------------------------------------------------------
    'Counter-Strike 2' = @{
        Process = @('cs2')
        Config  = { $null }
        Exe     = { Trouver-ExeJeu 'Counter-Strike 2' @('Counter-Strike Global Offensive\game\bin\win64\cs2.exe') @() }
        Video   = 'meilleurs parametres CS2 PC FPS'
        Options = @(
            @{ Nom = 'Priorite processeur elevee pour Counter-Strike 2'; Defaut = $true
               Desc = 'Reglage Windows : a chaque lancement, Windows donne plus de temps processeur au jeu qu''aux applis en arriere-plan (moins de chutes de FPS).'
               Action = { Set-PrioriteJeu 'Counter-Strike 2' @('cs2.exe') } }
            @{ Nom = 'Carte graphique haute performance pour Counter-Strike 2'; Defaut = $true
               Desc = 'Reglage Windows (Parametres > Ecran > Graphiques) : force la carte graphique principale pour ce jeu.'
               Action = { Set-GpuJeu 'Counter-Strike 2' @(& $Jeux['Counter-Strike 2'].Exe) } }
            @{ Nom = 'Desactiver les optimisations plein ecran de Windows'; Defaut = $false
               Desc = 'Reglage Windows (Proprietes > Compatibilite). Peut reduire la latence en plein ecran exclusif. Si tu ne sens pas de difference, laisse decoche.'
               Action = { Set-FsoJeu 'Counter-Strike 2' @(& $Jeux['Counter-Strike 2'].Exe) } }
            @{ Nom = 'Vider le cache de shaders de CS2 (seulement si saccades)'; Defaut = $false
               Desc = 'Utile apres une mise a jour du pilote graphique ou si le jeu saccade. Au lancement suivant, CS2 recompile ses shaders.'
               Action = { foreach ($l in Get-BibliothequesSteam) { Clear-Folder (Join-Path $l 'steamapps\shadercache\730') }; Clear-Folder (Join-Path $env:LOCALAPPDATA 'D3DSCache'); Write-Log '   Cache de shaders vide.' 'Gray' } }
        )
        Conseils = @"
REGLAGES CONSEILLES DANS COUNTER-STRIKE 2 (ton PC : {CONFIG})
OptiGame ne touche pas a ces reglages : ils sont a toi.

Video
- Mode d'affichage : Plein ecran.  Synchro verticale : desactivee.
- NVIDIA Reflex : active + Boost (ou AMD Anti-Lag dans le pilote).
- Limite de FPS : 0 (illimite) ou au moins 2x la frequence de ton ecran.

Video avancee
- Ombres : Moyen (necessaires pour voir les ennemis).  Details des modeles/textures : Moyen.
- Effets d'ombrage / particules : Faible.  Occlusion ambiante : desactivee.
- Anti-crenelage : MSAA 4x (bonne lisibilite) ou 2x si tu manques de FPS.
- FidelityFX Super Resolution : desactive (sauf si tu manques de FPS).
"@
    }
    # ---------------------------------------------------------------
    'Minecraft' = @{
        Process = @('Minecraft.Windows', 'javaw')
        Config  = { Join-Path $env:APPDATA '.minecraft' }
        Exe     = { Trouver-ExeMinecraft }
        Video   = 'meilleurs parametres Minecraft PC FPS Sodium'
        Options = @(
            @{ Nom = 'Plus de memoire pour Minecraft Java (RAM allouee)'; Defaut = $true
               Desc = 'Reglage du launcher Minecraft : par defaut le jeu n''a que 2 Go de RAM, ce qui donne des saccades. OptiGame lui donne une quantite adaptee a ta RAM (4 Go avec 16 Go). Ferme le launcher Minecraft avant d''appliquer.'
               Action = { Set-RamMinecraft } }
            @{ Nom = 'Carte graphique haute performance pour Minecraft'; Defaut = $true
               Desc = 'Reglage Windows (Parametres > Ecran > Graphiques) : force la carte graphique principale pour ce jeu.'
               Action = { Set-GpuJeu 'Minecraft' @(& $Jeux['Minecraft'].Exe) } }
            @{ Nom = 'Priorite processeur elevee pour Java (Minecraft)'; Defaut = $false
               Desc = 'Reglage Windows pour javaw.exe. Attention : ca touche aussi les autres programmes Java. Decoche par defaut.'
               Action = { Set-PrioriteJeu 'Minecraft' @('javaw.exe') } }
            @{ Nom = 'Vider les logs de Minecraft'; Defaut = $true
               Desc = 'Supprime les journaux et rapports de crash. Ne touche JAMAIS a tes mondes (dossier saves).'
               Action = { Clear-Folder (Join-Path $env:APPDATA '.minecraft\logs'); Clear-Folder (Join-Path $env:APPDATA '.minecraft\crash-reports'); Write-Log '   Logs et rapports de crash vides (mondes intacts).' 'Gray' } }
        )
        Conseils = @"
REGLAGES CONSEILLES DANS MINECRAFT (ton PC : {CONFIG})
OptiGame ne touche pas a ces reglages : ils sont a toi.

Options > Parametres video
- Distance d'affichage : 12 a 16 chunks.  Distance de simulation : 8 a 10.
- Graphismes : Rapides.  Nuages : Rapides ou desactives.  Lissage : Desactive.
- Synchronisation verticale : desactivee.  FPS max : Illimite ou frequence de ton ecran.
- Particules : Reduites.

Le plus gros gain (Java)
- Installe le mod Sodium (via Fabric ou Modrinth) : souvent 2 a 3 fois plus de FPS.
- Le bouton Plus de memoire d'OptiGame regle la RAM allouee dans le launcher.
"@
    }
    # ---------------------------------------------------------------
    'GTA V' = @{
        Process = @('GTA5', 'GTA5_Enhanced')
        Config  = { Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'Rockstar Games\GTA V' }
        Exe     = { Trouver-ExeJeu 'GTA V' @('Grand Theft Auto V\GTA5.exe', 'Grand Theft Auto V Enhanced\GTA5_Enhanced.exe') @('Program Files\Rockstar Games\Grand Theft Auto V\GTA5.exe', 'Program Files\Rockstar Games\Grand Theft Auto V Enhanced\GTA5_Enhanced.exe', 'Program Files\Epic Games\GTAV\GTA5.exe') }
        Video   = 'meilleurs parametres GTA 5 PC FPS'
        Options = @(
            @{ Nom = 'Priorite processeur elevee pour GTA V'; Defaut = $true
               Desc = 'Reglage Windows : a chaque lancement, Windows donne plus de temps processeur au jeu qu''aux applis en arriere-plan (moins de chutes de FPS).'
               Action = { Set-PrioriteJeu 'GTA V' @('GTA5.exe', 'GTA5_Enhanced.exe') } }
            @{ Nom = 'Carte graphique haute performance pour GTA V'; Defaut = $true
               Desc = 'Reglage Windows (Parametres > Ecran > Graphiques) : force la carte graphique principale pour ce jeu.'
               Action = { Set-GpuJeu 'GTA V' @(& $Jeux['GTA V'].Exe) } }
            @{ Nom = 'Desactiver les optimisations plein ecran de Windows'; Defaut = $false
               Desc = 'Reglage Windows (Proprietes > Compatibilite). Peut reduire la latence en plein ecran exclusif. Si tu ne sens pas de difference, laisse decoche.'
               Action = { Set-FsoJeu 'GTA V' @(& $Jeux['GTA V'].Exe) } }
            @{ Nom = 'Vider le cache de shaders DirectX (seulement si saccades)'; Defaut = $false
               Desc = 'Utile apres une mise a jour du pilote graphique. Au lancement suivant, le jeu recompile ses shaders (chargement un peu plus long une fois).'
               Action = { Clear-Folder (Join-Path $env:LOCALAPPDATA 'D3DSCache'); Write-Log '   Cache de shaders DirectX vide.' 'Gray' } }
        )
        Conseils = @"
REGLAGES CONSEILLES DANS GTA V (ton PC : {CONFIG})
OptiGame ne touche pas a ces reglages : ils sont a toi.

Graphismes
- DirectX : 11 (version classique) / DirectX 12 (Enhanced).  Synchro verticale : desactivee.
- Qualite des textures : Elevee (Tres elevee si ta carte a 8 Go ou plus).
- Ombres : Elevees.  Herbe : Elevee (Tres elevee coute tres cher).
- MSAA : desactive ou 2x.  FXAA : active.
- Post-traitement : Eleve.  Flou de mouvement et profondeur de champ : desactives.

Graphismes avances
- Tout laisser par defaut : ce sont les reglages les plus gourmands.
"@
    }
    # ---------------------------------------------------------------
    'Apex Legends' = @{
        Process = @('r5apex', 'r5apex_dx12')
        Config  = { Join-Path $env:USERPROFILE 'Saved Games\Respawn\Apex\local' }
        Exe     = { Trouver-ExeJeu 'Apex Legends' @('Apex Legends\r5apex.exe', 'Apex Legends\r5apex_dx12.exe') @('Program Files\EA Games\Apex\r5apex.exe', 'Program Files\EA Games\Apex\r5apex_dx12.exe') }
        Video   = 'meilleurs parametres Apex Legends PC FPS'
        Options = @(
            @{ Nom = 'Priorite processeur elevee pour Apex Legends'; Defaut = $true
               Desc = 'Reglage Windows : a chaque lancement, Windows donne plus de temps processeur au jeu qu''aux applis en arriere-plan (moins de chutes de FPS).'
               Action = { Set-PrioriteJeu 'Apex Legends' @('r5apex.exe', 'r5apex_dx12.exe') } }
            @{ Nom = 'Carte graphique haute performance pour Apex Legends'; Defaut = $true
               Desc = 'Reglage Windows (Parametres > Ecran > Graphiques) : force la carte graphique principale pour ce jeu.'
               Action = { Set-GpuJeu 'Apex Legends' @(& $Jeux['Apex Legends'].Exe) } }
            @{ Nom = 'Desactiver les optimisations plein ecran de Windows'; Defaut = $false
               Desc = 'Reglage Windows (Proprietes > Compatibilite). Peut reduire la latence en plein ecran exclusif. Si tu ne sens pas de difference, laisse decoche.'
               Action = { Set-FsoJeu 'Apex Legends' @(& $Jeux['Apex Legends'].Exe) } }
            @{ Nom = 'Vider le cache de shaders DirectX (seulement si saccades)'; Defaut = $false
               Desc = 'Utile apres une mise a jour du pilote graphique. Au lancement suivant, le jeu recompile ses shaders (chargement un peu plus long une fois).'
               Action = { Clear-Folder (Join-Path $env:LOCALAPPDATA 'D3DSCache'); Write-Log '   Cache de shaders DirectX vide.' 'Gray' } }
        )
        Conseils = @"
REGLAGES CONSEILLES DANS APEX LEGENDS (ton PC : {CONFIG})
OptiGame ne touche pas a ces reglages : ils sont a toi.

Video
- Mode d'affichage : Plein ecran.  Synchro verticale : desactivee.
- NVIDIA Reflex : active + Boost (ou AMD Anti-Lag dans le pilote).
- Echelle de resolution adaptative : desactivee.  Anti-crenelage : TSAA.
- Budget de streaming des textures : selon ta VRAM (Eleve pour 8 Go).
- Ombres (soleil, spots) : Faible ou desactivees.  Occlusion ambiante : desactivee.
- Detail des modeles : Eleve.  Effets : Faible.  Marques d'impact : desactivees.
"@
    }
    # ---------------------------------------------------------------
    'EA Sports FC' = @{
        Process = @('FC24', 'FC25', 'FC26')
        Config  = { $null }
        Exe     = { Trouver-ExeJeu 'EA Sports FC' @('EA SPORTS FC 26\FC26.exe', 'EA SPORTS FC 25\FC25.exe', 'EA SPORTS FC 24\FC24.exe') @('Program Files\EA Games\EA SPORTS FC 26\FC26.exe', 'Program Files\EA Games\EA SPORTS FC 25\FC25.exe', 'Program Files\EA Games\EA SPORTS FC 24\FC24.exe') }
        Video   = 'meilleurs parametres EA FC PC FPS'
        Options = @(
            @{ Nom = 'Priorite processeur elevee pour EA Sports FC'; Defaut = $false
               Desc = 'Reglage Windows : a chaque lancement, Windows donne plus de temps processeur au jeu qu''aux applis en arriere-plan (moins de chutes de FPS). Decoche par prudence avec l''anti-triche EA : active-le si tu as des chutes de FPS.'
               Action = { Set-PrioriteJeu 'EA Sports FC' @('FC26.exe', 'FC25.exe', 'FC24.exe') } }
            @{ Nom = 'Carte graphique haute performance pour EA Sports FC'; Defaut = $true
               Desc = 'Reglage Windows (Parametres > Ecran > Graphiques) : force la carte graphique principale pour ce jeu.'
               Action = { Set-GpuJeu 'EA Sports FC' @(& $Jeux['EA Sports FC'].Exe) } }
            @{ Nom = 'Desactiver les optimisations plein ecran de Windows'; Defaut = $false
               Desc = 'Reglage Windows (Proprietes > Compatibilite). Peut reduire la latence en plein ecran exclusif. Si tu ne sens pas de difference, laisse decoche.'
               Action = { Set-FsoJeu 'EA Sports FC' @(& $Jeux['EA Sports FC'].Exe) } }
            @{ Nom = 'Vider le cache de shaders DirectX (seulement si saccades)'; Defaut = $false
               Desc = 'Utile apres une mise a jour du pilote graphique. Au lancement suivant, le jeu recompile ses shaders (chargement un peu plus long une fois).'
               Action = { Clear-Folder (Join-Path $env:LOCALAPPDATA 'D3DSCache'); Write-Log '   Cache de shaders DirectX vide.' 'Gray' } }
        )
        Conseils = @"
REGLAGES CONSEILLES DANS EA SPORTS FC (ton PC : {CONFIG})
OptiGame ne touche pas a ces reglages : ils sont a toi.

Affichage (lanceur du jeu ou menu Parametres > Affichage)
- Mode : Plein ecran.  Synchro verticale : desactivee.
- Frequence : celle de ton ecran.  Images par seconde : 60 en match (le jeu est cale dessus).
- Qualite du rendu : Elevee.  Qualite de la foule : Moyenne.
- Flou de mouvement : desactive.  Anti-crenelage : TAA.
"@
    }
}

# =====================================================================
#  COULEURS ET POLICES
# =====================================================================
$cBg     = [Drawing.Color]::FromArgb(24, 24, 27)
$cPanel  = [Drawing.Color]::FromArgb(32, 32, 36)
$cBtn    = [Drawing.Color]::FromArgb(45, 45, 50)
$cText   = [Drawing.Color]::FromArgb(230, 230, 230)
$cMuted  = [Drawing.Color]::FromArgb(150, 150, 155)
$cAccent = [Drawing.Color]::FromArgb(0, 200, 83)
$cRed    = [Drawing.Color]::FromArgb(200, 60, 60)

$fontTitre = New-Object Drawing.Font('Segoe UI', 18, [Drawing.FontStyle]::Bold)
$fontTab   = New-Object Drawing.Font('Segoe UI', 10, [Drawing.FontStyle]::Bold)
$fontBtn   = New-Object Drawing.Font('Segoe UI', 10)
$fontBig   = New-Object Drawing.Font('Segoe UI', 13, [Drawing.FontStyle]::Bold)
$fontTxt   = New-Object Drawing.Font('Segoe UI', 9.5)
$fontLog   = New-Object Drawing.Font('Consolas', 9.5)

$script:ActionButtons = @()
$script:Busy = $false

# =====================================================================
#  OUTILS
# =====================================================================
# (Write-Log : defini dans l'interface v2)

function Run-Ext([string]$exe, [string]$arguments, [switch]$Visible) {
    $ws = if ($Visible) { 'Normal' } else { 'Hidden' }
    $p = Start-Process -FilePath $exe -ArgumentList $arguments -WindowStyle $ws -PassThru
    $null = $p.Handle
    while (-not $p.HasExited) {
        Pump-Ui
        Start-Sleep -Milliseconds 150
    }
    return $p.ExitCode
}

# =====================================================================
#  JOURNAL DES CHANGEMENTS (onglet Informations > Ce qui a change)
# =====================================================================
$DossierData    = Join-Path $env:ProgramData 'OptiGame'
$JournalFichier = Join-Path $DossierData 'changements.json'
$script:Journaliser = $true
$script:DejaNote = @{}
$script:Journal = New-Object System.Collections.ArrayList
$Fleche = [string][char]0x2192

# Nom lisible et valeurs lisibles des reglages suivis
$Libelles = @{
    'AutoGameModeEnabled'    = @{ N = 'Mode Jeu';                       D = 'Par defaut (active)'; V = @{ '0' = 'Desactive'; '1' = 'Active' } ; E = 'Windows donne la priorite au jeu au premier plan (moins de taches de fond pendant que tu joues).' }
    'HwSchMode'              = @{ N = 'Planification GPU (HAGS)';       D = 'Par defaut';          V = @{ '1' = 'Desactivee'; '2' = 'Activee' } ; E = 'La carte graphique gere elle-meme sa file de travail : un peu moins de latence et de charge processeur.' }
    'GameDVR_Enabled'        = @{ N = 'Game DVR (capture en fond)';     D = 'Par defaut (active)'; V = @{ '0' = 'Desactive'; '1' = 'Active' } ; E = 'Windows n''enregistre plus en permanence les dernieres minutes de jeu en arriere-plan : plus de FPS.' }
    'HiberbootEnabled'       = @{ N = 'Demarrage rapide';               D = 'Par defaut (active)'; V = @{ '0' = 'Desactive'; '1' = 'Active' } ; E = 'Le demarrage rapide garde Windows a moitie en veille : le couper evite des bugs de pilotes au demarrage.' }
    'GlobalUserDisabled'     = @{ N = 'Applis en arriere-plan';         D = 'Autorisees';          V = @{ '0' = 'Autorisees'; '1' = 'Bloquees' } ; E = 'Les applis du Microsoft Store tournent ou non en arriere-plan.' }
    'EnableTransparency'     = @{ N = 'Transparence Windows';           D = 'Activee';             V = @{ '0' = 'Desactivee'; '1' = 'Activee' } ; E = 'Effet de transparence des menus Windows : le couper soulage un peu la carte graphique.' }
    'MinAnimate'             = @{ N = 'Animations des fenetres';        D = 'Activees';            V = @{ '0' = 'Desactivees'; '1' = 'Activees' } ; E = 'Animations a l''ouverture / reduction des fenetres : les couper rend Windows plus reactif.' }
    'SystemResponsiveness'   = @{ N = 'CPU reserve aux taches de fond'; D = '20 % (defaut)';       S = ' %' ; E = 'Part du processeur gardee pour les taches de fond pendant un jeu : plus bas = plus pour le jeu.' }
    'Priority'               = @{ N = 'Priorite CPU des jeux';          D = '2 (defaut)';          S = ' / 8' ; E = 'Priorite donnee aux jeux par le planificateur multimedia de Windows.' }
    'Scheduling Category'    = @{ N = 'Categorie de priorite des jeux'; D = 'Moyenne (defaut)';    V = @{ 'High' = 'Haute'; 'Medium' = 'Moyenne' } ; E = 'Categorie de priorite des jeux dans le planificateur multimedia de Windows.' }
    'NetworkThrottlingIndex' = @{ N = 'Limitation reseau Windows';      D = 'Active (defaut)';     V = @{ '-1' = 'Desactivee'; '4294967295' = 'Desactivee' }; S = ' (active)' ; E = 'Windows ne limite plus le reseau pendant le son et la video : ping plus stable.' }
    'TcpAckFrequency'        = @{ N = 'Latence TCP (Nagle)';            D = 'Normale (defaut)';    V = @{ '1' = 'Reduite' } ; E = 'Les accuses de reception reseau partent tout de suite au lieu d''etre groupes : moins de latence.' }
    'DODownloadMode'         = @{ N = 'Partage des mises a jour (P2P)'; D = 'Active (defaut)';     V = @{ '0' = 'Desactive' } ; E = 'Windows n''envoie plus tes mises a jour a d''autres PC sur Internet : connexion liberee.' }
    'PowerThrottlingOff'     = @{ N = 'Bridage des applis (economie)';  D = 'Actif (defaut)';      V = @{ '1' = 'Desactive'; '0' = 'Actif' } ; E = 'Windows ne bride plus le processeur des applis pour economiser de l''energie.' }
}

function Charger-Journal {
    $script:Journal.Clear()
    if (Test-Path $JournalFichier) {
        try { foreach ($e in (Get-Content $JournalFichier -Raw | ConvertFrom-Json)) { if ("$($e.Element)" -ne 'Memoire utilisee') { [void]$script:Journal.Add($e) } } } catch {}
    }
}

function Sauver-Journal {
    New-Item -ItemType Directory -Path $DossierData -Force | Out-Null
    while ($script:Journal.Count -gt 300) { $script:Journal.RemoveAt(0) }
    ConvertTo-Json -InputObject @($script:Journal.ToArray()) -Depth 4 | Out-File -FilePath $JournalFichier -Encoding UTF8
}

# Bouton ou action d'OptiGame a l'origine des changements en cours (affiche dans Ce qui a change)
$script:SourceAction = $null
$NomsActions = @{
    'Optimisation complete' = 'Bouton Tout optimiser (Accueil ou Optimisation)'
    'Optimisation des performances' = 'Bouton Optimiser les performances (page Optimisation)'
    'Optimisation de la connexion' = 'Bouton Optimiser la connexion (page Optimisation)'
    'Annulation des optimisations' = 'Bouton Annuler les optimisations (page Optimisation)'
    'Mode Boost' = 'Bouton Mode Boost'
    'Nettoyage' = 'Bouton Nettoyage'
    'Reparation de la connexion' = 'Bouton Reparer la connexion (page Optimisation)'
    'Reparation de Windows' = 'Bouton Reparation de Windows (page Optimisation)'
    'Reparation de la recherche Windows' = 'Bouton Reparer la recherche Windows'
    'Renforcement de l''antivirus' = 'Bouton Renforcer la protection (page Antivirus)'
}
function Nom-Source([string]$titre) {
    if (-not $titre) { return '' }
    if ($NomsActions.ContainsKey($titre)) { return $NomsActions[$titre] }
    if ($titre -match '^Optimisation (.+)$' -and $Jeux.Contains($Matches[1])) { return "Bouton Appliquer les options cochees (page Jeux > $($Matches[1]))" }
    if ($titre -match "^Retour aux reglages d'origine : (.+)$") { return "Bouton Remettre comme avant (page Jeux > $($Matches[1]))" }
    return $titre
}
function Explication-Journal([string]$element) {
    switch -Regex ($element) {
        ' : carte graphique' { return 'Windows utilise ta carte graphique principale (la plus puissante) pour ce jeu (Parametres > Ecran > Graphiques).' }
        ' : priorite processeur' { return 'A chaque lancement du jeu, Windows lui donne plus de temps processeur qu''aux applis en arriere-plan.' }
        ' : optimisations plein ecran' { return 'Option de compatibilite Windows du jeu (Proprietes > Compatibilite).' }
        '^Roblox : ' { return 'FastFlag officiel de Roblox (fichier ClientAppSettings.json, recree a chaque mise a jour de Roblox).' }
        ' : resolution$|Mode d.affichage|Largeur|Hauteur' { return 'Affichage du jeu : resolution de ton ecran en plein ecran fenetre (anti-bug 2 ecrans).' }
        '^Antivirus' { return 'Reglage de Microsoft Defender, l''antivirus integre a Windows.' }
        '^Timer Resolution' { return 'Windows applique la precision de timer demandee par OptiGame a tous les programmes, jeux compris (apres un redemarrage).' }
        '^Lancement au demarrage' { return 'OptiGame s''ouvre tout seul quand tu allumes le PC.' }
        '^Plan d.alimentation|^Alimentation' { return 'Le processeur reste a pleine vitesse au lieu de ralentir pour economiser.' }
        '^(Frequence RAM|Quantite de RAM|Processeur|Carte graphique|Pilote carte graphique|Version du BIOS|Version de Windows|Isolation du noyau|Frequence ecran)$' { return 'Changement detecte sur ton PC depuis la derniere ouverture d''OptiGame (pas fait par OptiGame).' }
        '^(Fortnite|Rocket League|Palworld|Call of Duty BO7|BO7|Valorant|League of Legends|Counter-Strike 2|Minecraft|GTA V|Apex Legends|EA Sports FC) : ' { return 'Reglage cache du fichier de configuration du jeu (absent du menu du jeu).' }
    }
    return ''
}

function Ajouter-Journal([string]$element, [string]$avant, [string]$apres, [string]$explication) {
    if (-not $script:Journaliser) { return }
    if ($avant -eq $apres) { return }
    $src = if ($script:SourceAction) { Nom-Source $script:SourceAction } else { 'Automatique (OptiGame)' }
    # Pas de doublon : meme changement, meme resultat, juste apres le precedent
    if ($script:Journal.Count) {
        $der = $script:Journal[$script:Journal.Count - 1]
        if ("$($der.Element)" -eq $element -and "$($der.Apres)" -eq $apres) { return }
    }
    if (-not $explication) { $explication = Explication-Journal $element }
    [void]$script:Journal.Add([pscustomobject]@{
        Date = (Get-Date).ToString('dd/MM/yyyy HH:mm'); Element = $element; Avant = $avant; Apres = $apres; Source = $src; Explication = $explication })
    Sauver-Journal
}

function Lire-Reg([string]$path, [string]$name) {
    if (Test-Path $path) {
        $k = Get-Item -Path $path -ErrorAction SilentlyContinue
        if ($k -and ($k.GetValueNames() -contains $name)) { return $k.GetValue($name) }
    }
    return $null
}

function Format-Reg([string]$name, $v) {
    $l = $Libelles[$name]
    if (-not $l) { return "$v" }
    if ($null -eq $v) { return $l.D }
    $s = "$v"
    if ($l.V -and $l.V.ContainsKey($s)) { return $l.V[$s] }
    if ($l.S) { return "$s$($l.S)" }
    return $s
}

function Noter-Reg([string]$name, $avant, $apres) {
    if (-not $script:Journaliser) { return }
    $l = $Libelles[$name]
    if (-not $l) { return }
    if ($script:DejaNote.ContainsKey($l.N)) { return }
    $a = Format-Reg $name $avant
    $b = Format-Reg $name $apres
    if ($a -eq $b) { return }
    $script:DejaNote[$l.N] = $true
    Ajouter-Journal $l.N $a $b $l.E
}

function Set-Reg([string]$path, [string]$name, $value, [string]$type = 'DWord') {
    $avant = $null
    if ($script:Journaliser) { $avant = Lire-Reg $path $name }
    if (-not (Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
    New-ItemProperty -Path $path -Name $name -Value $value -PropertyType $type -Force | Out-Null
    Noter-Reg $name $avant $value
}

function Remove-Reg([string]$path, [string]$name) {
    $avant = $null
    if ($script:Journaliser) { $avant = Lire-Reg $path $name }
    Remove-ItemProperty -Path $path -Name $name -ErrorAction SilentlyContinue
    if ($null -ne $avant) { Noter-Reg $name $avant $null }
}

function Get-PlanNom {
    try {
        $p = Get-CimInstance -Namespace 'root\cimv2\power' -ClassName Win32_PowerPlan -ErrorAction Stop |
            Where-Object { $_.IsActive } | Select-Object -First 1
        if ($p) { return $p.ElementName }
    } catch {}
    $o = powercfg.exe /getactivescheme | Out-String
    if ($o -match '\(([^)]+)\)\s*$') { return $Matches[1].Trim() }
    return 'Inconnu'
}

function Set-PlanAlim([string]$guid) {
    $avant = Get-PlanNom
    powercfg.exe -setactive $guid 2>$null | Out-Null
    if ($LASTEXITCODE -ne 0) {
        # Plan absent (frequent sur Windows 11) : on cree une copie nommee OptiGame
        $g = $null
        $liste = powercfg.exe /list | Out-String
        if ($liste -match ($RegexGuid + '\s+\(OptiGame Performances\)')) { $g = $Matches[1] }
        if (-not $g) { $g = Nouveau-Plan $guid 'OptiGame Performances' }
        if ($g) { powercfg.exe -setactive $g | Out-Null }
    }
    Ajouter-Journal "Plan d'alimentation" $avant (Get-PlanNom)
}

# ---------- Carte Ethernet : economie d'energie ----------
function Est-WiFi($n) {
    return ($n.MediaType -eq 'Native 802.11' -or "$($n.PhysicalMediaType)" -match '802\.11' -or
            "$($n.InterfaceDescription)" -match 'Wi-?Fi|Wireless|WLAN|802\.11')
}

function Etape-EthernetEco {
    $f = Join-Path $DossierData 'ethernet_avant.json'
    $mots = @('*EEE', 'AdvancedEEE', 'EnableGreenEthernet', 'GigaLite', 'PowerSavingMode')
    $sauv = New-Object System.Collections.ArrayList
    if (Test-Path $f) { try { foreach ($x in (Get-Content $f -Raw | ConvertFrom-Json)) { [void]$sauv.Add($x) } } catch {} }
    $touches = @()
    foreach ($a in @(Get-NetAdapter -Physical -ErrorAction SilentlyContinue | Where-Object { -not (Est-WiFi $_) })) {
        $props = @(Get-NetAdapterAdvancedProperty -Name $a.Name -ErrorAction SilentlyContinue | Where-Object { $mots -contains $_.RegistryKeyword })
        foreach ($p in $props) {
            $val = "$($p.RegistryValue)"
            if ($val -eq '0') { continue }
            $deja = $sauv | Where-Object { $_.Adapter -eq $a.Name -and $_.Key -eq $p.RegistryKeyword }
            if (-not $deja) { [void]$sauv.Add([pscustomobject]@{ Adapter = $a.Name; Key = $p.RegistryKeyword; Val = $val }) }
            $avant = $p.DisplayValue
            $p | Set-NetAdapterAdvancedProperty -RegistryValue '0' -NoRestart -ErrorAction SilentlyContinue
            $apres = (Get-NetAdapterAdvancedProperty -Name $a.Name -ErrorAction SilentlyContinue | Where-Object { $_.RegistryKeyword -eq $p.RegistryKeyword }).DisplayValue
            Ajouter-Journal "Ethernet : $($p.DisplayName)" "$avant" "$apres"
            if ($touches -notcontains $a.Name) { $touches += $a.Name }
        }
    }
    if ($touches.Count -eq 0) { Write-Log '   Rien a changer (deja desactive ou carte sans ce reglage).' 'Gray'; return }
    New-Item -ItemType Directory -Path $DossierData -Force | Out-Null
    ConvertTo-Json -InputObject @($sauv.ToArray()) | Out-File -FilePath $f -Encoding UTF8
    foreach ($n in $touches) { Restart-NetAdapter -Name $n -Confirm:$false -ErrorAction SilentlyContinue }
    Write-Log "   Desactive sur : $($touches -join ', ')" 'Gray'
}

function Restaurer-Ethernet {
    $f = Join-Path $DossierData 'ethernet_avant.json'
    if (-not (Test-Path $f)) { return }
    Write-Log 'Reglages d''origine de la carte Ethernet...'
    $touches = @()
    try {
        foreach ($x in (Get-Content $f -Raw | ConvertFrom-Json)) {
            $p = Get-NetAdapterAdvancedProperty -Name $x.Adapter -ErrorAction SilentlyContinue |
                Where-Object { $_.RegistryKeyword -eq $x.Key } | Select-Object -First 1
            if (-not $p) { continue }
            $avant = $p.DisplayValue
            $p | Set-NetAdapterAdvancedProperty -RegistryValue $x.Val -NoRestart -ErrorAction SilentlyContinue
            $apres = (Get-NetAdapterAdvancedProperty -Name $x.Adapter -ErrorAction SilentlyContinue | Where-Object { $_.RegistryKeyword -eq $x.Key }).DisplayValue
            Ajouter-Journal "Ethernet : $($p.DisplayName)" "$avant" "$apres"
            if ($touches -notcontains $x.Adapter) { $touches += $x.Adapter }
        }
    } catch {}
    Remove-Item $f -Force -ErrorAction SilentlyContinue
    foreach ($n in $touches) { Restart-NetAdapter -Name $n -Confirm:$false -ErrorAction SilentlyContinue }
}


function Clear-Folder([string]$path) {
    if (Test-Path $path) {
        Get-ChildItem -Path $path -Force -ErrorAction SilentlyContinue |
            Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
    }
    Pump-Ui
}

# (Ask-YesNo : defini dans l'interface v2)

function Ask-Reboot {
    if (Ask-YesNo "Un redemarrage est necessaire pour tout appliquer.`r`n`r`nRedemarrer maintenant ?") {
        shutdown.exe /r /t 10 /c "Redemarrage OptiGame dans 10 secondes"
    }
}

# (Update-BtnJeu : defini dans l'interface v2)

# (Set-Busy : defini dans l'interface v2)

# (Invoke-Action : defini dans l'interface v2)

# =====================================================================
#  ETAPES D'OPTIMISATION
# =====================================================================
function Etape-PointRestauration([switch]$Force) {
    Enable-ComputerRestore -Drive 'C:\' -ErrorAction SilentlyContinue

    if (-not $Force) {
        Write-Log 'Point de restauration (seulement s''il n''y en a pas de moins de 7 jours)...'
        $recent = Get-ComputerRestorePoint -ErrorAction SilentlyContinue | Where-Object {
            $_.Description -like '*OptiGame*' -and
            [Management.ManagementDateTimeConverter]::ToDateTime($_.CreationTime) -gt (Get-Date).AddDays(-7)
        }
        if ($recent) {
            Write-Log '   Point OptiGame de moins de 7 jours trouve : pas de nouveau point.' 'Gray'
            return
        }
    } else {
        Write-Log 'Point de restauration (toujours cree en mode TOUT FAIRE)...'
    }

    # Windows bloque normalement plus d'un point par 24 h : on leve la limite le temps de la creation
    $srKey = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore'
    $ancienne = (Get-ItemProperty -Path $srKey -Name 'SystemRestorePointCreationFrequency' -ErrorAction SilentlyContinue).SystemRestorePointCreationFrequency
    Set-Reg $srKey 'SystemRestorePointCreationFrequency' 0

    Write-Log '   Creation en cours (peut prendre une minute)...' 'Gray'
    try {
        Checkpoint-Computer -Description "Avant OptiGame Complet $(Get-Date -Format 'dd/MM/yyyy HH:mm')" -RestorePointType MODIFY_SETTINGS -ErrorAction Stop
        Write-Log '   Nouveau point de restauration cree.' 'Gray'
    }
    catch {
        Write-Log "   Impossible de creer le point : $($_.Exception.Message)" 'Tomato'
    }
    finally {
        if ($null -ne $ancienne) { Set-Reg $srKey 'SystemRestorePointCreationFrequency' $ancienne }
        else { Remove-Reg $srKey 'SystemRestorePointCreationFrequency' }
    }
}

function Etape-Performance {
    Write-Log '[1/8] Plan d''alimentation Performances elevees...'
    Set-PlanAlim '8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c'
    Run-Ext 'powercfg.exe' '-change -standby-timeout-ac 0' | Out-Null

    Write-Log '[2/8] Mode Jeu + planification GPU (HAGS)...'
    Set-Reg 'HKCU:\Software\Microsoft\GameBar' 'AutoGameModeEnabled' 1
    Set-Reg 'HKCU:\Software\Microsoft\GameBar' 'AllowAutoGameMode' 1
    Set-Reg 'HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers' 'HwSchMode' 2

    Write-Log '[3/8] Desactivation Game DVR (capture en arriere-plan)...'
    Set-Reg 'HKCU:\System\GameConfigStore' 'GameDVR_Enabled' 0
    Set-Reg 'HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR' 'AppCaptureEnabled' 0

    Write-Log '[4/8] Desactivation du demarrage rapide...'
    Set-Reg 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power' 'HiberbootEnabled' 0

    Write-Log '[5/8] Applis en arriere-plan laissees actives (la recherche Windows et les jeux du Store en ont besoin)...'
    Remove-Reg 'HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications' 'GlobalUserDisabled'

    Write-Log '[6/8] Effets visuels alleges (transparence, animations)...'
    Set-Reg 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize' 'EnableTransparency' 0
    Set-Reg 'HKCU:\Control Panel\Desktop\WindowMetrics' 'MinAnimate' '0' 'String'

    Write-Log '[7/8] Priorite CPU/GPU donnee aux jeux...'
    $sp = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile'
    Set-Reg $sp 'SystemResponsiveness' 10
    Set-Reg "$sp\Tasks\Games" 'GPU Priority' 8
    Set-Reg "$sp\Tasks\Games" 'Priority' 6
    Set-Reg "$sp\Tasks\Games" 'Scheduling Category' 'High' 'String'

    Write-Log '[8/8] Optimisation SSD (TRIM)...'
    Run-Ext 'defrag.exe' 'C: /L' | Out-Null
}

function Etape-Connexion {
    $sp = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile'

    Write-Log '[1/6] Vidage du cache DNS...'
    Run-Ext 'ipconfig.exe' '/flushdns' | Out-Null

    Write-Log '[2/6] Suppression de la limitation reseau de Windows...'
    Set-Reg $sp 'NetworkThrottlingIndex' -1

    Write-Log '[3/6] Reduction de la latence TCP (Nagle desactive)...'
    Get-ChildItem 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces' -ErrorAction SilentlyContinue |
        ForEach-Object {
            Set-Reg $_.PSPath 'TcpAckFrequency' 1
            Set-Reg $_.PSPath 'TCPNoDelay' 1
        }

    Write-Log '[4/6] Reglage TCP automatique (autotuning normal)...'
    Run-Ext 'netsh.exe' 'int tcp set global autotuninglevel=normal' | Out-Null

    Write-Log '[5/6] Arret du partage des mises a jour avec d''autres PC...'
    Set-Reg 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization' 'DODownloadMode' 0

    Write-Log '[6/6] Economie d''energie de la carte Ethernet (coupure de 2-3 s)...'
    Etape-EthernetEco
}

function Etape-ReparerConnexion {
    Write-Log '[1/4] Reinitialisation Winsock...'
    Run-Ext 'netsh.exe' 'winsock reset' | Out-Null
    Write-Log '[2/4] Reinitialisation de la pile IP...'
    Run-Ext 'netsh.exe' 'int ip reset' | Out-Null
    Write-Log '[3/4] Renouvellement de l''adresse IP (coupure de quelques secondes)...'
    Run-Ext 'ipconfig.exe' '/release' | Out-Null
    Run-Ext 'ipconfig.exe' '/renew' | Out-Null
    Write-Log '[4/4] Vidage du cache DNS...'
    Run-Ext 'ipconfig.exe' '/flushdns' | Out-Null
}

function Etape-Nettoyage {
    $libreAvant = [double](Get-PSDrive C).Free
    Write-Log '[1/3] Fichiers temporaires et caches shaders (AMD + NVIDIA)...'
    Clear-Folder $env:TEMP
    Clear-Folder 'C:\Windows\Temp'
    Clear-Folder "$env:LOCALAPPDATA\D3DSCache"
    Clear-Folder "$env:LOCALAPPDATA\AMD\DxCache"
    Clear-Folder "$env:LOCALAPPDATA\AMD\DxcCache"
    Clear-Folder "$env:LOCALAPPDATA\NVIDIA\DXCache"
    Clear-Folder "$env:LOCALAPPDATA\NVIDIA\GLCache"

    Write-Log '[2/3] Vidage de la corbeille...'
    Clear-RecycleBin -Force -ErrorAction SilentlyContinue

    Write-Log '[3/3] Cache Windows Update...'
    Stop-Service wuauserv -Force -ErrorAction SilentlyContinue
    Clear-Folder 'C:\Windows\SoftwareDistribution\Download'
    Start-Service wuauserv -ErrorAction SilentlyContinue

    $libreApres = [double](Get-PSDrive C).Free
    Write-Log ('   Espace libere : {0:N2} Go' -f ([math]::Max(0, $libreApres - $libreAvant) / 1GB)) 'Gold'
    Ajouter-Journal 'Espace libre sur C:' ('{0:N1} Go' -f ($libreAvant / 1GB)) ('{0:N1} Go' -f ($libreApres / 1GB))
}

function Etape-Reparation {
    Write-Log 'Les fenetres noires qui s''ouvrent sont normales : ne les ferme pas.' 'Gold'
    Write-Log '[1/3] Reparation de l''image Windows (DISM) - 5 a 20 min...'
    $c = Run-Ext 'DISM.exe' '/Online /Cleanup-Image /RestoreHealth' -Visible
    Write-Log "   DISM termine (code $c)." 'Gray'
    Write-Log '[2/3] Verification des fichiers systeme (SFC) - 5 a 15 min...'
    $c = Run-Ext 'sfc.exe' '/scannow' -Visible
    Write-Log "   SFC termine (code $c)." 'Gray'
    Write-Log '[3/3] Verification du disque C: (lecture seule)...'
    $c = Run-Ext 'chkdsk.exe' 'C: /scan' -Visible
    Write-Log "   CHKDSK termine (code $c)." 'Gray'
}

function Etape-Diagnostic {
    $rapport = Join-Path ([Environment]::GetFolderPath('Desktop')) 'Rapport_PC.txt'
    $sections = [ordered]@{
        'Sante des disques' = {
            Get-PhysicalDisk | Select-Object FriendlyName, MediaType, HealthStatus, OperationalStatus | Format-List }
        'Espace libre' = {
            Get-PSDrive -PSProvider FileSystem | Select-Object Name,
                @{n='Libre_Go';e={[math]::Round($_.Free/1GB,1)}},
                @{n='Utilise_Go';e={[math]::Round($_.Used/1GB,1)}} | Format-Table }
        'RAM (si ConfiguredClockSpeed < Speed : active le XMP/EXPO dans le BIOS)' = {
            Get-CimInstance Win32_PhysicalMemory | Select-Object Manufacturer,
                @{n='Go';e={$_.Capacity/1GB}}, Speed, ConfiguredClockSpeed | Format-Table }
        'Carte graphique et pilote' = {
            Get-CimInstance Win32_VideoController | Select-Object Name, DriverVersion, DriverDate | Format-List }
        'Latence internet (ping 1.1.1.1)' = {
            $p = Test-Connection 1.1.1.1 -Count 4 -ErrorAction SilentlyContinue
            if ($p) { 'Moyenne : {0} ms (min {1} / max {2})' -f
                [math]::Round(($p | Measure-Object ResponseTime -Average).Average),
                ($p | Measure-Object ResponseTime -Minimum).Minimum,
                ($p | Measure-Object ResponseTime -Maximum).Maximum }
            else { 'Pas de reponse (connexion coupee ou ping bloque).' } }
        'Temps depuis le dernier demarrage' = {
            $u = (Get-Date) - (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
            '{0} jours {1} h' -f $u.Days, $u.Hours }
        'Programmes au demarrage' = {
            Get-CimInstance Win32_StartupCommand | Select-Object Name, Location | Format-Table -AutoSize }
        'Top 10 processus par RAM' = {
            Get-Process | Sort-Object WorkingSet -Descending | Select-Object -First 10 Name,
                @{n='RAM_Mo';e={[math]::Round($_.WorkingSet/1MB)}} | Format-Table }
        '15 dernieres erreurs critiques / crashs (7 derniers jours)' = {
            Get-WinEvent -FilterHashtable @{LogName='System';Level=1,2;StartTime=(Get-Date).AddDays(-7)} -MaxEvents 15 -ErrorAction SilentlyContinue |
                Select-Object TimeCreated, ProviderName, Message | Format-List }
    }

    $texte = "===== RAPPORT PC - $(Get-Date) =====`r`n"
    $i = 0
    foreach ($titre in $sections.Keys) {
        $i++
        Write-Log "[$i/$($sections.Count)] $titre..."
        $contenu = try { (& $sections[$titre]) | Out-String -Width 250 } catch { "Erreur : $($_.Exception.Message)" }
        $texte += "`r`n--- $titre ---`r`n$contenu"
    }
    $texte | Out-File -FilePath $rapport -Encoding UTF8
    Write-Log "Rapport enregistre sur le Bureau : Rapport_PC.txt" 'Gold'
    Start-Process notepad.exe $rapport
}

function Etape-Boost {
    Write-Log 'Fermeture des applications en arriere-plan...'
    'OneDrive','Teams','ms-teams','Skype','Widgets','YourPhone','PhoneExperienceHost' | ForEach-Object {
        Get-Process -Name $_ -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    }
    Run-Ext 'ipconfig.exe' '/flushdns' | Out-Null
    Write-Log 'Mode Boost applique. Lance ton jeu !' 'Gold'
}

function Etape-Restaurer {
    Write-Log 'Retour aux reglages par defaut...'
    Set-PlanAlim '381b4222-f694-41f0-9685-ff5bb260df2e'
    Set-Reg 'HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers' 'HwSchMode' 1
    Set-Reg 'HKCU:\System\GameConfigStore' 'GameDVR_Enabled' 1
    Set-Reg 'HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR' 'AppCaptureEnabled' 1
    Set-Reg 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power' 'HiberbootEnabled' 1
    Set-Reg 'HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications' 'GlobalUserDisabled' 0
    Set-Reg 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize' 'EnableTransparency' 1
    Set-Reg 'HKCU:\Control Panel\Desktop\WindowMetrics' 'MinAnimate' '1' 'String'

    Write-Log 'Reglages de priorite et reseau...'
    $sp = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile'
    Set-Reg $sp 'SystemResponsiveness' 20
    Set-Reg $sp 'NetworkThrottlingIndex' 10
    Set-Reg "$sp\Tasks\Games" 'Priority' 2
    Set-Reg "$sp\Tasks\Games" 'Scheduling Category' 'Medium' 'String'
    Get-ChildItem 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces' -ErrorAction SilentlyContinue |
        ForEach-Object {
            Remove-Reg $_.PSPath 'TcpAckFrequency'
            Remove-Reg $_.PSPath 'TCPNoDelay'
        }
    Remove-Reg 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization' 'DODownloadMode'

    Write-Log 'Reglages avances (plan OptiGame, bridage)...'
    Remove-Reg 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling' 'PowerThrottlingOff'
    $plans = powercfg.exe /list | Out-String
    foreach ($mt in [regex]::Matches($plans, $RegexGuid + '\s+\(OptiGame')) {
        powercfg.exe -delete $mt.Groups[1].Value | Out-Null
    }
    Restaurer-Ethernet
}

# =====================================================================
#  TEST DE PERFORMANCE (onglet Test)
#  Mesure -> applique une optimisation -> mesure -> remet comme avant
#  L'etat est sauvegarde sur disque pour continuer apres un redemarrage.
# =====================================================================
$DossierData     = Join-Path $env:ProgramData 'OptiGame'
$EtatFichier     = Join-Path $DossierData 'test_etat.json'
$ResultatFichier = Join-Path $DossierData 'dernier_test.json'
$NomTache        = 'OptiGame_Test'
$RegexGuid       = '([0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12})'
$script:Etat        = $null
$script:TestEnCours = $false
$script:StopDemande = $false

# Reglages testes dans le lot "Performances (standard)" (memes valeurs que Etape-Performance)
$TweaksPerf = @(
    @{ path = 'HKCU:\Software\Microsoft\GameBar'; name = 'AutoGameModeEnabled'; value = 1; type = 'DWord' }
    @{ path = 'HKCU:\Software\Microsoft\GameBar'; name = 'AllowAutoGameMode'; value = 1; type = 'DWord' }
    @{ path = 'HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers'; name = 'HwSchMode'; value = 2; type = 'DWord' }
    @{ path = 'HKCU:\System\GameConfigStore'; name = 'GameDVR_Enabled'; value = 0; type = 'DWord' }
    @{ path = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR'; name = 'AppCaptureEnabled'; value = 0; type = 'DWord' }
    @{ path = 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power'; name = 'HiberbootEnabled'; value = 0; type = 'DWord' }
    @{ path = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize'; name = 'EnableTransparency'; value = 0; type = 'DWord' }
    @{ path = 'HKCU:\Control Panel\Desktop\WindowMetrics'; name = 'MinAnimate'; value = '0'; type = 'String' }
    @{ path = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile'; name = 'SystemResponsiveness'; value = 10; type = 'DWord' }
    @{ path = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games'; name = 'GPU Priority'; value = 8; type = 'DWord' }
    @{ path = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games'; name = 'Priority'; value = 6; type = 'DWord' }
    @{ path = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games'; name = 'Scheduling Category'; value = 'High'; type = 'String' }
)

# Mesures : Plus = $true si "plus grand = mieux". Seuil = ecart minimum (en %) pour compter.
$Metriques = [ordered]@{
    CpuMono   = @{ Nom = 'Processeur (1 coeur)';         Unite = 'M op/s'; Plus = $true;  Seuil = 3 }
    CpuMulti  = @{ Nom = 'Processeur (tous les coeurs)'; Unite = 'M op/s'; Plus = $true;  Seuil = 3 }
    Memoire   = @{ Nom = 'Memoire (debit)';              Unite = 'Go/s';   Plus = $true;  Seuil = 4 }
    Latence   = @{ Nom = 'Reactivite Windows (moyenne)'; Unite = 'us';     Plus = $false; Seuil = 8 }
    Latence99 = @{ Nom = 'Reactivite Windows (pics)';    Unite = 'us';     Plus = $false; Seuil = 12 }
    CpuLibre  = @{ Nom = 'Processeur libre au repos';    Unite = '%';      Plus = $true;  Seuil = 1.5 }
    RamLibre  = @{ Nom = 'RAM libre au repos';           Unite = 'Go';     Plus = $true;  Seuil = 3 }
    Processus = @{ Nom = 'Processus actifs';             Unite = '';       Plus = $false; Seuil = 5 }
}

# Lots d'optimisations testes. Alternative = lot essaye si l'effet est trop faible.
$Lots = @{
    'boost' = @{
        Nom = 'Mode Boost'; Reboot = $false; Alternative = $null
        Metriques = @('CpuLibre', 'RamLibre', 'Processus', 'Latence99')
        Apply = { Etape-Boost }
        Permanent = $null
        Conseil = 'Pas de reglage permanent : lance le Mode Boost (onglet 1) juste avant de jouer.'
    }
    'perf' = @{
        Nom = 'Performances (standard)'; Reboot = $true; Alternative = 'perf2'
        Metriques = @('CpuMono', 'CpuMulti', 'Memoire', 'Latence', 'Latence99', 'CpuLibre')
        Apply = {
            Write-Log '   Plan Performances elevees, Mode Jeu, HAGS, Game DVR, effets visuels, priorite jeux...' 'Gray'
            Snap-PlanAlim '8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c'
            foreach ($t in $TweaksPerf) { Snap-Reg @t }
        }
        Permanent = { Etape-Performance }
        Conseil = 'Applique les reglages de "Optimiser les performances".'
    }
    'perf2' = @{
        Nom = 'Performances (avance)'; Reboot = $true; Alternative = $null
        Metriques = @('CpuMono', 'CpuMulti', 'Memoire', 'Latence', 'Latence99', 'CpuLibre')
        Apply = {
            Write-Log '   Plan OptiGame Ultime (processeur toujours a fond, coeurs jamais endormis), bridage off...' 'Gray'
            Snap-PlanAlim 'e9a42b02-d5df-448d-aa00-03f14749eb61' -Avance
            Snap-Reg -path 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling' -name 'PowerThrottlingOff' -value 1
        }
        Permanent = { Etape-PerfAvancee }
        Conseil = 'Plan d''alimentation OptiGame Ultime + bridage des applis desactive. Consomme plus.'
    }
}

$CodeBench = @'
using System;
using System.Diagnostics;
using System.Threading;

public static class OGBench
{
    public static double Sink;

    static double Work(long n)
    {
        double x = 0;
        for (long i = 1; i < n; i++) { x += Math.Sqrt(i) * (i & 7) / (1 + (i % 13)); }
        return x;
    }

    public static double CpuMono(int ms)
    {
        Sink += Work(200000);
        var sw = Stopwatch.StartNew(); long iters = 0; double s = 0;
        while (sw.ElapsedMilliseconds < ms) { s += Work(200000); iters += 200000; }
        sw.Stop(); Sink += s;
        return iters / sw.Elapsed.TotalSeconds / 1e6;
    }

    public static double CpuMulti(int ms)
    {
        int n = Environment.ProcessorCount; long total = 0;
        var threads = new Thread[n];
        var sw = Stopwatch.StartNew();
        for (int t = 0; t < n; t++)
        {
            threads[t] = new Thread(() => {
                long local = 0; double s = 0;
                while (sw.ElapsedMilliseconds < ms) { s += Work(200000); local += 200000; }
                Interlocked.Add(ref total, local);
                if (s == 42) Sink = s;
            });
            threads[t].IsBackground = true;
            threads[t].Start();
        }
        foreach (var th in threads) th.Join();
        sw.Stop();
        return total / sw.Elapsed.TotalSeconds / 1e6;
    }

    public static double Memory(int mb, int reps)
    {
        var a = new byte[mb * 1024 * 1024]; var b = new byte[a.Length];
        for (int i = 0; i < a.Length; i += 4096) { a[i] = 1; b[i] = 1; }
        Buffer.BlockCopy(a, 0, b, 0, a.Length);
        var sw = Stopwatch.StartNew();
        for (int r = 0; r < reps; r++) Buffer.BlockCopy(a, 0, b, 0, a.Length);
        sw.Stop();
        return (double)a.Length * reps / sw.Elapsed.TotalSeconds / 1e9;
    }

    public static double[] WakeLatency(int samples)
    {
        var ev = new AutoResetEvent(false);
        var done = new AutoResetEvent(false);
        var lat = new double[samples];
        long t0 = 0;
        var th = new Thread(() => {
            for (int i = 0; i < samples; i++)
            {
                ev.WaitOne();
                long t1 = Stopwatch.GetTimestamp();
                lat[i] = (t1 - Interlocked.Read(ref t0)) * 1e6 / Stopwatch.Frequency;
                done.Set();
            }
        });
        th.IsBackground = true; th.Start();
        var rnd = new Random(1);
        for (int i = 0; i < samples; i++)
        {
            Thread.Sleep(1 + rnd.Next(3));
            Interlocked.Exchange(ref t0, Stopwatch.GetTimestamp());
            ev.Set();
            done.WaitOne(1000);
        }
        Array.Sort(lat);
        double avg = 0; foreach (var v in lat) avg += v; avg /= samples;
        int idx = Math.Min(samples - 1, (int)(samples * 0.99));
        return new double[] { avg, lat[idx] };
    }
}
'@

# ---------- Outils du test ----------
function Check-Stop {
    if ($script:StopDemande -or ($script:Prog -and $script:Prog.Stop)) {
        if ($script:Prog) { $script:Prog.Stop = $false }
        throw 'ARRET_TEST'
    }
}

function Pause-Ui([int]$ms) {
    $fin = (Get-Date).AddMilliseconds($ms)
    while ((Get-Date) -lt $fin) { Check-Stop; Pump-Ui; Start-Sleep -Milliseconds 100 }
}

# (Wait-Ui : defini dans l'interface v2)

# (Set-Phase : defini dans l'interface v2)

function Save-Etat {
    New-Item -ItemType Directory -Path $DossierData -Force | Out-Null
    $script:Etat | ConvertTo-Json -Depth 8 | Out-File -FilePath $EtatFichier -Encoding UTF8
}

function Load-Etat {
    if (-not (Test-Path $EtatFichier)) { return $false }
    try { $script:Etat = Get-Content $EtatFichier -Raw | ConvertFrom-Json; return $true }
    catch { Remove-Item $EtatFichier -Force -ErrorAction SilentlyContinue; return $false }
}

function Liste([object]$x) { return ,@($x | Where-Object { $null -ne $_ }) }

function Enregistrer-Tache {
    $u = "$env:USERDOMAIN\$env:USERNAME"
    $act = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$script:CheminScript`" -Reprise"
    $trg = New-ScheduledTaskTrigger -AtLogOn -User $u
    $trg.Delay = 'PT20S'
    $prn = New-ScheduledTaskPrincipal -UserId $u -LogonType Interactive -RunLevel Highest
    $set = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -ExecutionTimeLimit ([TimeSpan]::Zero)
    Register-ScheduledTask -TaskName $NomTache -Action $act -Trigger $trg -Principal $prn -Settings $set -Force | Out-Null
}

function Supprimer-Tache { Unregister-ScheduledTask -TaskName $NomTache -Confirm:$false -ErrorAction SilentlyContinue }

# ---------- Sauvegarde / retour des reglages ----------
function Snap-Reg([string]$path, [string]$name, $value, [string]$type = 'DWord') {
    $existe = $false; $ancien = $null; $genre = $null
    if (Test-Path $path) {
        $k = Get-Item -Path $path
        if ($k.GetValueNames() -contains $name) {
            $existe = $true; $ancien = $k.GetValue($name); $genre = $k.GetValueKind($name).ToString()
        }
    }
    $script:Etat.Snapshot = (Liste $script:Etat.Snapshot) + [pscustomobject]@{ T = 'reg'; Path = $path; Name = $name; Existed = $existe; Old = $ancien; Kind = $genre }
    Set-Reg $path $name $value $type
}

function Get-PlanActif {
    $o = powercfg.exe /getactivescheme | Out-String
    if ($o -match $RegexGuid) { return $Matches[1] }
    return $null
}

function Nouveau-Plan([string]$modele, [string]$nom) {
    $o = powercfg.exe -duplicatescheme $modele 2>$null | Out-String
    if ($o -match $RegexGuid) {
        $g = $Matches[1]
        if ($nom) { powercfg.exe -changename $g $nom | Out-Null }
        return $g
    }
    return $null
}

function Regler-PlanAvance([string]$g) {
    powercfg.exe -setacvalueindex $g SUB_PROCESSOR PROCTHROTTLEMIN 100 | Out-Null
    powercfg.exe -setacvalueindex $g SUB_PROCESSOR CPMINCORES 100 | Out-Null
}

function Snap-PlanAlim([string]$modele, [switch]$Avance) {
    $ancien = Get-PlanActif
    $cree = $null
    if ($Avance) {
        $cree = Nouveau-Plan $modele 'OptiGame Ultime'
        if (-not $cree) { $cree = Nouveau-Plan '8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c' 'OptiGame Ultime' }
        if (-not $cree) { Write-Log '   Plan avance indisponible sur ce PC.' 'Tomato'; return }
        Regler-PlanAvance $cree
        powercfg.exe -setactive $cree | Out-Null
    } else {
        powercfg.exe -setactive $modele 2>$null | Out-Null
        if ($LASTEXITCODE -ne 0) {
            $cree = Nouveau-Plan $modele 'OptiGame Performances'
            if ($cree) { powercfg.exe -setactive $cree | Out-Null }
        }
    }
    $script:Etat.Snapshot = (Liste $script:Etat.Snapshot) + [pscustomobject]@{ T = 'power'; Old = $ancien; Created = $cree }
}

function Revert-Snapshot {
    $s = Liste $script:Etat.Snapshot
    if ($s.Count -eq 0) { return }
    Write-Log '   Retour des reglages comme avant...' 'Gray'
    [array]::Reverse($s)
    foreach ($x in $s) {
        if ($x.T -eq 'reg') {
            if ($x.Existed) { Set-Reg $x.Path $x.Name $x.Old $x.Kind } else { Remove-Reg $x.Path $x.Name }
        }
        elseif ($x.T -eq 'power') {
            if ($x.Old) { powercfg.exe -setactive $x.Old | Out-Null }
            if ($x.Created) { powercfg.exe -delete $x.Created | Out-Null }
        }
    }
    $script:Etat.Snapshot = @()
}

# ---------- Optimisation permanente "avancee" ----------
function Etape-PerfAvancee {
    Write-Log '[1/2] Plan d''alimentation OptiGame Ultime...'
    $g = $null
    $liste = powercfg.exe /list | Out-String
    if ($liste -match ($RegexGuid + '\s+\(OptiGame Ultime\)')) { $g = $Matches[1] }
    if (-not $g) { $g = Nouveau-Plan 'e9a42b02-d5df-448d-aa00-03f14749eb61' 'OptiGame Ultime' }
    if (-not $g) { $g = Nouveau-Plan '8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c' 'OptiGame Ultime' }
    if ($g) { Regler-PlanAvance $g; Set-PlanAlim $g }
    else { Write-Log '   Impossible de creer le plan sur ce PC.' 'Tomato' }
    Write-Log '[2/2] Desactivation du bridage des applis (Power Throttling)...'
    Set-Reg 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling' 'PowerThrottlingOff' 1
}

# ---------- Mesures ----------
function Init-Bench {
    Charger-Type 'OGBench' $CodeBench
}

function Mesurer-Passage {
    $r = [ordered]@{}
    $cpu = @()
    for ($i = 0; $i -lt 6; $i++) {
        $cpu += [double](Get-CimInstance Win32_PerfFormattedData_PerfOS_Processor -Filter "Name='_Total'").PercentProcessorTime
        Pause-Ui 1000
    }
    $r.CpuLibre = 100 - ($cpu | Measure-Object -Average).Average
    $os = Get-CimInstance Win32_OperatingSystem
    $r.RamLibre = $os.FreePhysicalMemory / 1MB
    $r.Processus = @(Get-Process).Count
    Check-Stop
    $l = [OGBench]::WakeLatency(200); $r.Latence = $l[0]; $r.Latence99 = $l[1]
    Pause-Ui 300
    $r.Memoire = [OGBench]::Memory(256, 6); [GC]::Collect()
    Pause-Ui 300
    $r.CpuMono = [OGBench]::CpuMono(2500)
    Pause-Ui 300
    $r.CpuMulti = [OGBench]::CpuMulti(2500)
    return $r
}

function Mesurer-Complet {
    Init-Bench
    $passes = @()
    for ($p = 1; $p -le 3; $p++) {
        Write-Log "   Passage $p/3..." 'Gray'
        $passes += , (Mesurer-Passage)
        Pause-Ui 2000
    }
    $med = [ordered]@{}; $bruit = [ordered]@{}
    foreach ($k in $Metriques.Keys) {
        $v = @($passes | ForEach-Object { [double]$_[$k] } | Sort-Object)
        $m = $v[1]
        $med[$k] = [math]::Round($m, 2)
        $bruit[$k] = if ($m -ne 0) { [math]::Round(($v[-1] - $v[0]) / [math]::Abs($m) * 100, 1) } else { 0 }
    }
    return @{ Med = $med; Bruit = $bruit }
}

function Comparer([string]$id, $mesure) {
    $lot = $Lots[$id]
    $gains = [ordered]@{}; $valeurs = [ordered]@{}
    $pos = 0; $neg = 0; $meilleur = $null
    foreach ($k in $Metriques.Keys) {
        $b = [double]$script:Etat.Base.$k
        $n = [double]$mesure.Med[$k]
        $valeurs[$k] = $n
        if ($b -eq 0) { $gains[$k] = 0; continue }
        $g = if ($Metriques[$k].Plus) { ($n - $b) / [math]::Abs($b) * 100 } else { ($b - $n) / [math]::Abs($b) * 100 }
        $g = [math]::Round($g, 1)
        $gains[$k] = $g
        if ($lot.Metriques -contains $k) {
            $bruitMax = [math]::Max([double]$script:Etat.Bruit.$k, [double]$mesure.Bruit[$k])
            $seuil = [math]::Max($Metriques[$k].Seuil, 2 * $bruitMax)
            if ($g -ge $seuil) {
                $pos++
                if (-not $meilleur -or $g -gt $gains[$meilleur]) { $meilleur = $k }
            }
            elseif ($g -le -$seuil) { $neg++ }
        }
    }
    $verdict = if ($pos -gt 0 -and $neg -eq 0) { 'Utile' }
               elseif ($pos -gt 0 -and $neg -gt 0) { 'Mitige' }
               elseif ($neg -gt 0) { 'A eviter' }
               else { 'Negligeable' }
    $texte = if ($meilleur) { "$($Metriques[$meilleur].Nom) +$($gains[$meilleur]) %" } else { '-' }
    return [pscustomobject]@{ Id = $id; Valeurs = $valeurs; Gains = $gains; Verdict = $verdict; Meilleur = $texte }
}

function Format-Val($v) { return ('{0:N2}' -f [double]$v) }

function Ecrire-RapportTest($data) {
    $f = Join-Path ([Environment]::GetFolderPath('Desktop')) 'Resultats_Test_OptiGame.txt'
    $l = New-Object System.Collections.Generic.List[string]
    $l.Add("===== TEST DE PERFORMANCE OPTIGAME - $($data.Date) =====")
    if ($data.Mode) { $l.Add("Mode : $($data.Mode)") }
    $l.Add('')
    $l.Add('--- Mesure de depart (bruit = variation normale entre 2 passages) ---')
    foreach ($k in $Metriques.Keys) {
        $l.Add(('  {0,-32} {1,10} {2,-7} (bruit {3} %)' -f $Metriques[$k].Nom, (Format-Val $data.Base.$k), $Metriques[$k].Unite, $data.Bruit.$k))
    }
    foreach ($r in (Liste $data.Resultats)) {
        $l.Add('')
        $l.Add("--- $($Lots[$r.Id].Nom) : $($r.Verdict) ---")
        foreach ($k in $Metriques.Keys) {
            $marque = if ($Lots[$r.Id].Metriques -contains $k) { '*' } else { ' ' }
            $signe = if ([double]$r.Gains.$k -gt 0) { '+' } else { '' }
            $l.Add(('{0} {1,-32} {2,10} -> {3,10}  ({4}{5} %)' -f $marque, $Metriques[$k].Nom, (Format-Val $data.Base.$k), (Format-Val $r.Valeurs.$k), $signe, $r.Gains.$k))
        }
    }
    $l.Add('')
    $l.Add('* = mesures prises en compte pour le verdict de cette optimisation.')
    $l.Add('Un ecart n''est compte que s''il depasse le seuil ET deux fois le bruit de mesure.')
    if ($data.Controle) {
        $l.Add('')
        $etatCtrl = if ($data.Controle.Ok) { 'OK, PC revenu comme avant' } else { 'ECART detecte' }
        $l.Add("--- Controle final (tous les reglages remis) : $etatCtrl ---")
        foreach ($k in @('CpuMono', 'CpuMulti', 'Memoire', 'Latence', 'Latence99')) {
            $signe = if ([double]$data.Controle.Ecarts.$k -gt 0) { '+' } else { '' }
            $l.Add(('  {0,-32} {1,10} -> {2,10}  ({3}{4} %)' -f $Metriques[$k].Nom, (Format-Val $data.Base.$k), (Format-Val $data.Controle.Valeurs.$k), $signe, $data.Controle.Ecarts.$k))
        }
        $l.Add('  Le point de restauration cree au debut du test reste disponible si besoin.')
    }
    $l.Add('Ce test mesure processeur, memoire, reactivite de Windows et charge au repos. Il ne mesure pas les FPS en jeu.')
    $l | Out-File -FilePath $f -Encoding UTF8
    return $f
}

# (Afficher-Resultats : defini dans l'interface v2)

# (Update-TestUi : defini dans l'interface v2)

function Redemarrer-Test([string]$raison) {
    $script:Etat.RebootDemande = (Get-Date).ToString('s')
    Save-Etat
    Write-Log $raison 'Gold'
    Write-Log 'Redemarrage dans 20 secondes. OptiGame se relancera tout seul apres ta connexion.' 'Gold'
    Set-Phase 'Redemarrage en cours... (le test continuera tout seul)'
    shutdown.exe /r /t 20 /c "OptiGame : redemarrage pour le test de performance" | Out-Null
}

function Arreter-Test {
    shutdown.exe /a 2>$null | Out-Null
    $script:Journaliser = $false
    if (-not $script:Etat) { [void](Load-Etat) }
    $reboot = $false
    if ($script:Etat) {
        if ((Liste $script:Etat.Snapshot).Count -gt 0) {
            $lc = $script:Etat.LotCourant
            Revert-Snapshot
            if ($lc -and $Lots[$lc].Reboot) { $reboot = $true }
        }
        if ($script:Etat.RebootPending) { $reboot = $true }
    }
    Supprimer-Tache
    Remove-Item $EtatFichier -Force -ErrorAction SilentlyContinue
    $script:Etat = $null; $script:StopDemande = $false; $script:TestEnCours = $false
    $script:Journaliser = $true
    Write-Log 'Test arrete : les reglages sont remis comme avant.' 'Gold'
    Set-Phase 'Test arrete.'
    Set-Compte ''
    Update-TestUi
    if ($reboot) { Ask-Reboot }
}

function Lancer-Test([switch]$Rapide) {
    if ($Rapide) {
        $msg = "Test RAPIDE, sans redemarrage :`r`n" +
               "  1. mesure ton PC tel qu'il est,`r`n" +
               "  2. essaie chaque optimisation une par une et mesure,`r`n" +
               "  3. remet tout comme avant,`r`n" +
               "  4. te montre ce qui vaut le coup.`r`n`r`n" +
               "Duree : 5 a 10 minutes. Un point de restauration est cree au debut, et une mesure de controle verifie a la fin que tout est revenu comme avant.`r`n" +
               "Un peu moins precis que le test complet : la planification GPU (HAGS) et le demarrage rapide ne s'activent qu'apres un redemarrage, leur effet n'est donc pas mesure.`r`n`r`n" +
               "Ferme tes jeux et logiciels, et ne touche pas au PC pendant le test.`r`n`r`n" +
               "Lancer le test rapide ?"
    } else {
        $msg = "Le test COMPLET va :`r`n" +
               "  1. mesurer ton PC tel qu'il est,`r`n" +
               "  2. essayer chaque optimisation une par une et mesurer,`r`n" +
               "  3. remettre tout comme avant,`r`n" +
               "  4. te montrer ce qui vaut le coup.`r`n`r`n" +
               "Duree : 25 a 45 minutes, avec 3 ou 4 redemarrages automatiques.`r`n" +
               "Un point de restauration est cree au debut, et une mesure de controle verifie a la fin que tout est revenu comme avant.`r`n" +
               "Ferme tes jeux et logiciels, et ne touche pas au PC pendant le test.`r`n" +
               "Si ta session a un mot de passe, tape-le apres chaque redemarrage.`r`n`r`n" +
               "Lancer le test ?"
    }
    if (-not (Ask-YesNo $msg)) { return }
    $bat = @(Get-CimInstance Win32_Battery -ErrorAction SilentlyContinue)
    if ($bat | Where-Object { $_.BatteryStatus -eq 1 }) {
        if (-not (Ask-YesNo "Ton PC portable est sur batterie : les mesures seront faussees.`r`nBranche le chargeur pour un test fiable.`r`n`r`nContinuer quand meme ?")) { return }
    }
    $script:StopDemande = $false
    $script:TestEnCours = $true
    $script:Journaliser = $false
    Update-TestUi
    Vider-ResultatsTest
    $continuer = $false
    try {
        if ($Rapide) { Write-Log '===== TEST DE PERFORMANCE RAPIDE (sans redemarrage) =====' 'White' }
        else { Write-Log '===== TEST DE PERFORMANCE COMPLET =====' 'White' }
        Set-Phase 'Preparation...'
        Etape-PointRestauration -Force
        $script:Etat = [pscustomobject]@{
            Phase = 'base'; Base = $null; Bruit = $null
            File = @('boost', 'perf'); LotCourant = $null
            Snapshot = @(); Resultats = @(); RebootPending = $false
            RebootDemande = $null; Debut = (Get-Date).ToString('s')
            SansReboot = [bool]$Rapide
        }
        if ($Rapide) {
            Save-Etat
            $continuer = $true
        } else {
            Write-Log 'Programmation de la relance automatique apres redemarrage...'
            Enregistrer-Tache
            Save-Etat
            Redemarrer-Test 'Premier redemarrage : pour mesurer ton PC dans un etat propre.'
        }
    }
    catch {
        Write-Log "[ERREUR] $($_.Exception.Message)" 'Tomato'
        Noter-Erreur 'Lancement du test' $_
        Supprimer-Tache
        Remove-Item $EtatFichier -Force -ErrorAction SilentlyContinue
    }
    finally {
        $script:TestEnCours = $false
        $script:Journaliser = $true
        Update-TestUi
    }
    if ($continuer) { Continue-Test }
}

function Continue-Test {
    $script:StopDemande = $false
    $script:TestEnCours = $true
    $script:Journaliser = $false
    Update-TestUi
    try {
        # Verifie que le redemarrage demande a bien eu lieu
        if ($script:Etat.RebootDemande) {
            $boot = (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
            if ($boot -lt [datetime]$script:Etat.RebootDemande) {
                Write-Log 'Le redemarrage prevu n''a pas eu lieu.' 'Gold'
                if (Ask-YesNo "Le test attend un redemarrage pour continuer.`r`n`r`nRedemarrer maintenant ?") {
                    shutdown.exe /r /t 10 /c "OptiGame : redemarrage pour le test de performance" | Out-Null
                    Set-Phase 'Redemarrage en cours...'
                } else {
                    Set-Phase 'En attente d''un redemarrage (ou clique sur Arreter le test).'
                }
                return
            }
            $script:Etat.RebootDemande = $null
            Save-Etat
        }

        while ($true) {
            switch ($script:Etat.Phase) {
                'base' {
                    Set-Phase 'Etape : mesure de depart'
                    if ($script:Etat.SansReboot) { Wait-Ui 20 'Stabilisation' }
                    else { Wait-Ui 120 'Windows finit de demarrer' }
                    Write-Log 'Mesure de depart (3 passages pour fiabiliser)...' 'White'
                    $m = Mesurer-Complet
                    $script:Etat.Base = $m.Med
                    $script:Etat.Bruit = $m.Bruit
                    Write-Log '   Mesure de depart enregistree.' 'Gray'
                    $script:Etat.Phase = 'suivant'
                    Save-Etat
                }
                'suivant' {
                    $file = Liste $script:Etat.File
                    if ($file.Count -eq 0) { $script:Etat.Phase = 'controle-prep'; Save-Etat; continue }
                    $id = $file[0]
                    $script:Etat.File = @($file | Select-Object -Skip 1)
                    $script:Etat.LotCourant = $id
                    Set-Phase "Etape : essai de $($Lots[$id].Nom)"
                    Write-Log "Essai temporaire : $($Lots[$id].Nom)..." 'White'
                    & $Lots[$id].Apply
                    if (-not $script:Etat.SansReboot -and ($Lots[$id].Reboot -or $script:Etat.RebootPending)) {
                        $script:Etat.Phase = 'apres-reboot'
                        Save-Etat
                        Redemarrer-Test 'Redemarrage necessaire pour que l''optimisation soit vraiment active.'
                        return
                    }
                    $script:Etat.Phase = 'mesure'
                    Save-Etat
                    Wait-Ui 20 'Stabilisation'
                }
                'apres-reboot' {
                    $script:Etat.RebootPending = $false
                    Set-Phase "Etape : mesure avec $($Lots[$script:Etat.LotCourant].Nom)"
                    Wait-Ui 120 'Windows finit de demarrer'
                    $script:Etat.Phase = 'mesure'
                    Save-Etat
                }
                'mesure' {
                    $id = $script:Etat.LotCourant
                    $lot = $Lots[$id]
                    Set-Phase "Etape : mesure avec $($lot.Nom)"
                    Write-Log "Mesure avec $($lot.Nom)..." 'White'
                    $m = Mesurer-Complet
                    $res = Comparer $id $m
                    Write-Log "Resultat $($lot.Nom) : $($res.Verdict)" $(if ($res.Verdict -eq 'Utile') { 'LightGreen' } else { 'Gold' })
                    foreach ($k in $lot.Metriques) {
                        $signe = if ($res.Gains[$k] -gt 0) { '+' } else { '' }
                        Write-Log ("   {0} : {1} -> {2} ({3}{4} %)" -f $Metriques[$k].Nom, (Format-Val $script:Etat.Base.$k), (Format-Val $res.Valeurs[$k]), $signe, $res.Gains[$k]) 'Gray'
                    }
                    Revert-Snapshot
                    if ($lot.Reboot -and -not $script:Etat.SansReboot) { $script:Etat.RebootPending = $true }
                    $script:Etat.Resultats = (Liste $script:Etat.Resultats) + $res
                    if ($res.Verdict -ne 'Utile' -and $lot.Alternative) {
                        Write-Log "Effet trop faible : on essaie autre chose ($($Lots[$lot.Alternative].Nom))." 'Gold'
                        $script:Etat.File = @($lot.Alternative) + (Liste $script:Etat.File)
                    }
                    $script:Etat.Phase = 'suivant'
                    Save-Etat
                }
                'controle-prep' {
                    Revert-Snapshot
                    if (-not $script:Etat.SansReboot -and $script:Etat.RebootPending) {
                        $script:Etat.RebootPending = $false
                        $script:Etat.Phase = 'controle'
                        Save-Etat
                        Redemarrer-Test 'Dernier redemarrage : pour verifier que ton PC est bien revenu comme avant.'
                        return
                    }
                    $script:Etat.Phase = 'controle'
                    Save-Etat
                }
                'controle' {
                    Set-Phase 'Etape : verification du retour a l''etat de depart'
                    if ($script:Etat.SansReboot) { Wait-Ui 20 'Stabilisation' }
                    else { Wait-Ui 120 'Windows finit de demarrer' }
                    Write-Log 'Mesure de controle (PC remis comme avant)...' 'White'
                    $m = Mesurer-Complet
                    $ctrl = Verifier-Retour $m
                    $script:Etat | Add-Member -NotePropertyName Controle -NotePropertyValue $ctrl -Force
                    if ($ctrl.Ok) { Write-Log 'Controle OK : ton PC est revenu a ses performances de depart.' 'LightGreen' }
                    else { Write-Log "Ecart apres retour : $($ctrl.Detail)" 'Gold' }
                    $script:Etat.Phase = 'fini'
                    Save-Etat
                }
                'fini' {
                    Finir-Test
                    return
                }
                default { throw "Etape inconnue : $($script:Etat.Phase)" }
            }
        }
    }
    catch {
        if ($_.Exception.Message -like '*ARRET_TEST*') {
            $script:TestEnCours = $false
            Arreter-Test
        } else {
            Write-Log "[ERREUR] $($_.Exception.Message)" 'Tomato'
            Write-Log 'Test en pause. Relance OptiGame pour continuer, ou clique sur Arreter le test pour tout remettre.' 'Gold'
            Noter-Erreur 'Test de performance' $_
            Set-Phase 'Test en pause (erreur) : voir l''onglet Erreurs.'
        }
    }
    finally {
        $script:TestEnCours = $false
        $script:Journaliser = $true
        Update-TestUi
    }
}

function Verifier-Retour($mesure) {
    # Compare la mesure finale (reglages remis) a la mesure de depart
    $cles = @('CpuMono', 'CpuMulti', 'Memoire', 'Latence', 'Latence99')
    $ecarts = [ordered]@{}; $valeurs = [ordered]@{}; $pb = @()
    foreach ($k in $cles) {
        $b = [double]$script:Etat.Base.$k
        $n = [double]$mesure.Med[$k]
        $valeurs[$k] = $n
        if ($b -eq 0) { $ecarts[$k] = 0; continue }
        $g = if ($Metriques[$k].Plus) { ($n - $b) / [math]::Abs($b) * 100 } else { ($b - $n) / [math]::Abs($b) * 100 }
        $g = [math]::Round($g, 1)
        $ecarts[$k] = $g
        $bruitMax = [math]::Max([double]$script:Etat.Bruit.$k, [double]$mesure.Bruit[$k])
        $seuil = [math]::Max($Metriques[$k].Seuil, 2 * $bruitMax)
        if ($g -le -$seuil) { $pb += "$($Metriques[$k].Nom) $g %" }
    }
    return [pscustomobject]@{ Ok = ($pb.Count -eq 0); Valeurs = [pscustomobject]$valeurs; Ecarts = [pscustomobject]$ecarts; Detail = ($pb -join ', ') }
}

function Finir-Test {
    Revert-Snapshot
    Supprimer-Tache
    $data = [pscustomobject]@{
        Date = (Get-Date).ToString('dd/MM/yyyy HH:mm')
        Base = $script:Etat.Base; Bruit = $script:Etat.Bruit
        Resultats = Liste $script:Etat.Resultats
        Mode = $(if ($script:Etat.SansReboot) { 'Rapide (sans redemarrage)' } else { 'Complet (avec redemarrages)' })
        Controle = $script:Etat.Controle
    }
    $rebootFinal = [bool]$script:Etat.RebootPending
    New-Item -ItemType Directory -Path $DossierData -Force | Out-Null
    $data | ConvertTo-Json -Depth 8 | Out-File -FilePath $ResultatFichier -Encoding UTF8
    Remove-Item $EtatFichier -Force -ErrorAction SilentlyContinue
    $script:Etat = $null

    $rapport = Ecrire-RapportTest $data
    Afficher-Resultats $data
    Set-Phase 'Test termine : coche ce que tu veux garder.'
    Write-Log '===== TEST TERMINE =====' 'White'
    Write-Log 'Tous les reglages ont ete remis comme avant le test.' 'Gold'
    Write-Log 'Detail complet sur le Bureau : Resultats_Test_OptiGame.txt' 'Gold'

    if ($script:Prog -and $script:Prog.Visible) { Fin-Progression $true }
    $utiles = @((Liste $data.Resultats) | Where-Object { $_.Verdict -eq 'Utile' -and $Lots[$_.Id].Permanent })
    $msg = if ($utiles.Count -gt 0) {
        "Test termine.`r`n`r`n$($utiles.Count) optimisation(s) donnent un vrai gain sur ton PC.`r`nElles sont cochees dans l'onglet Test : clique sur `"Appliquer`" pour les garder."
    } else {
        "Test termine.`r`n`r`nAucune optimisation ne donne de gain mesurable sur ton PC : il est deja bien regle.`r`nTu peux garder Windows tel quel."
    }
    if ($rebootFinal) { $msg += "`r`n`r`nPense a redemarrer pour que tout soit vraiment remis comme avant (ou applique d'abord ce que tu gardes)." }
    if ($data.Controle -and -not $data.Controle.Ok) {
        $msg += "`r`n`r`nATTENTION : la mesure de controle est un peu plus basse qu'au depart ($($data.Controle.Detail)).`r`n" +
                "C'est souvent une mise a jour ou un programme qui tournait en fond. Tous les reglages du test ont pourtant ete remis.`r`n`r`n" +
                "Ouvrir la Restauration du systeme pour revenir au point cree au debut du test ?"
        if ((Ask-YesNo $msg)) { Start-Process rstrui.exe }
        return
    }
    if ($data.Controle) { $msg += "`r`n`r`nControle final OK : ton PC est revenu exactement a ses performances de depart." }
    Show-Info $msg 'Test termine'
}

# =====================================================================
#  INFORMATIONS PC (onglet Informations)
# =====================================================================
function D8($x) { if ($x -is [datetime]) { return $x.ToString('dd/MM/yyyy') } return '?' }

function Type-Ram($t) {
    switch ([int]$t) { 24 { return 'DDR3' } 26 { return 'DDR4' } 34 { return 'DDR5' } default { return '' } }
}

function Trad-Sante($h) {
    switch ("$h") { 'Healthy' { return 'Bonne' } 'Warning' { return 'Attention' } 'Unhealthy' { return 'Mauvaise' } default { return "$h" } }
}

function Get-VramGo([string]$nomGpu) {
    $base = 'HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}'
    foreach ($k in @(Get-ChildItem $base -ErrorAction SilentlyContinue)) {
        if ($k.PSChildName -notmatch '^\d{4}$') { continue }
        $p = Get-ItemProperty $k.PSPath -ErrorAction SilentlyContinue
        if ($p.DriverDesc -ne $nomGpu) { continue }
        $m = $p.'HardwareInformation.qwMemorySize'
        if ($null -eq $m) { continue }
        try {
            if ($m -is [byte[]]) { $m = [BitConverter]::ToUInt64($m, 0) }
            return [math]::Round([double]$m / 1GB)
        } catch {}
    }
    return $null
}

$CodeEcran = @'
using System;
using System.Runtime.InteropServices;
public static class OGEcran
{
    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
    public struct DEVMODE
    {
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 32)] public string dmDeviceName;
        public short dmSpecVersion, dmDriverVersion, dmSize, dmDriverExtra;
        public int dmFields, dmPositionX, dmPositionY, dmDisplayOrientation, dmDisplayFixedOutput;
        public short dmColor, dmDuplex, dmYResolution, dmTTOption, dmCollate;
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 32)] public string dmFormName;
        public short dmLogPixels;
        public int dmBitsPerPel, dmPelsWidth, dmPelsHeight, dmDisplayFlags, dmDisplayFrequency;
        public int dmICMMethod, dmICMIntent, dmMediaType, dmDitherType, dmReserved1, dmReserved2, dmPanningWidth, dmPanningHeight;
    }
    [DllImport("user32.dll", CharSet = CharSet.Unicode)]
    static extern bool EnumDisplaySettings(string dev, int mode, ref DEVMODE dm);

    // Renvoie largeur, hauteur, Hz actuels, Hz maximum a cette resolution
    public static int[] Info(string dev)
    {
        var dm = new DEVMODE(); dm.dmSize = (short)Marshal.SizeOf(typeof(DEVMODE));
        if (!EnumDisplaySettings(dev, -1, ref dm)) return null;
        int w = dm.dmPelsWidth, h = dm.dmPelsHeight, hz = dm.dmDisplayFrequency, max = hz;
        var m = new DEVMODE(); m.dmSize = dm.dmSize;
        for (int i = 0; EnumDisplaySettings(dev, i, ref m); i++)
            if (m.dmPelsWidth == w && m.dmPelsHeight == h && m.dmDisplayFrequency > max) max = m.dmDisplayFrequency;
        return new int[] { w, h, hz, max };
    }
}
'@

function Get-Ecrans {
    # Lecture en direct (WMI garde l'ancienne frequence jusqu'au redemarrage)
    Charger-Type 'OGEcran' $CodeEcran
    $r = @()
    $n = 0
    foreach ($sc in [Windows.Forms.Screen]::AllScreens) {
        $n++
        $x = [OGEcran]::Info($sc.DeviceName)
        if (-not $x) { continue }
        $nom = if ($sc.Primary) { "Ecran $n (principal)" } else { "Ecran $n" }
        $r += [pscustomobject]@{ Nom = $nom; L = $x[0]; H = $x[1]; Hz = $x[2]; Max = $x[3] }
    }
    return $r
}

function Get-ProgrammeInstalle([string]$motif) {
    $cles = @('HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*', 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*')
    return Get-ItemProperty $cles -ErrorAction SilentlyContinue | Where-Object { "$($_.DisplayName)" -match $motif } | Select-Object -First 1
}

function Collecter-Infos {
    $r = [ordered]@{}
    $r.Cpu   = Get-CimInstance Win32_Processor -ErrorAction SilentlyContinue | Select-Object -First 1
    $r.Gpus  = @(Get-CimInstance Win32_VideoController -ErrorAction SilentlyContinue |
                 Where-Object { $_.Name -notmatch 'Basic Display|Basic Render|Virtual|Remote|Parsec|Mirage' })
    $r.Ram   = @(Get-CimInstance Win32_PhysicalMemory -ErrorAction SilentlyContinue)
    $r.Os    = Get-CimInstance Win32_OperatingSystem
    $r.Board = Get-CimInstance Win32_BaseBoard -ErrorAction SilentlyContinue | Select-Object -First 1
    $r.Bios  = Get-CimInstance Win32_BIOS -ErrorAction SilentlyContinue | Select-Object -First 1
    $r.Disks = @(Get-PhysicalDisk -ErrorAction SilentlyContinue)
    $r.Nets  = @(Get-NetAdapter -Physical -ErrorAction SilentlyContinue)
    $cv = Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -ErrorAction SilentlyContinue
    $r.WinVer = "$($cv.DisplayVersion) (build $($r.Os.BuildNumber).$($cv.UBR))"
    $r.Plan = Get-PlanNom
    $r.Vbs = $null
    try {
        $dg = Get-CimInstance -Namespace 'root\Microsoft\Windows\DeviceGuard' -ClassName Win32_DeviceGuard -ErrorAction Stop
        $r.Vbs = (@($dg.SecurityServicesRunning) -contains 2)
    } catch {}
    $r.Hags = Lire-Reg 'HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers' 'HwSchMode'
    $c = Get-PSDrive C -ErrorAction SilentlyContinue
    $r.CLibre = [double]$c.Free
    $r.CTotal = [double]$c.Free + [double]$c.Used
    $r.RamCfg = ($r.Ram | Measure-Object ConfiguredClockSpeed -Minimum).Minimum
    $r.RamMax = ($r.Ram | Measure-Object Speed -Maximum).Maximum
    $r.RamTot = [math]::Round((($r.Ram | Measure-Object Capacity -Sum).Sum) / 1GB)
    $r.RamType = if ($r.Ram.Count -gt 0) { Type-Ram $r.Ram[0].SMBIOSMemoryType } else { '' }
    $r.Uptime = (Get-Date) - $r.Os.LastBootUpTime
    $r.Ecrans = @(try { Get-Ecrans } catch { @() })
    $r.Chipset = Get-ProgrammeInstalle 'AMD Chipset'
    $r.VbsReg = Lire-Reg 'HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity' 'Enabled'
    $r.Plus = $script:InfosPlus
    Lancer-InfosPlus
    return [pscustomobject]$r
}

function Remplir-Composants($i) {
    $lignes = New-Object System.Collections.ArrayList
    $add = {
        param($a, $b, $couleur)
        $sous = ([string]$a).StartsWith('   ')
        $c = '#E9ECF2'
        if ($couleur -is [Drawing.Color]) { $c = '#{0:X2}{1:X2}{2:X2}' -f $couleur.R, $couleur.G, $couleur.B }
        [void]$lignes.Add([pscustomobject]@{
            Label = ([string]$a).Trim(); Valeur = [string]$b; Couleur = $c
            CouleurLabel = $(if ($sous) { '#6F788B' } else { '#8C95A8' })
            Graisse = $(if ($sous) { 'Normal' } else { 'SemiBold' })
            Retrait = $(if ($sous) { '16,0,0,0' } else { '0' })
        })
    }
    if ($i.Cpu) {
        & $add 'Processeur' ('{0} - {1} coeurs / {2} threads - {3} MHz' -f "$($i.Cpu.Name)".Trim(), $i.Cpu.NumberOfCores, $i.Cpu.NumberOfLogicalProcessors, $i.Cpu.MaxClockSpeed)
    }
    foreach ($g in $i.Gpus) {
        $v = Get-VramGo $g.Name
        $t = $g.Name
        if ($v) { $t += " - $v Go de VRAM" }
        & $add 'Carte graphique' $t
        & $add '   Pilote' ("{0} du {1}" -f $g.DriverVersion, (D8 $g.DriverDate))
    }
    foreach ($e in $i.Ecrans) {
        $coul = $null
        if ($e.Max -gt $e.Hz) { $coul = [Drawing.Color]::Gold }
        & $add $e.Nom ('{0} x {1} a {2} Hz (maximum de l''ecran : {3} Hz)' -f $e.L, $e.H, $e.Hz, $e.Max) $coul
    }
    if ($i.Ram.Count -gt 0) {
        $tailles = ($i.Ram | ForEach-Object { [math]::Round($_.Capacity / 1GB) }) -join ' + '
        & $add 'Memoire (RAM)' ('{0} Go {1} - {2} barrette(s) ({3} Go)' -f $i.RamTot, $i.RamType, $i.Ram.Count, $tailles)
        $coul = $null
        if ($i.RamCfg -and $i.RamMax -and $i.RamCfg -lt $i.RamMax) { $coul = [Drawing.Color]::Gold }
        & $add '   Frequence' ('{0} MHz (vitesse de base annoncee : {1} MHz)' -f $i.RamCfg, $i.RamMax) $coul
        $modeles = ($i.Ram | ForEach-Object { ("$($_.Manufacturer) $($_.PartNumber)").Trim() } | Select-Object -Unique) -join ', '
        & $add '   Modele' $modeles
    }
    foreach ($d in $i.Disks) {
        & $add 'Stockage' ('{0} - {1} Go - {2} {3}' -f $d.FriendlyName, [math]::Round($d.Size / 1GB), $d.MediaType, $d.BusType)
        $coul = $null
        if ("$($d.HealthStatus)" -ne 'Healthy') { $coul = [Drawing.Color]::Tomato }
        & $add '   Sante' (Trad-Sante $d.HealthStatus) $coul
        $sd = @($i.Plus.Sante) | Where-Object { $_ -and $_.Id -eq "$($d.DeviceId)" } | Select-Object -First 1
        if ($sd) {
            $vu = $false
            if ($null -ne $sd.Usure) {
                $vu = $true
                $c2 = if ([int]$sd.Usure -ge 80) { [Drawing.Color]::Tomato } elseif ([int]$sd.Usure -ge 50) { [Drawing.Color]::Gold } else { $null }
                & $add '   Usure' ("$($sd.Usure) % (il reste environ $(100 - [int]$sd.Usure) % de duree de vie)") $c2
            }
            if ($sd.Temp) {
                $vu = $true
                $c2 = if ([int]$sd.Temp -ge 70) { [Drawing.Color]::Tomato } elseif ([int]$sd.Temp -ge 55) { [Drawing.Color]::Gold } else { $null }
                & $add '   Temperature' ("$($sd.Temp) $([char]0xB0)C$(if ($sd.TempMax) { " (le plus chaud enregistre : $($sd.TempMax) $([char]0xB0)C)" })") $c2
            }
            if ($sd.Heures) { $vu = $true; & $add '   Allume pendant' ('{0:N0} heures (environ {1:N1} ans)' -f [double]$sd.Heures, ([double]$sd.Heures / 8760)) }
            if ($null -ne $sd.Erreurs) { $vu = $true; & $add '   Erreurs de lecture / ecriture' $(if ([int64]$sd.Erreurs -gt 0) { "$($sd.Erreurs) (a surveiller : sauvegarde tes fichiers importants)" } else { 'Aucune' }) $(if ([int64]$sd.Erreurs -gt 0) { [Drawing.Color]::Tomato } else { $null }) }
            if (-not $vu) { & $add '   Usure / temperature' 'Non donne par ce disque' }
        } elseif (-not $i.Plus) { & $add '   Usure / temperature' 'Analyse en cours...' }
    }
    if ($i.CTotal -gt 0) {
        & $add '   Espace libre C:' ('{0:N1} Go sur {1:N0} Go' -f ($i.CLibre / 1GB), ($i.CTotal / 1GB))
    }
    foreach ($n in $i.Nets) {
        $type = if (Est-WiFi $n) { 'Reseau Wi-Fi' } else { 'Reseau Ethernet' }
        $etat = if ($n.Status -eq 'Up') { "Connecte - $($n.LinkSpeed)" } else { 'Non connecte' }
        & $add $type "$($n.InterfaceDescription) - $etat"
    }
    if ($i.Board) { & $add 'Carte mere' ("$($i.Board.Manufacturer) $($i.Board.Product)").Trim() }
    if ($i.Bios)  { & $add '   BIOS' ("{0} du {1}" -f $i.Bios.SMBIOSBIOSVersion, (D8 $i.Bios.ReleaseDate)) }
    & $add 'Windows' ("$($i.Os.Caption) $($i.WinVer)").Trim()
    & $add '   Plan d''alimentation' $i.Plan
    & $add '   Planification GPU' (Format-Reg 'HwSchMode' $i.Hags)
    $vbsTxt = if ($null -eq $i.Vbs) { 'Inconnu' } elseif ($i.Vbs) { 'Active' } else { 'Desactivee' }
    & $add '   Isolation du noyau' $vbsTxt
    & $add '   Allume depuis' ('{0} jour(s) {1} h' -f $i.Uptime.Days, $i.Uptime.Hours)
    $script:LignesComp = @($lignes)
    if ($UI.ListeComposants) { $UI.ListeComposants.ItemsSource = @($lignes) }
}

function Suivre-Evolution($i) {
    # Compare le materiel/pilotes avec la derniere ouverture (ex : RAM 2133 -> 3200 MHz)
    $f = Join-Path $DossierData 'etat_pc.json'
    $vbsTxt = if ($null -eq $i.Vbs) { '' } elseif ($i.Vbs) { 'Active' } else { 'Desactivee' }
    $now = [ordered]@{
        'Frequence RAM'          = "$($i.RamCfg) MHz"
        'Quantite de RAM'        = "$($i.RamTot) Go"
        'Processeur'             = "$($i.Cpu.Name)".Trim()
        'Carte graphique'        = (($i.Gpus | ForEach-Object { $_.Name }) -join ', ')
        'Pilote carte graphique' = (($i.Gpus | ForEach-Object { $_.DriverVersion }) -join ', ')
        'Version du BIOS'        = "$($i.Bios.SMBIOSBIOSVersion)"
        'Version de Windows'     = $i.WinVer
        'Isolation du noyau'     = $vbsTxt
        'Frequence ecran'        = (($i.Ecrans | ForEach-Object { "$($_.Hz) Hz" }) -join ', ')
    }
    if (Test-Path $f) {
        try {
            $old = Get-Content $f -Raw | ConvertFrom-Json
            foreach ($k in $now.Keys) {
                $o = $old.$k
                if ($null -ne $o -and "$o" -ne '' -and "$($now[$k])" -ne '' -and "$o" -ne "$($now[$k])") {
                    $sa = $script:SourceAction
                    $script:SourceAction = 'Detecte a l''ouverture d''OptiGame (change en dehors d''OptiGame : BIOS, pilote, Windows...)'
                    Ajouter-Journal $k "$o" "$($now[$k])"
                    $script:SourceAction = $sa
                }
            }
        } catch {}
    }
    New-Item -ItemType Directory -Path $DossierData -Force | Out-Null
    $now | ConvertTo-Json | Out-File -FilePath $f -Encoding UTF8
}

# (Remplir-Changements : defini dans l'interface v2)

function Lire-Masques {
    $f = Join-Path $DossierData 'conseils_masques.json'
    if (-not (Test-Path $f)) { return @() }
    try { return @((Get-Content $f -Raw | ConvertFrom-Json) | ForEach-Object { "$_" }) } catch { return @() }
}

function Ouvrir-Lien([string]$cible) {
    if ($cible -like 'fix:*') { Corriger-Conseil $cible.Substring(4); return }
    if ($cible -like 'nav:*') { try { Aller-A $cible.Substring(4) } catch {}; return }
    if ($cible -eq 'bios:') {
        if (-not (Ask-YesNo "Le PC va redemarrer directement dans le BIOS dans 10 secondes.`r`nEnregistre ton travail avant.`r`n`r`nDans le BIOS : regle ce qui est indique, puis 'Save & Exit' (souvent F10).`r`n`r`nContinuer ?")) { return }
        shutdown.exe /r /fw /t 10 /c "OptiGame : redemarrage vers le BIOS" 2>$null | Out-Null
        if ($LASTEXITCODE -ne 0) {
            Show-Info "Ton PC ne permet pas d'ouvrir le BIOS automatiquement.`r`nRedemarre et appuie plusieurs fois sur Suppr (ou F2) des que l'ecran s'allume."
        }
        return
    }
    if ($cible -like 'masquer:*') {
        $id = $cible.Substring(8)
        $m = @(Lire-Masques) + $id
        New-Item -ItemType Directory -Path $DossierData -Force | Out-Null
        ConvertTo-Json -InputObject @($m | Select-Object -Unique) | Out-File -FilePath (Join-Path $DossierData 'conseils_masques.json') -Encoding UTF8
        if ($script:Infos) { Remplir-Conseils $script:Infos }
        return
    }
    if ($cible -eq 'av:') { Aller-A 'NavAntivirus'; return }
    if ($cible -eq 'repsearch:') {
        Invoke-Action 'Reparation de la recherche Windows' { [void](Reparer-Recherche -Force) }
        Actualiser-Infos
        return
    }
    if ($cible -eq 'reboot:') {
        if (Ask-YesNo "Redemarrer le PC dans 10 secondes ?`r`nEnregistre ton travail avant.") {
            shutdown.exe /r /t 10 /c "Redemarrage demande par OptiGame" | Out-Null
        }
        return
    }
    try { Start-Process $cible } catch {
        Show-Info "Impossible d'ouvrir : $cible"
    }
}

# Analyse plus fine du PC (reglages caches qui coutent des FPS, de la reactivite ou de la stabilite)
function Collecter-InfosPlus {
    $p = [ordered]@{}
    try { $p.SourisAccel = ("$((Get-ItemProperty 'HKCU:\Control Panel\Mouse' -ErrorAction Stop).MouseSpeed)" -ne '0') } catch { $p.SourisAccel = $null }
    $p.DemRapide = ("$(Lire-Reg 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power' 'HiberbootEnabled')" -ne '0')
    $p.RedemAttente = (Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired') -or
                      (Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending')
    # Programmes lances au demarrage de Windows (actifs)
    $dem = @()
    foreach ($k in @('HKCU:\Software\Microsoft\Windows\CurrentVersion\Run', 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run', 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run')) {
        $it = Get-Item $k -ErrorAction SilentlyContinue
        if (-not $it) { continue }
        foreach ($n in $it.GetValueNames()) {
            if (-not $n) { continue }
            $etat = $null
            foreach ($a in @(($k -replace 'CurrentVersion\\Run$', 'CurrentVersion\Explorer\StartupApproved\Run'), ($k -replace 'CurrentVersion\\Run$', 'CurrentVersion\Explorer\StartupApproved\Run32'))) {
                $v = Lire-Reg $a $n
                if ($v -is [byte[]] -and $v.Length) { $etat = $v[0] }
            }
            if ($null -eq $etat -or ($etat % 2) -eq 0) { $dem += $n }
        }
    }
    foreach ($d in @([Environment]::GetFolderPath('Startup'), [Environment]::GetFolderPath('CommonStartup'))) {
        $dem += @(Get-ChildItem -LiteralPath $d -File -ErrorAction SilentlyContinue | Where-Object { $_.Name -ne 'desktop.ini' } | ForEach-Object { $_.BaseName })
    }
    $p.Demarrage = @($dem | Select-Object -Unique)
    try {
        $o = (fsutil.exe behavior query DisableDeleteNotify) -join ' '
        $p.Trim = if ($o -match 'NTFS DisableDeleteNotify\s*=\s*(\d)') { $Matches[1] -eq '0' } else { $null }
    } catch { $p.Trim = $null }
    $p.DisqueC = $null
    try {
        $num = (Get-Partition -DriveLetter C -ErrorAction Stop).DiskNumber
        $pd = Get-PhysicalDisk -ErrorAction Stop | Where-Object { "$($_.DeviceId)" -eq "$num" } | Select-Object -First 1
        if ($pd) { $p.DisqueC = [pscustomobject]@{ Type = "$($pd.MediaType)"; Bus = "$($pd.BusType)"; Nom = "$($pd.FriendlyName)" } }
    } catch {}
    try { $p.PagefileAuto = [bool](Get-CimInstance Win32_ComputerSystem -ErrorAction Stop).AutomaticManagedPagefile } catch { $p.PagefileAuto = $null }
    try { $p.DerniereMaj = (Get-WinEvent -FilterHashtable @{ LogName = 'System'; ProviderName = 'Microsoft-Windows-WindowsUpdateClient'; Id = 19 } -MaxEvents 1 -ErrorAction Stop).TimeCreated } catch { $p.DerniereMaj = $null }
    $p.Capture = ("$(Lire-Reg 'HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR' 'AppCaptureEnabled')" -ne '0') -or ("$(Lire-Reg 'HKCU:\System\GameConfigStore' 'GameDVR_Enabled')" -ne '0')
    $p.Transparence = ("$(Lire-Reg 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize' 'EnableTransparency')" -ne '0')
    $p.NbProcessus = @(Get-Process -ErrorAction SilentlyContinue).Count
    # Mode d'alimentation de Windows 11 (curseur Meilleure efficacite / Equilibre / Meilleures performances)
    $ov = "$(Lire-Reg 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\User\PowerSchemes' 'ActiveOverlayAcPowerScheme')"
    $p.ModeEco = ($ov -match '961cc777-2547-4f9d-8174-7d86181b8a7a')
    $p.TimerGlobal = ("$(Lire-Reg 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\kernel' 'GlobalTimerResolutionRequests')" -eq '1')
    # Sante des disques (usure, temperature, erreurs) : compteurs de fiabilite de Windows
    $p.Sante = @()
    try {
        foreach ($d in @(Get-PhysicalDisk -ErrorAction Stop)) {
            $rc = $null; try { $rc = $d | Get-StorageReliabilityCounter -ErrorAction Stop } catch {}
            $p.Sante += [pscustomobject]@{ Id = "$($d.DeviceId)"; Nom = "$($d.FriendlyName)"; Etat = "$($d.HealthStatus)"; Type = "$($d.MediaType)"
                Usure = $(if ($rc) { $rc.Wear } else { $null }); Temp = $(if ($rc) { $rc.Temperature } else { $null }); TempMax = $(if ($rc) { $rc.TemperatureMax } else { $null })
                Heures = $(if ($rc) { $rc.PowerOnHours } else { $null })
                Erreurs = $(if ($rc -and ($null -ne $rc.ReadErrorsUncorrected -or $null -ne $rc.WriteErrorsUncorrected)) { [int64]$rc.ReadErrorsUncorrected + [int64]$rc.WriteErrorsUncorrected } else { $null }) }
        }
    } catch {}
    # Disques de jeux presque pleins (autres que C:)
    $p.DisquesPleins = @()
    try {
        foreach ($v in @(Get-CimInstance Win32_LogicalDisk -Filter 'DriveType=3' -ErrorAction Stop)) {
            if ($v.DeviceID -eq 'C:' -or -not $v.Size) { continue }
            if (($v.FreeSpace / $v.Size) -lt 0.10) { $p.DisquesPleins += [pscustomobject]@{ Lettre = $v.DeviceID; Libre = $v.FreeSpace; Total = $v.Size } }
        }
    } catch {}
    return [pscustomobject]$p
}

# L'analyse fine tourne dans un fil a part (fsutil, disques, journal Windows... peuvent prendre quelques secondes)
$script:InfosPlus = $null
function Lancer-InfosPlus {
    if ($script:TacheInfosPlus) { return }
    $code = "function Lire-Reg { $((Get-Command Lire-Reg).Definition) }`nfunction Collecter-InfosPlus { $((Get-Command Collecter-InfosPlus).Definition) }`nCollecter-InfosPlus"
    $ps = [powershell]::Create()
    [void]$ps.AddScript($code)
    $script:TacheInfosPlus = @{ PS = $ps; H = $ps.BeginInvoke(); Debut = Get-Date }
    if (-not $script:MinuterieInfosPlus) {
        $script:MinuterieInfosPlus = New-Object System.Windows.Threading.DispatcherTimer
        $script:MinuterieInfosPlus.Interval = [TimeSpan]::FromMilliseconds(500)
        $script:MinuterieInfosPlus.Add_Tick({
            $t = $script:TacheInfosPlus
            if (-not $t) { $script:MinuterieInfosPlus.Stop(); return }
            if (-not $t.H.IsCompleted) { if (((Get-Date) - $t.Debut).TotalSeconds -gt 60) { try { $t.PS.Stop() } catch {} } else { return } }
            $script:MinuterieInfosPlus.Stop()
            $script:TacheInfosPlus = $null
            $r = $null
            try { $r = @($t.PS.EndInvoke($t.H)) | Select-Object -Last 1 } catch {}
            try { $t.PS.Dispose() } catch {}
            if ($r) {
                $script:InfosPlus = $r
                if ($script:Infos) {
                    $script:Infos.Plus = $r
                    try { Remplir-Composants $script:Infos } catch {}
                    try { Remplir-Conseils $script:Infos } catch {}
                    try { Maj-Accueil } catch {}
                }
            }
        })
    }
    $script:MinuterieInfosPlus.Start()
}

# Petite aide C# : applique tout de suite le reglage de la souris (sans redemarrer la session)
$CodeSouris = @'
using System;
using System.Runtime.InteropServices;
public static class OGSouris
{
    [DllImport("user32.dll")] static extern bool SystemParametersInfo(uint action, uint param, int[] vparam, uint winIni);
    public static bool SansAcceleration()
    {
        return SystemParametersInfo(0x0004, 0, new int[] { 0, 0, 0 }, 0x01 | 0x02);
    }
}
'@

# Boutons "Regler pour moi" des conseils
function Corriger-Conseil([string]$id) {
    $titres = @{ souris = 'Couper l''acceleration de la souris'; demrapide = 'Couper le demarrage rapide'; trim = 'Activer le TRIM du SSD'
        pagefile = 'Fichier d''echange gere par Windows'; capture = 'Couper la capture en arriere-plan'; transparence = 'Couper la transparence' }
    $t = $titres[$id]
    if (-not $t) { return }
    $script:SourceAction = "Bouton $t (page Conseils)"
    Invoke-Action $t {
        switch ($id) {
            'souris' {
                Set-Reg 'HKCU:\Control Panel\Mouse' 'MouseSpeed' '0' 'String'
                Set-Reg 'HKCU:\Control Panel\Mouse' 'MouseThreshold1' '0' 'String'
                Set-Reg 'HKCU:\Control Panel\Mouse' 'MouseThreshold2' '0' 'String'
                try { Charger-Type 'OGSouris' $CodeSouris; [void][OGSouris]::SansAcceleration() } catch {}
                Ajouter-Journal 'Precision du pointeur amelioree (acceleration souris)' 'Activee' 'Desactivee' 'Le meme geste de la souris donne toujours le meme deplacement : visee plus reguliere en jeu.'
                Write-Log '   Acceleration de la souris coupee.'
            }
            'demrapide' { Set-Reg 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power' 'HiberbootEnabled' 0; Write-Log '   Demarrage rapide coupe.' }
            'trim' {
                Run-Ext 'fsutil.exe' 'behavior set DisableDeleteNotify 0' | Out-Null
                Ajouter-Journal 'TRIM du SSD' 'Desactive' 'Active' 'Windows previent le SSD des fichiers effaces : il garde sa vitesse dans le temps.'
                Write-Log '   TRIM active.'
            }
            'pagefile' {
                Get-CimInstance Win32_ComputerSystem | Set-CimInstance -Property @{ AutomaticManagedPagefile = $true }
                Ajouter-Journal 'Fichier d''echange (memoire virtuelle)' 'Taille manuelle' 'Gere par Windows' 'Windows ajuste lui-meme la memoire virtuelle : evite les crashs "memoire insuffisante" dans les gros jeux.'
                Write-Log '   Fichier d''echange gere par Windows (actif apres redemarrage).'
            }
            'capture' {
                Set-Reg 'HKCU:\System\GameConfigStore' 'GameDVR_Enabled' 0
                Set-Reg 'HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR' 'AppCaptureEnabled' 0
                Write-Log '   Capture en arriere-plan coupee.'
            }
            'transparence' { Set-Reg 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize' 'EnableTransparency' 0; Write-Log '   Transparence coupee.' }
        }
    }
    $script:SourceAction = $null
    Actualiser-Infos
}

function Calculer-Conseils($i) {
    $L = New-Object System.Collections.ArrayList
    $ajout = { param($niv, $txt, $actions, $id, $etapes) [void]$L.Add([pscustomobject]@{ N = $niv; T = $txt; A = @($actions); Id = $id; E = $etapes }) }
    $yt = { param($q) 'https://www.youtube.com/results?search_query=' + [uri]::EscapeDataString($q) }
    $gg = { param($q) 'https://www.google.com/search?q=' + [uri]::EscapeDataString($q) }
    $cpuNom = "$($i.Cpu.Name)".Trim()
    $ryzen = $cpuNom -match 'Ryzen'
    $carte = ("$($i.Board.Manufacturer) $($i.Board.Product)" -replace 'Micro-Star International Co\., Ltd\.?', 'MSI' -replace 'ASUSTeK COMPUTER INC\.?', 'ASUS' -replace 'Gigabyte Technology Co\., Ltd\.?', 'Gigabyte').Trim()
    $amdSoft = 'C:\Program Files\AMD\CNext\CNext\RadeonSoftware.exe'
    $btnAmdSoft = if (Test-Path $amdSoft) { ,@('Ouvrir AMD Software', $amdSoft) } else { $null }
    $urlAmd = 'https://www.amd.com/fr/support/downloads/drivers.html'
    $urlNvidia = 'https://www.nvidia.com/fr-fr/drivers/'

    # --- RAM : frequence (XMP / DOCP / EXPO) ---
    if ($i.RamCfg) {
        $seuil = if ($i.RamType -eq 'DDR5') { 5200 } else { 2900 }
        if ($i.RamCfg -lt $seuil -or ($i.RamMax -and $i.RamCfg -lt $i.RamMax)) {
            $t = "Ta RAM tourne a $($i.RamCfg) MHz. Si ta barrette le permet, active le profil XMP (appele DOCP ou EXPO sur les cartes meres AMD) dans le BIOS pour la passer a sa vraie vitesse (souvent 3200 ou 3600 MHz)."
            if ($ryzen) { $t += " Sur un Ryzen, c'est le reglage qui rapporte le plus : souvent +10 a 20 % d'images par seconde dans les jeux gourmands en processeur." }
            $t += " Ca se regle uniquement dans le BIOS : le bouton ci-dessous y redemarre directement."
            & $ajout 'A FAIRE' $t @(
                @('Redemarrer dans le BIOS', 'bios:'),
                @('Video : activer DOCP / XMP', (& $yt "activer DOCP XMP BIOS $carte")),
                @('Manuel de ta carte mere', (& $gg "$carte manuel PDF"))) $null "1. Clique sur Redemarrer dans le BIOS (le PC redemarre tout seul dans le BIOS).`r`n2. Cherche XMP, DOCP ou EXPO (souvent dans l'onglet OC, Ai Tweaker ou Extreme Tweaker).`r`n3. Choisis Profil 1 (ou Enabled).`r`n4. Appuie sur F10 puis Oui pour enregistrer et redemarrer.`r`n5. Reviens dans OptiGame > Composants : la frequence de la RAM doit avoir augmente.`r`nSi le PC ne demarre plus : il revient tout seul aux reglages d'origine apres 2-3 essais."
        } else {
            & $ajout 'OK' "RAM a $($i.RamCfg) MHz : le profil XMP / DOCP semble actif." @()
        }
    }
    # --- RAM : nombre de barrettes ---
    if ($i.Ram.Count -eq 1) {
        & $ajout 'A FAIRE' "Une seule barrette de RAM : le processeur n'utilise qu'un canal memoire. Passer a 2 barrettes identiques (ex : 2 x 8 Go) donne un vrai gain en jeu." @(
            @('Video : le dual channel explique', (& $yt 'dual channel RAM gain FPS explication')),
            @('Quels slots sur ta carte mere', (& $gg "$carte slots RAM dual channel")))
    } elseif ($i.Ram.Count -ge 2) {
        & $ajout 'OK' "$($i.Ram.Count) barrettes de RAM : double canal possible. Verifie qu'elles sont dans les slots conseilles par le manuel (souvent A2 et B2)." @(
            @('Quels slots sur ta carte mere', (& $gg "$carte slots RAM dual channel")))
    }
    if ($i.RamTot -and $i.RamTot -lt 16) {
        & $ajout 'INFO' "$($i.RamTot) Go de RAM : 16 Go est aujourd'hui le minimum confortable pour jouer." @(
            ,@('Video : ajouter de la RAM', (& $yt 'comment installer barrette RAM PC fixe'))) 'ram16'
    }
    # --- Carte graphique ---
    foreach ($g in $i.Gpus) {
        if ($g.DriverDate -is [datetime]) {
            $age = ((Get-Date) - $g.DriverDate).Days
            $estAmd = $g.Name -match 'Radeon|AMD'
            $estNv = $g.Name -match 'NVIDIA|GeForce'
            if ($age -gt 120) {
                $acts = @()
                if ($estAmd) { $acts += ,@('Telecharger le pilote AMD', $urlAmd); $acts += ,@('Video : mettre a jour', (& $yt 'mettre a jour pilote AMD Adrenalin')) }
                elseif ($estNv) { $acts += ,@('Telecharger le pilote NVIDIA', $urlNvidia); $acts += ,@('Video : mettre a jour', (& $yt 'mettre a jour pilote NVIDIA')) }
                else { $acts += ,@('Chercher le pilote', (& $gg "$($g.Name) pilote")) }
                & $ajout 'A FAIRE' ("Le pilote de ta {0} date d'environ {1} mois. Mets-le a jour : les nouveaux pilotes corrigent souvent des saccades et ameliorent les FPS." -f $g.Name, [math]::Round($age / 30)) $acts $null "1. Clique sur Telecharger le pilote.`r`n2. Prends l'installation automatique (AMD Software ou NVIDIA App).`r`n3. Choisis l'installation propre / minimale si proposee.`r`n4. Redemarre le PC apres l'installation."
            } else {
                & $ajout 'OK' "Pilote de ta $($g.Name) recent ($(D8 $g.DriverDate))." @()
            }
        }
    }
    $rx = @($i.Gpus | Where-Object { $_.Name -match 'RX [6-9]\d{3}' })
    if ($cpuNom -match 'Ryzen \d+ [5-9]\d{3}' -and $rx.Count -gt 0) {
        $acts = @(@('Redemarrer dans le BIOS', 'bios:'), @('Video : activer SAM', (& $yt "activer Smart Access Memory Resizable BAR $carte")))
        if ($btnAmdSoft) { $acts += $btnAmdSoft }
        & $ajout 'INFO' "Smart Access Memory (Resizable BAR) : ton $cpuNom et ta $($rx[0].Name) sont compatibles. Dans le BIOS (a jour), active 'Above 4G Decoding' et 'Re-Size BAR Support', puis verifie dans AMD Software > Performances > Reglages. Gain de 0 a 10 % selon les jeux. Windows doit etre installe en mode UEFI (CSM desactive)." $acts 'sam'
    }
    if (@($i.Gpus | Where-Object { $_.Name -match 'Radeon' }).Count -gt 0) {
        $acts = @(,@('Video : Radeon Anti-Lag', (& $yt 'Radeon Anti-Lag activer AMD Software')))
        if ($btnAmdSoft) { $acts += $btnAmdSoft }
        & $ajout 'INFO' "Dans AMD Software, active Radeon Anti-Lag pour les jeux competitifs : la souris reagit plus vite." $acts 'antilag'
    }
    if ($ryzen -and $i.Chipset) {
        & $ajout 'OK' "Pilotes chipset AMD installes (version $($i.Chipset.DisplayVersion)). Pense a les mettre a jour de temps en temps." @(
            ,@('Verifier les mises a jour', $urlAmd))
    } elseif ($ryzen) {
        & $ajout 'INFO' "Installe les derniers pilotes chipset AMD : ils aident Windows a bien repartir le travail sur les coeurs du Ryzen." @(
            @('Site AMD (chipset)', $urlAmd),
            @('Video : installer le chipset AMD', (& $yt 'installer pilote chipset AMD Ryzen')))
    }
    # --- Ecran (lecture en direct) ---
    foreach ($e in $i.Ecrans) {
        if ($e.Max -gt $e.Hz) {
            & $ajout 'A FAIRE' "$($e.Nom) regle a $($e.Hz) Hz alors qu'il peut monter a $($e.Max) Hz. Passe-le a $($e.Max) Hz dans les parametres d'affichage avances : l'image sera beaucoup plus fluide en jeu." @(
                @('Ouvrir le reglage', 'ms-settings:display-advanced'),
                @('Video : changer la frequence', (& $yt 'changer frequence ecran 144 Hz Windows 11'))) $null "1. Clique sur Ouvrir le reglage.`r`n2. Choisis l'ecran concerne en haut.`r`n3. Dans Choisir une frequence d'actualisation, prends $($e.Max) Hz.`r`n4. Si la valeur n'apparait pas : utilise un cable DisplayPort (ou HDMI 2.0+) branche sur la carte graphique, pas sur la carte mere."
        } else {
            & $ajout 'OK' "$($e.Nom) a $($e.Hz) Hz, le maximum qu'il propose." @()
        }
    }
    # --- Stockage ---
    if ($i.CTotal -gt 0) {
        $pct = $i.CLibre / $i.CTotal * 100
        if ($pct -lt 15) {
            & $ajout 'A FAIRE' ("Il ne reste que {0:N0} Go libres sur C: ({1:N0} %). Un SSD trop plein ralentit : garde au moins 15 % de libre." -f ($i.CLibre / 1GB), $pct) @(
                @('Voir ce qui prend de la place', 'ms-settings:storagesense'),
                @('Desinstaller des jeux / applis', 'ms-settings:appsfeatures')) $null "1. Lance le bouton Nettoyage d'OptiGame (fichiers temporaires, caches).`r`n2. Clique sur Voir ce qui prend de la place.`r`n3. Desinstalle les jeux et applis que tu n'utilises plus.`r`n4. Deplace photos et videos sur un autre disque."
        } else {
            & $ajout 'OK' ("{0:N0} Go libres sur C:." -f ($i.CLibre / 1GB)) @()
        }
    }
    foreach ($d in $i.Disks) {
        if ("$($d.HealthStatus)" -ne 'Healthy' -and "$($d.HealthStatus)" -ne '') {
            & $ajout 'ALERTE' "Le disque $($d.FriendlyName) signale un probleme de sante ($(Trad-Sante $d.HealthStatus)). Sauvegarde tes fichiers importants." @(
                @('Sauvegarde Windows', 'ms-settings:backup'),
                @('Video : sauvegarder ses fichiers', (& $yt 'sauvegarder ses fichiers Windows 11 disque externe')))
        }
    }
    # --- Reseau ---
    $eth  = @($i.Nets | Where-Object { -not (Est-WiFi $_) })
    $wifi = @($i.Nets | Where-Object { Est-WiFi $_ })
    $ethUp  = @($eth  | Where-Object { $_.Status -eq 'Up' })
    $wifiUp = @($wifi | Where-Object { $_.Status -eq 'Up' })
    if ($ethUp.Count -eq 0 -and $wifiUp.Count -gt 0 -and $eth.Count -gt 0) {
        & $ajout 'A FAIRE' "Tu es connecte en Wi-Fi alors que ton PC a une carte Ethernet ($($eth[0].InterfaceDescription)). Pour jouer, branche un cable : ping plus bas et surtout plus stable." @(
            @('Etat du reseau', 'ms-settings:network-status'),
            @('Video : Wi-Fi ou cable ?', (& $yt 'wifi ou cable ethernet gaming ping difference')))
    } elseif ($ethUp.Count -gt 0) {
        $e0 = $ethUp[0]
        if ($e0.ReceiveLinkSpeed -and $e0.ReceiveLinkSpeed -lt 1000000000) {
            & $ajout 'A FAIRE' "Ta carte Ethernet n'est connectee qu'a $($e0.LinkSpeed). Verifie le cable (Cat 5e ou Cat 6 minimum) et le port de la box." @(
                @('Video : choisir son cable', (& $yt 'cable ethernet cat 5e cat 6 difference')))
        } else {
            & $ajout 'OK' "Connecte en Ethernet a $($e0.LinkSpeed)." @()
        }
        if ("$($e0.InterfaceDescription)" -match '2\.5 ?G' -and $e0.ReceiveLinkSpeed -and $e0.ReceiveLinkSpeed -le 1000000000) {
            & $ajout 'INFO' "Ta carte est en 2.5 Gb/s mais tourne a 1 Gb/s : c'est normal si ta box n'a que des ports 1 Gb/s. Ca ne change rien au ping." @()
        }
        if ($wifiUp.Count -gt 0) {
            & $ajout 'INFO' "Wi-Fi et Ethernet sont actifs en meme temps. Windows utilise normalement l'Ethernet, mais tu peux couper le Wi-Fi pour etre sur." @(
                ,@('Reglages Wi-Fi', 'ms-settings:network-wifi'))
        }
    }
    # --- Windows ---
    if ($i.Vbs -eq $true -and "$($i.VbsReg)" -eq '0') {
        & $ajout 'A FAIRE' "Tu as desactive l'isolation du noyau : redemarre le PC pour que ce soit pris en compte." @(
            ,@('Redemarrer maintenant', 'reboot:'))
    } elseif ($i.Vbs -eq $true) {
        & $ajout 'INFO' "L'isolation du noyau (integrite de la memoire) est active. Elle protege Windows mais peut couter quelques % d'images par seconde. Tu peux la couper si tu veux, en sachant que ton PC sera un peu moins protege. L'appli n'y touche pas." @(
            @('Ouvrir le reglage', 'windowsdefender://coreisolation'),
            @('Video : explication', (& $yt 'integrite de la memoire Windows 11 jeux FPS'))) 'vbs'
    } elseif ($i.Vbs -eq $false) {
        & $ajout 'OK' 'Isolation du noyau desactivee (pas de perte de performance de ce cote).' @()
    }
    if ($i.Plan -match 'lev|Ultime|High|Ultimate|Performance') {
        & $ajout 'OK' "Plan d'alimentation : $($i.Plan)." @()
    } else {
        & $ajout 'INFO' "Plan d'alimentation actuel : $($i.Plan). Le bouton Optimiser les performances le passe en Performances elevees." @(
            ,@('Options d''alimentation', 'powercfg.cpl'))
    }
    try {
        $av = Etat-Antivirus
        if (-not $av.Defender -and $av.Tiers.Count -eq 0) {
            & $ajout 'ALERTE' "Aucun antivirus actif detecte : ton PC n'est pas protege." @(,@('Ouvrir la page Antivirus', 'av:'))
        } elseif ($av.Defender -and -not $av.Tiers.Count -and -not $av.TempsReel) {
            & $ajout 'ALERTE' "La protection antivirus en temps reel est coupee : ton PC n'est pas protege en continu." @(,@('Ouvrir la page Antivirus', 'av:'))
        } elseif ($av.Defender -and $av.SigDate -and ((Get-Date) - $av.SigDate).TotalDays -ge 7) {
            & $ajout 'A FAIRE' "Les definitions de virus n'ont pas ete mises a jour depuis $([int]((Get-Date) - $av.SigDate).TotalDays) jours." @(,@('Ouvrir la page Antivirus', 'av:'))
        } else {
            & $ajout 'OK' "Antivirus actif$(if ($av.Tiers.Count) { " ($($av.Tiers[0]))" } else { ' (Microsoft Defender)' }) et a jour." @()
        }
    } catch {}
    if (Recherche-Cassee) {
        & $ajout 'ALERTE' "La recherche Windows est bloquee (elle s'affiche vide). C'est un reglage laisse par une ancienne version d'OptiGame : un clic suffit a la reparer." @(
            ,@('Reparer la recherche', 'repsearch:'))
    }
    if ("$($i.Hags)" -eq '2') { & $ajout 'OK' 'Planification GPU (HAGS) activee.' @() }
    else {
        & $ajout 'INFO' 'Planification GPU (HAGS) non activee : le bouton Optimiser les performances l''active.' @(
            ,@('Voir le reglage', 'ms-settings:display-advancedgraphics'))
    }
    # ================= Analyse approfondie (v3) =================
    $x = $i.Plus
    if ($x) {
        if ($x.RedemAttente) {
            & $ajout 'A FAIRE' "Une mise a jour de Windows attend un redemarrage pour se terminer. Tant que ce n'est pas fait, Windows peut ralentir et des pilotes peuvent mal fonctionner." @(
                @('Redemarrer maintenant', 'reboot:'), @('Windows Update', 'ms-settings:windowsupdate')) $null "1. Enregistre ton travail.`r`n2. Clique sur Redemarrer maintenant (le PC redemarre dans 10 secondes).`r`n3. Laisse Windows finir la mise a jour (ne l'eteins pas pendant les pourcentages)."
        }
        if ($x.DerniereMaj -is [datetime]) {
            $j = [int]((Get-Date) - $x.DerniereMaj).TotalDays
            if ($j -gt 45) {
                & $ajout 'A FAIRE' "Aucune mise a jour de Windows installee depuis $j jours. Les mises a jour corrigent des failles de securite et parfois des problemes de performance en jeu." @(
                    @('Ouvrir Windows Update', 'ms-settings:windowsupdate'), @('Video : mettre a jour Windows 11', (& $yt 'mettre a jour Windows 11 Windows Update'))) 'majwin' "1. Clique sur Ouvrir Windows Update.`r`n2. Clique sur Rechercher des mises a jour.`r`n3. Installe tout, puis redemarre le PC."
            } else { & $ajout 'OK' "Windows a jour (derniere mise a jour il y a $j jours)." @() }
        }
        if ($x.SourisAccel) {
            & $ajout 'A FAIRE' "L'acceleration de la souris de Windows (Ameliorer la precision du pointeur) est active : un geste rapide deplace plus le curseur qu'un geste lent, ta visee change selon ta vitesse. Les joueurs la coupent toujours." @(
                @('Couper pour moi', 'fix:souris'), @('Video : explication', (& $yt 'desactiver ameliorer la precision du pointeur jeux'))) 'souris' "Le plus simple : clique sur Couper pour moi (c'est immediat).`r`nA la main : Parametres > Bluetooth et appareils > Souris > Parametres de souris supplementaires > Options du pointeur > decoche Ameliorer la precision du pointeur."
        } elseif ($x.SourisAccel -eq $false) { & $ajout 'OK' 'Acceleration de la souris coupee : visee reguliere.' @() }
        if ($x.Capture) {
            & $ajout 'A FAIRE' "La capture en arriere-plan de la Xbox Game Bar est active : Windows enregistre en permanence les dernieres minutes de jeu, ce qui coute des FPS et de la memoire." @(
                @('Couper pour moi', 'fix:capture'), @('Ouvrir le reglage', 'ms-settings:gaming-gamedvr')) 'capture' "Clique sur Couper pour moi.`r`nA la main : Parametres > Jeux > Captures > desactive Enregistrer ce qui s'est passe."
        }
        $nbDem = @($x.Demarrage).Count
        if ($nbDem -gt 8) {
            $noms = (@($x.Demarrage) | Select-Object -First 12) -join ', '
            & $ajout 'A FAIRE' "$nbDem programmes se lancent avec Windows ($noms...). Chacun ralentit le demarrage et prend de la memoire en jeu." @(
                @('Ouvrir les applis de demarrage', 'ms-settings:startupapps'), @('Video : desactiver les applis au demarrage', (& $yt 'desactiver applications demarrage Windows 11'))) 'demarrage' "1. Clique sur Ouvrir les applis de demarrage.`r`n2. Desactive tout ce qui n'est pas indispensable (Discord, Steam, Epic, Spotify, OneDrive... se lancent quand tu en as besoin).`r`n3. Garde : pilote audio, pilote graphique (AMD / NVIDIA), antivirus.`r`n4. Redemarre le PC."
        } elseif ($nbDem -gt 0) { & $ajout 'OK' "$nbDem programme(s) au demarrage de Windows : raisonnable." @() }
        if ($x.Trim -eq $false) {
            & $ajout 'ALERTE' "Le TRIM est desactive : ton SSD n'est pas prevenu des fichiers effaces et ralentit avec le temps." @(
                ,@('Activer pour moi', 'fix:trim')) $null "Clique sur Activer pour moi (sans risque, immediat)."
        } elseif ($x.Trim) { & $ajout 'OK' 'TRIM actif : le SSD garde sa vitesse.' @() }
        if ($x.DisqueC -and $x.DisqueC.Type -eq 'HDD') {
            & $ajout 'A FAIRE' "Windows est installe sur un disque dur classique ($($x.DisqueC.Nom)). C'est le plus gros frein possible : demarrage, chargements, saccades. Un SSD (meme d'entree de gamme) change tout." @(
                @('Video : passer Windows sur un SSD', (& $yt 'cloner Windows sur SSD tutoriel')), @('Comparer des SSD', (& $gg 'meilleur SSD NVMe rapport qualite prix'))) 'hdd'
        } elseif ($x.DisqueC) { & $ajout 'OK' "Windows sur SSD ($($x.DisqueC.Bus))." @() }
        if ($x.PagefileAuto -eq $false) {
            & $ajout 'A FAIRE' "La memoire virtuelle (fichier d'echange) est reglee a la main. Mal reglee, elle provoque des crashs \"memoire insuffisante\" dans les gros jeux (Palworld, Call of Duty...)." @(
                ,@('Laisser Windows gerer', 'fix:pagefile')) 'pagefile' "Clique sur Laisser Windows gerer, puis redemarre le PC."
        }
        if ($x.ModeEco) {
            & $ajout 'ALERTE' "Le mode d'alimentation de Windows est sur Meilleure efficacite energetique : le processeur est bride en permanence." @(
                ,@('Ouvrir le reglage', 'ms-settings:powersleep')) $null "1. Clique sur Ouvrir le reglage.`r`n2. Mode d'alimentation : choisis Meilleures performances."
        }
        if ($x.Transparence) {
            & $ajout 'INFO' "Les effets de transparence de Windows sont actifs. Les couper soulage un peu la carte graphique et rend Windows plus reactif." @(
                @('Couper pour moi', 'fix:transparence'), @('Ouvrir le reglage', 'ms-settings:colors')) 'transparence'
        }
        if ($x.DemRapide) {
            & $ajout 'INFO' "Le demarrage rapide de Windows est actif : le PC ne s'eteint jamais vraiment, ce qui garde des bugs de pilotes d'une session a l'autre. Le couper rend les redemarrages plus propres (demarrage 2-3 s plus long)." @(
                ,@('Couper pour moi', 'fix:demrapide')) 'demrapide'
        }
        if ($x.NbProcessus -gt 280) {
            & $ajout 'INFO' "$($x.NbProcessus) processus tournent en ce moment. Avant de jouer, le Mode Boost ferme les applis inutiles." @(
                ,@('Ouvrir le Gestionnaire des taches', 'taskmgr.exe')) 'processus'
        }
        foreach ($sd in @($x.Sante | Where-Object { $_ })) {
            $txt = $null
            if ("$($sd.Etat)" -and "$($sd.Etat)" -ne 'Healthy') { $txt = "Le disque $($sd.Nom) signale un probleme de sante ($(Trad-Sante $sd.Etat)). Sauvegarde tes fichiers importants des maintenant." }
            elseif ($null -ne $sd.Usure -and [int]$sd.Usure -ge 80) { $txt = "Le SSD $($sd.Nom) est use a $($sd.Usure) %. Il approche de la fin de sa duree de vie : sauvegarde tes fichiers et prevois de le remplacer." }
            elseif ($sd.Temp -and [int]$sd.Temp -ge 70) { $txt = "Le disque $($sd.Nom) chauffe ($($sd.Temp) $([char]0xB0)C). Un SSD trop chaud ralentit : ajoute un dissipateur (souvent fourni avec la carte mere) ou ameliore l'aeration." }
            if ($txt) { & $ajout 'ALERTE' $txt @(,@('Voir les composants', 'nav:NavInfos')) }
        }
        foreach ($dp in @($x.DisquesPleins)) {
            & $ajout 'A FAIRE' ("Le disque {0} est presque plein ({1:N0} Go libres sur {2:N0} Go). Les jeux s'y mettent a jour moins bien et chargent plus lentement." -f $dp.Lettre, ($dp.Libre / 1GB), ($dp.Total / 1GB)) @(
                ,@('Voir ce qui prend de la place', 'ms-settings:storagesense'))
        }
    }
    # BIOS ancien
    if ($i.Bios -and $i.Bios.ReleaseDate -is [datetime]) {
        $ans = ((Get-Date) - $i.Bios.ReleaseDate).TotalDays / 365
        if ($ans -gt 2.5) {
            & $ajout 'INFO' ("Le BIOS de ta carte mere ({0}) date de {1}. Les mises a jour de BIOS ameliorent la stabilite de la RAM, la compatibilite et parfois les performances (surtout sur Ryzen)." -f $carte, $i.Bios.ReleaseDate.ToString('MM/yyyy')) @(
                @('Page support de ta carte mere', (& $gg "$carte BIOS download support")), @('Video : mettre a jour le BIOS', (& $yt "mettre a jour BIOS $carte"))) 'bios' "1. Ouvre la page support de ta carte mere et telecharge le dernier BIOS.`r`n2. Mets-le sur une cle USB (format FAT32).`r`n3. Redemarre dans le BIOS et utilise l'outil de mise a jour (M-Flash, EZ Flash, Q-Flash selon la marque).`r`n4. Ne coupe JAMAIS le courant pendant la mise a jour.`r`n5. Apres la mise a jour, reactive le profil XMP / DOCP (il est remis par defaut)."
        }
    }
    if ($i.Uptime.Days -ge 7) {
        & $ajout 'A FAIRE' "Ton PC n'a pas redemarre depuis $($i.Uptime.Days) jours. Un redemarrage libere la memoire et applique les mises a jour." @(
            @('Redemarrer maintenant', 'reboot:'),
            @('Windows Update', 'ms-settings:windowsupdate'))
    }

    return @($L)
}

# (Remplir-Conseils : defini dans l'interface v2)

# (Actualiser-Infos : defini dans l'interface v2)

# (Copier-Infos : defini dans l'interface v2)

# =====================================================================
#  ERREURS (onglet Erreurs) : enregistrement + diagnostic automatique
# =====================================================================
$ErreursFichier = Join-Path $env:ProgramData 'OptiGame\erreurs.json'
$script:Erreurs = New-Object System.Collections.ArrayList

function Charger-Erreurs {
    $script:Erreurs.Clear()
    if (Test-Path $ErreursFichier) {
        try { foreach ($e in (Get-Content $ErreursFichier -Raw | ConvertFrom-Json)) { [void]$script:Erreurs.Add($e) } } catch {}
    }
}

function Sauver-Erreurs {
    New-Item -ItemType Directory -Path (Split-Path $ErreursFichier) -Force | Out-Null
    while ($script:Erreurs.Count -gt 50) { $script:Erreurs.RemoveAt(0) }
    ConvertTo-Json -InputObject @($script:Erreurs.ToArray()) -Depth 4 | Out-File -FilePath $ErreursFichier -Encoding UTF8
}

function Diagnostiquer-Erreur([string]$texte) {
    # Renvoie une cause probable + une action proposee (cle traitee par Corriger-Erreur)
    $t = $texte
    if ($t -match 'CommandInfo|bloc de script|script block|Index.*(hors|outside)|null-valued|valeur null|ne peut pas appeler une m.thode') {
        return @{ Cause = "Bug interne d'OptiGame (une etape n'a pas trouve ce qu'elle attendait). Ce n'est pas un probleme de ton PC. Arrete le test pour tout remettre, puis copie l'erreur et envoie-la pour correction."; Action = 'arret-test'; Label = 'Arreter le test et tout remettre' }
    }
    if ($t -match 'Crash probable de (.+?) \d+ s') {
        $jeu = $Matches[1]
        return @{ Cause = "Le jeu s'est ferme juste apres son lancement. Pour savoir si c'est l'optimisation : remets ce jeu comme avant et relance-le. S'il ne plante plus, reapplique les options une par une pour trouver la coupable. S'il plante encore, ce n'est pas l'optimisation du jeu : regarde le module en cause dans le rapport Windows ci-dessous (ex : un fichier amd... = pilote graphique a mettre a jour) et envoie-le a Claude."; Action = "restaurer-jeu:$jeu"; Label = "Remettre $jeu comme avant" }
    }
    if ($t -match 'Checkpoint-Computer|restauration|restore point|SystemRestore') {
        return @{ Cause = "La creation du point de restauration a echoue. La protection du systeme est peut-etre desactivee sur C:."; Action = 'protection'; Label = 'Ouvrir la protection du systeme' }
    }
    if ($t -match 'ScheduledTask|tache planifi|Task Scheduler') {
        return @{ Cause = "Windows a refuse de programmer la relance automatique (souvent un antivirus). Utilise plutot le test rapide, sans redemarrage."; Action = ''; Label = '' }
    }
    if ($t -match 'Acc.s refus|Access.*denied|UnauthorizedAccess|PermissionDenied|0x80070005') {
        return @{ Cause = "Acces refuse : OptiGame n'a pas les droits administrateur, ou un antivirus bloque la modification. Relance OptiGame avec Lancer_OptiGame.bat et accepte la demande d'autorisation."; Action = ''; Label = '' }
    }
    if ($t -match 'NetAdapter|Ethernet|MSFT_Net') {
        return @{ Cause = "Probleme en lisant ou reglant la carte reseau (pilote de la carte reseau pas a jour ou carte debranchee). Le reste de l'optimisation n'est pas touche."; Action = 'reseau'; Label = 'Ouvrir le Gestionnaire de peripheriques' }
    }
    if ($t -match 'CIM|WMI|0x8004|RPC') {
        return @{ Cause = "Le service d'informations de Windows (WMI) n'a pas repondu. Un redemarrage du PC regle presque toujours ce probleme."; Action = 'reboot'; Label = 'Redemarrer le PC' }
    }
    if ($t -match 'espace|disk.*full|not enough space|0x80070070') {
        return @{ Cause = "Plus assez d'espace disque pour terminer l'operation."; Action = 'stockage'; Label = 'Voir l''espace disque' }
    }
    return @{ Cause = "Cause inconnue. Copie l'erreur avec le bouton ci-dessous et envoie-la pour qu'on regarde."; Action = ''; Label = '' }
}

function Noter-Erreur([string]$ou, $er) {
    try {
        $msg = if ($er -is [System.Management.Automation.ErrorRecord]) { $er.Exception.Message } else { "$er" }
        $d = New-Object System.Text.StringBuilder
        [void]$d.AppendLine("OptiGame - erreur du $((Get-Date).ToString('dd/MM/yyyy HH:mm:ss'))")
        [void]$d.AppendLine("Ou : $ou")
        [void]$d.AppendLine("Message : $msg")
        if ($er -is [System.Management.Automation.ErrorRecord]) {
            [void]$d.AppendLine("Type : $($er.Exception.GetType().FullName)")
            if ($er.InvocationInfo) {
                [void]$d.AppendLine("Ligne $($er.InvocationInfo.ScriptLineNumber) : $("$($er.InvocationInfo.Line)".Trim())")
            }
            if ($er.ScriptStackTrace) { [void]$d.AppendLine("Pile :"); [void]$d.AppendLine($er.ScriptStackTrace) }
        }
        if ($script:Etat) {
            [void]$d.AppendLine("Test : phase=$($script:Etat.Phase) lot=$($script:Etat.LotCourant) file=$(@($script:Etat.File) -join ',') rapide=$($script:Etat.SansReboot)")
        }
        $os = Get-CimInstance Win32_OperatingSystem -ErrorAction SilentlyContinue
        [void]$d.AppendLine("Windows : $($os.Caption) build $($os.BuildNumber) - PowerShell $($PSVersionTable.PSVersion)")
        $fichier = Get-Item $script:CheminScript -ErrorAction SilentlyContinue
        if ($fichier) { [void]$d.AppendLine("OptiGame.ps1 du $($fichier.LastWriteTime.ToString('dd/MM/yyyy HH:mm'))") }
        $detail = $d.ToString()
        $diag = Diagnostiquer-Erreur $detail
        [void]$script:Erreurs.Add([pscustomobject]@{
            Date = (Get-Date).ToString('dd/MM/yyyy HH:mm'); Ou = $ou; Message = $msg
            Detail = $detail; Cause = $diag.Cause; Action = $diag.Action; Label = $diag.Label })
        Sauver-Erreurs
        Remplir-Erreurs
        Write-Log 'Detail et cause probable dans l''onglet Erreurs.' 'Gold'
    } catch {}
}

# (Remplir-Erreurs : defini dans l'interface v2)

# (Afficher-Erreur : defini dans l'interface v2)

function Corriger-Erreur([string]$action) {
    switch ($action) {
        'arret-test' {
            if (-not (Test-Path $EtatFichier) -and -not $script:Etat) {
                Show-Info 'Aucun test en cours : rien a remettre.'; return
            }
            if (Ask-YesNo 'Arreter le test et remettre tous les reglages comme avant ?') { Arreter-Test }
        }
        'protection' { Start-Process 'SystemPropertiesProtection.exe' }
        'reseau'     { Start-Process 'devmgmt.msc' }
        'reboot'     { Ouvrir-Lien 'reboot:' }
        'stockage'   { Start-Process 'ms-settings:storagesense' }
        { $_ -like 'restaurer-jeu:*' } {
            $jeu = $action.Substring(14)
            if (-not $Jeux[$jeu]) { return }
            if (Jeu-EnCours $jeu) { Show-Info "Ferme $jeu d'abord."; return }
            if (-not (Ask-YesNo "Remettre les reglages d'origine de $jeu ?")) { return }
            Invoke-Action "Retour aux reglages d'origine : $jeu" { Restaurer-Jeu $jeu }
            (Get-ChoixJeu $jeu).Appliques = @()
            Sauver-ChoixJeux
            if ($script:JeuSel -eq $jeu) { Remplir-OptionsJeu $jeu }
        }
    }
}

# =====================================================================
#  OUTILS DES OPTIMISATIONS PAR JEU
#  Sauvegarde des fichiers d'origine avant toute modification,
#  pour pouvoir tout remettre avec "Remettre comme avant".
# =====================================================================
$DossierSauv = Join-Path $env:ProgramData 'OptiGame\sauvegardes'

function Dossier-SauvJeu([string]$jeu) { return Join-Path $DossierSauv ($jeu -replace '[^A-Za-z0-9]', '_') }

function Lire-IndexJeu([string]$jeu) {
    $l = New-Object System.Collections.ArrayList
    $f = Join-Path (Dossier-SauvJeu $jeu) 'index.json'
    if (Test-Path $f) { try { foreach ($e in (Get-Content $f -Raw | ConvertFrom-Json)) { [void]$l.Add($e) } } catch {} }
    return ,$l
}

function Ecrire-IndexJeu([string]$jeu, $liste) {
    $d = Dossier-SauvJeu $jeu
    New-Item -ItemType Directory -Path $d -Force | Out-Null
    ConvertTo-Json -InputObject @($liste.ToArray()) -Depth 4 | Out-File -FilePath (Join-Path $d 'index.json') -Encoding UTF8
}

function Sauver-Original([string]$jeu, [string]$fichier) {
    # Copie le fichier d'origine une seule fois (la premiere modification)
    $idx = Lire-IndexJeu $jeu
    if ($idx | Where-Object { $_.Type -eq 'fichier' -and $_.Orig -eq $fichier }) { return }
    if (-not (Test-Path $fichier)) { return }
    $d = Dossier-SauvJeu $jeu
    New-Item -ItemType Directory -Path $d -Force | Out-Null
    $copie = Join-Path $d ("{0}_{1}.orig" -f $idx.Count, [IO.Path]::GetFileName($fichier))
    Copy-Item -LiteralPath $fichier -Destination $copie -Force
    [void]$idx.Add([pscustomobject]@{ Type = 'fichier'; Orig = $fichier; Copie = $copie; LectureSeule = (Get-Item -LiteralPath $fichier).IsReadOnly })
    Ecrire-IndexJeu $jeu $idx
}

function Jeu-EnCours([string]$jeu) {
    foreach ($p in $Jeux[$jeu].Process) {
        foreach ($x in @(Get-Process -Name $p -ErrorAction SilentlyContinue)) {
            if ($FenetreObligatoire -contains $x.ProcessName -and $x.MainWindowHandle -eq [IntPtr]::Zero) { continue }
            return $true
        }
    }
    try { return (Trouver-JeuxEnCours).ContainsKey($jeu) } catch { return $false }
}

# ---------- Memoire des jeux deja vus en cours (chemin reel du .exe) ----------
$FichierMemo = Join-Path $env:ProgramData 'OptiGame\jeux_detectes.json'
function Lire-Memo {
    if ($script:MemoCache) { return $script:MemoCache }
    $h = @{}
    if (Test-Path $FichierMemo) {
        try { foreach ($p in (Get-Content $FichierMemo -Raw | ConvertFrom-Json).PSObject.Properties) { $h[$p.Name] = $p.Value } } catch {}
    }
    $script:MemoCache = $h
    return $h
}
function Noter-Memo([string]$jeu, [string]$chemin, [string]$process) {
    if (-not $chemin) { return }
    $h = Lire-Memo
    $liste = @()
    if ($h[$jeu]) { $liste = @(@($h[$jeu].Chemins) + @($h[$jeu].Chemin) | Where-Object { $_ }) }
    if ($liste -contains $chemin) { return }
    $liste = @(@($liste) + $chemin | Select-Object -Unique -Last 5)
    $h[$jeu] = [pscustomobject]@{ Chemins = $liste }
    New-Item -ItemType Directory -Path (Split-Path $FichierMemo) -Force | Out-Null
    $h | ConvertTo-Json -Depth 3 | Out-File -FilePath $FichierMemo -Encoding UTF8
}
function Exe-Memo([string]$jeu) {
    # Tous les programmes deja vus pour ce jeu (ex : lanceur Call of Duty HQ + vrai jeu)
    $m = (Lire-Memo)[$jeu]
    if (-not $m) { return @() }
    return @(@(@($m.Chemins) + @($m.Chemin)) | Where-Object { $_ -and (Test-Path -LiteralPath $_) } | Select-Object -Unique)
}

function Court-Chemin([string]$p) {
    if ($p.Length -le 75) { return $p }
    $parts = $p -split '\\'
    if ($parts.Count -le 4) { return $p }
    return $parts[0] + '\...\' + (($parts | Select-Object -Last 3) -join '\')
}

# ---------- Lecture / ecriture en gardant l'encodage du fichier ----------
function Lire-Fichier([string]$p) {
    $b = [IO.File]::ReadAllBytes($p)
    if ($b.Length -ge 2 -and $b[0] -eq 0xFF -and $b[1] -eq 0xFE) { $enc = New-Object Text.UnicodeEncoding($false, $true); $skip = 2 }
    elseif ($b.Length -ge 3 -and $b[0] -eq 0xEF -and $b[1] -eq 0xBB -and $b[2] -eq 0xBF) { $enc = New-Object Text.UTF8Encoding($true); $skip = 3 }
    else {
        $skip = 0
        $enc = New-Object Text.UTF8Encoding($false, $true)
        try { [void]$enc.GetString($b) ; $enc = New-Object Text.UTF8Encoding($false) }
        catch { $enc = [Text.Encoding]::GetEncoding(1252) }
    }
    return @{ Texte = $enc.GetString($b, $skip, $b.Length - $skip); Enc = $enc }
}

function Ecrire-Fichier([string]$p, [string]$texte, $enc) {
    $f = Get-Item -LiteralPath $p
    $ro = $f.IsReadOnly
    if ($ro) { $f.IsReadOnly = $false }
    [IO.File]::WriteAllText($p, $texte, $enc)
    if ($ro) { (Get-Item -LiteralPath $p).IsReadOnly = $true }
}

function Set-IniJeu([string]$jeu, [string]$fichier, [string]$section, [string]$cle, [string]$valeur, [string]$libelle) {
    if (-not (Test-Path $fichier)) {
        Write-Log "   Fichier de reglages introuvable : lance le jeu une fois, puis recommence." 'Gold'
        return
    }
    $c = Lire-Fichier $fichier
    $nl = if ($c.Texte -match "`r`n") { "`r`n" } else { "`n" }
    $lignes = New-Object System.Collections.Generic.List[string]
    foreach ($l in ($c.Texte -split "`r?`n")) { $lignes.Add($l) }
    $sec = ''; $idxSec = -1; $dernier = -1; $ancien = $null; $trouve = $false
    $motif = '^\s*' + [regex]::Escape($cle) + '\s*=(.*)$'
    for ($i = 0; $i -lt $lignes.Count; $i++) {
        $t = $lignes[$i].Trim()
        if ($t -match '^\[(.+)\]$') {
            $sec = $Matches[1]
            if ($sec -eq $section) { $idxSec = $i; $dernier = $i }
            continue
        }
        if ($sec -ne $section) { continue }
        if ($t -ne '') { $dernier = $i }
        if (-not $trouve -and $lignes[$i] -match $motif) {
            $ancien = $Matches[1].Trim()
            $lignes[$i] = "$cle=$valeur"
            $trouve = $true
        }
    }
    if (-not $trouve) {
        if ($idxSec -ge 0) { $lignes.Insert($dernier + 1, "$cle=$valeur") }
        else {
            while ($lignes.Count -gt 0 -and $lignes[$lignes.Count - 1].Trim() -eq '') { $lignes.RemoveAt($lignes.Count - 1) }
            if ($lignes.Count -gt 0) { $lignes.Add('') }
            $lignes.Add("[$section]"); $lignes.Add("$cle=$valeur")
        }
    }
    if ($trouve -and $ancien -eq $valeur) { Write-Log "   $libelle : deja regle." 'Gray'; return }
    if ($script:VerifEnCours) { $script:Ecarts += $libelle; return }
    Noter-CleIni $jeu $fichier $section $cle $ancien
    Ecrire-Fichier $fichier ($lignes -join $nl) $c.Enc
    $avantTxt = if ($null -eq $ancien) { 'Par defaut' } else { $ancien }
    Write-Log "   $libelle : $avantTxt $Fleche $valeur" 'Gray'
    Ajouter-Journal "$jeu : $libelle" $avantTxt $valeur
}

function Verrouiller-Fichier([string]$jeu, [string]$fichier) {
    if (-not (Test-Path $fichier)) { Write-Log '   Fichier introuvable : rien a verrouiller.' 'Gray'; return }
    $f = Get-Item -LiteralPath $fichier
    if ($f.IsReadOnly) { Write-Log "   $($f.Name) : deja verrouille." 'Gray'; return }
    if ($script:VerifEnCours) { $script:Ecarts += 'verrouillage'; return }
    Sauver-Original $jeu $fichier
    $f.IsReadOnly = $true
    Write-Log "   $($f.Name) verrouille (lecture seule)." 'Gray'
    Ajouter-Journal "$jeu : $($f.Name)" 'Modifiable' 'Verrouille'
}

# ---------- Carte graphique par jeu (Parametres Windows > Graphiques) ----------
function Set-GpuJeu([string]$jeu, [string[]]$exes) {
    $exes = @($exes | Where-Object { $_ })
    if ($exes.Count -eq 0) { Write-Log '   Jeu introuvable sur ce PC : etape ignoree.' 'Gold'; return }
    $k = 'HKCU:\Software\Microsoft\DirectX\UserGpuPreferences'
    foreach ($exe in $exes) {
        $old = Lire-Reg $k $exe
        if ("$old" -match 'GpuPreference=2;') { Write-Log "   $([IO.Path]::GetFileName($exe)) : deja en haute performance." 'Gray'; continue }
        if ($script:VerifEnCours) { $script:Ecarts += "carte graphique $([IO.Path]::GetFileName($exe))"; continue }
        $idx = Lire-IndexJeu $jeu
        if (-not ($idx | Where-Object { $_.Type -eq 'gpu' -and $_.Orig -eq $exe })) {
            [void]$idx.Add([pscustomobject]@{ Type = 'gpu'; Orig = $exe; Val = $old })
            Ecrire-IndexJeu $jeu $idx
        }
        $nouveau = if ($old) { ("$old" -replace 'GpuPreference=\d;', '') + 'GpuPreference=2;' } else { 'GpuPreference=2;' }
        Set-Reg $k $exe $nouveau 'String'
        Write-Log "   $([IO.Path]::GetFileName($exe)) : haute performance." 'Gray'
        Ajouter-Journal "$jeu : carte graphique" 'Choix de Windows' 'Haute performance'
    }
}

# ---------- Recherche des jeux installes ----------
function Get-JeuxEpic {
    $r = @()
    $d = Join-Path $env:ProgramData 'Epic\EpicGamesLauncher\Data\Manifests'
    foreach ($f in @(Get-ChildItem $d -Filter '*.item' -ErrorAction SilentlyContinue)) {
        try { $j = Get-Content $f.FullName -Raw | ConvertFrom-Json; $r += [pscustomobject]@{ Nom = $j.DisplayName; Dir = $j.InstallLocation; Exe = $j.LaunchExecutable } } catch {}
    }
    return $r
}

function Get-BibliothequesSteam {
    $libs = @()
    $steam = (Get-ItemProperty 'HKCU:\Software\Valve\Steam' -ErrorAction SilentlyContinue).SteamPath
    if (-not $steam) { $steam = "${env:ProgramFiles(x86)}\Steam" }
    $steam = $steam -replace '/', '\'
    $libs += $steam
    $vdf = Join-Path $steam 'steamapps\libraryfolders.vdf'
    if (Test-Path $vdf) {
        foreach ($m in [regex]::Matches((Get-Content $vdf -Raw), '"path"\s+"([^"]+)"')) { $libs += ($m.Groups[1].Value -replace '\\\\', '\') }
    }
    return @($libs | Select-Object -Unique)
}

function Garder-Existants([string[]]$chemins) { return @($chemins | Where-Object { $_ -and (Test-Path -LiteralPath $_) } | Select-Object -Unique) }

function Trouver-ExeFortnite {
    $c = @()
    foreach ($e in (Get-JeuxEpic | Where-Object { $_.Nom -eq 'Fortnite' })) { $c += Join-Path $e.Dir 'FortniteGame\Binaries\Win64\FortniteClient-Win64-Shipping.exe' }
    $c += "$env:ProgramFiles\Epic Games\Fortnite\FortniteGame\Binaries\Win64\FortniteClient-Win64-Shipping.exe"
    return Garder-Existants $c
}

function Trouver-ExeRocketLeague {
    $c = @()
    foreach ($e in (Get-JeuxEpic | Where-Object { $_.Nom -match 'Rocket League' })) { $c += Join-Path $e.Dir 'Binaries\Win64\RocketLeague.exe' }
    foreach ($l in Get-BibliothequesSteam) { $c += Join-Path $l 'steamapps\common\rocketleague\Binaries\Win64\RocketLeague.exe' }
    $c += "$env:ProgramFiles\Epic Games\rocketleague\Binaries\Win64\RocketLeague.exe"
    return Garder-Existants $c
}

function Trouver-ExeRoblox {
    $c = @()
    foreach ($base in @((Join-Path $env:LOCALAPPDATA 'Roblox\Versions'), (Join-Path $env:LOCALAPPDATA 'Bloxstrap\Versions'), (Join-Path $env:LOCALAPPDATA 'Fishstrap\Versions'), "${env:ProgramFiles(x86)}\Roblox\Versions", "$env:ProgramFiles\Roblox\Versions")) {
        foreach ($v in @(Get-ChildItem $base -Directory -ErrorAction SilentlyContinue)) { $c += Join-Path $v.FullName 'RobloxPlayerBeta.exe' }
    }
    return Garder-Existants $c
}

function Trouver-ExeCod {
    $c = @()
    foreach ($l in Get-BibliothequesSteam) { $c += Join-Path $l 'steamapps\common\Call of Duty HQ\cod.exe' }
    foreach ($d in @(Get-PSDrive -PSProvider FileSystem -ErrorAction SilentlyContinue)) {
        $r = $d.Root
        $c += Join-Path $r 'Program Files (x86)\Call of Duty\cod.exe'
        $c += Join-Path $r 'Program Files (x86)\Call of Duty\_retail_\cod.exe'
        $c += Join-Path $r 'Call of Duty\cod.exe'
        $c += Join-Path $r 'XboxGames\Call of Duty\Content\cod.exe'
        # Version Microsoft Store / Xbox : dossier XboxGames\<nom du jeu>\Content
        foreach ($dj in @(Get-ChildItem (Join-Path $r 'XboxGames') -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -match 'Call of Duty|Black Ops' })) {
            foreach ($f in @(Get-ChildItem (Join-Path $dj.FullName 'Content') -File -Filter '*.exe' -ErrorAction SilentlyContinue | Where-Object { $_.Name -match '^(cod|cod2\d|BlackOps\d*|boot)\.exe$' })) { $c += $f.FullName }
        }
    }
    foreach ($pk in @(Get-AppxPackage -ErrorAction SilentlyContinue | Where-Object { $_.Name -match 'CallofDuty|Activision|BlackOps' })) {
        foreach ($f in @(Get-ChildItem $pk.InstallLocation -File -Filter '*.exe' -ErrorAction SilentlyContinue | Where-Object { $_.Name -match '^(cod|cod2\d|BlackOps\d*)\.exe$' })) { $c += $f.FullName }
    }
    $c = @(Exe-Memo 'Call of Duty BO7') + $c
    return Garder-Existants $c
}

# ---------- Specifique Roblox ----------
function Set-RobloxFps([int]$fps) {
    $f = & $Jeux['Roblox'].Config
    if (-not (Test-Path $f)) { Write-Log '   Fichier de reglages Roblox introuvable : lance Roblox une fois, puis recommence.' 'Gold'; return }
    $c = Lire-Fichier $f
    $m = [regex]::Match($c.Texte, '<int name="FramerateCap">(-?\d+)</int>')
    if (-not $m.Success) { Write-Log '   Reglage FPS absent du fichier : regle "Limite de FPS" dans les parametres de Roblox.' 'Gold'; return }
    $ancien = $m.Groups[1].Value
    if ($ancien -eq "$fps") { Write-Log "   Limite FPS : deja a $fps." 'Gray'; return }
    if ($script:VerifEnCours) { $script:Ecarts += 'limite FPS'; return }
    Sauver-Original 'Roblox' $f
    $txt = $c.Texte.Substring(0, $m.Groups[1].Index) + $fps + $c.Texte.Substring($m.Groups[1].Index + $m.Groups[1].Length)
    Ecrire-Fichier $f $txt $c.Enc
    $avantTxt = if ($ancien -eq '-1') { 'Par defaut' } else { $ancien }
    Write-Log "   Limite FPS : $avantTxt $Fleche $fps" 'Gray'
    Ajouter-Journal 'Roblox : limite FPS' $avantTxt "$fps"
}

# ---------- Specifique Call of Duty ----------
function Get-FichiersCod {
    # BO7 range ses reglages dans AppData\Local (Battle.net, Steam et Xbox/Microsoft Store),
    # mais on regarde aussi Documents par securite. "btcod25" = fichiers de la beta.
    $dossiers = @((& $Jeux['Call of Duty BO7'].Config), (Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'Call of Duty\players'))
    $r = @()
    foreach ($d in $dossiers) {
        $r += @(Get-ChildItem $d -File -ErrorAction SilentlyContinue | Where-Object { $_.Name -match '^s\.1\.0\.(bt\.?)?cod2[5-9]\.txt\d*$' } | ForEach-Object { $_.FullName })
    }
    return @($r | Select-Object -Unique)
}

function Set-CodWorkers {
    $coeurs = [int](Get-CimInstance Win32_Processor | Select-Object -First 1).NumberOfCores
    if ($coeurs -lt 2) { Write-Log '   Nombre de coeurs inconnu : etape ignoree.' 'Gold'; return }
    $fichiers = Get-FichiersCod
    if ($fichiers.Count -eq 0) { Write-Log '   Fichier de reglages BO7 introuvable : lance le jeu une fois, puis recommence.' 'Gold'; return }
    $fait = $false
    foreach ($f in $fichiers) {
        $c = Lire-Fichier $f
        $m = [regex]::Match($c.Texte, '(?m)^(\s*RendererWorkerCount\b[^=\r\n]*=\s*"?)(\d+)')
        if (-not $m.Success) { continue }
        $ancien = $m.Groups[2].Value
        if ($ancien -eq "$coeurs") { Write-Log "   $([IO.Path]::GetFileName($f)) : deja a $coeurs." 'Gray'; $fait = $true; continue }
        if ($script:VerifEnCours) { $script:Ecarts += 'threads de rendu'; $fait = $true; continue }
        Sauver-Original 'Call of Duty BO7' $f
        $g = $m.Groups[2]
        $txt = $c.Texte.Substring(0, $g.Index) + $coeurs + $c.Texte.Substring($g.Index + $g.Length)
        Ecrire-Fichier $f $txt $c.Enc
        Write-Log "   $([IO.Path]::GetFileName($f)) : RendererWorkerCount $ancien $Fleche $coeurs" 'Gray'
        Ajouter-Journal 'BO7 : threads de rendu' $ancien "$coeurs"
        $fait = $true
    }
    if (-not $fait) { Write-Log '   Ligne RendererWorkerCount introuvable dans le fichier : le format a peut-etre change, rien n''a ete modifie.' 'Gold' }
}

# ---------- Specifique Palworld ----------
function Dossier-ConfigPalworld {
    # Steam = Windows, Xbox / Microsoft Store = WinGDK, anciennes versions = WindowsNoEditor
    $base = Join-Path $env:LOCALAPPDATA 'Pal\Saved\Config'
    $cands = @(foreach ($n in 'Windows', 'WinGDK', 'WindowsNoEditor') {
        $d = Join-Path $base $n
        if (Test-Path $d) { Get-Item $d }
    })
    if ($cands.Count -eq 0) { return (Join-Path $base 'Windows') }
    $avecReglages = @($cands | Where-Object { Test-Path (Join-Path $_.FullName 'GameUserSettings.ini') })
    if ($avecReglages.Count -gt 0) { $cands = $avecReglages }
    return ($cands | Sort-Object LastWriteTime -Descending | Select-Object -First 1).FullName
}

function Fichier-EnginePalworld {
    $d = Dossier-ConfigPalworld
    if (-not (Test-Path $d)) {
        Write-Log '   Dossier de reglages Palworld introuvable : lance le jeu une fois, puis recommence.' 'Gold'
        return $null
    }
    $f = Join-Path $d 'Engine.ini'
    if (-not (Test-Path $f)) { [IO.File]::WriteAllText($f, '', (New-Object Text.UTF8Encoding($false))) }
    return $f
}

function Set-PalworldStreaming {
    $f = Fichier-EnginePalworld
    if (-not $f) { return }
    $vram = 0
    foreach ($g in @(Get-CimInstance Win32_VideoController -ErrorAction SilentlyContinue | Where-Object { $_.Name -notmatch 'Basic|Virtual|Remote' })) {
        $v = Get-VramGo $g.Name
        if ($v -gt $vram) { $vram = $v }
    }
    # Repere des guides Palworld : environ 3/8 de la VRAM, sans depasser 6 Go
    $pool = if ($vram -ge 16) { 6144 } elseif ($vram -ge 10) { 4096 } elseif ($vram -ge 8) { 3072 } elseif ($vram -ge 6) { 2048 } elseif ($vram -gt 0) { 1536 } else { 3072 }
    $vtxt = if ($vram -gt 0) { "$vram Go" } else { 'inconnue' }
    Write-Log "   VRAM detectee : $vtxt $Fleche reserve de textures $pool Mo" 'Gray'
    Set-IniJeu 'Palworld' $f '/Script/Engine.RendererSettings' 'r.Streaming.PoolSize' "$pool" 'Reserve de textures (Mo)'
    Set-IniJeu 'Palworld' $f '/Script/Engine.RendererSettings' 'r.Streaming.LimitPoolSizeToVRAM' '1' 'Limiter a la VRAM'
}

function Trouver-ExePalworld {
    $c = @(Exe-Memo 'Palworld')
    foreach ($l in Get-BibliothequesSteam) { $c += Join-Path $l 'steamapps\common\Palworld\Pal\Binaries\Win64\Palworld-Win64-Shipping.exe' }
    foreach ($d in @(Get-PSDrive -PSProvider FileSystem -ErrorAction SilentlyContinue)) {
        $c += Join-Path $d.Root 'XboxGames\Palworld\Content\Pal\Binaries\WinGDK\Palworld-WinGDK-Shipping.exe'
    }
    return Garder-Existants $c
}

# ---------- Jeux ajoutes en v3 : recherche du .exe ----------
# $steam : chemins relatifs a steamapps\common ; $disques : chemins relatifs a la racine de chaque disque
function Trouver-ExeJeu([string]$jeu, [string[]]$steam, [string[]]$disques) {
    $c = @(Exe-Memo $jeu)
    if ($steam) { foreach ($l in Get-BibliothequesSteam) { foreach ($r in $steam) { $c += Join-Path $l "steamapps\common\$r" } } }
    if ($disques) {
        foreach ($d in @(Get-PSDrive -PSProvider FileSystem -ErrorAction SilentlyContinue)) { foreach ($r in $disques) { $c += Join-Path $d.Root $r } }
    }
    return Garder-Existants $c
}

function Trouver-ExeMinecraft {
    $c = @(Exe-Memo 'Minecraft')
    $bases = @(
        (Join-Path $env:LOCALAPPDATA 'Packages\Microsoft.4297127D64EC6_8wekyb3d8bbwe\LocalCache\Local\runtime'),
        "${env:ProgramFiles(x86)}\Minecraft Launcher\runtime",
        "$env:ProgramFiles\Minecraft Launcher\runtime",
        (Join-Path $env:APPDATA '.minecraft\runtime'))
    foreach ($b in $bases) {
        if (Test-Path -LiteralPath $b) { $c += @(Get-ChildItem -LiteralPath $b -Recurse -Depth 6 -Filter 'javaw.exe' -ErrorAction SilentlyContinue | ForEach-Object { $_.FullName }) }
    }
    return Garder-Existants $c
}

# Minecraft Java : RAM allouee dans le launcher (launcher_profiles.json)
function Set-RamMinecraft {
    $f = Join-Path $env:APPDATA '.minecraft\launcher_profiles.json'
    if (-not (Test-Path -LiteralPath $f)) { Write-Log '   Launcher Minecraft introuvable : lance-le une fois, puis recommence.' 'Gold'; return }
    $ramPc = [math]::Round(((Get-CimInstance Win32_ComputerSystem -ErrorAction SilentlyContinue).TotalPhysicalMemory) / 1GB)
    $go = if ($ramPc -ge 32) { 6 } elseif ($ramPc -ge 16) { 4 } elseif ($ramPc -ge 8) { 3 } else { 0 }
    if ($go -eq 0) { Write-Log '   Moins de 8 Go de RAM : on laisse le reglage du launcher.' 'Gray'; return }
    try { $j = [IO.File]::ReadAllText($f) | ConvertFrom-Json } catch { Write-Log '   Fichier du launcher illisible : rien n''a ete modifie.' 'Gold'; return }
    if (-not $j.profiles) { return }
    $defaut = "-Xmx${go}G -XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:G1NewSizePercent=20 -XX:G1ReservePercent=20 -XX:MaxGCPauseMillis=50 -XX:G1HeapRegionSize=32M"
    $change = $false
    foreach ($pr in $j.profiles.PSObject.Properties) {
        $v = $pr.Value
        $args0 = "$($v.javaArgs)"
        $actuel = 2
        if ($args0 -match '-Xmx(\d+)([GgMm])') { $actuel = if ($Matches[2] -match '[Mm]') { [math]::Floor([int]$Matches[1] / 1024) } else { [int]$Matches[1] } }
        if ($actuel -ge $go) { continue }
        if ($script:VerifEnCours) { $script:Ecarts += 'RAM Minecraft'; return }
        $nouveau = if ($args0 -match '-Xmx\d+[GgMm]') { $args0 -replace '-Xmx\d+[GgMm]', "-Xmx${go}G" } else { $defaut }
        if ($v.PSObject.Properties.Name -contains 'javaArgs') { $v.javaArgs = $nouveau } else { $v | Add-Member -NotePropertyName javaArgs -NotePropertyValue $nouveau }
        $nomProfil = if ($v.name) { $v.name } else { $pr.Name }
        Write-Log "   Profil $nomProfil : $actuel Go $Fleche $go Go de RAM." 'Gray'
        $change = $true
    }
    if (-not $change) { Write-Log "   RAM de Minecraft : deja a $go Go ou plus." 'Gray'; return }
    Sauver-Original 'Minecraft' $f
    [IO.File]::WriteAllText($f, ($j | ConvertTo-Json -Depth 30), (New-Object Text.UTF8Encoding($false)))
    Ajouter-Journal 'Minecraft : RAM allouee' '2 Go (defaut)' "$go Go"
}

# Valorant : un fichier de reglages par compte
function Set-AntiBugValorant {
    $base = Join-Path $env:LOCALAPPDATA 'VALORANT\Saved\Config'
    $fs = @(Get-ChildItem -LiteralPath $base -Recurse -Depth 3 -Filter 'GameUserSettings.ini' -ErrorAction SilentlyContinue | Where-Object { (Section-AvecCle $_.FullName 'FullscreenMode') })
    if ($fs.Count -eq 0) { Write-Log '   Reglages de Valorant introuvables : lance le jeu une fois, puis recommence.' 'Gold'; return }
    foreach ($f in $fs) { Set-AntiBugUE 'Valorant' $f.FullName }
}

# ---------- Roblox : fermeture complete quand on quitte ----------
$OptionFermerRoblox = 'Fermer Roblox completement quand tu le quittes'
function Roblox-AFenetre($p) {
    # Une vraie fenetre de jeu : visible et avec un titre (quand on quitte, Roblox garde parfois une fenetre vide)
    return ($p.MainWindowHandle -ne [IntPtr]::Zero -and "$($p.MainWindowTitle)".Trim() -ne '')
}
function Tuer-Roblox {
    $n = 0
    foreach ($nm in @('RobloxPlayerBeta', 'RobloxCrashHandler')) {
        foreach ($p in @(Get-Process -Name $nm -ErrorAction SilentlyContinue)) {
            try { $p.Kill(); $n++ } catch { try { Stop-Process -Id $p.Id -Force -ErrorAction Stop; $n++ } catch {} }
        }
    }
    return $n
}
function Fermer-RobloxEnFond {
    $tous = @(Get-Process -Name 'RobloxPlayerBeta' -ErrorAction SilentlyContinue)
    if (@($tous | Where-Object { Roblox-AFenetre $_ }).Count -gt 0) { return }
    if ($tous.Count -eq 0 -and -not (Get-Process -Name 'RobloxCrashHandler' -ErrorAction SilentlyContinue)) { return }
    $n = Tuer-Roblox
    if ($n -gt 0) { Write-Log "   Roblox tournait encore en fond sans fenetre : ferme tout de suite ($n processus)." 'Gray' }
    $script:RobloxSansFenetre = $null
}
# Surveillance continue (toutes les 4 s) : Roblox sans fenetre -> ferme
$script:RobloxVuAvecFenetre = $false
$script:RobloxSansFenetre = $null
function Surveiller-Roblox {
    if (-not $Jeux.Contains('Roblox')) { return }
    if (-not (@((Get-ChoixJeu 'Roblox').Appliques) -contains $OptionFermerRoblox)) { return }
    $tous = @(Get-Process -Name 'RobloxPlayerBeta' -ErrorAction SilentlyContinue)
    if ($tous.Count -eq 0) {
        $script:RobloxSansFenetre = $null
        if ($script:RobloxVuAvecFenetre -and (Get-Process -Name 'RobloxCrashHandler' -ErrorAction SilentlyContinue)) { [void](Tuer-Roblox) }
        $script:RobloxVuAvecFenetre = $false
        return
    }
    if (@($tous | Where-Object { Roblox-AFenetre $_ }).Count -gt 0) { $script:RobloxVuAvecFenetre = $true; $script:RobloxSansFenetre = $null; return }
    if (-not $script:RobloxSansFenetre) { $script:RobloxSansFenetre = Get-Date }
    # Juste apres avoir quitte une partie : on ferme vite. Sinon (Roblox en train de demarrer) on laisse 45 s.
    $delai = if ($script:RobloxVuAvecFenetre) { 3 } else { 45 }
    if (((Get-Date) - $script:RobloxSansFenetre).TotalSeconds -ge $delai) {
        $n = Tuer-Roblox
        if ($n -gt 0) { Write-Log "Roblox etait reste ouvert en fond : ferme ($n processus)." 'Gray' }
        $script:RobloxVuAvecFenetre = $false; $script:RobloxSansFenetre = $null
    }
}

# ---------- Reglages caches : on ne retient QUE la valeur d'origine de chaque cle modifiee ----------
# (au lieu d'une copie du fichier entier : "Remettre comme avant" ne touche plus aux reglages faits dans le jeu)
function Noter-CleIni([string]$jeu, [string]$fichier, [string]$section, [string]$cle, $ancien) {
    $idx = Lire-IndexJeu $jeu
    if ($idx | Where-Object { $_.Type -eq 'ini' -and $_.Orig -eq $fichier -and $_.Section -eq $section -and $_.Cle -eq $cle }) { return }
    # Ancienne sauvegarde du fichier entier : on y lit la vraie valeur d'origine
    $f0 = $idx | Where-Object { $_.Type -in 'fichier', 'fichier_ancien' -and $_.Orig -eq $fichier } | Select-Object -First 1
    if ($f0 -and $f0.Copie -and (Test-Path -LiteralPath $f0.Copie)) { $ancien = Valeur-Ini $f0.Copie $section $cle }
    [void]$idx.Add([pscustomobject]@{ Type = 'ini'; Orig = $fichier; Section = $section; Cle = $cle; Val = $ancien })
    Ecrire-IndexJeu $jeu $idx
}

function Remettre-CleIni([string]$fichier, [string]$section, [string]$cle, $valeur) {
    if (-not (Test-Path -LiteralPath $fichier)) { return }
    $c = Lire-Fichier $fichier
    $nl = if ($c.Texte -match "`r`n") { "`r`n" } else { "`n" }
    $sortie = New-Object System.Collections.Generic.List[string]
    $sec = ''
    $motif = '^\s*' + [regex]::Escape($cle) + '\s*='
    foreach ($l in ($c.Texte -split "`r?`n")) {
        $t = $l.Trim()
        if ($t -match '^\[(.+)\]$') { $sec = $Matches[1] }
        elseif ($sec -eq $section -and $l -match $motif) {
            if ($null -eq $valeur) { continue }
            $l = "$cle=$valeur"
        }
        $sortie.Add($l)
    }
    Ecrire-Fichier $fichier ($sortie -join $nl) $c.Enc
}

function Valeur-Ini([string]$fichier, [string]$section, [string]$cle) {
    $sec = ''
    $motif = '^\s*' + [regex]::Escape($cle) + '\s*=(.*)$'
    foreach ($l in ((Lire-Fichier $fichier).Texte -split "`r?`n")) {
        $t = $l.Trim()
        if ($t -match '^\[(.+)\]$') { $sec = $Matches[1]; continue }
        if ($sec -eq $section -and $l -match $motif) { return $Matches[1].Trim() }
    }
    return $null
}

function Ini-ACle([string]$fichier, [string]$section, [string]$cle) {
    if (-not (Test-Path -LiteralPath $fichier)) { return $false }
    $sec = ''
    $motif = '^\s*' + [regex]::Escape($cle) + '\s*='
    foreach ($l in ((Lire-Fichier $fichier).Texte -split "`r?`n")) {
        $t = $l.Trim()
        if ($t -match '^\[(.+)\]$') { $sec = $Matches[1]; continue }
        if ($sec -eq $section -and $l -match $motif) { return $true }
    }
    return $false
}

# Modifie une cle seulement si le jeu l'utilise deja (evite d'ajouter des lignes inconnues)
function Set-IniCache([string]$jeu, [string]$fichier, [string]$section, [string]$cle, [string]$valeur, [string]$libelle) {
    if (-not (Test-Path -LiteralPath $fichier)) { Set-IniJeu $jeu $fichier $section $cle $valeur $libelle; return }
    if (-not (Ini-ACle $fichier $section $cle)) { Write-Log "   $libelle : pas utilise par ta version du jeu, ignore." 'Gray'; return }
    Set-IniJeu $jeu $fichier $section $cle $valeur $libelle
}

# ---------- Priorite processeur (Windows applique la priorite a chaque lancement du jeu) ----------
$CleIfeo = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options'
function Set-PrioriteJeu([string]$jeu, [string[]]$exes) {
    foreach ($n in $exes) {
        $k = "$CleIfeo\$n\PerfOptions"
        $old = Lire-Reg $k 'CpuPriorityClass'
        if ("$old" -eq '6') { Write-Log "   $n : deja en priorite elevee." 'Gray'; continue }
        if ($script:VerifEnCours) { $script:Ecarts += "priorite $n"; continue }
        $idx = Lire-IndexJeu $jeu
        if (-not ($idx | Where-Object { $_.Type -eq 'ifeo' -and $_.Orig -eq $n })) {
            [void]$idx.Add([pscustomobject]@{ Type = 'ifeo'; Orig = $n; Val = $old })
            Ecrire-IndexJeu $jeu $idx
        }
        Set-Reg $k 'CpuPriorityClass' 6 'DWord'
        Write-Log "   $n : priorite elevee (au-dessus de la normale) a chaque lancement." 'Gray'
        Ajouter-Journal "$jeu : priorite processeur" 'Normale' 'Elevee'
    }
}

# ---------- Optimisations plein ecran de Windows (Proprietes > Compatibilite) ----------
$CleLayers = 'HKCU:\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers'
function Set-FsoJeu([string]$jeu, [string[]]$exes) {
    $exes = @($exes | Where-Object { $_ -and $_ -notmatch '\\WindowsApps\\' })
    if ($exes.Count -eq 0) { Write-Log '   Jeu introuvable (ou version Microsoft Store) : etape ignoree.' 'Gold'; return }
    foreach ($exe in $exes) {
        $old = Lire-Reg $CleLayers $exe
        if ("$old" -match 'DISABLEDXMAXIMIZEDWINDOWEDMODE') { Write-Log "   $([IO.Path]::GetFileName($exe)) : deja regle." 'Gray'; continue }
        if ($script:VerifEnCours) { $script:Ecarts += "plein ecran $([IO.Path]::GetFileName($exe))"; continue }
        $idx = Lire-IndexJeu $jeu
        if (-not ($idx | Where-Object { $_.Type -eq 'layers' -and $_.Orig -eq $exe })) {
            [void]$idx.Add([pscustomobject]@{ Type = 'layers'; Orig = $exe; Val = $old })
            Ecrire-IndexJeu $jeu $idx
        }
        $nouveau = if ("$old".Trim()) { "$old".Trim() + ' DISABLEDXMAXIMIZEDWINDOWEDMODE' } else { '~ DISABLEDXMAXIMIZEDWINDOWEDMODE' }
        Set-Reg $CleLayers $exe $nouveau 'String'
        Write-Log "   $([IO.Path]::GetFileName($exe)) : optimisations plein ecran desactivees." 'Gray'
        Ajouter-Journal "$jeu : optimisations plein ecran" 'Activees' 'Desactivees'
    }
}

# ---------- Roblox : FastFlags officiels (liste autorisee par Roblox) ----------
# Le fichier est dans le dossier de la version de Roblox, qui change a chaque mise a jour :
# la verification automatique d'OptiGame le recree tout seul.
function Lire-FlagsRoblox([string]$f) {
    $o = [ordered]@{}
    if (Test-Path -LiteralPath $f) {
        try { $j = [IO.File]::ReadAllText($f) | ConvertFrom-Json; foreach ($p in $j.PSObject.Properties) { $o[$p.Name] = $p.Value } } catch {}
    }
    return $o
}
function Ecrire-FlagsRoblox([string]$f, $o) {
    New-Item -ItemType Directory -Path (Split-Path $f) -Force | Out-Null
    $txt = if ($o.Count) { ConvertTo-Json -InputObject ([pscustomobject]$o) } else { '{}' }
    [IO.File]::WriteAllText($f, $txt, (New-Object Text.UTF8Encoding($false)))
}
function Set-FlagsRoblox([hashtable]$flags, [string]$libelle) {
    $dossiers = @(Trouver-ExeRoblox | ForEach-Object { Split-Path $_ } | Select-Object -Unique)
    if ($dossiers.Count -eq 0) { Write-Log '   Roblox introuvable : lance-le une fois, puis recommence.' 'Gold'; return }
    foreach ($d in $dossiers) {
        $f = Join-Path $d 'ClientSettings\ClientAppSettings.json'
        $o = Lire-FlagsRoblox $f
        $diff = @($flags.Keys | Where-Object { "$($o[$_])" -ne "$($flags[$_])" })
        if ($diff.Count -eq 0) { Write-Log "   $libelle : deja regle." 'Gray'; continue }
        if ($script:VerifEnCours) { $script:Ecarts += $libelle; continue }
        $idx = Lire-IndexJeu 'Roblox'
        $e = $idx | Where-Object { $_.Type -eq 'robloxflags' } | Select-Object -First 1
        if (-not $e) { $e = [pscustomobject]@{ Type = 'robloxflags'; Orig = 'ClientAppSettings.json'; Cles = @() }; [void]$idx.Add($e) }
        $e.Cles = @(@($e.Cles) + @($flags.Keys) | Where-Object { $_ } | Select-Object -Unique)
        Ecrire-IndexJeu 'Roblox' $idx
        foreach ($k in $flags.Keys) { $o[$k] = $flags[$k] }
        Ecrire-FlagsRoblox $f $o
        Write-Log "   $libelle : regle ($([IO.Path]::GetFileName($d)))." 'Gray'
        Ajouter-Journal "Roblox : $libelle" 'Par defaut' 'Active'
    }
}

# ---------- Fortnite : resolution plus grande que l'ecran (plein ecran sur 2 ecrans, PC qui bug) ----------
$OptionFsoFortnite = 'Desactiver les optimisations plein ecran de Windows'
function Reparer-AffichageFortnite {
    if (Jeu-EnCours 'Fortnite') { return $false }
    $repare = $false
    # Ancienne option retiree : on rend a Windows ses optimisations plein ecran pour Fortnite
    $idx = Lire-IndexJeu 'Fortnite'
    $reste = New-Object System.Collections.ArrayList
    foreach ($e in $idx) {
        if ($e.Type -eq 'layers') {
            if ("$($e.Val)".Trim()) { Set-Reg $CleLayers $e.Orig "$($e.Val)" 'String' } else { Remove-Reg $CleLayers $e.Orig }
            $repare = $true
        } else { [void]$reste.Add($e) }
    }
    if ($repare) { Ecrire-IndexJeu 'Fortnite' $reste; Write-Log 'Fortnite : optimisations plein ecran de Windows remises (option retiree).' 'Gray' }
    foreach ($exe in @(Trouver-ExeFortnite)) {
        $v = Lire-Reg $CleLayers $exe
        if ("$v" -match 'DISABLEDXMAXIMIZEDWINDOWEDMODE') {
            $n = ("$v" -replace '\s*DISABLEDXMAXIMIZEDWINDOWEDMODE', '').Trim()
            if ($n -eq '~' -or -not $n) { Remove-Reg $CleLayers $exe } else { Set-Reg $CleLayers $exe $n 'String' }
            $repare = $true
        }
    }
    $c = Get-ChoixJeu 'Fortnite'
    $c.Appliques = @(@($c.Appliques) | Where-Object { $_ -ne $OptionFsoFortnite })
    $c.Choix = @(@($c.Choix) | Where-Object { $_ -ne $OptionFsoFortnite })
    $f = & $Jeux['Fortnite'].Config
    if (-not (Test-Path -LiteralPath $f)) { return $repare }
    # Bugs de textures : l'ancienne option "Mode Performance" mettait DirectX 12 avec le niveau "es31"
    # (reserve au vrai mode Performance en DirectX 11). Ce melange casse l'affichage : on le retire.
    $rhi = "$(Valeur-Ini $f 'D3DRHIPreference' 'PreferredRHI')"
    $niv = "$(Valeur-Ini $f 'D3DRHIPreference' 'PreferredFeatureLevel')"
    if ($rhi -eq 'dx12' -and $niv -eq 'es31') {
        $orig = $null
        foreach ($e in (Lire-IndexJeu 'Fortnite')) {
            if ($e.Type -in 'fichier', 'fichier_ancien' -and $e.Orig -eq $f -and $e.Copie -and (Test-Path -LiteralPath $e.Copie)) {
                $orig = Valeur-Ini $e.Copie 'D3DRHIPreference' 'PreferredFeatureLevel'
            }
        }
        if ($orig -and $orig -ne 'es31') { Remettre-CleIni $f 'D3DRHIPreference' 'PreferredFeatureLevel' $orig }
        else { Remettre-CleIni $f 'D3DRHIPreference' 'PreferredFeatureLevel' $null }
        Write-Log 'Fortnite : melange DirectX 12 + niveau Performance (cause des bugs de textures) corrige.' 'Gold'
        Ajouter-Journal 'Fortnite : niveau de rendu' 'es31 (bugs de textures)' $(if ($orig -and $orig -ne 'es31') { $orig } else { 'Par defaut du jeu' })
        $repare = $true
    }
    # Resolution plus grande que l'ecran principal -> resolution de l'ecran + plein ecran fenetre
    $sec = '/Script/FortniteGame.FortGameUserSettings'
    $rx = 0; $ry = 0
    [void][int]::TryParse("$(Valeur-Ini $f $sec 'ResolutionSizeX')", [ref]$rx)
    [void][int]::TryParse("$(Valeur-Ini $f $sec 'ResolutionSizeY')", [ref]$ry)
    Charger-Type 'OGEcran' $CodeEcran
    $ecran = [OGEcran]::Info([Windows.Forms.Screen]::PrimaryScreen.DeviceName)
    if (-not $ecran) { return $repare }
    $w = $ecran[0]; $h = $ecran[1]
    if ($rx -le $w -and $ry -le $h) { return $repare }
    Write-Log "Fortnite etait en $rx x $ry, plus grand que ton ecran ($w x $h) : resolution corrigee." 'Gold'
    foreach ($k in 'ResolutionSizeX', 'LastUserConfirmedResolutionSizeX', 'DesiredScreenWidth', 'LastUserConfirmedDesiredScreenWidth') { Remettre-CleIni $f $sec $k "$w" }
    foreach ($k in 'ResolutionSizeY', 'LastUserConfirmedResolutionSizeY', 'DesiredScreenHeight', 'LastUserConfirmedDesiredScreenHeight') { Remettre-CleIni $f $sec $k "$h" }
    # Plein ecran fenetre : stable avec plusieurs ecrans (tu peux remettre Plein ecran dans le jeu)
    foreach ($k in 'FullscreenMode', 'LastConfirmedFullscreenMode', 'PreferredFullscreenMode') { Remettre-CleIni $f $sec $k '1' }
    Ajouter-Journal 'Fortnite : resolution' "$rx x $ry" "$w x $h (plein ecran fenetre)"
    return $true
}

# ---------- Anti-bug 2 ecrans : plein ecran fenetre a la resolution de l'ecran principal ----------
function Res-EcranPrincipal {
    Charger-Type 'OGEcran' $CodeEcran
    return [OGEcran]::Info([Windows.Forms.Screen]::PrimaryScreen.DeviceName)
}
function Section-AvecCle([string]$fichier, [string]$cle) {
    $sec = ''
    $motif = '^\s*' + [regex]::Escape($cle) + '\s*='
    foreach ($l in ((Lire-Fichier $fichier).Texte -split "`r?`n")) {
        $t = $l.Trim()
        if ($t -match '^\[(.+)\]$') { $sec = $Matches[1]; continue }
        if ($sec -and $l -match $motif) { return $sec }
    }
    return $null
}
# Jeux Unreal Engine (Fortnite, Palworld) : GameUserSettings.ini
function Set-AntiBugUE([string]$jeu, [string]$f) {
    if (-not (Test-Path -LiteralPath $f)) { Write-Log '   Fichier de reglages introuvable : lance le jeu une fois, puis recommence.' 'Gold'; return }
    $sec = Section-AvecCle $f 'FullscreenMode'
    if (-not $sec) { Write-Log '   Reglage d''affichage introuvable dans le fichier : lance le jeu une fois, puis recommence.' 'Gold'; return }
    $e = Res-EcranPrincipal
    if (-not $e) { Write-Log '   Ecran principal introuvable : etape ignoree.' 'Gold'; return }
    # 1 = plein ecran fenetre (0 = plein ecran exclusif, celui qui fait changer la resolution)
    foreach ($k in 'FullscreenMode', 'LastConfirmedFullscreenMode', 'PreferredFullscreenMode') { Set-IniCache $jeu $f $sec $k '1' "Mode d'affichage ($k)" }
    foreach ($k in 'ResolutionSizeX', 'LastUserConfirmedResolutionSizeX', 'DesiredScreenWidth', 'LastUserConfirmedDesiredScreenWidth') { Set-IniCache $jeu $f $sec $k "$($e[0])" "Largeur ($k)" }
    foreach ($k in 'ResolutionSizeY', 'LastUserConfirmedResolutionSizeY', 'DesiredScreenHeight', 'LastUserConfirmedDesiredScreenHeight') { Set-IniCache $jeu $f $sec $k "$($e[1])" "Hauteur ($k)" }
}
# Rocket League : TASystemSettings.ini
function Set-AntiBugRL {
    $f = & $Jeux['Rocket League'].Config
    if (-not (Test-Path -LiteralPath $f)) { Write-Log '   Fichier de reglages introuvable : lance le jeu une fois, puis recommence.' 'Gold'; return }
    $e = Res-EcranPrincipal
    if (-not $e) { Write-Log '   Ecran principal introuvable : etape ignoree.' 'Gold'; return }
    Set-IniCache 'Rocket League' $f 'SystemSettings' 'Fullscreen' 'False' 'Plein ecran exclusif'
    Set-IniCache 'Rocket League' $f 'SystemSettings' 'Borderless' 'True' 'Plein ecran sans bordure'
    Set-IniCache 'Rocket League' $f 'SystemSettings' 'ResX' "$($e[0])" 'Largeur'
    Set-IniCache 'Rocket League' $f 'SystemSettings' 'ResY' "$($e[1])" 'Hauteur'
}
# Roblox : on retire une fois le plein ecran exclusif Alt+Entree (source du bug a 2 ecrans)
function Retirer-AltEntreeRoblox {
    $drapeau = Join-Path $env:ProgramData 'OptiGame\roblox_altentree_retire.txt'
    if (Test-Path $drapeau) { return }
    $nom = 'Vrai plein ecran avec Alt+Entree (moins de latence)'
    $c = Get-ChoixJeu 'Roblox'
    if (@($c.Appliques) -contains $nom -or @($c.Choix) -contains $nom) {
        foreach ($d in @(Trouver-ExeRoblox | ForEach-Object { Split-Path $_ } | Select-Object -Unique)) {
            $f = Join-Path $d 'ClientSettings\ClientAppSettings.json'
            if (-not (Test-Path -LiteralPath $f)) { continue }
            $o = Lire-FlagsRoblox $f
            if ($o.Contains('FFlagHandleAltEnterFullscreenManually')) { $o.Remove('FFlagHandleAltEnterFullscreenManually'); Ecrire-FlagsRoblox $f $o }
        }
        $c.Appliques = @(@($c.Appliques) | Where-Object { $_ -ne $nom })
        $c.Choix = @(@($c.Choix) | Where-Object { $_ -ne $nom })
        Sauver-ChoixJeux
        Write-Log 'Roblox : plein ecran exclusif Alt+Entree retire (il fait buguer les PC a 2 ecrans).' 'Gray'
    }
    New-Item -ItemType Directory -Path (Split-Path $drapeau) -Force | Out-Null
    'ok' | Out-File $drapeau -Encoding ASCII
}

# ---------- Passage aux reglages caches : on rend au joueur ce qui est dans le menu du jeu ----------
function Migrer-ReglagesJeux {
    # Options renommees : on garde ce que tu avais coche / applique
    $chg = $false
    foreach ($k in @($script:ChoixJeux.Keys)) {
        $c = $script:ChoixJeux[$k]
        $a = @(@($c.Choix) | ForEach-Object { $_ -replace '^Priorite processeur haute pour', 'Priorite processeur elevee pour' })
        $b = @(@($c.Appliques) | ForEach-Object { $_ -replace '^Priorite processeur haute pour', 'Priorite processeur elevee pour' })
        if (($a -join '|') -ne (@($c.Choix) -join '|') -or ($b -join '|') -ne (@($c.Appliques) -join '|')) { $c.Choix = $a; $c.Appliques = $b; $chg = $true }
    }
    if ($chg) { Sauver-ChoixJeux }
    $drapeau = Join-Path $env:ProgramData 'OptiGame\jeux_reglages_caches.txt'
    if (Test-Path $drapeau) { return }
    # Fichiers verrouilles par l'ancienne option : deverrouilles pour que le jeu sauvegarde tes reglages
    foreach ($jeu in 'Rocket League', 'Call of Duty BO7') {
        $c = Get-ChoixJeu $jeu
        if (@($c.Appliques) -match 'Verrouiller') {
            $fs = if ($jeu -eq 'Rocket League') { @(& $Jeux['Rocket League'].Config) } else { @(Get-FichiersCod) }
            foreach ($f in $fs) {
                try { if ((Test-Path -LiteralPath $f) -and (Get-Item -LiteralPath $f).IsReadOnly) { (Get-Item -LiteralPath $f).IsReadOnly = $false; Write-Log "$jeu : $([IO.Path]::GetFileName($f)) deverrouille (tes reglages en jeu sont de nouveau sauvegardes)." 'Gray' } } catch {}
            }
        }
    }
    # Anciennes sauvegardes du fichier entier (.ini / .xml) : plus restaurees en bloc, pour ne pas ecraser tes reglages en jeu
    foreach ($jeu in @($Jeux.Keys)) {
        if (-not $Jeux[$jeu]) { continue }
        $idx = Lire-IndexJeu $jeu
        $chg = $false
        foreach ($e in $idx) { if ($e.Type -eq 'fichier' -and $e.Orig -match '\.(ini|xml)$') { $e.Type = 'fichier_ancien'; $chg = $true } }
        if ($chg) { Ecrire-IndexJeu $jeu $idx }
    }
    # Choix : les nouvelles options conseillees sont cochees, les anciennes disparaissent
    $script:NouvellesOptions = @{}
    foreach ($jeu in @($Jeux.Keys)) {
        if (-not $Jeux[$jeu]) { continue }
        $noms = @($Jeux[$jeu].Options | ForEach-Object { $_.Nom })
        $defaut = @($Jeux[$jeu].Options | Where-Object { $_.Defaut } | ForEach-Object { $_.Nom })
        if (-not $script:ChoixJeux.ContainsKey($jeu)) { continue }
        $c = $script:ChoixJeux[$jeu]
        $etaitOptimise = @($c.Appliques).Count -gt 0
        $c.Choix = @(@(@($c.Choix) | Where-Object { $noms -contains $_ }) + $defaut | Select-Object -Unique)
        $c.Appliques = @(@($c.Appliques) | Where-Object { $noms -contains $_ })
        if ($etaitOptimise) {
            $a = @($Jeux[$jeu].Options | Where-Object { $_.Defaut -and @($c.Appliques) -notcontains $_.Nom })
            if ($a.Count) { $script:NouvellesOptions[$jeu] = $a }
        }
    }
    Sauver-ChoixJeux
    New-Item -ItemType Directory -Path (Split-Path $drapeau) -Force | Out-Null
    'ok' | Out-File $drapeau -Encoding ASCII
}

# Applique les nouvelles optimisations aux jeux deja optimises (une seule fois, apres la mise a jour)
function Appliquer-NouvellesOptions {
    if (-not $script:NouvellesOptions -or $script:NouvellesOptions.Count -eq 0) { return }
    $enCours = @()
    try { $enCours = @((Trouver-JeuxEnCours).Keys) } catch {}
    foreach ($jeu in @($script:NouvellesOptions.Keys)) {
        if ($enCours -contains $jeu) { $script:EnAttente[$jeu] = $true; continue }
        Appliquer-Jeu $jeu $script:NouvellesOptions[$jeu]
    }
    $script:NouvellesOptions = @{}
    try { Remplir-ListeJeux -Force; if ($script:JeuSel) { Remplir-OptionsJeu $script:JeuSel } } catch {}
}

# ---------- Remettre un jeu comme avant ----------
function Restaurer-Jeu([string]$jeu) {
    $idx = Lire-IndexJeu $jeu
    if ($idx.Count -eq 0) { Write-Log 'Rien a remettre : OptiGame n''a encore rien modifie pour ce jeu.' 'Gold'; return }
    $k = 'HKCU:\Software\Microsoft\DirectX\UserGpuPreferences'
    foreach ($e in $idx) {
        if ($e.Type -eq 'fichier') {
            if (Test-Path -LiteralPath $e.Copie) {
                if (Test-Path -LiteralPath $e.Orig) { (Get-Item -LiteralPath $e.Orig).IsReadOnly = $false }
                Copy-Item -LiteralPath $e.Copie -Destination $e.Orig -Force
                (Get-Item -LiteralPath $e.Orig).IsReadOnly = [bool]$e.LectureSeule
                Write-Log "   $([IO.Path]::GetFileName($e.Orig)) remis comme avant." 'Gray'
                Ajouter-Journal "$jeu : $([IO.Path]::GetFileName($e.Orig))" 'Optimise OptiGame' 'Fichier d''origine'
            }
        }
        elseif ($e.Type -eq 'ini') {
            Remettre-CleIni $e.Orig $e.Section $e.Cle $e.Val
            $av = if ($null -eq $e.Val) { 'Par defaut' } else { $e.Val }
            Write-Log "   $($e.Cle) : remis a $av." 'Gray'
            Ajouter-Journal "$jeu : $($e.Cle)" 'Optimise OptiGame' $av
        }
        elseif ($e.Type -eq 'ifeo') {
            $kp = "$CleIfeo\$($e.Orig)\PerfOptions"
            if ($null -ne $e.Val) { Set-Reg $kp 'CpuPriorityClass' ([int]$e.Val) 'DWord' } else { Remove-Reg $kp 'CpuPriorityClass' }
            Write-Log "   $($e.Orig) : priorite normale." 'Gray'
            Ajouter-Journal "$jeu : priorite processeur" 'Elevee' 'Normale'
        }
        elseif ($e.Type -eq 'layers') {
            if ("$($e.Val)".Trim()) { Set-Reg $CleLayers $e.Orig "$($e.Val)" 'String' } else { Remove-Reg $CleLayers $e.Orig }
            Write-Log "   $([IO.Path]::GetFileName($e.Orig)) : optimisations plein ecran de Windows remises." 'Gray'
            Ajouter-Journal "$jeu : optimisations plein ecran" 'Desactivees' 'Activees'
        }
        elseif ($e.Type -eq 'robloxflags') {
            foreach ($d in @(Trouver-ExeRoblox | ForEach-Object { Split-Path $_ } | Select-Object -Unique)) {
                $f = Join-Path $d 'ClientSettings\ClientAppSettings.json'
                if (-not (Test-Path -LiteralPath $f)) { continue }
                $o = Lire-FlagsRoblox $f
                foreach ($k in @($e.Cles)) { if ($o.Contains($k)) { $o.Remove($k) } }
                Ecrire-FlagsRoblox $f $o
            }
            Write-Log '   FastFlags Roblox retires.' 'Gray'
            Ajouter-Journal 'Roblox : FastFlags' 'Active' 'Par defaut'
        }
        elseif ($e.Type -eq 'gpu') {
            if ($e.Val) { Set-Reg $k $e.Orig $e.Val 'String' } else { Remove-Reg $k $e.Orig }
            Write-Log "   Carte graphique de $([IO.Path]::GetFileName($e.Orig)) : choix de Windows." 'Gray'
            Ajouter-Journal "$jeu : carte graphique" 'Haute performance' 'Choix de Windows'
        }
    }
    Remove-Item (Dossier-SauvJeu $jeu) -Recurse -Force -ErrorAction SilentlyContinue
}

function Etat-Jeu([string]$jeu) {
    $def = $Jeux[$jeu]
    $exe = @(& $def.Exe)
    if ($exe.Count -eq 0) { $m = Exe-Memo $jeu; if ($m) { $exe = @($m) } }
    $cfg = & $def.Config
    $exe = @(@($exe) + @(Exe-Memo $jeu) | Select-Object -Unique)
    $t = if ($exe.Count -gt 1) { "Jeu trouve : $(Court-Chemin $exe[-1])  (+ $($exe.Count - 1) autre : lanceur)" }
         elseif ($exe.Count -gt 0) { "Jeu trouve : $(Court-Chemin $exe[0])" } else { 'Jeu pas encore trouve : lance-le une fois avec OptiGame ouvert, il sera reconnu automatiquement.' }
    $cfgOk = if ($jeu -eq 'Call of Duty BO7') { (Get-FichiersCod).Count -gt 0 } elseif (-not $cfg) { $null } else { Test-Path $cfg }
    if ($null -ne $cfgOk) { $t += if ($cfgOk) { "`r`nFichier de reglages : trouve." } else { "`r`nFichier de reglages : absent (lance le jeu une fois)." } }
    if ((Lire-IndexJeu $jeu).Count -gt 0) { $t += '  Optimise par OptiGame : oui (sauvegarde disponible).' }
    return $t
}

# =====================================================================
#  CHOIX MEMORISES PAR JEU (les cases ne se decochent plus)
# =====================================================================
$FichierChoix = Join-Path $env:ProgramData 'OptiGame\jeux_choix.json'
$script:ChoixJeux = @{}

function Charger-ChoixJeux {
    $script:ChoixJeux = @{}
    if (-not (Test-Path $FichierChoix)) { return }
    try {
        $j = Get-Content $FichierChoix -Raw | ConvertFrom-Json
        foreach ($p in $j.PSObject.Properties) {
            $script:ChoixJeux[$p.Name] = [pscustomobject]@{ Choix = @($p.Value.Choix | Where-Object { $_ }); Appliques = @($p.Value.Appliques | Where-Object { $_ }) }
        }
    } catch {}
}

function Sauver-ChoixJeux {
    New-Item -ItemType Directory -Path (Split-Path $FichierChoix) -Force | Out-Null
    $o = [ordered]@{}
    foreach ($k in $script:ChoixJeux.Keys) { $o[$k] = @{ Choix = @($script:ChoixJeux[$k].Choix); Appliques = @($script:ChoixJeux[$k].Appliques) } }
    $o | ConvertTo-Json -Depth 4 | Out-File -FilePath $FichierChoix -Encoding UTF8
}

function Get-ChoixJeu([string]$jeu) {
    if (-not $script:ChoixJeux.ContainsKey($jeu)) {
        $defaut = @($Jeux[$jeu].Options | Where-Object { $_.Defaut } | ForEach-Object { $_.Nom })
        $script:ChoixJeux[$jeu] = [pscustomobject]@{ Choix = $defaut; Appliques = @() }
    }
    return $script:ChoixJeux[$jeu]
}

function Jeu-Optimise([string]$jeu) {
    if (-not $Jeux[$jeu]) { return $false }
    return (@((Get-ChoixJeu $jeu).Appliques).Count -gt 0) -or ((Lire-IndexJeu $jeu).Count -gt 0)
}

# =====================================================================
#  REGLAGES TOUJOURS APPLIQUES : verification du vrai contenu des fichiers
#  (un jeu, une mise a jour ou un changement dans le menu du jeu peut les remettre)
# =====================================================================
$script:VerifEnCours = $false
$script:Ecarts = @()
$script:EcartsJeux = @{}

# Options a verifier : celles appliquees qui laissent un reglage (pas les nettoyages ponctuels)
function Options-AVerifier([string]$jeu) {
    if (-not ($Jeux.Contains($jeu) -and $Jeux[$jeu])) { return @() }
    $faits = @((Get-ChoixJeu $jeu).Appliques)
    return @($Jeux[$jeu].Options | Where-Object { $faits -contains $_.Nom -and $_.Nom -notmatch 'Vider|cache|Fermer' })
}

# Renvoie les options appliquees dont le reglage n'est plus en place (lecture seule, rien n'est modifie)
function Verifier-ReglagesJeu([string]$jeu) {
    $mauvaises = @()
    foreach ($o in (Options-AVerifier $jeu)) {
        $script:Ecarts = @()
        $script:VerifEnCours = $true
        try { & $o.Action } catch {} finally { $script:VerifEnCours = $false }
        if ($script:Ecarts.Count -gt 0) { $mauvaises += $o }
    }
    return @($mauvaises)
}

# Verifie tous les jeux optimises et remet ce qui a ete defait (si le jeu est ferme)
function Garantir-ReglagesJeux([switch]$Discret) {
    if ($script:Busy -or $script:TestEnCours) { return }
    $enCours = @()
    try { $enCours = @((Trouver-JeuxEnCours).Keys) } catch {}
    $remis = @()
    foreach ($jeu in @($Jeux.Keys)) {
        if (-not $Jeux[$jeu]) { continue }
        $mauvaises = @(Verifier-ReglagesJeu $jeu)
        if ($mauvaises.Count -eq 0) { $script:EcartsJeux.Remove($jeu); continue }
        if ($enCours -contains $jeu) {
            # Impossible pendant que le jeu tourne : ce sera fait a sa fermeture
            $script:EcartsJeux[$jeu] = @($mauvaises | ForEach-Object { $_.Nom })
            continue
        }
        Write-Log "$jeu : $($mauvaises.Count) reglage(s) avaient ete remis par le jeu ou une mise a jour. Re-application..." 'Gold'
        $script:SourceAction = "Verification automatique : $jeu avait remis ses valeurs"
        foreach ($o in $mauvaises) { Write-Log "   $($o.Nom)"; try { & $o.Action } catch { Write-Log "   Erreur : $($_.Exception.Message)" 'Tomato' } }
        $script:SourceAction = $null
        $reste = @(Verifier-ReglagesJeu $jeu)
        if ($reste.Count) { $script:EcartsJeux[$jeu] = @($reste | ForEach-Object { $_.Nom }) } else { $script:EcartsJeux.Remove($jeu) }
        $remis += $jeu
    }
    if ($remis.Count) { try { Afficher-Toast ("Reglages remis en place : " + ($remis -join ', ')) 'info' } catch {} }
    elseif (-not $Discret) { Write-Log 'Reglages des jeux verifies : tout est bien applique.' 'Gray' }
    try { if ($script:JeuSel) { Remplir-OptionsJeu $script:JeuSel } } catch {}
}

function Appliquer-Jeu([string]$nom, $options) {
    Invoke-Action "Optimisation $nom" {
        $n = 0
        foreach ($o in $options) {
            $n++
            Write-Log "[$n/$($options.Count)] $($o.Nom)..."
            & $o.Action
        }
        Write-Log 'Lance le jeu pour profiter des reglages. En cas de souci : "Remettre comme avant".' 'Gold'
    }
    $c = Get-ChoixJeu $nom
    $c.Appliques = @(@($c.Appliques) + @($options | ForEach-Object { $_.Nom }) | Select-Object -Unique)
    Sauver-ChoixJeux
}

# =====================================================================
#  DETECTION DES JEUX EN COURS
# =====================================================================
# Jeux qui restent parfois ouverts en fond sans fenetre : ils ne comptent que s'ils ont une fenetre
$FenetreObligatoire = @('RobloxPlayerBeta')
$DetectionJeux = [ordered]@{
    'Fortnite'          = @('FortniteClient-Win64-Shipping')
    'Rocket League'     = @('RocketLeague')
    'Roblox'            = @('RobloxPlayerBeta')
    'Call of Duty BO7'  = @('cod', 'cod25', 'BlackOps7')
    'Palworld'          = @('Palworld-Win64-Shipping', 'Palworld-WinGDK-Shipping')
    'Valorant'          = @('VALORANT-Win64-Shipping')
    'League of Legends' = @('League of Legends')
    'Counter-Strike 2'  = @('cs2')
    'Minecraft'         = @('Minecraft.Windows', 'javaw')
    'GTA V'             = @('GTA5', 'GTA5_Enhanced')
    'Apex Legends'      = @('r5apex', 'r5apex_dx12')
    'EA Sports FC'      = @('FC24', 'FC25', 'FC26')
}
# Reconnaissance par le titre de la fenetre (utile pour les versions Microsoft Store / Xbox)
$TitresJeux = [ordered]@{
    'Call of Duty BO7' = '^Call of Duty|Black Ops 7'
    'Fortnite'         = '^Fortnite'
    'Rocket League'    = '^Rocket League'
    'Roblox'           = '^Roblox$'
    'Palworld'         = '^(Pal|Palworld)\s*$'
    'Minecraft'        = '^Minecraft'
}
# Navigateurs et applis dont le titre peut contenir un nom de jeu (onglet YouTube...)
$PasDesFenetresDeJeu = @('chrome', 'msedge', 'firefox', 'opera', 'opera_gx', 'brave', 'vivaldi', 'Discord', 'explorer', 'powershell', 'pwsh',
    'Spotify', 'obs64', 'steamwebhelper', 'XboxPcApp', 'XboxApp', 'notepad', 'Teams', 'ms-teams', 'WhatsApp', 'Telegram')
# Programmes a ne jamais prendre pour un jeu (lanceurs, outils)
$PasDesJeux = @('steam', 'steamwebhelper', 'EpicGamesLauncher', 'EpicWebHelper', 'Battle.net', 'Agent', 'RiotClientServices',
    'RiotClientUx', 'RiotClientUxRender', 'EADesktop', 'EABackgroundService', 'UbisoftConnect', 'upc', 'GalaxyClient',
    'XboxPcApp', 'GameBar', 'CrashReportClient', 'UnrealCEFSubProcess', 'BEService', 'EasyAntiCheat', 'EasyAntiCheat_EOS', 'vgtray')
$MotifDossierJeu = '\\steamapps\\common\\|\\Epic Games\\|\\XboxGames\\|\\Riot Games\\|\\Ubisoft Game Launcher\\games\\|\\EA Games\\|\\GOG Galaxy\\Games\\|\\Call of Duty\\'
$script:JeuxActifs = @{}
$script:EnAttente = @{}
$FichierAuto = Join-Path $env:ProgramData 'OptiGame\auto_jeux.txt'

# Nouveau PC : rien n'est active tant que l'utilisateur ne l'a pas choisi.
# PC qui avait deja OptiGame : on garde ce qu'il avait (l'ancien defaut etait "active").
if (-not (Test-Path $FichierAuto)) {
    try {
        New-Item -ItemType Directory -Path (Split-Path $FichierAuto) -Force | Out-Null
        $(if (Test-Path (Join-Path $env:ProgramData 'OptiGame\jeux_choix.json')) { '1' } else { '0' }) | Out-File -FilePath $FichierAuto -Encoding ASCII
    } catch {}
}
function Auto-Active {
    if (-not (Test-Path $FichierAuto)) { return $false }
    return ((Get-Content $FichierAuto -Raw -ErrorAction SilentlyContinue) -notmatch '0')
}

$script:CheminsPid = @{}
function Chemin-Pid($p) {
    $cle = "$($p.Id)|$(try { $p.StartTime.Ticks } catch { 0 })"
    if ($script:CheminsPid.ContainsKey($cle)) { return $script:CheminsPid[$cle] }
    $ch = $null; try { $ch = $p.Path } catch {}
    if ($script:CheminsPid.Count -gt 600) { $script:CheminsPid.Clear() }
    $script:CheminsPid[$cle] = $ch
    return $ch
}
function Trouver-JeuxEnCours {
    $r = @{}
    $procs = @(Get-Process -ErrorAction SilentlyContinue)
    foreach ($nom in $DetectionJeux.Keys) {
        foreach ($p in ($procs | Where-Object { $DetectionJeux[$nom] -contains $_.ProcessName })) {
            if ($p.ProcessName -eq 'javaw' -and "$($p.MainWindowTitle)" -notmatch 'Minecraft') { continue }
            if ($FenetreObligatoire -contains $p.ProcessName -and -not (Roblox-AFenetre $p)) { continue }
            $r[$nom] = [pscustomobject]@{ Pid = $p.Id; Exe = "$($p.ProcessName).exe"; Debut = $(try { $p.StartTime } catch { Get-Date }) }
            break
        }
    }
    # Jeux connus reconnus au titre de leur fenetre (barre des taches)
    $fenetres = @($procs | Where-Object { $_.MainWindowHandle -ne [IntPtr]::Zero -and $PasDesFenetresDeJeu -notcontains $_.ProcessName })
    $dejaPris = @()
    foreach ($nom in $TitresJeux.Keys) {
        if ($r.ContainsKey($nom)) { continue }
        $p = $fenetres | Where-Object { "$($_.MainWindowTitle)" -match $TitresJeux[$nom] } | Select-Object -First 1
        if ($p) {
            $r[$nom] = [pscustomobject]@{ Pid = $p.Id; Exe = "$($p.ProcessName).exe"; Debut = $(try { $p.StartTime } catch { Get-Date }) }
            $dejaPris += $p.Id
        }
    }
    # Memorise le vrai chemin des jeux connus en cours (pour l'afficher et regler la carte graphique)
    foreach ($nom in @($r.Keys)) {
        $p = $procs | Where-Object { $_.Id -eq $r[$nom].Pid } | Select-Object -First 1
        $ch = if ($p) { Chemin-Pid $p } else { $null }
        if ($ch) { try { Noter-Memo $nom $ch $p.ProcessName } catch {} }
    }
    # Jeux inconnus : fenetre visible dans la barre des taches + programme installe dans un dossier de jeux
    $connus = @($DetectionJeux.Values | ForEach-Object { $_ })
    foreach ($p in ($procs | Where-Object { $_.MainWindowHandle -ne [IntPtr]::Zero })) {
        if ($connus -contains $p.ProcessName -or $PasDesJeux -contains $p.ProcessName -or $dejaPris -contains $p.Id) { continue }
        $chemin = Chemin-Pid $p
        if (-not $chemin -or $chemin -notmatch $MotifDossierJeu) { continue }
        $titre = "$($p.MainWindowTitle)".Trim()
        if (-not $titre) { try { $titre = $p.MainModule.FileVersionInfo.ProductName } catch {} }
        if (-not $titre) { $titre = $p.ProcessName }
        if (-not $r.ContainsKey($titre)) { $r[$titre] = [pscustomobject]@{ Pid = $p.Id; Exe = "$($p.ProcessName).exe"; Debut = $(try { $p.StartTime } catch { Get-Date }) } }
    }
    return $r
}

function Texte-EtatJeu([string]$nom) {
    if (-not $Jeux.Contains($nom) -or -not $Jeux[$nom]) { return "$nom (pas d'optimisation)" }
    if (Jeu-Optimise $nom) { return "$nom (optimise)" }
    if ($script:EnAttente.ContainsKey($nom)) { return "$nom (optimise a la fermeture)" }
    return "$nom (pas encore optimise)"
}

# (Afficher-JeuxEnCours : defini dans l'interface v2)

function Chercher-Crash([string]$exe, [datetime]$depuis) {
    # Journal Windows "Application" : 1000 = plantage, 1002 = blocage, 1001 = rapport d'erreur (APPCRASH)
    try {
        $ev = Get-WinEvent -FilterHashtable @{ LogName = 'Application'; Id = 1000, 1001, 1002; StartTime = $depuis } -MaxEvents 40 -ErrorAction Stop |
            Where-Object { $_.Message -match [regex]::Escape($exe) -and ($_.Id -ne 1001 -or $_.Message -match 'APPCRASH|AppHang|BEX') } |
            Select-Object -First 1
        if ($ev) { return $ev.Message }
    } catch {}
    return $null
}

# Priorite elevee aussi pour un jeu DEJA lance (Windows ne l'applique sinon qu'au prochain lancement).
# Seulement si l'option "priorite" a ete choisie pour ce jeu dans OptiGame.
function Priorite-EnDirect([string]$nom, $info) {
    try {
        if (-not $info -or -not $info.Exe) { return }
        if ("$(Lire-Reg "$CleIfeo\$($info.Exe)\PerfOptions" 'CpuPriorityClass')" -ne '6') { return }
        $p = Get-Process -Id $info.Pid -ErrorAction Stop
        if ("$($p.PriorityClass)" -in 'Normal', 'BelowNormal', 'Idle') {
            $p.PriorityClass = 'AboveNormal'
            Write-Log "   $nom : priorite elevee appliquee tout de suite (jeu deja lance)." 'Gray'
        }
    } catch {}
}

function Jeu-Demarre([string]$nom, $info) {
    $script:JeuxActifs[$nom] = $info
    Write-Log "Jeu detecte : $nom" 'White'
    Priorite-EnDirect $nom $info
    try { Maj-PidsSouris } catch {}
    try { Notifier 'OptiGame' ("Jeu detecte : " + (Texte-EtatJeu $nom)) } catch {}
    if (-not ($Jeux.Contains($nom) -and $Jeux[$nom])) { return }
    if (-not (Auto-Active)) { return }
    if (-not $script:Busy) {
        Write-Log '   Mode Boost automatique (fermeture des applis en arriere-plan)...' 'Gray'
        try { Etape-Boost } catch {}
    }
    if (-not (Jeu-Optimise $nom)) {
        $script:EnAttente[$nom] = $true
        Write-Log "   Les reglages de $nom seront appliques automatiquement quand tu fermeras le jeu (le jeu les ecraserait en quittant) : ils marcheront a la prochaine partie." 'Gold'
    }
}

function Jeu-Arrete([string]$nom, $info, $fin) {
    $script:JeuxActifs.Remove($nom)
    if (-not $fin) { $fin = Get-Date }
    $duree = ($fin - $info.Debut).TotalSeconds
    $crash = Chercher-Crash $info.Exe $info.Debut.AddSeconds(-5)
    $optimise = Jeu-Optimise $nom
    if ($crash) {
        $script:EnAttente.Remove($nom)
        $txt = "Crash probable de $nom $([math]::Round($duree)) s apres son lancement.`r`nJeu : $nom`r`nOptimise par OptiGame : $(if ($optimise) { 'oui' } else { 'non' })`r`nOptions appliquees : $(@((Get-ChoixJeu $nom).Appliques) -join ', ')"
        if ($crash) { $txt += "`r`n`r`nRapport de plantage Windows :`r`n" + ($crash.Substring(0, [math]::Min(900, $crash.Length))) }
        Write-Log "$nom s'est ferme au bout de $([math]::Round($duree)) s : crash probable. Voir l'onglet Erreurs." 'Tomato'
        Noter-Erreur "Crash : $nom" $txt
        try { Notifier 'OptiGame' "$nom a plante. Details dans l'onglet Erreurs." } catch {}
        return
    }
    Write-Log "Jeu ferme : $nom (sans plantage enregistre par Windows)" 'Gray'
    try { Ajuster-PleinEcranJeux -Jeu $nom } catch {}
    if ($nom -eq 'Roblox' -and (@((Get-ChoixJeu 'Roblox').Appliques) -contains $OptionFermerRoblox)) { try { Fermer-RobloxEnFond } catch {} }
    if ($nom -eq 'Fortnite') { Start-Sleep -Seconds 2; try { if (Reparer-AffichageFortnite) { Afficher-Toast 'Affichage de Fortnite repare.' 'info'; Sauver-ChoixJeux } } catch {} }
    # Le jeu a pu remettre ses propres valeurs en quittant : on reverifie les options deja appliquees
    if (-not $script:Busy -and -not $script:EnAttente.ContainsKey($nom) -and $Jeux.Contains($nom) -and $Jeux[$nom] -and (Options-AVerifier $nom).Count -gt 0) {
        Start-Sleep -Seconds 3
        Write-Log "Verification des reglages de $nom apres sa fermeture..." 'Gray'
        $mauvaises = @(Verifier-ReglagesJeu $nom)
        if ($mauvaises.Count) {
            Write-Log "   $nom avait remis $($mauvaises.Count) reglage(s) : re-application." 'Gold'
            $script:SourceAction = "Verification automatique a la fermeture de $nom"
            foreach ($o in $mauvaises) { try { & $o.Action } catch {} }
            $script:SourceAction = $null
            try { Afficher-Toast "Reglages de $nom remis en place." 'info' } catch {}
        } else { Write-Log '   Tout est toujours applique.' 'Gray' }
        $script:EcartsJeux.Remove($nom)
        if ($script:JeuSel -eq $nom) { try { Remplir-OptionsJeu $nom } catch {} }
    }
    if ($script:EnAttente.ContainsKey($nom) -and -not $script:Busy) {
        $script:EnAttente.Remove($nom)
        $choix = @((Get-ChoixJeu $nom).Choix)
        $opts = @($Jeux[$nom].Options | Where-Object { $choix -contains $_.Nom })
        if ($opts.Count -gt 0) {
            Start-Sleep -Seconds 3
            Appliquer-Jeu $nom $opts
            if ($script:JeuSel -eq $nom) { Remplir-OptionsJeu $nom }
        }
    }
}

$script:Disparus = @{}
function Verifier-Jeux {
    if ($script:TestEnCours) { return }
    try {
        $actuels = Trouver-JeuxEnCours
        foreach ($nom in @($actuels.Keys)) {
            $n = $actuels[$nom]
            if ($script:JeuxActifs.ContainsKey($nom)) {
                # Meme jeu, autre programme : le lanceur a passe la main au vrai jeu
                if ($script:JeuxActifs[$nom].Pid -ne $n.Pid) {
                    Write-Log "$nom : le lanceur a lance le jeu ($($n.Exe))." 'Gray'
                    $script:JeuxActifs[$nom] = $n
                    Priorite-EnDirect $nom $n
                }
            }
            elseif ($script:Disparus.ContainsKey($nom)) {
                Write-Log "$nom : le lanceur a lance le jeu ($($n.Exe))." 'Gray'
                $script:Disparus.Remove($nom)
                $script:JeuxActifs[$nom] = $n
                Priorite-EnDirect $nom $n
            }
            else { Jeu-Demarre $nom $n }
        }
        # Un jeu qui disparait : on attend 25 s avant de conclure (le lanceur peut relancer le vrai jeu)
        foreach ($nom in @($script:JeuxActifs.Keys)) {
            if (-not $actuels.ContainsKey($nom)) {
                $script:Disparus[$nom] = @{ Info = $script:JeuxActifs[$nom]; Quand = Get-Date }
                $script:JeuxActifs.Remove($nom)
            }
        }
        foreach ($nom in @($script:Disparus.Keys)) {
            if (((Get-Date) - $script:Disparus[$nom].Quand).TotalSeconds -ge 25) {
                $d = $script:Disparus[$nom]
                $script:Disparus.Remove($nom)
                Jeu-Arrete $nom $d.Info $d.Quand
            }
        }
        Afficher-JeuxEnCours
    } catch {}
}

# =====================================================================
#  INTERFACE V2 (WPF) : fenetre moderne, animations, ecran de progression
# =====================================================================
$XamlStyles = @'
<ResourceDictionary xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
                    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml">

  <!-- ===================== COULEURS ===================== -->
  <SolidColorBrush x:Key="Fond" Color="#0D0F14"/>
  <SolidColorBrush x:Key="Cote" Color="#11141B"/>
  <SolidColorBrush x:Key="FondCarte" Color="#161A23"/>
  <SolidColorBrush x:Key="Carte2" Color="#1C212C"/>
  <SolidColorBrush x:Key="Bord" Color="#242A37"/>
  <SolidColorBrush x:Key="Texte" Color="#E9ECF2"/>
  <SolidColorBrush x:Key="Gris" Color="#8C95A8"/>
  <SolidColorBrush x:Key="Vert" Color="#00D46A"/>
  <SolidColorBrush x:Key="Rouge" Color="#FF5468"/>
  <SolidColorBrush x:Key="Or" Color="#FFC24B"/>
  <LinearGradientBrush x:Key="Degrade" StartPoint="0,0" EndPoint="1,1">
    <GradientStop Color="#00D46A" Offset="0"/>
    <GradientStop Color="#00B2D6" Offset="1"/>
  </LinearGradientBrush>
  <LinearGradientBrush x:Key="DegradHero" StartPoint="0,0" EndPoint="1,1">
    <GradientStop Color="#16261F" Offset="0"/>
    <GradientStop Color="#141B26" Offset="1"/>
  </LinearGradientBrush>
  <FontFamily x:Key="Icones">Segoe Fluent Icons, Segoe MDL2 Assets</FontFamily>
  <FontFamily x:Key="Mono">Cascadia Mono, Consolas</FontFamily>

  <!-- ===================== BOUTONS ===================== -->
  <Style x:Key="Btn" TargetType="Button">
    <Setter Property="Background" Value="#1E2430"/>
    <Setter Property="Foreground" Value="#E9ECF2"/>
    <Setter Property="BorderBrush" Value="#2A3140"/>
    <Setter Property="BorderThickness" Value="1"/>
    <Setter Property="Padding" Value="16,9"/>
    <Setter Property="FontSize" Value="13"/>
    <Setter Property="Cursor" Value="Hand"/>
    <Setter Property="Focusable" Value="False"/>
    <Setter Property="RenderTransformOrigin" Value="0.5,0.5"/>
    <Setter Property="RenderTransform">
      <Setter.Value><ScaleTransform ScaleX="1" ScaleY="1"/></Setter.Value>
    </Setter>
    <Setter Property="Template">
      <Setter.Value>
        <ControlTemplate TargetType="Button">
          <Grid>
            <Border x:Name="Fd" CornerRadius="9" Background="{TemplateBinding Background}"
                    BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}"/>
            <Border x:Name="Lueur" CornerRadius="9" Background="White" Opacity="0"/>
            <ContentPresenter Margin="{TemplateBinding Padding}" HorizontalAlignment="Center" VerticalAlignment="Center"/>
          </Grid>
          <ControlTemplate.Triggers>
            <EventTrigger RoutedEvent="MouseEnter">
              <BeginStoryboard><Storyboard>
                <DoubleAnimation Storyboard.TargetName="Lueur" Storyboard.TargetProperty="Opacity" To="0.08" Duration="0:0:0.15"/>
              </Storyboard></BeginStoryboard>
            </EventTrigger>
            <EventTrigger RoutedEvent="MouseLeave">
              <BeginStoryboard><Storyboard>
                <DoubleAnimation Storyboard.TargetName="Lueur" Storyboard.TargetProperty="Opacity" To="0" Duration="0:0:0.25"/>
                <DoubleAnimation Storyboard.TargetProperty="(UIElement.RenderTransform).(ScaleTransform.ScaleX)" To="1" Duration="0:0:0.15"/>
                <DoubleAnimation Storyboard.TargetProperty="(UIElement.RenderTransform).(ScaleTransform.ScaleY)" To="1" Duration="0:0:0.15"/>
              </Storyboard></BeginStoryboard>
            </EventTrigger>
            <EventTrigger RoutedEvent="PreviewMouseLeftButtonDown">
              <BeginStoryboard><Storyboard>
                <DoubleAnimation Storyboard.TargetProperty="(UIElement.RenderTransform).(ScaleTransform.ScaleX)" To="0.95" Duration="0:0:0.08"/>
                <DoubleAnimation Storyboard.TargetProperty="(UIElement.RenderTransform).(ScaleTransform.ScaleY)" To="0.95" Duration="0:0:0.08"/>
              </Storyboard></BeginStoryboard>
            </EventTrigger>
            <EventTrigger RoutedEvent="PreviewMouseLeftButtonUp">
              <BeginStoryboard><Storyboard>
                <DoubleAnimation Storyboard.TargetProperty="(UIElement.RenderTransform).(ScaleTransform.ScaleX)" To="1" Duration="0:0:0.2">
                  <DoubleAnimation.EasingFunction><BackEase EasingMode="EaseOut" Amplitude="0.5"/></DoubleAnimation.EasingFunction>
                </DoubleAnimation>
                <DoubleAnimation Storyboard.TargetProperty="(UIElement.RenderTransform).(ScaleTransform.ScaleY)" To="1" Duration="0:0:0.2">
                  <DoubleAnimation.EasingFunction><BackEase EasingMode="EaseOut" Amplitude="0.5"/></DoubleAnimation.EasingFunction>
                </DoubleAnimation>
              </Storyboard></BeginStoryboard>
            </EventTrigger>
            <Trigger Property="IsEnabled" Value="False">
              <Setter Property="Opacity" Value="0.4"/>
            </Trigger>
          </ControlTemplate.Triggers>
        </ControlTemplate>
      </Setter.Value>
    </Setter>
  </Style>

  <Style x:Key="BtnPrincipal" TargetType="Button" BasedOn="{StaticResource Btn}">
    <Setter Property="Background" Value="{StaticResource Degrade}"/>
    <Setter Property="Foreground" Value="#06130C"/>
    <Setter Property="BorderThickness" Value="0"/>
    <Setter Property="FontWeight" Value="SemiBold"/>
    <Setter Property="Effect">
      <Setter.Value><DropShadowEffect Color="#00D46A" BlurRadius="18" ShadowDepth="0" Opacity="0.35"/></Setter.Value>
    </Setter>
  </Style>

  <Style x:Key="BtnDanger" TargetType="Button" BasedOn="{StaticResource Btn}">
    <Setter Property="Background" Value="#2A151A"/>
    <Setter Property="BorderBrush" Value="#55232E"/>
    <Setter Property="Foreground" Value="#FF8A97"/>
  </Style>

  <Style x:Key="BtnFantome" TargetType="Button" BasedOn="{StaticResource Btn}">
    <Setter Property="Background" Value="Transparent"/>
    <Setter Property="BorderBrush" Value="#2A3140"/>
  </Style>

  <Style x:Key="BtnTitre" TargetType="Button">
    <Setter Property="Width" Value="46"/>
    <Setter Property="Height" Value="34"/>
    <Setter Property="Foreground" Value="#B9C0CE"/>
    <Setter Property="Focusable" Value="False"/>
    <Setter Property="Cursor" Value="Hand"/>
    <Setter Property="Template">
      <Setter.Value>
        <ControlTemplate TargetType="Button">
          <Grid Background="Transparent">
            <!-- Survol bien visible : fond clair + contour (rouge pour la croix) -->
            <Border x:Name="Survol" CornerRadius="7" Background="#2EFFFFFF" BorderBrush="#40FFFFFF" BorderThickness="1" Opacity="0"/>
            <Border x:Name="Rouge" CornerRadius="7" Background="#E0384B" Opacity="0"/>
            <ContentPresenter x:Name="Icone" HorizontalAlignment="Center" VerticalAlignment="Center" RenderTransformOrigin="0.5,0.5"
                              TextElement.FontFamily="Segoe Fluent Icons, Segoe MDL2 Assets" TextElement.FontSize="12">
              <ContentPresenter.RenderTransform><ScaleTransform ScaleX="1" ScaleY="1"/></ContentPresenter.RenderTransform>
            </ContentPresenter>
          </Grid>
          <ControlTemplate.Triggers>
            <Trigger Property="IsMouseOver" Value="True">
              <Setter Property="Foreground" Value="White"/>
              <Trigger.EnterActions>
                <BeginStoryboard><Storyboard>
                  <DoubleAnimation Storyboard.TargetName="Survol" Storyboard.TargetProperty="Opacity" To="1" Duration="0:0:0.12"/>
                  <DoubleAnimation Storyboard.TargetName="Icone" Storyboard.TargetProperty="(UIElement.RenderTransform).(ScaleTransform.ScaleX)" To="1.15" Duration="0:0:0.15"/>
                  <DoubleAnimation Storyboard.TargetName="Icone" Storyboard.TargetProperty="(UIElement.RenderTransform).(ScaleTransform.ScaleY)" To="1.15" Duration="0:0:0.15"/>
                </Storyboard></BeginStoryboard>
              </Trigger.EnterActions>
              <Trigger.ExitActions>
                <BeginStoryboard><Storyboard>
                  <DoubleAnimation Storyboard.TargetName="Survol" Storyboard.TargetProperty="Opacity" To="0" Duration="0:0:0.2"/>
                  <DoubleAnimation Storyboard.TargetName="Icone" Storyboard.TargetProperty="(UIElement.RenderTransform).(ScaleTransform.ScaleX)" To="1" Duration="0:0:0.2"/>
                  <DoubleAnimation Storyboard.TargetName="Icone" Storyboard.TargetProperty="(UIElement.RenderTransform).(ScaleTransform.ScaleY)" To="1" Duration="0:0:0.2"/>
                </Storyboard></BeginStoryboard>
              </Trigger.ExitActions>
            </Trigger>
            <MultiTrigger>
              <MultiTrigger.Conditions>
                <Condition Property="IsMouseOver" Value="True"/>
                <Condition Property="Tag" Value="fermer"/>
              </MultiTrigger.Conditions>
              <Setter TargetName="Rouge" Property="Opacity" Value="1"/>
            </MultiTrigger>
            <Trigger Property="IsPressed" Value="True">
              <Setter TargetName="Survol" Property="Background" Value="#45FFFFFF"/>
            </Trigger>
          </ControlTemplate.Triggers>
        </ControlTemplate>
      </Setter.Value>
    </Setter>
  </Style>

  <!-- ===================== MENU DE NAVIGATION ===================== -->
  <Style x:Key="Nav" TargetType="RadioButton">
    <Setter Property="Foreground" Value="#8C95A8"/>
    <Setter Property="FontSize" Value="13.5"/>
    <Setter Property="Cursor" Value="Hand"/>
    <Setter Property="Focusable" Value="False"/>
    <Setter Property="Margin" Value="12,2"/>
    <Setter Property="GroupName" Value="Nav"/>
    <Setter Property="Template">
      <Setter.Value>
        <ControlTemplate TargetType="RadioButton">
          <Grid Height="40" Background="Transparent">
            <Border x:Name="Fd" CornerRadius="9" Background="#1B2130" Opacity="0"/>
            <Border x:Name="Survol" CornerRadius="9" Background="#161B26" Opacity="0"/>
            <Border x:Name="Barre" Width="3" Height="18" CornerRadius="2" HorizontalAlignment="Left" Margin="2,0,0,0"
                    Background="{StaticResource Degrade}" RenderTransformOrigin="0.5,0.5">
              <Border.RenderTransform><ScaleTransform ScaleY="0"/></Border.RenderTransform>
            </Border>
            <StackPanel Orientation="Horizontal" Margin="16,0,0,0" VerticalAlignment="Center">
              <TextBlock Text="{Binding Tag, RelativeSource={RelativeSource TemplatedParent}}" FontFamily="Segoe Fluent Icons, Segoe MDL2 Assets" FontSize="16"
                         VerticalAlignment="Center" Width="24"/>
              <ContentPresenter VerticalAlignment="Center" Margin="8,0,0,0"/>
            </StackPanel>
          </Grid>
          <ControlTemplate.Triggers>
            <Trigger Property="IsChecked" Value="True">
              <Setter Property="Foreground" Value="#E9ECF2"/>
              <Trigger.EnterActions>
                <BeginStoryboard><Storyboard>
                  <DoubleAnimation Storyboard.TargetName="Fd" Storyboard.TargetProperty="Opacity" To="1" Duration="0:0:0.2"/>
                  <DoubleAnimation Storyboard.TargetName="Barre" Storyboard.TargetProperty="(UIElement.RenderTransform).(ScaleTransform.ScaleY)" To="1" Duration="0:0:0.3">
                    <DoubleAnimation.EasingFunction><BackEase EasingMode="EaseOut" Amplitude="0.7"/></DoubleAnimation.EasingFunction>
                  </DoubleAnimation>
                </Storyboard></BeginStoryboard>
              </Trigger.EnterActions>
              <Trigger.ExitActions>
                <BeginStoryboard><Storyboard>
                  <DoubleAnimation Storyboard.TargetName="Fd" Storyboard.TargetProperty="Opacity" To="0" Duration="0:0:0.2"/>
                  <DoubleAnimation Storyboard.TargetName="Barre" Storyboard.TargetProperty="(UIElement.RenderTransform).(ScaleTransform.ScaleY)" To="0" Duration="0:0:0.15"/>
                </Storyboard></BeginStoryboard>
              </Trigger.ExitActions>
            </Trigger>
            <Trigger Property="IsMouseOver" Value="True">
              <Setter Property="Foreground" Value="#E9ECF2"/>
              <Setter TargetName="Survol" Property="Opacity" Value="1"/>
            </Trigger>
          </ControlTemplate.Triggers>
        </ControlTemplate>
      </Setter.Value>
    </Setter>
  </Style>

  <!-- ===================== INTERRUPTEUR (case a cocher) ===================== -->
  <Style x:Key="Switch" TargetType="CheckBox">
    <Setter Property="Cursor" Value="Hand"/>
    <Setter Property="Focusable" Value="False"/>
    <Setter Property="Foreground" Value="#E9ECF2"/>
    <Setter Property="Template">
      <Setter.Value>
        <ControlTemplate TargetType="CheckBox">
          <Grid Background="Transparent">
            <Grid.ColumnDefinitions>
              <ColumnDefinition Width="Auto"/>
              <ColumnDefinition Width="*"/>
            </Grid.ColumnDefinitions>
            <Grid Width="40" Height="22" VerticalAlignment="Top" Margin="0,1,12,0">
              <Border CornerRadius="11" Background="#2A3140"/>
              <Border x:Name="On" CornerRadius="11" Background="{StaticResource Degrade}" Opacity="0"/>
              <Ellipse x:Name="Pastille" Width="16" Height="16" Fill="White" HorizontalAlignment="Left" Margin="3,0,0,0">
                <Ellipse.RenderTransform><TranslateTransform X="0"/></Ellipse.RenderTransform>
              </Ellipse>
            </Grid>
            <ContentPresenter Grid.Column="1" VerticalAlignment="Center"/>
          </Grid>
          <ControlTemplate.Triggers>
            <Trigger Property="IsChecked" Value="True">
              <Trigger.EnterActions>
                <BeginStoryboard><Storyboard>
                  <DoubleAnimation Storyboard.TargetName="Pastille" Storyboard.TargetProperty="(UIElement.RenderTransform).(TranslateTransform.X)" To="18" Duration="0:0:0.2">
                    <DoubleAnimation.EasingFunction><CubicEase EasingMode="EaseOut"/></DoubleAnimation.EasingFunction>
                  </DoubleAnimation>
                  <DoubleAnimation Storyboard.TargetName="On" Storyboard.TargetProperty="Opacity" To="1" Duration="0:0:0.2"/>
                </Storyboard></BeginStoryboard>
              </Trigger.EnterActions>
              <Trigger.ExitActions>
                <BeginStoryboard><Storyboard>
                  <DoubleAnimation Storyboard.TargetName="Pastille" Storyboard.TargetProperty="(UIElement.RenderTransform).(TranslateTransform.X)" To="0" Duration="0:0:0.2">
                    <DoubleAnimation.EasingFunction><CubicEase EasingMode="EaseOut"/></DoubleAnimation.EasingFunction>
                  </DoubleAnimation>
                  <DoubleAnimation Storyboard.TargetName="On" Storyboard.TargetProperty="Opacity" To="0" Duration="0:0:0.2"/>
                </Storyboard></BeginStoryboard>
              </Trigger.ExitActions>
            </Trigger>
            <Trigger Property="IsEnabled" Value="False">
              <Setter Property="Opacity" Value="0.4"/>
            </Trigger>
          </ControlTemplate.Triggers>
        </ControlTemplate>
      </Setter.Value>
    </Setter>
  </Style>

  <!-- ===================== CARTES ===================== -->
  <Style x:Key="Carte" TargetType="Border">
    <Setter Property="Background" Value="#161A23"/>
    <Setter Property="BorderBrush" Value="#232937"/>
    <Setter Property="BorderThickness" Value="1"/>
    <Setter Property="CornerRadius" Value="14"/>
    <Setter Property="Padding" Value="20"/>
  </Style>

  <Style x:Key="CarteAnim" TargetType="Border" BasedOn="{StaticResource Carte}">
    <Setter Property="RenderTransform">
      <Setter.Value><TranslateTransform Y="0"/></Setter.Value>
    </Setter>
    <Style.Triggers>
      <EventTrigger RoutedEvent="MouseEnter">
        <BeginStoryboard><Storyboard>
          <DoubleAnimation Storyboard.TargetProperty="(UIElement.RenderTransform).(TranslateTransform.Y)" To="-3" Duration="0:0:0.18">
            <DoubleAnimation.EasingFunction><CubicEase EasingMode="EaseOut"/></DoubleAnimation.EasingFunction>
          </DoubleAnimation>
        </Storyboard></BeginStoryboard>
      </EventTrigger>
      <EventTrigger RoutedEvent="MouseLeave">
        <BeginStoryboard><Storyboard>
          <DoubleAnimation Storyboard.TargetProperty="(UIElement.RenderTransform).(TranslateTransform.Y)" To="0" Duration="0:0:0.25"/>
        </Storyboard></BeginStoryboard>
      </EventTrigger>
      <Trigger Property="IsMouseOver" Value="True">
        <Setter Property="BorderBrush" Value="#2E3A4C"/>
      </Trigger>
    </Style.Triggers>
  </Style>

  <Style x:Key="Titre" TargetType="TextBlock">
    <Setter Property="FontSize" Value="27"/>
    <Setter Property="FontWeight" Value="SemiBold"/>
    <Setter Property="Foreground" Value="#E9ECF2"/>
    <Setter Property="FontFamily" Value="Segoe UI Variable Display, Segoe UI"/>
  </Style>
  <Style x:Key="SousTitre" TargetType="TextBlock">
    <Setter Property="FontSize" Value="13.5"/>
    <Setter Property="Foreground" Value="#8C95A8"/>
    <Setter Property="Margin" Value="0,4,0,0"/>
    <Setter Property="TextWrapping" Value="Wrap"/>
  </Style>
  <Style x:Key="Section" TargetType="TextBlock">
    <Setter Property="FontSize" Value="12"/>
    <Setter Property="FontWeight" Value="SemiBold"/>
    <Setter Property="Foreground" Value="#8C95A8"/>
    <Setter Property="Margin" Value="2,26,0,12"/>
  </Style>

  <!-- ===================== LISTES ===================== -->
  <Style x:Key="Liste" TargetType="ListBox">
    <Setter Property="Background" Value="Transparent"/>
    <Setter Property="BorderThickness" Value="0"/>
    <Setter Property="Foreground" Value="#E9ECF2"/>
    <Setter Property="ScrollViewer.HorizontalScrollBarVisibility" Value="Disabled"/>
    <Setter Property="Focusable" Value="False"/>
  </Style>
  <Style x:Key="Element" TargetType="ListBoxItem">
    <Setter Property="Cursor" Value="Hand"/>
    <Setter Property="Focusable" Value="True"/>
    <Setter Property="FocusVisualStyle" Value="{x:Null}"/>
    <Setter Property="HorizontalContentAlignment" Value="Stretch"/>
    <Setter Property="Template">
      <Setter.Value>
        <ControlTemplate TargetType="ListBoxItem">
          <Border x:Name="B" CornerRadius="10" Background="Transparent" BorderThickness="1" BorderBrush="Transparent"
                  Margin="0,2" Padding="12,9">
            <ContentPresenter/>
          </Border>
          <ControlTemplate.Triggers>
            <Trigger Property="IsMouseOver" Value="True">
              <Setter TargetName="B" Property="Background" Value="#1A1F2A"/>
            </Trigger>
            <Trigger Property="IsSelected" Value="True">
              <Setter TargetName="B" Property="Background" Value="#1A2730"/>
              <Setter TargetName="B" Property="BorderBrush" Value="#1F6B4A"/>
            </Trigger>
          </ControlTemplate.Triggers>
        </ControlTemplate>
      </Setter.Value>
    </Setter>
  </Style>

  <!-- ===================== BARRES DE DEFILEMENT ===================== -->
  <Style TargetType="ScrollBar">
    <Setter Property="Width" Value="9"/>
    <Setter Property="MinWidth" Value="9"/>
    <Setter Property="Background" Value="Transparent"/>
    <Setter Property="Template">
      <Setter.Value>
        <ControlTemplate TargetType="ScrollBar">
          <Track x:Name="PART_Track" IsDirectionReversed="True" Orientation="{TemplateBinding Orientation}">
            <Track.Thumb>
              <Thumb>
                <Thumb.Template>
                  <ControlTemplate TargetType="Thumb">
                    <Border CornerRadius="4" Background="#343C4C" Margin="2"/>
                  </ControlTemplate>
                </Thumb.Template>
              </Thumb>
            </Track.Thumb>
          </Track>
          <ControlTemplate.Triggers>
            <Trigger Property="Orientation" Value="Horizontal">
              <Setter TargetName="PART_Track" Property="IsDirectionReversed" Value="False"/>
            </Trigger>
          </ControlTemplate.Triggers>
        </ControlTemplate>
      </Setter.Value>
    </Setter>
    <Style.Triggers>
      <Trigger Property="Orientation" Value="Horizontal">
        <Setter Property="Width" Value="Auto"/>
        <Setter Property="MinWidth" Value="0"/>
        <Setter Property="Height" Value="9"/>
      </Trigger>
    </Style.Triggers>
  </Style>

  <!-- ===================== INFOBULLES ===================== -->
  <Style TargetType="ToolTip">
    <Setter Property="Foreground" Value="#E9ECF2"/>
    <Setter Property="FontSize" Value="12.5"/>
    <Setter Property="MaxWidth" Value="380"/>
    <Setter Property="Template">
      <Setter.Value>
        <ControlTemplate TargetType="ToolTip">
          <Border Background="#1E2430" BorderBrush="#2E3646" BorderThickness="1" CornerRadius="8" Padding="10,7">
            <ContentPresenter>
              <ContentPresenter.Resources>
                <Style TargetType="TextBlock"><Setter Property="TextWrapping" Value="Wrap"/></Style>
              </ContentPresenter.Resources>
            </ContentPresenter>
          </Border>
        </ControlTemplate>
      </Setter.Value>
    </Setter>
  </Style>

  <Style x:Key="BarreRonde" TargetType="ProgressBar">
    <Setter Property="Template">
      <Setter.Value>
        <ControlTemplate TargetType="ProgressBar">
          <Grid>
            <Border x:Name="PART_Track" CornerRadius="3" Background="{TemplateBinding Background}"/>
            <Border x:Name="PART_Indicator" CornerRadius="3" Background="{TemplateBinding Foreground}" HorizontalAlignment="Left"/>
          </Grid>
        </ControlTemplate>
      </Setter.Value>
    </Setter>
  </Style>

  <Style x:Key="ZoneSaisie" TargetType="TextBox">
    <Setter Property="Background" Value="#0F1218"/>
    <Setter Property="Foreground" Value="#E9ECF2"/>
    <Setter Property="CaretBrush" Value="#E9ECF2"/>
    <Setter Property="SelectionBrush" Value="#00D46A"/>
    <Setter Property="BorderBrush" Value="#2A3140"/>
    <Setter Property="BorderThickness" Value="1"/>
    <Setter Property="Padding" Value="10,8"/>
    <Setter Property="FontSize" Value="12.5"/>
    <Setter Property="TextWrapping" Value="NoWrap"/>
    <Setter Property="VerticalContentAlignment" Value="Center"/>
    <Setter Property="Template">
      <Setter.Value>
        <ControlTemplate TargetType="TextBox">
          <Border x:Name="B" Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}"
                  BorderThickness="{TemplateBinding BorderThickness}" CornerRadius="9">
            <ScrollViewer x:Name="PART_ContentHost" Margin="{TemplateBinding Padding}" VerticalAlignment="Center"/>
          </Border>
          <ControlTemplate.Triggers>
            <Trigger Property="IsMouseOver" Value="True">
              <Setter TargetName="B" Property="BorderBrush" Value="#3A4252"/>
            </Trigger>
            <Trigger Property="IsKeyboardFocused" Value="True">
              <Setter TargetName="B" Property="BorderBrush" Value="#00D46A"/>
            </Trigger>
          </ControlTemplate.Triggers>
        </ControlTemplate>
      </Setter.Value>
    </Setter>
  </Style>

  <Style x:Key="ZoneTexte" TargetType="TextBox">
    <Setter Property="Background" Value="#0F1218"/>
    <Setter Property="Foreground" Value="#C9CFDA"/>
    <Setter Property="BorderBrush" Value="#232937"/>
    <Setter Property="BorderThickness" Value="1"/>
    <Setter Property="Padding" Value="10"/>
    <Setter Property="FontFamily" Value="Cascadia Mono, Consolas"/>
    <Setter Property="FontSize" Value="11.5"/>
    <Setter Property="IsReadOnly" Value="True"/>
    <Setter Property="TextWrapping" Value="Wrap"/>
    <Setter Property="VerticalScrollBarVisibility" Value="Auto"/>
    <Setter Property="Template">
      <Setter.Value>
        <ControlTemplate TargetType="TextBox">
          <Border Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}"
                  BorderThickness="{TemplateBinding BorderThickness}" CornerRadius="10">
            <ScrollViewer x:Name="PART_ContentHost" Margin="{TemplateBinding Padding}"/>
          </Border>
        </ControlTemplate>
      </Setter.Value>
    </Setter>
  </Style>

  <Style x:Key="Pastille" TargetType="Border">
    <Setter Property="CornerRadius" Value="6"/>
    <Setter Property="Padding" Value="8,2"/>
    <Setter Property="HorizontalAlignment" Value="Left"/>
    <Setter Property="VerticalAlignment" Value="Center"/>
  </Style>
</ResourceDictionary>
'@

$XamlMain = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="OptiGame" Width="1180" Height="760" MinWidth="1020" MinHeight="660"
        WindowStartupLocation="CenterScreen" Background="#0D0F14"
        FontFamily="Segoe UI Variable Text, Segoe UI" FontSize="13" Foreground="#E9ECF2"
        UseLayoutRounding="True" TextOptions.TextFormattingMode="Display">
  <WindowChrome.WindowChrome>
    <WindowChrome CaptionHeight="46" ResizeBorderThickness="6" GlassFrameThickness="0,0,0,1"
                  CornerRadius="0" UseAeroCaptionButtons="False"/>
  </WindowChrome.WindowChrome>

  <Grid x:Name="Racine">
    <Grid.ColumnDefinitions>
      <ColumnDefinition Width="232"/>
      <ColumnDefinition Width="*"/>
    </Grid.ColumnDefinitions>

    <!-- ===================== BARRE LATERALE ===================== -->
    <Border Grid.Column="0" Background="#11141B" BorderBrush="#1C212B" BorderThickness="0,0,1,0">
      <DockPanel>
        <StackPanel DockPanel.Dock="Top" Orientation="Horizontal" Margin="20,18,0,22">
          <Border Width="40" Height="40" CornerRadius="11" Background="{StaticResource Degrade}">
            <Border.Effect><DropShadowEffect Color="#00D46A" BlurRadius="16" ShadowDepth="0" Opacity="0.45"/></Border.Effect>
            <TextBlock Text="OG" FontWeight="Bold" FontSize="16" Foreground="#06130C" HorizontalAlignment="Center" VerticalAlignment="Center"/>
          </Border>
          <StackPanel Margin="12,0,0,0" VerticalAlignment="Center">
            <TextBlock Text="OptiGame" FontSize="18" FontWeight="SemiBold" FontFamily="Segoe UI Variable Display, Segoe UI"/>
            <TextBlock x:Name="TxtVersion" Text="v2.0" FontSize="11.5" Foreground="#8C95A8"/>
          </StackPanel>
        </StackPanel>

        <StackPanel DockPanel.Dock="Bottom" Margin="20,0,16,18">
          <Border Background="#161A23" CornerRadius="10" Padding="12,10" BorderBrush="#232937" BorderThickness="1">
            <StackPanel>
              <TextBlock Text="Jeux en cours" FontSize="11" Foreground="#8C95A8"/>
              <StackPanel Orientation="Horizontal" Margin="0,4,0,0">
                <Ellipse x:Name="PointJeux" Width="8" Height="8" Fill="#3A4252" VerticalAlignment="Center"/>
                <TextBlock x:Name="TxtCoteJeux" Text="Aucun" FontSize="12.5" Margin="8,0,0,0" TextTrimming="CharacterEllipsis"/>
              </StackPanel>
            </StackPanel>
          </Border>
        </StackPanel>

        <ScrollViewer VerticalScrollBarVisibility="Auto">
          <StackPanel x:Name="Menu">
            <TextBlock Text="GENERAL" FontSize="10.5" FontWeight="SemiBold" Foreground="#5E677A" Margin="28,0,0,6"/>
            <RadioButton x:Name="NavAccueil" Style="{StaticResource Nav}" Tag="&#xE80F;" Content="Accueil" IsChecked="True"/>
            <RadioButton x:Name="NavOptim" Style="{StaticResource Nav}" Tag="&#xE945;" Content="Optimisation"/>
            <RadioButton x:Name="NavJeux" Style="{StaticResource Nav}" Tag="&#xE7FC;" Content="Jeux"/>
            <RadioButton x:Name="NavTest" Style="{StaticResource Nav}" Tag="&#xE9D9;" Content="Test de performance"/>
            <RadioButton x:Name="NavSpeed" Style="{StaticResource Nav}" Tag="&#xE774;" Content="Reseau"/>
            <TextBlock Text="MON PC" FontSize="10.5" FontWeight="SemiBold" Foreground="#5E677A" Margin="28,18,0,6"/>
            <RadioButton x:Name="NavInfos" Style="{StaticResource Nav}" Tag="&#xE950;" Content="Composants"/>
            <RadioButton x:Name="NavOled" Style="{StaticResource Nav}" Tag="&#xE7F4;" Content="Ecran"/>
            <RadioButton x:Name="NavAntivirus" Style="{StaticResource Nav}" Tag="&#xEA18;" Content="Antivirus"/>
            <RadioButton x:Name="NavConseils" Style="{StaticResource Nav}" Tag="&#xE82F;" Content="Conseils"/>
            <RadioButton x:Name="NavHisto" Style="{StaticResource Nav}" Tag="&#xE81C;" Content="Ce qui a change"/>

            <TextBlock Text="OUTILS" FontSize="10.5" FontWeight="SemiBold" Foreground="#5E677A" Margin="28,18,0,6"/>
            <RadioButton x:Name="NavSpicetify" Style="{StaticResource Nav}" Tag="&#xE8D6;" Content="Spicetify (Spotify)"/>
            <TextBlock Text="APPLICATION" FontSize="10.5" FontWeight="SemiBold" Foreground="#5E677A" Margin="28,18,0,6"/>
            <RadioButton x:Name="NavApparence" Style="{StaticResource Nav}" Tag="&#xE790;" Content="Apparence"/>
            <RadioButton x:Name="NavVersions" Style="{StaticResource Nav}" Tag="&#xE7B8;" Content="Versions"/>
            <RadioButton x:Name="NavErreurs" Style="{StaticResource Nav}" Tag="&#xE7BA;">
              <StackPanel Orientation="Horizontal">
                <TextBlock Text="Erreurs" VerticalAlignment="Center"/>
                <Border x:Name="BadgeErreurs" Background="#FF5468" CornerRadius="8" Padding="6,0" Margin="8,0,0,0" Visibility="Collapsed" VerticalAlignment="Center">
                  <TextBlock x:Name="TxtBadgeErreurs" Text="0" FontSize="11" FontWeight="Bold" Foreground="White"/>
                </Border>
              </StackPanel>
            </RadioButton>
            <RadioButton x:Name="NavJournal" Style="{StaticResource Nav}" Tag="&#xE8A5;" Content="Journal"/>
          </StackPanel>
        </ScrollViewer>
      </DockPanel>
    </Border>

    <!-- ===================== PARTIE DROITE ===================== -->
    <Grid Grid.Column="1">
      <Grid.RowDefinitions>
        <RowDefinition Height="46"/>
        <RowDefinition Height="*"/>
        <RowDefinition Height="30"/>
      </Grid.RowDefinitions>

      <!-- Barre de titre -->
      <Grid Grid.Row="0">
        <Border x:Name="PilluleJeux" HorizontalAlignment="Left" VerticalAlignment="Center" Margin="28,6,0,0"
                Background="#13241C" BorderBrush="#1F5A3E" BorderThickness="1" CornerRadius="13" Padding="10,4" Visibility="Collapsed">
          <StackPanel Orientation="Horizontal">
            <Ellipse Width="8" Height="8" Fill="#00D46A" VerticalAlignment="Center">
              <Ellipse.Triggers>
                <EventTrigger RoutedEvent="FrameworkElement.Loaded">
                  <BeginStoryboard><Storyboard RepeatBehavior="Forever" AutoReverse="True">
                    <DoubleAnimation Storyboard.TargetProperty="Opacity" From="1" To="0.25" Duration="0:0:0.8"/>
                  </Storyboard></BeginStoryboard>
                </EventTrigger>
              </Ellipse.Triggers>
            </Ellipse>
            <TextBlock x:Name="TxtPilluleJeux" FontSize="12" Margin="8,0,0,0" Foreground="#9DEBC0"/>
          </StackPanel>
        </Border>
        <StackPanel Orientation="Horizontal" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,6,8,0">
          <Button x:Name="BtnRelancer" Style="{StaticResource BtnTitre}" Content="&#xE72C;" WindowChrome.IsHitTestVisibleInChrome="True" ToolTip="Relancer OptiGame (en cas de bug)"/>
          <Button x:Name="BtnReduire" Style="{StaticResource BtnTitre}" Content="&#xE921;" WindowChrome.IsHitTestVisibleInChrome="True" ToolTip="Reduire (OptiGame continue en arriere-plan)"/>
          <Button x:Name="BtnAgrandir" Style="{StaticResource BtnTitre}" Content="&#xE922;" WindowChrome.IsHitTestVisibleInChrome="True"/>
          <Button x:Name="BtnFermer" Style="{StaticResource BtnTitre}" Content="&#xE8BB;" Tag="fermer" WindowChrome.IsHitTestVisibleInChrome="True"/>
        </StackPanel>
      </Grid>

      <!-- Pages -->
      <Grid x:Name="Pages" Grid.Row="1" ClipToBounds="True">

        <!-- ========== ACCUEIL ========== -->
        <ScrollViewer x:Name="PageAccueil" VerticalScrollBarVisibility="Auto">
          <StackPanel Margin="32,10,32,28">
            <TextBlock Text="Tableau de bord" Style="{StaticResource Titre}"/>
            <TextBlock x:Name="TxtBonjour" Style="{StaticResource SousTitre}" Text="Analyse de ton PC..."/>
            <Border x:Name="BanniereMaj" Visibility="Collapsed" Margin="0,18,0,0" CornerRadius="14" Padding="20,14" Background="#16261F" BorderBrush="#1F6B4A" BorderThickness="1">
              <Grid>
                <StackPanel Margin="0,0,330,0" VerticalAlignment="Center">
                  <StackPanel Orientation="Horizontal">
                    <TextBlock Text="&#xE896;" FontFamily="Segoe Fluent Icons, Segoe MDL2 Assets" Foreground="#00D46A" FontSize="16" VerticalAlignment="Center"/>
                    <TextBlock x:Name="TxtMajTitre" Text="Mise a jour disponible" FontSize="15" FontWeight="SemiBold" Margin="10,0,0,0"/>
                  </StackPanel>
                  <TextBlock x:Name="TxtMajSous" Foreground="#C9CFDA" FontSize="12.5" TextWrapping="Wrap" Margin="26,3,0,0"/>
                </StackPanel>
                <StackPanel Orientation="Horizontal" HorizontalAlignment="Right" VerticalAlignment="Center">
                  <Button x:Name="BtnMajInstaller" Style="{StaticResource BtnPrincipal}" Content="Installer" Padding="16,9" Margin="0,0,8,0"/>
                  <Button x:Name="BtnMajVoir" Style="{StaticResource Btn}" Content="Voir les versions" Padding="14,9" Margin="0,0,8,0"/>
                  <Button x:Name="BtnMajPlusTard" Style="{StaticResource BtnFantome}" Content="Plus tard" Padding="14,9"/>
                </StackPanel>
              </Grid>
            </Border>

            <Border Style="{StaticResource Carte}" Margin="0,22,0,0" Padding="28,24" Background="{StaticResource DegradHero}">
              <Grid>
                <Grid.ColumnDefinitions>
                  <ColumnDefinition Width="230"/>
                  <ColumnDefinition Width="*"/>
                </Grid.ColumnDefinitions>
                <Grid Width="200" Height="200" HorizontalAlignment="Left">
                  <Ellipse Width="150" Height="150" Fill="#1800D46A">
                    <Ellipse.Effect><BlurEffect Radius="40"/></Ellipse.Effect>
                  </Ellipse>
                  <Ellipse Width="184" Height="184" Stroke="#222A36" StrokeThickness="14"/>
                  <Canvas Width="200" Height="200">
                    <Path x:Name="ArcScore" Stroke="{StaticResource Degrade}" StrokeThickness="14"
                          StrokeStartLineCap="Round" StrokeEndLineCap="Round">
                      <Path.Effect><DropShadowEffect Color="#00D46A" BlurRadius="14" ShadowDepth="0" Opacity="0.5"/></Path.Effect>
                    </Path>
                  </Canvas>
                  <StackPanel HorizontalAlignment="Center" VerticalAlignment="Center">
                    <TextBlock x:Name="TxtScore" Text="--" FontSize="52" FontWeight="Bold" HorizontalAlignment="Center"
                               FontFamily="Segoe UI Variable Display, Segoe UI"/>
                    <TextBlock Text="SCORE" FontSize="11" FontWeight="SemiBold" Foreground="#8C95A8" HorizontalAlignment="Center" Margin="0,-4,0,0"/>
                  </StackPanel>
                </Grid>
                <StackPanel Grid.Column="1" VerticalAlignment="Center">
                  <TextBlock x:Name="TxtScoreTitre" Text="Analyse en cours..." FontSize="21" FontWeight="SemiBold" FontFamily="Segoe UI Variable Display, Segoe UI"/>
                  <TextBlock x:Name="TxtScoreSous" Foreground="#9AA3B5" Margin="0,6,0,14" TextWrapping="Wrap"/>
                  <ItemsControl x:Name="ListeScore">
                    <ItemsControl.ItemsPanel>
                      <ItemsPanelTemplate><UniformGrid Columns="2"/></ItemsPanelTemplate>
                    </ItemsControl.ItemsPanel>
                    <ItemsControl.ItemTemplate>
                      <DataTemplate>
                        <StackPanel Orientation="Horizontal" Margin="0,3,12,3" ToolTip="{Binding Aide}" Cursor="Hand" Background="Transparent">
                          <TextBlock Text="{Binding Icone}" FontFamily="Segoe Fluent Icons, Segoe MDL2 Assets" FontSize="13"
                                     Foreground="{Binding Couleur}" VerticalAlignment="Center"/>
                          <TextBlock Text="{Binding Texte}" Margin="8,0,0,0" Foreground="#C9CFDA" FontSize="12.5" VerticalAlignment="Center"/>
                        </StackPanel>
                      </DataTemplate>
                    </ItemsControl.ItemTemplate>
                  </ItemsControl>
                  <StackPanel Orientation="Horizontal" Margin="0,18,0,0">
                    <Button x:Name="BtnToutFaire" Style="{StaticResource BtnPrincipal}" Padding="24,12" FontSize="14.5">
                      <StackPanel Orientation="Horizontal">
                        <TextBlock Text="&#xE945;" FontFamily="Segoe Fluent Icons, Segoe MDL2 Assets" VerticalAlignment="Center"/>
                        <TextBlock Text="Tout optimiser" Margin="8,0,0,0"/>
                      </StackPanel>
                      <Button.Triggers>
                        <EventTrigger RoutedEvent="FrameworkElement.Loaded">
                          <BeginStoryboard><Storyboard RepeatBehavior="Forever" AutoReverse="True">
                            <DoubleAnimation Storyboard.TargetProperty="(UIElement.Effect).(DropShadowEffect.BlurRadius)" From="12" To="30" Duration="0:0:1.4"/>
                            <DoubleAnimation Storyboard.TargetProperty="(UIElement.Effect).(DropShadowEffect.Opacity)" From="0.25" To="0.6" Duration="0:0:1.4"/>
                          </Storyboard></BeginStoryboard>
                        </EventTrigger>
                      </Button.Triggers>
                    </Button>
                    <Button x:Name="BtnVoirConseils" Style="{StaticResource BtnFantome}" Content="Voir les conseils" Margin="10,0,0,0"/>
                  </StackPanel>
                </StackPanel>
              </Grid>
            </Border>

            <UniformGrid Columns="4" Margin="-7,14,-7,0">
              <Border Style="{StaticResource CarteAnim}" Margin="7">
                <StackPanel>
                  <TextBlock Text="Processeur" Foreground="#8C95A8" FontSize="12"/>
                  <TextBlock x:Name="TxtCpu" Text="-- %" FontSize="26" FontWeight="SemiBold" Margin="0,4,0,8"/>
                  <Grid Height="6">
                    <Border CornerRadius="3" Background="#232A36"/>
                    <Border x:Name="BarreCpu" CornerRadius="3" Background="{StaticResource Degrade}" RenderTransformOrigin="0,0.5">
                      <Border.RenderTransform><ScaleTransform ScaleX="0"/></Border.RenderTransform>
                    </Border>
                  </Grid>
                  <TextBlock x:Name="TxtCpuNom" Foreground="#6F788B" FontSize="11.5" Margin="0,8,0,0" TextTrimming="CharacterEllipsis"/>
                </StackPanel>
              </Border>
              <Border Style="{StaticResource CarteAnim}" Margin="7">
                <StackPanel>
                  <TextBlock Text="Memoire (RAM)" Foreground="#8C95A8" FontSize="12"/>
                  <TextBlock x:Name="TxtRam" Text="-- %" FontSize="26" FontWeight="SemiBold" Margin="0,4,0,8"/>
                  <Grid Height="6">
                    <Border CornerRadius="3" Background="#232A36"/>
                    <Border x:Name="BarreRam" CornerRadius="3" Background="{StaticResource Degrade}" RenderTransformOrigin="0,0.5">
                      <Border.RenderTransform><ScaleTransform ScaleX="0"/></Border.RenderTransform>
                    </Border>
                  </Grid>
                  <DockPanel Margin="0,8,0,0">
                    <Button x:Name="BtnRamLiberer" DockPanel.Dock="Right" Style="{StaticResource Btn}" Content="Liberer" Padding="10,3" FontSize="11.5" Margin="8,-3,0,0"/>
                    <TextBlock x:Name="TxtRamNom" Foreground="#6F788B" FontSize="11.5" TextTrimming="CharacterEllipsis" VerticalAlignment="Center"/>
                  </DockPanel>
                </StackPanel>
              </Border>
              <Border Style="{StaticResource CarteAnim}" Margin="7">
                <StackPanel>
                  <TextBlock Text="Jeux en cours" Foreground="#8C95A8" FontSize="12"/>
                  <TextBlock x:Name="TxtJeuxNb" Text="0" FontSize="26" FontWeight="SemiBold" Margin="0,4,0,8"/>
                  <TextBlock x:Name="TxtJeuxNoms" Text="Lance un jeu : OptiGame le detecte tout seul." Foreground="#8C95A8" FontSize="12" TextWrapping="Wrap"/>
                </StackPanel>
              </Border>
              <Border Style="{StaticResource CarteAnim}" Margin="7" ToolTip="Temperature de ta carte graphique (la meme que le Gestionnaire des taches). OptiGame te previent si elle depasse 85 degres, meme en jeu.">
                <StackPanel>
                  <TextBlock Text="Temperatures" Foreground="#8C95A8" FontSize="12"/>
                  <TextBlock x:Name="TxtTempGpu" Text="--" FontSize="26" FontWeight="SemiBold" Margin="0,4,0,8"/>
                  <Grid Height="6">
                    <Border CornerRadius="3" Background="#232A36"/>
                    <Border x:Name="BarreTemp" CornerRadius="3" RenderTransformOrigin="0,0.5">
                      <Border.Background>
                        <LinearGradientBrush StartPoint="0,0" EndPoint="1,0">
                          <GradientStop Color="#3FE08E" Offset="0"/>
                          <GradientStop Color="#FFC24B" Offset="0.75"/>
                          <GradientStop Color="#FF5468" Offset="1"/>
                        </LinearGradientBrush>
                      </Border.Background>
                      <Border.RenderTransform><ScaleTransform ScaleX="0"/></Border.RenderTransform>
                    </Border>
                  </Grid>
                  <TextBlock x:Name="TxtTempDetail" Foreground="#6F788B" FontSize="11.5" Margin="0,8,0,0" TextWrapping="Wrap"/>
                </StackPanel>
              </Border>
            </UniformGrid>

            <TextBlock Text="TIMER RESOLUTION ET MEMOIRE" Style="{StaticResource Section}"/>
            <Border Style="{StaticResource Carte}" Padding="22,18">
              <Grid>
                <Grid.ColumnDefinitions>
                  <ColumnDefinition Width="*"/>
                  <ColumnDefinition Width="24"/>
                  <ColumnDefinition Width="340"/>
                </Grid.ColumnDefinitions>
                <StackPanel>
                  <TextBlock Text="Timer Resolution (precision de Windows)" Foreground="#8C95A8" FontSize="12"/>
                  <StackPanel Orientation="Horizontal" Margin="0,4,0,0">
                    <TextBlock x:Name="TxtTrActuel" Text="-- ms" FontSize="26" FontWeight="SemiBold" VerticalAlignment="Center"/>
                    <Border Style="{StaticResource Pastille}" x:Name="PastTr" Background="#1E2430" Margin="12,4,0,0">
                      <TextBlock x:Name="TxtTrEtat" Text="Par defaut" FontSize="11.5" Foreground="#8C95A8"/>
                    </Border>
                  </StackPanel>
                  <TextBlock x:Name="TxtTrInfo" Text="Plus la valeur est basse, plus Windows est precis : moins d'input lag et des images plus regulieres en jeu. Maximum = 0,500 ms." Foreground="#8C95A8" FontSize="12" TextWrapping="Wrap" Margin="0,4,0,0"/>
                  <WrapPanel Margin="0,14,0,0">
                    <Button x:Name="BtnTrMax" Style="{StaticResource BtnPrincipal}" Margin="0,0,10,8" Padding="16,10">
                      <StackPanel Orientation="Horizontal"><TextBlock Text="&#xE916;" FontFamily="{StaticResource Icones}" VerticalAlignment="Center"/><TextBlock Text="Maximum" Margin="8,0,0,0"/></StackPanel>
                    </Button>
                    <Button x:Name="BtnTrMemoire" Style="{StaticResource Btn}" Margin="0,0,10,8" Padding="16,10" ToolTip="Timer au maximum et memoire liberee en un clic.">
                      <StackPanel Orientation="Horizontal"><TextBlock Text="&#xE964;" FontFamily="{StaticResource Icones}" Foreground="#00D46A" VerticalAlignment="Center"/><TextBlock Text="Maximum + liberer la memoire" Margin="8,0,0,0"/></StackPanel>
                    </Button>
                    <Button x:Name="BtnTrDefaut" Style="{StaticResource Btn}" Content="Par defaut" Margin="0,0,10,8" Padding="16,10"/>
                    <Button x:Name="BtnTrTester" Style="{StaticResource BtnFantome}" Margin="0,0,10,8" Padding="16,10" ToolTip="Mesure la vraie precision qu'un jeu obtient, dans un programme a part.">
                      <StackPanel Orientation="Horizontal"><TextBlock Text="&#xE9D9;" FontFamily="{StaticResource Icones}" VerticalAlignment="Center"/><TextBlock Text="Verifier pour de vrai" Margin="8,0,0,0"/></StackPanel>
                    </Button>
                  </WrapPanel>
                  <Border x:Name="CadreTrTest" Visibility="Collapsed" Background="#12161E" CornerRadius="9" Padding="14,10" Margin="0,4,0,0">
                    <StackPanel>
                      <TextBlock x:Name="TxtTrTestTitre" FontWeight="SemiBold" TextWrapping="Wrap"/>
                      <TextBlock x:Name="TxtTrTestDetail" Foreground="#C9CFDA" FontSize="12" TextWrapping="Wrap" Margin="0,4,0,0" LineHeight="18"/>
                      <StackPanel x:Name="PanTrComparaison" Margin="0,10,0,0"/>
                    </StackPanel>
                  </Border>
                </StackPanel>
                <StackPanel Grid.Column="2">
                  <Border Background="#1A1F29" CornerRadius="10" Padding="12,10">
                    <CheckBox x:Name="ChkTrAuto" Style="{StaticResource Switch}">
                      <StackPanel>
                        <TextBlock Text="Toujours au maximum (meme OptiGame ferme)" FontWeight="SemiBold"/>
                        <TextBlock Text="Un petit programme invisible garde le timer au maximum, des que tu allumes le PC." Foreground="#8C95A8" FontSize="11.5" TextWrapping="Wrap"/>
                      </StackPanel>
                    </CheckBox>
                  </Border>
                  <Border Background="#1A1F29" CornerRadius="10" Padding="12,10" Margin="0,8,0,0">
                    <StackPanel>
                      <CheckBox x:Name="ChkDemarrage" Style="{StaticResource Switch}">
                        <StackPanel>
                          <TextBlock Text="Lancer OptiGame au demarrage du PC" FontWeight="SemiBold"/>
                          <TextBlock Text="Sans demande de confirmation Windows." Foreground="#8C95A8" FontSize="11.5" TextWrapping="Wrap"/>
                        </StackPanel>
                      </CheckBox>
                      <StackPanel x:Name="ZoneDemarrage" Margin="2,10,0,0">
                        <RadioButton x:Name="RbDemCache" GroupName="Demarrage" Content="En arriere-plan (icone pres de l'horloge)" Foreground="#C9CFDA" Margin="0,0,0,6" IsChecked="True"/>
                        <RadioButton x:Name="RbDemFenetre" GroupName="Demarrage" Content="Avec la fenetre complete" Foreground="#C9CFDA"/>
                      </StackPanel>
                    </StackPanel>
                  </Border>
                </StackPanel>
              </Grid>
            </Border>

            <TextBlock Text="ACTIONS RAPIDES" Style="{StaticResource Section}"/>
            <WrapPanel x:Name="ActionsRapides">
              <Button x:Name="BtnQBoost" Style="{StaticResource Btn}" Margin="0,0,10,10" Padding="16,11" ToolTip="Ferme les applis inutiles avant de jouer.">
                <StackPanel Orientation="Horizontal"><TextBlock Text="&#xE7FC;" FontFamily="Segoe Fluent Icons, Segoe MDL2 Assets" Foreground="#00D46A" VerticalAlignment="Center"/><TextBlock Text="Mode Boost" Margin="8,0,0,0"/></StackPanel>
              </Button>
              <Button x:Name="BtnQMemoire" Style="{StaticResource Btn}" Margin="0,0,10,10" Padding="16,11" ToolTip="Allege les applis en arriere-plan, sans toucher au jeu en cours.">
                <StackPanel Orientation="Horizontal"><TextBlock Text="&#xE964;" FontFamily="Segoe Fluent Icons, Segoe MDL2 Assets" Foreground="#00D46A" VerticalAlignment="Center"/><TextBlock Text="Liberer la memoire" Margin="8,0,0,0"/></StackPanel>
              </Button>
              <Button x:Name="BtnQNettoyage" Style="{StaticResource Btn}" Margin="0,0,10,10" Padding="16,11" ToolTip="Fichiers temporaires, caches, corbeille.">
                <StackPanel Orientation="Horizontal"><TextBlock Text="&#xE74D;" FontFamily="Segoe Fluent Icons, Segoe MDL2 Assets" Foreground="#00B2D6" VerticalAlignment="Center"/><TextBlock Text="Nettoyage" Margin="8,0,0,0"/></StackPanel>
              </Button>
              <Button x:Name="BtnQTest" Style="{StaticResource Btn}" Margin="0,0,10,10" Padding="16,11" ToolTip="Test rapide sans redemarrage (5 a 10 min).">
                <StackPanel Orientation="Horizontal"><TextBlock Text="&#xE9D9;" FontFamily="Segoe Fluent Icons, Segoe MDL2 Assets" Foreground="#FFC24B" VerticalAlignment="Center"/><TextBlock Text="Test rapide" Margin="8,0,0,0"/></StackPanel>
              </Button>
              <Button x:Name="BtnQDiag" Style="{StaticResource Btn}" Margin="0,0,10,10" Padding="16,11" ToolTip="Rapport complet sur le Bureau.">
                <StackPanel Orientation="Horizontal"><TextBlock Text="&#xE9F9;" FontFamily="Segoe Fluent Icons, Segoe MDL2 Assets" Foreground="#8AB4FF" VerticalAlignment="Center"/><TextBlock Text="Diagnostic" Margin="8,0,0,0"/></StackPanel>
              </Button>
              <Button x:Name="BtnQCaptures" Style="{StaticResource Btn}" Margin="0,0,10,10" Padding="16,11" ToolTip="Win+Maj+S ou Impr ecran ne fait plus rien ? Debloque et redemarre l'Outil Capture de Windows.">
                <StackPanel Orientation="Horizontal"><TextBlock Text="&#xE722;" FontFamily="Segoe Fluent Icons, Segoe MDL2 Assets" Foreground="#FF8AD8" VerticalAlignment="Center"/><TextBlock Text="Reparer les captures d'ecran" Margin="8,0,0,0"/></StackPanel>
              </Button>
            </WrapPanel>
          </StackPanel>
        </ScrollViewer>

        <!-- ========== OPTIMISATION ========== -->
        <ScrollViewer x:Name="PageOptim" VerticalScrollBarVisibility="Auto" Visibility="Collapsed">
          <StackPanel Margin="32,10,32,28">
            <TextBlock Text="Optimisation" Style="{StaticResource Titre}"/>
            <TextBlock Text="Chaque action cree d'abord un point de restauration. Tu peux tout annuler en bas de page." Style="{StaticResource SousTitre}"/>
            <Border Style="{StaticResource Carte}" Margin="0,22,0,0" Padding="26,22" Background="{StaticResource DegradHero}">
              <Grid>
                <Grid.ColumnDefinitions>
                  <ColumnDefinition Width="Auto"/>
                  <ColumnDefinition Width="*"/>
                  <ColumnDefinition Width="Auto"/>
                </Grid.ColumnDefinitions>
                <Border Width="58" Height="58" CornerRadius="16" Background="{StaticResource Degrade}" VerticalAlignment="Center">
                  <TextBlock Text="&#xE945;" FontFamily="Segoe Fluent Icons, Segoe MDL2 Assets" FontSize="26" Foreground="#06130C" HorizontalAlignment="Center" VerticalAlignment="Center"/>
                </Border>
                <StackPanel Grid.Column="1" Margin="18,0,18,0" VerticalAlignment="Center">
                  <TextBlock Text="Optimisation complete" FontSize="18" FontWeight="SemiBold"/>
                  <TextBlock Text="Point de restauration, reparation de Windows, performances, connexion, nettoyage, diagnostic et Mode Boost. Environ 30 a 45 minutes." Foreground="#9AA3B5" TextWrapping="Wrap" Margin="0,4,0,0"/>
                </StackPanel>
                <Button x:Name="BtnToutFaire2" Grid.Column="2" Style="{StaticResource BtnPrincipal}" Content="Tout optimiser" Padding="22,12" VerticalAlignment="Center"/>
              </Grid>
            </Border>
            <TextBlock Text="TOUTES LES ACTIONS" Style="{StaticResource Section}"/>
            <ItemsControl x:Name="ListeActions">
              <ItemsControl.ItemsPanel>
                <ItemsPanelTemplate><WrapPanel/></ItemsPanelTemplate>
              </ItemsControl.ItemsPanel>
              <ItemsControl.ItemTemplate>
                <DataTemplate>
                  <Border Style="{StaticResource CarteAnim}" Width="292" Margin="0,0,14,14" Padding="18">
                    <StackPanel>
                      <Border Width="40" Height="40" CornerRadius="11" Background="{Binding FondIcone}" HorizontalAlignment="Left">
                        <TextBlock Text="{Binding Icone}" FontFamily="Segoe Fluent Icons, Segoe MDL2 Assets" FontSize="18"
                                   Foreground="{Binding CouleurIcone}" HorizontalAlignment="Center" VerticalAlignment="Center"/>
                      </Border>
                      <TextBlock Text="{Binding Titre}" FontSize="15" FontWeight="SemiBold" Margin="0,12,0,4"/>
                      <TextBlock Text="{Binding Desc}" Foreground="#8C95A8" FontSize="12.5" TextWrapping="Wrap" Height="52"/>
                      <Button Style="{StaticResource Btn}" Content="{Binding Bouton}" Tag="{Binding Id}" HorizontalAlignment="Left"
                              Margin="0,10,0,0" Background="{Binding FondBouton}" Foreground="{Binding TexteBouton}" BorderBrush="{Binding BordBouton}"/>
                    </StackPanel>
                  </Border>
                </DataTemplate>
              </ItemsControl.ItemTemplate>
            </ItemsControl>
          </StackPanel>
        </ScrollViewer>

        <!-- ========== JEUX ========== -->
        <Grid x:Name="PageJeux" Margin="32,10,32,24" Visibility="Collapsed">
          <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
          </Grid.RowDefinitions>
          <StackPanel>
            <TextBlock Text="Jeux" Style="{StaticResource Titre}"/>
            <TextBlock Text="OptiGame ne change que des reglages caches (absents du menu du jeu) et de Windows : tes reglages en jeu restent les tiens. Ils sont verifies et remis tout seuls si un jeu ou une mise a jour les defait." Style="{StaticResource SousTitre}"/>
            <Border Style="{StaticResource Carte}" Margin="0,14,0,0" Padding="18,12">
              <UniformGrid Columns="2">
                <Grid Margin="0,4,18,8" ToolTip="Pour les PC a 2 ecrans : tous tes jeux passent en plein ecran fenetre a la resolution exacte de ton ecran principal. L'ecran ne se rallume plus, Windows ne bascule plus sur le 2e ecran, plus de resolution folle ni de crash en sortant du plein ecran. C'est l'inverse du vrai plein ecran : un seul des deux peut etre actif.">
                  <Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                  <StackPanel Margin="0,0,10,0">
                    <StackPanel Orientation="Horizontal">
                      <TextBlock Text="&#xE7F4;" FontFamily="Segoe Fluent Icons, Segoe MDL2 Assets" Foreground="#00D46A" FontSize="14" VerticalAlignment="Center"/>
                      <TextBlock Text="Anti-bug 2 ecrans (tous les jeux)" FontSize="14" FontWeight="SemiBold" Margin="9,0,0,0"/>
                    </StackPanel>
                    <TextBlock x:Name="TxtAntiBugTous" Foreground="#8C95A8" FontSize="11.5" TextWrapping="Wrap" Margin="23,3,0,0" Text="Plein ecran fenetre stable : plus de bugs avec 2 ecrans."/>
                  </StackPanel>
                  <CheckBox x:Name="ChkAntiBugTous" Grid.Column="1" Style="{StaticResource Switch}" VerticalAlignment="Center"/>
                </Grid>
                <Grid Margin="18,4,0,8" ToolTip="Plein ecran du menu du jeu ou Alt+Entree = le jeu prend l'ecran pour lui seul (vrai plein ecran exclusif), au lieu d'une fenetre sans bordure. Applique a tous tes jeux trouves, SAUF Fortnite : avec 2 ecrans il bugue (ecran noir, plein ecran sur les 2 ecrans), alors il garde son plein ecran fenetre stable sur l'ecran principal.">
                  <Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                  <StackPanel Margin="0,0,10,0">
                    <StackPanel Orientation="Horizontal">
                      <TextBlock Text="&#xE740;" FontFamily="Segoe Fluent Icons, Segoe MDL2 Assets" Foreground="#00D46A" FontSize="14" VerticalAlignment="Center"/>
                      <TextBlock Text="Vrai plein ecran (tous les jeux)" FontSize="14" FontWeight="SemiBold" Margin="9,0,0,0"/>
                    </StackPanel>
                    <TextBlock x:Name="TxtPleinEcranEtat" FontSize="11.5" TextWrapping="Wrap" Margin="23,3,0,0"/>
                  </StackPanel>
                  <CheckBox x:Name="ChkPleinEcran" Grid.Column="1" Style="{StaticResource Switch}" VerticalAlignment="Center"/>
                </Grid>
                <Grid Margin="0,8,18,4" ToolTip="Quand un jeu est en plein ecran, la souris ne peut pas aller sur l'autre ecran, meme dans les menus du jeu. Jeu en fenetre, Alt+Tab ou jeu reduit : la souris est libre tout de suite.">
                  <Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                  <StackPanel Margin="0,0,10,0">
                    <StackPanel Orientation="Horizontal">
                      <TextBlock Text="&#xE962;" FontFamily="Segoe Fluent Icons, Segoe MDL2 Assets" Foreground="#00D46A" FontSize="14" VerticalAlignment="Center"/>
                      <TextBlock Text="Souris bloquee sur l'ecran du jeu" FontSize="14" FontWeight="SemiBold" Margin="9,0,0,0"/>
                    </StackPanel>
                    <TextBlock Foreground="#8C95A8" FontSize="11.5" TextWrapping="Wrap" Margin="23,3,0,0" Text="Jeu en plein ecran : elle reste dessus. En fenetre : libre."/>
                  </StackPanel>
                  <CheckBox x:Name="ChkSourisJeu" Grid.Column="1" Style="{StaticResource Switch}" VerticalAlignment="Center"/>
                </Grid>
                <Grid Margin="18,8,0,4" ToolTip="Quand un jeu est en plein ecran, appuyer sur la touche Windows ne fait rien (plus de menu Demarrer qui te sort du jeu en pleine partie). Alt+Tab marche toujours. Si ton antivirus n'aime pas cette option, desactive-la.">
                  <Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                  <StackPanel Margin="0,0,10,0">
                    <StackPanel Orientation="Horizontal">
                      <TextBlock Text="&#xE765;" FontFamily="Segoe Fluent Icons, Segoe MDL2 Assets" Foreground="#00D46A" FontSize="14" VerticalAlignment="Center"/>
                      <TextBlock Text="Touche Windows desactivee en jeu" FontSize="14" FontWeight="SemiBold" Margin="9,0,0,0"/>
                    </StackPanel>
                    <TextBlock Foreground="#8C95A8" FontSize="11.5" TextWrapping="Wrap" Margin="23,3,0,0" Text="Plus de menu Demarrer qui te sort du jeu. Alt+Tab marche toujours."/>
                  </StackPanel>
                  <CheckBox x:Name="ChkWinJeu" Grid.Column="1" Style="{StaticResource Switch}" VerticalAlignment="Center"/>
                </Grid>
              </UniformGrid>
            </Border>
          </StackPanel>
          <Grid Grid.Row="1" Margin="0,20,0,0">
            <Grid.ColumnDefinitions>
              <ColumnDefinition Width="290"/>
              <ColumnDefinition Width="18"/>
              <ColumnDefinition Width="*"/>
            </Grid.ColumnDefinitions>
            <Border Style="{StaticResource Carte}" Padding="10">
              <DockPanel>
                <Border DockPanel.Dock="Bottom" Background="#1A1F29" CornerRadius="10" Padding="12,10" Margin="0,8,0,0">
                  <CheckBox x:Name="ChkAuto" Style="{StaticResource Switch}">
                    <StackPanel>
                      <TextBlock Text="Optimisation automatique" FontWeight="SemiBold"/>
                      <TextBlock Text="Mode Boost au lancement d'un jeu, reglages verifies a sa fermeture." Foreground="#8C95A8" FontSize="11.5" TextWrapping="Wrap"/>
                    </StackPanel>
                  </CheckBox>
                </Border>
                <ListBox x:Name="ListeJeux" Style="{StaticResource Liste}" ItemContainerStyle="{StaticResource Element}">
                  <ListBox.ItemTemplate>
                    <DataTemplate>
                      <Grid>
                        <Grid.ColumnDefinitions>
                          <ColumnDefinition Width="Auto"/>
                          <ColumnDefinition Width="*"/>
                          <ColumnDefinition Width="Auto"/>
                        </Grid.ColumnDefinitions>
                        <Ellipse x:Name="Point" Width="9" Height="9" Fill="{Binding Point}" VerticalAlignment="Center" Margin="0,0,12,0"/>
                        <StackPanel Grid.Column="1">
                          <TextBlock Text="{Binding Nom}" FontSize="13.5" FontWeight="SemiBold" Foreground="{Binding CouleurNom}"/>
                          <TextBlock Text="{Binding Statut}" FontSize="11.5" Foreground="#8C95A8" Margin="0,1,0,0"/>
                        </StackPanel>
                        <TextBlock Grid.Column="2" Text="&#xE73E;" FontFamily="Segoe Fluent Icons, Segoe MDL2 Assets" Foreground="#00D46A"
                                   VerticalAlignment="Center" Visibility="{Binding VisOpti}"/>
                      </Grid>
                      <DataTemplate.Triggers>
                        <DataTrigger Binding="{Binding EnCours}" Value="True">
                          <DataTrigger.EnterActions>
                            <BeginStoryboard><Storyboard RepeatBehavior="Forever" AutoReverse="True">
                              <DoubleAnimation Storyboard.TargetName="Point" Storyboard.TargetProperty="Opacity" From="1" To="0.2" Duration="0:0:0.7"/>
                            </Storyboard></BeginStoryboard>
                          </DataTrigger.EnterActions>
                        </DataTrigger>
                      </DataTemplate.Triggers>
                    </DataTemplate>
                  </ListBox.ItemTemplate>
                </ListBox>
              </DockPanel>
            </Border>

            <Border Grid.Column="2" Style="{StaticResource Carte}" Padding="24,20">
              <Grid>
                <Grid.RowDefinitions>
                  <RowDefinition Height="Auto"/>
                  <RowDefinition Height="*"/>
                  <RowDefinition Height="Auto"/>
                </Grid.RowDefinitions>
                <StackPanel>
                  <TextBlock x:Name="TxtJeuNom" FontSize="22" FontWeight="SemiBold" FontFamily="Segoe UI Variable Display, Segoe UI"/>
                  <TextBlock x:Name="TxtJeuEtat" Foreground="#8C95A8" FontSize="12.5" TextWrapping="Wrap" Margin="0,6,0,14"/>
                </StackPanel>
                <ScrollViewer Grid.Row="1" VerticalScrollBarVisibility="Auto">
                  <StackPanel>
                    <ItemsControl x:Name="ListeOptions">
                      <ItemsControl.ItemTemplate>
                        <DataTemplate>
                          <Border Background="#1A1F29" CornerRadius="11" Padding="14,12" Margin="0,0,0,8">
                            <CheckBox Style="{StaticResource Switch}" IsChecked="{Binding Coche, Mode=OneWay}" Tag="{Binding Nom}">
                              <StackPanel>
                                <StackPanel Orientation="Horizontal">
                                  <TextBlock Text="{Binding Nom}" FontSize="13.5" FontWeight="SemiBold" TextWrapping="Wrap"/>
                                  <Border Style="{StaticResource Pastille}" Background="#163626" Margin="10,0,0,0" Visibility="{Binding VisApplique}">
                                    <TextBlock Text="applique" FontSize="11" Foreground="#3FE08E"/>
                                  </Border>
                                  <Border Style="{StaticResource Pastille}" Background="#33270F" Margin="10,0,0,0" Visibility="{Binding VisEcart}" ToolTip="Le jeu a remis sa valeur. OptiGame la remettra quand le jeu sera ferme.">
                                    <TextBlock Text="remis a la fermeture du jeu" FontSize="11" Foreground="#FFC24B"/>
                                  </Border>
                                </StackPanel>
                                <TextBlock Text="{Binding Desc}" Foreground="#8C95A8" FontSize="12" TextWrapping="Wrap" Margin="0,3,0,0"/>
                              </StackPanel>
                            </CheckBox>
                          </Border>
                        </DataTemplate>
                      </ItemsControl.ItemTemplate>
                    </ItemsControl>
                    <TextBlock x:Name="TxtJeuVide" Foreground="#8C95A8" TextWrapping="Wrap" Visibility="Collapsed"
                               Text="Pas encore d'optimisation pour ce jeu. Il est quand meme detecte quand tu y joues."/>
                  </StackPanel>
                </ScrollViewer>
                <WrapPanel Grid.Row="2" Margin="0,14,0,0">
                  <Button x:Name="BtnJeuAppliquer" Style="{StaticResource BtnPrincipal}" Content="Appliquer les options cochees" Margin="0,0,10,8"/>
                  <Button x:Name="BtnJeuRestaurer" Style="{StaticResource BtnDanger}" Content="Remettre comme avant" Margin="0,0,10,8"/>
                  <Button x:Name="BtnJeuConseils" Style="{StaticResource Btn}" Content="Reglages conseilles" Margin="0,0,10,8"/>
                  <Button x:Name="BtnJeuVideo" Style="{StaticResource Btn}" Content="Video" Margin="0,0,10,8"/>
                  <Button x:Name="BtnJeuDossier" Style="{StaticResource Btn}" Content="Dossier des reglages" Margin="0,0,10,8"/>
                </WrapPanel>
              </Grid>
            </Border>
          </Grid>
        </Grid>

        <!-- ========== TEST ========== -->
        <Grid x:Name="PageTest" Margin="32,10,32,24" Visibility="Collapsed">
          <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
          </Grid.RowDefinitions>
          <StackPanel>
            <TextBlock Text="Test de performance" Style="{StaticResource Titre}"/>
            <TextBlock Text="Mesure ton PC, essaie chaque optimisation, mesure a nouveau, remet tout comme avant, et te montre ce qui vaut vraiment le coup." Style="{StaticResource SousTitre}"/>
          </StackPanel>
          <Grid Grid.Row="1" Margin="0,20,0,0">
            <Grid.ColumnDefinitions>
              <ColumnDefinition Width="*"/>
              <ColumnDefinition Width="18"/>
              <ColumnDefinition Width="*"/>
            </Grid.ColumnDefinitions>
            <Border Style="{StaticResource Carte}" Padding="24">
              <StackPanel>
                <Border Background="#1A1F29" CornerRadius="11" Padding="16,14">
                  <StackPanel>
                    <TextBlock Text="Test complet" FontWeight="SemiBold" FontSize="14"/>
                    <TextBlock Text="25 a 45 min, 3 ou 4 redemarrages automatiques. Le plus fiable." Foreground="#8C95A8" FontSize="12.5" TextWrapping="Wrap" Margin="0,3,0,10"/>
                    <Button x:Name="BtnTestComplet" Style="{StaticResource BtnPrincipal}" Content="Lancer le test complet" HorizontalAlignment="Left"/>
                  </StackPanel>
                </Border>
                <Border Background="#1A1F29" CornerRadius="11" Padding="16,14" Margin="0,10,0,0">
                  <StackPanel>
                    <TextBlock Text="Test rapide" FontWeight="SemiBold" FontSize="14"/>
                    <TextBlock Text="5 a 10 min, sans redemarrage. Un peu moins precis." Foreground="#8C95A8" FontSize="12.5" TextWrapping="Wrap" Margin="0,3,0,10"/>
                    <Button x:Name="BtnTestRapide" Style="{StaticResource Btn}" Content="Lancer le test rapide" HorizontalAlignment="Left"/>
                  </StackPanel>
                </Border>
                <TextBlock Text="Mesure : processeur, memoire, reactivite de Windows et charge au repos (pas les FPS en jeu)." Foreground="#6F788B" FontSize="12" TextWrapping="Wrap" Margin="2,14,0,0"/>
                <TextBlock x:Name="TxtPhase" Foreground="#FFC24B" FontWeight="SemiBold" FontSize="13.5" TextWrapping="Wrap" Margin="2,16,0,0"/>
                <TextBlock x:Name="TxtCompte" FontSize="20" FontWeight="SemiBold" Margin="2,6,0,0"/>
                <Button x:Name="BtnTestStop" Style="{StaticResource BtnDanger}" Content="Arreter le test et tout remettre" HorizontalAlignment="Left" Margin="0,12,0,0" IsEnabled="False"/>
              </StackPanel>
            </Border>
            <Border Grid.Column="2" Style="{StaticResource Carte}" Padding="24">
              <Grid>
                <Grid.RowDefinitions>
                  <RowDefinition Height="Auto"/>
                  <RowDefinition Height="*"/>
                  <RowDefinition Height="Auto"/>
                </Grid.RowDefinitions>
                <TextBlock Text="Resultats" FontSize="16" FontWeight="SemiBold" Margin="0,0,0,12"/>
                <ScrollViewer Grid.Row="1" VerticalScrollBarVisibility="Auto">
                  <StackPanel>
                    <ItemsControl x:Name="ListeResultats">
                      <ItemsControl.ItemTemplate>
                        <DataTemplate>
                          <Border Background="#1A1F29" CornerRadius="11" Padding="14,12" Margin="0,0,0,8" ToolTip="{Binding Conseil}">
                            <Grid>
                              <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="Auto"/>
                              </Grid.ColumnDefinitions>
                              <CheckBox Style="{StaticResource Switch}" IsChecked="{Binding Coche, Mode=OneWay}" IsEnabled="{Binding Activable}" Tag="{Binding Id}">
                                <StackPanel>
                                  <TextBlock Text="{Binding Nom}" FontWeight="SemiBold"/>
                                  <TextBlock Text="{Binding Meilleur}" Foreground="#8C95A8" FontSize="12"/>
                                </StackPanel>
                              </CheckBox>
                              <Border Grid.Column="1" Style="{StaticResource Pastille}" Background="{Binding FondVerdict}">
                                <TextBlock Text="{Binding Verdict}" FontSize="11.5" FontWeight="SemiBold" Foreground="{Binding CouleurVerdict}"/>
                              </Border>
                            </Grid>
                          </Border>
                        </DataTemplate>
                      </ItemsControl.ItemTemplate>
                    </ItemsControl>
                    <TextBlock x:Name="TxtTestVide" Foreground="#8C95A8" TextWrapping="Wrap" Text="Lance un test : les resultats s'afficheront ici."/>
                  </StackPanel>
                </ScrollViewer>
                <Button x:Name="BtnTestAppliquer" Grid.Row="2" Style="{StaticResource BtnPrincipal}" Content="Appliquer les optimisations cochees" HorizontalAlignment="Left" Margin="0,12,0,0"/>
              </Grid>
            </Border>
          </Grid>
        </Grid>

        <!-- ========== COMPOSANTS ========== -->
        <Grid x:Name="PageInfos" Margin="32,10,32,24" Visibility="Collapsed">
          <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
          </Grid.RowDefinitions>
          <Grid>
            <StackPanel>
              <TextBlock Text="Composants" Style="{StaticResource Titre}"/>
              <TextBlock Text="Ce qui est dans ton PC, et comment c'est regle." Style="{StaticResource SousTitre}"/>
            </StackPanel>
            <StackPanel Orientation="Horizontal" HorizontalAlignment="Right" VerticalAlignment="Bottom">
              <Button x:Name="BtnInfosActualiser" Style="{StaticResource Btn}" Content="Actualiser" Margin="0,0,10,0"/>
              <Button x:Name="BtnInfosCopier" Style="{StaticResource Btn}" Content="Copier les infos"/>
            </StackPanel>
          </Grid>
          <Border Grid.Row="1" Style="{StaticResource Carte}" Margin="0,20,0,0" Padding="8,10">
            <ScrollViewer VerticalScrollBarVisibility="Auto">
              <ItemsControl x:Name="ListeComposants">
                <ItemsControl.ItemTemplate>
                  <DataTemplate>
                    <Border BorderBrush="#1E2430" BorderThickness="0,0,0,1" Padding="14,9">
                      <Grid>
                        <Grid.ColumnDefinitions>
                          <ColumnDefinition Width="210"/>
                          <ColumnDefinition Width="*"/>
                        </Grid.ColumnDefinitions>
                        <TextBlock Text="{Binding Label}" Foreground="{Binding CouleurLabel}" FontWeight="{Binding Graisse}" Margin="{Binding Retrait}"/>
                        <TextBlock Grid.Column="1" Text="{Binding Valeur}" Foreground="{Binding Couleur}" TextWrapping="Wrap"/>
                      </Grid>
                    </Border>
                  </DataTemplate>
                </ItemsControl.ItemTemplate>
              </ItemsControl>
            </ScrollViewer>
          </Border>
        </Grid>

        <!-- ========== CONSEILS ========== -->
        <Grid x:Name="PageConseils" Margin="32,10,32,24" Visibility="Collapsed">
          <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
          </Grid.RowDefinitions>
          <Grid>
            <StackPanel>
              <TextBlock Text="Conseils pour ton PC" Style="{StaticResource Titre}"/>
              <TextBlock x:Name="TxtConseilsInfo" Style="{StaticResource SousTitre}"/>
            </StackPanel>
            <StackPanel Orientation="Horizontal" HorizontalAlignment="Right" VerticalAlignment="Bottom">
              <Button x:Name="BtnConseilsActualiser" Style="{StaticResource Btn}" Content="Actualiser" Margin="0,0,10,0"/>
              <Button x:Name="BtnConseilsTout" Style="{StaticResource Btn}" Content="Reafficher tout"/>
            </StackPanel>
          </Grid>
          <ScrollViewer Grid.Row="1" Margin="0,20,0,0" VerticalScrollBarVisibility="Auto">
            <ItemsControl x:Name="ListeConseils">
              <ItemsControl.ItemTemplate>
                <DataTemplate>
                  <Border Background="#161A23" BorderBrush="#232937" BorderThickness="1" CornerRadius="13" Margin="0,0,6,10">
                    <Grid>
                      <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="4"/>
                        <ColumnDefinition Width="*"/>
                      </Grid.ColumnDefinitions>
                      <Border Background="{Binding Couleur}" CornerRadius="13,0,0,13"/>
                      <StackPanel Grid.Column="1" Margin="18,14,18,14">
                        <Border Style="{StaticResource Pastille}" Background="{Binding Fond}">
                          <TextBlock Text="{Binding Niveau}" FontSize="11" FontWeight="Bold" Foreground="{Binding Couleur}"/>
                        </Border>
                        <TextBlock Text="{Binding Texte}" TextWrapping="Wrap" Margin="0,8,0,0" Foreground="#D5DAE3" LineHeight="19"/>
                        <Border Visibility="{Binding VisEtapes}" Background="#12161E" CornerRadius="9" Padding="14,10" Margin="0,10,0,0">
                          <StackPanel>
                            <TextBlock Text="COMMENT FAIRE" FontSize="11" FontWeight="SemiBold" Foreground="#8C95A8"/>
                            <TextBlock Text="{Binding Etapes}" TextWrapping="Wrap" Margin="0,6,0,0" Foreground="#C9CFDA" LineHeight="20"/>
                          </StackPanel>
                        </Border>
                        <ItemsControl ItemsSource="{Binding Actions}">
                          <ItemsControl.ItemsPanel>
                            <ItemsPanelTemplate><WrapPanel/></ItemsPanelTemplate>
                          </ItemsControl.ItemsPanel>
                          <ItemsControl.ItemTemplate>
                            <DataTemplate>
                              <Button Style="{StaticResource Btn}" Content="{Binding Label}" Tag="{Binding Cible}" ToolTip="{Binding Cible}"
                                      Padding="12,6" FontSize="12" Margin="0,10,8,0"/>
                            </DataTemplate>
                          </ItemsControl.ItemTemplate>
                        </ItemsControl>
                      </StackPanel>
                    </Grid>
                  </Border>
                </DataTemplate>
              </ItemsControl.ItemTemplate>
            </ItemsControl>
          </ScrollViewer>
        </Grid>

        <!-- ========== CE QUI A CHANGE ========== -->
        <Grid x:Name="PageHisto" Margin="32,10,32,24" Visibility="Collapsed">
          <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
          </Grid.RowDefinitions>
          <Grid>
            <StackPanel>
              <TextBlock Text="Ce qui a change" Style="{StaticResource Titre}"/>
              <TextBlock Text="Chaque reglage modifie : ce que c'est, avant et apres, et quel bouton l'a fait. Les essais du test de performance et la memoire liberee n'y apparaissent pas." Style="{StaticResource SousTitre}"/>
            </StackPanel>
            <Button x:Name="BtnHistoEffacer" Style="{StaticResource BtnDanger}" Content="Effacer l'historique" HorizontalAlignment="Right" VerticalAlignment="Bottom"/>
          </Grid>
          <Border Grid.Row="1" Style="{StaticResource Carte}" Margin="0,20,0,0" Padding="8,10">
            <Grid>
              <ScrollViewer VerticalScrollBarVisibility="Auto">
                <ItemsControl x:Name="ListeHisto">
                  <ItemsControl.ItemTemplate>
                    <DataTemplate>
                      <Border BorderBrush="#1E2430" BorderThickness="0,0,0,1" Padding="14,10">
                        <Grid>
                          <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="125"/>
                            <ColumnDefinition Width="2*"/>
                            <ColumnDefinition Width="1.4*"/>
                            <ColumnDefinition Width="34"/>
                            <ColumnDefinition Width="1.4*"/>
                          </Grid.ColumnDefinitions>
                          <TextBlock Text="{Binding Date}" Foreground="#6F788B" FontSize="12"/>
                          <StackPanel Grid.Column="1" Margin="0,0,12,0">
                            <TextBlock Text="{Binding Element}" TextWrapping="Wrap" FontWeight="SemiBold"/>
                            <TextBlock Text="{Binding Explication}" Visibility="{Binding VisExpl}" TextWrapping="Wrap" Foreground="#8C95A8" FontSize="12" Margin="0,3,0,0"/>
                            <TextBlock Text="{Binding Source}" TextWrapping="Wrap" Foreground="#00D46A" FontSize="11.5" Margin="0,3,0,0"/>
                          </StackPanel>
                          <TextBlock Grid.Column="2" Text="{Binding Avant}" Foreground="#8C95A8" TextWrapping="Wrap"/>
                          <TextBlock Grid.Column="3" Text="&#xE72A;" FontFamily="Segoe Fluent Icons, Segoe MDL2 Assets" Foreground="#00D46A" HorizontalAlignment="Center" VerticalAlignment="Center"/>
                          <TextBlock Grid.Column="4" Text="{Binding Apres}" Foreground="#3FE08E" FontWeight="SemiBold" TextWrapping="Wrap"/>
                        </Grid>
                      </Border>
                    </DataTemplate>
                  </ItemsControl.ItemTemplate>
                </ItemsControl>
              </ScrollViewer>
              <TextBlock x:Name="TxtHistoVide" Text="Aucun changement pour l'instant." Foreground="#8C95A8" Margin="14" Visibility="Collapsed"/>
            </Grid>
          </Border>
        </Grid>

        <!-- ========== JOURNAL ========== -->
        <Grid x:Name="PageJournal" Margin="32,10,32,24" Visibility="Collapsed">
          <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
          </Grid.RowDefinitions>
          <Grid>
            <StackPanel>
              <TextBlock Text="Journal" Style="{StaticResource Titre}"/>
              <TextBlock Text="Tout ce qu'OptiGame fait, en direct." Style="{StaticResource SousTitre}"/>
            </StackPanel>
            <StackPanel Orientation="Horizontal" HorizontalAlignment="Right" VerticalAlignment="Bottom">
              <Button x:Name="BtnJournalCopier" Style="{StaticResource Btn}" Content="Copier" Margin="0,0,10,0"/>
              <Button x:Name="BtnJournalVider" Style="{StaticResource BtnDanger}" Content="Vider"/>
            </StackPanel>
          </Grid>
          <Border Grid.Row="1" Style="{StaticResource Carte}" Margin="0,20,0,0" Padding="6" Background="#0F1218">
            <ListBox x:Name="ListeJournal" Style="{StaticResource Liste}" VirtualizingPanel.IsVirtualizing="True">
              <ListBox.ItemContainerStyle>
                <Style TargetType="ListBoxItem">
                  <Setter Property="Focusable" Value="False"/>
                  <Setter Property="Template">
                    <Setter.Value>
                      <ControlTemplate TargetType="ListBoxItem"><ContentPresenter Margin="10,1"/></ControlTemplate>
                    </Setter.Value>
                  </Setter>
                </Style>
              </ListBox.ItemContainerStyle>
              <ListBox.ItemTemplate>
                <DataTemplate>
                  <TextBlock Text="{Binding Texte}" Foreground="{Binding Couleur}" FontFamily="Cascadia Mono, Consolas" FontSize="12" TextWrapping="Wrap"/>
                </DataTemplate>
              </ListBox.ItemTemplate>
            </ListBox>
          </Border>
        </Grid>

        <!-- ========== ERREURS ========== -->
        <Grid x:Name="PageErreurs" Margin="32,10,32,24" Visibility="Collapsed">
          <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
          </Grid.RowDefinitions>
          <Grid>
            <StackPanel>
              <TextBlock Text="Erreurs" Style="{StaticResource Titre}"/>
              <TextBlock Text="OptiGame analyse chaque probleme. Copie l'erreur pour l'envoyer a Claude." Style="{StaticResource SousTitre}"/>
            </StackPanel>
            <StackPanel Orientation="Horizontal" HorizontalAlignment="Right" VerticalAlignment="Bottom">
              <Button x:Name="BtnErrCopierTout" Style="{StaticResource Btn}" Content="Copier tout" Margin="0,0,10,0"/>
              <Button x:Name="BtnErrEffacer" Style="{StaticResource BtnDanger}" Content="Effacer la liste"/>
            </StackPanel>
          </Grid>
          <Grid Grid.Row="1" Margin="0,20,0,0">
            <Grid.ColumnDefinitions>
              <ColumnDefinition Width="340"/>
              <ColumnDefinition Width="18"/>
              <ColumnDefinition Width="*"/>
            </Grid.ColumnDefinitions>
            <Border Style="{StaticResource Carte}" Padding="10">
              <Grid>
                <ListBox x:Name="ListeErreurs" Style="{StaticResource Liste}" ItemContainerStyle="{StaticResource Element}">
                  <ListBox.ItemTemplate>
                    <DataTemplate>
                      <StackPanel>
                        <TextBlock Text="{Binding Ou}" FontWeight="SemiBold" Foreground="#FF8A97" TextTrimming="CharacterEllipsis"/>
                        <TextBlock Text="{Binding Date}" Foreground="#6F788B" FontSize="11.5"/>
                        <TextBlock Text="{Binding Message}" Foreground="#8C95A8" FontSize="12" TextTrimming="CharacterEllipsis" MaxHeight="34" TextWrapping="Wrap"/>
                      </StackPanel>
                    </DataTemplate>
                  </ListBox.ItemTemplate>
                </ListBox>
                <StackPanel x:Name="ErreursVide" VerticalAlignment="Center" HorizontalAlignment="Center" Visibility="Collapsed">
                  <TextBlock Text="&#xE73E;" FontFamily="Segoe Fluent Icons, Segoe MDL2 Assets" FontSize="34" Foreground="#00D46A" HorizontalAlignment="Center"/>
                  <TextBlock Text="Aucune erreur. Tout va bien !" Foreground="#8C95A8" Margin="0,10,0,0"/>
                </StackPanel>
              </Grid>
            </Border>
            <Border Grid.Column="2" Style="{StaticResource Carte}" Padding="22">
              <Grid>
                <Grid.RowDefinitions>
                  <RowDefinition Height="Auto"/>
                  <RowDefinition Height="Auto"/>
                  <RowDefinition Height="*"/>
                  <RowDefinition Height="Auto"/>
                </Grid.RowDefinitions>
                <StackPanel>
                  <TextBlock Text="Cause probable" FontWeight="SemiBold" Foreground="#00D46A"/>
                  <TextBlock x:Name="TxtCause" Foreground="#FFC24B" TextWrapping="Wrap" Margin="0,6,0,0" LineHeight="19"/>
                </StackPanel>
                <Button x:Name="BtnCorriger" Grid.Row="1" Style="{StaticResource BtnPrincipal}" HorizontalAlignment="Left" Margin="0,14,0,0" Visibility="Collapsed"/>
                <DockPanel Grid.Row="2" Margin="0,18,0,0">
                  <TextBlock DockPanel.Dock="Top" Text="Detail technique" FontWeight="SemiBold" Foreground="#00D46A" Margin="0,0,0,8"/>
                  <TextBox x:Name="TxtDetail" Style="{StaticResource ZoneTexte}"/>
                </DockPanel>
                <Button x:Name="BtnErrCopier" Grid.Row="3" Style="{StaticResource Btn}" Content="Copier cette erreur" HorizontalAlignment="Left" Margin="0,14,0,0"/>
              </Grid>
            </Border>
          </Grid>
        </Grid>

        <!-- ========== ANTIVIRUS ========== -->
        <Grid x:Name="PageAntivirus" Margin="32,10,32,24" Visibility="Collapsed">
          <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
          </Grid.RowDefinitions>
          <Grid>
            <StackPanel Margin="0,0,180,0">
              <TextBlock Text="Antivirus" Style="{StaticResource Titre}"/>
              <TextBlock Text="OptiGame pilote Microsoft Defender, l'antivirus integre a Windows : etat de la protection, analyses, mises a jour et menaces trouvees." Style="{StaticResource SousTitre}"/>
            </StackPanel>
            <StackPanel Orientation="Horizontal" HorizontalAlignment="Right" VerticalAlignment="Bottom">
              <Button x:Name="BtnAvActualiser" Style="{StaticResource Btn}" Content="Actualiser" Margin="0,0,10,0"/>
              <Button x:Name="BtnAvSecurite" Style="{StaticResource Btn}" Content="Securite Windows"/>
            </StackPanel>
          </Grid>

          <!-- Etat -->
          <UniformGrid Grid.Row="1" Columns="4" Margin="-6,18,-6,0">
            <Border Style="{StaticResource Carte}" Margin="6" Padding="16,14">
              <StackPanel>
                <StackPanel Orientation="Horizontal">
                  <Ellipse x:Name="PtAvProtection" Width="9" Height="9" Fill="#5E677A" VerticalAlignment="Center"/>
                  <TextBlock Text="PROTECTION" FontSize="11" FontWeight="SemiBold" Foreground="#8C95A8" Margin="8,0,0,0"/>
                </StackPanel>
                <TextBlock x:Name="TxtAvProtection" Text="..." FontSize="15" FontWeight="SemiBold" Margin="0,8,0,0" TextWrapping="Wrap"/>
                <TextBlock x:Name="TxtAvProtectionSous" FontSize="12" Foreground="#8C95A8" Margin="0,3,0,0" TextWrapping="Wrap"/>
              </StackPanel>
            </Border>
            <Border Style="{StaticResource Carte}" Margin="6" Padding="16,14">
              <StackPanel>
                <StackPanel Orientation="Horizontal">
                  <Ellipse x:Name="PtAvDefinitions" Width="9" Height="9" Fill="#5E677A" VerticalAlignment="Center"/>
                  <TextBlock Text="DEFINITIONS DE VIRUS" FontSize="11" FontWeight="SemiBold" Foreground="#8C95A8" Margin="8,0,0,0"/>
                </StackPanel>
                <TextBlock x:Name="TxtAvDefinitions" Text="..." FontSize="15" FontWeight="SemiBold" Margin="0,8,0,0" TextWrapping="Wrap"/>
                <TextBlock x:Name="TxtAvDefinitionsSous" FontSize="12" Foreground="#8C95A8" Margin="0,3,0,0" TextWrapping="Wrap"/>
              </StackPanel>
            </Border>
            <Border Style="{StaticResource Carte}" Margin="6" Padding="16,14">
              <StackPanel>
                <StackPanel Orientation="Horizontal">
                  <Ellipse x:Name="PtAvAnalyse" Width="9" Height="9" Fill="#5E677A" VerticalAlignment="Center"/>
                  <TextBlock Text="DERNIERE ANALYSE" FontSize="11" FontWeight="SemiBold" Foreground="#8C95A8" Margin="8,0,0,0"/>
                </StackPanel>
                <TextBlock x:Name="TxtAvAnalyse" Text="..." FontSize="15" FontWeight="SemiBold" Margin="0,8,0,0" TextWrapping="Wrap"/>
                <TextBlock x:Name="TxtAvAnalyseSous" FontSize="12" Foreground="#8C95A8" Margin="0,3,0,0" TextWrapping="Wrap"/>
              </StackPanel>
            </Border>
            <Border Style="{StaticResource Carte}" Margin="6" Padding="16,14">
              <StackPanel>
                <StackPanel Orientation="Horizontal">
                  <Ellipse x:Name="PtAvExtra" Width="9" Height="9" Fill="#5E677A" VerticalAlignment="Center"/>
                  <TextBlock Text="PROTECTIONS EN PLUS" FontSize="11" FontWeight="SemiBold" Foreground="#8C95A8" Margin="8,0,0,0"/>
                </StackPanel>
                <TextBlock x:Name="TxtAvExtra" Text="..." FontSize="15" FontWeight="SemiBold" Margin="0,8,0,0" TextWrapping="Wrap"/>
                <TextBlock x:Name="TxtAvExtraSous" FontSize="12" Foreground="#8C95A8" Margin="0,3,0,0" TextWrapping="Wrap"/>
              </StackPanel>
            </Border>
          </UniformGrid>

          <!-- Analyses -->
          <Border Grid.Row="2" Style="{StaticResource Carte}" Margin="0,12,0,0">
            <StackPanel>
              <Grid>
                <StackPanel Margin="0,0,120,0">
                  <TextBlock x:Name="TxtAvScan" Text="Aucune analyse en cours" FontSize="15" FontWeight="SemiBold"/>
                  <TextBlock x:Name="TxtAvScanSous" Text="Analyse rapide : 1 a 5 min, les endroits ou les virus se cachent. Analyse complete : tout le PC, parfois plus d'une heure (tu peux jouer pendant)." FontSize="12" Foreground="#8C95A8" Margin="0,3,0,0" TextWrapping="Wrap"/>
                </StackPanel>
                <Button x:Name="BtnAvStop" Style="{StaticResource BtnDanger}" Content="Arreter" HorizontalAlignment="Right" VerticalAlignment="Center" Visibility="Collapsed"/>
              </Grid>
              <ProgressBar x:Name="BarAvScan" Height="5" Margin="0,12,0,0" IsIndeterminate="True" Foreground="#00D46A" Background="#1E2430" BorderThickness="0" Visibility="Collapsed"/>
              <WrapPanel Margin="0,14,0,0">
                <Button x:Name="BtnAvRapide" Style="{StaticResource BtnPrincipal}" Margin="0,0,10,8">
                  <StackPanel Orientation="Horizontal">
                    <TextBlock Text="&#xE721;" FontFamily="{StaticResource Icones}" FontSize="13" VerticalAlignment="Center" Margin="0,0,8,0"/>
                    <TextBlock Text="Analyse rapide"/>
                  </StackPanel>
                </Button>
                <Button x:Name="BtnAvComplete" Style="{StaticResource Btn}" Content="Analyse complete" Margin="0,0,10,8"/>
                <Button x:Name="BtnAvDossier" Style="{StaticResource Btn}" Content="Analyser un dossier..." Margin="0,0,10,8"/>
                <Button x:Name="BtnAvFichier" Style="{StaticResource Btn}" Content="Analyser un fichier..." Margin="0,0,10,8"/>
                <Button x:Name="BtnAvMaj" Style="{StaticResource Btn}" Content="Mettre a jour les definitions" Margin="0,0,10,8"/>
                <Button x:Name="BtnAvRenforcer" Style="{StaticResource BtnFantome}" Content="Renforcer la protection" Margin="0,0,10,8"/>
                <Button x:Name="BtnAvHorsLigne" Style="{StaticResource BtnFantome}" Content="Analyse hors ligne (redemarre)" Margin="0,0,10,8"/>
              </WrapPanel>
            </StackPanel>
          </Border>

          <!-- Menaces -->
          <Border Grid.Row="3" Style="{StaticResource Carte}" Margin="0,12,0,0" Padding="20,16">
            <Grid>
              <Grid.RowDefinitions>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="*"/>
              </Grid.RowDefinitions>
              <Grid>
                <TextBlock x:Name="TxtAvMenacesTitre" Text="Menaces detectees" FontSize="15" FontWeight="SemiBold" VerticalAlignment="Center"/>
                <Button x:Name="BtnAvSupprimer" Style="{StaticResource BtnDanger}" Content="Supprimer les menaces actives" HorizontalAlignment="Right" Visibility="Collapsed"/>
              </Grid>
              <TextBlock x:Name="TxtAvAucune" Grid.Row="1" Text="Aucune menace detectee. Ton PC est propre." Foreground="#3FE08E" FontSize="13.5" Margin="0,12,0,0"/>
              <ScrollViewer Grid.Row="1" Margin="0,10,0,0" VerticalScrollBarVisibility="Auto">
                <ItemsControl x:Name="ListeMenaces">
                  <ItemsControl.ItemTemplate>
                    <DataTemplate>
                      <Border BorderBrush="#1E2430" BorderThickness="0,0,0,1" Padding="4,9">
                        <Grid>
                          <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="Auto"/>
                          </Grid.ColumnDefinitions>
                          <StackPanel>
                            <TextBlock Text="{Binding Nom}" FontWeight="SemiBold" FontSize="13.5" TextTrimming="CharacterEllipsis"/>
                            <TextBlock Text="{Binding Detail}" Foreground="#8C95A8" FontSize="12" Margin="0,2,0,0" TextTrimming="CharacterEllipsis" ToolTip="{Binding Detail}"/>
                          </StackPanel>
                          <Border Grid.Column="1" Style="{StaticResource Pastille}" Background="{Binding FondEtat}" Margin="10,0,0,0">
                            <TextBlock Text="{Binding Etat}" FontSize="11.5" Foreground="{Binding CouleurEtat}"/>
                          </Border>
                        </Grid>
                      </Border>
                    </DataTemplate>
                  </ItemsControl.ItemTemplate>
                </ItemsControl>
              </ScrollViewer>
            </Grid>
          </Border>
        </Grid>

        <!-- ========== SPICETIFY ========== -->
        <ScrollViewer x:Name="PageSpicetify" VerticalScrollBarVisibility="Auto" Visibility="Collapsed">
        <StackPanel Margin="32,10,32,24">
          <Grid>
            <StackPanel Margin="0,0,140,0">
              <TextBlock Text="Spicetify" Style="{StaticResource Titre}"/>
              <TextBlock Text="Personnalise Spotify : themes, fonds d'ecran, couleurs, extensions. Il faut Spotify installe depuis spotify.com (la version Microsoft Store ne marche pas avec Spicetify)." Style="{StaticResource SousTitre}"/>
            </StackPanel>
            <Button x:Name="BtnSpActualiser" Style="{StaticResource Btn}" Content="Actualiser" HorizontalAlignment="Right" VerticalAlignment="Bottom"/>
          </Grid>

          <UniformGrid Columns="3" Margin="-6,18,-6,0">
            <Border Style="{StaticResource Carte}" Margin="6" Padding="16,14">
              <StackPanel>
                <StackPanel Orientation="Horizontal">
                  <Ellipse x:Name="PtSpSpotify" Width="9" Height="9" Fill="#5E677A" VerticalAlignment="Center"/>
                  <TextBlock Text="SPOTIFY" FontSize="11" FontWeight="SemiBold" Foreground="#8C95A8" Margin="8,0,0,0"/>
                </StackPanel>
                <TextBlock x:Name="TxtSpSpotify" Text="..." FontSize="15" FontWeight="SemiBold" Margin="0,8,0,0" TextWrapping="Wrap"/>
                <TextBlock x:Name="TxtSpSpotifySous" FontSize="12" Foreground="#8C95A8" Margin="0,3,0,0" TextWrapping="Wrap"/>
              </StackPanel>
            </Border>
            <Border Style="{StaticResource Carte}" Margin="6" Padding="16,14">
              <StackPanel>
                <StackPanel Orientation="Horizontal">
                  <Ellipse x:Name="PtSpCli" Width="9" Height="9" Fill="#5E677A" VerticalAlignment="Center"/>
                  <TextBlock Text="SPICETIFY" FontSize="11" FontWeight="SemiBold" Foreground="#8C95A8" Margin="8,0,0,0"/>
                </StackPanel>
                <TextBlock x:Name="TxtSpCli" Text="..." FontSize="15" FontWeight="SemiBold" Margin="0,8,0,0" TextWrapping="Wrap"/>
                <TextBlock x:Name="TxtSpCliSous" FontSize="12" Foreground="#8C95A8" Margin="0,3,0,0" TextWrapping="Wrap"/>
              </StackPanel>
            </Border>
            <Border Style="{StaticResource Carte}" Margin="6" Padding="16,14">
              <StackPanel>
                <StackPanel Orientation="Horizontal">
                  <Ellipse x:Name="PtSpMarket" Width="9" Height="9" Fill="#5E677A" VerticalAlignment="Center"/>
                  <TextBlock Text="MARKETPLACE (THEMES)" FontSize="11" FontWeight="SemiBold" Foreground="#8C95A8" Margin="8,0,0,0"/>
                </StackPanel>
                <TextBlock x:Name="TxtSpMarket" Text="..." FontSize="15" FontWeight="SemiBold" Margin="0,8,0,0" TextWrapping="Wrap"/>
                <TextBlock x:Name="TxtSpMarketSous" FontSize="12" Foreground="#8C95A8" Margin="0,3,0,0" TextWrapping="Wrap"/>
              </StackPanel>
            </Border>
          </UniformGrid>

          <Border Style="{StaticResource Carte}" Margin="0,12,0,0" Padding="16,12">
            <CheckBox x:Name="ChkSpAuto" Style="{StaticResource Switch}">
              <StackPanel>
                <TextBlock Text="Spicetify automatique" FontWeight="SemiBold" FontSize="14"/>
                <TextBlock Text="A chaque lancement d'OptiGame (puis toutes les 10 min) : installe Spicetify et le Marketplace s'ils manquent, et les reapplique tout seuls apres une mise a jour de Spotify. Les boutons ci-dessous restent la pour tout faire a la main en cas de souci." Foreground="#8C95A8" FontSize="12" TextWrapping="Wrap"/>
              </StackPanel>
            </CheckBox>
          </Border>


          <Border Style="{StaticResource Carte}" Margin="0,12,0,0">
            <StackPanel>
              <TextBlock Text="Installer" FontSize="15" FontWeight="SemiBold"/>
              <TextBlock Text="Une fenetre PowerShell s'ouvre (sans droits administrateur, comme Spicetify le demande). Reponds aux questions dedans : a &quot;Do you also want to install Spicetify Marketplace ?&quot; tape Y puis Entree pour avoir les themes." FontSize="12" Foreground="#8C95A8" Margin="0,3,0,0" TextWrapping="Wrap"/>
              <WrapPanel Margin="0,14,0,0">
                <Button x:Name="BtnSpInstaller" Style="{StaticResource BtnPrincipal}" Margin="0,0,10,8">
                  <StackPanel Orientation="Horizontal">
                    <TextBlock Text="&#xE896;" FontFamily="{StaticResource Icones}" FontSize="13" VerticalAlignment="Center" Margin="0,0,8,0"/>
                    <TextBlock Text="Installer Spicetify"/>
                  </StackPanel>
                </Button>
                <Button x:Name="BtnSpMarket" Style="{StaticResource Btn}" Content="Installer le Marketplace (themes)" Margin="0,0,10,8"/>
                <Button x:Name="BtnSpReappliquer" Style="{StaticResource Btn}" Content="Reappliquer apres une mise a jour de Spotify" Margin="0,0,10,8"/>
                <Button x:Name="BtnSpReparer" Style="{StaticResource Btn}" Content="Reparer Spotify (ecran Something went wrong)" Margin="0,0,10,8"/>
                <Button x:Name="BtnSpOrigine" Style="{StaticResource BtnFantome}" Content="Remettre Spotify normal (garder Spicetify)" Margin="0,0,10,8"/>
                <Button x:Name="BtnSpSpotify" Style="{StaticResource Btn}" Content="Installer Spotify (site officiel)" Margin="0,0,10,8"/>
              </WrapPanel>
              <TextBlock Text="OptiGame telecharge l'installateur officiel de Spicetify (github.com/spicetify/cli) et le lance dans cette fenetre." FontSize="12" Foreground="#5F687A" Margin="0,8,0,0" TextWrapping="Wrap"/>
            </StackPanel>
          </Border>

          <Border Style="{StaticResource Carte}" Margin="0,12,0,0">
            <StackPanel>
              <TextBlock Text="Mettre un theme ou un fond custom" FontSize="15" FontWeight="SemiBold"/>
              <TextBlock FontSize="13" Foreground="#C9CFDA" Margin="0,8,0,0" TextWrapping="Wrap" LineHeight="21"
                         Text="1. Ouvre Spotify : une icone Marketplace (panier) apparait en haut a gauche.&#10;2. Onglet Themes : choisis un theme et clique Install (il s'applique tout de suite).&#10;3. Pour un fond d'ecran perso : cherche un theme avec image de fond, ou l'extension Full App Display dans l'onglet Extensions.&#10;4. Apres chaque mise a jour de Spotify, clique sur Reappliquer apres une mise a jour de Spotify."/>
              <WrapPanel Margin="0,14,0,0">
                <Button x:Name="BtnSpThemes" Style="{StaticResource BtnFantome}" Content="Dossier des themes" Margin="0,0,10,8"/>
                <Button x:Name="BtnSpSite" Style="{StaticResource BtnFantome}" Content="Site Spicetify" Margin="0,0,10,8"/>
              </WrapPanel>
            </StackPanel>
          </Border>

          <Border Style="{StaticResource Carte}" Margin="0,12,0,0">
            <Grid>
              <StackPanel Margin="0,0,220,0">
                <TextBlock Text="Desinstaller Spicetify" FontSize="15" FontWeight="SemiBold"/>
                <TextBlock Text="Remet Spotify d'origine (spicetify restore), puis supprime Spicetify, ses themes et le Marketplace. Spotify reste installe." FontSize="12" Foreground="#8C95A8" Margin="0,3,0,0" TextWrapping="Wrap"/>
              </StackPanel>
              <Button x:Name="BtnSpDesinstaller" Style="{StaticResource BtnDanger}" Content="Desinstaller Spicetify" HorizontalAlignment="Right" VerticalAlignment="Center"/>
            </Grid>
          </Border>
        </StackPanel>
        </ScrollViewer>

        <!-- ========== ECRAN OLED ========== -->
        <!-- ========== SPEED TEST ========== -->
        <ScrollViewer x:Name="PageSpeed" VerticalScrollBarVisibility="Auto" Visibility="Collapsed">
          <StackPanel Margin="32,10,32,28">
            <TextBlock Text="Reseau" Style="{StaticResource Titre}"/>
            <TextBlock Text="Tout sur ta connexion : son etat, un speed test officiel (speedtest.net) avec le verdict pour jouer, et le DNS le plus rapide." Style="{StaticResource SousTitre}"/>
            <TextBlock Text="ETAT DE LA CONNEXION" Style="{StaticResource Section}"/>
            <Border Style="{StaticResource Carte}">
              <Grid>
                <Grid.ColumnDefinitions>
                  <ColumnDefinition Width="*"/>
                  <ColumnDefinition Width="Auto"/>
                </Grid.ColumnDefinitions>
                <TextBlock x:Name="TxtNetEtat" Text="Lecture de ta connexion..." Foreground="#C9CFDA" FontSize="12.5" TextWrapping="Wrap" LineHeight="20" Margin="0,0,14,0"/>
                <StackPanel Grid.Column="1" VerticalAlignment="Top">
                  <Button x:Name="BtnNetActualiser" Style="{StaticResource Btn}" Content="Actualiser" Padding="16,9" Margin="0,0,0,8"/>
                  <Button x:Name="BtnNetReparer" Style="{StaticResource Btn}" Content="Reparer la connexion" Padding="16,9"
                          ToolTip="Vide le cache DNS et renouvelle l'adresse IP, sans couper la connexion. Utile si des sites ou un jeu ne se connectent plus."/>
                </StackPanel>
              </Grid>
            </Border>

            <TextBlock Text="SPEED TEST" Style="{StaticResource Section}"/>
            <Border Style="{StaticResource Carte}" Padding="26,22" Background="{StaticResource DegradHero}">
              <Grid>
                <Grid.ColumnDefinitions>
                  <ColumnDefinition Width="240"/>
                  <ColumnDefinition Width="*"/>
                </Grid.ColumnDefinitions>
                <Grid Width="220" Height="220" HorizontalAlignment="Left">
                  <Canvas Width="220" Height="220">
                    <Path x:Name="ArcSpeedFond" Stroke="#222A36" StrokeThickness="14" StrokeStartLineCap="Round" StrokeEndLineCap="Round"/>
                    <Path x:Name="ArcSpeed" Stroke="{StaticResource Degrade}" StrokeThickness="14" StrokeStartLineCap="Round" StrokeEndLineCap="Round"/>
                  </Canvas>
                  <StackPanel HorizontalAlignment="Center" VerticalAlignment="Center">
                    <TextBlock x:Name="TxtSpGros" Text="-" FontSize="44" FontWeight="SemiBold" HorizontalAlignment="Center" FontFamily="Segoe UI Variable Display, Segoe UI"/>
                    <Slider x:Name="ValSpeed" Minimum="0" Maximum="1000000" Visibility="Collapsed"/>
                    <TextBlock x:Name="TxtSpUnite" Text="Mb/s" FontSize="13" Foreground="#8C95A8" HorizontalAlignment="Center"/>
                  </StackPanel>
                </Grid>
                <StackPanel Grid.Column="1" VerticalAlignment="Center" Margin="10,0,0,0">
                  <TextBlock x:Name="TxtSpPhase" Text="Pret." FontSize="16" FontWeight="SemiBold" TextWrapping="Wrap"/>
                  <TextBlock x:Name="TxtSpServeur" Text="Serveur : le meilleur pres de chez toi (choisi automatiquement)" TextWrapping="Wrap" Foreground="#8C95A8" FontSize="12.5" Margin="0,4,0,12"/>
                  <ProgressBar x:Name="BarreSpeed" Style="{StaticResource BarreRonde}" Height="6" Minimum="0" Maximum="100" Value="0" Foreground="{StaticResource Degrade}" Background="#222A36" BorderThickness="0" Margin="0,0,0,16"/>
                  <WrapPanel>
                    <Button x:Name="BtnSpeedGo" Style="{StaticResource BtnPrincipal}" Content="Lancer le test" Padding="22,11" FontSize="14" Margin="0,0,10,8"/>
                    <Button x:Name="BtnSpeedSite" Style="{StaticResource BtnFantome}" Content="Comparer sur speedtest.net" Padding="16,11" Margin="0,0,10,8"/>
                  </WrapPanel>
                  <TextBlock Foreground="#8C95A8" FontSize="11.5" TextWrapping="Wrap" Margin="0,6,0,0"
                             Text="Pour un resultat juste : ferme les telechargements (Steam, Epic, mises a jour) et le streaming pendant le test."/>
                  <TextBlock Foreground="#6F788B" FontSize="11" TextWrapping="Wrap" Margin="0,6,0,0"
                             Text="Utilise l'outil officiel Speedtest by Ookla (le meme que speedtest.net, gratuit pour un usage personnel), dans un programme a part. Lancer le test = accepter sa licence et sa politique de confidentialite (speedtest.net/about/eula)."/>
                </StackPanel>
              </Grid>
            </Border>

            <UniformGrid Columns="5" Margin="0,16,0,0">
              <Border Style="{StaticResource Carte}" Padding="16,14" Margin="0,0,10,0" ToolTip="Temps d'aller-retour vers le serveur : plus c'est bas, plus tes actions arrivent vite.">
                <StackPanel><TextBlock Text="PING" FontSize="11" FontWeight="SemiBold" Foreground="#8C95A8"/><TextBlock x:Name="TxtSpPing" Text="-" FontSize="22" FontWeight="SemiBold" Margin="0,4,0,0"/></StackPanel>
              </Border>
              <Border Style="{StaticResource Carte}" Padding="16,14" Margin="0,0,10,0" ToolTip="Variation du ping (jitter) : plus c'est bas, plus la connexion est reguliere (pas de teleportations en jeu).">
                <StackPanel><TextBlock Text="STABILITE" FontSize="11" FontWeight="SemiBold" Foreground="#8C95A8"/><TextBlock x:Name="TxtSpJitter" Text="-" FontSize="22" FontWeight="SemiBold" Margin="0,4,0,0"/></StackPanel>
              </Border>
              <Border Style="{StaticResource Carte}" Padding="16,14" Margin="0,0,10,0" ToolTip="Ping mesure pendant que la connexion est a fond : montre si ton ping explose quand quelqu'un telecharge chez toi (bufferbloat).">
                <StackPanel><TextBlock Text="PING EN CHARGE" FontSize="11" FontWeight="SemiBold" Foreground="#8C95A8"/><TextBlock x:Name="TxtSpCharge" Text="-" FontSize="22" FontWeight="SemiBold" Margin="0,4,0,0"/></StackPanel>
              </Border>
              <Border Style="{StaticResource Carte}" Padding="16,14" Margin="0,0,10,0" ToolTip="Vitesse de reception (telechargements, streaming, mises a jour de jeux).">
                <StackPanel><TextBlock Text="DESCENDANT" FontSize="11" FontWeight="SemiBold" Foreground="#8C95A8"/><TextBlock x:Name="TxtSpDown" Text="-" FontSize="22" FontWeight="SemiBold" Margin="0,4,0,0"/></StackPanel>
              </Border>
              <Border Style="{StaticResource Carte}" Padding="16,14" ToolTip="Vitesse d'envoi (stream Twitch, partage d'ecran Discord, envoi de fichiers).">
                <StackPanel><TextBlock Text="MONTANT" FontSize="11" FontWeight="SemiBold" Foreground="#8C95A8"/><TextBlock x:Name="TxtSpUp" Text="-" FontSize="22" FontWeight="SemiBold" Margin="0,4,0,0"/></StackPanel>
              </Border>
            </UniformGrid>

            <TextBlock Text="CE QUE CA DONNE POUR JOUER" Style="{StaticResource Section}"/>
            <Border Style="{StaticResource Carte}">
              <StackPanel x:Name="PanSpeedConseils">
                <TextBlock Text="Lance un test pour voir le verdict." Foreground="#8C95A8" FontSize="12.5"/>
              </StackPanel>
            </Border>

            <TextBlock Text="HISTORIQUE" Style="{StaticResource Section}"/>
            <Border Style="{StaticResource Carte}" Padding="18,12">
              <StackPanel>
                <TextBlock x:Name="TxtSpeedHistoVide" Text="Aucun test pour l'instant." Foreground="#8C95A8" FontSize="12.5"/>
                <ItemsControl x:Name="ListeSpeed">
                  <ItemsControl.ItemTemplate>
                    <DataTemplate>
                      <Border BorderBrush="#1E2430" BorderThickness="0,0,0,1" Padding="2,8">
                        <Grid>
                          <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="150"/>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="70"/>
                          </Grid.ColumnDefinitions>
                          <TextBlock Text="{Binding Date}" Foreground="#8C95A8" FontSize="12.5"/>
                          <TextBlock Grid.Column="1" Text="{Binding Ping}" FontSize="12.5"/>
                          <TextBlock Grid.Column="2" Text="{Binding Jitter}" Foreground="#C9CFDA" FontSize="12.5"/>
                          <TextBlock Grid.Column="3" Text="{Binding Down}" FontSize="12.5"/>
                          <TextBlock Grid.Column="4" Text="{Binding Up}" FontSize="12.5"/>
                          <TextBlock Grid.Column="5" Text="{Binding Lien}" Foreground="#8C95A8" FontSize="12"/>
                        </Grid>
                      </Border>
                    </DataTemplate>
                  </ItemsControl.ItemTemplate>
                </ItemsControl>
              </StackPanel>
            </Border>

            <TextBlock Text="DNS LE PLUS RAPIDE" Style="{StaticResource Section}"/>
            <Border Style="{StaticResource Carte}">
              <StackPanel>
                <TextBlock Foreground="#C9CFDA" FontSize="12.5" TextWrapping="Wrap" LineHeight="19"
                           Text="Le DNS, c'est l'annuaire d'internet : il traduit les noms (discord.com, les serveurs de jeux...) en adresses. Un DNS plus rapide fait demarrer plus vite les connexions, les sites et les menus en ligne. Il ne change pas ton ping en pleine partie. OptiGame teste les meilleurs DNS gratuits depuis chez toi et met le plus rapide en un clic (annulable)."/>
                <TextBlock x:Name="TxtDnsActuel" Foreground="#8C95A8" FontSize="12" Margin="0,10,0,0" TextWrapping="Wrap"/>
                <WrapPanel Margin="0,12,0,0">
                  <Button x:Name="BtnDnsTester" Style="{StaticResource BtnPrincipal}" Content="Tester les DNS" Padding="18,10" Margin="0,0,10,8"/>
                  <Button x:Name="BtnDnsRemettre" Style="{StaticResource BtnDanger}" Content="Remettre le DNS d'origine" Padding="16,10" Margin="0,0,10,8" Visibility="Collapsed"/>
                </WrapPanel>
                <TextBlock x:Name="TxtDnsEtat" Foreground="#C9CFDA" FontSize="12.5" TextWrapping="Wrap" Margin="0,4,0,8"/>
                <ItemsControl x:Name="ListeDns">
                  <ItemsControl.ItemTemplate>
                    <DataTemplate>
                      <Border BorderBrush="#1E2430" BorderThickness="0,0,0,1" Padding="2,9">
                        <Grid>
                          <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="230"/>
                            <ColumnDefinition Width="240"/>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="Auto"/>
                          </Grid.ColumnDefinitions>
                          <StackPanel>
                            <TextBlock Text="{Binding Nom}" FontWeight="SemiBold" Foreground="{Binding Couleur}"/>
                            <TextBlock Text="{Binding Info}" Foreground="#8C95A8" FontSize="11.5" TextWrapping="Wrap" Margin="0,2,10,0"/>
                          </StackPanel>
                          <Border Grid.Column="1" Height="8" CornerRadius="4" Background="{Binding Couleur}" Width="{Binding Largeur}" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                          <TextBlock Grid.Column="2" Text="{Binding Temps}" FontWeight="SemiBold" VerticalAlignment="Center" Margin="10,0,10,0"/>
                          <Button Grid.Column="3" Style="{StaticResource Btn}" Content="Utiliser" Tag="{Binding Fournisseur}" Visibility="{Binding VisUtiliser}" Padding="14,6" FontSize="12" VerticalAlignment="Center"/>
                        </Grid>
                      </Border>
                    </DataTemplate>
                  </ItemsControl.ItemTemplate>
                </ItemsControl>
              </StackPanel>
            </Border>
          </StackPanel>
        </ScrollViewer>

        <ScrollViewer x:Name="PageOled" VerticalScrollBarVisibility="Auto" Visibility="Collapsed">
          <StackPanel Margin="32,10,32,28">
            <TextBlock Text="Ecran" Style="{StaticResource Titre}"/>
            <TextBlock Text="Bords ultra lisses, image plus nette, degrades sans marches (anti-banding) et rendu facon OLED. Tout se remet comme avant en un clic." Style="{StaticResource SousTitre}"/>
            <TextBlock Text="BORDS ULTRA LISSES (QUALITE VISUELLE MAX)" Style="{StaticResource Section}"/>
            <Border Style="{StaticResource Carte}">
              <StackPanel>
                <Grid>
                  <StackPanel Margin="0,0,250,0">
                    <TextBlock Text="Un bouton : bords lisses au maximum dans tes jeux" FontSize="15" FontWeight="SemiBold"/>
                    <TextBlock x:Name="TxtQualiteMax" FontSize="12.5" Margin="0,4,0,0" TextWrapping="Wrap"/>
                  </StackPanel>
                  <StackPanel HorizontalAlignment="Right" VerticalAlignment="Center">
                    <Button x:Name="BtnQualiteMax" Style="{StaticResource BtnPrincipal}" Content="Activer les bords ultra lisses" Padding="18,11"/>
                    <Button x:Name="BtnQualiteMaxOff" Style="{StaticResource BtnDanger}" Content="Desactiver (plus de FPS)" Padding="18,11" Visibility="Collapsed"/>
                  </StackPanel>
                </Grid>
                <TextBlock Foreground="#C9CFDA" FontSize="12.5" TextWrapping="Wrap" LineHeight="19" Margin="0,12,0,0"
                           Text="Reglages caches des jeux (pas ceux du menu), annulables d'un clic :&#10;- Roblox : anticrenelage force en 8x (plus aucun escalier sur les bords), textures toujours au maximum, et l'eclairage le plus realiste de Roblox (ombres et lumieres calculees pixel par pixel : le plus proche du ray tracing sur Roblox, si Roblox accepte encore ce FastFlag).&#10;- Rocket League : anticrenelage 8x (si ta version du jeu a ce reglage).&#10;- Palworld : lissage temporel en haute qualite + accentuation de l'image + textures nettes au loin."/>
                <TextBlock Foreground="#FFC24B" FontSize="12" TextWrapping="Wrap" Margin="0,8,0,0"
                           Text="Ca coute des FPS (surtout l'anticrenelage 8x). Pour le competitif, garde plutot les FPS : desactive avant une partie classee si ca baisse trop."/>
                <Border Background="#12161E" CornerRadius="9" Padding="14,10" Margin="0,12,0,0">
                  <StackPanel>
                    <TextBlock Text="POUR TOUS LES AUTRES JEUX (AMD Software > Jeux > Graphiques)" FontSize="11" FontWeight="SemiBold" Foreground="#8C95A8"/>
                    <TextBlock TextWrapping="Wrap" Margin="0,6,0,0" Foreground="#C9CFDA" LineHeight="20"
                               Text="1. Filtrage morphologique : Active (lisse les bords dans les jeux DirectX 9 a 11, comme Rocket League).&#10;2. Filtrage anisotrope : Active, niveau 16x. Qualite du filtrage des textures : Haute.&#10;3. Radeon Image Sharpening : Active, 60 a 80 % (bords plus traces).&#10;4. Le plus lisse possible (supersampling) : onglet Affichage > Super resolution virtuelle (VSR) : Active. Tu peux ensuite choisir dans un jeu une resolution plus grande que ton ecran : l'image est calculee en grand puis reduite, les bords deviennent ultra lisses (mais beaucoup moins de FPS).&#10;5. Vrai ray tracing : Fortnite le propose dans son menu (DirectX 12 > Eclairage Lumen + reflets en ray tracing materiel). Ta RX 6600 le supporte, mais les FPS chutent fortement."/>
                  </StackPanel>
                </Border>
                <WrapPanel Margin="0,10,0,0">
                  <Button x:Name="BtnQualiteAmd" Style="{StaticResource Btn}" Content="Ouvrir AMD Software" Margin="0,0,10,8" Padding="16,9"/>
                </WrapPanel>
              </StackPanel>
            </Border>

            <TextBlock Text="IMAGE PLUS NETTE" Style="{StaticResource Section}"/>
            <Border Style="{StaticResource Carte}">
              <StackPanel>
                <TextBlock Foreground="#C9CFDA" FontSize="12.5" TextWrapping="Wrap" LineHeight="19"
                           Text="Une image floue vient presque toujours de 4 choses : une resolution qui n'est pas celle de l'ecran (Windows etire l'image), une frequence trop basse (flou quand ca bouge), un texte mal lisse, ou un jeu affiche en dessous de la resolution de l'ecran. Tout se regle ici."/>
                <Border Background="#12161E" CornerRadius="9" Padding="14,10" Margin="0,10,0,0">
                  <TextBlock TextWrapping="Wrap" Foreground="#9AA3B5" FontSize="12" LineHeight="18"
                             Text="Et le ray tracing ? Il ne rend pas l'image plus nette : c'est un eclairage plus realiste (reflets, ombres, lumiere) dans les jeux qui le proposent, et il se regle dans le menu du jeu. Sur une RX 6600 il fait perdre beaucoup d'images par seconde. Pour la nettete, ce qui compte vraiment c'est tout ce qui est en dessous (surtout l'accentuation AMD en jeu)."/>
                </Border>

                <TextBlock Text="1. RESOLUTION ET FREQUENCE DE TES ECRANS" FontSize="11.5" FontWeight="SemiBold" Foreground="#8C95A8" Margin="0,18,0,8"/>
                <StackPanel x:Name="PanNetEcrans"/>
                <WrapPanel Margin="0,6,0,0">
                  <Button x:Name="BtnNetMax" Style="{StaticResource BtnPrincipal}" Content="Tout mettre au plus net" Margin="0,0,10,8" Padding="16,9"
                          ToolTip="Resolution native + frequence maximale sur chaque ecran. Si l'image ne s'affiche pas bien, tout revient tout seul au bout de 15 secondes."/>
                  <Button x:Name="BtnNetAnalyser" Style="{StaticResource Btn}" Content="Analyser" Margin="0,0,10,8" Padding="16,9"/>
                  <Button x:Name="BtnNetUfo" Style="{StaticResource BtnFantome}" Content="Tester le flou de mouvement (testufo.com)" Margin="0,0,10,8" Padding="16,9"/>
                </WrapPanel>

                <TextBlock Text="2. TEXTE ET APPLIS" FontSize="11.5" FontWeight="SemiBold" Foreground="#8C95A8" Margin="0,18,0,8"/>
                <CheckBox x:Name="ChkClearType" Style="{StaticResource Switch}" Margin="0,0,0,10"
                          Content="Texte net (ClearType) : les lettres sont lissees au niveau des sous-pixels, bords plus fins et plus precis"/>
                <CheckBox x:Name="ChkDpiFlou" Style="{StaticResource Switch}" Margin="0,0,0,10"
                          Content="Corriger les applis floues : Windows redessine net les vieilles applis quand ta mise a l'echelle n'est pas 100 % (s'applique a leur prochaine ouverture)"/>
                <WrapPanel>
                  <Button x:Name="BtnNetClearType" Style="{StaticResource Btn}" Content="Regler le texte a ton oeil (5 etapes)" Margin="0,0,10,8" Padding="16,9"
                          ToolTip="Outil de Windows : tu choisis 5 fois le texte qui te parait le plus net, il regle le lissage pour TON ecran."/>
                </WrapPanel>

                <TextBlock Text="3. NETTETE EN JEU (CARTE AMD)" FontSize="11.5" FontWeight="SemiBold" Foreground="#8C95A8" Margin="0,18,0,8"/>
                <TextBlock Foreground="#C9CFDA" FontSize="12.5" TextWrapping="Wrap" LineHeight="19"
                           Text="L'accentuation d'image AMD (Radeon Image Sharpening) rend les bords plus traces et les textures plus nettes dans tous les jeux, sans perte d'images par seconde. C'est le reglage le plus efficace contre le flou en jeu, surtout si le jeu utilise FSR ou une echelle de rendu sous 100 %."/>
                <Border Background="#12161E" CornerRadius="9" Padding="14,10" Margin="0,10,0,0">
                  <StackPanel>
                    <TextBlock Text="COMMENT FAIRE (2 minutes)" FontSize="11" FontWeight="SemiBold" Foreground="#8C95A8"/>
                    <TextBlock TextWrapping="Wrap" Margin="0,6,0,0" Foreground="#C9CFDA" LineHeight="20"
                               Text="1. Clique sur Ouvrir AMD Software > onglet Jeux > Graphiques (reglages globaux, pour tous les jeux).&#10;2. Radeon Image Sharpening : Active. Nettete : 60 a 80 % (au-dessus, des contours blancs apparaissent).&#10;3. Radeon Anti-Lag : Active (moins de retard, aucun effet sur la nettete mais toujours utile).&#10;4. Onglet Affichage : AMD FreeSync Active (image fluide sans dechirure quand ca bouge).&#10;5. Onglet Affichage : Mise a l'echelle GPU desactivee si tu joues a la resolution de ton ecran.&#10;6. Dans tes jeux : echelle de rendu / resolution 3D a 100 %, flou de mouvement desactive (reglages du jeu)."/>
                  </StackPanel>
                </Border>
                <WrapPanel Margin="0,10,0,0">
                  <Button x:Name="BtnNetAmd" Style="{StaticResource Btn}" Content="Ouvrir AMD Software" Margin="0,0,10,8" Padding="16,9"/>
                </WrapPanel>

                <TextBlock Text="4. VIDEOS PLUS NETTES" FontSize="11.5" FontWeight="SemiBold" Foreground="#8C95A8" Margin="0,18,0,8"/>
                <TextBlock Foreground="#C9CFDA" FontSize="12.5" TextWrapping="Wrap" LineHeight="19"
                           Text="Microsoft Edge peut agrandir les videos en basse qualite (YouTube, streaming) avec ta carte graphique pour les rendre plus nettes : option Ameliorer les videos. Ta RX 6600 est compatible. Dans mpv, le bouton de la partie anti-banding active aussi un agrandissement plus net des videos."/>
                <WrapPanel Margin="0,10,0,0">
                  <Button x:Name="BtnNetEdge" Style="{StaticResource Btn}" Content="Ouvrir les reglages video d'Edge" Margin="0,0,10,8" Padding="16,9"
                          ToolTip="Dans la page qui s'ouvre : active Ameliorer les videos dans Microsoft Edge."/>
                </WrapPanel>
              </StackPanel>
            </Border>

            <TextBlock Text="MODE OLED" Style="{StaticResource Section}"/>
            <Border Style="{StaticResource Carte}">
              <Grid>
                <StackPanel Margin="0,0,260,0">
                  <TextBlock x:Name="TxtOledEtat" Text="Mode OLED : desactive" FontSize="15" FontWeight="SemiBold"/>
                  <TextBlock Foreground="#C9CFDA" FontSize="12.5" TextWrapping="Wrap" Margin="0,6,0,0" LineHeight="19"
                             Text="Rend ton ecran le plus proche possible d'un OLED :&#10;- Windows en mode sombre (menus, barre des taches, applis)&#10;- fond d'ecran noir pur, transparence coupee&#10;- contraste des noirs renforce (les gris tres sombres deviennent noirs)&#10;- OptiGame en noir pur&#10;Un clic sur Desactiver remet tout exactement comme avant."/>
                  <TextBlock Foreground="#8C95A8" FontSize="11.5" TextWrapping="Wrap" Margin="0,8,0,0"
                             Text="Un ecran LCD ne peut pas eteindre ses pixels comme un vrai OLED : c'est le rendu le plus proche possible. Pour aller plus loin : dans les reglages de ton ecran, baisse un peu la luminosite et monte le contraste."/>
                  <CheckBox x:Name="ChkOledDoux" Style="{StaticResource Switch}" Margin="0,12,0,0"
                            Content="Noirs plus doux (moins de banding dans les ombres, conseille pour les films et dessins animes)"/>
                </StackPanel>
                <StackPanel HorizontalAlignment="Right" VerticalAlignment="Center">
                  <Button x:Name="BtnOledOn" Style="{StaticResource BtnPrincipal}" Content="Activer le mode OLED" Padding="18,11"/>
                  <Button x:Name="BtnOledOff" Style="{StaticResource BtnDanger}" Content="Desactiver le mode OLED" Padding="18,11" Visibility="Collapsed"/>
                </StackPanel>
              </Grid>
            </Border>

            <TextBlock Text="DEGRADES SANS MARCHES (ANTI-BANDING)" Style="{StaticResource Section}"/>
            <Border Style="{StaticResource Carte}">
              <StackPanel>
                <TextBlock Foreground="#C9CFDA" FontSize="12.5" TextWrapping="Wrap" LineHeight="19"
                           Text="Le banding, c'est quand un degrade (un ciel, une ombre, un fondu au noir dans un dessin anime) s'affiche en marches avec des limites visibles au lieu d'un fondu lisse. Il vient surtout de la video elle-meme (compression du streaming), mais ton PC peut l'aggraver : couleurs compressees vers l'ecran, trop peu de nuances, courbe gamma modifiee. Ici on enleve tout ce qui l'aggrave, et on lisse les videos quand c'est possible."/>

                <TextBlock Text="1. TON ECRAN RECOIT-IL TOUTES LES NUANCES ?" FontSize="11.5" FontWeight="SemiBold" Foreground="#8C95A8" Margin="0,18,0,8"/>
                <StackPanel x:Name="PanBandEcran"/>
                <WrapPanel Margin="0,6,0,0">
                  <Button x:Name="BtnBandAnalyser" Style="{StaticResource Btn}" Content="Analyser mes ecrans" Margin="0,0,10,8" Padding="16,9"/>
                  <Button x:Name="BtnBandTest" Style="{StaticResource Btn}" Content="Tester les degrades (plein ecran)" Margin="0,0,10,8" Padding="16,9"
                          ToolTip="Affiche des degrades en plein ecran : si tu vois des bandes nettes, il y a du banding. Echap ou clic pour fermer."/>
                  <Button x:Name="BtnBandAmd" Style="{StaticResource BtnFantome}" Content="Ouvrir AMD Software" Margin="0,0,10,8" Padding="16,9"/>
                </WrapPanel>
                <Border Background="#12161E" CornerRadius="9" Padding="14,10" Margin="0,6,0,0">
                  <StackPanel>
                    <TextBlock Text="COMMENT FAIRE (carte AMD, 2 minutes)" FontSize="11" FontWeight="SemiBold" Foreground="#8C95A8"/>
                    <TextBlock TextWrapping="Wrap" Margin="0,6,0,0" Foreground="#C9CFDA" LineHeight="20"
                               Text="1. Clique sur Ouvrir AMD Software, puis l'engrenage (Parametres) en haut a droite > onglet Affichage.&#10;2. Choisis ton ecran en haut si tu en as deux.&#10;3. Format de pixel : RGB 4:4:4 Format de pixel PC Standard (Full RGB). Jamais YCbCr 4:2:2 ou 4:2:0.&#10;4. Profondeur de couleur : la plus haute proposee (10 bpc si ton ecran l'accepte, sinon 8 bpc).&#10;5. Vari-Bright : desactive (il change le contraste tout seul et cree des marches).&#10;6. Reviens ici et clique sur Analyser mes ecrans pour verifier, puis refais le test des degrades."/>
                  </StackPanel>
                </Border>

                <TextBlock Text="2. LISSER LES VIDEOS" FontSize="11.5" FontWeight="SemiBold" Foreground="#8C95A8" Margin="0,20,0,8"/>
                <TextBlock x:Name="TxtBandMpv" Foreground="#C9CFDA" FontSize="12.5" TextWrapping="Wrap" LineHeight="19"/>
                <WrapPanel Margin="0,10,0,0">
                  <Button x:Name="BtnBandMpv" Style="{StaticResource BtnPrincipal}" Content="Activer le lissage des degrades (mpv)" Margin="0,0,10,8" Padding="16,9"/>
                  <Button x:Name="BtnBandMpvOff" Style="{StaticResource BtnDanger}" Content="Enlever le lissage" Margin="0,0,10,8" Padding="16,9" Visibility="Collapsed"/>
                  <Button x:Name="BtnBandMpvSite" Style="{StaticResource BtnFantome}" Content="Telecharger mpv (gratuit)" Margin="0,0,10,8" Padding="16,9"/>
                </WrapPanel>
                <TextBlock Foreground="#8C95A8" FontSize="11.5" TextWrapping="Wrap" Margin="0,4,0,0"
                           Text="Dans le navigateur (Netflix, YouTube, Crunchyroll...) aucun lissage n'est possible : mets la qualite au maximum (plus de qualite = moins de marches). Le lissage marche sur les videos ouvertes avec mpv : fichiers telecharges, ou liens YouTube colles dans mpv."/>
              </StackPanel>
            </Border>
          </StackPanel>
        </ScrollViewer>

        <!-- ========== APPARENCE ========== -->
        <ScrollViewer x:Name="PageApparence" VerticalScrollBarVisibility="Auto" Visibility="Collapsed">
          <StackPanel Margin="32,10,32,28">
            <TextBlock Text="Apparence" Style="{StaticResource Titre}"/>
            <TextBlock Text="Clique sur une couleur ou un fond : ca change tout de suite, tu vois le resultat en direct. C'est enregistre automatiquement." Style="{StaticResource SousTitre}"/>
            <TextBlock x:Name="TxtThActuel" Foreground="#8C95A8" FontSize="12.5" Margin="0,8,0,0"/>

            <TextBlock Text="COULEUR" Style="{StaticResource Section}"/>
            <Border Style="{StaticResource Carte}">
              <StackPanel>
                <WrapPanel x:Name="PanThCouleurs">
                <Button Style="{StaticResource Btn}" Tag="00D46A,00B2D6" Margin="0,0,10,10" Padding="14,9">
                  <StackPanel Orientation="Horizontal">
                    <Ellipse Width="18" Height="18" Fill="#3A4252"/>
                    <TextBlock Text="Vert" Margin="9,0,0,0" VerticalAlignment="Center"/>
                  </StackPanel>
                </Button>
                <Button Style="{StaticResource Btn}" Tag="3D8BFF,00C8FF" Margin="0,0,10,10" Padding="14,9">
                  <StackPanel Orientation="Horizontal">
                    <Ellipse Width="18" Height="18" Fill="#3A4252"/>
                    <TextBlock Text="Bleu" Margin="9,0,0,0" VerticalAlignment="Center"/>
                  </StackPanel>
                </Button>
                <Button Style="{StaticResource Btn}" Tag="FF4FA3,C25CFF" Margin="0,0,10,10" Padding="14,9">
                  <StackPanel Orientation="Horizontal">
                    <Ellipse Width="18" Height="18" Fill="#3A4252"/>
                    <TextBlock Text="Rose" Margin="9,0,0,0" VerticalAlignment="Center"/>
                  </StackPanel>
                </Button>
                <Button Style="{StaticResource Btn}" Tag="9B5CFF,5C7CFF" Margin="0,0,10,10" Padding="14,9">
                  <StackPanel Orientation="Horizontal">
                    <Ellipse Width="18" Height="18" Fill="#3A4252"/>
                    <TextBlock Text="Violet" Margin="9,0,0,0" VerticalAlignment="Center"/>
                  </StackPanel>
                </Button>
                <Button Style="{StaticResource Btn}" Tag="FF4D5E,FF8A3D" Margin="0,0,10,10" Padding="14,9">
                  <StackPanel Orientation="Horizontal">
                    <Ellipse Width="18" Height="18" Fill="#3A4252"/>
                    <TextBlock Text="Rouge" Margin="9,0,0,0" VerticalAlignment="Center"/>
                  </StackPanel>
                </Button>
                <Button Style="{StaticResource Btn}" Tag="FF9F1C,FFD23F" Margin="0,0,10,10" Padding="14,9">
                  <StackPanel Orientation="Horizontal">
                    <Ellipse Width="18" Height="18" Fill="#3A4252"/>
                    <TextBlock Text="Orange" Margin="9,0,0,0" VerticalAlignment="Center"/>
                  </StackPanel>
                </Button>
                <Button Style="{StaticResource Btn}" Tag="00D1C1,00A3FF" Margin="0,0,10,10" Padding="14,9">
                  <StackPanel Orientation="Horizontal">
                    <Ellipse Width="18" Height="18" Fill="#3A4252"/>
                    <TextBlock Text="Cyan" Margin="9,0,0,0" VerticalAlignment="Center"/>
                  </StackPanel>
                </Button>
                <Button Style="{StaticResource Btn}" Tag="F2F4F8,A8B0C0" Margin="0,0,10,10" Padding="14,9">
                  <StackPanel Orientation="Horizontal">
                    <Ellipse Width="18" Height="18" Fill="#3A4252"/>
                    <TextBlock Text="Noir et blanc" Margin="9,0,0,0" VerticalAlignment="Center"/>
                  </StackPanel>
                </Button>
                </WrapPanel>
                <TextBlock Text="Ta propre couleur (code comme FF4FA3) : choisis-la sur coolors.co puis colle le code ici." Foreground="#8C95A8" FontSize="12" Margin="0,8,0,8" TextWrapping="Wrap"/>
                <StackPanel Orientation="Horizontal">
                  <TextBox x:Name="TxtThCouleur" Style="{StaticResource ZoneSaisie}" Width="140" FontFamily="{StaticResource Mono}" Text="#"/>
                  <Button x:Name="BtnThPerso" Style="{StaticResource BtnPrincipal}" Content="Appliquer cette couleur" Margin="10,0,0,0" Padding="16,9"/>
                  <Button x:Name="BtnThSiteCouleur" Style="{StaticResource BtnFantome}" Content="Choisir une couleur (coolors.co)" Margin="10,0,0,0" Padding="16,9"/>
                </StackPanel>
              </StackPanel>
            </Border>

            <TextBlock Text="FOND" Style="{StaticResource Section}"/>
            <Border Style="{StaticResource Carte}">
              <StackPanel>
                <WrapPanel x:Name="PanThFonds">
                <Button Style="{StaticResource Btn}" Tag="sombre" Margin="0,0,10,10" Padding="14,9">
                  <StackPanel Orientation="Horizontal">
                    <Border Background="White" CornerRadius="5" Padding="3"><Border Width="26" Height="18" CornerRadius="3"/></Border>
                    <TextBlock Text="Sombre" Margin="9,0,0,0" VerticalAlignment="Center"/>
                  </StackPanel>
                </Button>
                <Button Style="{StaticResource Btn}" Tag="noir" Margin="0,0,10,10" Padding="14,9">
                  <StackPanel Orientation="Horizontal">
                    <Border Background="White" CornerRadius="5" Padding="3"><Border Width="26" Height="18" CornerRadius="3"/></Border>
                    <TextBlock Text="Noir pur (OLED)" Margin="9,0,0,0" VerticalAlignment="Center"/>
                  </StackPanel>
                </Button>
                <Button Style="{StaticResource Btn}" Tag="nuit" Margin="0,0,10,10" Padding="14,9">
                  <StackPanel Orientation="Horizontal">
                    <Border Background="White" CornerRadius="5" Padding="3"><Border Width="26" Height="18" CornerRadius="3"/></Border>
                    <TextBlock Text="Bleu nuit" Margin="9,0,0,0" VerticalAlignment="Center"/>
                  </StackPanel>
                </Button>
                <Button Style="{StaticResource Btn}" Tag="prune" Margin="0,0,10,10" Padding="14,9">
                  <StackPanel Orientation="Horizontal">
                    <Border Background="White" CornerRadius="5" Padding="3"><Border Width="26" Height="18" CornerRadius="3"/></Border>
                    <TextBlock Text="Prune" Margin="9,0,0,0" VerticalAlignment="Center"/>
                  </StackPanel>
                </Button>
                </WrapPanel>
                <TextBlock Text="Image de fond : une image (jpg, png) affichee en transparence derriere les pages. Trouve-en sur wallhaven.cc (fonds d'ecran gratuits), enregistre-la, puis choisis-la ici." Foreground="#8C95A8" FontSize="12" Margin="0,8,0,8" TextWrapping="Wrap"/>
                <WrapPanel>
                  <Button x:Name="BtnThImage" Style="{StaticResource Btn}" Content="Choisir une image..." Margin="0,0,10,10" Padding="16,9"/>
                  <Button x:Name="BtnThSiteImage" Style="{StaticResource BtnFantome}" Content="Trouver un fond (wallhaven.cc)" Margin="0,0,10,10" Padding="16,9"/>
                  <Button x:Name="BtnThSansImage" Style="{StaticResource BtnFantome}" Content="Enlever l'image" Margin="0,0,10,10" Padding="16,9"/>
                </WrapPanel>
                <StackPanel Orientation="Horizontal" Margin="0,4,0,0">
                  <TextBlock Text="Visibilite de l'image :" Foreground="#C9CFDA" VerticalAlignment="Center"/>
                  <Slider x:Name="SldThOpacite" Width="220" Minimum="5" Maximum="60" Value="22" Margin="12,0,10,0" VerticalAlignment="Center" IsSnapToTickEnabled="True" TickFrequency="1"/>
                  <TextBlock x:Name="TxtThOpacite" Text="22 %" Foreground="#C9CFDA" VerticalAlignment="Center" Width="50"/>
                  <Button x:Name="BtnThOpacite" Style="{StaticResource BtnFantome}" Content="Redemarrer pour tout finaliser" Padding="14,7" ToolTip="Les couleurs changent tout de suite. Quelques effets (survol, selection) prennent la nouvelle couleur apres un redemarrage d'OptiGame."/>
                </StackPanel>
              </StackPanel>
            </Border>

            <Button x:Name="BtnThDefaut" Style="{StaticResource BtnFantome}" Content="Remettre l'apparence d'origine" HorizontalAlignment="Left" Margin="0,18,0,0" Padding="16,9"/>
          </StackPanel>
        </ScrollViewer>

        <!-- ========== VERSIONS ========== -->
        <Grid x:Name="PageVersions" Margin="32,10,32,20" Visibility="Collapsed">
          <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="Auto"/>
          </Grid.RowDefinitions>
          <StackPanel>
            <TextBlock Text="Versions" Style="{StaticResource Titre}"/>
            <TextBlock Text="Selectionne une version puis Utiliser cette version. Les nouvelles versions publiees par l'operateur arrivent en bas (Mises a jour en ligne) : tu choisis de les installer ou non." Style="{StaticResource SousTitre}"/>
            <Button x:Name="BtnVoirNouveautes" Style="{StaticResource Btn}" HorizontalAlignment="Left" Margin="0,10,0,0" Padding="14,8">
              <StackPanel Orientation="Horizontal">
                <TextBlock Text="&#xE734;" FontFamily="Segoe Fluent Icons, Segoe MDL2 Assets" Foreground="#00D46A" VerticalAlignment="Center"/>
                <TextBlock x:Name="TxtBtnNouveautes" Text="Nouveautes de cette version" Margin="8,0,0,0"/>
              </StackPanel>
            </Button>
          </StackPanel>
          <Grid Grid.Row="1" Margin="0,16,0,0">
            <Grid.ColumnDefinitions>
              <ColumnDefinition Width="380"/>
              <ColumnDefinition Width="18"/>
              <ColumnDefinition Width="*"/>
            </Grid.ColumnDefinitions>
            <Border Style="{StaticResource Carte}" Padding="10">
              <ListBox x:Name="ListeVersions" Style="{StaticResource Liste}" ItemContainerStyle="{StaticResource Element}">
                <ListBox.ItemTemplate>
                  <DataTemplate>
                    <Grid>
                      <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="*"/>
                        <ColumnDefinition Width="Auto"/>
                      </Grid.ColumnDefinitions>
                      <StackPanel>
                        <TextBlock Text="{Binding Version}" FontSize="17" FontWeight="Bold" Foreground="{Binding Couleur}"/>
                        <TextBlock Text="{Binding Fichier}" Foreground="#8C95A8" FontSize="12"/>
                        <TextBlock Text="{Binding Date}" Foreground="#6F788B" FontSize="11.5"/>
                      </StackPanel>
                      <StackPanel Grid.Column="1" VerticalAlignment="Center">
                        <Border Style="{StaticResource Pastille}" Background="#163626" Visibility="{Binding VisEnCours}" Margin="0,0,0,4" HorizontalAlignment="Right">
                          <TextBlock Text="en cours" FontSize="11" Foreground="#3FE08E"/>
                        </Border>
                        <Border Style="{StaticResource Pastille}" Background="#1A2638" Visibility="{Binding VisRecente}" HorizontalAlignment="Right">
                          <TextBlock Text="plus recente" FontSize="11" Foreground="#7FB4FF"/>
                        </Border>
                      </StackPanel>
                    </Grid>
                  </DataTemplate>
                </ListBox.ItemTemplate>
              </ListBox>
            </Border>
            <Border Grid.Column="2" Style="{StaticResource Carte}" Padding="24">
              <Grid>
                <Grid.RowDefinitions>
                  <RowDefinition Height="Auto"/>
                  <RowDefinition Height="*"/>
                  <RowDefinition Height="Auto"/>
                </Grid.RowDefinitions>
                <TextBlock Text="Nouveautes de la version" FontSize="16" FontWeight="SemiBold"/>
                <ScrollViewer Grid.Row="1" Margin="0,12,0,0" VerticalScrollBarVisibility="Auto">
                  <TextBlock x:Name="TxtNotes" TextWrapping="Wrap" Foreground="#C9CFDA" LineHeight="21"/>
                </ScrollViewer>
                <WrapPanel Grid.Row="2" Margin="0,14,0,0">
                  <Button x:Name="BtnVerUtiliser" Style="{StaticResource BtnPrincipal}" Content="Utiliser cette version" Margin="0,0,10,8"/>
                  <Button x:Name="BtnVerAjouter" Style="{StaticResource Btn}" Content="Ajouter une version..." Margin="0,0,10,8"/>
                  <Button x:Name="BtnVerDossier" Style="{StaticResource Btn}" Content="Ouvrir le dossier" Margin="0,0,10,8"/>
                  <Button x:Name="BtnRaccourcis" Style="{StaticResource Btn}" Content="Creer les raccourcis" Margin="0,0,10,8"
                          ToolTip="Ajoute 2 raccourcis sur le Bureau et dans le menu Demarrer : OptiGame (derniere version utilisee) et OptiGame - Lanceur."/>
                  <Button x:Name="BtnVerSupprimer" Style="{StaticResource BtnDanger}" Content="Supprimer cette version" Margin="0,0,10,8"/>
                </WrapPanel>
              </Grid>
            </Border>
          </Grid>
          <Grid Grid.Row="2" Margin="0,16,0,0">
            <Grid.ColumnDefinitions>
              <ColumnDefinition Width="*"/>
              <ColumnDefinition Width="18"/>
              <ColumnDefinition Width="400"/>
            </Grid.ColumnDefinitions>
            <!-- Mises a jour en ligne (cote amis) -->
            <Border Style="{StaticResource Carte}" Padding="20,16">
              <StackPanel>
                <Grid>
                  <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="Auto"/>
                  </Grid.ColumnDefinitions>
                  <StackPanel Margin="0,0,14,0">
                    <TextBlock Text="Mises a jour en ligne" FontSize="15" FontWeight="SemiBold"/>
                    <TextBlock x:Name="TxtMajEtat" Text="..." Foreground="#8C95A8" FontSize="12" TextWrapping="Wrap" Margin="0,3,0,0"/>
                  </StackPanel>
                  <StackPanel Grid.Column="1" Orientation="Horizontal" VerticalAlignment="Top">
                    <Button x:Name="BtnMajVerifier" Style="{StaticResource Btn}" Content="Verifier" Padding="14,8"
                            ToolTip="Regarde tout de suite si l'operateur a publie une nouvelle version (OptiGame le fait aussi tout seul regulierement)."/>
                    <Button x:Name="BtnMajTout" Style="{StaticResource BtnPrincipal}" Content="Tout installer" Padding="14,8" Margin="8,0,0,0" Visibility="Collapsed"/>
                  </StackPanel>
                </Grid>
                <ScrollViewer MaxHeight="130" VerticalScrollBarVisibility="Auto" Margin="0,10,0,0">
                  <ItemsControl x:Name="ListeDistantes">
                    <ItemsControl.ItemTemplate>
                      <DataTemplate>
                        <Border BorderBrush="#1E2430" BorderThickness="0,0,0,1" Padding="2,8">
                          <Grid>
                            <Grid.ColumnDefinitions>
                              <ColumnDefinition Width="*"/>
                              <ColumnDefinition Width="Auto"/>
                            </Grid.ColumnDefinitions>
                            <StackPanel>
                              <StackPanel Orientation="Horizontal">
                                <TextBlock Text="{Binding Titre}" FontWeight="SemiBold" Foreground="{Binding Couleur}"/>
                                <Border Style="{StaticResource Pastille}" Background="{Binding FondEtat}" Margin="8,0,0,0">
                                  <TextBlock Text="{Binding Etat}" FontSize="11" Foreground="{Binding CouleurEtat}"/>
                                </Border>
                              </StackPanel>
                              <TextBlock Text="{Binding Notes}" Foreground="#8C95A8" FontSize="12" TextWrapping="Wrap" Margin="0,2,0,0"/>
                            </StackPanel>
                            <StackPanel Grid.Column="1" Orientation="Horizontal" VerticalAlignment="Center">
                              <Button Style="{StaticResource BtnPrincipal}" Content="{Binding TexteInstaller}" Tag="{Binding TagInstaller}" Visibility="{Binding VisInstaller}" Padding="10,5" FontSize="12" Margin="8,0,0,0"/>
                              <Button Style="{StaticResource BtnFantome}" Content="{Binding TexteIgnorer}" Tag="{Binding TagIgnorer}" Visibility="{Binding VisIgnorer}" Padding="10,5" FontSize="12" Margin="8,0,0,0"/>
                            </StackPanel>
                          </Grid>
                        </Border>
                      </DataTemplate>
                    </ItemsControl.ItemTemplate>
                  </ItemsControl>
                </ScrollViewer>
                <TextBlock x:Name="TxtMajVide" Text="Tout est a jour." Foreground="#3FE08E" Margin="0,8,0,0" Visibility="Collapsed"/>
                <StackPanel x:Name="ZoneMajSource" Margin="0,12,0,0">
                  <TextBlock Text="LIEN DES MISES A JOUR (donne par l'operateur)" FontSize="11" FontWeight="SemiBold" Foreground="#8C95A8" Margin="0,0,0,6"/>
                  <Grid>
                    <Grid.ColumnDefinitions>
                      <ColumnDefinition Width="*"/>
                      <ColumnDefinition Width="Auto"/>
                    </Grid.ColumnDefinitions>
                    <TextBox x:Name="TxtMajSource" Style="{StaticResource ZoneSaisie}" FontFamily="{StaticResource Mono}" FontSize="12"
                             ToolTip="Colle ici le lien que l'operateur t'a donne (il commence par https://)."/>
                    <Button x:Name="BtnMajSource" Grid.Column="1" Style="{StaticResource Btn}" Content="Enregistrer" Padding="16,8" Margin="8,0,0,0"/>
                  </Grid>
                </StackPanel>
              </StackPanel>
            </Border>
            <!-- Mode operateur (publier les mises a jour) -->
            <Border Grid.Column="2" Style="{StaticResource Carte}" Padding="20,16">
              <StackPanel>
                <TextBlock Text="Mode operateur" FontSize="15" FontWeight="SemiBold"/>
                <TextBlock x:Name="TxtOpEtat" Text="Pour envoyer les nouvelles versions a tes amis sans leur envoyer de fichier." Foreground="#8C95A8" FontSize="12" TextWrapping="Wrap" Margin="0,3,0,10"/>
                <StackPanel x:Name="ZoneOpConfig" Visibility="Collapsed">
                  <TextBlock Text="Depot GitHub (pseudo/nom-du-depot)" Foreground="#C9CFDA" FontSize="12"/>
                  <TextBox x:Name="TxtOpDepot" Style="{StaticResource ZoneSaisie}" Margin="0,4,0,8"/>
                  <TextBlock Text="Jeton GitHub (garde secret, chiffre sur ce PC)" Foreground="#C9CFDA" FontSize="12"/>
                  <PasswordBox x:Name="PwdOpJeton" Margin="0,4,0,8" Padding="10,8" Background="#0F1218" Foreground="#E9ECF2" BorderBrush="#2A3140" CaretBrush="#E9ECF2" VerticalContentAlignment="Center"/>
                  <WrapPanel>
                    <Button x:Name="BtnOpEnregistrer" Style="{StaticResource BtnPrincipal}" Content="Enregistrer" Padding="12,7" Margin="0,0,8,8"/>
                    <Button x:Name="BtnOpAide" Style="{StaticResource BtnFantome}" Content="Comment faire ?" Padding="12,7" Margin="0,0,8,8"/>
                  </WrapPanel>
                </StackPanel>
                <WrapPanel x:Name="ZoneOpActions">
                  <Button x:Name="BtnOpDevenir" Style="{StaticResource Btn}" Content="Je suis l'operateur" Padding="12,7" Margin="0,0,8,8"/>
                  <Button x:Name="BtnOpPublier" Style="{StaticResource BtnPrincipal}" Content="Publier la version choisie" Padding="12,7" Margin="0,0,8,8"/>
                  <Button x:Name="BtnOpPublierTout" Style="{StaticResource Btn}" Content="Publier toutes" Padding="12,7" Margin="0,0,8,8"/>
                  <Button x:Name="BtnOpRetirer" Style="{StaticResource BtnFantome}" Content="Retirer la version choisie" Padding="12,7" Margin="0,0,8,8"/>
                  <Button x:Name="BtnOpLien" Style="{StaticResource BtnFantome}" Content="Copier le lien pour tes amis" Padding="12,7" Margin="0,0,8,8"/>
                  <Button x:Name="BtnOpTestAmi" Style="{StaticResource BtnFantome}" Content="Voir comme un ami (test)" Padding="12,7" Margin="0,0,8,8"
                          ToolTip="Ouvre une 2e fenetre d'OptiGame comme chez un ami : pas operateur, seulement cette version. Colle le lien pour voir ce qu'il recoit. Ton vrai OptiGame n'est pas touche."/>
                  <Button x:Name="BtnOpQuitter" Style="{StaticResource BtnFantome}" Content="Quitter le mode operateur" Padding="12,7" Margin="0,0,8,8"/>
                </WrapPanel>
              </StackPanel>
            </Border>
          </Grid>
        </Grid>

        <!-- Notification (toast) -->
        <Border x:Name="Toast" HorizontalAlignment="Right" VerticalAlignment="Bottom" Margin="0,0,26,22"
                Background="#1C2330" BorderBrush="#2B3A4A" BorderThickness="1" CornerRadius="12" Padding="16,12"
                Opacity="0" IsHitTestVisible="False" MaxWidth="420">
          <Border.RenderTransform><TranslateTransform Y="20"/></Border.RenderTransform>
          <Border.Effect><DropShadowEffect BlurRadius="24" ShadowDepth="0" Opacity="0.5"/></Border.Effect>
          <StackPanel Orientation="Horizontal">
            <TextBlock x:Name="ToastIcone" Text="&#xE73E;" FontFamily="Segoe Fluent Icons, Segoe MDL2 Assets" Foreground="#00D46A" FontSize="15" VerticalAlignment="Center"/>
            <TextBlock x:Name="ToastTexte" Margin="10,0,0,0" TextWrapping="Wrap" VerticalAlignment="Center"/>
          </StackPanel>
        </Border>
      </Grid>

      <!-- Barre d'etat -->
      <Border Grid.Row="2" BorderBrush="#1A1F28" BorderThickness="0,1,0,0">
        <TextBlock x:Name="TxtStatut" Text="Pret." Foreground="#6F788B" FontSize="11.5" VerticalAlignment="Center" Margin="32,0,0,0" TextTrimming="CharacterEllipsis"/>
      </Border>
    </Grid>
  </Grid>
</Window>
'@

$XamlOverlay = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        WindowStyle="None" AllowsTransparency="True" Background="Transparent" ShowInTaskbar="False"
        ShowActivated="False" ResizeMode="NoResize" Topmost="False" Width="800" Height="600"
        FontFamily="Segoe UI Variable Text, Segoe UI" UseLayoutRounding="True">
  <Window.Resources>
    <LinearGradientBrush x:Key="Degrade" StartPoint="0,0" EndPoint="1,1">
      <GradientStop Color="#00D46A" Offset="0"/>
      <GradientStop Color="#00B2D6" Offset="1"/>
    </LinearGradientBrush>

    <Storyboard x:Key="Entree">
      <DoubleAnimation Storyboard.TargetName="Racine" Storyboard.TargetProperty="Opacity" From="0" To="1" Duration="0:0:0.25"/>
      <DoubleAnimation Storyboard.TargetName="Echelle" Storyboard.TargetProperty="ScaleX" From="0.9" To="1" Duration="0:0:0.45">
        <DoubleAnimation.EasingFunction><BackEase EasingMode="EaseOut" Amplitude="0.4"/></DoubleAnimation.EasingFunction>
      </DoubleAnimation>
      <DoubleAnimation Storyboard.TargetName="Echelle" Storyboard.TargetProperty="ScaleY" From="0.9" To="1" Duration="0:0:0.45">
        <DoubleAnimation.EasingFunction><BackEase EasingMode="EaseOut" Amplitude="0.4"/></DoubleAnimation.EasingFunction>
      </DoubleAnimation>
    </Storyboard>

    <Storyboard x:Key="Sortie">
      <DoubleAnimation Storyboard.TargetName="Racine" Storyboard.TargetProperty="Opacity" To="0" Duration="0:0:0.3"/>
      <DoubleAnimation Storyboard.TargetName="Echelle" Storyboard.TargetProperty="ScaleX" To="0.95" Duration="0:0:0.3"/>
      <DoubleAnimation Storyboard.TargetName="Echelle" Storyboard.TargetProperty="ScaleY" To="0.95" Duration="0:0:0.3"/>
    </Storyboard>

    <Storyboard x:Key="Reussite">
      <DoubleAnimation Storyboard.TargetName="Travail" Storyboard.TargetProperty="Opacity" To="0" Duration="0:0:0.25"/>
      <DoubleAnimation Storyboard.TargetName="Succes" Storyboard.TargetProperty="Opacity" To="1" Duration="0:0:0.25"/>
      <DoubleAnimation Storyboard.TargetName="EchelleSucces" Storyboard.TargetProperty="ScaleX" From="0.5" To="1" Duration="0:0:0.5">
        <DoubleAnimation.EasingFunction><BackEase EasingMode="EaseOut" Amplitude="0.8"/></DoubleAnimation.EasingFunction>
      </DoubleAnimation>
      <DoubleAnimation Storyboard.TargetName="EchelleSucces" Storyboard.TargetProperty="ScaleY" From="0.5" To="1" Duration="0:0:0.5">
        <DoubleAnimation.EasingFunction><BackEase EasingMode="EaseOut" Amplitude="0.8"/></DoubleAnimation.EasingFunction>
      </DoubleAnimation>
      <DoubleAnimation Storyboard.TargetName="Coche" Storyboard.TargetProperty="StrokeDashOffset" From="14" To="0" BeginTime="0:0:0.15" Duration="0:0:0.45">
        <DoubleAnimation.EasingFunction><CubicEase EasingMode="EaseOut"/></DoubleAnimation.EasingFunction>
      </DoubleAnimation>
      <DoubleAnimation Storyboard.TargetName="Onde" Storyboard.TargetProperty="Opacity" From="0.7" To="0" Duration="0:0:0.9"/>
      <DoubleAnimation Storyboard.TargetName="EchelleOnde" Storyboard.TargetProperty="ScaleX" From="0.8" To="1.6" Duration="0:0:0.9"/>
      <DoubleAnimation Storyboard.TargetName="EchelleOnde" Storyboard.TargetProperty="ScaleY" From="0.8" To="1.6" Duration="0:0:0.9"/>
    </Storyboard>

    <Storyboard x:Key="Rate">
      <DoubleAnimation Storyboard.TargetName="Travail" Storyboard.TargetProperty="Opacity" To="0" Duration="0:0:0.25"/>
      <DoubleAnimation Storyboard.TargetName="Echec" Storyboard.TargetProperty="Opacity" To="1" Duration="0:0:0.25"/>
      <DoubleAnimation Storyboard.TargetName="DecalEchec" Storyboard.TargetProperty="X" From="-10" To="0" Duration="0:0:0.5">
        <DoubleAnimation.EasingFunction><ElasticEase EasingMode="EaseOut" Oscillations="3" Springiness="4"/></DoubleAnimation.EasingFunction>
      </DoubleAnimation>
    </Storyboard>
  </Window.Resources>

  <Grid x:Name="Racine" Opacity="0">
    <Border Background="#D90B0D12"/>
    <Border Width="540" HorizontalAlignment="Center" VerticalAlignment="Center" CornerRadius="22"
            Background="#151922" BorderBrush="#263043" BorderThickness="1" Padding="34,30,34,26" RenderTransformOrigin="0.5,0.5">
      <Border.RenderTransform><ScaleTransform x:Name="Echelle" ScaleX="1" ScaleY="1"/></Border.RenderTransform>
      <Border.Effect><DropShadowEffect BlurRadius="50" ShadowDepth="0" Opacity="0.7" Color="Black"/></Border.Effect>
      <StackPanel>
        <Grid Width="170" Height="170" HorizontalAlignment="Center">
          <!-- ===== animation de travail ===== -->
          <Grid x:Name="Travail">
            <Ellipse Width="120" Height="120" Fill="#3000D46A" RenderTransformOrigin="0.5,0.5">
              <Ellipse.Effect><BlurEffect Radius="34"/></Ellipse.Effect>
              <Ellipse.RenderTransform><ScaleTransform x:Name="Pouls"/></Ellipse.RenderTransform>
              <Ellipse.Triggers>
                <EventTrigger RoutedEvent="FrameworkElement.Loaded">
                  <BeginStoryboard><Storyboard RepeatBehavior="Forever" AutoReverse="True">
                    <DoubleAnimation Storyboard.TargetName="Pouls" Storyboard.TargetProperty="ScaleX" From="0.85" To="1.15" Duration="0:0:1.1"/>
                    <DoubleAnimation Storyboard.TargetName="Pouls" Storyboard.TargetProperty="ScaleY" From="0.85" To="1.15" Duration="0:0:1.1"/>
                  </Storyboard></BeginStoryboard>
                </EventTrigger>
              </Ellipse.Triggers>
            </Ellipse>
            <Ellipse Width="158" Height="158" Stroke="{StaticResource Degrade}" StrokeThickness="4" StrokeDashArray="14 9"
                     StrokeDashCap="Round" RenderTransformOrigin="0.5,0.5">
              <Ellipse.RenderTransform><RotateTransform x:Name="Rot1"/></Ellipse.RenderTransform>
              <Ellipse.Triggers>
                <EventTrigger RoutedEvent="FrameworkElement.Loaded">
                  <BeginStoryboard><Storyboard RepeatBehavior="Forever">
                    <DoubleAnimation Storyboard.TargetName="Rot1" Storyboard.TargetProperty="Angle" From="0" To="360" Duration="0:0:3"/>
                  </Storyboard></BeginStoryboard>
                </EventTrigger>
              </Ellipse.Triggers>
            </Ellipse>
            <Ellipse Width="128" Height="128" Stroke="#5500B2D6" StrokeThickness="2.5" StrokeDashArray="3 7"
                     StrokeDashCap="Round" RenderTransformOrigin="0.5,0.5">
              <Ellipse.RenderTransform><RotateTransform x:Name="Rot2"/></Ellipse.RenderTransform>
              <Ellipse.Triggers>
                <EventTrigger RoutedEvent="FrameworkElement.Loaded">
                  <BeginStoryboard><Storyboard RepeatBehavior="Forever">
                    <DoubleAnimation Storyboard.TargetName="Rot2" Storyboard.TargetProperty="Angle" From="360" To="0" Duration="0:0:4.5"/>
                  </Storyboard></BeginStoryboard>
                </EventTrigger>
              </Ellipse.Triggers>
            </Ellipse>
            <Canvas Width="170" Height="170" RenderTransformOrigin="0.5,0.5">
              <Canvas.RenderTransform><RotateTransform x:Name="Rot3"/></Canvas.RenderTransform>
              <Ellipse Canvas.Left="80" Canvas.Top="2" Width="10" Height="10" Fill="#00D46A">
                <Ellipse.Effect><DropShadowEffect Color="#00D46A" BlurRadius="12" ShadowDepth="0" Opacity="0.9"/></Ellipse.Effect>
              </Ellipse>
              <Canvas.Triggers>
                <EventTrigger RoutedEvent="FrameworkElement.Loaded">
                  <BeginStoryboard><Storyboard RepeatBehavior="Forever">
                    <DoubleAnimation Storyboard.TargetName="Rot3" Storyboard.TargetProperty="Angle" From="0" To="360" Duration="0:0:1.6"/>
                  </Storyboard></BeginStoryboard>
                </EventTrigger>
              </Canvas.Triggers>
            </Canvas>
            <TextBlock x:Name="IconeCentre" Text="&#xE945;" FontFamily="Segoe Fluent Icons, Segoe MDL2 Assets" FontSize="42"
                       Foreground="#00D46A" HorizontalAlignment="Center" VerticalAlignment="Center">
              <TextBlock.Effect><DropShadowEffect Color="#00D46A" BlurRadius="20" ShadowDepth="0" Opacity="0.8"/></TextBlock.Effect>
              <TextBlock.Triggers>
                <EventTrigger RoutedEvent="FrameworkElement.Loaded">
                  <BeginStoryboard><Storyboard RepeatBehavior="Forever" AutoReverse="True">
                    <DoubleAnimation Storyboard.TargetProperty="Opacity" From="1" To="0.45" Duration="0:0:0.9"/>
                  </Storyboard></BeginStoryboard>
                </EventTrigger>
              </TextBlock.Triggers>
            </TextBlock>
          </Grid>

          <!-- ===== reussite ===== -->
          <Grid x:Name="Succes" Opacity="0">
            <Ellipse x:Name="Onde" Width="130" Height="130" Stroke="#00D46A" StrokeThickness="3" Opacity="0" RenderTransformOrigin="0.5,0.5">
              <Ellipse.RenderTransform><ScaleTransform x:Name="EchelleOnde"/></Ellipse.RenderTransform>
            </Ellipse>
            <Grid RenderTransformOrigin="0.5,0.5">
              <Grid.RenderTransform><ScaleTransform x:Name="EchelleSucces"/></Grid.RenderTransform>
              <Ellipse Width="130" Height="130" Fill="#1A00D46A" Stroke="#00D46A" StrokeThickness="3">
                <Ellipse.Effect><DropShadowEffect Color="#00D46A" BlurRadius="30" ShadowDepth="0" Opacity="0.6"/></Ellipse.Effect>
              </Ellipse>
              <Path x:Name="Coche" Data="M 58,86 L 77,104 L 113,64" Stroke="#00D46A" StrokeThickness="9"
                    StrokeStartLineCap="Round" StrokeEndLineCap="Round" StrokeLineJoin="Round"
                    StrokeDashArray="14 14" StrokeDashOffset="14" Width="170" Height="170"/>
            </Grid>
          </Grid>

          <!-- ===== echec ===== -->
          <Grid x:Name="Echec" Opacity="0">
            <Grid.RenderTransform><TranslateTransform x:Name="DecalEchec"/></Grid.RenderTransform>
            <Ellipse Width="130" Height="130" Fill="#1AFF5468" Stroke="#FF5468" StrokeThickness="3"/>
            <Path Data="M 66,66 L 104,104 M 104,66 L 66,104" Stroke="#FF5468" StrokeThickness="9"
                  StrokeStartLineCap="Round" StrokeEndLineCap="Round" Width="170" Height="170"/>
          </Grid>
        </Grid>

        <TextBlock x:Name="Titre" FontSize="21" FontWeight="SemiBold" Foreground="#E9ECF2" HorizontalAlignment="Center"
                   Margin="0,16,0,6" FontFamily="Segoe UI Variable Display, Segoe UI" TextAlignment="Center" TextWrapping="Wrap"/>
        <TextBlock x:Name="Etape" FontSize="13.5" Foreground="#C9CFDA" HorizontalAlignment="Center" TextAlignment="Center" TextWrapping="Wrap"/>
        <TextBlock x:Name="Detail" FontSize="12.5" Foreground="#8C95A8" HorizontalAlignment="Center" TextAlignment="Center"
                   TextWrapping="Wrap" Margin="0,4,0,0"/>

        <Grid x:Name="ZoneBarre" Margin="0,22,0,0" Height="8">
          <Border CornerRadius="4" Background="#232A36"/>
          <Border x:Name="Barre" CornerRadius="4" Background="{StaticResource Degrade}" HorizontalAlignment="Left" Width="0">
            <Border.Effect><DropShadowEffect Color="#00D46A" BlurRadius="10" ShadowDepth="0" Opacity="0.6"/></Border.Effect>
          </Border>
          <Canvas x:Name="Indet" ClipToBounds="True" Visibility="Collapsed">
            <Border x:Name="BarreIndet" Width="130" Height="8" CornerRadius="4" Background="{StaticResource Degrade}" Canvas.Left="-130">
              <Border.Triggers>
                <EventTrigger RoutedEvent="FrameworkElement.Loaded">
                  <BeginStoryboard><Storyboard RepeatBehavior="Forever">
                    <DoubleAnimation Storyboard.TargetProperty="(Canvas.Left)" From="-130" To="472" Duration="0:0:1.5">
                      <DoubleAnimation.EasingFunction><SineEase EasingMode="EaseInOut"/></DoubleAnimation.EasingFunction>
                    </DoubleAnimation>
                  </Storyboard></BeginStoryboard>
                </EventTrigger>
              </Border.Triggers>
            </Border>
          </Canvas>
        </Grid>
        <Grid Margin="0,8,0,0">
          <TextBlock x:Name="Temps" Foreground="#8C95A8" FontSize="12" HorizontalAlignment="Left"/>
          <TextBlock x:Name="Pct" Foreground="#8C95A8" FontSize="12" HorizontalAlignment="Right"/>
        </Grid>

        <Border Margin="0,16,0,0" CornerRadius="11" Background="#0E1116" BorderBrush="#1E2430" BorderThickness="1" Padding="14,10" Height="118">
          <ItemsControl x:Name="Lignes">
            <ItemsControl.ItemTemplate>
              <DataTemplate>
                <TextBlock Text="{Binding}" FontFamily="Cascadia Mono, Consolas" FontSize="11.5" Foreground="#7FE0A8"
                           TextTrimming="CharacterEllipsis" Margin="0,1"/>
              </DataTemplate>
            </ItemsControl.ItemTemplate>
          </ItemsControl>
        </Border>

        <Button x:Name="BtnStop" Content="Arreter le test et tout remettre" Margin="0,16,0,0" HorizontalAlignment="Center"
                Visibility="Collapsed" Cursor="Hand" Foreground="#FF8A97" FontSize="13">
          <Button.Template>
            <ControlTemplate TargetType="Button">
              <Border x:Name="B" Background="#2A151A" BorderBrush="#55232E" BorderThickness="1" CornerRadius="9" Padding="16,8">
                <ContentPresenter HorizontalAlignment="Center"/>
              </Border>
              <ControlTemplate.Triggers>
                <Trigger Property="IsMouseOver" Value="True"><Setter TargetName="B" Property="Background" Value="#3A1A22"/></Trigger>
              </ControlTemplate.Triggers>
            </ControlTemplate>
          </Button.Template>
        </Button>
      </StackPanel>
    </Border>
  </Grid>
</Window>
'@

$XamlDialogue = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        WindowStyle="None" AllowsTransparency="True" Background="Transparent" ShowInTaskbar="False"
        SizeToContent="WidthAndHeight" ResizeMode="NoResize" WindowStartupLocation="CenterOwner"
        FontFamily="Segoe UI Variable Text, Segoe UI" Foreground="#E9ECF2" UseLayoutRounding="True">
  <Border x:Name="Carte" Margin="34" CornerRadius="18" Background="#171B24" BorderBrush="#2A3140" BorderThickness="1"
          Padding="26,22,26,20" MinWidth="400" MaxWidth="600" Opacity="0" RenderTransformOrigin="0.5,0.5">
    <Border.RenderTransform><ScaleTransform x:Name="Echelle" ScaleX="0.92" ScaleY="0.92"/></Border.RenderTransform>
    <Border.Effect><DropShadowEffect BlurRadius="40" ShadowDepth="0" Opacity="0.65"/></Border.Effect>
    <Border.Triggers>
      <EventTrigger RoutedEvent="FrameworkElement.Loaded">
        <BeginStoryboard><Storyboard>
          <DoubleAnimation Storyboard.TargetProperty="Opacity" To="1" Duration="0:0:0.18"/>
          <DoubleAnimation Storyboard.TargetName="Echelle" Storyboard.TargetProperty="ScaleX" To="1" Duration="0:0:0.35">
            <DoubleAnimation.EasingFunction><BackEase EasingMode="EaseOut" Amplitude="0.4"/></DoubleAnimation.EasingFunction>
          </DoubleAnimation>
          <DoubleAnimation Storyboard.TargetName="Echelle" Storyboard.TargetProperty="ScaleY" To="1" Duration="0:0:0.35">
            <DoubleAnimation.EasingFunction><BackEase EasingMode="EaseOut" Amplitude="0.4"/></DoubleAnimation.EasingFunction>
          </DoubleAnimation>
        </Storyboard></BeginStoryboard>
      </EventTrigger>
    </Border.Triggers>
    <StackPanel>
      <StackPanel x:Name="Entete" Orientation="Horizontal" Background="Transparent">
        <Border x:Name="FondIcone" Width="40" Height="40" CornerRadius="20" Background="#16301F">
          <TextBlock x:Name="Icone" FontFamily="Segoe Fluent Icons, Segoe MDL2 Assets" FontSize="18" Foreground="#00D46A"
                     HorizontalAlignment="Center" VerticalAlignment="Center"/>
        </Border>
        <TextBlock x:Name="Titre" FontSize="17" FontWeight="SemiBold" VerticalAlignment="Center" Margin="12,0,0,0"/>
      </StackPanel>
      <ScrollViewer x:Name="Defil" MaxHeight="440" VerticalScrollBarVisibility="Auto" Margin="0,16,0,0">
        <TextBlock x:Name="Message" TextWrapping="Wrap" FontSize="13.5" Foreground="#C9CFDA" LineHeight="20"/>
      </ScrollViewer>
      <StackPanel Orientation="Horizontal" HorizontalAlignment="Right" Margin="0,22,0,0">
        <Button x:Name="BtnNon" Style="{StaticResource BtnFantome}" Content="Non" MinWidth="90" Margin="0,0,10,0"/>
        <Button x:Name="BtnOui" Style="{StaticResource BtnPrincipal}" Content="Oui" MinWidth="90"/>
      </StackPanel>
    </StackPanel>
  </Border>
</Window>
'@

$CouleursLog = @{
    LightGreen = '#7FE0A8'; White = '#E9ECF2'; Gray = '#8C95A8'; Gold = '#FFC24B'
    Tomato = '#FF6B7A'; LightSkyBlue = '#8AB4FF'
}
$script:LignesJournal = New-Object 'System.Collections.ObjectModel.ObservableCollection[object]'
$script:Prog = $null
$script:ProgTest = $false
$script:ProgMaj = 1
$script:ProgMajTot = 1
$script:PageActive = 'PageAccueil'
$script:JeuSel = $null
$script:SigJeux = ''
$script:TestCoches = @{}
$script:LignesComp = @()
$UI = @{}

function Charger-Xaml([string]$x) {
    $r = New-Object System.Xml.XmlNodeReader ([xml]$x)
    return [Windows.Markup.XamlReader]::Load($r)
}

function Duree([int]$ms) { return [System.Windows.Duration]::new([TimeSpan]::FromMilliseconds($ms)) }

function Animer($cible, $propriete, [double]$vers, [int]$ms = 300, $de = $null) {
    $a = New-Object System.Windows.Media.Animation.DoubleAnimation
    if ($null -ne $de) { $a.From = [double]$de }
    $a.To = $vers
    $a.Duration = Duree $ms
    $e = New-Object System.Windows.Media.Animation.CubicEase
    $e.EasingMode = 'EaseOut'
    $a.EasingFunction = $e
    $cible.BeginAnimation($propriete, $a)
}

# ---------------------------------------------------------------------
#  JOURNAL, ETAT, OCCUPATION
# ---------------------------------------------------------------------
function Write-Log([string]$msg, [string]$couleur = 'LightGreen') {
    if ($script:VerifEnCours) { return }
    $c = $CouleursLog[$couleur]
    if (-not $c) { $c = '#C9CFDA' }
    $ligne = [pscustomobject]@{ Texte = $msg; Couleur = $c }
    try {
        $script:LignesJournal.Add($ligne)
        while ($script:LignesJournal.Count -gt 800) { $script:LignesJournal.RemoveAt(0) }
        if ($script:PageActive -eq 'PageJournal' -and $UI.ListeJournal) { $UI.ListeJournal.ScrollIntoView($ligne) }
        if ($UI.TxtStatut -and $msg.Trim()) { $UI.TxtStatut.Text = $msg.Trim() }
    } catch {}
    if ($script:Prog -and $script:Prog.Visible) { Progression-Log $msg }
    Pump-Ui
}

function Set-Busy([bool]$b) {
    $script:Busy = $b
    foreach ($n in 'BtnToutFaire', 'BtnToutFaire2', 'BtnQBoost', 'BtnQMemoire', 'BtnRamLiberer', 'BtnQNettoyage', 'BtnQTest', 'BtnQDiag', 'ListeActions',
                    'BtnTestComplet', 'BtnTestRapide', 'BtnTestAppliquer', 'BtnVerUtiliser', 'BtnCorriger', 'ListeOptions') {
        if ($UI[$n]) { $UI[$n].IsEnabled = -not $b }
    }
    Update-BtnJeu
}

function Update-BtnJeu {
    if (-not $UI.BtnJeuAppliquer) { return }
    $ok = ($null -ne $script:JeuSel) -and ($null -ne $Jeux[$script:JeuSel])
    foreach ($n in 'BtnJeuAppliquer', 'BtnJeuRestaurer', 'BtnJeuDossier', 'BtnJeuConseils', 'BtnJeuVideo') {
        $UI[$n].IsEnabled = $ok -and -not $script:Busy
    }
}

# ---------------------------------------------------------------------
#  ECRAN DE PROGRESSION ANIME (fil d'execution separe : toujours fluide)
# ---------------------------------------------------------------------
$ScriptOverlay = {
    param($Prog, $Xaml)
    Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase
    $lecteur = New-Object System.Xml.XmlNodeReader ([xml]$Xaml)
    $w = [Windows.Markup.XamlReader]::Load($lecteur)
    $n = @{}
    foreach ($k in 'Racine', 'Titre', 'Etape', 'Detail', 'Barre', 'Indet', 'ZoneBarre', 'Pct', 'Temps', 'Lignes', 'BtnStop') { $n[$k] = $w.FindName($k) }
    $sb = @{}
    foreach ($k in 'Entree', 'Sortie', 'Reussite', 'Rate') { $sb[$k] = $w.FindResource($k) }
    $etat = @{ Visible = $false; FinJouee = ''; OwnerFait = $false; Affiche = 0.0; CacherA = $null
               Lignes = (New-Object System.Collections.Generic.List[string]) }
    $n.BtnStop.Add_Click({
        $Prog.Stop = $true
        $n.BtnStop.IsEnabled = $false
        $n.BtnStop.Content = 'Arret en cours, les reglages vont etre remis...'
    })
    $minuterie = New-Object System.Windows.Threading.DispatcherTimer
    $minuterie.Interval = [TimeSpan]::FromMilliseconds(40)
    $minuterie.Add_Tick({
        try {
            if ($Prog.Quitter) {
                $minuterie.Stop()
                $w.Close()
                [System.Windows.Threading.Dispatcher]::CurrentDispatcher.InvokeShutdown()
                return
            }
            $voir = $Prog.Visible -and $Prog.MainVisible
            if ($voir) {
                if (-not $etat.OwnerFait -and $Prog.Owner -ne [IntPtr]::Zero) {
                    (New-Object System.Windows.Interop.WindowInteropHelper($w)).Owner = $Prog.Owner
                    $etat.OwnerFait = $true
                }
                $r = $Prog.Rect
                $w.Left = $r[0]; $w.Top = $r[1]
                $w.Width = [math]::Max(400.0, [double]$r[2]); $w.Height = [math]::Max(400.0, [double]$r[3])
                if (-not $etat.Visible) {
                    $etat.Visible = $true
                    $etat.CacherA = $null
                    $etat.FinJouee = ''
                    $etat.Affiche = 0.0
                    foreach ($k in 'Reussite', 'Rate', 'Sortie') { $sb[$k].Remove($w) }
                    $n.BtnStop.IsEnabled = $true
                    $n.BtnStop.Content = 'Arreter le test et tout remettre'
                    $etat.Lignes.Clear()
                    $n.Lignes.ItemsSource = $null
                    $w.Show()
                    $sb.Entree.Begin($w, $true)
                }
                if ($Prog.Vider) { $Prog.Vider = $false; $etat.Lignes.Clear(); $n.Lignes.ItemsSource = $null; $etat.Affiche = 0.0 }
                $n.Titre.Text = [string]$Prog.Titre
                $n.Etape.Text = [string]$Prog.Etape
                $n.Detail.Text = [string]$Prog.Detail
                $x = $null
                $nouveau = $false
                while ($Prog.Lignes.TryDequeue([ref]$x)) { $etat.Lignes.Add($x); $nouveau = $true }
                if ($nouveau) {
                    while ($etat.Lignes.Count -gt 6) { $etat.Lignes.RemoveAt(0) }
                    $n.Lignes.ItemsSource = $etat.Lignes.ToArray()
                }
                $pct = [double]$Prog.Pct
                if ($pct -lt 0 -and -not $Prog.Fin) {
                    $n.Indet.Visibility = 'Visible'; $n.Barre.Visibility = 'Collapsed'; $n.Pct.Text = ''
                } else {
                    if ($Prog.Fin -eq 'ok') { $pct = 1.0 }
                    if ($pct -lt 0) { $pct = $etat.Affiche }
                    $n.Indet.Visibility = 'Collapsed'; $n.Barre.Visibility = 'Visible'
                    $etat.Affiche += ($pct - $etat.Affiche) * 0.12
                    $n.Barre.Width = [math]::Max(0.0, [double]$n.ZoneBarre.ActualWidth * [double]$etat.Affiche)
                    $n.Pct.Text = ('{0:N0} %' -f ($etat.Affiche * 100))
                }
                $d = (Get-Date) - [datetime]$Prog.Debut
                $n.Temps.Text = ('{0:00}:{1:00}' -f [math]::Floor($d.TotalMinutes), $d.Seconds)
                $n.BtnStop.Visibility = $(if ($Prog.StopVisible) { 'Visible' } else { 'Collapsed' })
                if ($Prog.Fin -and $etat.FinJouee -ne $Prog.Fin) {
                    $etat.FinJouee = $Prog.Fin
                    if ($Prog.Fin -eq 'ok') { $sb.Reussite.Begin($w, $true) } else { $sb.Rate.Begin($w, $true) }
                }
            } elseif ($etat.Visible) {
                $etat.Visible = $false
                $sb.Sortie.Begin($w, $true)
                $etat.CacherA = (Get-Date).AddMilliseconds(330)
            } elseif ($etat.CacherA -and (Get-Date) -ge $etat.CacherA) {
                $etat.CacherA = $null
                $w.Hide()
                foreach ($k in 'Reussite', 'Rate', 'Entree') { $sb[$k].Remove($w) }
            }
        } catch { $Prog.ErreurOverlay = $_.Exception.Message }
    })
    $minuterie.Start()
    $Prog.Pret = $true
    [System.Windows.Threading.Dispatcher]::Run()
}

function Demarrer-Overlay {
    $script:Prog = [hashtable]::Synchronized(@{
        Visible = $false; MainVisible = $true; Titre = ''; Etape = ''; Detail = ''; Pct = -1.0; Fin = ''
        Stop = $false; StopVisible = $false; Debut = [datetime]::Now; Rect = @(0, 0, 900, 600); Owner = [IntPtr]::Zero
        Quitter = $false; Pret = $false; Vider = $false; ErreurOverlay = ''
        Lignes = (New-Object 'System.Collections.Concurrent.ConcurrentQueue[string]')
    })
    try {
        $rs = [runspacefactory]::CreateRunspace()
        $rs.ApartmentState = 'STA'
        $rs.ThreadOptions = 'ReuseThread'
        $rs.Open()
        $ps = [powershell]::Create()
        $ps.Runspace = $rs
        [void]$ps.AddScript($ScriptOverlay.ToString()).AddArgument($script:Prog).AddArgument($XamlOverlay)
        $script:OverlayPs = $ps
        $script:OverlayAsync = $ps.BeginInvoke()
    } catch { Write-Log "Ecran de progression indisponible : $($_.Exception.Message)" 'Gray' }
}

function Maj-RectProg {
    if (-not $script:Prog -or -not $UI.Fenetre) { return }
    $f = $UI.Fenetre
    if ($f.WindowState -eq 'Maximized') {
        $wa = [System.Windows.SystemParameters]::WorkArea
        $l = $wa.Left; $t = $wa.Top; $w = $wa.Width; $h = $wa.Height
    } else { $l = $f.Left; $t = $f.Top; $w = $f.ActualWidth; $h = $f.ActualHeight }
    $script:Prog.Rect = @([double]$l, [double]($t + 46), [double]$w, [double]($h - 46))
    $script:Prog.MainVisible = ($f.IsVisible -and $f.WindowState -ne 'Minimized')
}

function Debut-Progression([string]$titre, [switch]$AvecStop) {
    if (-not $script:Prog) { return }
    $script:ProgMaj = 1; $script:ProgMajTot = 1
    $p = $script:Prog
    $p.Titre = $titre; $p.Etape = ''; $p.Detail = 'Preparation...'; $p.Pct = -1.0; $p.Fin = ''
    $p.Stop = $false; $p.StopVisible = [bool]$AvecStop; $p.Debut = [datetime]::Now; $p.Vider = $true
    $x = $null
    while ($p.Lignes.TryDequeue([ref]$x)) {}
    $script:ProgTest = [bool]$AvecStop
    Maj-RectProg
    $p.Visible = $true
}

function Fin-Progression([bool]$ok) {
    if (-not $script:Prog -or -not $script:Prog.Visible) { return }
    $p = $script:Prog
    $p.Titre = $(if ($ok) { 'Termine !' } else { 'Un probleme est survenu' })
    $p.Etape = $(if ($ok) { 'Tout s''est bien passe.' } else { 'Le detail est dans l''onglet Erreurs.' })
    $p.Detail = ''
    $p.Fin = $(if ($ok) { 'ok' } else { 'err' })
    $fin = (Get-Date).AddMilliseconds(1700)
    while ((Get-Date) -lt $fin) { Pump-Ui; Start-Sleep -Milliseconds 30 }
    $p.Visible = $false
    $script:ProgTest = $false
}

function Fixer-Pct([double]$v) {
    $v = [math]::Max(0.0, [math]::Min(0.99, [double]$v))
    if ([double]$script:Prog.Pct -lt 0 -or $v -gt [double]$script:Prog.Pct) { $script:Prog.Pct = $v }
}

function Progression-Log([string]$msg) {
    $t = $msg.Trim()
    if (-not $t) { return }
    $script:Prog.Lignes.Enqueue($t)
    if ($t -match '^#####\s*(\d+)\s*/\s*(\d+)\s*(.*?)\s*#*$') {
        $script:ProgMaj = [int]$Matches[1]; $script:ProgMajTot = [math]::Max(1, [int]$Matches[2])
        $script:Prog.Detail = ''
        $nomEtape = (Get-Culture).TextInfo.ToTitleCase($Matches[3].ToLower())
        $script:Prog.Etape = "Etape $($Matches[1]) sur $($Matches[2]) : $nomEtape"
        Fixer-Pct (($script:ProgMaj - 1) / $script:ProgMajTot)
    } elseif ($t -match '^\[\s*(\d+)\s*/\s*(\d+)\]\s*(.+)$') {
        $i = [int]$Matches[1]; $nb = [math]::Max(1, [int]$Matches[2])
        Fixer-Pct ((($script:ProgMaj - 1) + (($i - 1) / $nb)) / $script:ProgMajTot)
        $script:Prog.Detail = $Matches[3]
    } elseif ($msg -notmatch '^\s' -and $t -notmatch '^=====') {
        $script:Prog.Detail = $t
    }
}

# ---------------------------------------------------------------------
#  ACTIONS (avec ecran anime)
# ---------------------------------------------------------------------
function Invoke-Action([string]$titre, [scriptblock]$travail) {
    $sourceAvant = $script:SourceAction
    if (-not $script:SourceAction) { $script:SourceAction = $titre }
    Set-Busy $true
    $script:DejaNote = @{}
    $proprio = -not ($script:Prog -and $script:Prog.Visible)
    if ($proprio) { Debut-Progression $titre }
    Write-Log "===== $titre =====" 'White'
    $debut = Get-Date
    $ok = $true
    try {
        & $travail
        $sec = [int][math]::Round(((Get-Date) - $debut).TotalSeconds)
        $duree = if ($sec -lt 60) { "$sec s" } else { '{0} min {1:00} s' -f [math]::Floor($sec / 60), ($sec % 60) }
        Write-Log "[OK] $titre termine ($duree)." 'White'
    }
    catch {
        $ok = $false
        Write-Log "[ERREUR] $($_.Exception.Message)" 'Tomato'
        Noter-Erreur $titre $_
    }
    finally {
        if ($proprio) { Fin-Progression $ok }
        $script:SourceAction = $sourceAvant
        Set-Busy $false
        Remplir-Changements
    }
}

# ---------------------------------------------------------------------
#  BOITES DE DIALOGUE
# ---------------------------------------------------------------------
function Show-Dialogue([string]$texte, [string]$titre = 'OptiGame', [string]$type = 'info', [switch]$OuiNon, [string]$Oui = 'Oui', [string]$Non = 'Non') {
    $cache = $false
    if ($script:Prog -and $script:Prog.Visible -and $script:Prog.MainVisible) { $cache = $true; $script:Prog.MainVisible = $false }
    try {
        $d = Charger-Xaml $XamlDialogue
        $styles = @{
            question = @([char]0xE9CE, '#16301F', '#00D46A')
            info     = @([char]0xE946, '#16243A', '#8AB4FF')
            alerte   = @([char]0xE7BA, '#3A2E14', '#FFC24B')
            succes   = @([char]0xE73E, '#16301F', '#00D46A')
            erreur   = @([char]0xE783, '#3A1A20', '#FF6B7A')
        }
        $s = $styles[$type]
        if (-not $s) { $s = $styles.info }
        $d.FindName('Icone').Text = [string]$s[0]
        $d.FindName('FondIcone').Background = [System.Windows.Media.BrushConverter]::new().ConvertFromString($s[1])
        $d.FindName('Icone').Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString($s[2])
        $d.FindName('Titre').Text = $titre
        $d.FindName('Message').Text = $texte
        $bOui = $d.FindName('BtnOui'); $bNon = $d.FindName('BtnNon')
        if ($OuiNon) { $bOui.Content = $Oui; $bNon.Content = $Non }
        else { $bOui.Content = 'OK'; $bNon.Visibility = 'Collapsed' }
        $res = @{ V = $false }
        $bOui.Add_Click({ $res.V = $true; $d.Close() }.GetNewClosure())
        $bNon.Add_Click({ $d.Close() }.GetNewClosure())
        $d.FindName('Entete').Add_MouseLeftButtonDown({ try { $d.DragMove() } catch {} }.GetNewClosure())
        $d.Add_KeyDown({
            param($s2, $e)
            if ($e.Key -eq 'Escape') { $d.Close() }
            elseif ($e.Key -eq 'Return') { $res.V = $true; $d.Close() }
        }.GetNewClosure())
        if ($UI.Fenetre -and $UI.Fenetre.IsVisible -and $UI.Fenetre.WindowState -ne 'Minimized') { $d.Owner = $UI.Fenetre }
        else { $d.WindowStartupLocation = 'CenterScreen'; $d.Topmost = $true }
        [void]$d.ShowDialog()
        return [bool]$res.V
    }
    catch {
        $btn = if ($OuiNon) { 'YesNo' } else { 'OK' }
        $r = [System.Windows.Forms.MessageBox]::Show($texte, $titre, $btn)
        return ($r -eq 'Yes' -or $r -eq 'OK')
    }
    finally { if ($cache) { Maj-RectProg } }
}

function Ask-YesNo([string]$texte) { return (Show-Dialogue $texte 'OptiGame' 'question' -OuiNon) }
function Show-Info([string]$texte, [string]$titre = 'OptiGame') { [void](Show-Dialogue $texte $titre 'info') }

function Afficher-Toast([string]$texte, [string]$type = 'ok') {
    if (-not $UI.Toast) { return }
    $UI.ToastTexte.Text = $texte
    $ic = @{ ok = @([char]0xE73E, '#00D46A'); info = @([char]0xE946, '#8AB4FF'); alerte = @([char]0xE7BA, '#FFC24B') }[$type]
    if (-not $ic) { $ic = @([char]0xE73E, '#00D46A') }
    $UI.ToastIcone.Text = [string]$ic[0]
    $UI.ToastIcone.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString($ic[1])
    $op = New-Object System.Windows.Media.Animation.DoubleAnimationUsingKeyFrames
    foreach ($k in @(@(0, 0), @(200, 1), @(2800, 1), @(3200, 0))) {
        [void]$op.KeyFrames.Add((New-Object System.Windows.Media.Animation.LinearDoubleKeyFrame($k[1], [System.Windows.Media.Animation.KeyTime]::FromTimeSpan([TimeSpan]::FromMilliseconds($k[0])))))
    }
    $UI.Toast.BeginAnimation([System.Windows.UIElement]::OpacityProperty, $op)
    Animer $UI.Toast.RenderTransform ([System.Windows.Media.TranslateTransform]::YProperty) 0 350 20
}

# ---------------------------------------------------------------------
#  TEST DE PERFORMANCE (affichage)
# ---------------------------------------------------------------------
function Set-Phase([string]$t) {
    if ($UI.TxtPhase) { $UI.TxtPhase.Text = $t }
    if ($script:Prog -and $script:Prog.Visible) { $script:Prog.Etape = $t }
    Pump-Ui
}

function Set-Compte([string]$t) {
    if ($UI.TxtCompte) { $UI.TxtCompte.Text = $t }
    if ($script:Prog -and $script:Prog.Visible) { $script:Prog.Detail = $t }
}

function Wait-Ui([int]$secondes, [string]$texte) {
    $fin = (Get-Date).AddSeconds($secondes)
    while ((Get-Date) -lt $fin) {
        Check-Stop
        Set-Compte "$texte : $([math]::Ceiling(($fin - (Get-Date)).TotalSeconds)) s"
        Pump-Ui
        Start-Sleep -Milliseconds 150
    }
    Set-Compte ''
}

function Update-TestUi {
    $enCours = $script:TestEnCours -or (Test-Path $EtatFichier)
    Set-Busy $enCours
    if ($UI.BtnTestStop) { $UI.BtnTestStop.IsEnabled = $enCours }
    if ($script:TestEnCours) {
        if ($script:Prog -and -not $script:Prog.Visible) { Debut-Progression 'Test de performance' -AvecStop }
    } elseif ($script:Prog -and $script:Prog.Visible -and $script:ProgTest) {
        $script:Prog.Visible = $false
        $script:ProgTest = $false
    }
}

function Vider-ResultatsTest {
    if (-not $UI.ListeResultats) { return }
    $UI.ListeResultats.ItemsSource = $null
    $UI.TxtTestVide.Visibility = 'Visible'
    $script:TestCoches = @{}
}

function Afficher-Resultats($data) {
    $items = @()
    $script:TestCoches = @{}
    foreach ($r in (Liste $data.Resultats)) {
        $lot = $Lots[$r.Id]
        if (-not $lot) { continue }
        $c = switch ($r.Verdict) {
            'Utile'    { @('#3FE08E', '#163626') }
            'Mitige'   { @('#FFC24B', '#3A2E14') }
            'A eviter' { @('#FF8A97', '#3A1A20') }
            default    { @('#8C95A8', '#232A36') }
        }
        $coche = [bool]($lot.Permanent -and $r.Verdict -eq 'Utile')
        if ($coche) { $script:TestCoches[$r.Id] = $true }
        $items += [pscustomobject]@{
            Id = $r.Id; Nom = $lot.Nom; Verdict = $r.Verdict; Meilleur = "Meilleur gain : $($r.Meilleur)"
            Conseil = $lot.Conseil; Activable = [bool]$lot.Permanent; Coche = $coche
            CouleurVerdict = $c[0]; FondVerdict = $c[1]
        }
    }
    $UI.ListeResultats.ItemsSource = $items
    $UI.TxtTestVide.Visibility = $(if ($items.Count) { 'Collapsed' } else { 'Visible' })
}

# ---------------------------------------------------------------------
#  INFORMATIONS, CONSEILS, HISTORIQUE, ERREURS
# ---------------------------------------------------------------------
function Remplir-Changements {
    if (-not $UI.ListeHisto) { return }
    $items = @()
    for ($k = $script:Journal.Count - 1; $k -ge 0; $k--) {
        $e = $script:Journal[$k]
        $src = "$($e.Source)"
        $ex = "$($e.Explication)"
        if (-not $ex) { $ex = Explication-Journal ([string]$e.Element) }
        $items += [pscustomobject]@{ Date = [string]$e.Date; Element = [string]$e.Element; Avant = [string]$e.Avant; Apres = [string]$e.Apres
            Source = $(if ($src) { "Fait par : $src" } else { 'Fait par : OptiGame (ancienne version, bouton non enregistre)' })
            Explication = $ex; VisExpl = $(if ($ex) { 'Visible' } else { 'Collapsed' }) }
    }
    $UI.ListeHisto.ItemsSource = $items
    $UI.TxtHistoVide.Visibility = $(if ($items.Count) { 'Collapsed' } else { 'Visible' })
}

$StyleNiveaux = @{
    'ALERTE'  = @('#FF5468', '#33FF5468')
    'A FAIRE' = @('#FFC24B', '#33FFC24B')
    'INFO'    = @('#5AA9FF', '#2E5AA9FF')
    'OK'      = @('#00D46A', '#2600D46A')
}

function Remplir-Conseils($i) {
    if (-not $UI.ListeConseils) { return }
    $L = @(Calculer-Conseils $i)
    $masques = @(Lire-Masques)
    $nbMasques = @($L | Where-Object { $_.Id -and $masques -contains $_.Id }).Count
    $L = @($L | Where-Object { -not ($_.Id -and $masques -contains $_.Id) })
    $items = @()
    foreach ($niv in @('ALERTE', 'A FAIRE', 'INFO', 'OK')) {
        foreach ($c in @($L | Where-Object { $_.N -eq $niv })) {
            $acts = @()
            foreach ($a in @($c.A)) { if ($a -and $a.Count -ge 2) { $acts += [pscustomobject]@{ Label = [string]$a[0]; Cible = [string]$a[1] } } }
            if ($c.Id -and $niv -ne 'OK') { $acts += [pscustomobject]@{ Label = "C'est fait : masquer"; Cible = "masquer:$($c.Id)" } }
            $items += [pscustomobject]@{ Niveau = $niv; Texte = $c.T; Couleur = $StyleNiveaux[$niv][0]; Fond = $StyleNiveaux[$niv][1]; Actions = $acts
                Etapes = "$($c.E)"; VisEtapes = $(if ($c.E) { 'Visible' } else { 'Collapsed' }) }
        }
    }
    $UI.ListeConseils.ItemsSource = $items
    $nbFaire = @($items | Where-Object { $_.Niveau -in 'ALERTE', 'A FAIRE' }).Count
    $nbOk = @($items | Where-Object { $_.Niveau -eq 'OK' }).Count
    $t = "$nbFaire a regler, $nbOk deja bien regle(s). Analyse faite a $((Get-Date).ToString('HH:mm:ss'))."
    if ($nbMasques) { $t += " $nbMasques conseil(s) masque(s)." }
    $UI.TxtConseilsInfo.Text = $t
}

function Ajouter-Score($liste, [bool]$ok, [string]$texte, [string]$aide) {
    [void]$liste.Add([pscustomobject]@{
        Ok = $ok; Texte = $texte; Aide = $(if ($aide) { $aide } else { $null })
        Icone = $(if ($ok) { [string][char]0xE73E } else { [string][char]0xE7BA })
        Couleur = $(if ($ok) { '#00D46A' } else { '#FFC24B' })
    })
}

function Calculer-Score($i) {
    $L = New-Object System.Collections.ArrayList
    Ajouter-Score $L ($i.Plan -match 'lev|Ultime|High|Ultimate|Performance') 'Alimentation performances' "Plan actuel : $($i.Plan)"
    Ajouter-Score $L ("$($i.Hags)" -eq '2') 'Planification GPU active' $null
    Ajouter-Score $L ("$(Lire-Reg 'HKCU:\System\GameConfigStore' 'GameDVR_Enabled')" -eq '0') 'Capture en fond coupee' 'Game DVR'
    Ajouter-Score $L ("$(Lire-Reg 'HKCU:\Software\Microsoft\GameBar' 'AutoGameModeEnabled')" -ne '0') 'Mode Jeu actif' $null
    if ($i.RamCfg) {
        $seuil = if ($i.RamType -eq 'DDR5') { 5200 } else { 2900 }
        Ajouter-Score $L ($i.RamCfg -ge $seuil -and -not ($i.RamMax -and $i.RamCfg -lt $i.RamMax)) 'RAM a pleine vitesse' "$($i.RamCfg) MHz"
    }
    $vieux = @($i.Gpus | Where-Object { $_.DriverDate -is [datetime] -and ((Get-Date) - $_.DriverDate).Days -gt 120 })
    if (@($i.Gpus).Count) { Ajouter-Score $L ($vieux.Count -eq 0) 'Pilote graphique recent' $null }
    if ($i.CTotal -gt 0) { Ajouter-Score $L (($i.CLibre / $i.CTotal) -ge 0.15) 'Assez de place sur C:' ('{0:N0} Go libres' -f ($i.CLibre / 1GB)) }
    Ajouter-Score $L ($i.Uptime.Days -lt 7) 'Redemarre recemment' $null
    if (@($i.Ecrans).Count) { Ajouter-Score $L (@($i.Ecrans | Where-Object { $_.Max -gt $_.Hz }).Count -eq 0) 'Ecran a sa frequence max' $null }
    $eth = @($i.Nets | Where-Object { -not (Est-WiFi $_) })
    if ($eth.Count) { Ajouter-Score $L (@($eth | Where-Object { $_.Status -eq 'Up' }).Count -gt 0) 'Connecte en cable' $null }
    $x = $i.Plus
    if ($x) {
        if ($null -ne $x.SourisAccel) { Ajouter-Score $L (-not $x.SourisAccel) 'Souris sans acceleration' 'Ameliorer la precision du pointeur : coupe = visee reguliere' }
        Ajouter-Score $L (-not $x.Capture) 'Capture Xbox coupee' 'Enregistrement en arriere-plan de la Game Bar'
        Ajouter-Score $L (-not $x.RedemAttente) 'Aucune mise a jour en attente' 'Mise a jour Windows qui attend un redemarrage'
        if ($x.DerniereMaj -is [datetime]) { Ajouter-Score $L (((Get-Date) - $x.DerniereMaj).TotalDays -le 45) 'Windows a jour' "Derniere mise a jour : $($x.DerniereMaj.ToString('dd/MM/yyyy'))" }
        Ajouter-Score $L (@($x.Demarrage).Count -le 8) 'Peu d''applis au demarrage' "$(@($x.Demarrage).Count) programme(s) au demarrage"
        if ($null -ne $x.Trim) { Ajouter-Score $L ([bool]$x.Trim) 'TRIM du SSD actif' $null }
        if ($x.DisqueC) { Ajouter-Score $L ($x.DisqueC.Type -ne 'HDD') 'Windows sur SSD' "$($x.DisqueC.Nom)" }
        Ajouter-Score $L (-not $x.ModeEco) 'Pas de bridage energie' 'Mode d''alimentation Windows 11'
        if ($null -ne $x.PagefileAuto) { Ajouter-Score $L ([bool]$x.PagefileAuto) 'Memoire virtuelle auto' 'Fichier d''echange gere par Windows' }
    }
    try {
        $av = Etat-Antivirus
        Ajouter-Score $L (($av.Defender -and $av.TempsReel) -or $av.Tiers.Count -gt 0) 'Antivirus actif' $null
    } catch {}
    return , $L
}

function Dessiner-Arc([double]$v) {
    if (-not $UI.ArcScore) { return }
    $r = 85.0; $cx = 100.0; $cy = 100.0
    $ang = [math]::Min(359.9, 360.0 * $v / 100.0)
    if ($ang -le 0.5) { $UI.ArcScore.Data = $null; return }
    $rad = ($ang - 90) * [math]::PI / 180
    $x = $cx + $r * [math]::Cos($rad); $y = $cy + $r * [math]::Sin($rad)
    $geo = New-Object System.Windows.Media.StreamGeometry
    $ctx = $geo.Open()
    $ctx.BeginFigure((New-Object System.Windows.Point($cx, ($cy - $r))), $false, $false)
    $ctx.ArcTo((New-Object System.Windows.Point($x, $y)), (New-Object System.Windows.Size($r, $r)), 0, ($ang -gt 180),
        [System.Windows.Media.SweepDirection]::Clockwise, $true, $false)
    $ctx.Close()
    $geo.Freeze()
    $UI.ArcScore.Data = $geo
}

function Animer-Score([int]$cible) {
    $script:ScoreDe = [double]$script:ScoreActuel
    $script:ScoreVers = [double]$cible
    $script:ScoreDebut = Get-Date
    if (-not $script:MinuterieScore) {
        $script:MinuterieScore = New-Object System.Windows.Threading.DispatcherTimer
        $script:MinuterieScore.Interval = [TimeSpan]::FromMilliseconds(16)
        $script:MinuterieScore.Add_Tick({
            $t = [math]::Min(1.0, ((Get-Date) - $script:ScoreDebut).TotalMilliseconds / 1200.0)
            $e = 1 - [math]::Pow(1 - $t, 3)
            $v = $script:ScoreDe + ($script:ScoreVers - $script:ScoreDe) * $e
            $script:ScoreActuel = $v
            Dessiner-Arc $v
            $UI.TxtScore.Text = [string][math]::Round($v)
            if ($t -ge 1) { $script:MinuterieScore.Stop() }
        })
    }
    $script:MinuterieScore.Start()
}

function Maj-Accueil {
    $i = $script:Infos
    if (-not $i -or -not $UI.ListeScore) { return }
    $L = Calculer-Score $i
    $nbOk = @($L | Where-Object { $_.Ok }).Count
    $score = if ($L.Count) { [math]::Round(100.0 * $nbOk / $L.Count) } else { 0 }
    $UI.ListeScore.ItemsSource = @($L)
    $UI.TxtScoreTitre.Text = if ($score -ge 90) { 'Ton PC est au top' } elseif ($score -ge 70) { 'Ton PC est bien regle' } elseif ($score -ge 50) { 'Quelques reglages a ameliorer' } else { 'Ton PC peut aller beaucoup plus vite' }
    $ko = $L.Count - $nbOk
    $UI.TxtScoreSous.Text = if ($ko -gt 0) { "$ko point(s) sur $($L.Count) a regler. Tout optimiser s'occupe des reglages Windows ; clique sur un point pour voir le conseil (avec les etapes et les boutons)." } else { 'Tout est en ordre. Lance Tout optimiser de temps en temps pour garder ton PC au top.' }
    $cpu = "$($i.Cpu.Name)".Trim()
    $UI.TxtCpuNom.Text = $cpu
    $UI.TxtBonjour.Text = "$cpu - $(@($i.Gpus | ForEach-Object { $_.Name }) -join ', ') - $($i.RamTot) Go de RAM"
    Animer-Score $score
}

function Maj-StatsDirect {
    if ($script:Busy -or $script:TestEnCours -or -not (Fenetre-Ouverte) -or $script:PageActive -ne 'PageAccueil') { return }
    try {
        $cpu = [double](Get-CimInstance Win32_PerfFormattedData_PerfOS_Processor -Filter "Name='_Total'" -ErrorAction Stop).PercentProcessorTime
        $os = Get-CimInstance Win32_OperatingSystem -ErrorAction Stop
        $tot = [double]$os.TotalVisibleMemorySize; $libre = [double]$os.FreePhysicalMemory
        $ram = if ($tot -gt 0) { ($tot - $libre) / $tot * 100 } else { 0 }
        $UI.TxtCpu.Text = ('{0:N0} %' -f $cpu)
        $UI.TxtRam.Text = ('{0:N0} %' -f $ram)
        $UI.TxtRam.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString($(if ($ram -ge 85) { '#FFC24B' } else { '#E9ECF2' }))
        $UI.TxtRamNom.Text = ('{0:N1} Go utilises sur {1:N0} Go' -f (($tot - $libre) / 1MB), ($tot / 1MB))
        Animer $UI.BarreCpu.RenderTransform ([System.Windows.Media.ScaleTransform]::ScaleXProperty) ([math]::Min(1.0, [double]$cpu / 100.0)) 600
        Animer $UI.BarreRam.RenderTransform ([System.Windows.Media.ScaleTransform]::ScaleXProperty) ([math]::Min(1.0, [double]$ram / 100.0)) 600
    } catch {}
    try { Maj-Temperatures } catch {}
}

function Actualiser-Infos {
    if ($UI.TxtStatut) { $UI.TxtStatut.Text = 'Analyse de ton PC...' }
    Pump-Ui
    try {
        $i = Collecter-Infos
        $script:Infos = $i
        $script:DerniereLecture = Get-Date
        Remplir-Composants $i
        Suivre-Evolution $i
        Remplir-Changements
        Remplir-Conseils $i
        Maj-Accueil
        if ($UI.TxtStatut) { $UI.TxtStatut.Text = 'Pret.' }
    }
    catch {
        if ($UI.TxtStatut) { $UI.TxtStatut.Text = "Lecture des infos incomplete : $($_.Exception.Message)" }
        Noter-Erreur 'Lecture des informations du PC' $_
    }
}

function Copier-Infos {
    $t = New-Object System.Text.StringBuilder
    foreach ($l in @($script:LignesComp)) { [void]$t.AppendLine(('{0} : {1}' -f $l.Label, $l.Valeur)) }
    [System.Windows.Clipboard]::SetText($t.ToString())
    Afficher-Toast 'Infos copiees : colle-les (Ctrl + V) ou tu veux.'
}

function Remplir-Erreurs {
    if (-not $UI.ListeErreurs) { return }
    $items = @()
    for ($k = $script:Erreurs.Count - 1; $k -ge 0; $k--) {
        $e = $script:Erreurs[$k]
        $items += [pscustomobject]@{ Idx = $k; Date = [string]$e.Date; Ou = [string]$e.Ou; Message = [string]$e.Message }
    }
    $UI.ListeErreurs.ItemsSource = $items
    $UI.ErreursVide.Visibility = $(if ($items.Count) { 'Collapsed' } else { 'Visible' })
    $UI.BadgeErreurs.Visibility = $(if ($items.Count) { 'Visible' } else { 'Collapsed' })
    $UI.TxtBadgeErreurs.Text = [string]$items.Count
    if ($items.Count) { $UI.ListeErreurs.SelectedIndex = 0 } else { Afficher-Erreur $null }
}

function Afficher-Erreur($e) {
    if (-not $e) {
        $UI.TxtCause.Text = 'Aucune erreur. Tout va bien !'
        $UI.TxtDetail.Text = ''
        $UI.BtnCorriger.Visibility = 'Collapsed'
        return
    }
    $UI.TxtCause.Text = [string]$e.Cause
    $UI.TxtDetail.Text = ([string]$e.Detail) -replace "(?<!`r)`n", "`r`n"
    if ($e.Action) {
        $UI.BtnCorriger.Visibility = 'Visible'
        $UI.BtnCorriger.Content = [string]$e.Label
        $UI.BtnCorriger.Tag = [string]$e.Action
    } else { $UI.BtnCorriger.Visibility = 'Collapsed' }
}

# ---------------------------------------------------------------------
#  JEUX
# ---------------------------------------------------------------------
function Remplir-ListeJeux([switch]$Force) {
    if (-not $UI.ListeJeux) { return }
    $items = @()
    $sig = New-Object System.Text.StringBuilder
    foreach ($nom in $Jeux.Keys) {
        $def = $Jeux[$nom]
        $enCours = $script:JeuxActifs.ContainsKey($nom)
        $opti = [bool]($def -and (Jeu-Optimise $nom))
        $point = if ($enCours) { '#00D46A' } elseif ($opti) { '#2E9E6A' } elseif ($def) { '#3A4252' } else { '#262C38' }
        $statut = if ($enCours) { if ($opti) { 'En cours - optimise' } else { 'En cours' } }
                  elseif ($opti) { 'Optimise' } elseif ($def) { 'Pas encore optimise' } else { 'Bientot disponible' }
        $items += [pscustomobject]@{
            Nom = $nom; Statut = $statut; Point = $point; EnCours = $enCours
            VisOpti = $(if ($opti) { 'Visible' } else { 'Collapsed' })
            CouleurNom = $(if ($def) { '#E9ECF2' } else { '#6F788B' })
        }
        [void]$sig.Append("$nom|$statut;")
    }
    if (-not $Force -and $sig.ToString() -eq $script:SigJeux) { return }
    $script:SigJeux = $sig.ToString()
    $script:RemplissageJeux = $true
    $UI.ListeJeux.ItemsSource = $items
    if ($script:JeuSel) { $UI.ListeJeux.SelectedItem = ($items | Where-Object { $_.Nom -eq $script:JeuSel } | Select-Object -First 1) }
    $script:RemplissageJeux = $false
}

# Textes adaptes au PC sur lequel OptiGame tourne (detecte en direct, jamais ecrit en dur)
function Matos-PC {
    if ($script:MatosPC) { return $script:MatosPC }
    $cpu = $null; $gpu = $null; $vram = $null; $coeurs = $null
    try {
        $c = Get-CimInstance Win32_Processor -ErrorAction Stop | Select-Object -First 1
        $cpu = ("$($c.Name)" -replace '\(R\)|\(TM\)|CPU|Processor|\d+-Core|@.*$', '' -replace '\s+', ' ').Trim()
        $coeurs = [int]$c.NumberOfCores
    } catch {}
    try {
        $g = @(Get-CimInstance Win32_VideoController -ErrorAction Stop | Where-Object { $_.Name -notmatch 'Basic|Virtual|Remote|Parsec|Mirage' })
        $best = $null; $bv = -1
        foreach ($x in $g) { $v = Get-VramGo $x.Name; if ([double]$v -gt $bv) { $bv = [double]$v; $best = $x } }
        if ($best) { $gpu = ("$($best.Name)" -replace '\(R\)|\(TM\)|AMD |NVIDIA |Series', '' -replace '\s+', ' ').Trim(); if ($bv -gt 0) { $vram = "$bv Go" } }
    } catch {}
    if (-not $cpu) { $cpu = 'processeur inconnu' }
    if (-not $gpu) { $gpu = 'carte graphique inconnue' }
    if (-not $vram) { $vram = 'inconnue' }
    if (-not $coeurs) { $coeurs = '?' }
    $cfg = "$cpu + $gpu"
    if ($vram -ne 'inconnue') { $cfg += " $vram" }
    $script:MatosPC = @{ CONFIG = $cfg; GPU = $gpu; VRAM = $vram; COEURS = "$coeurs"; CPU = $cpu }
    return $script:MatosPC
}
function Personnaliser([string]$t) {
    if ($t -notmatch '\{[A-Z]+\}') { return $t }
    $m = Matos-PC
    foreach ($k in $m.Keys) { $t = $t.Replace('{' + $k + '}', [string]$m[$k]) }
    return $t
}

function Remplir-OptionsJeu([string]$nom) {
    $def = $Jeux[$nom]
    $UI.TxtJeuNom.Text = $nom
    if ($def) {
        $c = Get-ChoixJeu $nom
        $items = @()
        foreach ($o in $def.Options) {
            $items += [pscustomobject]@{
                Nom = $o.Nom; Desc = (Personnaliser $o.Desc); Coche = (@($c.Choix) -contains $o.Nom)
                VisApplique = $(if ((@($c.Appliques) -contains $o.Nom) -and -not (@($script:EcartsJeux[$nom]) -contains $o.Nom)) { 'Visible' } else { 'Collapsed' })
                VisEcart = $(if (@($script:EcartsJeux[$nom]) -contains $o.Nom) { 'Visible' } else { 'Collapsed' })
            }
        }
        $UI.ListeOptions.ItemsSource = $items
        $UI.TxtJeuVide.Visibility = 'Collapsed'
        $UI.TxtJeuEtat.Text = 'Recherche du jeu sur ton PC...'
        Pump-Ui
        $UI.TxtJeuEtat.Text = (Etat-Jeu $nom) -replace "`r`n", '   '
    } else {
        $UI.ListeOptions.ItemsSource = $null
        $UI.TxtJeuVide.Visibility = 'Visible'
        $UI.TxtJeuEtat.Text = ''
    }
    Update-BtnJeu
}

function Afficher-JeuxEnCours {
    if (-not $UI.PilluleJeux) { return }
    $noms = @($script:JeuxActifs.Keys | Sort-Object)
    if ($noms.Count -eq 0) {
        $UI.PilluleJeux.Visibility = 'Collapsed'
        $UI.PointJeux.Fill = [System.Windows.Media.BrushConverter]::new().ConvertFromString('#3A4252')
        $UI.TxtCoteJeux.Text = 'Aucun'
        $UI.TxtJeuxNb.Text = '0'
        $UI.TxtJeuxNoms.Text = 'Lance un jeu : OptiGame le detecte tout seul.'
    } else {
        $etats = @($noms | ForEach-Object { Texte-EtatJeu $_ })
        $UI.PilluleJeux.Visibility = 'Visible'
        $UI.TxtPilluleJeux.Text = 'En cours : ' + ($etats -join '   |   ')
        $UI.PointJeux.Fill = [System.Windows.Media.BrushConverter]::new().ConvertFromString('#00D46A')
        $UI.TxtCoteJeux.Text = ($noms -join ', ')
        $UI.TxtJeuxNb.Text = [string]$noms.Count
        $UI.TxtJeuxNoms.Text = ($etats -join "`n")
    }
    Remplir-ListeJeux
}

# ---------------------------------------------------------------------
#  VERSIONS
# ---------------------------------------------------------------------
# ---------- Toutes les versions, quel que soit le nom du fichier (.ps1 ou .bat) ----------
$FichiersExclus = @('Demarrer_OptiGame.ps1', 'Lanceur_OptiGame.bat', 'Lancer_OptiGame.bat', 'Lanceur_OptiGame.ps1')

function Infos-Version($f) {
    $ext = $f.Extension.ToLower()
    $v = $null
    if ($f.Name -match '^OptiGame_v(\d+(\.\d+)*)\.ps1$') { $v = $Matches[1] }
    elseif ($ext -eq '.ps1') {
        try {
            $debut = (Get-Content -LiteralPath $f.FullName -TotalCount 15 -ErrorAction Stop) -join "`n"
            if ($debut -match '(?m)^#\s*OptiGame version\s*:\s*(\d+(\.\d+)*)') { $v = $Matches[1] }
        } catch {}
    }
    $ver = $null
    if ($v) { if ($v -notmatch '\.') { $v += '.0' }; try { $ver = [version]$v } catch {} }
    $base = [IO.Path]::GetFileNameWithoutExtension($f.Name)
    $label = if ($ver) { "v$($ver.Major).$($ver.Minor)" } elseif ($ext -in '.bat', '.cmd') { "$base (console)" } else { $base }
    return [pscustomobject]@{
        Name = $f.Name; FullName = $f.FullName; LastWriteTime = $f.LastWriteTime; Extension = $ext
        Version = $ver; Label = $label; Ancienne = ($null -eq $ver)
    }
}

# Versions numerotees d'abord (de la plus recente a la plus ancienne), puis les fichiers sans numero (par date)
function Lister-ToutesVersions([string]$dossier) {
    $infos = @(Get-ChildItem -LiteralPath $dossier -File -ErrorAction SilentlyContinue |
        Where-Object { $_.Extension -in '.ps1', '.bat', '.cmd' -and $FichiersExclus -notcontains $_.Name } |
        ForEach-Object { Infos-Version $_ })
    $avec = @($infos | Where-Object { $_.Version } | Sort-Object Version -Descending)
    $sans = @($infos | Where-Object { -not $_.Version } | Sort-Object LastWriteTime -Descending)
    return @($avec + $sans)
}

function Notes-Fichier([string]$chemin) {
    $ext = [IO.Path]::GetExtension($chemin).ToLower()
    if ($ext -in '.bat', '.cmd') { return "Toute premiere version d'OptiGame : un menu en mode texte (fenetre noire), sans interface." }
    try {
        $debut = (Get-Content -LiteralPath $chemin -TotalCount 120 -ErrorAction Stop) -join "`n"
        $n = @([regex]::Matches($debut, '(?m)^#\s*NOTE\s*:\s*(.+)$') | ForEach-Object { [string][char]0x2022 + '  ' + $_.Groups[1].Value.Trim() })
        if ($n.Count -gt 0) { return ($n -join "`r`n`r`n") }
    } catch {}
    return 'Ancienne version (pas de notes).'
}

function Lancer-Fichier([string]$chemin) {
    Unblock-File -LiteralPath $chemin -ErrorAction SilentlyContinue
    $ext = [IO.Path]::GetExtension($chemin).ToLower()
    if ($ext -in '.bat', '.cmd') { Start-Process -FilePath $chemin -WorkingDirectory (Split-Path $chemin); return }
    $extra = ''
    if ([IO.Path]::GetFileName($chemin) -notmatch '^OptiGame_v\d+(\.\d+)*\.ps1$') {
        # Ancienne version au nom libre : -Reprise l'empeche de basculer toute seule vers une autre version
        $txt = [IO.File]::ReadAllText($chemin)
        if ($txt -match 'function Choisir-Version' -and $txt -match '\[switch\]\$Reprise') { $extra = ' -Reprise' }
    }
    Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$chemin`"$extra$ArgTest"
}

function Notes-Version([string]$chemin) { return (Notes-Fichier $chemin) }

function Remplir-Versions {
    if (-not $UI.ListeVersions) { return }
    $liste = Lister-ToutesVersions (Split-Path $PSCommandPath)
    $items = @()
    $k = 0
    foreach ($f in $liste) {
        $enCours = ($f.FullName -eq $PSCommandPath)
        $items += [pscustomobject]@{
            Version = $f.Label; Fichier = $(if ($f.Ancienne) { "$($f.Name)  (ancienne)" } else { $f.Name })
            Date = 'Ajoutee le ' + $f.LastWriteTime.ToString('dd/MM/yyyy HH:mm')
            Chemin = $f.FullName; Couleur = $(if ($enCours) { '#00D46A' } elseif ($f.Ancienne) { '#B9C0CE' } else { '#E9ECF2' })
            VisEnCours = $(if ($enCours) { 'Visible' } else { 'Collapsed' })
            VisRecente = $(if ($k -eq 0 -and -not $f.Ancienne) { 'Visible' } else { 'Collapsed' })
        }
        $k++
    }
    $UI.ListeVersions.ItemsSource = $items
    $avant = $script:VersionChoisie
    $sel = $null
    if ($avant) { $sel = $items | Where-Object { $_.Chemin -eq $avant } | Select-Object -First 1 }
    if (-not $sel) { $sel = $items | Where-Object { $_.Chemin -eq $PSCommandPath } | Select-Object -First 1 }
    $UI.ListeVersions.SelectedItem = $sel
}

# ---------------------------------------------------------------------
#  ICONE, RACCOURCIS, ZONE DE NOTIFICATION
# ---------------------------------------------------------------------
function Dessiner-Logo([int]$t) {
    $bmp = New-Object Drawing.Bitmap($t, $t)
    $g = [Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = 'AntiAlias'
    $g.TextRenderingHint = 'AntiAliasGridFit'
    $g.Clear([Drawing.Color]::Transparent)
    $r = [int]($t * 0.22)
    $chemin = New-Object Drawing.Drawing2D.GraphicsPath
    $m = [math]::Max(1, [int]($t * 0.03)); $s = $t - 2 * $m
    $chemin.AddArc($m, $m, $r, $r, 180, 90)
    $chemin.AddArc($m + $s - $r, $m, $r, $r, 270, 90)
    $chemin.AddArc($m + $s - $r, $m + $s - $r, $r, $r, 0, 90)
    $chemin.AddArc($m, $m + $s - $r, $r, $r, 90, 90)
    $chemin.CloseFigure()
    $pinceau = New-Object Drawing.Drawing2D.LinearGradientBrush((New-Object Drawing.Point(0, 0)), (New-Object Drawing.Point($t, $t)),
        [Drawing.Color]::FromArgb(0, 212, 106), [Drawing.Color]::FromArgb(0, 178, 214))
    $g.FillPath($pinceau, $chemin)
    $police = New-Object Drawing.Font('Segoe UI', [single]($t * 0.36), [Drawing.FontStyle]::Bold, [Drawing.GraphicsUnit]::Pixel)
    $format = New-Object Drawing.StringFormat
    $format.Alignment = 'Center'; $format.LineAlignment = 'Center'
    $g.DrawString('OG', $police, (New-Object Drawing.SolidBrush([Drawing.Color]::FromArgb(6, 19, 12))), (New-Object Drawing.RectangleF(0, [single]($t * 0.02), $t, $t)), $format)
    $g.Dispose()
    return $bmp
}

function Ecrire-Ico([string]$chemin) {
    $bmp = Dessiner-Logo 256
    $ms = New-Object IO.MemoryStream
    $bmp.Save($ms, [Drawing.Imaging.ImageFormat]::Png)
    $png = $ms.ToArray()
    New-Item -ItemType Directory -Path (Split-Path $chemin) -Force | Out-Null
    $fs = [IO.File]::Create($chemin)
    $bw = New-Object IO.BinaryWriter($fs)
    $bw.Write([UInt16]0); $bw.Write([UInt16]1); $bw.Write([UInt16]1)
    $bw.Write([byte]0); $bw.Write([byte]0); $bw.Write([byte]0); $bw.Write([byte]0)
    $bw.Write([UInt16]1); $bw.Write([UInt16]32); $bw.Write([UInt32]$png.Length); $bw.Write([UInt32]22)
    $bw.Write($png)
    $bw.Close()
}

function Creer-Raccourcis {
    if ($TestAmi) { Write-Log 'Mode test ami : les raccourcis ne sont pas touches.' 'Gray'; return @() }
    $dossierApp = Split-Path $PSCommandPath
    $ico = Join-Path $DossierData 'OptiGame.ico'
    Ecrire-Ico $ico
    Ecrire-ScriptLancement $ScriptOuvrir
    Remove-Item -LiteralPath (Join-Path $dossierApp 'Demarrer_OptiGame.ps1') -Force -ErrorAction SilentlyContinue
    $ps = Join-Path $env:WINDIR 'System32\WindowsPowerShell\v1.0\powershell.exe'
    $lanceurBat = @((Join-Path $dossierApp 'Lanceur_OptiGame.bat'), (Join-Path (Split-Path $dossierApp) 'Lanceur_OptiGame.bat')) | Where-Object { Test-Path $_ } | Select-Object -First 1
    $sh = New-Object -ComObject WScript.Shell
    $faits = @()
    foreach ($dossier in @([Environment]::GetFolderPath('Desktop'), [Environment]::GetFolderPath('Programs'))) {
        # OptiGame : ouvre directement la derniere version utilisee
        try {
            $s = $sh.CreateShortcut((Join-Path $dossier 'OptiGame.lnk'))
            $s.TargetPath = $ps
            $s.Arguments = "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$ScriptOuvrir`""
            $s.WorkingDirectory = $dossierApp
            $s.IconLocation = "$ico,0"
            $s.WindowStyle = 7
            $s.Description = 'OptiGame (derniere version utilisee)'
            $s.Save()
            $faits += $s.FullName
        } catch {}
        # Lanceur OptiGame : choisir ou ajouter une version
        if ($lanceurBat) {
            try {
                Remove-Item -LiteralPath (Join-Path $dossier 'Lanceur OptiGame.lnk') -Force -ErrorAction SilentlyContinue
                $s = $sh.CreateShortcut((Join-Path $dossier 'OptiGame - Lanceur.lnk'))
                $s.TargetPath = $lanceurBat
                $s.Arguments = ''
                $s.WorkingDirectory = (Split-Path $lanceurBat)
                $s.IconLocation = "$ico,0"
                $s.WindowStyle = 7
                $s.Description = 'OptiGame - Lanceur (choisir une version)'
                $s.Save()
                $faits += $s.FullName
            } catch {}
        }
    }
    return $faits
}

# Anciens raccourcis "OptiGame" qui ouvraient le lanceur : remplaces une fois par les deux nouveaux
function Migrer-Raccourcis {
    if ($TestAmi) { return }
    try { Ecrire-ScriptLancement $ScriptOuvrir } catch {}
    $sh = New-Object -ComObject WScript.Shell
    foreach ($dossier in @([Environment]::GetFolderPath('Desktop'), [Environment]::GetFolderPath('Programs'))) {
        $lnk = Join-Path $dossier 'OptiGame.lnk'
        if (-not (Test-Path -LiteralPath $lnk)) { continue }
        try {
            $t = $sh.CreateShortcut($lnk).TargetPath
            if ($t -match '\.bat$' -or $t -match 'Demarrer_OptiGame' -or (Test-Path -LiteralPath (Join-Path $dossier 'Lanceur OptiGame.lnk')) -or -not (Test-Path -LiteralPath (Join-Path $dossier 'OptiGame - Lanceur.lnk'))) { [void](Creer-Raccourcis); Write-Log 'Raccourcis mis a jour : OptiGame (direct) et OptiGame - Lanceur.' 'Gray'; return }
        } catch {}
    }
}

function Montrer-Fenetre {
    Apres-Retour
    $f = $UI.Fenetre
    $f.Show()
    if ($f.WindowState -eq 'Minimized') { $f.WindowState = 'Normal' }
    [void]$f.Activate()
    # Passe au premier plan meme si une autre fenetre est devant
    $f.Topmost = $true; $f.Topmost = $false
    [void]$f.Focus()
    Maj-RectProg
}

# Arriere-plan : la fenetre est reduite et RESTE dans la barre des taches (un clic dessus la fait revenir)
function Cacher-Fenetre {
    $f = $UI.Fenetre
    if (-not $f.IsVisible) { $f.ShowActivated = $false; $f.Show() }
    if ($f.WindowState -ne 'Minimized') { $f.WindowState = 'Minimized' }
    Annoncer-ArrierePlan
}
function Annoncer-ArrierePlan {
    Maj-RectProg
    if (-not $script:BulleMontree -and $script:Notif) {
        $script:BulleMontree = $true
        $script:Notif.ShowBalloonTip(5000, 'OptiGame continue en arriere-plan',
            'Detection des jeux et optimisation automatique toujours actives. Clique sur OptiGame dans la barre des taches pour le rouvrir.',
            [Windows.Forms.ToolTipIcon]::Info)
    }
}
# Fenetre vraiment a l'ecran (ni cachee, ni reduite dans la barre des taches)
function Fenetre-Ouverte { return [bool]($UI.Fenetre -and $UI.Fenetre.IsVisible -and $UI.Fenetre.WindowState -ne 'Minimized') }
# Ce qui attendait que la fenetre revienne (nouveautes, question de mise a jour)
function Apres-Retour {
    if ($script:NouvEnAttente) { $UI.Fenetre.Dispatcher.BeginInvoke([Action]{ try { Proposer-Nouveautes } catch {} }, [System.Windows.Threading.DispatcherPriority]::Background) | Out-Null }
    if ($script:QuestionMajEnAttente) { $UI.Fenetre.Dispatcher.BeginInvoke([Action]{ try { Proposer-MajLancement } catch {} }, [System.Windows.Threading.DispatcherPriority]::Background) | Out-Null }
    if (-not $script:DistantQuand -or ((Get-Date) - $script:DistantQuand).TotalMinutes -gt 2) { try { Demarrer-VerifMaj } catch {} }
}

function Notifier([string]$titre, [string]$texte) {
    if ($script:Notif -and -not (Fenetre-Ouverte)) {
        $script:Notif.ShowBalloonTip(4000, $titre, $texte, [Windows.Forms.ToolTipIcon]::Info)
    }
}

$MotifApplisRecherche = '^(Microsoft\.Windows\.Search|MicrosoftWindows\.Client\.CBS|MicrosoftWindows\.Client\.Core|Microsoft\.Windows\.StartMenuExperienceHost|Microsoft\.Windows\.ShellExperienceHost)_'

function Recherche-Cassee {
    $base = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications'
    if ("$(Lire-Reg $base 'GlobalUserDisabled')" -eq '1') { return $true }
    if ("$(Lire-Reg 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Search' 'BackgroundAppGlobalToggle')" -eq '0') { return $true }
    foreach ($k in @(Get-ChildItem $base -ErrorAction SilentlyContinue | Where-Object { $_.PSChildName -match $MotifApplisRecherche })) {
        $p = Get-ItemProperty $k.PSPath -ErrorAction SilentlyContinue
        if ("$($p.Disabled)" -eq '1' -or "$($p.DisabledByUser)" -eq '1') { return $true }
    }
    return $false
}

function Reparer-Recherche([switch]$Force) {
    # Les anciennes versions bloquaient les applis en arriere-plan : Windows a aussi bloque l'appli Recherche elle-meme
    if (-not $Force -and -not (Recherche-Cassee)) { return $false }
    $base = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications'
    $script:Journaliser = $false
    Remove-Reg $base 'GlobalUserDisabled'
    Remove-Reg 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Search' 'BackgroundAppGlobalToggle'
    foreach ($k in @(Get-ChildItem $base -ErrorAction SilentlyContinue | Where-Object { $_.PSChildName -match $MotifApplisRecherche })) {
        Remove-ItemProperty -Path $k.PSPath -Name 'Disabled', 'DisabledByUser' -ErrorAction SilentlyContinue
    }
    $script:Journaliser = $true
    foreach ($p in 'SearchHost', 'SearchApp', 'StartMenuExperienceHost', 'ShellExperienceHost') {
        Get-Process -Name $p -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    }
    Ajouter-Journal 'Recherche Windows' 'Bloquee' 'Reparee'
    Write-Log 'Recherche Windows reparee : elle redemarre toute seule dans quelques secondes.' 'Gold'
    return $true
}

# Anciennes versions : en bloquant les applis en arriere-plan, Windows a aussi bloque l'Outil Capture
# (Win+Maj+S / touche Impr ecran ne faisait plus rien). On le debloque.
function Reparer-Captures([switch]$Force) {
    $base = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications'
    $fait = $false
    if ($Force) {
        # Strategies qui interdisent l'Outil Capture (mises par certains programmes d'optimisation)
        foreach ($k in 'HKCU:\Software\Policies\Microsoft\Windows\TabletPC', 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\TabletPC') {
            if ("$(Lire-Reg $k 'DisableSnippingTool')" -eq '1') { Remove-Reg $k 'DisableSnippingTool'; $fait = $true }
        }
        if ("$(Lire-Reg $base 'GlobalUserDisabled')" -eq '1') { Remove-Reg $base 'GlobalUserDisabled'; $fait = $true }
    }
    foreach ($k in @(Get-ChildItem $base -ErrorAction SilentlyContinue | Where-Object { $_.PSChildName -match '^(Microsoft\.ScreenSketch|Microsoft\.Windows\.Photos|MicrosoftWindows\.Client\.CBS|Microsoft\.WindowsNotepad)_' })) {
        $p = Get-ItemProperty $k.PSPath -ErrorAction SilentlyContinue
        if ("$($p.Disabled)" -eq '1' -or "$($p.DisabledByUser)" -eq '1') {
            Remove-ItemProperty -Path $k.PSPath -Name 'Disabled', 'DisabledByUser' -ErrorAction SilentlyContinue
            $fait = $true
        }
    }
    if ($fait -or $Force) {
        foreach ($n in 'ScreenSketch', 'SnippingTool', 'ScreenClippingHost') { Get-Process -Name $n -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue }
        if ($fait) { Ajouter-Journal 'Outil Capture d''ecran' 'Bloque' 'Repare' 'Win+Maj+S et la touche Impr ecran remarchent.' }
        Write-Log 'Captures d''ecran reparees (Outil Capture debloque et redemarre).' 'Gold'
    }
    return $fait
}

# Bouton de l'Accueil : repare, verifie que l'Outil Capture est installe, puis ouvre une capture pour tester
function Reparer-CapturesBouton {
    $script:SourceAction = 'Bouton Reparer les captures (Accueil)'
    try { [void](Reparer-Captures -Force) } catch {}
    $script:SourceAction = $null
    $installe = $true
    try { $installe = [bool](Get-AppxPackage -Name 'Microsoft.ScreenSketch' -ErrorAction Stop) } catch {}
    if (-not $installe) {
        if (Ask-YesNo "L'Outil Capture de Windows n'est pas installe sur ce PC : c'est pour ca que Win+Maj+S ne fait rien.`r`n`r`nOuvrir le Microsoft Store pour le reinstaller (gratuit) ?") { Start-Process 'ms-windows-store://pdp/?productid=9MZ95KL8MR0L' }
        return
    }
    Start-Sleep -Milliseconds 800
    try { Start-Process 'ms-screenclip:' } catch {}
    Show-Info "Outil Capture repare : une capture vient de s'ouvrir pour tester (selectionne une zone, elle est copiee, colle-la avec Ctrl+V).`r`n`r`nRaccourcis :`r`n- Win+Maj+S : capturer une zone`r`n- Impr ecran : capture (si active dans Parametres > Accessibilite > Clavier)`r`n- Win+Impr ecran : tout l'ecran, enregistre dans Images\Captures d'ecran`r`n`r`nWin+Alt+Impr ecran (capture Xbox / Game Bar) reste coupe par OptiGame : il enregistre en continu et coute des FPS." 'Captures d''ecran'
}

# ---------------------------------------------------------------------
#  ACTIONS DES PAGES
# ---------------------------------------------------------------------
# ---------------------------------------------------------------------
#  LIBERER LA MEMOIRE (comme Mem Reduct, sans toucher au jeu en cours)
# ---------------------------------------------------------------------
$CodeMemoire = @'
using System;
using System.Diagnostics;
using System.Runtime.InteropServices;

public static class OGMem
{
    [DllImport("psapi.dll")] static extern bool EmptyWorkingSet(IntPtr h);
    [DllImport("ntdll.dll")] static extern int NtSetSystemInformation(int classe, ref int info, int taille);
    [DllImport("advapi32.dll", SetLastError = true)] static extern bool OpenProcessToken(IntPtr h, uint acces, out IntPtr jeton);
    [DllImport("advapi32.dll", SetLastError = true, CharSet = CharSet.Unicode)] static extern bool LookupPrivilegeValue(string sys, string nom, out long luid);
    [DllImport("advapi32.dll", SetLastError = true)] static extern bool AdjustTokenPrivileges(IntPtr jeton, bool toutOff, ref TP nouveau, int taille, IntPtr ancien, IntPtr retour);
    [DllImport("kernel32.dll")] static extern IntPtr GetCurrentProcess();
    [DllImport("kernel32.dll")] static extern bool CloseHandle(IntPtr h);
    [DllImport("user32.dll")] static extern IntPtr GetForegroundWindow();
    [DllImport("user32.dll")] static extern uint GetWindowThreadProcessId(IntPtr h, out uint pid);

    [StructLayout(LayoutKind.Sequential, Pack = 4)]
    struct TP { public int Nombre; public long Luid; public int Attributs; }

    static bool Privilege(string nom)
    {
        IntPtr jeton;
        if (!OpenProcessToken(GetCurrentProcess(), 0x28, out jeton)) return false;
        try
        {
            TP tp = new TP(); tp.Nombre = 1; tp.Attributs = 2;
            if (!LookupPrivilegeValue(null, nom, out tp.Luid)) return false;
            return AdjustTokenPrivileges(jeton, false, ref tp, 0, IntPtr.Zero, IntPtr.Zero);
        }
        finally { CloseHandle(jeton); }
    }

    public static int PidPremierPlan()
    {
        uint p; GetWindowThreadProcessId(GetForegroundWindow(), out p); return (int)p;
    }

    // Vide la memoire de travail des programmes, sauf ceux de la liste (jeu en cours, systeme sensible)
    public static int Alleger(int[] pidsExclus, string[] nomsExclus)
    {
        int n = 0;
        foreach (Process p in Process.GetProcesses())
        {
            try
            {
                if (p.Id <= 4) continue;
                if (Array.IndexOf(pidsExclus, p.Id) >= 0) continue;
                if (Array.IndexOf(nomsExclus, p.ProcessName.ToLowerInvariant()) >= 0) continue;
                if (EmptyWorkingSet(p.Handle)) n++;
            }
            catch { }
            finally { p.Dispose(); }
        }
        return n;
    }

    // Vide la partie "basse priorite" du cache memoire de Windows
    public static int ViderCache()
    {
        Privilege("SeProfileSingleProcessPrivilege");
        int commande = 5;  // MemoryPurgeLowPriorityStandbyList
        return NtSetSystemInformation(80, ref commande, 4);
    }
}
'@

$ProcessusSensibles = @('dwm', 'audiodg', 'csrss', 'wininit', 'winlogon', 'lsass', 'services', 'smss', 'system', 'registry', 'memory compression', 'fontdrvhost')

function Etat-Memoire {
    $os = Get-CimInstance Win32_OperatingSystem
    $dispo = [double](Get-CimInstance Win32_PerfFormattedData_PerfOS_Memory).AvailableMBytes * 1MB
    $total = [double]$os.TotalVisibleMemorySize * 1KB
    return [pscustomobject]@{ Total = $total; Dispo = $dispo; Pct = [math]::Round(100.0 * ($total - $dispo) / $total) }
}

function Gros-Consommateurs([int]$nb = 6) {
    $groupes = Get-Process -ErrorAction SilentlyContinue | Group-Object ProcessName | ForEach-Object {
        $desc = ($_.Group | ForEach-Object { $_.Description } | Where-Object { $_ } | Select-Object -First 1)
        [pscustomobject]@{ Nom = $(if ($desc) { $desc } else { $_.Name }); Process = $_.Name
                           Go = (($_.Group | Measure-Object WorkingSet64 -Sum).Sum / 1GB) }
    }
    return @($groupes | Sort-Object Go -Descending | Select-Object -First $nb)
}

function Etape-Memoire {
    Charger-Type 'OGMem' $CodeMemoire
    $avant = Etat-Memoire
    Write-Log ('[1/3] Memoire utilisee au depart : {0} % ({1:N1} Go libres sur {2:N0} Go)' -f $avant.Pct, ($avant.Dispo / 1GB), ($avant.Total / 1GB))
    try { Fermer-RobloxEnFond } catch {}
    Write-Log '[2/3] Allegement des applis en arriere-plan (le jeu en cours n''est pas touche)...'
    $exclus = @([OGMem]::PidPremierPlan(), $PID)
    foreach ($k in $script:JeuxActifs.Keys) { $exclus += [int]$script:JeuxActifs[$k].Pid }
    $n = [OGMem]::Alleger([int[]]$exclus, [string[]]$ProcessusSensibles)
    Write-Log "   $n programmes alleges." 'Gray'
    Write-Log '[3/3] Vidage du cache memoire de faible priorite...'
    [void][OGMem]::ViderCache()
    Start-Sleep -Milliseconds 800
    $apres = Etat-Memoire
    $libere = [math]::Max(0.0, ($apres.Dispo - $avant.Dispo) / 1GB)
    Write-Log ('   Memoire utilisee : {0} % {1} {2} % ({3:N1} Go liberes)' -f $avant.Pct, $Fleche, $apres.Pct, $libere) 'Gold'
    $script:ResultatMemoire = [pscustomobject]@{ Avant = $avant.Pct; Apres = $apres.Pct; Libere = $libere; Top = (Gros-Consommateurs 6) }
}

function Liberer-Memoire {
    Invoke-Action 'Liberation de la memoire' { Etape-Memoire }
    $r = $script:ResultatMemoire
    if (-not $r) { return }
    $txt = ('Memoire utilisee : {0} %  {1}  {2} %   ({3:N1} Go liberes)' -f $r.Avant, $Fleche, $r.Apres, $r.Libere)
    $txt += "`r`n`r`nCe qui prend le plus de memoire maintenant :"
    foreach ($t in $r.Top) { $txt += ("`r`n   {0,-28} {1:N1} Go" -f $t.Nom, $t.Go) }
    $jeuxLourds = @($r.Top | Where-Object { $_.Go -ge 5 -and ($script:JeuxActifs.Values | ForEach-Object { $_.Exe -replace '\.exe$', '' }) -contains $_.Process })
    foreach ($j in $jeuxLourds) {
        $txt += ("`r`n`r`n{0} utilise {1:N1} Go a lui seul. C'est beaucoup : sa memoire grossit au fil de la partie. Le relancer de temps en temps la libere (OptiGame ne vide jamais la memoire d'un jeu en cours, ca le ferait saccader)." -f $j.Nom, $j.Go)
    }
    $txt += "`r`n`r`nAstuce : ferme les applis lourdes dont tu n'as pas besoin pendant que tu joues (navigateur, Discord en video...)."
    [void](Show-Dialogue $txt 'Memoire liberee' 'succes')
    Maj-StatsDirect
}

$ActionsOptim = @(
    @{ Id = 'perf'; Ic = 0xE945; Coul = '#00D46A'; Titre = 'Optimiser les performances'; Desc = 'Alimentation max, Mode Jeu, planification GPU, Game DVR coupe, effets visuels, priorite aux jeux.'; Bouton = 'Optimiser' }
    @{ Id = 'memoire'; Ic = 0xE964; Coul = '#00D46A'; Titre = 'Liberer la memoire'; Desc = 'Allege les applis en arriere-plan et vide le cache, sans toucher au jeu en cours. Comme Mem Reduct.'; Bouton = 'Liberer' }
    @{ Id = 'nettoyage'; Ic = 0xE74D; Coul = '#00B2D6'; Titre = 'Nettoyage'; Desc = 'Fichiers temporaires, caches des shaders AMD et NVIDIA, corbeille, cache de Windows Update.'; Bouton = 'Nettoyer' }
    @{ Id = 'boost'; Ic = 0xE7FC; Coul = '#00D46A'; Titre = 'Mode Boost'; Desc = 'Ferme OneDrive, Teams, Widgets et les autres applis inutiles. A lancer juste avant de jouer.'; Bouton = 'Booster' }
    @{ Id = 'connexion'; Ic = 0xE839; Coul = '#8AB4FF'; Titre = 'Optimiser la connexion'; Desc = 'Limitation reseau de Windows retiree, latence TCP reduite, economie d''energie Ethernet coupee.'; Bouton = 'Optimiser' }
    @{ Id = 'dns'; Ic = 0xE895; Coul = '#8AB4FF'; Titre = 'Vider le cache DNS'; Desc = 'Rapide et sans risque. Utile si un site ou un serveur de jeu ne repond plus.'; Bouton = 'Vider' }
    @{ Id = 'repconnexion'; Ic = 0xE90F; Coul = '#FFC24B'; Titre = 'Reparer la connexion'; Desc = 'Si internet bug : reinitialise Winsock et la pile IP. Coupure de quelques secondes.'; Bouton = 'Reparer' }
    @{ Id = 'recherche'; Ic = 0xE721; Coul = '#FFC24B'; Titre = 'Reparer la recherche Windows'; Desc = 'Si la recherche du menu Demarrer s''affiche vide. Debloque l''appli Recherche et la relance.'; Bouton = 'Reparer' }
    @{ Id = 'repwin'; Ic = 0xE90F; Coul = '#FFC24B'; Titre = 'Reparation de Windows'; Desc = 'DISM + SFC + verification du disque. Compte 10 a 30 minutes.'; Bouton = 'Reparer' }
    @{ Id = 'diag'; Ic = 0xE9F9; Coul = '#8AB4FF'; Titre = 'Diagnostic'; Desc = 'Rapport complet sur le Bureau : disques, RAM, carte graphique, ping, erreurs recentes.'; Bouton = 'Generer' }
    @{ Id = 'annuler'; Ic = 0xE7A7; Coul = '#FF5468'; Titre = 'Annuler les optimisations'; Desc = 'Remet les reglages Windows par defaut (performances et connexion).'; Bouton = 'Tout annuler'; Danger = $true }
)

function Items-ActionsOptim {
    $items = @()
    foreach ($a in $ActionsOptim) {
        $coul = $a.Coul
        $danger = [bool]$a.Danger
        $items += [pscustomobject]@{
            Id = $a.Id; Icone = [string][char]$a.Ic; CouleurIcone = $coul; FondIcone = ('#22' + $coul.Substring(1))
            Titre = $a.Titre; Desc = $a.Desc; Bouton = $a.Bouton
            FondBouton = $(if ($danger) { '#2A151A' } else { '#1E2430' })
            TexteBouton = $(if ($danger) { '#FF8A97' } else { '#E9ECF2' })
            BordBouton = $(if ($danger) { '#55232E' } else { '#2A3140' })
        }
    }
    return $items
}

function Executer-Action([string]$id) {
    if ($script:Busy) { return }
    switch ($id) {
        'tout' {
            if (-not (Ask-YesNo "L'optimisation complete dure 30 a 45 minutes.`r`nTu peux reduire OptiGame pendant ce temps, mais ne le ferme pas.`r`n`r`nLa corbeille sera videe definitivement.`r`n`r`nOn y va ?")) { return }
            Invoke-Action 'Optimisation complete' {
                Write-Log '##### 1/6 PREPARATION #####' 'White';        Etape-PointRestauration -Force
                Write-Log '##### 2/6 REPARATION #####' 'White';         Etape-Reparation
                Write-Log '##### 3/6 PERFORMANCE #####' 'White';        Etape-Performance
                Write-Log '##### 4/6 CONNEXION #####' 'White';          Etape-Connexion
                Write-Log '##### 5/6 NETTOYAGE #####' 'White';          Etape-Nettoyage
                Write-Log '##### 6/6 DIAGNOSTIC ET BOOST #####' 'White'; Etape-Diagnostic; Etape-Boost
                Write-Log 'Les jeux recompileront leurs shaders au 1er lancement (une seule fois).' 'Gold'
            }
            Actualiser-Infos
            Ask-Reboot
        }
        'perf'      { Invoke-Action 'Optimisation des performances' { Etape-PointRestauration; Etape-Performance }; Actualiser-Infos; Ask-Reboot }
        'nettoyage' {
            if (-not (Ask-YesNo 'La corbeille sera videe definitivement. Continuer ?')) { return }
            Invoke-Action 'Nettoyage' { Etape-Nettoyage }
        }
        'boost'     { Invoke-Action 'Mode Boost' { Etape-Boost } }
        'memoire'   { Liberer-Memoire }
        'connexion' { Invoke-Action 'Optimisation de la connexion' { Etape-PointRestauration; Etape-Connexion }; Actualiser-Infos; Ask-Reboot }
        'dns'       { Invoke-Action 'Vidage du cache DNS' { Write-Log 'Vidage du cache DNS...'; Run-Ext 'ipconfig.exe' '/flushdns' | Out-Null } }
        'repconnexion' {
            if (-not (Ask-YesNo "A utiliser seulement si la connexion pose probleme.`r`nInternet sera coupe quelques secondes.`r`n`r`nContinuer ?")) { return }
            Invoke-Action 'Reparation de la connexion' { Etape-ReparerConnexion }
            Ask-Reboot
        }
        'repwin'    { Invoke-Action 'Reparation de Windows' { Etape-Reparation }; Ask-Reboot }
        'recherche' { Invoke-Action 'Reparation de la recherche Windows' { [void](Reparer-Recherche -Force) }; Actualiser-Infos }
        'diag'      { Invoke-Action 'Diagnostic' { Etape-Diagnostic } }
        'annuler'   {
            if (-not (Ask-YesNo 'Remettre tous les reglages Windows par defaut ?')) { return }
            Invoke-Action 'Annulation des optimisations' { Etape-Restaurer }
            Actualiser-Infos
            Ask-Reboot
        }
    }
}

$Pages = [ordered]@{
    NavAccueil = 'PageAccueil'; NavOptim = 'PageOptim'; NavJeux = 'PageJeux'; NavTest = 'PageTest'; NavInfos = 'PageInfos'
    NavConseils = 'PageConseils'; NavHisto = 'PageHisto'; NavJournal = 'PageJournal'; NavErreurs = 'PageErreurs'; NavVersions = 'PageVersions'; NavAntivirus = 'PageAntivirus'; NavSpicetify = 'PageSpicetify'; NavApparence = 'PageApparence'; NavOled = 'PageOled'; NavSpeed = 'PageSpeed'
}

function Show-Page([string]$page) {
    foreach ($p in $Pages.Values) { if ($p -ne $page -and $UI[$p]) { $UI[$p].Visibility = 'Collapsed' } }
    $el = $UI[$page]
    if (-not $el) { return }
    $el.Visibility = 'Visible'
    $tt = New-Object System.Windows.Media.TranslateTransform(0, 16)
    $el.RenderTransform = $tt
    Animer $el ([System.Windows.UIElement]::OpacityProperty) 1 260 0
    Animer $tt ([System.Windows.Media.TranslateTransform]::YProperty) 0 380 16
    $script:PageActive = $page
    if ($page -eq 'PageJournal' -and $script:LignesJournal.Count) { $UI.ListeJournal.ScrollIntoView($script:LignesJournal[$script:LignesJournal.Count - 1]) }
    if ($page -eq 'PageAccueil') { Maj-StatsDirect }
    if ($page -eq 'PageVersions') { Remplir-Versions; try { Maj-ZoneMaj } catch {} }
    if ($page -eq 'PageAntivirus') { try { Maj-PageAntivirus } catch {} }
    if ($page -eq 'PageSpicetify') { try { Maj-PageSpicetify } catch {} }
    if ($page -eq 'PageApparence') { try { Maj-PageApparence } catch {} }
    if ($page -eq 'PageOled') { try { Maj-PageEcran } catch {} }
    if ($page -eq 'PageSpeed') { try { Maj-PageSpeed } catch {} }
    if ($script:MapVivant -and $script:MapVivant.Count) { try { Repeindre $el $script:MapVivant } catch {} }
    if ($page -eq 'PageJeux') { try { Garantir-ReglagesJeux -Discret } catch {} }
}

function Aller-A([string]$nav) { $UI[$nav].IsChecked = $true }

# ---------------------------------------------------------------------
#  CONSTRUCTION DE LA FENETRE
# ---------------------------------------------------------------------
function Relancer-OptiGame {
    if ($script:TestEnCours) { Show-Info 'Un test de performance est en cours : arrete-le avant de relancer OptiGame.'; return }
    if ($script:Busy -and -not (Ask-YesNo "Une action est en cours.`r`nRelancer quand meme OptiGame ?")) { return }
    if (-not $script:Busy -and -not (Ask-YesNo "Relancer OptiGame v$VersionApp ?`r`nUtile en cas de bug : la fenetre se ferme et se rouvre. Tes reglages sont conserves.")) { return }
    # La version actuelle devient la version active, pour rouvrir exactement celle-ci
    $nom = [IO.Path]::GetFileName($PSCommandPath)
    if ($nom -match '^OptiGame_v\d+(\.\d+)*\.ps1$') {
        try { $e = Lire-EtatVersions; Sauver-EtatVersions $nom (@($e.Vues) + @(Lister-Versions | ForEach-Object { $_.Name })) } catch {}
    }
    $script:Relance = $PSCommandPath
    $script:ForcerFermeture = $true
    $UI.Fenetre.Close()
}

# =====================================================================
#  ANTIVIRUS (Microsoft Defender, integre a Windows)
# =====================================================================
function Info-Av([string]$t, [string]$type = 'info') { [void](Show-Dialogue $t 'Antivirus' $type) }

function Etat-Antivirus {
    if ($script:CacheAv -and ((Get-Date) - $script:CacheAvQuand).TotalSeconds -lt 60) { return $script:CacheAv }
    $script:CacheAv = Etat-AntivirusDirect
    $script:CacheAvQuand = Get-Date
    return $script:CacheAv
}
function Etat-AntivirusDirect {
    $r = [ordered]@{ Defender = $false; Tiers = @(); Mode = ''; TempsReel = $false; Actif = $false
        SigDate = $null; SigAge = $null; SigVersion = ''; Rapide = $null; Complete = $null
        Falsification = $null; Pua = $null; Cloud = $null; Erreur = '' }
    try {
        foreach ($p in @(Get-CimInstance -Namespace 'root/SecurityCenter2' -ClassName AntiVirusProduct -ErrorAction Stop)) {
            if ("$($p.displayName)" -notmatch 'Defender') { $r.Tiers += "$($p.displayName)" }
        }
    } catch {}
    try {
        $s = Get-MpComputerStatus -ErrorAction Stop
        $r.Defender = $true
        $r.Mode = "$($s.AMRunningMode)"
        $r.TempsReel = [bool]$s.RealTimeProtectionEnabled
        $r.Actif = [bool]$s.AntivirusEnabled
        $r.SigDate = $s.AntivirusSignatureLastUpdated
        $r.SigAge = $s.AntivirusSignatureAge
        $r.SigVersion = "$($s.AntivirusSignatureVersion)"
        if ($s.QuickScanEndTime -and $s.QuickScanEndTime.Year -gt 2000) { $r.Rapide = $s.QuickScanEndTime }
        if ($s.FullScanEndTime -and $s.FullScanEndTime.Year -gt 2000) { $r.Complete = $s.FullScanEndTime }
        $r.Falsification = $s.IsTamperProtected
    } catch { $r.Erreur = $_.Exception.Message }
    try {
        $p = Get-MpPreference -ErrorAction Stop
        $r.Pua = ([int]$p.PUAProtection -eq 1)
        $r.Cloud = ([int]$p.MAPSReporting -gt 0)
    } catch {}
    return [pscustomobject]$r
}

function Texte-Depuis($d) {
    if (-not $d) { return 'jamais' }
    $t = (Get-Date) - $d
    if ($t.TotalMinutes -lt 2) { return "a l'instant" }
    if ($t.TotalHours -lt 1) { return "il y a $([int]$t.TotalMinutes) min" }
    if ($t.TotalDays -lt 1) { return "il y a $([int]$t.TotalHours) h" }
    if ($t.TotalDays -lt 2) { return 'hier' }
    return "il y a $([int]$t.TotalDays) jours"
}

$EtatsMenace = @{ 0 = 'Inconnu'; 1 = 'Detectee'; 2 = 'Nettoyee'; 3 = 'En quarantaine'; 4 = 'Supprimee'; 5 = 'Autorisee'; 6 = 'Bloquee'
    102 = 'Quarantaine ratee'; 103 = 'Suppression ratee'; 104 = 'Autorisation ratee'; 105 = 'Abandonnee'; 107 = 'Blocage rate' }

function Lister-Menaces {
    $noms = @{}
    $actives = @{}
    try { foreach ($m in @(Get-MpThreat -ErrorAction Stop)) { $noms["$($m.ThreatID)"] = "$($m.ThreatName)"; if ($m.IsActive) { $actives["$($m.ThreatID)"] = $true } } } catch {}
    $r = @()
    try {
        $dets = @(Get-MpThreatDetection -ErrorAction Stop | Sort-Object InitialDetectionTime -Descending | Select-Object -First 40)
        foreach ($d in $dets) {
            $id = "$($d.ThreatID)"
            $etat = $EtatsMenace[[int]$d.ThreatStatusID]
            if (-not $etat) { $etat = "Etat $($d.ThreatStatusID)" }
            $ok = [int]$d.ThreatStatusID -in 2, 3, 4, 6
            $fichiers = @($d.Resources | ForEach-Object { "$_" -replace '^[a-z]+:_', '' }) -join ', '
            if (-not $fichiers) { $fichiers = 'emplacement inconnu' }
            $quand = if ($d.InitialDetectionTime) { $d.InitialDetectionTime.ToString('dd/MM/yyyy HH:mm') } else { '' }
            $r += [pscustomobject]@{
                Nom = $(if ($noms[$id]) { $noms[$id] } else { "Menace $id" })
                Detail = "$quand  -  $fichiers"
                Etat = $etat
                Active = (-not $ok) -or $actives.ContainsKey($id)
                FondEtat = $(if ($ok) { '#163626' } else { '#3A1A20' })
                CouleurEtat = $(if ($ok) { '#3FE08E' } else { '#FF6B7A' })
                Quand = $d.InitialDetectionTime
            }
        }
    } catch {}
    return @($r)
}

# --- Taches longues (analyses, mise a jour) dans un fil a part : l'interface reste fluide ---
$script:AvTache = $null
function Demarrer-TacheAv([string]$titre, [scriptblock]$code, [object[]]$arguments) {
    if ($script:AvTache) { Info-Av 'Une analyse ou une mise a jour est deja en cours.'; return }
    $ps = [powershell]::Create()
    [void]$ps.AddScript($code)
    foreach ($a in $arguments) { [void]$ps.AddArgument($a) }
    $script:AvTache = @{ PS = $ps; H = $ps.BeginInvoke(); Debut = Get-Date; Titre = $titre }
    Write-Log "Antivirus : $titre..." 'White'
    $UI.TxtAvScan.Text = "$titre en cours..."
    $UI.TxtAvScanSous.Text = 'Tu peux continuer a utiliser ton PC, ou reduire OptiGame : tu seras prevenu a la fin.'
    $UI.BarAvScan.Visibility = 'Visible'
    $UI.BtnAvStop.Visibility = 'Visible'
    Maj-BoutonsAv
    if (-not $script:MinuterieAv) {
        $script:MinuterieAv = New-Object System.Windows.Threading.DispatcherTimer
        $script:MinuterieAv.Interval = [TimeSpan]::FromSeconds(1)
        $script:MinuterieAv.Add_Tick({ Suivre-TacheAv })
    }
    $script:MinuterieAv.Start()
}

function Suivre-TacheAv {
    $t = $script:AvTache
    if (-not $t) { $script:MinuterieAv.Stop(); return }
    $sec = [int]((Get-Date) - $t.Debut).TotalSeconds
    $duree = if ($sec -lt 60) { "$sec s" } else { '{0} min {1:00} s' -f [math]::Floor($sec / 60), ($sec % 60) }
    $UI.TxtAvScan.Text = "$($t.Titre) en cours...  $duree"
    if (-not $t.H.IsCompleted) { return }
    $script:MinuterieAv.Stop()
    $erreur = $null
    try { [void]$t.PS.EndInvoke($t.H) } catch { $erreur = $_.Exception.InnerException; if (-not $erreur) { $erreur = $_.Exception } }
    if (-not $erreur -and $t.PS.Streams.Error.Count) { $erreur = $t.PS.Streams.Error[0].Exception }
    $arrete = $t.Arrete
    try { $t.PS.Dispose() } catch {}
    $script:AvTache = $null
    $UI.BarAvScan.Visibility = 'Collapsed'
    $UI.BtnAvStop.Visibility = 'Collapsed'
    $nouvelles = @(Lister-Menaces | Where-Object { $_.Quand -and $_.Quand -ge $t.Debut.AddSeconds(-5) })
    if ($arrete) {
        $UI.TxtAvScan.Text = "$($t.Titre) arretee au bout de $duree."
        Write-Log "Antivirus : $($t.Titre) arretee." 'Gold'
    } elseif ($erreur) {
        $UI.TxtAvScan.Text = "$($t.Titre) : echec."
        $UI.TxtAvScanSous.Text = "$($erreur.Message)"
        Write-Log "Antivirus : $($t.Titre) a echoue : $($erreur.Message)" 'Tomato'
        Noter-Erreur "Antivirus : $($t.Titre)" "$($erreur.Message)"
    } elseif ($nouvelles.Count) {
        $UI.TxtAvScan.Text = "$($t.Titre) terminee ($duree) : $($nouvelles.Count) menace(s) trouvee(s)."
        $UI.TxtAvScanSous.Text = 'Defender les a bloquees. Detail ci-dessous.'
        Write-Log "Antivirus : $($nouvelles.Count) menace(s) trouvee(s) : $(@($nouvelles | ForEach-Object { $_.Nom }) -join ', ')" 'Tomato'
        try { Afficher-Toast "$($nouvelles.Count) menace(s) trouvee(s) : voir la page Antivirus." 'alerte' } catch {}
        try { Notifier 'OptiGame - Antivirus' "$($nouvelles.Count) menace(s) trouvee(s). Ouvre OptiGame > Antivirus." } catch {}
    } else {
        $fin = if ($t.Titre -match 'jour') { 'Definitions a jour.' } else { 'Aucune menace trouvee.' }
        $UI.TxtAvScan.Text = "$($t.Titre) terminee ($duree). $fin"
        $UI.TxtAvScanSous.Text = 'Ton PC est protege.'
        Write-Log "Antivirus : $($t.Titre) terminee ($duree). $fin" 'LightGreen'
        try { Afficher-Toast "$($t.Titre) terminee : $fin" 'ok' } catch {}
        try { Notifier 'OptiGame - Antivirus' "$($t.Titre) terminee : $fin" } catch {}
    }
    Maj-PageAntivirus
}

function Arreter-TacheAv {
    $t = $script:AvTache
    if (-not $t) { return }
    $t.Arrete = $true
    $UI.TxtAvScan.Text = 'Arret en cours...'
    try { [void]$t.PS.BeginStop($null, $null) } catch {}
}

function Lancer-AnalyseAv([string]$type, [string]$chemin) {
    $e = Etat-Antivirus
    if (-not $e.Defender) { Info-Av "Microsoft Defender n'est pas disponible sur ce PC.$(if ($e.Tiers.Count) { "`r`nTon antivirus actuel : $($e.Tiers -join ', '). Lance l'analyse depuis son application." })" 'alerte'; return }
    $titres = @{ QuickScan = 'Analyse rapide'; FullScan = 'Analyse complete'; CustomScan = 'Analyse personnalisee' }
    $titre = $titres[$type]
    if ($type -eq 'CustomScan') { $titre = "Analyse de $([IO.Path]::GetFileName($chemin.TrimEnd('\')))" }
    Demarrer-TacheAv $titre {
        param($t, $c)
        if ($t -eq 'CustomScan') { Start-MpScan -ScanType CustomScan -ScanPath $c -ErrorAction Stop }
        else { Start-MpScan -ScanType $t -ErrorAction Stop }
    } @($type, $chemin)
}

function Maj-DefinitionsAv {
    $e = Etat-Antivirus
    if (-not $e.Defender) { Info-Av "Microsoft Defender n'est pas disponible sur ce PC." 'alerte'; return }
    Demarrer-TacheAv 'Mise a jour des definitions' { Update-MpSignature -ErrorAction Stop } @()
}

function Renforcer-Antivirus {
    $e = Etat-Antivirus
    if (-not $e.Defender) { Info-Av "Microsoft Defender n'est pas disponible sur ce PC." 'alerte'; return }
    if ($e.Tiers.Count -and $e.Mode -match 'Passive') {
        Info-Av "Ton PC est protege par $($e.Tiers -join ', ') : Defender est en veille, c'est normal.`r`nRegle la protection depuis ton antivirus." 'info'; return
    }
    $txt = "OptiGame va activer :`r`n`r`n- la protection en temps reel (si elle est coupee)`r`n- le blocage des applications indesirables (logiciels publicitaires, faux optimiseurs, mineurs de crypto caches...)`r`n- la protection dans le cloud (nouvelles menaces reconnues en quelques secondes)`r`n`r`nAucun impact sur les FPS en jeu. Continuer ?"
    if (-not (Ask-YesNo $txt)) { return }
    Invoke-Action 'Renforcement de l''antivirus' {
        if (-not $e.TempsReel) {
            try { Set-MpPreference -DisableRealtimeMonitoring $false -ErrorAction Stop; Write-Log '   Protection en temps reel : activee.'; Ajouter-Journal 'Antivirus : temps reel' 'Desactive' 'Active' }
            catch { Write-Log '   Protection en temps reel : Windows refuse (protection contre les falsifications). Active-la dans Securite Windows.' 'Gold' }
        }
        if (-not $e.Pua) {
            Set-MpPreference -PUAProtection Enabled -ErrorAction Stop
            Write-Log '   Blocage des applications indesirables : active.'
            Ajouter-Journal 'Antivirus : applications indesirables' 'Autorisees' 'Bloquees'
        } else { Write-Log '   Blocage des applications indesirables : deja actif.' 'Gray' }
        if (-not $e.Cloud) {
            Set-MpPreference -MAPSReporting Advanced -ErrorAction Stop
            Write-Log '   Protection dans le cloud : activee.'
            Ajouter-Journal 'Antivirus : protection cloud' 'Desactivee' 'Activee'
        } else { Write-Log '   Protection dans le cloud : deja active.' 'Gray' }
    }
    Maj-PageAntivirus
}

function Supprimer-MenacesAv {
    if (-not (Ask-YesNo "Supprimer toutes les menaces encore actives ?`r`nDefender les retire definitivement du PC.")) { return }
    Invoke-Action 'Suppression des menaces' {
        Remove-MpThreat -ErrorAction Stop
        Write-Log '   Menaces actives supprimees.'
    }
    Maj-PageAntivirus
}

function Maj-BoutonsAv {
    $libre = -not $script:AvTache
    foreach ($n in 'BtnAvRapide', 'BtnAvComplete', 'BtnAvDossier', 'BtnAvFichier', 'BtnAvMaj', 'BtnAvRenforcer', 'BtnAvHorsLigne') {
        if ($UI[$n]) { $UI[$n].IsEnabled = $libre -and $script:AvDispo }
    }
}

function Pinceau([string]$c) { return (New-Object System.Windows.Media.BrushConverter).ConvertFromString($c) }

function Maj-PageAntivirus {
    if (-not $UI.TxtAvProtection) { return }
    $vert = '#00D46A'; $or = '#FFC24B'; $rouge = '#FF5468'
    $e = Etat-Antivirus
    $script:AvDispo = $e.Defender
    # Protection
    if ($e.Tiers.Count -and ($e.Mode -match 'Passive' -or -not $e.Defender)) {
        $UI.TxtAvProtection.Text = "Protege par $($e.Tiers[0])"
        $UI.TxtAvProtectionSous.Text = 'Defender est en veille (normal avec un autre antivirus).'
        $UI.PtAvProtection.Fill = Pinceau $vert
    } elseif (-not $e.Defender) {
        $UI.TxtAvProtection.Text = 'Aucun antivirus detecte'
        $UI.TxtAvProtectionSous.Text = 'Ouvre Securite Windows pour activer Microsoft Defender.'
        $UI.PtAvProtection.Fill = Pinceau $rouge
    } elseif ($e.TempsReel -and $e.Actif) {
        $UI.TxtAvProtection.Text = 'Active'
        $UI.TxtAvProtectionSous.Text = "Microsoft Defender surveille ton PC en temps reel.$(if ($e.Falsification) { ' Protege contre les falsifications.' })"
        $UI.PtAvProtection.Fill = Pinceau $vert
    } else {
        $UI.TxtAvProtection.Text = 'Temps reel COUPE'
        $UI.TxtAvProtectionSous.Text = 'Ton PC n''est pas protege en continu. Bouton Renforcer la protection.'
        $UI.PtAvProtection.Fill = Pinceau $rouge
    }
    # Definitions
    if ($e.Defender -and $e.SigDate) {
        $UI.TxtAvDefinitions.Text = "A jour $(Texte-Depuis $e.SigDate)"
        $UI.TxtAvDefinitionsSous.Text = "Version $($e.SigVersion)"
        $age = ((Get-Date) - $e.SigDate).TotalDays
        $UI.PtAvDefinitions.Fill = Pinceau $(if ($age -lt 2) { $vert } elseif ($age -lt 7) { $or } else { $rouge })
        if ($age -ge 2) { $UI.TxtAvDefinitions.Text = "Mises a jour $(Texte-Depuis $e.SigDate)"; $UI.TxtAvDefinitionsSous.Text = "Version $($e.SigVersion) - clique sur Mettre a jour." }
    } else {
        $UI.TxtAvDefinitions.Text = 'Inconnues'; $UI.TxtAvDefinitionsSous.Text = ''; $UI.PtAvDefinitions.Fill = Pinceau '#5E677A'
    }
    # Derniere analyse
    $der = @($e.Rapide, $e.Complete | Where-Object { $_ } | Sort-Object -Descending) | Select-Object -First 1
    if ($der) {
        $UI.TxtAvAnalyse.Text = (Texte-Depuis $der)
        $UI.TxtAvAnalyseSous.Text = "Rapide : $(Texte-Depuis $e.Rapide)   Complete : $(Texte-Depuis $e.Complete)"
        $j = ((Get-Date) - $der).TotalDays
        $UI.PtAvAnalyse.Fill = Pinceau $(if ($j -lt 8) { $vert } elseif ($j -lt 30) { $or } else { $rouge })
    } else {
        $UI.TxtAvAnalyse.Text = 'Jamais'; $UI.TxtAvAnalyseSous.Text = 'Lance une analyse rapide.'; $UI.PtAvAnalyse.Fill = Pinceau $or
    }
    # Protections en plus
    if ($e.Defender) {
        $n = @($e.Pua, $e.Cloud | Where-Object { $_ }).Count
        $UI.TxtAvExtra.Text = "$n / 2 actives"
        $UI.TxtAvExtraSous.Text = "Applications indesirables : $(if ($e.Pua) { 'bloquees' } else { 'autorisees' }). Cloud : $(if ($e.Cloud) { 'actif' } else { 'coupe' })."
        $UI.PtAvExtra.Fill = Pinceau $(if ($n -eq 2) { $vert } else { $or })
    } else { $UI.TxtAvExtra.Text = '-'; $UI.TxtAvExtraSous.Text = ''; $UI.PtAvExtra.Fill = Pinceau '#5E677A' }
    # Menaces
    $m = @(Lister-Menaces)
    $UI.ListeMenaces.ItemsSource = $m
    $UI.TxtAvAucune.Visibility = $(if ($m.Count) { 'Collapsed' } else { 'Visible' })
    $UI.TxtAvMenacesTitre.Text = $(if ($m.Count) { "Menaces detectees ($($m.Count))" } else { 'Menaces detectees' })
    $UI.BtnAvSupprimer.Visibility = $(if (@($m | Where-Object { $_.Active }).Count) { 'Visible' } else { 'Collapsed' })
    Maj-BoutonsAv
}

# =====================================================================
#  SPICETIFY (personnalisation de Spotify)
#  Spicetify refuse de s'installer en administrateur : ses commandes sont lancees
#  dans une fenetre PowerShell normale (sans droits admin), via l'Explorateur Windows.
# =====================================================================
$SpExe = Join-Path $env:LOCALAPPDATA 'spicetify\spicetify.exe'
$SpConfig = Join-Path $env:APPDATA 'spicetify'
$UrlInstallSpicetify = 'https://raw.githubusercontent.com/spicetify/cli/main/install.ps1'
$UrlInstallMarketplace = 'https://raw.githubusercontent.com/spicetify/marketplace/main/resources/install.ps1'
# Telecharge l'installateur officiel dans un fichier, puis le lance (au lieu de l'executer directement depuis Internet)
function Code-Installateur([string]$url, [string]$nom) {
    return @"
`$f = Join-Path `$env:TEMP '$nom'
Write-Host '  Telechargement de l''installateur officiel...' -ForegroundColor Cyan
Invoke-WebRequest -UseBasicParsing -Uri '$url' -OutFile `$f
& `$f
"@
}

function Etat-Spicetify {
    $r = [ordered]@{ SpotifyPC = $false; SpotifyStore = $false; SpotifyVer = ''; Cli = $false; CliVer = ''; Applique = $false; Theme = ''; Market = $false }
    $sp = Join-Path $env:APPDATA 'Spotify\Spotify.exe'
    if (Test-Path -LiteralPath $sp) {
        $r.SpotifyPC = $true
        try { $r.SpotifyVer = (Get-Item -LiteralPath $sp).VersionInfo.ProductVersion } catch {}
    }
    try { if (Get-AppxPackage -Name 'SpotifyAB.SpotifyMusic' -ErrorAction Stop) { $r.SpotifyStore = $true } } catch {}
    if (Test-Path -LiteralPath $SpExe) {
        $r.Cli = $true
        try { $r.CliVer = "$((Get-Item -LiteralPath $SpExe).VersionInfo.ProductVersion)".Trim() } catch {}
        if (-not $r.CliVer) { $r.CliVer = 'installee' }
    }
    $ini = Join-Path $SpConfig 'config-xpui.ini'
    if (Test-Path -LiteralPath $ini) {
        try {
            $r.Applique = [bool]"$(Valeur-Ini $ini 'Backup' 'version')".Trim()
            $r.Theme = "$(Valeur-Ini $ini 'Setting' 'current_theme')".Trim()
        } catch {}
    }
    $r.Market = Test-Path -LiteralPath (Join-Path $SpConfig 'CustomApps\marketplace')
    return [pscustomobject]$r
}

# Ouvre une fenetre PowerShell SANS droits administrateur qui execute $code
function Lancer-CommeUtilisateur([string]$nom, [string]$titre, [string]$code, [switch]$Discret) {
    $d = Join-Path $env:TEMP 'OptiGame'
    New-Item -ItemType Directory -Path $d -Force | Out-Null
    $ps1 = Join-Path $d "$nom.ps1"
    $cmd = Join-Path $d "$nom.cmd"
    $script:SpMarqueur = Join-Path $d "$nom.fini"
    Remove-Item -LiteralPath $script:SpMarqueur -Force -ErrorAction SilentlyContinue
    $contenu = @"
`$Host.UI.RawUI.WindowTitle = 'OptiGame - $titre'
`$ErrorActionPreference = 'Continue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
`$SpExe = Join-Path `$env:LOCALAPPDATA 'spicetify\spicetify.exe'
Write-Host ''
Write-Host '  OptiGame - $titre' -ForegroundColor Green
Write-Host '  ------------------------------------------------------------' -ForegroundColor DarkGray
`$admin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (`$admin) { Write-Host '  Attention : cette fenetre a les droits administrateur. Si Spicetify demande d''annuler, reponds N.' -ForegroundColor Yellow }
Write-Host ''
try {
$code
} catch { Write-Host "  Erreur : `$(`$_.Exception.Message)" -ForegroundColor Red }
'fini' | Out-File -FilePath '$($script:SpMarqueur)' -Encoding ASCII
Write-Host ''
Write-Host '  Termine. Tu peux fermer cette fenetre (OptiGame se met a jour tout seul).' -ForegroundColor Green
$(if ($Discret) { "Start-Sleep -Seconds 4" } else { "Read-Host '  Appuie sur Entree pour fermer'" })
"@
    [IO.File]::WriteAllText($ps1, $contenu, (New-Object Text.UTF8Encoding($true)))
    $lancement = if ($Discret) { "start `"`" /min powershell.exe" } else { 'powershell.exe' }
    [IO.File]::WriteAllText($cmd, "@echo off`r`n$lancement -NoProfile -ExecutionPolicy Bypass -File `"$ps1`"`r`n", [Text.Encoding]::ASCII)
    # L'Explorateur tourne sans droits admin : ce qu'il lance non plus
    Start-Process -FilePath (Join-Path $env:WINDIR 'explorer.exe') -ArgumentList "`"$cmd`""
    Write-Log "Spicetify : $titre (fenetre PowerShell ouverte)." 'White'
    $script:SpDebut = Get-Date
    if (-not $script:MinuterieSp) {
        $script:MinuterieSp = New-Object System.Windows.Threading.DispatcherTimer
        $script:MinuterieSp.Interval = [TimeSpan]::FromSeconds(3)
        $script:MinuterieSp.Add_Tick({
            if ($script:SpMarqueur -and (Test-Path -LiteralPath $script:SpMarqueur)) {
                Remove-Item -LiteralPath $script:SpMarqueur -Force -ErrorAction SilentlyContinue
                $script:MinuterieSp.Stop()
                try { Maj-PageSpicetify } catch {}
                try { Noter-VersionSpotify } catch {}
                try { Afficher-Toast 'Spicetify : termine.' 'ok' } catch {}
                Write-Log 'Spicetify : termine.' 'LightGreen'
            } elseif (((Get-Date) - $script:SpDebut).TotalMinutes -gt 20) { $script:MinuterieSp.Stop() }
        })
    }
    $script:MinuterieSp.Start()
}

function Installer-Spicetify {
    $e = Etat-Spicetify
    if ($e.SpotifyStore -and -not $e.SpotifyPC) {
        if (Ask-YesNo "Tu as la version Microsoft Store de Spotify : Spicetify ne fonctionne pas avec.`r`n`r`nIl faut la desinstaller (Parametres > Applications), puis installer Spotify depuis spotify.com (bouton Installer Spotify).`r`n`r`nOuvrir les Applications Windows maintenant ?") { Start-Process 'ms-settings:appsfeatures' }
        return
    }
    if (-not $e.SpotifyPC) {
        if (Ask-YesNo "Spotify n'est pas installe sur ce PC. Spicetify en a besoin.`r`n`r`nInstaller Spotify d'abord ?") { Installer-Spotify }
        return
    }
    Lancer-CommeUtilisateur 'spicetify_installer' 'Installation de Spicetify' @"
Write-Host '  Ferme Spotify si besoin : il sera relance tout seul.' -ForegroundColor Gray
Write-Host '  A la question Marketplace, tape Y puis Entree pour avoir les themes.' -ForegroundColor Gray
Write-Host ''
$(Code-Installateur $UrlInstallSpicetify 'spicetify-install.ps1')
if (Test-Path `$SpExe) {
    Write-Host ''
    Write-Host '  Application de Spicetify a Spotify...' -ForegroundColor Cyan
    & `$SpExe backup apply
}
"@
}

function Installer-Marketplace {
    if (-not (Etat-Spicetify).Cli) { Show-Info 'Installe d''abord Spicetify.' 'Spicetify'; return }
    Lancer-CommeUtilisateur 'spicetify_marketplace' 'Installation du Marketplace Spicetify' (Code-Installateur $UrlInstallMarketplace 'spicetify-marketplace.ps1')
}

function Reappliquer-Spicetify {
    if (-not (Etat-Spicetify).Cli) { Show-Info 'Spicetify n''est pas installe.' 'Spicetify'; return }
    Lancer-CommeUtilisateur 'spicetify_reappliquer' 'Reapplication de Spicetify' @"
& `$SpExe backup apply
if (`$LASTEXITCODE -ne 0) {
    Write-Host '  Mise a jour de Spicetify...' -ForegroundColor Cyan
    & `$SpExe update
    & `$SpExe restore backup apply
}
"@
}

# Spotify casse (texte bizarre en haut, "Something went wrong") : Spicetify pas adapte a la version de Spotify
function Reparer-Spicetify {
    if (-not (Etat-Spicetify).Cli) { Show-Info 'Spicetify n''est pas installe.' 'Spicetify'; return }
    Lancer-CommeUtilisateur 'spicetify_reparer' 'Reparation de Spotify' @"
Write-Host '  1/4 Fermeture de Spotify...' -ForegroundColor Cyan
Get-Process Spotify -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2
Write-Host '  2/4 Spotify remis d''origine...' -ForegroundColor Cyan
& `$SpExe restore
Write-Host '  3/4 Mise a jour de Spicetify vers la derniere version...' -ForegroundColor Cyan
& `$SpExe update
Write-Host '  4/4 Nouvelle sauvegarde et application...' -ForegroundColor Cyan
& `$SpExe backup apply
if (`$LASTEXITCODE -ne 0) {
    Write-Host ''
    Write-Host '  Spicetify ne gere pas encore ta version de Spotify.' -ForegroundColor Yellow
    Write-Host '  Spotify est remis normal en attendant. Reessaie dans quelques jours avec Reappliquer.' -ForegroundColor Yellow
    & `$SpExe restore
} else {
    Write-Host ''
    Write-Host '  Si Spotify affiche encore Something went wrong : clique Remettre Spotify normal dans OptiGame,' -ForegroundColor Gray
    Write-Host '  puis reessaie dans quelques jours (Spicetify sort souvent une mise a jour apres celles de Spotify).' -ForegroundColor Gray
}
"@
}

function Origine-Spotify {
    if (-not (Etat-Spicetify).Cli) { Show-Info 'Spicetify n''est pas installe.' 'Spicetify'; return }
    Lancer-CommeUtilisateur 'spicetify_origine' 'Spotify remis normal' @"
Get-Process Spotify -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2
& `$SpExe restore
Write-Host '  Spotify est remis normal. Spicetify et tes themes sont gardes : Reappliquer pour les remettre.' -ForegroundColor Green
"@
}

function Installer-Spotify {
    Lancer-CommeUtilisateur 'spotify_installer' 'Installation de Spotify' @"
if (Get-Command winget -ErrorAction SilentlyContinue) {
    winget install --id Spotify.Spotify -e --accept-source-agreements --accept-package-agreements
} else {
    Write-Host '  winget absent : ouverture de la page de telechargement de Spotify.' -ForegroundColor Yellow
    Start-Process 'https://www.spotify.com/fr/download/windows/'
}
"@
}

function Desinstaller-Spicetify {
    $e = Etat-Spicetify
    if (-not $e.Cli -and -not (Test-Path -LiteralPath $SpConfig)) { Show-Info 'Spicetify n''est pas installe.' 'Spicetify'; return }
    if (-not (Ask-YesNo "Desinstaller Spicetify ?`r`n`r`nSpotify sera remis d'origine, puis Spicetify, ses themes et le Marketplace seront supprimes. Spotify reste installe.")) { return }
    Lancer-CommeUtilisateur 'spicetify_desinstaller' 'Desinstallation de Spicetify' @"
if (Test-Path `$SpExe) {
    Write-Host '  Remise de Spotify d''origine (spicetify restore)...' -ForegroundColor Cyan
    & `$SpExe restore
}
Write-Host '  Suppression des fichiers de Spicetify...' -ForegroundColor Cyan
Remove-Item -Recurse -Force (Join-Path `$env:APPDATA 'spicetify') -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force (Join-Path `$env:LOCALAPPDATA 'spicetify') -ErrorAction SilentlyContinue
`$p = [Environment]::GetEnvironmentVariable('PATH', 'User')
if (`$p) {
    `$n = (@(`$p -split ';' | Where-Object { `$_ -and `$_ -notmatch '\\spicetify\\?$' }) -join ';')
    if (`$n -ne `$p) { [Environment]::SetEnvironmentVariable('PATH', `$n, 'User'); Write-Host '  Spicetify retire du PATH.' -ForegroundColor Gray }
}
Write-Host '  Spicetify est desinstalle.' -ForegroundColor Green
"@
}

function Maj-PageSpicetify {
    if (-not $UI.TxtSpSpotify) { return }
    $vert = '#00D46A'; $or = '#FFC24B'; $rouge = '#FF5468'; $gris = '#5E677A'
    $e = Etat-Spicetify
    if ($e.SpotifyPC) {
        $UI.TxtSpSpotify.Text = 'Installe'
        $UI.TxtSpSpotifySous.Text = "Version spotify.com $($e.SpotifyVer)$(if ($e.SpotifyStore) { ' (la version Store est aussi la : utilise celle-ci)' })"
        $UI.PtSpSpotify.Fill = Pinceau $vert
    } elseif ($e.SpotifyStore) {
        $UI.TxtSpSpotify.Text = 'Version Microsoft Store'
        $UI.TxtSpSpotifySous.Text = 'Pas compatible : desinstalle-la et installe celle de spotify.com.'
        $UI.PtSpSpotify.Fill = Pinceau $rouge
    } else {
        $UI.TxtSpSpotify.Text = 'Pas installe'
        $UI.TxtSpSpotifySous.Text = 'Bouton Installer Spotify.'
        $UI.PtSpSpotify.Fill = Pinceau $or
    }
    if ($e.Cli) {
        $UI.TxtSpCli.Text = $(if ($e.Applique) { 'Installe et applique' } else { 'Installe, pas applique' })
        $UI.TxtSpCliSous.Text = "Version $($e.CliVer)$(if ($e.Theme) { " - theme : $($e.Theme)" })"
        $UI.PtSpCli.Fill = Pinceau $(if ($e.Applique) { $vert } else { $or })
    } else {
        $UI.TxtSpCli.Text = 'Pas installe'
        $UI.TxtSpCliSous.Text = 'Bouton Installer Spicetify.'
        $UI.PtSpCli.Fill = Pinceau $gris
    }
    if ($e.Market) {
        $UI.TxtSpMarket.Text = 'Installe'
        $UI.TxtSpMarketSous.Text = 'Icone panier en haut a gauche dans Spotify.'
        $UI.PtSpMarket.Fill = Pinceau $vert
    } else {
        $UI.TxtSpMarket.Text = 'Pas installe'
        $UI.TxtSpMarketSous.Text = 'Il donne acces aux themes et fonds customs.'
        $UI.PtSpMarket.Fill = Pinceau $gris
    }
    $UI.BtnSpMarket.IsEnabled = $e.Cli
    $UI.BtnSpReappliquer.IsEnabled = $e.Cli
    $UI.BtnSpReparer.IsEnabled = $e.Cli
    $UI.BtnSpOrigine.IsEnabled = $e.Cli
    $UI.BtnSpThemes.IsEnabled = (Test-Path -LiteralPath $SpConfig)
    $UI.BtnSpDesinstaller.IsEnabled = ($e.Cli -or (Test-Path -LiteralPath $SpConfig))
}

# =====================================================================
#  TIMER RESOLUTION (comme l'outil "Set Timer Resolution", bouton Maximum)
# =====================================================================
$CodeTimer = @'
using System;
using System.Runtime.InteropServices;
public static class OGTimer
{
    [DllImport("ntdll.dll")] static extern int NtSetTimerResolution(uint desired, bool set, out uint current);
    [DllImport("ntdll.dll")] static extern int NtQueryTimerResolution(out uint minimum, out uint maximum, out uint current);
    // Renvoie en millisecondes : plage la plus large (15,625), la plus fine (0,5), actuelle
    public static double[] Info()
    {
        uint a, b, c;
        NtQueryTimerResolution(out a, out b, out c);
        return new double[] { a / 10000.0, b / 10000.0, c / 10000.0 };
    }
    public static double Regler(bool maximum)
    {
        uint a, b, c, r;
        NtQueryTimerResolution(out a, out b, out c);
        NtSetTimerResolution(b, maximum, out r);
        return r / 10000.0;
    }
}
'@
$FichierTimerAuto = Join-Path $env:ProgramData 'OptiGame\timer_auto.txt'
$CleKernel = 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\kernel'
$script:TimerActif = $false

function Charger-Timer { Charger-Type 'OGTimer' $CodeTimer }
function Timer-AutoActif { return ((Test-Path $FichierTimerAuto) -and ((Get-Content $FichierTimerAuto -Raw -ErrorAction SilentlyContinue) -match '1')) }

# Windows 11 : sans ce reglage, le timer d'une appli ne s'applique pas aux autres (donc pas aux jeux)
function Assurer-TimerGlobal {
    if ([Environment]::OSVersion.Version.Build -lt 22000) { return }
    if ("$(Lire-Reg $CleKernel 'GlobalTimerResolutionRequests')" -eq '1') { return }
    Set-Reg $CleKernel 'GlobalTimerResolutionRequests' 1 'DWord'
    try { New-Item -ItemType Directory -Path $DossierData -Force | Out-Null; (Get-Date).ToString('yyyy-MM-dd HH:mm:ss') | Out-File (Join-Path $DossierData 'timer_global_quand.txt') -Encoding ASCII } catch {}
    $script:SourceAction = 'Bouton Maximum ou interrupteur Timer Resolution (Accueil)'
    Ajouter-Journal 'Timer Resolution : appliquee a tout le PC' 'Desactive' 'Active'
    $script:SourceAction = $null
    Write-Log 'Timer Resolution : reglage Windows 11 active (s''applique a tous les jeux apres un redemarrage).' 'Gold'
    $drapeau = Join-Path $DossierData 'timer_global_info.txt'
    if (-not (Test-Path $drapeau)) {
        New-Item -ItemType Directory -Path $DossierData -Force | Out-Null
        'ok' | Out-File $drapeau -Encoding ASCII
        try { Afficher-Toast 'Timer au maximum : redemarre le PC une fois pour qu''il marche aussi dans les jeux.' 'info' } catch {}
    }
}

# =====================================================================
#  TIMER RESOLUTION PERMANENT : un petit programme invisible garde le timer au maximum,
#  meme quand OptiGame est ferme, des l'ouverture de ta session Windows.
# =====================================================================
$NomTacheTimer = 'OptiGame - Timer Resolution'
$ScriptTimer = Join-Path $env:ProgramData 'OptiGame\timer_resolution.ps1'
function Ecrire-ScriptTimer {
    $code = @'
# Garde le Timer Resolution de Windows au maximum (cree par OptiGame)
$cree = $false
$verrou = New-Object System.Threading.Mutex($false, 'Global\OptiGame_Timer', [ref]$cree)
if (-not $cree) { exit }
$arret = New-Object System.Threading.EventWaitHandle($false, [System.Threading.EventResetMode]::ManualReset, 'Global\OptiGame_TimerStop')
[void]$arret.Reset()
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public static class OGTimerFond
{
    [DllImport("ntdll.dll")] static extern int NtSetTimerResolution(uint desired, bool set, out uint current);
    [DllImport("ntdll.dll")] static extern int NtQueryTimerResolution(out uint minimum, out uint maximum, out uint current);
    public static void Maximum() { uint a, b, c, r; NtQueryTimerResolution(out a, out b, out c); NtSetTimerResolution(b, true, out r); }
}
"@
while ($true) {
    [OGTimerFond]::Maximum()
    if ($arret.WaitOne(30000)) { break }
}
'@
    New-Item -ItemType Directory -Path (Split-Path $ScriptTimer) -Force | Out-Null
    [IO.File]::WriteAllText($ScriptTimer, $code, (New-Object Text.UTF8Encoding($true)))
}
function TimerFond-Actif {
    $m = $null
    try { $ok = [System.Threading.Mutex]::TryOpenExisting('Global\OptiGame_Timer', [ref]$m); if ($m) { $m.Dispose() }; return $ok } catch { return $false }
}
function Demarrer-TimerFond {
    Ecrire-ScriptTimer
    $u = "$env:USERDOMAIN\$env:USERNAME"
    $arg = "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$ScriptTimer`""
    $act = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument $arg
    $trg = New-ScheduledTaskTrigger -AtLogOn -User $u
    $prn = New-ScheduledTaskPrincipal -UserId $u -LogonType Interactive -RunLevel Highest
    $set = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -ExecutionTimeLimit ([TimeSpan]::Zero) -MultipleInstances IgnoreNew
    Register-ScheduledTask -TaskName $NomTacheTimer -Action $act -Trigger $trg -Principal $prn -Settings $set -Force | Out-Null
    if (-not (TimerFond-Actif)) { Start-ScheduledTask -TaskName $NomTacheTimer -ErrorAction SilentlyContinue }
}
function Arreter-TimerFond {
    Unregister-ScheduledTask -TaskName $NomTacheTimer -Confirm:$false -ErrorAction SilentlyContinue
    try { $ev = New-Object System.Threading.EventWaitHandle($false, [System.Threading.EventResetMode]::ManualReset, 'Global\OptiGame_TimerStop'); [void]$ev.Set(); Start-Sleep -Milliseconds 300; $ev.Dispose() } catch {}
}
# Le reglage Windows 11 n'agit qu'apres un redemarrage : on retient quand il a ete active
function Timer-RedemarrageNecessaire {
    if ([Environment]::OSVersion.Version.Build -lt 22000) { return $false }
    if ("$(Lire-Reg $CleKernel 'GlobalTimerResolutionRequests')" -ne '1') { return $true }
    $f = Join-Path $DossierData 'timer_global_quand.txt'
    if (-not (Test-Path $f)) { return $false }
    try {
        $quand = [datetime]::ParseExact("$(Get-Content $f -Raw)".Trim(), 'yyyy-MM-dd HH:mm:ss', $null)
        $boot = (Get-CimInstance Win32_OperatingSystem -ErrorAction Stop).LastBootUpTime
        return ($boot -lt $quand)
    } catch { return $false }
}

# ---------- Verification reelle ----------
# Un programme a part (comme un jeu, qui ne demande rien lui-meme) mesure combien dure une pause de 1 ms.
# Timer a 0,5 ms : la pause dure environ 1 a 1,5 ms. Timer a 1 ms : environ 2 ms. Timer pas actif : environ 15,6 ms.
function Tester-TimerReel {
    if ($script:TestTimer) { return }
    $d = Join-Path $env:TEMP 'OptiGame'
    New-Item -ItemType Directory -Path $d -Force | Out-Null
    $sortie = Join-Path $d 'test_timer.txt'
    $script = Join-Path $d 'test_timer.ps1'
    Remove-Item -LiteralPath $sortie -Force -ErrorAction SilentlyContinue
    $code = @'
param([string]$Sortie)
$t = [Diagnostics.Stopwatch]::StartNew()
for ($i = 0; $i -lt 200; $i++) { [Threading.Thread]::Sleep(1) }
$t.Stop()
($t.Elapsed.TotalMilliseconds / 200).ToString([Globalization.CultureInfo]::InvariantCulture) | Out-File -FilePath $Sortie -Encoding ASCII
'@
    [IO.File]::WriteAllText($script, $code, (New-Object Text.UTF8Encoding($true)))
    $p = Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$script`" -Sortie `"$sortie`"" -WindowStyle Hidden -PassThru
    $script:TestTimer = @{ P = $p; F = $sortie; Debut = Get-Date }
    $UI.CadreTrTest.Visibility = 'Visible'
    $UI.TxtTrTestTitre.Text = 'Mesure en cours...'
    $UI.TxtTrTestTitre.Foreground = Pinceau '#E9ECF2'
    $UI.TxtTrTestDetail.Text = 'Un petit programme a part fait 200 pauses de 1 ms, comme un jeu. Quelques secondes.'
    if (-not $script:MinuterieTestTimer) {
        $script:MinuterieTestTimer = New-Object System.Windows.Threading.DispatcherTimer
        $script:MinuterieTestTimer.Interval = [TimeSpan]::FromMilliseconds(300)
        $script:MinuterieTestTimer.Add_Tick({ Suivre-TestTimer })
    }
    $script:MinuterieTestTimer.Start()
}
# Une barre de comparaison : plus elle est courte, mieux c'est
function Barre-Comparaison([string]$nom, [double]$ms, [string]$couleur, [bool]$gras) {
    $fr = [Globalization.CultureInfo]'fr-FR'
    $g = New-Object System.Windows.Controls.Grid
    $g.Margin = '0,3,0,3'
    foreach ($w in 210, 0, 70) {
        $c = New-Object System.Windows.Controls.ColumnDefinition
        $c.Width = if ($w -eq 0) { New-Object System.Windows.GridLength(1, 'Star') } else { New-Object System.Windows.GridLength($w) }
        $g.ColumnDefinitions.Add($c)
    }
    $t = New-Object System.Windows.Controls.TextBlock
    $t.Text = $nom; $t.FontSize = 12; $t.Foreground = Pinceau $(if ($gras) { '#E9ECF2' } else { '#9AA3B5' }); $t.VerticalAlignment = 'Center'
    if ($gras) { $t.FontWeight = 'SemiBold' }
    $fond = New-Object System.Windows.Controls.Border
    $fond.Height = 10; $fond.CornerRadius = 5; $fond.Background = Pinceau '#1E2430'; $fond.VerticalAlignment = 'Center'
    [System.Windows.Controls.Grid]::SetColumn($fond, 1)
    $b = New-Object System.Windows.Controls.Border
    $b.Height = 10; $b.CornerRadius = 5; $b.Background = Pinceau $couleur; $b.HorizontalAlignment = 'Left'; $b.VerticalAlignment = 'Center'
    [System.Windows.Controls.Grid]::SetColumn($b, 1)
    $pct = [math]::Max(0.03, [math]::Min(1.0, $ms / 16.0))
    $fond.Add_SizeChanged({ param($x, $e) $b.Width = [math]::Max(4, $e.NewSize.Width * $pct) }.GetNewClosure())
    $v = New-Object System.Windows.Controls.TextBlock
    $v.Text = "$($ms.ToString('0.0', $fr)) ms"; $v.FontSize = 12; $v.HorizontalAlignment = 'Right'; $v.VerticalAlignment = 'Center'
    $v.Foreground = Pinceau $(if ($gras) { $couleur } else { '#9AA3B5' })
    if ($gras) { $v.FontWeight = 'SemiBold' }
    [System.Windows.Controls.Grid]::SetColumn($v, 2)
    [void]$g.Children.Add($t); [void]$g.Children.Add($fond); [void]$g.Children.Add($b); [void]$g.Children.Add($v)
    return $g
}

function Suivre-TestTimer {
    $t = $script:TestTimer
    if (-not $t) { $script:MinuterieTestTimer.Stop(); return }
    if (-not $t.P.HasExited -and ((Get-Date) - $t.Debut).TotalSeconds -lt 30) { return }
    $script:MinuterieTestTimer.Stop()
    $script:TestTimer = $null
    $ms = $null
    try { $ms = [double]::Parse("$(Get-Content $t.F -Raw -ErrorAction Stop)".Trim(), [Globalization.CultureInfo]::InvariantCulture) } catch {}
    $fr = [Globalization.CultureInfo]'fr-FR'
    $UI.PanTrComparaison.Children.Clear()
    $permanent = if (TimerFond-Actif) { 'Le programme permanent est en marche : le timer reste au maximum meme quand OptiGame est ferme.' } else { 'Le programme permanent est arrete : active Toujours au maximum pour que ca marche aussi OptiGame ferme.' }
    if ($null -eq $ms) {
        $UI.TxtTrTestTitre.Text = 'La mesure n''a pas pu se faire. Reessaie.'
        $UI.TxtTrTestTitre.Foreground = Pinceau '#FFC24B'
        $UI.TxtTrTestDetail.Text = $permanent
        return
    }
    $txtMs = $ms.ToString('0.00', $fr)
    $comment = "COMMENT MARCHE LE TEST : un petit programme a part, qui se comporte comme un jeu, demande 200 fois a Windows : 'reveille-moi dans 1 milliseconde'. OptiGame chronometre combien de temps Windows met vraiment. Plus c'est proche de 1 ms, plus Windows est precis.`r`n`r`n"
    if ($ms -le 1.7) {
        $UI.TxtTrTestTitre.Text = "ACTIF AU MAXIMUM pour tes jeux ($txtMs ms au lieu de 15,6 ms)"
        $UI.TxtTrTestTitre.Foreground = Pinceau '#3FE08E'
        $UI.TxtTrTestDetail.Text = $comment + "TON RESULTAT : Windows a mis $txtMs ms au lieu de 1 ms demandee. C'est le meilleur resultat possible (on ne descend jamais a 1,0 pile).`r`n`r`n" +
            "CE QUE CA CHANGE EN JEU : sans Timer Resolution, Windows ne reveille les programmes que toutes les 15,6 ms. Avec, c'est environ 12 fois plus precis : les images arrivent plus regulierement (moins de micro-saccades, surtout avec une limite de FPS) et la souris reagit un peu plus vite.`r`n`r`n$permanent"
        $coul = '#3FE08E'
    } elseif ($ms -le 6) {
        $UI.TxtTrTestTitre.Text = "Actif, mais pas au maximum ($txtMs ms)"
        $UI.TxtTrTestTitre.Foreground = Pinceau '#FFC24B'
        $UI.TxtTrTestDetail.Text = $comment + "TON RESULTAT : $txtMs ms. Windows est plus precis que la normale (15,6 ms) mais pas au maximum (environ 1 a 1,5 ms).`r`n`r`n" +
            "QUOI FAIRE : clique sur Maximum puis refais le test. Si ca ne change pas, le PC etait peut-etre tres charge pendant la mesure : refais-la au calme.`r`n`r`n$permanent"
        $coul = '#FFC24B'
    } else {
        $UI.TxtTrTestTitre.Text = "PAS ACTIF pour tes jeux ($txtMs ms, comme un Windows normal)"
        $UI.TxtTrTestTitre.Foreground = Pinceau '#FF6B7A'
        $global = $null
        try { Charger-Timer; $global = [OGTimer]::Info()[2] } catch {}
        $quoi = if ((Timer-RedemarrageNecessaire) -or ($null -ne $global -and $global -le 0.6)) {
            "QUOI FAIRE : le timer est bien a 0,5 ms, mais Windows 11 ne le partage pas encore avec les autres programmes (donc pas avec tes jeux). Redemarre le PC une fois, puis refais ce test."
        } else { 'QUOI FAIRE : clique sur Maximum (ou active Toujours au maximum), puis refais le test.' }
        $UI.TxtTrTestDetail.Text = $comment + "TON RESULTAT : $txtMs ms, c'est la valeur normale de Windows : tes jeux ne profitent pas du Timer Resolution.`r`n`r`n$quoi`r`n`r`n$permanent"
        $coul = '#FF6B7A'
    }
    # Comparaison visuelle (barre plus courte = mieux)
    $titre = New-Object System.Windows.Controls.TextBlock
    $titre.Text = 'COMPARAISON (barre plus courte = Windows plus precis = mieux)'; $titre.FontSize = 11; $titre.FontWeight = 'SemiBold'; $titre.Foreground = Pinceau '#8C95A8'; $titre.Margin = '0,2,0,4'
    [void]$UI.PanTrComparaison.Children.Add($titre)
    [void]$UI.PanTrComparaison.Children.Add((Barre-Comparaison 'Windows normal (sans timer)' 15.6 '#5E677A' $false))
    [void]$UI.PanTrComparaison.Children.Add((Barre-Comparaison 'Timer a 1 ms' 2.0 '#5E677A' $false))
    [void]$UI.PanTrComparaison.Children.Add((Barre-Comparaison 'Timer au maximum (0,5 ms)' 1.3 '#5E677A' $false))
    [void]$UI.PanTrComparaison.Children.Add((Barre-Comparaison 'TON PC MAINTENANT' $ms $coul $true))
}

function Timer-Max([switch]$Discret) {
    Charger-Timer
    $r = [OGTimer]::Regler($true)
    $script:TimerActif = $true
    if (-not $Discret) { Write-Log ("Timer Resolution au maximum : {0} ms." -f $r.ToString('0.000', [Globalization.CultureInfo]'fr-FR')) }
    try { Assurer-TimerGlobal } catch {}
    Maj-Timer
}

function Timer-Defaut {
    Charger-Timer
    $r = [OGTimer]::Regler($false)
    $script:TimerActif = $false
    Write-Log ("Timer Resolution remis par defaut ({0} ms, regle par Windows et les autres applis)." -f $r.ToString('0.000', [Globalization.CultureInfo]'fr-FR'))
    Maj-Timer
}

function Maj-Timer {
    if (-not $UI.TxtTrActuel) { return }
    try {
        Charger-Timer
        $i = [OGTimer]::Info()
        $fr = [Globalization.CultureInfo]'fr-FR'
        $UI.TxtTrActuel.Text = "$($i[2].ToString('0.000', $fr)) ms"
        $UI.TxtTrInfo.Text = "Plage de ton PC : $($i[0].ToString('0.000', $fr)) a $($i[1].ToString('0.000', $fr)) ms. Plus c'est bas, plus Windows est precis : moins d'input lag et des images plus regulieres en jeu."
        if (-not $script:TimerVerifQuand -or ((Get-Date) - $script:TimerVerifQuand).TotalSeconds -gt 20) {
            $script:TimerFondEtat = TimerFond-Actif
            $script:TimerRedem = Timer-RedemarrageNecessaire
            $script:TimerVerifQuand = Get-Date
        }
        if ($script:TimerRedem -and ($script:TimerActif -or $script:TimerFondEtat)) {
            $UI.TxtTrInfo.Text = "Redemarre le PC une fois : sous Windows 11, le timer ne s'applique aux jeux qu'apres ce redemarrage (a faire une seule fois)."
        }
        if ($script:TimerFondEtat) {
            $UI.TxtTrEtat.Text = 'Maximum actif en permanence'; $UI.TxtTrEtat.Foreground = Pinceau '#3FE08E'; $UI.PastTr.Background = Pinceau '#163626'
        } elseif ($script:TimerActif) {
            $UI.TxtTrEtat.Text = 'Maximum actif'; $UI.TxtTrEtat.Foreground = Pinceau '#3FE08E'; $UI.PastTr.Background = Pinceau '#163626'
        } else {
            $UI.TxtTrEtat.Text = 'Par defaut'; $UI.TxtTrEtat.Foreground = Pinceau '#8C95A8'; $UI.PastTr.Background = Pinceau '#1E2430'
        }
    } catch {}
}

# =====================================================================
#  LANCEMENT D'OPTIGAME AU DEMARRAGE DU PC
#  Une tache planifiee lance un petit script stable (ProgramData) qui ouvre la version active :
#  ca marche toujours apres une mise a jour d'OptiGame.
# =====================================================================
$NomTacheDem = 'OptiGame - Demarrage'
$ScriptDem = Join-Path $env:ProgramData 'OptiGame\demarrage.ps1'

$ScriptOuvrir = Join-Path $env:ProgramData 'OptiGame\ouvrir_optigame.ps1'
function Ecrire-ScriptDemarrage { Ecrire-ScriptLancement $ScriptDem }
function Ecrire-ScriptLancement([string]$destination) {
    if ($TestAmi) { return }
    $modele = @'
# Ouvre OptiGame avec la derniere version utilisee (cree par OptiGame : raccourci OptiGame et demarrage du PC)
param([switch]$Cache)
$dossier = '__DOSSIER__'
$cible = $null
try {
    $a = (Get-Content (Join-Path $env:ProgramData 'OptiGame\versions.json') -Raw | ConvertFrom-Json).Active
    if ($a) { $p = Join-Path $dossier $a; if (Test-Path -LiteralPath $p) { $cible = $p } }
} catch {}
if (-not $cible) {
    $cible = Get-ChildItem -LiteralPath $dossier -Filter 'OptiGame_v*.ps1' -ErrorAction SilentlyContinue |
        Sort-Object { $v = $_.BaseName -replace '^OptiGame_v', ''; if ($v -notmatch '\.') { $v += '.0' }; try { [version]$v } catch { [version]'0.0' } } -Descending |
        Select-Object -First 1 -ExpandProperty FullName
}
if (-not $cible) { exit }
$arg = "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$cible`""
if ($Cache -and (Select-String -LiteralPath $cible -Pattern 'switch\]\$Cache' -Quiet)) { $arg += ' -Cache' }
Start-Process powershell.exe -ArgumentList $arg
'@
    New-Item -ItemType Directory -Path (Split-Path $destination) -Force | Out-Null
    $txt = $modele.Replace('__DOSSIER__', ((Split-Path $PSCommandPath) -replace "'", "''"))
    [IO.File]::WriteAllText($destination, $txt, (New-Object Text.UTF8Encoding($true)))
}

function Demarrage-Actif { return [bool](Get-ScheduledTask -TaskName $NomTacheDem -ErrorAction SilentlyContinue) }
function Demarrage-Mode {
    $t = Get-ScheduledTask -TaskName $NomTacheDem -ErrorAction SilentlyContinue
    if ($t -and "$($t.Actions[0].Arguments)" -match '-Cache') { return 'cache' }
    return 'fenetre'
}

function Activer-Demarrage([string]$mode) {
    $avant = if (Demarrage-Actif) { Demarrage-Mode } else { $null }
    Ecrire-ScriptDemarrage
    $u = "$env:USERDOMAIN\$env:USERNAME"
    $arg = "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$ScriptDem`""
    if ($mode -eq 'cache') { $arg += ' -Cache' }
    $act = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument $arg
    $trg = New-ScheduledTaskTrigger -AtLogOn -User $u
    $trg.Delay = 'PT15S'
    $prn = New-ScheduledTaskPrincipal -UserId $u -LogonType Interactive -RunLevel Highest
    $set = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -ExecutionTimeLimit ([TimeSpan]::Zero)
    Register-ScheduledTask -TaskName $NomTacheDem -Action $act -Trigger $trg -Principal $prn -Settings $set -Force | Out-Null
    $txt = if ($mode -eq 'cache') { 'en arriere-plan' } else { 'avec la fenetre' }
    if ($avant -eq $mode) { return }
    Write-Log "OptiGame se lancera au demarrage du PC ($txt)."
    $script:SourceAction = 'Interrupteur Lancer OptiGame au demarrage du PC (Accueil)'
    $av = if ($avant -eq 'cache') { 'Oui (en arriere-plan)' } elseif ($avant) { 'Oui (avec la fenetre)' } else { 'Non' }
    Ajouter-Journal 'Lancement au demarrage du PC' $av "Oui ($txt)"
    $script:SourceAction = $null
}

function Desactiver-Demarrage {
    Unregister-ScheduledTask -TaskName $NomTacheDem -Confirm:$false -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath $ScriptDem -Force -ErrorAction SilentlyContinue
    Write-Log 'OptiGame ne se lancera plus au demarrage du PC.'
    $script:SourceAction = 'Interrupteur Lancer OptiGame au demarrage du PC (Accueil)'
    Ajouter-Journal 'Lancement au demarrage du PC' 'Oui' 'Non'
    $script:SourceAction = $null
}

# =====================================================================
#  SPICETIFY AUTOMATIQUE
# =====================================================================
$FichierSpAuto = Join-Path $env:ProgramData 'OptiGame\spicetify_auto.txt'
$FichierSpVer = Join-Path $env:ProgramData 'OptiGame\spicetify_spotify_version.txt'
function SpAuto-Actif { return ((Test-Path $FichierSpAuto) -and ((Get-Content $FichierSpAuto -Raw -ErrorAction SilentlyContinue) -match '1')) }

# Installation sans aucune question (memes etapes que les installateurs officiels de Spicetify et du Marketplace)
$CodeSpInstallAuto = @'
$ErrorActionPreference = 'Stop'
Write-Host '  Recherche de la derniere version de Spicetify...' -ForegroundColor Cyan
$v = ((Invoke-RestMethod -UseBasicParsing -Uri 'https://api.github.com/repos/spicetify/cli/releases/latest').tag_name).TrimStart('v')
$arch = if ($env:PROCESSOR_ARCHITECTURE -eq 'ARM64') { 'arm64' } else { 'x64' }
$zip = Join-Path $env:TEMP 'spicetify.zip'
Write-Host "  Telechargement de Spicetify $v..." -ForegroundColor Cyan
Invoke-WebRequest -UseBasicParsing -Uri "https://github.com/spicetify/cli/releases/download/v$v/spicetify-$v-windows-$arch.zip" -OutFile $zip
$dir = Join-Path $env:LOCALAPPDATA 'spicetify'
New-Item -ItemType Directory -Path $dir -Force | Out-Null
Expand-Archive -Path $zip -DestinationPath $dir -Force
Remove-Item $zip -Force
$p = [Environment]::GetEnvironmentVariable('PATH', 'User')
if ("$p" -notmatch [regex]::Escape($dir)) { [Environment]::SetEnvironmentVariable('PATH', "$p;$dir".Trim(';'), 'User') }
$ErrorActionPreference = 'Continue'
& $SpExe config | Out-Null
Write-Host '  Installation du Marketplace (themes)...' -ForegroundColor Cyan
$ud = Join-Path $env:APPDATA 'spicetify'
$app = Join-Path $ud 'CustomApps\marketplace'
$theme = Join-Path $ud 'Themes\marketplace'
New-Item -ItemType Directory -Path $app, $theme -Force | Out-Null
Invoke-WebRequest -UseBasicParsing -Uri 'https://github.com/spicetify/marketplace/releases/latest/download/marketplace.zip' -OutFile (Join-Path $app 'marketplace.zip')
Expand-Archive -Path (Join-Path $app 'marketplace.zip') -DestinationPath $app -Force
$dist = Join-Path $app 'marketplace-dist'
if (Test-Path $dist) { Move-Item -Path (Join-Path $dist '*') -Destination $app -Force; Remove-Item $dist -Recurse -Force }
Remove-Item (Join-Path $app 'marketplace.zip') -Force -ErrorAction SilentlyContinue
Invoke-WebRequest -UseBasicParsing -Uri 'https://raw.githubusercontent.com/spicetify/marketplace/main/resources/color.ini' -OutFile (Join-Path $theme 'color.ini')
& $SpExe config custom_apps spicetify-marketplace- -q
& $SpExe config custom_apps marketplace
& $SpExe config inject_css 1 replace_colors 1
& $SpExe config current_theme marketplace
Write-Host '  Application a Spotify...' -ForegroundColor Cyan
& $SpExe backup apply
'@

$CodeSpReappliquer = @'
& $SpExe backup apply
if ($LASTEXITCODE -ne 0) {
    Write-Host '  Mise a jour de Spicetify...' -ForegroundColor Cyan
    & $SpExe update
    & $SpExe restore backup apply
}
'@

function Noter-VersionSpotify {
    $e = Etat-Spicetify
    if ($e.SpotifyVer) {
        New-Item -ItemType Directory -Path $DossierData -Force | Out-Null
        $e.SpotifyVer | Out-File $FichierSpVer -Encoding ASCII
    }
}

function Verifier-SpicetifyAuto([switch]$Silencieux) {
    if (-not (SpAuto-Actif)) { return }
    if ($script:MinuterieSp -and $script:MinuterieSp.IsEnabled) { return }   # une operation Spicetify est deja en cours
    $e = Etat-Spicetify
    if (-not $e.SpotifyPC) {
        if (-not $Silencieux) { Write-Log 'Spicetify automatique : Spotify (version spotify.com) pas installe, rien a faire.' 'Gray' }
        return
    }
    if (-not $e.Cli) {
        Write-Log 'Spicetify automatique : Spicetify absent, installation...' 'White'
        Lancer-CommeUtilisateur 'spicetify_auto' 'Installation automatique de Spicetify' $CodeSpInstallAuto -Discret
        return
    }
    $derniere = if (Test-Path $FichierSpVer) { "$(Get-Content $FichierSpVer -Raw)".Trim() } else { '' }
    if (-not $e.Applique) {
        Write-Log 'Spicetify automatique : pas applique a Spotify, application...' 'White'
        Lancer-CommeUtilisateur 'spicetify_auto' 'Application automatique de Spicetify' $CodeSpReappliquer -Discret
    } elseif (-not $derniere) {
        Noter-VersionSpotify
    } elseif ($derniere -ne $e.SpotifyVer) {
        Write-Log "Spicetify automatique : Spotify mis a jour ($derniere -> $($e.SpotifyVer)), Spicetify reapplique..." 'White'
        Lancer-CommeUtilisateur 'spicetify_auto' 'Reapplication automatique de Spicetify' $CodeSpReappliquer -Discret
    } elseif (-not $Silencieux) {
        Write-Log 'Spicetify automatique : tout est en place.' 'Gray'
    }
}

# =====================================================================
#  THEMES : couleur principale, fond et image de fond d'OptiGame
#  Les couleurs sont remplacees dans l'interface avant son chargement.
# =====================================================================
$FichierTheme = Join-Path $env:ProgramData 'OptiGame\theme.json'
$ThemeDefaut = [ordered]@{ Accent = '00D46A'; Accent2 = '00B2D6'; Fond = 'sombre'; Image = ''; Opacite = 22 }

function Lire-Theme {
    $t = [ordered]@{}
    foreach ($k in $ThemeDefaut.Keys) { $t[$k] = $ThemeDefaut[$k] }
    if (Test-Path $FichierTheme) {
        try { $j = Get-Content $FichierTheme -Raw | ConvertFrom-Json; foreach ($k in @($ThemeDefaut.Keys)) { if ($null -ne $j.$k -and "$($j.$k)" -ne '') { $t[$k] = $j.$k } } } catch {}
    }
    return $t
}
function Sauver-Theme($t) {
    New-Item -ItemType Directory -Path (Split-Path $FichierTheme) -Force | Out-Null
    ([pscustomobject]$t) | ConvertTo-Json | Out-File -FilePath $FichierTheme -Encoding UTF8
}

function Couleur-RGB([string]$h) { $h = $h.TrimStart('#'); return @([Convert]::ToInt32($h.Substring(0, 2), 16), [Convert]::ToInt32($h.Substring(2, 2), 16), [Convert]::ToInt32($h.Substring(4, 2), 16)) }
function Melanger([string]$a, [string]$b, [double]$t) {
    $x = Couleur-RGB $a; $y = Couleur-RGB $b
    return ('{0:X2}{1:X2}{2:X2}' -f [int]($x[0] + ($y[0] - $x[0]) * $t), [int]($x[1] + ($y[1] - $x[1]) * $t), [int]($x[2] + ($y[2] - $x[2]) * $t))
}

# Couleurs de fond d'origine (du plus sombre au plus clair)
$CouleursFond = @('0D0F14', '11141B', '161A23', '1C212C', '1A1F29', '12161E', '171B24', '0F1218', '1E2430', '232937', '232A36', '2A3140', '1C212B',
    '161B26', '1A1F2A', '1A2730', '141B26', '242A37', '1B2130', '1C2330', '222A36', '2E3646', '343C4C', '232936', '2E3A4C', '3A4252', '1A2638', '1C2330', '232A36')
$TeintesFond = @{ noir = @('000000', 0.45); nuit = @('14254F', 0.38); prune = @('3A1640', 0.38) }

function Table-Theme($t) {
    $m = @{}
    $a1 = "$($t.Accent)".TrimStart('#').ToUpper(); $a2 = "$($t.Accent2)".TrimStart('#').ToUpper()
    if ($t.Fond -ne 'sombre' -and $TeintesFond.ContainsKey($t.Fond)) {
        $tf = $TeintesFond[$t.Fond]
        foreach ($c in $CouleursFond) {
            $m[$c] = if ($t.Fond -eq 'noir') { Melanger $c '000000' 0.55 } else { Melanger $c $tf[0] $tf[1] }
        }
    }
    $bg = if ($m.ContainsKey('0D0F14')) { $m['0D0F14'] } else { '0D0F14' }
    if ($a1 -ne '00D46A' -or $a2 -ne '00B2D6') {
        $m['00D46A'] = $a1; $m['00B2D6'] = $a2
        $m['3FE08E'] = Melanger $a1 'FFFFFF' 0.25; $m['7FE0A8'] = Melanger $a1 'FFFFFF' 0.45; $m['9DEBC0'] = Melanger $a1 'FFFFFF' 0.6
        $m['163626'] = Melanger $bg $a1 0.18; $m['16301F'] = Melanger $bg $a1 0.15; $m['16261F'] = Melanger $bg $a1 0.11; $m['13241C'] = Melanger $bg $a1 0.1
        $m['1F6B4A'] = Melanger $bg $a1 0.42; $m['1F5A3E'] = Melanger $bg $a1 0.35; $m['2E9E6A'] = Melanger $bg $a1 0.7
        $m['06130C'] = Melanger '000000' $a1 0.08
    }
    return $m
}

function Recolorer([string]$texte, $m) {
    if ($m.Count -eq 0) { return $texte }
    $motif = '(?i)(?<=#(?:[0-9A-F]{2})?)(' + (($m.Keys | ForEach-Object { [regex]::Escape($_) }) -join '|') + ')(?![0-9A-F])'
    return [regex]::Replace($texte, $motif, { param($x) $m[$x.Value.ToUpper()] })
}

function Appliquer-ThemeXaml {
    $t = Lire-Theme
    $script:ThemeCharge = $t
    $script:ThemeAffiche = $t
    $script:XamlDialogueDefaut = $XamlDialogue
    $m = Table-Theme $t
    if ($m.Count -eq 0) { return }
    $script:XamlStyles = Recolorer $XamlStyles $m
    $script:XamlMain = Recolorer $XamlMain $m
    $script:XamlOverlay = Recolorer $XamlOverlay $m
    $script:XamlDialogue = Recolorer $XamlDialogue $m
    if ($m.ContainsKey('00D46A')) {
        $StyleNiveaux['OK'] = @("#$($m['00D46A'])", "#26$($m['00D46A'])")
    }
}

function Appliquer-ImageFond {
    $t = Lire-Theme
    if ($script:ImageFond -and $UI.Racine) { $UI.Racine.Children.Remove($script:ImageFond); $script:ImageFond = $null }
    if (-not $t.Image -or -not (Test-Path -LiteralPath $t.Image) -or -not $UI.Racine) { return }
    try {
        $bmp = New-Object System.Windows.Media.Imaging.BitmapImage
        $bmp.BeginInit()
        $bmp.CacheOption = [System.Windows.Media.Imaging.BitmapCacheOption]::OnLoad
        $bmp.DecodePixelWidth = 1920
        $bmp.UriSource = New-Object Uri($t.Image)
        $bmp.EndInit()
        $img = New-Object System.Windows.Controls.Image
        $img.Source = $bmp
        $img.Stretch = 'UniformToFill'
        $img.Opacity = [double]$t.Opacite / 100.0
        $img.IsHitTestVisible = $false
        [System.Windows.Controls.Grid]::SetColumnSpan($img, 2)
        $UI.Racine.Children.Insert(0, $img)
        $script:ImageFond = $img
    } catch {}
}

# ---------- Changement de theme EN DIRECT (sans redemarrer) ----------
# On repeint les couleurs deja affichees : ancienne couleur -> nouvelle couleur.
function Rgb-Couleur($c) { return ('{0:X2}{1:X2}{2:X2}' -f $c.R, $c.G, $c.B) }
function Table-Passage($de, $vers) {
    $a = Table-Theme $de; $b = Table-Theme $vers
    $m = @{}
    foreach ($k in @(@($a.Keys) + @($b.Keys) + @($CouleursFond) + @('00D46A', '00B2D6', '3FE08E', '7FE0A8', '9DEBC0', '163626', '16301F', '16261F', '13241C', '1F6B4A', '1F5A3E', '2E9E6A', '06130C') | Select-Object -Unique)) {
        $x = if ($a.ContainsKey($k)) { $a[$k] } else { $k }
        $y = if ($b.ContainsKey($k)) { $b[$k] } else { $k }
        if ($x -ne $y -and -not $m.ContainsKey($x)) { $m[$x] = $y }
    }
    return $m
}
function Nouvelle-Couleur($c, $m) {
    $k = Rgb-Couleur $c
    if (-not $m.ContainsKey($k)) { return $null }
    $n = Couleur-RGB $m[$k]
    return [System.Windows.Media.Color]::FromArgb($c.A, [byte]$n[0], [byte]$n[1], [byte]$n[2])
}
function Nouveau-Pinceau($b, $m) {
    if ($b -is [System.Windows.Media.SolidColorBrush]) {
        $n = Nouvelle-Couleur $b.Color $m
        if ($null -eq $n) { return $null }
        $r = New-Object System.Windows.Media.SolidColorBrush($n); $r.Opacity = $b.Opacity; return $r
    }
    if ($b -is [System.Windows.Media.GradientBrush]) {
        $chg = $false
        $r = $b.Clone()
        foreach ($st in $r.GradientStops) { $n = Nouvelle-Couleur $st.Color $m; if ($null -ne $n) { $st.Color = $n; $chg = $true } }
        if ($chg) { return $r }
    }
    return $null
}
$ProprietesCouleur = @(
    [System.Windows.Controls.Control]::BackgroundProperty, [System.Windows.Controls.Control]::ForegroundProperty, [System.Windows.Controls.Control]::BorderBrushProperty,
    [System.Windows.Controls.Border]::BackgroundProperty, [System.Windows.Controls.Border]::BorderBrushProperty, [System.Windows.Controls.Panel]::BackgroundProperty,
    [System.Windows.Controls.TextBlock]::ForegroundProperty, [System.Windows.Controls.TextBlock]::BackgroundProperty,
    [System.Windows.Shapes.Shape]::FillProperty, [System.Windows.Shapes.Shape]::StrokeProperty, [System.Windows.Window]::BackgroundProperty) | Select-Object -Unique
function Repeindre($racine, $m) {
    if (-not $racine -or $m.Count -eq 0) { return }
    $vus = New-Object 'System.Collections.Generic.HashSet[object]'
    $pile = New-Object System.Collections.Stack
    $pile.Push($racine)
    while ($pile.Count) {
        $d = $pile.Pop()
        if (-not ($d -is [System.Windows.DependencyObject]) -or -not $vus.Add($d)) { continue }
        if ($d -eq $UI.PanThCouleurs -or $d -eq $UI.PanThFonds) { continue }
        foreach ($p in $ProprietesCouleur) {
            # Ne pas figer les couleurs de survol / selection (definies par des declencheurs),
            # et ignorer les proprietes qui ne concernent pas cet element (valeur par defaut)
            $src = "$([System.Windows.DependencyPropertyHelper]::GetValueSource($d, $p).BaseValueSource)"
            if ($src -match 'Trigger|Inherited|^Default$|Unknown') { continue }
            $b = $d.GetValue($p)
            if (-not $b) { continue }
            $n = Nouveau-Pinceau $b $m
            if ($n) { try { $d.SetValue($p, $n) } catch {} }
        }
        if ($d -is [System.Windows.UIElement] -and $d.Effect -is [System.Windows.Media.Effects.DropShadowEffect]) {
            $n = Nouvelle-Couleur $d.Effect.Color $m
            if ($null -ne $n) { $e = $d.Effect.Clone(); $e.Color = $n; $d.Effect = $e }
        }
        if ($d -is [System.Windows.Media.Visual] -or $d -is [System.Windows.Media.Media3D.Visual3D]) {
            $nb = [System.Windows.Media.VisualTreeHelper]::GetChildrenCount($d)
            for ($k = 0; $k -lt $nb; $k++) { $pile.Push([System.Windows.Media.VisualTreeHelper]::GetChild($d, $k)) }
        }
        if ($d -is [System.Windows.FrameworkElement] -or $d -is [System.Windows.FrameworkContentElement]) {
            foreach ($c in [System.Windows.LogicalTreeHelper]::GetChildren($d)) { if ($c -is [System.Windows.DependencyObject]) { $pile.Push($c) } }
        }
    }
}

function Appliquer-ThemeDirect($nouveau) {
    $deAffiche = Table-Passage $script:ThemeAffiche $nouveau
    $deCharge = Table-Passage $script:ThemeCharge $nouveau
    # Couleurs de texte neutres : jamais repeintes (sinon tout le texte changerait de couleur)
    foreach ($n in @('E9ECF2', '8C95A8', 'C9CFDA', '9AA3B5', 'B9C0CE', 'D5DAE3', '6F788B', '5E677A', 'FFFFFF', '000000')) { $deAffiche.Remove($n); $deCharge.Remove($n) }
    $m = @{}
    foreach ($k in $deCharge.Keys) { $m[$k] = $deCharge[$k] }
    foreach ($k in $deAffiche.Keys) { $m[$k] = $deAffiche[$k] }
    $script:MapVivant = $deCharge
    $script:ThemeAffiche = $nouveau
    $UI.Fenetre.Cursor = [System.Windows.Input.Cursors]::Wait
    try {
        Repeindre $UI.Fenetre $m
        # Fenetres de message et couleur "OK" des conseils
        $md = Table-Theme $nouveau
        $script:XamlDialogue = Recolorer $script:XamlDialogueDefaut $md
        $StyleNiveaux['OK'] = $(if ($md.ContainsKey('00D46A')) { @("#$($md['00D46A'])", "#26$($md['00D46A'])") } else { @('#00D46A', '#2600D46A') })
    } finally { $UI.Fenetre.Cursor = $null }
    # Les elements qui apparaitront ensuite (listes, pages) sont repeints a leur affichage
    if (-not $script:MinuterieTheme) {
        $script:MinuterieTheme = New-Object System.Windows.Threading.DispatcherTimer
        $script:MinuterieTheme.Interval = [TimeSpan]::FromSeconds(2)
        $script:MinuterieTheme.Add_Tick({
            if ($script:MapVivant -and $script:MapVivant.Count -and $UI.Fenetre.IsVisible -and $script:PageActive) { try { Repeindre $UI[$script:PageActive] $script:MapVivant } catch {} }
        })
    }
    if ($script:MapVivant.Count) { $script:MinuterieTheme.Start() } else { $script:MinuterieTheme.Stop() }
}

# Applique tout de suite le theme enregistre
function Relancer-PourTheme {
    $t = Lire-Theme
    try { Appliquer-ThemeDirect $t } catch { Write-Log "Apparence : $($_.Exception.Message)" 'Gray' }
    try { Appliquer-ImageFond } catch {}
    Maj-PageApparence
    Afficher-Toast 'Apparence appliquee.'
}

function Relancer-Complet {
    if ($script:TestEnCours -or $script:Busy) { Show-Info 'Une action est en cours : reessaie a la fin.' 'Apparence'; return }
    $nom = [IO.Path]::GetFileName($PSCommandPath)
    if ($nom -match '^OptiGame_v\d+(\.\d+)*\.ps1$') { try { $e = Lire-EtatVersions; Sauver-EtatVersions $nom (@($e.Vues) + @(Lister-Versions | ForEach-Object { $_.Name })) } catch {} }
    $script:Relance = $PSCommandPath
    $script:ForcerFermeture = $true
    $UI.Fenetre.Close()
}

# Pastilles de choix : chacune garde SA couleur, quel que soit le theme actuel
function Peindre-Pastilles {
    $apercus = @{ sombre = @('#0D0F14', '#161A23'); noir = @('#000000', '#0B0C0F'); nuit = @('#0A1226', '#13203F'); prune = @('#140B16', '#22142A') }
    foreach ($b in @($UI.PanThCouleurs.Children)) {
        $c = "$($b.Tag)".Split(',')
        if ($c.Count -lt 2) { continue }
        $b.Content.Children[0].Fill = New-Object System.Windows.Media.LinearGradientBrush ([System.Windows.Media.ColorConverter]::ConvertFromString("#$($c[0])")), ([System.Windows.Media.ColorConverter]::ConvertFromString("#$($c[1])")), 45
    }
    foreach ($b in @($UI.PanThFonds.Children)) {
        $c = $apercus["$($b.Tag)"]
        if ($c) { $b.Content.Children[0].Background = [System.Windows.Media.Brushes]::White; $b.Content.Children[0].Child.Background = New-Object System.Windows.Media.LinearGradientBrush ([System.Windows.Media.ColorConverter]::ConvertFromString($c[0])), ([System.Windows.Media.ColorConverter]::ConvertFromString($c[1])), 0 }
    }
}

function Maj-PageApparence {
    if (-not $UI.TxtThActuel) { return }
    try { Peindre-Pastilles } catch {}
    try { Maj-Oled } catch {}
    $t = Lire-Theme
    $noms = @{ sombre = 'Sombre'; noir = 'Noir pur'; nuit = 'Bleu nuit'; prune = 'Prune' }
    $UI.TxtThActuel.Text = "Actuellement : couleur #$($t.Accent), fond $($noms[$t.Fond])$(if ($t.Image) { ", image $([IO.Path]::GetFileName($t.Image)) ($($t.Opacite) %)" })."
    $UI.SldThOpacite.Value = [double]$t.Opacite
}

# =====================================================================
#  MISES A JOUR EN LIGNE + MODE OPERATEUR
#  L'operateur publie ses versions sur un depot GitHub public (manifest.json + dossier versions).
#  Les autres PC lisent ce manifest : ils voient les nouvelles versions, les installent ou les ignorent,
#  et OptiGame verifie que les fichiers n'ont pas ete modifies (empreinte SHA-256).
# =====================================================================
$FichierMaj = if ($TestAmi) { Join-Path $DossierTestAmi 'maj.json' } else { Join-Path $env:ProgramData 'OptiGame\maj.json' }
$FichierOp = if ($TestAmi) { Join-Path $DossierTestAmi 'operateur.json' } else { Join-Path $env:ProgramData 'OptiGame\operateur.json' }
$script:Distant = $null
$script:MajTache = $null
$script:BannierePlusTard = $false

function Lire-Maj {
    $m = [ordered]@{ Source = ''; Ignorees = @() }
    if (Test-Path $FichierMaj) { try { $j = Get-Content $FichierMaj -Raw | ConvertFrom-Json; $m.Source = "$($j.Source)"; $m.Ignorees = @($j.Ignorees | Where-Object { $_ }) } catch {} }
    if (-not $m.Source) {
        # Une version publiee par l'operateur contient le lien : configuration automatique
        try {
            $h = (Get-Content -LiteralPath $PSCommandPath -TotalCount 40) -join "`n"
            if ($h -match '(?m)^#\s*OptiGame source\s*:\s*(https://\S+)') { $m.Source = $Matches[1]; Sauver-Maj $m }
        } catch {}
    }
    return $m
}
function Sauver-Maj($m) {
    New-Item -ItemType Directory -Path (Split-Path $FichierMaj) -Force | Out-Null
    ([pscustomobject]@{ Source = $m.Source; Ignorees = @($m.Ignorees) }) | ConvertTo-Json | Out-File -FilePath $FichierMaj -Encoding UTF8
}

function Empreinte([string]$chemin) {
    $sha = [Security.Cryptography.SHA256]::Create()
    try { return ([BitConverter]::ToString($sha.ComputeHash([IO.File]::ReadAllBytes($chemin))).Replace('-', '').ToLower()) } finally { $sha.Dispose() }
}
function Version-Texte([string]$v) { if ($v -notmatch '\.') { $v += '.0' }; try { return [version]$v } catch { return [version]'0.0' } }
function Dossier-Versions { return (Split-Path $PSCommandPath) }

# --- Lecture du manifest en arriere-plan (l'interface ne se fige jamais) ---
function Demarrer-VerifMaj([switch]$Manuel) {
    $m = Lire-Maj
    if (-not $m.Source) { Maj-ZoneMaj; if ($Manuel) { Show-Info "Aucun lien de mises a jour.`r`nColle le lien donne par l'operateur dans Versions > Mises a jour en ligne." 'Mises a jour' }; return }
    if ($script:MajTache) { return }
    $ps = [powershell]::Create()
    [void]$ps.AddScript({
        param($u)
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        # Parametre unique : GitHub renvoie toujours la derniere version du fichier (pas une copie en cache de 5 minutes)
        $sep = if ($u -match '\?') { '&' } else { '?' }
        (Invoke-WebRequest -UseBasicParsing -Uri ($u + $sep + 't=' + [DateTime]::UtcNow.Ticks) -TimeoutSec 15 -Headers @{ 'Cache-Control' = 'no-cache' }).Content
    }).AddArgument($m.Source)
    $script:MajTache = @{ PS = $ps; H = $ps.BeginInvoke(); Manuel = [bool]$Manuel; Debut = Get-Date }
    if (-not $script:MinuterieMaj) {
        $script:MinuterieMaj = New-Object System.Windows.Threading.DispatcherTimer
        $script:MinuterieMaj.Interval = [TimeSpan]::FromMilliseconds(400)
        $script:MinuterieMaj.Add_Tick({ Suivre-VerifMaj })
    }
    $script:MinuterieMaj.Start()
    if ($UI.TxtMajEtat) { $UI.TxtMajEtat.Text = 'Recherche des mises a jour...' }
}

function Suivre-VerifMaj {
    $t = $script:MajTache
    if (-not $t) { $script:MinuterieMaj.Stop(); return }
    if (-not $t.H.IsCompleted) { if (((Get-Date) - $t.Debut).TotalSeconds -gt 30) { try { $t.PS.Stop() } catch {} } else { return } }
    $script:MinuterieMaj.Stop()
    $script:MajTache = $null
    $txt = $null; $err = $null
    try { $txt = @($t.PS.EndInvoke($t.H)) -join '' } catch { $err = $_.Exception.InnerException; if (-not $err) { $err = $_.Exception } }
    try { $t.PS.Dispose() } catch {}
    if ($txt) {
        $script:ErreurMajNotee = $false
        try { $script:Distant = @((ConvertFrom-Json $txt).versions | Where-Object { $_.nom }) ; $script:DistantQuand = Get-Date }
        catch { $err = New-Object Exception('le fichier de mises a jour est illisible') }
    }
    if ($err) {
        if (-not $script:ErreurMajNotee -or $t.Manuel) { Write-Log "Mises a jour : impossible de verifier ($($err.Message))." 'Gray'; $script:ErreurMajNotee = $true }
        if ($t.Manuel) { Show-Info "Impossible de verifier les mises a jour :`r`n$($err.Message)`r`n`r`nVerifie ta connexion et le lien." 'Mises a jour' }
    }
    Maj-ZoneMaj
    try { Proposer-MajLancement } catch {}
}

# Au lancement d'OptiGame : s'il y a une nouvelle version, on demande tout de suite si on l'installe (une seule fois)
function Proposer-MajLancement {
    if ($script:QuestionMajFaite) { return }
    if ($null -eq $script:Distant) { $script:QuestionMajFaite = $true; return }
    $n = @(Etat-Maj | Where-Object { -not $_.Present -and -not $_.Ignoree -and $_.Nouvelle })
    if ($n.Count -eq 0) { $script:QuestionMajFaite = $true; return }
    # Fenetre cachee (demarrage avec le PC) ou action en cours : on demandera a l'ouverture de la fenetre
    if (-not (Fenetre-Ouverte) -or $script:Busy -or $script:TestEnCours) { $script:QuestionMajEnAttente = $true; return }
    $script:QuestionMajFaite = $true
    $script:QuestionMajEnAttente = $false
    $plus = $n[0]
    $notes = if ($plus.Notes) { "`r`n`r`nNouveautes : $($plus.Notes)" } else { '' }
    $autres = if ($n.Count -gt 1) { "`r`n($($n.Count) nouvelles versions : toutes seront installees.)" } else { '' }
    if (Ask-YesNo "Une nouvelle version d'OptiGame est disponible : v$($plus.Version).$notes$autres`r`n`r`nLa mettre a jour maintenant ?`r`nOptiGame l'installe puis redemarre dessus (tes reglages sont gardes).`r`n`r`nNon = plus tard (le bouton Installer reste a l'Accueil).") {
        Installer-VersionsEnLigne $n -ProposerUtiliser -Direct
    }
}

# Compare les versions en ligne avec le dossier Versions
function Etat-Maj {
    $m = Lire-Maj
    $dossier = Dossier-Versions
    $actuelle = Version-Texte $VersionApp
    $op = Op-Configure
    $r = @()
    foreach ($v in @($script:Distant | Where-Object { $_ -and $_.nom })) {
        $f = Join-Path $dossier "$($v.nom)"
        $present = Test-Path -LiteralPath $f
        $modifie = $false
        if ($present -and $v.sha256 -and -not $op) { try { $modifie = ((Empreinte $f) -ne "$($v.sha256)".ToLower()) } catch {} }
        $ver = Version-Texte "$($v.version)"
        $r += [pscustomobject]@{
            Nom = "$($v.nom)"; Version = "$($v.version)"; Ver = $ver; Sha = "$($v.sha256)".ToLower(); Url = "$($v.url)"; Notes = "$($v.notes)"
            Present = $present; Modifie = $modifie; Ignoree = (@($m.Ignorees) -contains "$($v.nom)"); Nouvelle = ($ver -gt $actuelle)
        }
    }
    return @($r | Sort-Object Ver -Descending)
}

function Maj-ZoneMaj {
    $m = Lire-Maj
    $op = Op-Configure
    if ($UI.TxtMajSource -and -not $UI.TxtMajSource.IsKeyboardFocused) { $UI.TxtMajSource.Text = $m.Source }
    $etat = @(Etat-Maj)
    $aFaire = @($etat | Where-Object { (-not $_.Present -and -not $_.Ignoree) -or $_.Modifie })
    $nouvelles = @($etat | Where-Object { -not $_.Present -and -not $_.Ignoree -and $_.Nouvelle })
    # Liste de la page Versions
    if ($UI.ListeDistantes) {
        $items = @()
        foreach ($e in $etat) {
            if ($e.Present -and -not $e.Modifie) { continue }
            $etiq, $fond, $coul = if ($e.Modifie) { @('modifiee', '#3A1A20', '#FF6B7A') } elseif ($e.Ignoree) { @('ignoree', '#1E2430', '#8C95A8') } elseif ($e.Nouvelle) { @('nouvelle', '#163626', '#3FE08E') } else { @('manquante', '#33270F', '#FFC24B') }
            $items += [pscustomobject]@{
                Titre = "v$($e.Version)  -  $($e.Nom)"; Couleur = $(if ($e.Ignoree) { '#8C95A8' } else { '#E9ECF2' })
                Etat = $etiq; FondEtat = $fond; CouleurEtat = $coul
                Notes = $(if ($e.Modifie) { 'Ce fichier a ete modifie sur ce PC : reinstalle l''original de l''operateur.' } elseif ($e.Notes) { $e.Notes } else { 'Version publiee par l''operateur.' })
                TexteInstaller = $(if ($e.Modifie) { 'Reinstaller' } else { 'Installer' }); TagInstaller = "inst:$($e.Nom)"
                VisInstaller = 'Visible'
                TexteIgnorer = $(if ($e.Ignoree) { 'Ne plus ignorer' } else { 'Ignorer' }); TagIgnorer = $(if ($e.Ignoree) { "rea:$($e.Nom)" } else { "ign:$($e.Nom)" })
                VisIgnorer = $(if ($e.Modifie) { 'Collapsed' } else { 'Visible' })
            }
        }
        $UI.ListeDistantes.ItemsSource = $items
        $UI.TxtMajVide.Visibility = $(if ($items.Count -eq 0 -and $m.Source -and $null -ne $script:Distant) { 'Visible' } else { 'Collapsed' })
        $UI.BtnMajTout.Visibility = $(if ($aFaire.Count -gt 0) { 'Visible' } else { 'Collapsed' })
        $UI.BtnMajTout.Content = "Tout installer ($($aFaire.Count))"
        $UI.TxtMajEtat.Text = if (-not $m.Source) { "Recois les nouvelles versions d'OptiGame automatiquement. Colle en dessous le lien donne par la personne qui publie OptiGame (l'operateur)." }
            elseif ($null -eq $script:Distant) { "Lien enregistre. Clique sur Verifier." }
            else { "$(@($script:Distant).Count) version(s) en ligne, verifie a $($script:DistantQuand.ToString('HH:mm')). $($aFaire.Count) a installer." }
        $UI.ZoneMajSource.Visibility = $(if ($m.Source -and -not $op) { 'Collapsed' } else { 'Visible' })
    }
    # Banniere de l'Accueil
    if ($UI.BanniereMaj) {
        $modifActuelle = @($etat | Where-Object { $_.Modifie -and $_.Nom -eq [IO.Path]::GetFileName($PSCommandPath) })
        if ($modifActuelle.Count) {
            $UI.TxtMajTitre.Text = 'Cette version d''OptiGame a ete modifiee'
            $UI.TxtMajSous.Text = "Le fichier $($modifActuelle[0].Nom) ne correspond plus a l'original publie. Reinstalle-le pour eviter les bugs."
            $UI.BtnMajInstaller.Content = 'Reinstaller l''original'
            $UI.BtnMajInstaller.Tag = 'modif'
            $UI.BanniereMaj.Visibility = 'Visible'
        } elseif ($nouvelles.Count -and "$($script:PlusTardVersion)" -ne "$($nouvelles[0].Nom)") {
            $plus = $nouvelles[0]
            # Notification Windows une seule fois par nouvelle version
            if ("$($script:VersionNotifiee)" -ne "$($plus.Nom)") {
                $script:VersionNotifiee = $plus.Nom
                try {
                    if ($script:Notif -and -not ((Fenetre-Ouverte) -and $UI.Fenetre.IsActive)) {
                        $script:Notif.ShowBalloonTip(8000, "Mise a jour d'OptiGame : v$($plus.Version)", "Une nouvelle version est disponible. Clique ici pour l'installer.$(if ($plus.Notes) { ' ' + "$($plus.Notes)".Substring(0, [math]::Min(120, "$($plus.Notes)".Length)) })", [Windows.Forms.ToolTipIcon]::Info)
                        $script:BulleMaj = $true
                    }
                    if (-not $UI.Fenetre.IsActive) { Clignoter-BarreTaches }
                } catch {}
                Write-Log "Nouvelle version disponible : v$($plus.Version)." 'Gold'
            }
            $UI.TxtMajTitre.Text = "Mise a jour disponible : OptiGame v$($plus.Version)"
            $UI.TxtMajSous.Text = $(if ($nouvelles.Count -gt 1) { "$($nouvelles.Count) nouvelles versions (toutes seront installees). " } else { '' }) + $(if ($plus.Notes) { $plus.Notes } else { 'Publiee par l''operateur.' })
            $UI.BtnMajInstaller.Content = 'Installer'
            $UI.BtnMajInstaller.Tag = 'nouvelles'
            $UI.BanniereMaj.Visibility = 'Visible'
        } else { $UI.BanniereMaj.Visibility = 'Collapsed' }
    }
    Maj-ZoneOp
}

function Url-Version($e) {
    if ($e.Url) { return $e.Url }
    $src = (Lire-Maj).Source
    return ($src -replace '[^/]+$', '') + 'versions/' + [uri]::EscapeDataString($e.Nom)
}

# Telecharge, verifie l'empreinte et installe des versions dans le dossier Versions
function Installer-VersionsEnLigne($liste, [switch]$ProposerUtiliser, [switch]$Direct) {
    $liste = @($liste)
    if ($liste.Count -eq 0) { return }
    $dossier = Dossier-Versions
    $ok = New-Object System.Collections.ArrayList
    $script:SourceAction = 'Mises a jour en ligne (page Versions ou Accueil)'
    Invoke-Action "Installation de $($liste.Count) version(s)" {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        foreach ($e in $liste) {
            Write-Log "Telechargement de $($e.Nom)..."
            $tmp = Join-Path $env:TEMP "og_$([guid]::NewGuid().ToString('N')).ps1"
            try {
                Invoke-WebRequest -UseBasicParsing -Uri (Url-Version $e) -OutFile $tmp -TimeoutSec 60 -ErrorAction Stop
                if ($e.Sha -and (Empreinte $tmp) -ne $e.Sha) { throw "le fichier telecharge ne correspond pas a celui de l'operateur (empreinte differente)" }
                $dest = Join-Path $dossier $e.Nom
                if (Test-Path -LiteralPath $dest) { (Get-Item -LiteralPath $dest).IsReadOnly = $false }
                Move-Item -LiteralPath $tmp -Destination $dest -Force
                Unblock-File -LiteralPath $dest -ErrorAction SilentlyContinue
                (Get-Item -LiteralPath $dest).IsReadOnly = $true
                Write-Log "   $($e.Nom) installee et verifiee."
                [void]$ok.Add($e)
            } catch {
                Write-Log "   $($e.Nom) : echec ($($_.Exception.Message))." 'Tomato'
                Remove-Item -LiteralPath $tmp -Force -ErrorAction SilentlyContinue
            }
        }
    }
    $script:SourceAction = $null
    $m = Lire-Maj; $m.Ignorees = @(@($m.Ignorees) | Where-Object { @($ok | ForEach-Object { $_.Nom }) -notcontains $_ }); Sauver-Maj $m
    Remplir-Versions
    Maj-ZoneMaj
    $plus = @($ok | Where-Object { $_.Nouvelle } | Sort-Object Ver -Descending) | Select-Object -First 1
    if ($ProposerUtiliser -and $plus) {
        if ($Direct -or (Ask-YesNo "OptiGame v$($plus.Version) est installee.`r`n`r`nPasser a cette version maintenant ? (OptiGame redemarre, tes reglages sont gardes)")) {
            $e2 = Lire-EtatVersions
            Sauver-EtatVersions $plus.Nom (@($e2.Vues) + @(Lister-Versions | ForEach-Object { $_.Name }))
            $script:Relance = Join-Path $dossier $plus.Nom
            $script:ForcerFermeture = $true
            $UI.Fenetre.Close()
        }
    } elseif ($ok.Count) { Afficher-Toast "$($ok.Count) version(s) installee(s)." }
}

function Ignorer-Version([string]$nom, [bool]$ignorer) {
    $m = Lire-Maj
    $l = @(@($m.Ignorees) | Where-Object { $_ -ne $nom })
    if ($ignorer) { $l += $nom }
    $m.Ignorees = $l
    Sauver-Maj $m
    Maj-ZoneMaj
}

function Supprimer-VersionLocale([string]$chemin) {
    if (-not $chemin) { return }
    if ($chemin -eq $PSCommandPath) { Show-Info 'C''est la version ouverte : passe d''abord a une autre version.' 'Versions'; return }
    $nom = [IO.Path]::GetFileName($chemin)
    if (-not (Ask-YesNo "Supprimer $nom du dossier Versions ?`r`n(Si elle est en ligne, tu pourras la reinstaller plus tard.)")) { return }
    try {
        $it = Get-Item -LiteralPath $chemin -ErrorAction Stop
        $it.IsReadOnly = $false
        Remove-Item -LiteralPath $chemin -Force -ErrorAction Stop
        Write-Log "Version supprimee : $nom." 'Gray'
        # Supprimee volontairement : on ne la repropose pas comme manquante
        if (@($script:Distant | Where-Object { $_.nom -eq $nom }).Count) { Ignorer-Version $nom $true }
        Afficher-Toast "$nom supprimee."
    } catch { Show-Info "Impossible de supprimer $nom : $($_.Exception.Message)" 'Versions' }
    Remplir-Versions
    Maj-ZoneMaj
}

# ----------------------------- OPERATEUR -----------------------------
function Lire-Op {
    if (-not (Test-Path $FichierOp)) { return $null }
    try {
        $j = Get-Content $FichierOp -Raw | ConvertFrom-Json
        $sec = ConvertTo-SecureString "$($j.Jeton)" -ErrorAction Stop
        $jeton = [Runtime.InteropServices.Marshal]::PtrToStringBSTR([Runtime.InteropServices.Marshal]::SecureStringToBSTR($sec))
        $br = if ($j.Branche) { "$($j.Branche)" } else { 'main' }
        return [pscustomobject]@{ Depot = "$($j.Depot)"; Branche = $br; Jeton = $jeton }
    } catch { return $null }
}
function Op-Configure { return (Test-Path $FichierOp) }
function Url-Manifest($op) { return "https://raw.githubusercontent.com/$($op.Depot)/$($op.Branche)/manifest.json" }

function Op-Api([string]$methode, [string]$url, $corps) {
    $op = Lire-Op
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $h = @{ Authorization = "Bearer $($op.Jeton)"; 'User-Agent' = 'OptiGame'; Accept = 'application/vnd.github+json' }
    $p = @{ Method = $methode; Uri = $url; Headers = $h; ErrorAction = 'Stop'; TimeoutSec = 60 }
    if ($null -ne $corps) { $p.Body = [Text.Encoding]::UTF8.GetBytes(($corps | ConvertTo-Json -Depth 6)); $p.ContentType = 'application/json; charset=utf-8' }
    return Invoke-RestMethod @p
}
function Op-Lire([string]$chemin) {
    $op = Lire-Op
    try {
        $r = Op-Api 'GET' "https://api.github.com/repos/$($op.Depot)/contents/$chemin`?ref=$($op.Branche)" $null
        return [pscustomobject]@{ Sha = $r.sha; Texte = [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String(("$($r.content)" -replace '\s', ''))) }
    } catch {
        if ("$($_.Exception.Message)" -match '404') { return $null }
        throw
    }
}
function Op-Ecrire([string]$chemin, [byte[]]$octets, [string]$message) {
    $op = Lire-Op
    $ex = Op-Lire $chemin
    $corps = @{ message = $message; content = [Convert]::ToBase64String($octets); branch = $op.Branche }
    if ($ex) { $corps.sha = $ex.Sha }
    [void](Op-Api 'PUT' "https://api.github.com/repos/$($op.Depot)/contents/$chemin" $corps)
}
function Op-Supprimer([string]$chemin, [string]$message) {
    $op = Lire-Op
    $ex = Op-Lire $chemin
    if (-not $ex) { return }
    [void](Op-Api 'DELETE' "https://api.github.com/repos/$($op.Depot)/contents/$chemin" @{ message = $message; sha = $ex.Sha; branch = $op.Branche })
}
function Op-LireManifest {
    $m = Op-Lire 'manifest.json'
    if (-not $m) { return @() }
    try { return @((ConvertFrom-Json $m.Texte).versions | Where-Object { $_.nom }) } catch { return @() }
}
function Op-EcrireManifest($versions) {
    $tri = @($versions | Sort-Object { Version-Texte "$($_.version)" } -Descending)
    $json = ([pscustomobject]@{ app = 'OptiGame'; maj = (Get-Date).ToString('yyyy-MM-dd HH:mm'); versions = @($tri) }) | ConvertTo-Json -Depth 5
    Op-Ecrire 'manifest.json' ([Text.Encoding]::UTF8.GetBytes($json)) 'OptiGame : mise a jour de la liste des versions'
}

function Op-Enregistrer([string]$depot, [string]$jeton) {
    $depot = $depot.Trim().Trim('/') -replace '^https?://github\.com/', ''
    if ($depot -notmatch '^[\w.-]+/[\w.-]+$') { Show-Info "Depot invalide. Ecris-le comme : pseudo/nom-du-depot" 'Mode operateur'; return }
    if (-not $jeton) { Show-Info 'Colle ton jeton GitHub.' 'Mode operateur'; return }
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        $r = Invoke-RestMethod -Uri "https://api.github.com/repos/$depot" -Headers @{ Authorization = "Bearer $jeton"; 'User-Agent' = 'OptiGame'; Accept = 'application/vnd.github+json' } -ErrorAction Stop -TimeoutSec 20
        if ($r.private) { Show-Info "Ce depot est prive : tes amis ne pourront pas telecharger.`r`nSur GitHub : Settings > General > Danger Zone > Change visibility > Public." 'Mode operateur'; return }
        if ($r.permissions -and -not $r.permissions.push) { Show-Info 'Ce jeton ne peut pas ecrire dans le depot (droit Contents : Read and write).' 'Mode operateur'; return }
        $br = if ($r.default_branch) { "$($r.default_branch)" } else { 'main' }
    } catch { Show-Info "Connexion a GitHub impossible :`r`n$($_.Exception.Message)`r`n`r`nVerifie le nom du depot et le jeton." 'Mode operateur'; return }
    $enc = ConvertTo-SecureString $jeton -AsPlainText -Force | ConvertFrom-SecureString
    New-Item -ItemType Directory -Path (Split-Path $FichierOp) -Force | Out-Null
    ([pscustomobject]@{ Depot = $depot; Branche = $br; Jeton = $enc }) | ConvertTo-Json | Out-File -FilePath $FichierOp -Encoding UTF8
    $m = Lire-Maj; $m.Source = Url-Manifest (Lire-Op); Sauver-Maj $m
    Write-Log "Mode operateur active : depot $depot." 'White'
    Afficher-Toast 'Mode operateur active.'
    Maj-ZoneMaj
}

# Ajoute le lien des mises a jour dans l'en-tete du fichier (les amis sont configures automatiquement)
function Op-Tamponner([string]$chemin, [string]$url) {
    $c = Lire-Fichier $chemin
    if ($c.Texte -match '(?m)^#\s*OptiGame source\s*:') {
        $t = [regex]::Replace($c.Texte, '(?m)^#\s*OptiGame source\s*:.*$', "# OptiGame source: $url")
    } elseif ($c.Texte -match '(?m)^#\s*OptiGame version\s*:.*$') {
        $t = $c.Texte.Insert($c.Texte.IndexOf("`n", $c.Texte.IndexOf($Matches[0])) + 1, "# OptiGame source: $url`r`n")
    } else { return }
    if ($t -eq $c.Texte) { return }
    $it = Get-Item -LiteralPath $chemin
    $ro = $it.IsReadOnly; $it.IsReadOnly = $false
    [IO.File]::WriteAllText($chemin, $t, (New-Object Text.UTF8Encoding($true)))
    if ($ro) { (Get-Item -LiteralPath $chemin).IsReadOnly = $true }
}

function Op-Publier($fichiers) {
    $op = Lire-Op
    if (-not $op) { Show-Info 'Mode operateur non configure.' 'Mode operateur'; return }
    $fichiers = @($fichiers | Where-Object { $_.Name -match '^OptiGame_v\d+(\.\d+)*\.ps1$' })
    if ($fichiers.Count -eq 0) { Show-Info 'Seules les versions nommees OptiGame_vX.X.ps1 peuvent etre publiees.' 'Mode operateur'; return }
    $url = Url-Manifest $op
    Invoke-Action "Publication de $($fichiers.Count) version(s)" {
        $liste = [System.Collections.ArrayList]@(Op-LireManifest)
        foreach ($f in $fichiers) {
            Write-Log "Publication de $($f.Name)..."
            Op-Tamponner $f.FullName $url
            $octets = [IO.File]::ReadAllBytes($f.FullName)
            Op-Ecrire "versions/$($f.Name)" $octets "OptiGame : publication de $($f.Name)"
            $notes = @(Get-Content -LiteralPath $f.FullName -TotalCount 40 | Where-Object { $_ -match '^#\s*NOTE\s*:' } | ForEach-Object { ($_ -replace '^#\s*NOTE\s*:\s*', '').Trim() } | Select-Object -First 2) -join ' '
            if ($notes.Length -gt 300) { $notes = $notes.Substring(0, 297) + '...' }
            $v = (Version-DeNom $f.Name).ToString()
            foreach ($x in @($liste | Where-Object { $_.nom -eq $f.Name })) { $liste.Remove($x) }
            [void]$liste.Add([pscustomobject]@{ nom = $f.Name; version = $v; sha256 = (Empreinte $f.FullName); date = (Get-Date).ToString('yyyy-MM-dd'); notes = $notes
                url = "https://raw.githubusercontent.com/$($op.Depot)/$($op.Branche)/versions/$([uri]::EscapeDataString($f.Name))" })
            Write-Log "   $($f.Name) en ligne."
        }
        Op-EcrireManifest $liste
        Write-Log 'Liste des versions en ligne mise a jour. Tes amis la verront a leur prochain lancement d''OptiGame (ou en cliquant sur Verifier).' 'Gold'
    }
    $m = Lire-Maj; if (-not $m.Source) { $m.Source = $url; Sauver-Maj $m }
    Remplir-Versions
    Demarrer-VerifMaj
}

function Op-Retirer([string]$nom) {
    if (-not (Ask-YesNo "Retirer $nom de la distribution ?`r`nTes amis ne la verront plus (elle reste sur leur PC s'ils l'ont deja).")) { return }
    Invoke-Action "Retrait de $nom" {
        $liste = @(Op-LireManifest | Where-Object { $_.nom -ne $nom })
        Op-EcrireManifest $liste
        Op-Supprimer "versions/$nom" "OptiGame : retrait de $nom"
        Write-Log "   $nom retiree de la distribution."
    }
    Demarrer-VerifMaj
}

function Maj-ZoneOp {
    if (-not $UI.TxtOpEtat) { return }
    $op = $null
    if (Op-Configure) { $op = Lire-Op }
    $conf = [bool]$op
    foreach ($n in 'BtnOpPublier', 'BtnOpPublierTout', 'BtnOpRetirer', 'BtnOpLien', 'BtnOpQuitter', 'BtnOpTestAmi') { $UI[$n].Visibility = $(if ($conf) { 'Visible' } else { 'Collapsed' }) }
    $UI.BtnOpDevenir.Visibility = $(if ($conf -or $UI.ZoneOpConfig.Visibility -eq 'Visible') { 'Collapsed' } else { 'Visible' })
    if ($conf) {
        $UI.ZoneOpConfig.Visibility = 'Collapsed'
        $UI.TxtOpEtat.Text = "Tu es l'operateur (depot $($op.Depot)). Selectionne une version a gauche puis Publier : tes amis la recevront a leur prochain lancement d'OptiGame."
    } elseif (Op-Configure) {
        $UI.TxtOpEtat.Text = 'Configuration de l''operateur illisible sur ce PC : reconfigure-la.'
    } else {
        $UI.TxtOpEtat.Text = 'Pour envoyer les nouvelles versions a tes amis sans leur envoyer de fichier. Reserve a celui qui publie OptiGame.'
    }
}

# =====================================================================
#  MODE OLED : rend tout l'ecran le plus proche possible d'un ecran OLED
#  (noirs purs partout, Windows sombre, fond noir, contraste des noirs renforce)
#  Tout est note pour etre remis exactement comme avant.
# =====================================================================
$FichierOled = Join-Path $env:ProgramData 'OptiGame\oled.json'
$CodeOled = @'
using System;
using System.Runtime.InteropServices;
public static class OGOled
{
    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
    struct DISPLAY_DEVICE { public int cb; [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 32)] public string DeviceName;
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 128)] public string DeviceString; public int StateFlags;
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 128)] public string DeviceID; [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 128)] public string DeviceKey; }
    [DllImport("user32.dll", CharSet = CharSet.Unicode)] static extern bool EnumDisplayDevices(string dev, int i, ref DISPLAY_DEVICE dd, int flags);
    [DllImport("gdi32.dll", CharSet = CharSet.Unicode)] static extern IntPtr CreateDC(string driver, string device, string output, IntPtr init);
    [DllImport("gdi32.dll")] static extern bool DeleteDC(IntPtr dc);
    [DllImport("gdi32.dll")] static extern bool SetDeviceGammaRamp(IntPtr dc, ushort[] ramp);
    [DllImport("user32.dll", CharSet = CharSet.Unicode)] static extern bool SystemParametersInfo(int action, int param, string vparam, int winIni);
    [DllImport("user32.dll")] static extern bool SetSysColors(int n, int[] elements, int[] colors);
    [DllImport("user32.dll", CharSet = CharSet.Unicode)] static extern IntPtr SendMessageTimeout(IntPtr hwnd, int msg, IntPtr w, string l, int flags, int timeout, out IntPtr result);

    // gamma = 1.0 : normal ; gamma > 1 : noirs plus profonds, contraste renforce dans les ombres
    public static int Gamma(double gamma)
    {
        ushort[] ramp = new ushort[768];
        for (int i = 0; i < 256; i++)
        {
            double v = Math.Pow(i / 255.0, gamma) * 65535.0;
            ushort u = (ushort)Math.Max(0, Math.Min(65535, v));
            ramp[i] = u; ramp[256 + i] = u; ramp[512 + i] = u;
        }
        int ok = 0;
        DISPLAY_DEVICE d = new DISPLAY_DEVICE(); d.cb = Marshal.SizeOf(d);
        for (int i = 0; EnumDisplayDevices(null, i, ref d, 0); i++)
        {
            if ((d.StateFlags & 1) != 0)
            {
                IntPtr dc = CreateDC(null, d.DeviceName, null, IntPtr.Zero);
                if (dc != IntPtr.Zero) { if (SetDeviceGammaRamp(dc, ramp)) ok++; DeleteDC(dc); }
            }
            d = new DISPLAY_DEVICE(); d.cb = Marshal.SizeOf(d);
        }
        return ok;
    }
    public static void FondUni(int rgb)
    {
        SetSysColors(1, new int[] { 1 }, new int[] { rgb });
    }
    public static void FondImage(string chemin)
    {
        SystemParametersInfo(0x0014, 0, chemin, 0x01 | 0x02);
    }
    public static void PrevenirWindows()
    {
        IntPtr r;
        SendMessageTimeout(new IntPtr(0xFFFF), 0x001A, IntPtr.Zero, "ImmersiveColorSet", 0x0002, 1000, out r);
    }
}
'@
$CleTheme = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize'

function Oled-Actif { return (Test-Path $FichierOled) }

function Activer-Oled {
    if (Oled-Actif) { return }
    Charger-Type 'OGOled' $CodeOled
    $t = Lire-Theme
    $avant = [ordered]@{
        Apps = Lire-Reg $CleTheme 'AppsUseLightTheme'; Systeme = Lire-Reg $CleTheme 'SystemUsesLightTheme'
        Transparence = Lire-Reg $CleTheme 'EnableTransparency'
        FondImage = "$(Lire-Reg 'HKCU:\Control Panel\Desktop' 'WallPaper')"; FondCouleur = "$(Lire-Reg 'HKCU:\Control Panel\Colors' 'Background')"
        FondOptiGame = "$($t.Fond)"
    }
    $script:SourceAction = 'Bouton Activer le mode OLED (page Ecran)'
    Invoke-Action 'Mode OLED' {
        Write-Log '   Windows en mode sombre (applis et barre des taches)...'
        Set-Reg $CleTheme 'AppsUseLightTheme' 0
        Set-Reg $CleTheme 'SystemUsesLightTheme' 0
        Ajouter-Journal 'Mode sombre de Windows' $(if ("$($avant.Apps)" -eq '0') { 'Sombre' } else { 'Clair' }) 'Sombre' 'Menus, barre des taches et applis en noir : comme un ecran OLED.'
        Set-Reg $CleTheme 'EnableTransparency' 0
        Write-Log '   Fond d''ecran noir uni...'
        Set-Reg 'HKCU:\Control Panel\Colors' 'Background' '0 0 0' 'String'
        Set-Reg 'HKCU:\Control Panel\Desktop' 'WallPaper' '' 'String'
        [OGOled]::FondUni(0)
        [OGOled]::FondImage('')
        Ajouter-Journal 'Fond d''ecran' $(if ($avant.FondImage) { [IO.Path]::GetFileName($avant.FondImage) } else { 'Couleur unie' }) 'Noir pur' 'Un ecran OLED eteint ses pixels sur le noir : ici, le fond est noir pur.'
        Write-Log '   Contraste des noirs renforce...'
        $n = [OGOled]::Gamma((Gamma-Oled))
        if ($n -gt 0) { Ajouter-Journal 'Contraste des noirs (courbe gamma)' 'Normal' 'Renforce' 'Les gris tres sombres deviennent plus noirs, comme sur un OLED. Remis a la desactivation du mode.' }
        else { Write-Log '   Ta carte graphique refuse la courbe gamma : le reste du mode OLED est actif.' 'Gold' }
        [OGOled]::PrevenirWindows()
        New-Item -ItemType Directory -Path (Split-Path $FichierOled) -Force | Out-Null
        ([pscustomobject]$avant) | ConvertTo-Json | Out-File -FilePath $FichierOled -Encoding UTF8
    }
    $script:SourceAction = $null
    # OptiGame aussi en noir pur
    $t.Fond = 'noir'; Sauver-Theme $t
    try { Appliquer-ThemeDirect $t } catch {}
    Maj-Oled
    Afficher-Toast 'Mode OLED active.'
}

function Desactiver-Oled {
    if (-not (Oled-Actif)) { return }
    Charger-Type 'OGOled' $CodeOled
    $a = Get-Content $FichierOled -Raw | ConvertFrom-Json
    $script:SourceAction = 'Bouton Desactiver le mode OLED (page Ecran)'
    Invoke-Action 'Retour a l''affichage normal' {
        if ($null -ne $a.Apps) { Set-Reg $CleTheme 'AppsUseLightTheme' ([int]$a.Apps) } else { Remove-Reg $CleTheme 'AppsUseLightTheme' }
        if ($null -ne $a.Systeme) { Set-Reg $CleTheme 'SystemUsesLightTheme' ([int]$a.Systeme) } else { Remove-Reg $CleTheme 'SystemUsesLightTheme' }
        if ($null -ne $a.Transparence) { Set-Reg $CleTheme 'EnableTransparency' ([int]$a.Transparence) }
        Ajouter-Journal 'Mode sombre de Windows' 'Sombre' $(if ("$($a.Apps)" -eq '0') { 'Sombre' } else { 'Clair' })
        if ($a.FondCouleur) {
            Set-Reg 'HKCU:\Control Panel\Colors' 'Background' "$($a.FondCouleur)" 'String'
            $c = "$($a.FondCouleur)".Split(' ') | ForEach-Object { [int]$_ }
            if ($c.Count -eq 3) { [OGOled]::FondUni($c[0] + 256 * $c[1] + 65536 * $c[2]) }
        }
        Set-Reg 'HKCU:\Control Panel\Desktop' 'WallPaper' "$($a.FondImage)" 'String'
        [OGOled]::FondImage("$($a.FondImage)")
        Ajouter-Journal 'Fond d''ecran' 'Noir pur' $(if ($a.FondImage) { [IO.Path]::GetFileName("$($a.FondImage)") } else { 'Couleur unie' })
        [void][OGOled]::Gamma(1.0)
        Ajouter-Journal 'Contraste des noirs (courbe gamma)' 'Renforce' 'Normal'
        [OGOled]::PrevenirWindows()
        Write-Log '   Affichage remis comme avant.'
    }
    $script:SourceAction = $null
    Remove-Item -LiteralPath $FichierOled -Force -ErrorAction SilentlyContinue
    $t = Lire-Theme
    if ($a.FondOptiGame) { $t.Fond = "$($a.FondOptiGame)" } else { $t.Fond = 'sombre' }
    Sauver-Theme $t
    try { Appliquer-ThemeDirect $t } catch {}
    Maj-Oled
    Afficher-Toast 'Affichage normal remis.' 'info'
}

# La courbe gamma est remise a zero par Windows (veille, changement d'ecran...) : on la reapplique
function Reappliquer-GammaOled {
    if (-not (Oled-Actif)) { return }
    try { Charger-Type 'OGOled' $CodeOled; [void][OGOled]::Gamma((Gamma-Oled)) } catch {}
}

function Maj-Oled {
    if (-not $UI.TxtOledEtat) { return }
    $on = Oled-Actif
    $UI.TxtOledEtat.Text = if ($on) { 'Mode OLED : ACTIF' } else { 'Mode OLED : desactive' }
    $UI.TxtOledEtat.Foreground = Pinceau $(if ($on) { '#3FE08E' } else { '#8C95A8' })
    $UI.BtnOledOn.Visibility = $(if ($on) { 'Collapsed' } else { 'Visible' })
    $UI.BtnOledOff.Visibility = $(if ($on) { 'Visible' } else { 'Collapsed' })
}

# =====================================================================
#  ECRAN : anti-banding (degrades sans marches)
# =====================================================================
$FichierEcran = Join-Path $env:ProgramData 'OptiGame\ecran.json'
function Lire-ReglagesEcran {
    $r = [ordered]@{ GammaDoux = $false }
    if (Test-Path $FichierEcran) { try { $j = Get-Content $FichierEcran -Raw | ConvertFrom-Json; if ($null -ne $j.GammaDoux) { $r.GammaDoux = [bool]$j.GammaDoux } } catch {} }
    return $r
}
function Sauver-ReglagesEcran($r) {
    New-Item -ItemType Directory -Path (Split-Path $FichierEcran) -Force | Out-Null
    ([pscustomobject]$r) | ConvertTo-Json | Out-File -FilePath $FichierEcran -Encoding UTF8
}
# Courbe du mode OLED : 1.18 = noirs tres profonds ; 1.08 = plus doux (beaucoup moins de marches dans les ombres)
function Gamma-Oled { if ((Lire-ReglagesEcran).GammaDoux) { return 1.08 } else { return 1.18 } }

# Lit ce que la carte graphique envoie vraiment a chaque ecran (nuances par couleur + format)
$CodeCouleursEcran = @'
using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;
public static class OGCouleursEcran {
    [StructLayout(LayoutKind.Sequential)] struct LUID { public uint Low; public int High; }
    [StructLayout(LayoutKind.Sequential)] struct SOURCE { public LUID adapterId; public uint id; public uint modeInfoIdx; public uint statusFlags; }
    [StructLayout(LayoutKind.Sequential)] struct TARGET { public LUID adapterId; public uint id; public uint modeInfoIdx; public int tech; public int rotation; public int scaling; public uint rateNum; public uint rateDen; public int scan; public int available; public uint statusFlags; }
    [StructLayout(LayoutKind.Sequential)] struct PATH { public SOURCE source; public TARGET target; public uint flags; }
    [StructLayout(LayoutKind.Sequential)] struct MODE { public int infoType; public uint id; public LUID adapterId;
        public uint a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11; }
    [StructLayout(LayoutKind.Sequential)] struct HEADER { public int type; public uint size; public LUID adapterId; public uint id; }
    [StructLayout(LayoutKind.Sequential)] struct COLORINFO { public HEADER header; public uint value; public int encoding; public uint bits; }
    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)] struct NAME { public HEADER header; public uint flags; public int tech;
        public ushort manuf; public ushort product; public uint connector;
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 64)] public string friendly;
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 128)] public string path; }
    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)] struct SOURCENAME { public HEADER header;
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 32)] public string gdi; }
    [StructLayout(LayoutKind.Explicit, Size = 80)] struct PREF { [FieldOffset(0)] public HEADER header; [FieldOffset(20)] public uint width; [FieldOffset(24)] public uint height; }
    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
    public struct DEVMODE {
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 32)] public string dmDeviceName;
        public short dmSpecVersion, dmDriverVersion, dmSize, dmDriverExtra;
        public int dmFields, dmPositionX, dmPositionY, dmDisplayOrientation, dmDisplayFixedOutput;
        public short dmColor, dmDuplex, dmYResolution, dmTTOption, dmCollate;
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 32)] public string dmFormName;
        public short dmLogPixels;
        public int dmBitsPerPel, dmPelsWidth, dmPelsHeight, dmDisplayFlags, dmDisplayFrequency;
        public int dmICMMethod, dmICMIntent, dmMediaType, dmDitherType, dmReserved1, dmReserved2, dmPanningWidth, dmPanningHeight;
    }
    [DllImport("user32.dll")] static extern int GetDisplayConfigBufferSizes(uint flags, out uint nPath, out uint nMode);
    [DllImport("user32.dll")] static extern int QueryDisplayConfig(uint flags, ref uint nPath, [Out] PATH[] paths, ref uint nMode, [Out] MODE[] modes, IntPtr topo);
    [DllImport("user32.dll")] static extern int DisplayConfigGetDeviceInfo(ref COLORINFO info);
    [DllImport("user32.dll")] static extern int DisplayConfigGetDeviceInfo(ref NAME info);
    [DllImport("user32.dll")] static extern int DisplayConfigGetDeviceInfo(ref SOURCENAME info);
    [DllImport("user32.dll")] static extern int DisplayConfigGetDeviceInfo(ref PREF info);
    [DllImport("user32.dll", CharSet = CharSet.Unicode)] static extern bool EnumDisplaySettings(string dev, int mode, ref DEVMODE dm);
    [DllImport("user32.dll")] static extern bool SystemParametersInfo(int action, int param, IntPtr vparam, int winIni);
    [DllImport("user32.dll", CharSet = CharSet.Unicode)] static extern int ChangeDisplaySettingsEx(string dev, ref DEVMODE dm, IntPtr hwnd, int flags, IntPtr param);

    // Une ligne par ecran : nom|bits par couleur|format (0 RGB, 1 YCbCr444, 2 YCbCr422, 3 YCbCr420)|HDR (0/1)|nom Windows (\\.\DISPLAY1)|largeur native|hauteur native
    public static string[] Lire() {
        List<string> r = new List<string>();
        uint np, nm;
        if (GetDisplayConfigBufferSizes(2, out np, out nm) != 0) return r.ToArray();
        PATH[] paths = new PATH[np]; MODE[] modes = new MODE[nm];
        if (QueryDisplayConfig(2, ref np, paths, ref nm, modes, IntPtr.Zero) != 0) return r.ToArray();
        for (int i = 0; i < np; i++) {
            NAME n = new NAME();
            n.header.type = 2; n.header.size = (uint)Marshal.SizeOf(typeof(NAME));
            n.header.adapterId = paths[i].target.adapterId; n.header.id = paths[i].target.id;
            string nom = (DisplayConfigGetDeviceInfo(ref n) == 0 && !string.IsNullOrEmpty(n.friendly)) ? n.friendly : ("Ecran " + (i + 1));
            COLORINFO c = new COLORINFO();
            c.header.type = 9; c.header.size = (uint)Marshal.SizeOf(typeof(COLORINFO));
            c.header.adapterId = paths[i].target.adapterId; c.header.id = paths[i].target.id;
            string coul = (DisplayConfigGetDeviceInfo(ref c) == 0) ? (c.bits + "|" + c.encoding + "|" + (((c.value & 2) != 0) ? 1 : 0)) : "0|-1|0";
            SOURCENAME s = new SOURCENAME();
            s.header.type = 1; s.header.size = (uint)Marshal.SizeOf(typeof(SOURCENAME));
            s.header.adapterId = paths[i].source.adapterId; s.header.id = paths[i].source.id;
            string gdi = (DisplayConfigGetDeviceInfo(ref s) == 0) ? s.gdi : "";
            PREF p = new PREF();
            p.header.type = 3; p.header.size = 80;
            p.header.adapterId = paths[i].target.adapterId; p.header.id = paths[i].target.id;
            string pref = (DisplayConfigGetDeviceInfo(ref p) == 0) ? (p.width + "|" + p.height) : "0|0";
            r.Add(nom + "|" + coul + "|" + gdi + "|" + pref);
        }
        return r.ToArray();
    }

    // Lissage du texte : true = ClearType (texte net), false = lissage standard
    public static void ClearType(bool on) {
        SystemParametersInfo(0x004B, 1, IntPtr.Zero, 3);
        SystemParametersInfo(0x200B, 0, new IntPtr(on ? 2 : 1), 3);
    }
    // largeur, hauteur, Hz actuels
    public static int[] Actuel(string dev) {
        DEVMODE dm = new DEVMODE(); dm.dmSize = (short)Marshal.SizeOf(typeof(DEVMODE));
        if (!EnumDisplaySettings(dev, -1, ref dm)) return null;
        return new int[] { dm.dmPelsWidth, dm.dmPelsHeight, dm.dmDisplayFrequency };
    }
    // Plus haute frequence proposee par l'ecran a cette resolution
    public static int MaxHz(string dev, int w, int h) {
        DEVMODE m = new DEVMODE(); m.dmSize = (short)Marshal.SizeOf(typeof(DEVMODE));
        int max = 0;
        for (int i = 0; EnumDisplaySettings(dev, i, ref m); i++)
            if (m.dmPelsWidth == w && m.dmPelsHeight == h && m.dmBitsPerPel >= 32 && m.dmDisplayFrequency > max) max = m.dmDisplayFrequency;
        return max;
    }
    // Change resolution + frequence (0 = reussi)
    public static int Appliquer(string dev, int w, int h, int hz) {
        DEVMODE dm = new DEVMODE(); dm.dmSize = (short)Marshal.SizeOf(typeof(DEVMODE));
        if (!EnumDisplaySettings(dev, -1, ref dm)) return -99;
        dm.dmPelsWidth = w; dm.dmPelsHeight = h; dm.dmDisplayFrequency = hz;
        dm.dmFields = 0x80000 | 0x100000 | 0x400000;
        return ChangeDisplaySettingsEx(dev, ref dm, IntPtr.Zero, 0x01, IntPtr.Zero);
    }
}
'@

function Ligne-Ecran([string]$texte, [string]$couleur, [bool]$gras = $false) {
    $t = New-Object System.Windows.Controls.TextBlock
    $t.Text = $texte; $t.TextWrapping = 'Wrap'; $t.FontSize = 12.5; $t.Margin = '0,0,0,4'
    $t.Foreground = Pinceau $couleur
    if ($gras) { $t.FontWeight = 'SemiBold'; $t.FontSize = 13.5; $t.Margin = '0,6,0,3' }
    [void]$UI.PanBandEcran.Children.Add($t)
}

function Analyser-Ecrans {
    if (-not $UI.PanBandEcran) { return }
    $UI.PanBandEcran.Children.Clear()
    $lignes = @()
    try { Charger-Type 'OGCouleursEcran' $CodeCouleursEcran; $lignes = @([OGCouleursEcran]::Lire()) } catch {}
    if ($lignes.Count -eq 0) { Ligne-Ecran 'Impossible de lire les reglages de tes ecrans (Windows ne donne pas l''info). Suis le guide ci-dessous.' '#FFC24B'; return }
    $formats = @{ '0' = 'RGB'; '1' = 'YCbCr 4:4:4'; '2' = 'YCbCr 4:2:2'; '3' = 'YCbCr 4:2:0'; '4' = 'Intensite' }
    $problemes = 0
    foreach ($l in $lignes) {
        $p = $l.Split('|')
        $nom = $p[0]; $bits = [int]$p[1]; $enc = $p[2]; $hdr = $p[3] -eq '1'
        $fmt = if ($formats.ContainsKey($enc)) { $formats[$enc] } else { 'inconnu' }
        Ligne-Ecran "$nom  -  $(if ($bits) { "$bits bits par couleur" } else { 'nuances inconnues' }), format $fmt$(if ($hdr) { ', HDR actif' })" '#E9ECF2' $true
        switch ($enc) {
            '0' { Ligne-Ecran '   OK Format RGB : les couleurs arrivent completes a l''ecran.' '#3FE08E' }
            '1' { Ligne-Ecran '   ~  YCbCr 4:4:4 : correct, mais RGB 4:4:4 (Full RGB) est meilleur sur PC (noirs plus justes). Etape 3 du guide.' '#FFC24B'; $problemes++ }
            '2' { Ligne-Ecran '   X  YCbCr 4:2:2 : les couleurs sont compressees avant d''arriver a l''ecran, ca cree des marches. Mets RGB 4:4:4 (etape 3).' '#FF8A97'; $problemes++ }
            '3' { Ligne-Ecran '   X  YCbCr 4:2:0 : couleurs tres compressees, beaucoup de banding. Mets RGB 4:4:4 (etape 3).' '#FF8A97'; $problemes++ }
        }
        if ($bits -ge 10) { Ligne-Ecran "   OK $bits bits : plus de 1 milliard de couleurs, les degrades sont les plus lisses possibles." '#3FE08E' }
        elseif ($bits -eq 8) { Ligne-Ecran '   ~  8 bits (16 millions de couleurs) : normal. Si AMD Software propose 10 bpc pour cet ecran, choisis-le (etape 4) : les degrades seront plus doux.' '#C9CFDA' }
        elseif ($bits -gt 0) { Ligne-Ecran "   X  $bits bits seulement : peu de nuances, banding visible. Monte la profondeur de couleur (etape 4)." '#FF8A97'; $problemes++ }
    }
    if (Oled-Actif) {
        if ((Lire-ReglagesEcran).GammaDoux) { Ligne-Ecran 'Mode OLED actif avec les noirs doux : bon reglage contre le banding.' '#3FE08E' }
        else { Ligne-Ecran 'Mode OLED actif avec les noirs profonds : ca accentue les marches dans les ombres. Active "Noirs plus doux" au-dessus.' '#FFC24B'; $problemes++ }
    }
    if ($problemes -eq 0) { Ligne-Ecran 'Rien sur ton PC n''aggrave le banding. S''il reste des marches, elles viennent de la video elle-meme : utilise le lissage (partie 2).' '#8C95A8' }
}

# Plein ecran de degrades pour voir le banding a l'oeil
function Tester-Degrades {
    $f = New-Object System.Windows.Window
    $f.WindowStyle = 'None'; $f.WindowState = 'Maximized'; $f.ResizeMode = 'NoResize'; $f.Topmost = $true
    $f.Background = [System.Windows.Media.Brushes]::Black; $f.Cursor = [System.Windows.Input.Cursors]::Hand
    $g = New-Object System.Windows.Controls.Grid
    $bandes = @(@('#000000', '#FFFFFF'), @('#000000', '#404040'), @('#000000', '#FF0000'), @('#000000', '#00FF00'), @('#000000', '#0000FF'), @('#000000', '#FFB070'))
    foreach ($b in $bandes) {
        $r = New-Object System.Windows.Controls.RowDefinition; $g.RowDefinitions.Add($r)
        $z = New-Object System.Windows.Shapes.Rectangle
        $z.Fill = New-Object System.Windows.Media.LinearGradientBrush ([System.Windows.Media.ColorConverter]::ConvertFromString($b[0])), ([System.Windows.Media.ColorConverter]::ConvertFromString($b[1])), 0
        [System.Windows.Controls.Grid]::SetRow($z, $g.Children.Count)
        [void]$g.Children.Add($z)
    }
    $t = New-Object System.Windows.Controls.TextBlock
    $t.Text = 'Regarde les degrades : un fondu lisse = parfait. Des bandes avec des limites nettes = banding (surtout dans la 2e bande, la plus sombre).   Echap ou clic pour fermer'
    $t.Foreground = [System.Windows.Media.Brushes]::White; $t.Background = Pinceau '#B0000000'; $t.Padding = '14,8'; $t.FontSize = 14
    $t.HorizontalAlignment = 'Center'; $t.VerticalAlignment = 'Top'; $t.Margin = '0,20,0,0'
    [System.Windows.Controls.Grid]::SetRowSpan($t, $bandes.Count)
    [void]$g.Children.Add($t)
    $f.Content = $g
    $f.Add_KeyDown({ param($s, $e) if ($e.Key -eq 'Escape') { $s.Close() } })
    $f.Add_MouseLeftButtonDown({ param($s, $e) $s.Close() })
    [void]$f.ShowDialog()
}

function Ouvrir-AmdSoftware {
    $exe = @("$env:ProgramFiles\AMD\CNext\CNext\RadeonSoftware.exe", "$env:ProgramFiles\AMD\CNext\CNext\RadeonSettings.exe") | Where-Object { Test-Path $_ } | Select-Object -First 1
    if ($exe) { Start-Process $exe; return }
    Show-Info "AMD Software est introuvable sur ce PC.`r`n`r`nClic droit sur le Bureau > AMD Software: Adrenalin Edition. S'il n'y est pas, installe-le depuis amd.com/fr/support (pilote de ta carte graphique)." 'Ecran'
}

# ---------- Lissage des degrades dans mpv (filtre "deband") ----------
$DossierMpv = Join-Path $env:APPDATA 'mpv'
$ConfMpv = Join-Path $DossierMpv 'mpv.conf'
$DebutMpv = '# --- OptiGame : lissage des degrades (anti-banding) ---'
$FinMpv = '# --- fin OptiGame ---'
function Mpv-Installe {
    if (Get-Command mpv.exe -ErrorAction SilentlyContinue) { return $true }
    foreach ($c in @("$env:ProgramFiles\mpv\mpv.exe", "$env:LOCALAPPDATA\Programs\mpv\mpv.exe", "$env:USERPROFILE\scoop\apps\mpv\current\mpv.exe", "$env:ProgramData\chocolatey\bin\mpv.exe")) { if (Test-Path $c) { return $true } }
    return $false
}
function Lissage-Actif { return ((Test-Path $ConfMpv) -and ((Get-Content -LiteralPath $ConfMpv -Raw -ErrorAction SilentlyContinue) -match [regex]::Escape($DebutMpv))) }
function Activer-LissageMpv {
    $bloc = @($DebutMpv,
        'deband=yes',
        'deband-iterations=4',
        'deband-threshold=48',
        'deband-range=24',
        'deband-grain=24',
        'dither-depth=auto',
        'scale=ewa_lanczossharp',
        'cscale=ewa_lanczossharp',
        $FinMpv) -join "`r`n"
    New-Item -ItemType Directory -Path $DossierMpv -Force | Out-Null
    $txt = if (Test-Path $ConfMpv) { Get-Content -LiteralPath $ConfMpv -Raw } else { '' }
    if ($txt -match [regex]::Escape($DebutMpv)) { return }
    if ($txt -and -not $txt.EndsWith("`n")) { $txt += "`r`n" }
    [IO.File]::WriteAllText($ConfMpv, $txt + $bloc + "`r`n", (New-Object Text.UTF8Encoding($false)))
    $script:SourceAction = 'Bouton Activer le lissage des degrades (page Ecran)'
    Ajouter-Journal 'Lissage des degrades (mpv)' 'Desactive' 'Active' 'mpv lisse les marches des degrades (filtre deband), ajoute un tres leger grain qui cache les dernieres limites, et agrandit les videos plus nettement.'
    $script:SourceAction = $null
    Write-Log 'Lissage des degrades active dans mpv.'
    Afficher-Toast 'Lissage des degrades active.'
}
function Desactiver-LissageMpv {
    if (-not (Lissage-Actif)) { return }
    $txt = Get-Content -LiteralPath $ConfMpv -Raw
    $txt = [regex]::Replace($txt, '(?s)' + [regex]::Escape($DebutMpv) + '.*?' + [regex]::Escape($FinMpv) + '\r?\n?', '')
    [IO.File]::WriteAllText($ConfMpv, $txt, (New-Object Text.UTF8Encoding($false)))
    $script:SourceAction = 'Bouton Enlever le lissage (page Ecran)'
    Ajouter-Journal 'Lissage des degrades (mpv)' 'Active' 'Desactive'
    $script:SourceAction = $null
    Afficher-Toast 'Lissage enleve.' 'info'
}
function Maj-Lissage {
    if (-not $UI.TxtBandMpv) { return }
    $on = Lissage-Actif
    $inst = Mpv-Installe
    $UI.TxtBandMpv.Text = if ($on -and $inst) { 'Lissage ACTIF : toutes les videos ouvertes avec mpv ont des degrades lisses (le filtre enleve les marches et ajoute un grain invisible qui cache les dernieres limites).' }
        elseif ($on) { 'Lissage pret : il marchera des que mpv sera installe (bouton Telecharger mpv). Ouvre ensuite tes videos avec mpv.' }
        elseif ($inst) { 'mpv est installe. Active le lissage : les fondus au noir et les degrades des dessins animes seront lisses au lieu d''avoir des marches.' }
        else { 'mpv est un lecteur video gratuit capable d''effacer le banding des videos (filtre deband). Active le lissage ici, installe mpv, puis ouvre tes videos avec lui.' }
    $UI.TxtBandMpv.Foreground = Pinceau $(if ($on) { '#3FE08E' } else { '#C9CFDA' })
    $UI.BtnBandMpv.Visibility = $(if ($on) { 'Collapsed' } else { 'Visible' })
    $UI.BtnBandMpvOff.Visibility = $(if ($on) { 'Visible' } else { 'Collapsed' })
    $UI.BtnBandMpvSite.Visibility = $(if ($inst) { 'Collapsed' } else { 'Visible' })
}
function Maj-PageEcran {
    try { Maj-Oled } catch {}
    try { $script:MajEcranEnCours = $true; $UI.ChkOledDoux.IsChecked = (Lire-ReglagesEcran).GammaDoux } finally { $script:MajEcranEnCours = $false }
    try { Maj-Lissage } catch {}
    try { Analyser-Ecrans } catch {}
    try { Maj-Nettete } catch {}
    try { Maj-QualiteMax } catch {}
}

# =====================================================================
#  ECRAN : image plus nette
# =====================================================================
function Ligne-Net([string]$texte, [string]$couleur, [bool]$gras = $false) {
    $t = New-Object System.Windows.Controls.TextBlock
    $t.Text = $texte; $t.TextWrapping = 'Wrap'; $t.FontSize = 12.5; $t.Margin = '0,0,0,4'
    $t.Foreground = Pinceau $couleur
    if ($gras) { $t.FontWeight = 'SemiBold'; $t.FontSize = 13.5; $t.Margin = '0,6,0,3' }
    [void]$UI.PanNetEcrans.Children.Add($t)
}

# Pour chaque ecran : reglage actuel et reglage le plus net possible
function Plan-Nettete {
    Charger-Type 'OGCouleursEcran' $CodeCouleursEcran
    $r = @()
    foreach ($l in @([OGCouleursEcran]::Lire())) {
        $p = $l.Split('|')
        if ($p.Count -lt 7 -or -not $p[4]) { continue }
        $dev = $p[4]
        $a = [OGCouleursEcran]::Actuel($dev)
        if (-not $a) { continue }
        $nw = [int]$p[5]; $nh = [int]$p[6]
        if ($nw -le 0 -or $nh -le 0 -or [OGCouleursEcran]::MaxHz($dev, $nw, $nh) -le 0) { $nw = $a[0]; $nh = $a[1] }
        $hz = [OGCouleursEcran]::MaxHz($dev, $nw, $nh)
        if ($hz -le 0) { $hz = $a[2] }
        $r += [pscustomobject]@{ Nom = $p[0]; Dev = $dev; W = $a[0]; H = $a[1]; Hz = $a[2]; NW = $nw; NH = $nh; NHz = $hz
            AChanger = ($a[0] -ne $nw -or $a[1] -ne $nh -or $a[2] -lt $hz) }
    }
    return $r
}

function Analyser-Nettete {
    if (-not $UI.PanNetEcrans) { return }
    $UI.PanNetEcrans.Children.Clear()
    $plan = @()
    try { $plan = @(Plan-Nettete) } catch {}
    if ($plan.Count -eq 0) { Ligne-Net 'Impossible de lire tes ecrans. Verifie a la main : Parametres Windows > Affichage > Resolution (celle marquee "recommande") et Affichage avance > Frequence (la plus haute).' '#FFC24B'; return }
    foreach ($e in $plan) {
        Ligne-Net "$($e.Nom)  -  $($e.W) x $($e.H) a $($e.Hz) Hz" '#E9ECF2' $true
        if ($e.W -eq $e.NW -and $e.H -eq $e.NH) { Ligne-Net "   OK Resolution native ($($e.NW) x $($e.NH)) : chaque pixel de l'image = un pixel de l'ecran, rien n'est etire." '#3FE08E' }
        else { Ligne-Net "   X  Pas la resolution de l'ecran : il est fait pour $($e.NW) x $($e.NH). Windows etire l'image, d'ou le flou. Bouton Tout mettre au plus net." '#FF8A97' }
        if ($e.Hz -ge $e.NHz) { Ligne-Net "   OK $($e.Hz) Hz : la frequence la plus haute de cet ecran (le moins de flou quand ca bouge)." '#3FE08E' }
        else { Ligne-Net "   X  $($e.Hz) Hz alors que l'ecran monte a $($e.NHz) Hz : l'image est plus floue en mouvement et moins fluide. Bouton Tout mettre au plus net." '#FF8A97' }
    }
    $UI.BtnNetMax.IsEnabled = [bool]($plan | Where-Object { $_.AChanger })
    $UI.BtnNetMax.Content = if ($UI.BtnNetMax.IsEnabled) { 'Tout mettre au plus net' } else { 'Deja au plus net' }
}

# Petite fenetre "Garder ?" avec retour automatique (si l'ecran ne s'affiche pas bien, on ne peut pas cliquer)
function Confirmer-Ecran([int]$secondes = 15) {
    $f = New-Object System.Windows.Window
    $f.WindowStyle = 'None'; $f.ResizeMode = 'NoResize'; $f.Topmost = $true; $f.SizeToContent = 'WidthAndHeight'
    $f.WindowStartupLocation = 'CenterScreen'; $f.Background = Pinceau '#171B24'; $f.BorderBrush = Pinceau '#2A3140'; $f.BorderThickness = 1
    $sp = New-Object System.Windows.Controls.StackPanel; $sp.Margin = '28,22,28,20'
    $t1 = New-Object System.Windows.Controls.TextBlock; $t1.Text = 'L''image s''affiche bien ?'; $t1.FontSize = 18; $t1.FontWeight = 'SemiBold'; $t1.Foreground = Pinceau '#E9ECF2'
    $t2 = New-Object System.Windows.Controls.TextBlock; $t2.FontSize = 13.5; $t2.Margin = '0,10,0,0'; $t2.Foreground = Pinceau '#C9CFDA'
    $bp = New-Object System.Windows.Controls.StackPanel; $bp.Orientation = 'Horizontal'; $bp.HorizontalAlignment = 'Right'; $bp.Margin = '0,18,0,0'
    $bn = New-Object System.Windows.Controls.Button; $bn.Content = 'Annuler'; $bn.Style = $script:App.Resources['BtnFantome']; $bn.Margin = '0,0,10,0'; $bn.MinWidth = 100
    $bo = New-Object System.Windows.Controls.Button; $bo.Content = 'Garder'; $bo.Style = $script:App.Resources['BtnPrincipal']; $bo.MinWidth = 100
    [void]$bp.Children.Add($bn); [void]$bp.Children.Add($bo)
    [void]$sp.Children.Add($t1); [void]$sp.Children.Add($t2); [void]$sp.Children.Add($bp)
    $f.Content = $sp
    $etat = @{ Garder = $false; Reste = $secondes }
    $t2.Text = "Sans reponse, tout revient comme avant dans $($etat.Reste) s."
    $min = New-Object System.Windows.Threading.DispatcherTimer
    $min.Interval = [TimeSpan]::FromSeconds(1)
    $min.Add_Tick({ $etat.Reste--; if ($etat.Reste -le 0) { $min.Stop(); $f.Close() } else { $t2.Text = "Sans reponse, tout revient comme avant dans $($etat.Reste) s." } }.GetNewClosure())
    $bo.Add_Click({ $etat.Garder = $true; $min.Stop(); $f.Close() }.GetNewClosure())
    $bn.Add_Click({ $min.Stop(); $f.Close() }.GetNewClosure())
    $min.Start()
    [void]$f.ShowDialog()
    return [bool]$etat.Garder
}

function Mettre-AuPlusNet {
    $plan = @(Plan-Nettete | Where-Object { $_.AChanger })
    if ($plan.Count -eq 0) { Afficher-Toast 'Tes ecrans sont deja au plus net.' 'info'; return }
    $faits = @()
    foreach ($e in $plan) {
        $res = [OGCouleursEcran]::Appliquer($e.Dev, $e.NW, $e.NH, $e.NHz)
        if ($res -eq 0) { $faits += $e } else { Write-Log "   $($e.Nom) : Windows a refuse $($e.NW) x $($e.NH) a $($e.NHz) Hz (code $res)." 'Gold' }
    }
    if ($faits.Count -eq 0) { Show-Info 'Windows a refuse le changement. Regle-le a la main : Parametres > Affichage.' 'Ecran'; return }
    Start-Sleep -Milliseconds 600
    if (Confirmer-Ecran 15) {
        $script:SourceAction = 'Bouton Tout mettre au plus net (page Ecran)'
        foreach ($e in $faits) {
            Ajouter-Journal "$($e.Nom) : resolution et frequence" "$($e.W) x $($e.H) a $($e.Hz) Hz" "$($e.NW) x $($e.NH) a $($e.NHz) Hz" 'Resolution native = image nette (rien n''est etire). Frequence maximale = moins de flou quand ca bouge.'
        }
        $script:SourceAction = $null
        Afficher-Toast 'Ecrans regles au plus net.'
    } else {
        foreach ($e in $faits) { [void][OGCouleursEcran]::Appliquer($e.Dev, $e.W, $e.H, $e.Hz) }
        Afficher-Toast 'Reglages d''ecran remis comme avant.' 'info'
    }
    Analyser-Nettete
}

function ClearType-Actif {
    return ("$(Lire-Reg 'HKCU:\Control Panel\Desktop' 'FontSmoothing')" -ne '0' -and "$(Lire-Reg 'HKCU:\Control Panel\Desktop' 'FontSmoothingType')" -ne '1')
}
function Regler-ClearType([bool]$on) {
    Set-Reg 'HKCU:\Control Panel\Desktop' 'FontSmoothing' '2' 'String'
    Set-Reg 'HKCU:\Control Panel\Desktop' 'FontSmoothingType' $(if ($on) { 2 } else { 1 }) 'DWord'
    try { Charger-Type 'OGCouleursEcran' $CodeCouleursEcran; [OGCouleursEcran]::ClearType($on) } catch {}
    $script:SourceAction = 'Case Texte net ClearType (page Ecran)'
    Ajouter-Journal 'Lissage du texte' $(if ($on) { 'Standard' } else { 'ClearType' }) $(if ($on) { 'ClearType (net)' } else { 'Standard' }) 'ClearType lisse les lettres au niveau des sous-pixels de l''ecran : bords plus fins et texte plus net.'
    $script:SourceAction = $null
}
function DpiFlou-Actif { return ("$(Lire-Reg 'HKCU:\Control Panel\Desktop' 'EnablePerProcessSystemDPI')" -eq '1') }
function Regler-DpiFlou([bool]$on) {
    Set-Reg 'HKCU:\Control Panel\Desktop' 'EnablePerProcessSystemDPI' $(if ($on) { 1 } else { 0 }) 'DWord'
    $script:SourceAction = 'Case Corriger les applis floues (page Ecran)'
    Ajouter-Journal 'Correction des applis floues' $(if ($on) { 'Desactivee' } else { 'Activee' }) $(if ($on) { 'Activee' } else { 'Desactivee' }) 'Windows redessine net les applications qui deviennent floues avec une mise a l''echelle differente de 100 %.'
    $script:SourceAction = $null
}
function Ouvrir-ReglagesEdge {
    try { Start-Process 'msedge.exe' 'edge://settings/system' -ErrorAction Stop }
    catch { Show-Info 'Microsoft Edge est introuvable. Ouvre Edge > Parametres > Systeme et performances > Ameliorer les videos.' 'Ecran' }
}
function Maj-Nettete {
    try {
        $script:MajEcranEnCours = $true
        $UI.ChkClearType.IsChecked = ClearType-Actif
        $UI.ChkDpiFlou.IsChecked = DpiFlou-Actif
    } finally { $script:MajEcranEnCours = $false }
    try { Analyser-Nettete } catch {}
}

# =====================================================================
#  ECRAN : bords ultra lisses / qualite visuelle maximale (un bouton pour tous les jeux)
#  Ce sont des options cachees des jeux (pas celles du menu), annulables a tout moment.
# =====================================================================
$OptionsQualiteMax = [ordered]@{
    'Roblox'        = @('Qualite max : bords ultra lisses (anticrenelage MSAA 8x)', 'Qualite max : textures au maximum', 'Qualite max : eclairage le plus realiste (Future)')
    'Rocket League' = @('Qualite max : bords lisses (anticrenelage MSAA 8x)')
    'Palworld'      = @('Qualite max : bords lisses et image accentuee')
}
$OptionCouperMsaa = 'Plus de FPS : couper l''anticrenelage (MSAA)'
$ClesQualiteRoblox = @('FIntDebugForceMSAASamples', 'DFFlagTextureQualityOverrideEnabled', 'DFIntTextureQualityOverride', 'FFlagDebugForceFutureIsBrightPhase3')
$ClesQualitePalworld = @('r.Tonemapper.Sharpen', 'r.MaxAnisotropy', 'r.TSR.History.ScreenPercentage', 'r.TemporalAA.Quality')

function Jeu-PourQualite([string]$jeu) {
    switch ($jeu) {
        'Roblox' { return (@(Trouver-ExeRoblox).Count -gt 0) }
        'Rocket League' { return (Test-Path -LiteralPath (& $Jeux['Rocket League'].Config)) }
        'Palworld' { return (Test-Path -LiteralPath (Dossier-ConfigPalworld)) }
    }
    return $false
}
function QualiteMax-Active {
    foreach ($jeu in $OptionsQualiteMax.Keys) {
        $c = Get-ChoixJeu $jeu
        foreach ($n in $OptionsQualiteMax[$jeu]) { if (@($c.Choix) -contains $n -or @($c.Appliques) -contains $n) { return $true } }
    }
    return $false
}
# Remet une cle d'un fichier .ini a sa valeur d'origine (notee par OptiGame avant de la changer)
function Rendre-CleIni([string]$jeu, [string]$fichier, [string]$section, [string]$cle) {
    $idx = Lire-IndexJeu $jeu
    $e = $idx | Where-Object { $_.Type -eq 'ini' -and $_.Orig -eq $fichier -and $_.Section -eq $section -and $_.Cle -eq $cle } | Select-Object -First 1
    if (-not $e) { return }
    Remettre-CleIni $fichier $section $cle $e.Val
    $reste = New-Object System.Collections.ArrayList
    foreach ($x in $idx) { if ($x -ne $e) { [void]$reste.Add($x) } }
    Ecrire-IndexJeu $jeu $reste
}

function Activer-QualiteMax {
    $faits = @(); $attente = @()
    foreach ($jeu in $OptionsQualiteMax.Keys) {
        if (-not (Jeu-PourQualite $jeu)) { continue }
        $c = Get-ChoixJeu $jeu
        # "Couper l'anticrenelage" fait l'inverse : on le retire
        $c.Choix = @(@($c.Choix) | Where-Object { $_ -ne $OptionCouperMsaa })
        $c.Appliques = @(@($c.Appliques) | Where-Object { $_ -ne $OptionCouperMsaa })
        $c.Choix = @(@($c.Choix) + $OptionsQualiteMax[$jeu] | Select-Object -Unique)
        $opts = @($Jeux[$jeu].Options | Where-Object { $OptionsQualiteMax[$jeu] -contains $_.Nom })
        if (Jeu-EnCours $jeu) { $script:EnAttente[$jeu] = $true; $attente += $jeu; continue }
        $script:SourceAction = 'Bouton Bords ultra lisses (page Ecran)'
        Appliquer-Jeu $jeu $opts
        $script:SourceAction = $null
        $faits += $jeu
    }
    Sauver-ChoixJeux
    $msg = @()
    if ($faits.Count) { $msg += "Active pour : $($faits -join ', '). Relance ces jeux pour le voir." }
    if ($attente.Count) { $msg += "En cours de jeu : $($attente -join ', '). Ce sera applique quand tu fermeras le jeu." }
    if (-not $msg.Count) { $msg += 'Aucun jeu compatible trouve (Roblox, Rocket League, Palworld). Lance-les une fois, puis reessaie.' }
    Afficher-Toast $(if ($faits.Count -or $attente.Count) { "Bords ultra lisses actives ($(@($faits) + @($attente) -join ', '))." } else { 'Aucun jeu compatible trouve (Roblox, Rocket League, Palworld).' }) $(if ($faits.Count -or $attente.Count) { 'ok' } else { 'info' })
}

function Desactiver-QualiteMax {
    foreach ($jeu in $OptionsQualiteMax.Keys) {
        $c = Get-ChoixJeu $jeu
        $avait = @(@($c.Choix) + @($c.Appliques) | Where-Object { $OptionsQualiteMax[$jeu] -contains $_ })
        $c.Choix = @(@($c.Choix) | Where-Object { $OptionsQualiteMax[$jeu] -notcontains $_ })
        $c.Appliques = @(@($c.Appliques) | Where-Object { $OptionsQualiteMax[$jeu] -notcontains $_ })
        if (-not $avait.Count) { continue }
        try {
            switch ($jeu) {
                'Roblox' {
                    foreach ($d in @(Trouver-ExeRoblox | ForEach-Object { Split-Path $_ } | Select-Object -Unique)) {
                        $f = Join-Path $d 'ClientSettings\ClientAppSettings.json'
                        if (-not (Test-Path -LiteralPath $f)) { continue }
                        $o = Lire-FlagsRoblox $f
                        foreach ($k in $ClesQualiteRoblox) { if ($o.Contains($k)) { $o.Remove($k) } }
                        Ecrire-FlagsRoblox $f $o
                    }
                }
                'Rocket League' { Rendre-CleIni 'Rocket League' (& $Jeux['Rocket League'].Config) 'SystemSettings' 'MaxMultiSamples' }
                'Palworld' {
                    $f = Join-Path (Dossier-ConfigPalworld) 'Engine.ini'
                    foreach ($k in $ClesQualitePalworld) { Rendre-CleIni 'Palworld' $f 'SystemSettings' $k }
                    # Le filtrage 16x etait peut-etre deja la avant : on ne retire que ce qu'OptiGame a ajoute
                }
            }
            $script:SourceAction = 'Bouton Desactiver les bords ultra lisses (page Ecran)'
            Ajouter-Journal "$jeu : qualite visuelle max" 'Active' 'Desactive' 'Bords et textures remis comme avant (plus de FPS).'
            $script:SourceAction = $null
        } catch {}
    }
    Sauver-ChoixJeux
    Afficher-Toast 'Bords ultra lisses desactives.' 'info'
}

function Maj-QualiteMax {
    if (-not $UI.TxtQualiteMax) { return }
    $on = QualiteMax-Active
    $UI.TxtQualiteMax.Text = if ($on) { 'ACTIF : bords ultra lisses et textures au maximum dans tes jeux compatibles (verifie et remis automatiquement si un jeu les enleve).' } else { 'Desactive.' }
    $UI.TxtQualiteMax.Foreground = Pinceau $(if ($on) { '#3FE08E' } else { '#8C95A8' })
    $UI.BtnQualiteMax.Visibility = $(if ($on) { 'Collapsed' } else { 'Visible' })
    $UI.BtnQualiteMaxOff.Visibility = $(if ($on) { 'Visible' } else { 'Collapsed' })
}

# =====================================================================
#  SPEED TEST : ping, stabilite, debit descendant / montant, ping en charge
#  Serveurs Cloudflare (speed.cloudflare.com), le plus proche de chez toi.
#  Tout tourne en arriere-plan : la fenetre reste fluide.
# =====================================================================
$FichierSpeed = Join-Path $env:ProgramData 'OptiGame\speedtest.json'
$CodeSpeed = @'
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Net;
using System.Net.Sockets;
using System.Threading;
public static class OGSpeed {
    public static volatile string Phase = "";
    public static volatile bool Fini = true;
    public static volatile bool Arreter = false;
    public static volatile string Erreur = "";
    public static volatile string Colo = "";
    public static double Direct, Ping, Jitter, PingCharge, Down, Up;
    public static int Pourcent;
    static long total;
    static IPAddress ip;
    const string Hote = "speed.cloudflare.com";
    const string Base = "https://speed.cloudflare.com/";
    static List<double> charges = new List<double>();

    public static void Lancer() {
        if (!Fini) return;
        Fini = false; Arreter = false; Erreur = ""; Colo = ""; Phase = "ping";
        Direct = Ping = Jitter = PingCharge = Down = Up = 0; Pourcent = 0;
        ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;
        ServicePointManager.DefaultConnectionLimit = 64;
        ServicePointManager.Expect100Continue = false;
        ServicePointManager.UseNagleAlgorithm = false;
        Thread t = new Thread(Tout); t.IsBackground = true; t.Priority = ThreadPriority.BelowNormal; t.Start();
    }

    static void Tout() {
        try {
            MesurerPing();
            if (!Arreter) Debit(true);
            if (!Arreter) Debit(false);
            Phase = Arreter ? "arrete" : "fini";
            Pourcent = 100;
        } catch (Exception e) { Erreur = e.Message; Phase = "erreur"; }
        Fini = true;
    }

    // Vrai ping : temps d'etablissement d'une connexion TCP (1 aller-retour), comme les sites de speed test
    static double UnPing() {
        using (Socket s = new Socket(ip.AddressFamily, SocketType.Stream, ProtocolType.Tcp)) {
            s.NoDelay = true;
            Stopwatch sw = Stopwatch.StartNew();
            IAsyncResult ar = s.BeginConnect(ip, 443, null, null);
            if (!ar.AsyncWaitHandle.WaitOne(3000)) throw new TimeoutException();
            s.EndConnect(ar);
            sw.Stop();
            return sw.Elapsed.TotalMilliseconds;
        }
    }

    static double Mediane(List<double> l) {
        if (l.Count == 0) return 0;
        List<double> c = new List<double>(l); c.Sort();
        return c[c.Count / 2];
    }

    static void MesurerPing() {
        Phase = "ping";
        IPAddress[] ips = Dns.GetHostAddresses(Hote);
        ip = null;
        foreach (IPAddress a in ips) if (a.AddressFamily == AddressFamily.InterNetwork) { ip = a; break; }
        if (ip == null && ips.Length > 0) ip = ips[0];
        if (ip == null) throw new Exception("serveur de test introuvable (pas d'internet ?)");
        // Ville du serveur (en-tete cf-ray)
        try {
            HttpWebRequest r = (HttpWebRequest)WebRequest.Create(Base + "__down?bytes=0");
            r.Timeout = 6000; r.Proxy = null;
            using (HttpWebResponse rep = (HttpWebResponse)r.GetResponse()) {
                string ray = rep.Headers["cf-ray"];
                if (!string.IsNullOrEmpty(ray) && ray.Contains("-")) Colo = ray.Substring(ray.LastIndexOf('-') + 1);
            }
        } catch { }
        try { UnPing(); } catch { }
        List<double> l = new List<double>();
        for (int i = 0; i < 20 && !Arreter; i++) {
            try { double p = UnPing(); l.Add(p); Direct = p; } catch { }
            Pourcent = 1 + i / 2;
            Thread.Sleep(80);
        }
        if (l.Count == 0) throw new Exception("le serveur de test ne repond pas (connexion coupee ou bloquee par un pare-feu)");
        Ping = Mediane(l);
        double j = 0; for (int i = 1; i < l.Count; i++) j += Math.Abs(l[i] - l[i - 1]);
        Jitter = l.Count > 1 ? j / (l.Count - 1) : 0;
    }

    static void Telecharger(object o) {
        DateTime fin = (DateTime)o;
        byte[] buf = new byte[131072];
        while (DateTime.UtcNow < fin && !Arreter) {
            try {
                HttpWebRequest r = (HttpWebRequest)WebRequest.Create(Base + "__down?bytes=100000000&r=" + Guid.NewGuid().ToString("N"));
                r.Timeout = 15000; r.ReadWriteTimeout = 15000; r.Proxy = null;
                using (WebResponse rep = r.GetResponse())
                using (Stream s = rep.GetResponseStream()) {
                    int n;
                    while ((n = s.Read(buf, 0, buf.Length)) > 0) {
                        Interlocked.Add(ref total, n);
                        if (DateTime.UtcNow >= fin || Arreter) { r.Abort(); break; }
                    }
                }
            } catch { Thread.Sleep(100); }
        }
    }

    static void Envoyer(object o) {
        DateTime fin = (DateTime)o;
        byte[] buf = new byte[131072];
        new Random().NextBytes(buf);
        const int taille = 8 * 1024 * 1024;
        while (DateTime.UtcNow < fin && !Arreter) {
            try {
                HttpWebRequest r = (HttpWebRequest)WebRequest.Create(Base + "__up?r=" + Guid.NewGuid().ToString("N"));
                r.Method = "POST"; r.Timeout = 15000; r.ReadWriteTimeout = 15000; r.Proxy = null;
                r.ContentType = "application/octet-stream"; r.ContentLength = taille; r.AllowWriteStreamBuffering = false;
                bool coupe = false;
                using (Stream s = r.GetRequestStream()) {
                    int envoye = 0;
                    while (envoye < taille) {
                        int n = Math.Min(buf.Length, taille - envoye);
                        s.Write(buf, 0, n); envoye += n;
                        Interlocked.Add(ref total, n);
                        if (DateTime.UtcNow >= fin || Arreter) { coupe = true; r.Abort(); break; }
                    }
                }
                if (!coupe) { using (WebResponse rep = r.GetResponse()) { } }
            } catch { Thread.Sleep(100); }
        }
    }

    // Ping pendant le telechargement : montre si la connexion "rame" quand elle est chargee (bufferbloat)
    static void BouclePingCharge(object o) {
        DateTime fin = (DateTime)o;
        Thread.Sleep(2000);
        while (DateTime.UtcNow < fin && !Arreter) {
            try { double p = UnPing(); lock (charges) charges.Add(p); } catch { }
            Thread.Sleep(300);
        }
    }

    static void Debit(bool descendant) {
        Phase = descendant ? "download" : "upload";
        int flux = descendant ? 8 : 6;
        double duree = descendant ? 12.0 : 10.0;
        Interlocked.Exchange(ref total, 0);
        DateTime debut = DateTime.UtcNow;
        DateTime fin = debut.AddSeconds(duree);
        List<Thread> th = new List<Thread>();
        for (int i = 0; i < flux; i++) {
            Thread t = new Thread(descendant ? (ParameterizedThreadStart)Telecharger : Envoyer);
            t.IsBackground = true; t.Priority = ThreadPriority.BelowNormal; t.Start(fin); th.Add(t);
        }
        if (descendant) { lock (charges) charges.Clear(); Thread p = new Thread(BouclePingCharge); p.IsBackground = true; p.Start(fin); th.Add(p); }
        long avant = 0; DateTime tAvant = debut;
        long base2 = -1; DateTime tBase = debut;
        double lisse = 0;
        while (DateTime.UtcNow < fin && !Arreter) {
            Thread.Sleep(250);
            DateTime now = DateTime.UtcNow;
            long v = Interlocked.Read(ref total);
            double dt = (now - tAvant).TotalSeconds;
            if (dt > 0) {
                double inst = (v - avant) * 8.0 / dt / 1e6;
                lisse = lisse == 0 ? inst : lisse * 0.6 + inst * 0.4;
                Direct = lisse;
            }
            avant = v; tAvant = now;
            // Les premieres secondes (montee en vitesse des connexions) ne comptent pas
            if (base2 < 0 && (now - debut).TotalSeconds >= 3.0) { base2 = v; tBase = now; }
            double frac = Math.Min(1.0, (now - debut).TotalSeconds / duree);
            Pourcent = descendant ? 10 + (int)(frac * 50) : 60 + (int)(frac * 40);
        }
        long fin2 = Interlocked.Read(ref total);
        double res = 0;
        if (base2 >= 0) { double s = (DateTime.UtcNow - tBase).TotalSeconds; if (s > 0) res = (fin2 - base2) * 8.0 / s / 1e6; }
        else { double s = (DateTime.UtcNow - debut).TotalSeconds; if (s > 0) res = fin2 * 8.0 / s / 1e6; }
        foreach (Thread t in th) { try { t.Join(1500); } catch { } }
        if (descendant) { Down = res; lock (charges) PingCharge = Mediane(charges); }
        else Up = res;
    }
}
'@

# ---------- Les moteurs de mesure tournent dans un PROGRAMME A PART ----------
# OptiGame ne fait que lire leur progression (quelques lignes de texte) : la fenetre reste fluide,
# et la mesure n'est pas ralentie par l'interface.
#  1) Speedtest by Ookla (officiel, le meme que speedtest.net) : moteur principal
#  2) Secours si Ookla est indisponible : serveurs Cloudflare
$DossierOokla = Join-Path $env:ProgramData 'OptiGame\speedtest'
$ExeOokla = Join-Path $DossierOokla 'speedtest.exe'
$MarqueOokla = Join-Path $DossierOokla 'verifie.txt'
$UrlOokla = 'https://install.speedtest.net/app/cli/ookla-speedtest-1.2.0-win64.zip'
$ScriptCf = Join-Path $DossierOokla 'secours_cloudflare.ps1'
$SourceCf = Join-Path $DossierOokla 'secours_cloudflare.cs'

function Ookla-Pret { return ((Test-Path -LiteralPath $ExeOokla) -and (Test-Path -LiteralPath $MarqueOokla)) }

# Telechargement de l'outil officiel (1 Mo, une seule fois), en arriere-plan, puis verification
# qu'il fonctionne et que c'est bien Speedtest by Ookla
function Installer-Ookla {
    $ps = [powershell]::Create()
    [void]$ps.AddScript({
        param($url, $dossier)
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        New-Item -ItemType Directory -Path $dossier -Force | Out-Null
        $zip = Join-Path $dossier 'ookla.zip'
        $exe = Join-Path $dossier 'speedtest.exe'
        Invoke-WebRequest -UseBasicParsing -Uri $url -OutFile $zip -TimeoutSec 60
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        $z = [IO.Compression.ZipFile]::OpenRead($zip)
        try {
            $entree = $z.Entries | Where-Object { $_.Name -eq 'speedtest.exe' } | Select-Object -First 1
            if (-not $entree) { throw 'speedtest.exe absent du telechargement' }
            [IO.Compression.ZipFileExtensions]::ExtractToFile($entree, $exe, $true)
        } finally { $z.Dispose() }
        Remove-Item -LiteralPath $zip -Force -ErrorAction SilentlyContinue
        $psi = New-Object System.Diagnostics.ProcessStartInfo($exe, '--version')
        $psi.UseShellExecute = $false; $psi.CreateNoWindow = $true; $psi.RedirectStandardOutput = $true
        $p = [System.Diagnostics.Process]::Start($psi)
        $sortie = $p.StandardOutput.ReadToEnd()
        [void]$p.WaitForExit(10000)
        if ($sortie -notmatch 'Speedtest by Ookla') {
            Remove-Item -LiteralPath $exe -Force -ErrorAction SilentlyContinue
            throw 'le fichier telecharge n''est pas Speedtest by Ookla (supprime par securite)'
        }
        "$($sortie.Trim())" | Out-File -FilePath (Join-Path $dossier 'verifie.txt') -Encoding ASCII
        'ok'
    }).AddArgument($UrlOokla).AddArgument($DossierOokla)
    return @{ PS = $ps; H = $ps.BeginInvoke() }
}

# Moteur de secours : petit script qui tourne dans son propre PowerShell et ecrit sa progression
# au meme format que Speedtest (une ligne JSON a la fois)
function Ecrire-MoteurSecours {
    New-Item -ItemType Directory -Path $DossierOokla -Force | Out-Null
    $script = @'
# Speed test de secours d'OptiGame (serveurs Cloudflare). Cree par OptiGame, ne pas modifier.
$ErrorActionPreference = 'Stop'
function Ecrire($o) { [Console]::Out.WriteLine(($o | ConvertTo-Json -Compress -Depth 4)); [Console]::Out.Flush() }
try { Add-Type -Path (Join-Path $PSScriptRoot 'secours_cloudflare.cs') }
catch { Ecrire @{ type = 'log'; level = 'error'; message = "preparation impossible : $($_.Exception.Message)" }; exit 1 }
[OGSpeed]::Lancer()
$envoye = $false
while (-not [OGSpeed]::Fini) {
    Start-Sleep -Milliseconds 100
    if (-not $envoye -and [OGSpeed]::Colo) { $envoye = $true; Ecrire @{ type = 'testStart'; isp = ''; server = @{ name = 'Cloudflare'; location = [OGSpeed]::Colo } } }
    $pc = [double][OGSpeed]::Pourcent
    switch ([OGSpeed]::Phase) {
        'ping' { Ecrire @{ type = 'ping'; ping = @{ latency = [OGSpeed]::Direct; progress = [math]::Min(1.0, $pc / 10.0) } } }
        'download' { Ecrire @{ type = 'download'; download = @{ bandwidth = [OGSpeed]::Direct * 125000; progress = ($pc - 10) / 50.0 } } }
        'upload' { Ecrire @{ type = 'upload'; upload = @{ bandwidth = [OGSpeed]::Direct * 125000; progress = ($pc - 60) / 40.0 } } }
    }
}
if ([OGSpeed]::Phase -eq 'fini') {
    Ecrire @{ type = 'result'; ping = @{ latency = [OGSpeed]::Ping; jitter = [OGSpeed]::Jitter }
        download = @{ bandwidth = [OGSpeed]::Down * 125000; latency = @{ iqm = [OGSpeed]::PingCharge } }; upload = @{ bandwidth = [OGSpeed]::Up * 125000 }
        server = @{ name = 'Cloudflare'; location = [OGSpeed]::Colo }; result = @{ url = '' } }
} else { Ecrire @{ type = 'log'; level = 'error'; message = "$([OGSpeed]::Erreur)" } }
'@
    $enc = New-Object Text.UTF8Encoding($false)
    [IO.File]::WriteAllText($ScriptCf, $script, $enc)
    [IO.File]::WriteAllText($SourceCf, $CodeSpeed, $enc)
}

# Lance un moteur (programme a part) et lit sa progression ligne par ligne dans un fil a part
function Demarrer-Mesure([string]$moteur) {
    $etat = [hashtable]::Synchronized(@{ Moteur = $moteur; Phase = 'debut'; Direct = 0.0; Ping = 0.0; Jitter = 0.0; Charge = 0.0; Down = 0.0; Up = 0.0; Perte = $null
        Serveur = ''; Isp = ''; Url = ''; Pourcent = 0; Fini = $false; Erreur = ''; Pid = 0; Arreter = $false })
    if ($moteur -eq 'ookla') { $fichier = $ExeOokla; $arguments = '--accept-license --accept-gdpr -f jsonl -p yes' }
    else {
        Ecrire-MoteurSecours
        $fichier = Join-Path $env:WINDIR 'System32\WindowsPowerShell\v1.0\powershell.exe'
        $arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$ScriptCf`""
    }
    $ps = [powershell]::Create()
    [void]$ps.AddScript({
        param($fichier, $arguments, $etat)
        try {
            $psi = New-Object System.Diagnostics.ProcessStartInfo($fichier, $arguments)
            $psi.UseShellExecute = $false; $psi.CreateNoWindow = $true
            $psi.RedirectStandardOutput = $true; $psi.RedirectStandardError = $true
            $p = [System.Diagnostics.Process]::Start($psi)
            $etat.Pid = $p.Id
            $err = $p.StandardError.ReadToEndAsync()
            while ($null -ne ($l = $p.StandardOutput.ReadLine())) {
                if ($l -notmatch '^\s*\{') { continue }
                $j = $null
                try { $j = $l | ConvertFrom-Json } catch { continue }
                switch ("$($j.type)") {
                    'testStart' { $etat.Serveur = "$($j.server.name) - $($j.server.location)"; $etat.Isp = "$($j.isp)"; $etat.Phase = 'ping' }
                    'ping' { $etat.Phase = 'ping'; $etat.Direct = [double]$j.ping.latency; $etat.Pourcent = [int](10 * [double]$j.ping.progress) }
                    'download' { $etat.Phase = 'download'; $etat.Direct = [double]$j.download.bandwidth / 125000; $etat.Pourcent = 10 + [int](50 * [double]$j.download.progress) }
                    'upload' { $etat.Phase = 'upload'; $etat.Direct = [double]$j.upload.bandwidth / 125000; $etat.Pourcent = 60 + [int](40 * [double]$j.upload.progress) }
                    'result' {
                        $etat.Ping = [double]$j.ping.latency; $etat.Jitter = [double]$j.ping.jitter
                        $etat.Down = [double]$j.download.bandwidth / 125000; $etat.Up = [double]$j.upload.bandwidth / 125000
                        $etat.Charge = if ($j.download.latency.iqm) { [double]$j.download.latency.iqm } else { $etat.Ping }
                        if ($null -ne $j.packetLoss) { $etat.Perte = [double]$j.packetLoss }
                        $etat.Url = "$($j.result.url)"
                        if (-not $etat.Serveur) { $etat.Serveur = "$($j.server.name) - $($j.server.location)" }
                        $etat.Phase = 'fini'; $etat.Pourcent = 100
                    }
                    'log' { if ("$($j.level)" -eq 'error') { $etat.Erreur = "$($j.message)" } }
                }
            }
            $p.WaitForExit()
            if ($etat.Phase -ne 'fini' -and -not $etat.Erreur -and -not $etat.Arreter) {
                $e = "$($err.Result)".Trim()
                $etat.Erreur = if ($e) { ($e -split "`n" | Select-Object -Last 1).Trim() } else { 'le test s''est arrete sans resultat' }
            }
        } catch { $etat.Erreur = $_.Exception.Message }
        $etat.Fini = $true
    }).AddArgument($fichier).AddArgument($arguments).AddArgument($etat)
    $script:Mesure = @{ PS = $ps; H = $ps.BeginInvoke(); Etat = $etat }
    if (-not $script:MinuterieMesure) {
        $script:MinuterieMesure = New-Object System.Windows.Threading.DispatcherTimer
        $script:MinuterieMesure.Interval = [TimeSpan]::FromMilliseconds(100)
        $script:MinuterieMesure.Add_Tick({ Suivre-Mesure })
    }
    $script:MinuterieMesure.Start()
}

function Test-SpeedEnCours { return ([bool]($script:Mesure -and -not $script:Mesure.Etat.Fini)) }

function Arreter-Mesure {
    if (-not $script:Mesure) { return }
    $script:Mesure.Etat.Arreter = $true
    try { if ($script:Mesure.Etat.Pid) { Stop-Process -Id $script:Mesure.Etat.Pid -Force -ErrorAction SilentlyContinue } } catch {}
}

$VillesCloudflare = @{ CDG = 'Paris'; MRS = 'Marseille'; LYS = 'Lyon'; BOD = 'Bordeaux'; TLS = 'Toulouse'; NCE = 'Nice'; BRU = 'Bruxelles'; FRA = 'Francfort'
    AMS = 'Amsterdam'; LHR = 'Londres'; MAD = 'Madrid'; BCN = 'Barcelone'; ZRH = 'Zurich'; GVA = 'Geneve'; MXP = 'Milan'; LUX = 'Luxembourg'; DUS = 'Dusseldorf' }

function Lire-HistoSpeed {
    if (Test-Path $FichierSpeed) { try { return @(Get-Content $FichierSpeed -Raw | ConvertFrom-Json) } catch {} }
    return @()
}

# ---------- Jauge et grand chiffre animes par WPF lui-meme (60 images/s, sans calcul a chaque image) ----------
function Dessiner-ArcSur($chemin, [double]$frac) {
    if (-not $chemin) { return }
    $r = 95.0; $cx = 110.0; $cy = 110.0
    $debutA = 135.0; $total = 270.0
    $ang = [math]::Max(0.0, [math]::Min($total - 0.01, $total * $frac))
    if ($ang -le 0.5) { $chemin.Data = $null; return }
    $a1 = $debutA * [math]::PI / 180; $a2 = ($debutA + $ang) * [math]::PI / 180
    $geo = New-Object System.Windows.Media.StreamGeometry
    $ctx = $geo.Open()
    $ctx.BeginFigure((New-Object System.Windows.Point(($cx + $r * [math]::Cos($a1)), ($cy + $r * [math]::Sin($a1)))), $false, $false)
    $ctx.ArcTo((New-Object System.Windows.Point(($cx + $r * [math]::Cos($a2)), ($cy + $r * [math]::Sin($a2)))), (New-Object System.Windows.Size($r, $r)), 0, ($ang -gt 180),
        [System.Windows.Media.SweepDirection]::Clockwise, $true, $false)
    $ctx.Close()
    $geo.Freeze()
    $chemin.Data = $geo
}
# Echelle logarithmique : 1 Mb/s a 1000 Mb/s se lisent bien sur la meme jauge
function Frac-Vitesse([double]$v) { return [math]::Min(1.0, [math]::Log10(1 + [math]::Max(0, $v)) / [math]::Log10(1001)) }

# Longueur du trait de la jauge, en "epaisseurs" (unite des pointilles WPF) : 95 x 270 degres / 14
$LongJauge = 95.0 * 1.5 * [math]::PI / 14.0
function Fond-Jauge {
    if (-not $UI.ArcSpeedFond -or $script:JaugePrete) { return }
    Dessiner-ArcSur $UI.ArcSpeedFond 0.9999
    Dessiner-ArcSur $UI.ArcSpeed 0.9999
    $dc = New-Object System.Windows.Media.DoubleCollection
    $dc.Add($LongJauge + 1); $dc.Add($LongJauge + 1)
    $UI.ArcSpeed.StrokeDashArray = $dc
    $UI.ArcSpeed.StrokeDashOffset = $LongJauge + 1
    $UI.ArcSpeed.Opacity = 0
    $script:JaugePrete = $true
}
function Anim-Vers($objet, $propriete, [double]$vers, [int]$ms = 350) {
    $a = New-Object System.Windows.Media.Animation.DoubleAnimation
    $a.To = $vers
    $a.Duration = New-Object System.Windows.Duration([TimeSpan]::FromMilliseconds($ms))
    $e = New-Object System.Windows.Media.Animation.QuadraticEase; $e.EasingMode = 'EaseOut'; $a.EasingFunction = $e
    $objet.BeginAnimation($propriete, $a, [System.Windows.Media.Animation.HandoffBehavior]::SnapshotAndReplace)
}
function Anim-Jauge([double]$frac) {
    Fond-Jauge
    $frac = [math]::Max(0.0, [math]::Min(1.0, $frac))
    $UI.ArcSpeed.Opacity = $(if ($frac -gt 0.003) { 1 } else { 0 })
    Anim-Vers $UI.ArcSpeed ([System.Windows.Shapes.Shape]::StrokeDashOffsetProperty) (($LongJauge + 1) * (1 - $frac))
}
# Le grand chiffre suit une valeur animee (curseur invisible) : il defile en douceur
function Anim-Nombre([double]$v, [string]$format = '{0:N0}', [string]$unite = '') {
    if ($script:FormatGros -ne $format -or -not [System.Windows.Data.BindingOperations]::IsDataBound($UI.TxtSpGros, [System.Windows.Controls.TextBlock]::TextProperty)) {
        $b = New-Object System.Windows.Data.Binding('Value')
        $b.Source = $UI.ValSpeed; $b.StringFormat = $format
        [void]$UI.TxtSpGros.SetBinding([System.Windows.Controls.TextBlock]::TextProperty, $b)
        $script:FormatGros = $format
    }
    if ($unite -and $UI.TxtSpUnite.Text -ne $unite) { $UI.TxtSpUnite.Text = $unite }
    Anim-Vers $UI.ValSpeed ([System.Windows.Controls.Primitives.RangeBase]::ValueProperty) $v 300
}
function Texte-Gros([string]$t, [string]$unite = '') {
    [System.Windows.Data.BindingOperations]::ClearBinding($UI.TxtSpGros, [System.Windows.Controls.TextBlock]::TextProperty)
    $script:FormatGros = $null
    $UI.TxtSpGros.Text = $t; $UI.TxtSpUnite.Text = $unite
}

function Reinit-AffichageSpeed {
    $UI.PanSpeedConseils.Children.Clear()
    foreach ($n in 'TxtSpPing', 'TxtSpJitter', 'TxtSpDown', 'TxtSpUp', 'TxtSpCharge') { $UI[$n].Text = '-' }
    $UI.BarreSpeed.Value = 0
    $UI.ValSpeed.BeginAnimation([System.Windows.Controls.Primitives.RangeBase]::ValueProperty, $null); $UI.ValSpeed.Value = 0
    Anim-Jauge 0
    Texte-Gros '...' ''
    $UI.BtnSpeedGo.Content = 'Arreter'
}

function Lancer-SpeedTest {
    if (Test-SpeedEnCours) { Arreter-Mesure; $UI.TxtSpPhase.Text = 'Arret du test...'; return }
    if ($script:InstOokla -and -not $script:InstOokla.H.IsCompleted) { return }
    $script:SecoursDejaTente = $false
    if (Ookla-Pret) {
        Reinit-AffichageSpeed
        $UI.TxtSpPhase.Text = 'Recherche du meilleur serveur...'
        Demarrer-Mesure 'ookla'
        return
    }
    # Premiere fois : on recupere l'outil officiel Speedtest (Ookla)
    $UI.TxtSpPhase.Text = 'Telechargement de l''outil officiel Speedtest (1 Mo, une seule fois)...'
    $UI.BtnSpeedGo.IsEnabled = $false
    $script:InstOokla = Installer-Ookla
    if (-not $script:MinuterieInst) {
        $script:MinuterieInst = New-Object System.Windows.Threading.DispatcherTimer
        $script:MinuterieInst.Interval = [TimeSpan]::FromMilliseconds(300)
        $script:MinuterieInst.Add_Tick({
            if (-not $script:InstOokla.H.IsCompleted) { return }
            $script:MinuterieInst.Stop()
            $UI.BtnSpeedGo.IsEnabled = $true
            $err = $null
            try { [void]$script:InstOokla.PS.EndInvoke($script:InstOokla.H) } catch { $err = $_.Exception.InnerException; if (-not $err) { $err = $_.Exception } }
            try { $script:InstOokla.PS.Dispose() } catch {}
            if (-not $err -and (Ookla-Pret)) { Lancer-SpeedTest }
            else {
                $raison = if ($err) { $err.Message } else { 'fichier introuvable' }
                Write-Log "Speed test : outil Speedtest indisponible ($raison) : test de secours Cloudflare." 'Gold'
                Reinit-AffichageSpeed
                $UI.TxtSpPhase.Text = 'Speedtest indisponible : test de secours (Cloudflare)...'
                $script:SecoursDejaTente = $true
                Demarrer-Mesure 'cloudflare'
            }
        })
    }
    $script:MinuterieInst.Start()
}

function Suivre-Mesure {
    $e = $script:Mesure.Etat
    if ($e.Pourcent -ne $script:DernierPourcent) { $script:DernierPourcent = $e.Pourcent; Anim-Vers $UI.BarreSpeed ([System.Windows.Controls.Primitives.RangeBase]::ValueProperty) ([double]$e.Pourcent) 300 }
    if ($e.Serveur -and -not $script:ServeurAffiche) {
        $s = "$($e.Serveur)"
        if ($e.Moteur -eq 'cloudflare') { foreach ($c in $VillesCloudflare.Keys) { if ($s -match "- $c$") { $s = "Cloudflare - $($VillesCloudflare[$c])" } } }
        $UI.TxtSpServeur.Text = "Serveur : $s$(if ($e.Isp) { "   -   Ton operateur : $($e.Isp)" })$(if ($e.Moteur -eq 'cloudflare') { '   (test de secours)' })"
        $script:ServeurAffiche = $true
    }
    if ($e.Phase -ne $script:PhaseAffichee) {
        $script:PhaseAffichee = $e.Phase
        switch ($e.Phase) {
            'ping' { $UI.TxtSpPhase.Text = 'Mesure du ping...' }
            'download' { $UI.TxtSpPhase.Text = 'Telechargement (descendant)...'; if ($e.Ping -le 0 -and $script:DernierPing) { $UI.TxtSpPing.Text = "$([math]::Round($script:DernierPing)) ms" } }
            'upload' { $UI.TxtSpPhase.Text = 'Envoi (montant)...'; if ($script:DernierDown) { $UI.TxtSpDown.Text = ('{0:N1} Mb/s' -f $script:DernierDown) } }
        }
    }
    $v = [double]$e.Direct
    if ($v -ne $script:DerniereValeur) {
        $script:DerniereValeur = $v
        switch ($e.Phase) {
            'ping' { if ($v -gt 0) { $script:DernierPing = $v; Anim-Nombre $v '{0:N0}' 'ms'; Anim-Jauge ([math]::Min(1.0, $v / 150.0)) } }
            'download' { $script:DernierDown = $v; Anim-Nombre $v $(if ($v -ge 100) { '{0:N0}' } else { '{0:N1}' }) 'Mb/s'; Anim-Jauge (Frac-Vitesse $v) }
            'upload' { Anim-Nombre $v $(if ($v -ge 100) { '{0:N0}' } else { '{0:N1}' }) 'Mb/s'; Anim-Jauge (Frac-Vitesse $v) }
        }
    }
    if (-not $e.Fini) { return }
    $script:MinuterieMesure.Stop()
    $script:ServeurAffiche = $false; $script:PhaseAffichee = $null; $script:DerniereValeur = $null; $script:DernierPing = $null; $script:DernierDown = $null; $script:DernierPourcent = $null
    try { $script:Mesure.PS.EndInvoke($script:Mesure.H) | Out-Null; $script:Mesure.PS.Dispose() } catch {}
    $UI.BtnSpeedGo.Content = 'Relancer le test'
    if ($e.Arreter) { $UI.TxtSpPhase.Text = 'Test arrete.'; Texte-Gros '-'; Anim-Jauge 0; return }
    if ($e.Phase -ne 'fini') {
        # Speedtest a echoue (serveurs injoignables, limite...) : on essaie le secours une fois
        if ($e.Moteur -eq 'ookla' -and -not $script:SecoursDejaTente) {
            Write-Log "Speed test : Speedtest a echoue ($($e.Erreur)) : test de secours Cloudflare." 'Gold'
            $script:SecoursDejaTente = $true
            Reinit-AffichageSpeed
            $UI.TxtSpPhase.Text = 'Speedtest n''a pas pu finir : test de secours (Cloudflare)...'
            Demarrer-Mesure 'cloudflare'
            return
        }
        $UI.TxtSpPhase.Text = "Test impossible : $($e.Erreur)"
        Texte-Gros '-'; Anim-Jauge 0
        return
    }
    $serveur = "$($e.Serveur)"
    if ($e.Moteur -eq 'cloudflare') { foreach ($c in $VillesCloudflare.Keys) { if ($serveur -match "- $c$") { $serveur = "Cloudflare - $($VillesCloudflare[$c])" } } }
    Afficher-ResultatSpeed ([pscustomobject]@{
        Date = (Get-Date).ToString('dd/MM/yyyy HH:mm'); Ping = [math]::Round($e.Ping); Jitter = [math]::Round($e.Jitter, 1)
        Charge = [math]::Round($e.Charge); Down = [math]::Round($e.Down, 1); Up = [math]::Round($e.Up, 1)
        Perte = $(if ($null -ne $e.Perte) { [math]::Round([double]$e.Perte, 1) } else { $null })
        Serveur = $serveur; Url = $e.Url; Moteur = $e.Moteur; Wifi = [bool](Connexion-EnWifi)
    }) -Nouveau
}

# (lecture instantanee, sans requete WMI qui ferait geler la fenetre)
function Connexion-EnWifi {
    try {
        $actifs = @([System.Net.NetworkInformation.NetworkInterface]::GetAllNetworkInterfaces() | Where-Object {
            "$($_.OperationalStatus)" -eq 'Up' -and "$($_.NetworkInterfaceType)" -in 'Ethernet', 'Wireless80211', 'GigabitEthernet' -and
            "$($_.Description)" -notmatch 'Virtual|Hyper-V|VPN|TAP|VMware|VirtualBox|Bluetooth|Loopback|WAN Miniport|Tunnel' })
        $wifi = @($actifs | Where-Object { "$($_.NetworkInterfaceType)" -eq 'Wireless80211' })
        return ($wifi.Count -gt 0 -and $wifi.Count -eq $actifs.Count)
    } catch { return $false }
}

function Conseil-Speed([string]$texte, [string]$couleur) {
    $t = New-Object System.Windows.Controls.TextBlock
    $t.Text = $texte; $t.TextWrapping = 'Wrap'; $t.FontSize = 12.5; $t.Margin = '0,0,0,6'; $t.LineHeight = 19
    $t.Foreground = Pinceau $couleur
    [void]$UI.PanSpeedConseils.Children.Add($t)
}

function Afficher-ResultatSpeed($r, [switch]$Nouveau) {
    $UI.TxtSpPing.Text = "$($r.Ping) ms"; $UI.TxtSpJitter.Text = "$($r.Jitter) ms"; $UI.TxtSpCharge.Text = "$($r.Charge) ms"
    $UI.TxtSpDown.Text = "$($r.Down) Mb/s"; $UI.TxtSpUp.Text = "$($r.Up) Mb/s"
    Anim-Nombre ([double]$r.Down) $(if ([double]$r.Down -ge 100) { '{0:N0}' } else { '{0:N1}' }) 'Mb/s descendant'
    Anim-Jauge (Frac-Vitesse ([double]$r.Down))
    $UI.TxtSpPhase.Text = "Resultat du $($r.Date)"
    if ($r.Serveur) { $UI.TxtSpServeur.Text = "Serveur : $($r.Serveur)$(if ($r.Moteur -eq 'cloudflare') { '   (test de secours)' })" }
    $script:UrlSpeed = "$($r.Url)"
    $UI.BtnSpeedSite.Content = if ($script:UrlSpeed) { 'Voir ce resultat sur speedtest.net' } else { 'Comparer sur speedtest.net' }
    Anim-Vers $UI.BarreSpeed ([System.Windows.Controls.Primitives.RangeBase]::ValueProperty) 100 250
    # Verdict pour jouer
    $UI.PanSpeedConseils.Children.Clear()
    $p = [double]$r.Ping; $j = [double]$r.Jitter; $hausse = [double]$r.Charge - $p
    if ($p -le 20) { Conseil-Speed "OK Ping $p ms : excellent pour jouer (le ping en jeu depend aussi de la distance du serveur du jeu)." '#3FE08E' }
    elseif ($p -le 40) { Conseil-Speed "OK Ping $p ms : bon pour jouer." '#3FE08E' }
    elseif ($p -le 80) { Conseil-Speed "~  Ping $p ms : correct, mais tu peux sentir un leger retard en competitif." '#FFC24B' }
    else { Conseil-Speed "X  Ping $p ms : eleve. Branche un cable Ethernet, ferme les telechargements, redemarre ta box." '#FF8A97' }
    if ($j -le 5) { Conseil-Speed "OK Stabilite ($j ms d'ecart) : connexion tres reguliere, pas de saccades reseau." '#3FE08E' }
    elseif ($j -le 15) { Conseil-Speed "~  Stabilite ($j ms d'ecart) : quelques variations, possibles petits a-coups en jeu." '#FFC24B' }
    else { Conseil-Speed "X  Stabilite ($j ms d'ecart) : connexion instable (souvent le Wi-Fi). En jeu : teleportations, coups qui ne passent pas." '#FF8A97' }
    if ($hausse -le 30) { Conseil-Speed "OK Ping quand la connexion est chargee : +$([math]::Max(0, [math]::Round($hausse))) ms seulement. Meme si quelqu'un telecharge chez toi, ton ping reste bon." '#3FE08E' }
    else { Conseil-Speed "X  Ping quand la connexion est chargee : +$([math]::Round($hausse)) ms (bufferbloat). Quand quelqu'un regarde une video ou telecharge chez toi, ton ping explose. Solution : active la QoS / priorite jeu dans les reglages de ta box, ou evite les gros telechargements pendant que tu joues." '#FF8A97' }
    $d = [double]$r.Down; $u = [double]$r.Up
    if ($d -ge 50) { Conseil-Speed "OK Descendant $d Mb/s : largement assez (jeux, streaming, mises a jour rapides)." '#3FE08E' }
    elseif ($d -ge 15) { Conseil-Speed "~  Descendant $d Mb/s : suffisant pour jouer, mais les mises a jour de jeux seront longues." '#FFC24B' }
    else { Conseil-Speed "X  Descendant $d Mb/s : faible. Les jeux en ligne passent, mais streaming et telechargements vont saturer ta connexion." '#FF8A97' }
    if ($u -ge 10) { Conseil-Speed "OK Montant $u Mb/s : assez pour jouer et streamer (Twitch, Discord en partage d'ecran)." '#3FE08E' }
    elseif ($u -ge 3) { Conseil-Speed "~  Montant $u Mb/s : OK pour jouer, juste pour streamer en 720p." '#FFC24B' }
    else { Conseil-Speed "X  Montant $u Mb/s : tres faible, le partage d'ecran ou un stream feront monter ton ping." '#FF8A97' }
    if ($null -ne $r.Perte) {
        if ([double]$r.Perte -le 0) { Conseil-Speed 'OK Aucune perte de paquets : rien ne se perd en route.' '#3FE08E' }
        else { Conseil-Speed "X  Perte de paquets $($r.Perte) % : des infos se perdent en route (coups qui ne passent pas, teleportations). Souvent le Wi-Fi ou un cable abime." '#FF8A97' }
    }
    if ($r.Wifi) { Conseil-Speed 'Tu es en Wi-Fi : un cable Ethernet donne presque toujours un ping plus bas et surtout plus stable.' '#9AA3B5' }
    if ($r.Moteur -eq 'cloudflare') { Conseil-Speed 'Resultat du test de secours (Cloudflare) : Speedtest etait indisponible. Les chiffres peuvent un peu differer de speedtest.net.' '#FFC24B' }
    Conseil-Speed 'Les debits dependent aussi de ton abonnement : compare avec ce que ton operateur annonce. Refais le test a differentes heures (le soir, le reseau est plus charge).' '#8C95A8'
    if ($Nouveau) {
        $h = @(@($r) + @(Lire-HistoSpeed) | Select-Object -First 12)
        try { New-Item -ItemType Directory -Path (Split-Path $FichierSpeed) -Force | Out-Null; ConvertTo-Json -InputObject @($h) | Out-File -FilePath $FichierSpeed -Encoding UTF8 } catch {}
        Remplir-HistoSpeed
        Write-Log "Speed test ($(if ($r.Moteur -eq 'cloudflare') { 'secours Cloudflare' } else { 'Speedtest by Ookla' })) : ping $($r.Ping) ms, $($r.Down) Mb/s descendant, $($r.Up) Mb/s montant." 'Gray'
    }
}

function Remplir-HistoSpeed {
    if (-not $UI.ListeSpeed) { return }
    $items = @(Lire-HistoSpeed | ForEach-Object {
        [pscustomobject]@{ Date = "$($_.Date)"; Ping = "$($_.Ping) ms"; Jitter = "+/- $($_.Jitter) ms"; Down = "$($_.Down) Mb/s"; Up = "$($_.Up) Mb/s"
            Lien = $(if ($_.Wifi) { 'Wi-Fi' } else { 'Cable' }) }
    })
    $UI.ListeSpeed.ItemsSource = $items
    $UI.TxtSpeedHistoVide.Visibility = $(if ($items.Count) { 'Collapsed' } else { 'Visible' })
}

function Maj-PageSpeed {
    try { Lancer-EtatReseau } catch {}
    Fond-Jauge
    Remplir-HistoSpeed
    $h = @(Lire-HistoSpeed)
    if ($h.Count -and $UI.TxtSpPhase.Text -eq 'Pret.' -and -not (Test-SpeedEnCours)) { Afficher-ResultatSpeed $h[0] }
}

# ---------- Temperatures : carte graphique (comme le Gestionnaire des taches) + zone thermique ----------
# Lecture dans un fil a part toutes les 2 s : aucun ralentissement de la fenetre, aucun pilote a installer.
$CodeTemp = @'
using System;
using System.Diagnostics;
using System.Runtime.InteropServices;
using System.Threading;
public static class OGTemp {
    [StructLayout(LayoutKind.Sequential)] struct LUID { public uint Low; public int High; }
    [StructLayout(LayoutKind.Sequential)] struct ADAPTERINFO { public uint hAdapter; public LUID luid; public uint NumOfSources; public int bPrecise; }
    [StructLayout(LayoutKind.Sequential)] struct ENUM2 { public uint NumAdapters; public IntPtr pAdapters; }
    [StructLayout(LayoutKind.Sequential)] struct QUERY { public uint hAdapter; public int Type; public IntPtr pData; public uint Size; }
    [StructLayout(LayoutKind.Sequential)] struct CLOSE { public uint hAdapter; }
    [StructLayout(LayoutKind.Explicit, Size = 64)] struct PERF { [FieldOffset(0)] public uint PhysicalAdapterIndex; [FieldOffset(48)] public uint FanRPM; [FieldOffset(52)] public uint Power; [FieldOffset(56)] public uint Temperature; }
    [DllImport("gdi32.dll")] static extern int D3DKMTEnumAdapters2(ref ENUM2 e);
    [DllImport("gdi32.dll")] static extern int D3DKMTQueryAdapterInfo(ref QUERY q);
    [DllImport("gdi32.dll")] static extern int D3DKMTCloseAdapter(ref CLOSE c);

    public static double Gpu = -1, GpuMax = -1, Zone = -1, ZoneMax = -1;
    public static int Ventilo = -1;
    static Thread fil;
    static PerformanceCounter[] zones;

    public static void Demarrer() {
        if (fil != null) return;
        fil = new Thread(Boucle); fil.IsBackground = true; fil.Priority = ThreadPriority.BelowNormal; fil.Start();
    }

    static void Boucle() {
        try {
            if (PerformanceCounterCategory.Exists("Thermal Zone Information")) {
                string[] noms = new PerformanceCounterCategory("Thermal Zone Information").GetInstanceNames();
                zones = new PerformanceCounter[noms.Length];
                for (int i = 0; i < noms.Length; i++) zones[i] = new PerformanceCounter("Thermal Zone Information", "Temperature", noms[i], true);
            }
        } catch { zones = null; }
        while (true) {
            try { double g = LireGpu(); Gpu = g; if (g > GpuMax) GpuMax = g; } catch { }
            try {
                double z = -1;
                if (zones != null) foreach (PerformanceCounter c in zones) { double k = c.NextValue() - 273.15; if (k > 15 && k < 115 && k > z) z = k; }
                Zone = z; if (z > ZoneMax) ZoneMax = z;
            } catch { }
            Thread.Sleep(2000);
        }
    }

    static double LireGpu() {
        ENUM2 e = new ENUM2();
        if (D3DKMTEnumAdapters2(ref e) != 0 || e.NumAdapters == 0) return -1;
        int sz = Marshal.SizeOf(typeof(ADAPTERINFO));
        IntPtr buf = Marshal.AllocHGlobal(sz * (int)e.NumAdapters);
        IntPtr pp = Marshal.AllocHGlobal(64);
        double best = -1;
        try {
            e.pAdapters = buf;
            if (D3DKMTEnumAdapters2(ref e) != 0) return -1;
            for (int i = 0; i < e.NumAdapters; i++) {
                ADAPTERINFO a = (ADAPTERINFO)Marshal.PtrToStructure(new IntPtr(buf.ToInt64() + (long)i * sz), typeof(ADAPTERINFO));
                PERF p = new PERF();
                Marshal.StructureToPtr(p, pp, false);
                QUERY q = new QUERY(); q.hAdapter = a.hAdapter; q.Type = 62; q.pData = pp; q.Size = 64;
                if (D3DKMTQueryAdapterInfo(ref q) == 0) {
                    p = (PERF)Marshal.PtrToStructure(pp, typeof(PERF));
                    if (p.Temperature > 0 && p.Temperature < 1500) {
                        double t = p.Temperature / 10.0;
                        if (t > best) { best = t; Ventilo = (int)p.FanRPM; }
                    }
                }
                CLOSE c = new CLOSE(); c.hAdapter = a.hAdapter; D3DKMTCloseAdapter(ref c);
            }
        } finally { Marshal.FreeHGlobal(buf); Marshal.FreeHGlobal(pp); }
        return best;
    }
}
'@
$script:AlerteTempQuand = [datetime]::MinValue
function Demarrer-Temperatures { try { Charger-Type 'OGTemp' $CodeTemp; [OGTemp]::Demarrer() } catch {} }
function Deg { return [string][char]0xB0 + 'C' }

function Maj-Temperatures {
    if (-not $UI.TxtTempGpu -or -not ('OGTemp' -as [type])) { return }
    $g = [OGTemp]::Gpu; $z = [OGTemp]::Zone
    if ($g -gt 0) {
        $UI.TxtTempGpu.Text = ('{0:N0} {1}' -f $g, (Deg))
        $UI.TxtTempGpu.Foreground = Pinceau $(if ($g -ge 85) { '#FF5468' } elseif ($g -ge 75) { '#FFC24B' } else { '#E9ECF2' })
        Animer $UI.BarreTemp.RenderTransform ([System.Windows.Media.ScaleTransform]::ScaleXProperty) ([math]::Min(1.0, $g / 100.0)) 600
        $det = "Carte graphique - max $('{0:N0}' -f [OGTemp]::GpuMax) $(Deg)"
        if ([OGTemp]::Ventilo -gt 0) { $det += " - ventilo $([OGTemp]::Ventilo) tr/min" }
        if ($z -gt 0) { $det += "`r`nCarte mere : ~$('{0:N0}' -f $z) $(Deg) (capteur approximatif)" }
        $UI.TxtTempDetail.Text = $det
    } else {
        $UI.TxtTempGpu.Text = '--'
        $UI.TxtTempDetail.Text = if ($z -gt 0) { "Carte mere : ~$('{0:N0}' -f $z) $(Deg) (capteur approximatif)" } else { 'Lecture en cours... (ta carte graphique doit etre a jour pour donner sa temperature)' }
    }
}

# Alerte si la carte graphique chauffe trop (meme en jeu, fenetre cachee) : une fois toutes les 15 minutes au plus
function Verifier-AlerteTemp {
    if (-not ('OGTemp' -as [type])) { return }
    $g = [OGTemp]::Gpu
    if ($g -lt 85 -or ((Get-Date) - $script:AlerteTempQuand).TotalMinutes -lt 15) { return }
    $script:AlerteTempQuand = Get-Date
    $msg = if ($g -ge 95) { "Carte graphique a $([math]::Round($g)) $(Deg) : beaucoup trop chaud ! Elle va baisser ses performances pour se proteger. Verifie que ses ventilateurs tournent et que le boitier respire (poussiere, aeration)." }
           else { "Carte graphique a $([math]::Round($g)) $(Deg) : ca chauffe. Nettoie la poussiere, ameliore l'aeration du boitier, ou limite tes FPS a la frequence de ton ecran." }
    Write-Log $msg 'Gold'
    if (Fenetre-Ouverte) { try { Afficher-Toast "Carte graphique a $([math]::Round($g)) $(Deg) : ca chauffe !" 'alerte' } catch {} }
    elseif ($script:Notif) { $script:Notif.ShowBalloonTip(6000, 'OptiGame : temperature', $msg, [Windows.Forms.ToolTipIcon]::Warning) }
}

# =====================================================================
#  RESEAU : etat de la connexion + DNS le plus rapide
# =====================================================================
$CodeDns = @'
using System;
using System.Diagnostics;
using System.Net;
using System.Net.Sockets;
public static class OGDns {
    static Random hasard = new Random();
    // Une vraie question DNS envoyee directement au serveur : temps de reponse en ms (-1 si pas de reponse)
    public static double Requete(string serveur, string domaine, int delaiMs) {
        try {
            byte[] q = new byte[512]; int n = 0;
            int id = hasard.Next(1, 65535);
            q[n++] = (byte)(id >> 8); q[n++] = (byte)id; q[n++] = 1; q[n++] = 0; q[n++] = 0; q[n++] = 1;
            for (int i = 0; i < 6; i++) q[n++] = 0;
            foreach (string part in domaine.Split('.')) { q[n++] = (byte)part.Length; foreach (char c in part) q[n++] = (byte)c; }
            q[n++] = 0; q[n++] = 0; q[n++] = 1; q[n++] = 0; q[n++] = 1;
            using (UdpClient u = new UdpClient()) {
                u.Client.ReceiveTimeout = delaiMs;
                u.Connect(IPAddress.Parse(serveur), 53);
                Stopwatch sw = Stopwatch.StartNew();
                u.Send(q, n);
                IPEndPoint ep = null;
                byte[] r = u.Receive(ref ep);
                sw.Stop();
                if (r.Length < 12 || r[0] != q[0] || r[1] != q[1]) return -1;
                if ((r[3] & 0x0F) != 0) return -1;
                return sw.Elapsed.TotalMilliseconds;
            }
        } catch { return -1; }
    }
}
'@
$FichierDns = Join-Path $env:ProgramData 'OptiGame\dns.json'
$FournisseursDns = @(
    [pscustomobject]@{ Nom = 'Cloudflare'; V4 = @('1.1.1.1', '1.0.0.1'); V6 = @('2606:4700:4700::1111', '2606:4700:4700::1001'); Info = 'Souvent le plus rapide, respecte la vie privee.' }
    [pscustomobject]@{ Nom = 'Google'; V4 = @('8.8.8.8', '8.8.4.4'); V6 = @('2001:4860:4860::8888', '2001:4860:4860::8844'); Info = 'Tres fiable, rapide partout.' }
    [pscustomobject]@{ Nom = 'Quad9'; V4 = @('9.9.9.9', '149.112.112.112'); V6 = @('2620:fe::fe', '2620:fe::9'); Info = 'Bloque en plus les sites dangereux (virus, arnaques).' }
    [pscustomobject]@{ Nom = 'OpenDNS'; V4 = @('208.67.222.222', '208.67.220.220'); V6 = @('2620:119:35::35', '2620:119:53::53'); Info = 'Cisco, fiable.' }
)
$DomainesTestDns = @('www.google.com', 'www.youtube.com', 'discord.com', 'www.epicgames.com', 'www.roblox.com', 'store.steampowered.com', 'www.twitch.tv', 'www.callofduty.com', 'open.spotify.com', 'www.ea.com')

# Cartes reseau physiques connectees
function Cartes-Actives { return @(Get-NetAdapter -Physical -ErrorAction SilentlyContinue | Where-Object { $_.Status -eq 'Up' }) }

function Dns-Actuels {
    $r = @()
    foreach ($c in (Cartes-Actives)) { $r += @(Get-DnsClientServerAddress -InterfaceIndex $c.ifIndex -AddressFamily IPv4 -ErrorAction SilentlyContinue | ForEach-Object { $_.ServerAddresses }) }
    return @($r | Where-Object { $_ } | Select-Object -Unique)
}
function Nom-Dns($ips) {
    foreach ($f in $FournisseursDns) { if (@($ips | Where-Object { $f.V4 -contains $_ }).Count) { return $f.Nom } }
    return 'Ta box / ton operateur'
}

# Etat de la connexion, lu en arriere-plan (les commandes reseau de Windows sont lentes)
function Lancer-EtatReseau {
    if ($script:TacheReseau -and -not $script:TacheReseau.H.IsCompleted) { return }
    $UI.TxtNetEtat.Text = 'Lecture de ta connexion...'
    $ps = [powershell]::Create()
    [void]$ps.AddScript({
        $l = New-Object System.Collections.ArrayList
        foreach ($c in @(Get-NetAdapter -Physical -ErrorAction SilentlyContinue | Where-Object { $_.Status -eq 'Up' })) {
            $wifi = ($c.MediaType -eq 'Native 802.11' -or "$($c.PhysicalMediaType)" -match '802\.11' -or "$($c.InterfaceDescription)" -match 'Wi-?Fi|Wireless|WLAN')
            $type = if ($wifi) { 'Wi-Fi' } else { 'Cable Ethernet' }
            [void]$l.Add("Connexion : $type - $($c.LinkSpeed) ($($c.InterfaceDescription))")
            if ($wifi) {
                try {
                    $w = (netsh.exe wlan show interfaces) -join "`n"
                    $sig = if ($w -match '(?m)^\s*(Signal|Signal)\s*:\s*(\d+)\s*%') { $Matches[2] } else { $null }
                    $bande = if ($w -match '(?m)^\s*(Bande|Band)\s*:\s*(.+)$') { $Matches[2].Trim() } else { '' }
                    if ($sig) { [void]$l.Add("   Signal Wi-Fi : $sig %$(if ($bande) { " - $bande" })$(if ([int]$sig -lt 60) { '  (faible : rapproche-toi de la box ou passe en cable)' })") }
                } catch {}
            }
            $cfg = Get-NetIPConfiguration -InterfaceIndex $c.ifIndex -ErrorAction SilentlyContinue
            $ip = @($cfg.IPv4Address | ForEach-Object { $_.IPAddress }) -join ', '
            $gw = @($cfg.IPv4DefaultGateway | ForEach-Object { $_.NextHop }) | Select-Object -First 1
            if ($ip) { [void]$l.Add("   Adresse du PC : $ip") }
            if ($gw) {
                $t = @()
                $p = New-Object System.Net.NetworkInformation.Ping
                for ($i = 0; $i -lt 5; $i++) { try { $rep = $p.Send($gw, 1000); if ($rep.Status -eq 'Success') { $t += $rep.RoundtripTime } } catch {} }
                $moy = if ($t.Count) { [math]::Round(($t | Measure-Object -Average).Average) } else { $null }
                [void]$l.Add("   Box : $gw - ping $(if ($null -ne $moy) { "$moy ms$(if ($moy -gt 5) { '  (eleve pour la box : Wi-Fi charge ou cable abime ?)' })" } else { 'pas de reponse' })")
            }
            $dns = @(Get-DnsClientServerAddress -InterfaceIndex $c.ifIndex -AddressFamily IPv4 -ErrorAction SilentlyContinue | ForEach-Object { $_.ServerAddresses }) -join ', '
            if ($dns) { [void]$l.Add("   DNS : $dns") }
        }
        if ($l.Count -eq 0) { [void]$l.Add('Aucune connexion reseau active.') }
        ($l -join "`r`n")
    })
    $script:TacheReseau = @{ PS = $ps; H = $ps.BeginInvoke() }
    if (-not $script:MinuterieReseau) {
        $script:MinuterieReseau = New-Object System.Windows.Threading.DispatcherTimer
        $script:MinuterieReseau.Interval = [TimeSpan]::FromMilliseconds(300)
        $script:MinuterieReseau.Add_Tick({
            if (-not $script:TacheReseau.H.IsCompleted) { return }
            $script:MinuterieReseau.Stop()
            $txt = $null
            try { $txt = @($script:TacheReseau.PS.EndInvoke($script:TacheReseau.H)) -join "`r`n" } catch {}
            try { $script:TacheReseau.PS.Dispose() } catch {}
            $UI.TxtNetEtat.Text = if ($txt) { $txt } else { 'Impossible de lire l''etat de la connexion.' }
            # Nom du DNS utilise
            $d = @(Dns-Actuels)
            $UI.TxtDnsActuel.Text = if ($d.Count) { "DNS utilise maintenant : $(Nom-Dns $d) ($($d -join ', '))$(if (Test-Path $FichierDns) { '  -  choisi par OptiGame' })" } else { '' }
            $UI.BtnDnsRemettre.Visibility = $(if (Test-Path $FichierDns) { 'Visible' } else { 'Collapsed' })
        })
    }
    $script:MinuterieReseau.Start()
}

function Reparer-Connexion {
    Invoke-Action 'Reparation de la connexion' {
        Write-Log '   Vidage du cache DNS (adresses des sites memorisees)...'
        try { Clear-DnsClientCache } catch { Run-Ext 'ipconfig.exe' '/flushdns' | Out-Null }
        Write-Log '   Renouvellement de l''adresse IP (sans couper la connexion)...'
        Run-Ext 'ipconfig.exe' '/renew' | Out-Null
        Write-Log '   Connexion rafraichie. Si ca ne suffit pas : redemarre ta box (debranche 30 secondes).' 'Gold'
    }
    Lancer-EtatReseau
}

# ---------- Test des DNS (en arriere-plan) ----------
function Lancer-TestDns {
    if ($script:TacheDns -and -not $script:TacheDns.H.IsCompleted) { return }
    try { Charger-Type 'OGDns' $CodeDns } catch { Show-Info "Test impossible : $($_.Exception.Message)" 'DNS'; return }
    $actuels = @(Dns-Actuels | Where-Object { $_ -match '^\d+\.\d+\.\d+\.\d+$' })
    $liste = @()
    if ($actuels.Count -and (Nom-Dns $actuels) -eq 'Ta box / ton operateur') { $liste += [pscustomobject]@{ Nom = 'Ta box / ton operateur (actuel)'; V4 = $actuels; Info = 'Celui que tu utilises maintenant.'; Actuel = $true } }
    foreach ($f in $FournisseursDns) { $liste += [pscustomobject]@{ Nom = $f.Nom; V4 = $f.V4; Info = $f.Info; Actuel = (@($actuels | Where-Object { $f.V4 -contains $_ }).Count -gt 0) } }
    $UI.TxtDnsEtat.Text = 'Test en cours : 10 sites x 3 questions pour chaque DNS (environ 10 secondes)...'
    $UI.BtnDnsTester.IsEnabled = $false
    $ps = [powershell]::Create()
    [void]$ps.AddScript({
        param($liste, $domaines)
        foreach ($s in $liste) {
            $t = @(); $echecs = 0
            for ($tour = 0; $tour -lt 3; $tour++) {
                foreach ($d in $domaines) {
                    $ms = [OGDns]::Requete($s.V4[0], $d, 1500)
                    if ($ms -lt 0) { $echecs++ } else { $t += $ms }
                }
            }
            $med = if ($t.Count) { ($t | Sort-Object)[[int]($t.Count / 2)] } else { 9999 }
            [pscustomobject]@{ Nom = $s.Nom; Ms = [math]::Round($med, 1); Echecs = $echecs; Info = $s.Info; Actuel = $s.Actuel }
        }
    }).AddArgument($liste).AddArgument($DomainesTestDns)
    $script:TacheDns = @{ PS = $ps; H = $ps.BeginInvoke() }
    if (-not $script:MinuterieDns) {
        $script:MinuterieDns = New-Object System.Windows.Threading.DispatcherTimer
        $script:MinuterieDns.Interval = [TimeSpan]::FromMilliseconds(300)
        $script:MinuterieDns.Add_Tick({
            if (-not $script:TacheDns.H.IsCompleted) { return }
            $script:MinuterieDns.Stop()
            $UI.BtnDnsTester.IsEnabled = $true
            $res = @()
            try { $res = @($script:TacheDns.PS.EndInvoke($script:TacheDns.H)) } catch {}
            try { $script:TacheDns.PS.Dispose() } catch {}
            Afficher-ResultatsDns $res
        })
    }
    $script:MinuterieDns.Start()
}

function Afficher-ResultatsDns($res) {
    $ok = @($res | Where-Object { $_.Ms -lt 9999 } | Sort-Object Ms)
    if (-not $ok.Count) { $UI.TxtDnsEtat.Text = 'Aucun DNS n''a repondu : verifie ta connexion (ou un pare-feu bloque le test).'; return }
    $meilleur = $ok[0]
    $actuel = $res | Where-Object { $_.Actuel } | Select-Object -First 1
    $max = [double]($ok | Measure-Object Ms -Maximum).Maximum
    $items = @(foreach ($r in @($ok) + @($res | Where-Object { $_.Ms -ge 9999 })) {
        $est = ($r.Nom -eq $meilleur.Nom)
        [pscustomobject]@{
            Nom = $r.Nom + $(if ($r.Actuel -and $r.Nom -notmatch 'actuel') { '  (actuel)' } else { '' })
            Temps = $(if ($r.Ms -ge 9999) { 'pas de reponse' } else { "$($r.Ms) ms" })
            Info = $r.Info + $(if ($r.Echecs) { "  -  $($r.Echecs) question(s) sans reponse" } else { '' })
            Largeur = $(if ($r.Ms -ge 9999 -or $max -le 0) { 4 } else { [math]::Max(6, 220 * $r.Ms / $max) })
            Couleur = $(if ($est) { '#3FE08E' } elseif ($r.Echecs -gt 3) { '#FF8A97' } else { '#8C95A8' })
            Fournisseur = $(($r.Nom -replace '\s*\(actuel\)', ''))
            VisUtiliser = $(if ($r.Actuel -or $r.Nom -match '^Ta box') { 'Collapsed' } else { 'Visible' })
        }
    })
    $UI.ListeDns.ItemsSource = $items
    $gain = if ($actuel) { [math]::Round($actuel.Ms - $meilleur.Ms, 1) } else { $null }
    $UI.TxtDnsEtat.Text = if ($meilleur.Actuel) { "Ton DNS actuel est deja le plus rapide ($($meilleur.Ms) ms) : rien a changer." }
        elseif ($null -ne $gain -and $gain -lt 3) { "$($meilleur.Nom) est le plus rapide ($($meilleur.Ms) ms), mais ton DNS actuel n'est que $gain ms plus lent : le changement ne se sentira pas." }
        else { "Le plus rapide : $($meilleur.Nom) ($($meilleur.Ms) ms)$(if ($null -ne $gain) { ", soit $gain ms de moins a chaque nouveau site ou serveur contacte" }). Clique sur Utiliser pour le mettre." }
}

function Appliquer-Dns([string]$nom) {
    $f = $FournisseursDns | Where-Object { $_.Nom -eq $nom } | Select-Object -First 1
    if (-not $f) { return }
    $cartes = @(Cartes-Actives)
    if (-not $cartes.Count) { Show-Info 'Aucune carte reseau connectee.' 'DNS'; return }
    $avant = if (Test-Path $FichierDns) { try { Get-Content $FichierDns -Raw | ConvertFrom-Json } catch { $null } } else { $null }
    $memo = if ($avant -and $avant.Avant) { @($avant.Avant) } else {
        @(foreach ($c in $cartes) {
            $g = "$($c.InterfaceGuid)"
            [pscustomobject]@{ Index = $c.ifIndex; Guid = $g
                V4 = "$(Lire-Reg "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\$g" 'NameServer')"
                V6 = "$(Lire-Reg "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters\Interfaces\$g" 'NameServer')" }
        })
    }
    $ancien = Nom-Dns (Dns-Actuels)
    $script:SourceAction = "Bouton Utiliser $nom (page Reseau)"
    Invoke-Action "DNS $nom" {
        foreach ($c in $cartes) {
            Set-DnsClientServerAddress -InterfaceIndex $c.ifIndex -ServerAddresses (@($f.V4) + @($f.V6)) -ErrorAction Stop
            Write-Log "   $($c.Name) : DNS $nom ($($f.V4 -join ', '))." 'Gray'
        }
        try { Clear-DnsClientCache } catch {}
        Ajouter-Journal 'DNS (adresses des sites)' $ancien $nom 'Le DNS traduit les noms des sites et des serveurs de jeux en adresses : un DNS plus rapide = connexions qui demarrent plus vite.'
    }
    $script:SourceAction = $null
    New-Item -ItemType Directory -Path (Split-Path $FichierDns) -Force | Out-Null
    ([pscustomobject]@{ Choix = $nom; Avant = $memo }) | ConvertTo-Json -Depth 4 | Out-File -FilePath $FichierDns -Encoding UTF8
    Afficher-Toast "DNS $nom active."
    Lancer-EtatReseau
}

function Remettre-Dns {
    if (-not (Test-Path $FichierDns)) { return }
    $j = $null; try { $j = Get-Content $FichierDns -Raw | ConvertFrom-Json } catch {}
    $script:SourceAction = 'Bouton Remettre le DNS d''origine (page Reseau)'
    Invoke-Action 'DNS d''origine' {
        foreach ($a in @($j.Avant)) {
            $liste = @("$($a.V4)", "$($a.V6)" | ForEach-Object { $_ -split '[,\s]+' } | Where-Object { $_ })
            try {
                if ($liste.Count) { Set-DnsClientServerAddress -InterfaceIndex $a.Index -ServerAddresses $liste -ErrorAction Stop }
                else { Set-DnsClientServerAddress -InterfaceIndex $a.Index -ResetServerAddresses -ErrorAction Stop }
            } catch { Write-Log "   Carte $($a.Index) : $($_.Exception.Message)" 'Gray' }
        }
        try { Clear-DnsClientCache } catch {}
        Ajouter-Journal 'DNS (adresses des sites)' "$($j.Choix)" 'Origine (box)'
    }
    $script:SourceAction = $null
    Remove-Item -LiteralPath $FichierDns -Force -ErrorAction SilentlyContinue
    Afficher-Toast 'DNS d''origine remis.' 'info'
    Lancer-EtatReseau
}

# =====================================================================
#  VRAI PLEIN ECRAN (exclusif) pour tous les jeux
#  - Windows : optimisations plein ecran coupees (globalement + pour chaque jeu trouve),
#    pour qu'un jeu en plein ecran (ou Alt+Entree) prenne vraiment l'ecran pour lui seul.
#  - Jeux qui le permettent : mode "plein ecran" (pas fenetre sans bordure) dans leurs fichiers.
# =====================================================================
$FichierPE = Join-Path $env:ProgramData 'OptiGame\plein_ecran.json'
$CleFse = 'HKCU:\System\GameConfigStore'
$ValeursFse = [ordered]@{ GameDVR_FSEBehaviorMode = 2; GameDVR_HonorUserFSEBehaviorMode = 1; GameDVR_FSEBehavior = 2; GameDVR_DXGIHonorFSEWindowsCompatible = 1 }
$OptionAntiBug = 'Anti-bug 2 ecrans : plein ecran sans changement de resolution'
$ClesPEUE = @('FullscreenMode', 'LastConfirmedFullscreenMode', 'PreferredFullscreenMode')

function PE-Actif { return (Test-Path $FichierPE) }

function Activer-VraiPleinEcran {
    # L'anti-bug 2 ecrans fait l'inverse (plein ecran fenetre) : il est retire tout seul... sauf pour Fortnite,
    # qui n'est jamais mis en vrai plein ecran (DirectX 12 + 2 ecrans = ecran noir, plein ecran sur les 2 ecrans)
    $avecAntiBug = @($Jeux.Keys | Where-Object { $_ -ne 'Fortnite' } | Where-Object { $c = Get-ChoixJeu $_; @($c.Choix) + @($c.Appliques) -contains $OptionAntiBug })
    if ($avecAntiBug.Count) { Retirer-AntiBug $avecAntiBug }
    $enCours = New-Object System.Collections.ArrayList
    $script:SourceAction = 'Interrupteur Vrai plein ecran (page Jeux)'
    Invoke-Action 'Vrai plein ecran' {
        # (pas de reglage Windows global : il touchait aussi Fortnite et causait ses bugs d'affichage)
        Ajouter-Journal 'Plein ecran des jeux' 'Optimise par Windows (sans bordure)' 'Vrai plein ecran (exclusif)' 'Les jeux en plein ecran prennent l''ecran pour eux seuls : un peu moins de latence dans les jeux DirectX 9 a 11.'
        # Les reglages du jeu ne sont pas touches. Si le plein ecran est deja active DANS le jeu, OptiGame le laisse gerer.
        foreach ($j in @($Jeux.Keys)) {
            if ($j -eq 'Fortnite') { continue }   # Fortnite (DirectX 12) le gere lui-meme, et ce reglage lui causait des bugs d'affichage
            if ((PleinEcran-Natif $j) -eq $true) { Write-Log "   $j : plein ecran deja regle dans le jeu, OptiGame le laisse gerer." 'Gray'; continue }
            if (Jeu-EnCours $j) { [void]$enCours.Add($j) }
            try { $exes = @(& $Jeux[$j].Exe) } catch { $exes = @() }
            $exes = @($exes | Where-Object { $_ -and (Test-Path -LiteralPath $_) })
            if ($exes.Count) { Write-Log "   $j :"; Set-FsoJeu $j $exes }
        }
        if (@(Trouver-ExeRoblox).Count -and (PleinEcran-Natif 'Roblox') -ne $true) { Write-Log '   Roblox : Alt+Entree = vrai plein ecran...'; Set-FlagsRoblox @{ 'FFlagHandleAltEnterFullscreenManually' = 'False' } 'Alt+Entree vrai plein ecran' }
    }
    $script:SourceAction = $null
    New-Item -ItemType Directory -Path (Split-Path $FichierPE) -Force | Out-Null
    ([pscustomobject]@{ Global = $false }) | ConvertTo-Json -Depth 4 | Out-File -FilePath $FichierPE -Encoding UTF8
    Proteger-Fortnite
    Maj-PleinEcran
    Afficher-Toast $(if ($enCours.Count) { "Vrai plein ecran active (relance $($enCours -join ', ') pour en profiter)." } else { 'Vrai plein ecran active.' })
}

function Desactiver-VraiPleinEcran {
    $j0 = $null; try { $j0 = Get-Content $FichierPE -Raw | ConvertFrom-Json } catch {}
    $script:SourceAction = 'Interrupteur Vrai plein ecran (page Jeux)'
    Invoke-Action 'Plein ecran normal' {
        Rendre-FseGlobal $j0
        Ajouter-Journal 'Plein ecran des jeux' 'Vrai plein ecran (exclusif)' 'Optimise par Windows'
        # Optimisations plein ecran rendues a chaque jeu (sauf si l'option du jeu est cochee)
        foreach ($j in @($Jeux.Keys)) {
            if (@((Get-ChoixJeu $j).Appliques) -contains 'Desactiver les optimisations plein ecran de Windows') { continue }
            $idx = Lire-IndexJeu $j
            $reste = New-Object System.Collections.ArrayList
            $chg = $false
            foreach ($e in $idx) {
                if ($e.Type -eq 'layers') {
                    if ("$($e.Val)".Trim()) { Set-Reg $CleLayers $e.Orig "$($e.Val)" 'String' } else { Remove-Reg $CleLayers $e.Orig }
                    $chg = $true
                } else { [void]$reste.Add($e) }
            }
            if ($chg) { Ecrire-IndexJeu $j $reste; Write-Log "   $j : optimisations plein ecran de Windows remises." 'Gray' }
        }
        $f = Join-Path (Dossier-ConfigPalworld) 'GameUserSettings.ini'
        if (Test-Path -LiteralPath $f) { $sec = Section-AvecCle $f 'FullscreenMode'; if ($sec) { foreach ($k in $ClesPEUE) { Rendre-CleIni 'Palworld' $f $sec $k } } }
        $f = & $Jeux['Rocket League'].Config
        if (Test-Path -LiteralPath $f) { foreach ($k in 'Fullscreen', 'Borderless') { Rendre-CleIni 'Rocket League' $f 'SystemSettings' $k } }
        foreach ($d in @(Trouver-ExeRoblox | ForEach-Object { Split-Path $_ } | Select-Object -Unique)) {
            $fr = Join-Path $d 'ClientSettings\ClientAppSettings.json'
            if (-not (Test-Path -LiteralPath $fr)) { continue }
            $o = Lire-FlagsRoblox $fr
            if ($o.Contains('FFlagHandleAltEnterFullscreenManually')) { $o.Remove('FFlagHandleAltEnterFullscreenManually'); Ecrire-FlagsRoblox $fr $o }
        }
        Write-Log '   Plein ecran remis comme avant.'
    }
    $script:SourceAction = $null
    Remove-Item -LiteralPath $FichierPE -Force -ErrorAction SilentlyContinue
    Maj-PleinEcran
    Afficher-Toast 'Plein ecran remis comme avant.' 'info'
}

# Anciennes versions : le vrai plein ecran changeait un reglage Windows global (il touchait aussi Fortnite) : on le rend
function Rendre-FseGlobal($j0) {
    if (-not $j0) { return }
    if ($null -ne $j0.PSObject.Properties['Global'] -and -not $j0.Global) { return }
    foreach ($k in $ValeursFse.Keys) {
        $v = if ($j0.Avant) { $j0.Avant.$k } else { $null }
        if ($null -ne $v -and "$v" -ne '') { Set-Reg $CleFse $k ([int]$v) } else { Remove-Reg $CleFse $k }
    }
}
# Retire l'anti-bug 2 ecrans de certains jeux (et remet leur mode d'affichage d'avant)
function Retirer-AntiBug($jeux) {
    foreach ($j in @($jeux)) {
        $c = Get-ChoixJeu $j
        $c.Choix = @(@($c.Choix) | Where-Object { $_ -ne $OptionAntiBug })
        $c.Appliques = @(@($c.Appliques) | Where-Object { $_ -ne $OptionAntiBug })
        foreach ($e in @(Lire-IndexJeu $j | Where-Object { $_.Type -eq 'ini' -and $ClesAntiBug -contains $_.Cle })) { Rendre-CleIni $j $e.Orig $e.Section $e.Cle }
    }
    Sauver-ChoixJeux
}
# Avec 2 ecrans, Fortnite garde toujours l'anti-bug (plein ecran fenetre sur l'ecran principal) : Alt+Entree ne peut plus le casser
function Proteger-Fortnite {
    if ([System.Windows.Forms.Screen]::AllScreens.Count -lt 2 -or -not $Jeux.Contains('Fortnite')) { return }
    $f = & $Jeux['Fortnite'].Config
    if (-not $f -or -not (Test-Path -LiteralPath $f)) { return }
    $c = Get-ChoixJeu 'Fortnite'
    if (@($c.Appliques) -contains $OptionAntiBug) { return }
    $c.Choix = @(@($c.Choix) + $OptionAntiBug | Select-Object -Unique)
    if (Jeu-EnCours 'Fortnite') { $script:EnAttente['Fortnite'] = $true; Sauver-ChoixJeux; return }
    $script:SourceAction = 'Protection automatique de Fortnite (2 ecrans)'
    try { Set-AntiBugUE 'Fortnite' $f; $c.Appliques = @(@($c.Appliques) + $OptionAntiBug | Select-Object -Unique) } catch {}
    $script:SourceAction = $null
    Sauver-ChoixJeux
}
# Au demarrage : corrige l'ancien vrai plein ecran (reglage global) et protege Fortnite
function Migrer-PleinEcran {
    if (-not (PE-Actif)) { return }
    $j0 = $null; try { $j0 = Get-Content $FichierPE -Raw | ConvertFrom-Json } catch {}
    if ($j0 -and ($null -eq $j0.PSObject.Properties['Global'] -or $j0.Global)) {
        Rendre-FseGlobal $j0
        ([pscustomobject]@{ Global = $false }) | ConvertTo-Json | Out-File -FilePath $FichierPE -Encoding UTF8
        Write-Log 'Vrai plein ecran : reglage Windows global retire (il faisait buguer Fortnite avec 2 ecrans).' 'Gray'
    }
    Proteger-Fortnite
}

# ---------- Plein ecran deja regle DANS le jeu ? Alors OptiGame laisse le jeu gerer ----------
# (deux plein ecrans en meme temps = ecran noir, plein ecran sur les 2 ecrans, resolution folle)
function PleinEcran-Natif([string]$j) {
    try { $cfg = & $Jeux[$j].Config } catch { $cfg = $null }
    if (-not $cfg -or -not (Test-Path -LiteralPath $cfg)) { return $null }
    try {
        switch ($j) {
            'Rocket League' {
                $fs = Valeur-Ini $cfg 'SystemSettings' 'Fullscreen'
                if ($null -eq $fs) { return $null }
                return ($fs -eq 'True' -and (Valeur-Ini $cfg 'SystemSettings' 'Borderless') -ne 'True')
            }
            'Roblox' { return ((Get-Content -LiteralPath $cfg -Raw) -match '<bool name="Fullscreen">true</bool>') }
            'Minecraft' { $o = Join-Path $cfg 'options.txt'; if (Test-Path -LiteralPath $o) { return ((Get-Content -LiteralPath $o -Raw) -match '(?m)^fullscreen:true') }; return $null }
            'GTA V' { $x = Join-Path $cfg 'settings.xml'; if (Test-Path -LiteralPath $x) { return ((Get-Content -LiteralPath $x -Raw) -match '<Windowed value="0"') }; return $null }
            'Apex Legends' { $v = Join-Path $cfg 'videoconfig.txt'; if (Test-Path -LiteralPath $v) { $t = Get-Content -LiteralPath $v -Raw; return ($t -match '"setting\.fullscreen"\s+"1"' -and $t -notmatch '"setting\.nowindowborder"\s+"1"') }; return $null }
        }
        # Jeux Unreal (Palworld, Valorant...) : GameUserSettings.ini, FullscreenMode = 0 (plein ecran)
        $f = if (Test-Path -LiteralPath $cfg -PathType Leaf) { $cfg } else { Get-ChildItem -LiteralPath $cfg -Filter 'GameUserSettings.ini' -Recurse -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1 -ExpandProperty FullName }
        if (-not $f -or $f -notmatch '\.ini$') { return $null }
        $sec = Section-AvecCle $f 'FullscreenMode'
        if (-not $sec) { return $null }
        return ("$(Valeur-Ini $f $sec 'FullscreenMode')" -eq '0')
    } catch { return $null }
}
# Enleve le vrai plein ecran d'OptiGame pour un jeu (optimisations plein ecran de Windows rendues)
function Retirer-PEJeu([string]$j) {
    $idx = Lire-IndexJeu $j
    $reste = New-Object System.Collections.ArrayList
    $chg = $false
    foreach ($e in $idx) {
        if ($e.Type -eq 'layers') {
            if ("$($e.Val)".Trim()) { Set-Reg $CleLayers $e.Orig "$($e.Val)" 'String' } else { Remove-Reg $CleLayers $e.Orig }
            $chg = $true
        } else { [void]$reste.Add($e) }
    }
    if ($chg) { Ecrire-IndexJeu $j $reste }
    if ($j -eq 'Roblox') {
        foreach ($d in @(Trouver-ExeRoblox | ForEach-Object { Split-Path $_ } | Select-Object -Unique)) {
            $fr = Join-Path $d 'ClientSettings\ClientAppSettings.json'
            if (-not (Test-Path -LiteralPath $fr)) { continue }
            $o = Lire-FlagsRoblox $fr
            if ($o.Contains('FFlagHandleAltEnterFullscreenManually')) { $o.Remove('FFlagHandleAltEnterFullscreenManually'); Ecrire-FlagsRoblox $fr $o; $chg = $true }
        }
    }
    return $chg
}
function PE-Pose([string]$j) {
    if (@(Lire-IndexJeu $j | Where-Object { $_.Type -eq 'layers' }).Count) { return $true }
    return $false
}
# Verifie les jeux fermes (un reglage change pendant la partie ne compte qu'au prochain lancement).
# Sans -Jeu : verification legere reguliere (seulement les jeux ou OptiGame a mis son vrai plein ecran).
# Avec -Jeu : jeu qui vient de se fermer, OptiGame peut aussi remettre son vrai plein ecran si le jeu est repasse en fenetre.
function Ajuster-PleinEcranJeux([string]$Jeu) {
    if (-not (PE-Actif)) { return }
    $liste = if ($Jeu) { @($Jeu) } else { @($Jeux.Keys | Where-Object { (PE-Pose $_) -or $_ -eq 'Roblox' }) }
    foreach ($j in $liste) {
        if (-not $Jeux.Contains($j) -or $j -eq 'Fortnite' -or (Jeu-EnCours $j)) { continue }
        if (@((Get-ChoixJeu $j).Appliques) -contains 'Desactiver les optimisations plein ecran de Windows') { continue }
        $natif = PleinEcran-Natif $j
        if ($natif -eq $true) {
            if ((PE-Pose $j) -or ($j -eq 'Roblox')) {
                if (Retirer-PEJeu $j) {
                    Write-Log "$j : le plein ecran est deja regle dans le jeu, OptiGame enleve son vrai plein ecran pour ce jeu (pas de double plein ecran)." 'Gray'
                    $script:SourceAction = 'Vrai plein ecran (ajustement automatique)'
                    Ajouter-Journal "$j : vrai plein ecran d'OptiGame" 'Actif' 'Laisse au jeu' 'Le plein ecran est deja active dans les parametres du jeu : deux plein ecrans en meme temps feraient buguer l''affichage.'
                    $script:SourceAction = $null
                }
            }
        } elseif ($Jeu -and -not (PE-Pose $j)) {
            try { $exes = @(& $Jeux[$j].Exe) } catch { $exes = @() }
            $exes = @($exes | Where-Object { $_ -and (Test-Path -LiteralPath $_) })
            if ($exes.Count) {
                $script:SourceAction = 'Vrai plein ecran (ajustement automatique)'
                Set-FsoJeu $j $exes
                $script:SourceAction = $null
            }
        }
    }
}

function Maj-PleinEcran {
    if (-not $UI.ChkPleinEcran) { return }
    $on = PE-Actif
    try { $script:MajPEEnCours = $true; $UI.ChkPleinEcran.IsChecked = $on } finally { $script:MajPEEnCours = $false }
    $UI.TxtPleinEcranEtat.Text = if ($on) { 'ACTIF : plein ecran du jeu ou Alt+Entree = vrai plein ecran.' } else { 'Le jeu prend l''ecran pour lui seul (pas de fenetre sans bordure).' }
    $UI.TxtPleinEcranEtat.Foreground = Pinceau $(if ($on) { '#3FE08E' } else { '#8C95A8' })
    try {
        $script:MajPEEnCours = $true
        if ($UI.ChkSourisJeu) { $UI.ChkSourisJeu.IsChecked = (Souris-Activee) }
        if ($UI.ChkWinJeu) { $UI.ChkWinJeu.IsChecked = (Win-Activee) }
        if ($UI.ChkAntiBugTous) {
            $ab = AntiBug-Actif
            $UI.ChkAntiBugTous.IsChecked = $ab
            $UI.TxtAntiBugTous.Text = if ($ab) { 'ACTIF : plein ecran fenetre stable pour tes jeux.' } else { 'Plein ecran fenetre stable : plus de bugs avec 2 ecrans.' }
            $UI.TxtAntiBugTous.Foreground = Pinceau $(if ($ab) { '#3FE08E' } else { '#8C95A8' })
        }
    } finally { $script:MajPEEnCours = $false }
}

# =====================================================================
#  NOUVEAUTES : affichees une fois apres une mise a jour (et bouton dans Versions)
# =====================================================================
$FichierNouv = Join-Path $env:ProgramData 'OptiGame\nouveautes_vues.txt'
function Afficher-Nouveautes {
    $notes = Notes-Fichier $script:CheminScript
    Show-Info "Nouveautes d'OptiGame v$VersionApp :`r`n`r`n$notes" "Nouveautes v$VersionApp"
}
function Proposer-Nouveautes {
    $nom = [IO.Path]::GetFileName($script:CheminScript)
    $vu = if (Test-Path $FichierNouv) { "$(Get-Content $FichierNouv -Raw -ErrorAction SilentlyContinue)".Trim() } else { '' }
    if ($vu -eq $nom) { return }
    # Premiere utilisation d'OptiGame sur ce PC : pas de "nouveautes", on note juste la version
    $dejaUtilise = $vu -or (Test-Path $FichierVersions)
    if ($dejaUtilise -and -not (Fenetre-Ouverte)) { $script:NouvEnAttente = $true; return }
    try { New-Item -ItemType Directory -Path (Split-Path $FichierNouv) -Force | Out-Null; $nom | Out-File -FilePath $FichierNouv -Encoding ASCII } catch {}
    $script:NouvEnAttente = $false
    if ($dejaUtilise) { Afficher-Nouveautes }
}

# =====================================================================
#  SOURIS BLOQUEE SUR L'ECRAN DU JEU (PC a 2 ecrans)
#  Meme en plein ecran, Windows laisse la souris passer sur l'autre ecran si le jeu ne la retient pas
#  (et un clic la-bas fait sortir du jeu). OptiGame la garde sur l'ecran du jeu tant que le jeu est
#  au premier plan. Alt+Tab, la touche Windows ou Ctrl+Alt+Suppr la liberent aussitot.
# =====================================================================
$FichierSouris = Join-Path $env:ProgramData 'OptiGame\souris_jeu.txt'
$CodeSourisJeu = @'
using System;
using System.Diagnostics;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading;
public static class OGSourisJeu {
    [StructLayout(LayoutKind.Sequential)] struct RECT { public int L, T, R, B; }
    [StructLayout(LayoutKind.Sequential)] struct POINT { public int X, Y; }
    [StructLayout(LayoutKind.Sequential)] struct MONITORINFO { public int cbSize; public RECT rcMonitor; public RECT rcWork; public uint dwFlags; }
    [StructLayout(LayoutKind.Sequential)] struct MSLL { public POINT pt; public uint mouseData; public uint flags; public uint time; public IntPtr extra; }
    [StructLayout(LayoutKind.Sequential)] struct KBDLL { public uint vk; public uint scan; public uint flags; public uint time; public IntPtr extra; }
    [StructLayout(LayoutKind.Sequential)] struct CURSORINFO { public int cbSize; public int flags; public IntPtr hCursor; public POINT pt; }
    [StructLayout(LayoutKind.Sequential)] struct MSG { public IntPtr hwnd; public uint message; public IntPtr wParam; public IntPtr lParam; public uint time; public POINT pt; }
    delegate IntPtr HookProc(int code, IntPtr wParam, IntPtr lParam);

    [DllImport("user32.dll")] static extern IntPtr GetForegroundWindow();
    [DllImport("user32.dll")] static extern uint GetWindowThreadProcessId(IntPtr h, out uint pid);
    [DllImport("user32.dll")] static extern bool GetWindowRect(IntPtr h, out RECT r);
    [DllImport("user32.dll")] static extern bool IsIconic(IntPtr h);
    [DllImport("user32.dll")] static extern IntPtr MonitorFromWindow(IntPtr h, uint flags);
    [DllImport("user32.dll")] static extern bool GetMonitorInfo(IntPtr m, ref MONITORINFO mi);
    [DllImport("user32.dll", EntryPoint = "ClipCursor")] static extern bool ClipRect(ref RECT r);
    [DllImport("user32.dll", EntryPoint = "ClipCursor")] static extern bool ClipAucun(IntPtr r);
    [DllImport("user32.dll")] static extern bool GetClipCursor(out RECT r);
    [DllImport("user32.dll")] static extern bool GetCursorPos(out POINT p);
    [DllImport("user32.dll")] static extern bool SetCursorPos(int x, int y);
    [DllImport("user32.dll")] static extern bool GetCursorInfo(ref CURSORINFO ci);
    [DllImport("user32.dll")] static extern int GetSystemMetrics(int i);
    [DllImport("user32.dll", CharSet = CharSet.Unicode)] static extern int GetClassName(IntPtr h, StringBuilder s, int n);
    [DllImport("user32.dll")] static extern IntPtr SetWindowsHookEx(int id, HookProc proc, IntPtr hMod, uint thread);
    [DllImport("user32.dll")] static extern bool UnhookWindowsHookEx(IntPtr h);
    [DllImport("user32.dll")] static extern IntPtr CallNextHookEx(IntPtr h, int code, IntPtr wParam, IntPtr lParam);
    [DllImport("user32.dll")] static extern int GetMessage(out MSG m, IntPtr h, uint min, uint max);
    [DllImport("user32.dll")] static extern bool PostThreadMessage(uint thread, uint msg, IntPtr w, IntPtr l);
    [DllImport("kernel32.dll")] static extern uint GetCurrentThreadId();
    [DllImport("kernel32.dll")] static extern IntPtr GetModuleHandle(string nom);
    [DllImport("winmm.dll")] static extern uint timeBeginPeriod(uint p);

    public static volatile bool Actif = false;      // souris gardee sur l'ecran du jeu (2 ecrans)
    public static volatile bool BloquerWin = false; // touche Windows sans effet pendant le jeu
    public static volatile bool BloquerAltEntree = false; // Alt+Entree sans effet dans certains jeux (Fortnite)
    public static string[] AltEntreeJeux = new string[0];
    static volatile string nomFg = "";
    public static int[] Pids = new int[0];
    public static string[] Exclus = new string[0];
    public static volatile string Jeu = "";
    static volatile bool enJeu = false, clipOn = false;
    static volatile int rL, rT, rR, rB;
    static bool bloque = false;
    static uint dernierPid = 0; static string dernierNom = "";
    static IntPtr derniereFenetre = IntPtr.Zero; static bool derniereCible = false; static RECT dernierEcran;
    static DateTime prochaineAnalyse = DateTime.MinValue;
    static Thread fil, filCrochets;
    static uint idCrochets = 0;
    static IntPtr hSouris = IntPtr.Zero, hClavier = IntPtr.Zero;
    static HookProc procSouris = ProcSouris, procClavier = ProcClavier;

    public static void Demarrer() {
        if (fil == null) { fil = new Thread(Boucle); fil.IsBackground = true; fil.Priority = ThreadPriority.AboveNormal; fil.Start(); }
        if (filCrochets == null) { filCrochets = new Thread(BoucleCrochets); filCrochets.IsBackground = true; filCrochets.Priority = ThreadPriority.Highest; filCrochets.Start(); }
        else Reinstaller();
    }
    // Met en place (ou enleve) les crochets souris / clavier selon les options choisies
    public static void Reinstaller() { if (idCrochets != 0) PostThreadMessage(idCrochets, 0x8001, IntPtr.Zero, IntPtr.Zero); }

    static void Appliquer() {
        IntPtr mod = GetModuleHandle(null);
        if (Actif && hSouris == IntPtr.Zero) hSouris = SetWindowsHookEx(14, procSouris, mod, 0);
        if (!Actif && hSouris != IntPtr.Zero) { UnhookWindowsHookEx(hSouris); hSouris = IntPtr.Zero; }
        bool clavier = BloquerWin || BloquerAltEntree;
        if (clavier && hClavier == IntPtr.Zero) hClavier = SetWindowsHookEx(13, procClavier, mod, 0);
        if (!clavier && hClavier != IntPtr.Zero) { UnhookWindowsHookEx(hClavier); hClavier = IntPtr.Zero; }
    }

    static void BoucleCrochets() {
        idCrochets = GetCurrentThreadId();
        Appliquer();
        MSG m;
        while (GetMessage(out m, IntPtr.Zero, 0, 0) > 0) { if (m.message == 0x8001) Appliquer(); }
    }

    // Souris : quand le curseur est visible (menus du jeu), il ne peut pas sortir de l'ecran du jeu.
    // Quand il est cache (camera du jeu), on ne bloque rien : le jeu recoit tous les mouvements.
    static IntPtr ProcSouris(int code, IntPtr wParam, IntPtr lParam) {
        try {
            if (code >= 0 && clipOn && wParam.ToInt32() == 0x200) {
                MSLL s = (MSLL)Marshal.PtrToStructure(lParam, typeof(MSLL));
                if ((s.flags & 1) == 0 && (s.pt.X < rL || s.pt.X >= rR || s.pt.Y < rT || s.pt.Y >= rB)) {
                    CURSORINFO ci = new CURSORINFO(); ci.cbSize = Marshal.SizeOf(typeof(CURSORINFO));
                    if (GetCursorInfo(ref ci) && (ci.flags & 1) != 0) {
                        SetCursorPos(Math.Max(rL, Math.Min(rR - 1, s.pt.X)), Math.Max(rT, Math.Min(rB - 1, s.pt.Y)));
                        return new IntPtr(1);
                    }
                }
            }
        } catch { }
        return CallNextHookEx(hSouris, code, wParam, lParam);
    }

    // Clavier : seules les touches Windows (jeu en plein ecran) et Alt+Entree (dans Fortnite) sont ignorees.
    // Aucune autre touche n'est regardee.
    static IntPtr ProcClavier(int code, IntPtr wParam, IntPtr lParam) {
        try {
            if (code >= 0) {
                KBDLL k = (KBDLL)Marshal.PtrToStructure(lParam, typeof(KBDLL));
                if (enJeu && BloquerWin && (k.vk == 0x5B || k.vk == 0x5C)) return new IntPtr(1);
                if (BloquerAltEntree && k.vk == 0x0D && (k.flags & 0x20) != 0) {
                    string n = nomFg;
                    foreach (string j in AltEntreeJeux) if (string.Equals(j, n, StringComparison.OrdinalIgnoreCase)) return new IntPtr(1);
                }
            }
        } catch { }
        return CallNextHookEx(hClavier, code, wParam, lParam);
    }

    static void Liberer() { clipOn = false; if (bloque) { ClipAucun(IntPtr.Zero); bloque = false; } }

    static string NomProcessus(uint pid) {
        if (pid == dernierPid) return dernierNom;
        dernierPid = pid;
        try { dernierNom = Process.GetProcessById((int)pid).ProcessName; } catch { dernierNom = ""; }
        return dernierNom;
    }

    static bool Dedans(RECT a, RECT b) { return a.L >= b.L && a.T >= b.T && a.R <= b.R && a.B <= b.B; }

    static bool EstCible(IntPtr h, out RECT ecran) {
        if (h == derniereFenetre && DateTime.UtcNow < prochaineAnalyse) { ecran = dernierEcran; return derniereCible; }
        derniereFenetre = h; prochaineAnalyse = DateTime.UtcNow.AddMilliseconds(150);
        uint pid; GetWindowThreadProcessId(h, out pid);
        RECT r; GetWindowRect(h, out r);
        MONITORINFO mi = new MONITORINFO(); mi.cbSize = Marshal.SizeOf(typeof(MONITORINFO));
        GetMonitorInfo(MonitorFromWindow(h, 2), ref mi);
        ecran = mi.rcMonitor; dernierEcran = ecran;
        // Seulement en PLEIN ECRAN : jeu en fenetre = souris et touche Windows libres
        bool plein = r.L <= ecran.L && r.T <= ecran.T && r.R >= ecran.R && r.B >= ecran.B;
        bool cible = false;
        string nom = NomProcessus(pid);
        if (plein) {
            cible = Array.IndexOf(Pids, (int)pid) >= 0;
            if (!cible) {
                StringBuilder cl = new StringBuilder(64); GetClassName(h, cl, 64);
                string c = cl.ToString();
                bool exclu = c == "Progman" || c == "WorkerW" || nom == "";
                foreach (string e in Exclus) if (string.Equals(e, nom, StringComparison.OrdinalIgnoreCase)) { exclu = true; break; }
                cible = !exclu;
            }
        }
        Jeu = cible ? nom : "";
        derniereCible = cible;
        return cible;
    }

    static void Boucle() {
        try { timeBeginPeriod(1); } catch { }
        while (true) {
            try {
                if (!Actif && !BloquerWin && !BloquerAltEntree) { Liberer(); enJeu = false; nomFg = ""; Thread.Sleep(300); continue; }
                IntPtr h = GetForegroundWindow();
                if (h == IntPtr.Zero || IsIconic(h)) { Liberer(); enJeu = false; nomFg = ""; derniereFenetre = IntPtr.Zero; Thread.Sleep(20); continue; }
                uint pfg; GetWindowThreadProcessId(h, out pfg); nomFg = NomProcessus(pfg);
                RECT m;
                bool cible = EstCible(h, out m);
                enJeu = cible;
                if (!cible || !Actif || GetSystemMetrics(80) < 2) { Liberer(); Thread.Sleep(20); continue; }
                rL = m.L; rT = m.T; rR = m.R; rB = m.B; clipOn = true;
                RECT actuel;
                if (!bloque || !GetClipCursor(out actuel) || !Dedans(actuel, m)) { ClipRect(ref m); bloque = true; }
                POINT p;
                if (GetCursorPos(out p) && (p.X < m.L || p.X >= m.R || p.Y < m.T || p.Y >= m.B)) {
                    SetCursorPos(Math.Max(m.L, Math.Min(m.R - 1, p.X)), Math.Max(m.T, Math.Min(m.B - 1, p.Y)));
                }
            } catch { }
            Thread.Sleep(2);
        }
    }
}
'@
$FichierWinJeu = Join-Path $env:ProgramData 'OptiGame\touche_windows_jeu.txt'
function Win-Activee { return (Test-Path $FichierWinJeu) }
$ExclusSouris = @('ApplicationFrameHost', 'TextInputHost', 'ShellExperienceHost', 'SearchHost', 'StartMenuExperienceHost', 'LockApp', 'Taskmgr',
    'vlc', 'mpv', 'mpc-hc64', 'mpc-be64', 'PotPlayerMini64', 'Video.UI', 'Microsoft.Media.Player', 'Netflix', 'PrimeVideo', 'mstsc', 'ScreenClippingHost', 'SnippingTool')
function Souris-Activee { return (Test-Path $FichierSouris) }
# Lance (ou met a jour) la surveillance : souris gardee sur l'ecran du jeu et/ou touche Windows ignoree en jeu
# Alt+Entree desactive dans Fortnite (son plein ecran Alt+Entree est incorrigeable avec 2 ecrans). Actif par defaut.
$FichierAltEntreeOff = Join-Path $env:ProgramData 'OptiGameltentree_fortnite_autorise.txt'
function AltEntree-Bloque { return -not (Test-Path $FichierAltEntreeOff) }
function Demarrer-Souris {
    $s = Souris-Activee; $w = Win-Activee; $ae = AltEntree-Bloque
    if (-not $s -and -not $w -and -not $ae -and -not ('OGSourisJeu' -as [type])) { return }
    try {
        Charger-Type 'OGSourisJeu' $CodeSourisJeu
        [OGSourisJeu]::Exclus = [string[]](@($PasDesFenetresDeJeu) + $ExclusSouris + @('OptiGame', 'powershell'))
        [OGSourisJeu]::Actif = $s
        [OGSourisJeu]::BloquerWin = $w
        [OGSourisJeu]::AltEntreeJeux = [string[]]@('FortniteClient-Win64-Shipping')
        [OGSourisJeu]::BloquerAltEntree = $ae
        [OGSourisJeu]::Demarrer()
        [OGSourisJeu]::Reinstaller()
    } catch {}
}
# Les jeux detectes par OptiGame sont toujours concernes (meme en fenetre)
function Maj-PidsSouris {
    if (-not ('OGSourisJeu' -as [type])) { return }
    try { [OGSourisJeu]::Pids = [int[]]@($script:JeuxActifs.Values | ForEach-Object { [int]$_.Pid }) } catch {}
}
function Regler-Souris([bool]$on) {
    $script:SourceAction = 'Interrupteur Souris bloquee sur l''ecran du jeu (page Jeux)'
    if ($on) { New-Item -ItemType Directory -Path (Split-Path $FichierSouris) -Force | Out-Null; 'actif' | Out-File -FilePath $FichierSouris -Encoding ASCII }
    else { Remove-Item -LiteralPath $FichierSouris -Force -ErrorAction SilentlyContinue }
    Demarrer-Souris; Maj-PidsSouris
    Ajouter-Journal 'Souris en jeu (2 ecrans)' $(if ($on) { 'Libre' } else { 'Bloquee sur l''ecran du jeu' }) $(if ($on) { 'Bloquee sur l''ecran du jeu' } else { 'Libre' }) 'La souris ne peut plus partir sur l''autre ecran pendant que tu joues (Alt+Tab la libere).'
    $script:SourceAction = $null
    Afficher-Toast $(if ($on) { 'Souris bloquee sur l''ecran du jeu pendant que tu joues.' } else { 'Souris libre a nouveau.' }) $(if ($on) { 'ok' } else { 'info' })
}
function Regler-WinJeu([bool]$on) {
    $script:SourceAction = 'Interrupteur Touche Windows desactivee en jeu (page Jeux)'
    if ($on) { New-Item -ItemType Directory -Path (Split-Path $FichierWinJeu) -Force | Out-Null; 'actif' | Out-File -FilePath $FichierWinJeu -Encoding ASCII }
    else { Remove-Item -LiteralPath $FichierWinJeu -Force -ErrorAction SilentlyContinue }
    Demarrer-Souris; Maj-PidsSouris
    Ajouter-Journal 'Touche Windows en jeu' $(if ($on) { 'Active' } else { 'Desactivee' }) $(if ($on) { 'Desactivee' } else { 'Active' }) 'Pendant que tu joues, la touche Windows ne fait rien (plus de menu Demarrer en pleine partie).'
    $script:SourceAction = $null
    Afficher-Toast $(if ($on) { 'Touche Windows desactivee pendant que tu joues.' } else { 'Touche Windows remise.' }) $(if ($on) { 'ok' } else { 'info' })
}

# ---------- Anti-bug 2 ecrans pour tous les jeux d'un coup ----------
function Jeux-AvecAntiBug { return @($Jeux.Keys | Where-Object { @($Jeux[$_].Options | ForEach-Object { $_.Nom }) -contains $OptionAntiBug }) }
function AntiBug-Actif {
    if (PE-Actif) { return $false }   # (en vrai plein ecran, seul Fortnite garde l'anti-bug, pour sa protection)
    foreach ($j in (Jeux-AvecAntiBug)) { if (@((Get-ChoixJeu $j).Choix) -contains $OptionAntiBug) { return $true } }
    return $false
}
$ClesAntiBug = @('FullscreenMode', 'LastConfirmedFullscreenMode', 'PreferredFullscreenMode', 'ResolutionSizeX', 'LastUserConfirmedResolutionSizeX', 'DesiredScreenWidth',
    'LastUserConfirmedDesiredScreenWidth', 'ResolutionSizeY', 'LastUserConfirmedResolutionSizeY', 'DesiredScreenHeight', 'LastUserConfirmedDesiredScreenHeight', 'Fullscreen', 'Borderless', 'ResX', 'ResY')
function Activer-AntiBugTous {
    # Le vrai plein ecran fait l'inverse : il est retire tout seul
    if (PE-Actif) { Desactiver-VraiPleinEcran }
    $faits = New-Object System.Collections.ArrayList; $attente = New-Object System.Collections.ArrayList
    $script:SourceAction = 'Interrupteur Anti-bug 2 ecrans pour tous les jeux (page Jeux)'
    Invoke-Action 'Anti-bug 2 ecrans (tous les jeux)' {
        foreach ($j in (Jeux-AvecAntiBug)) {
            $c = Get-ChoixJeu $j
            $c.Choix = @(@($c.Choix) + $OptionAntiBug | Select-Object -Unique)
            $o = $Jeux[$j].Options | Where-Object { $_.Nom -eq $OptionAntiBug } | Select-Object -First 1
            if (Jeu-EnCours $j) { $script:EnAttente[$j] = $true; [void]$attente.Add($j); continue }
            Write-Log "$j :"
            try { & $o.Action; $c.Appliques = @(@($c.Appliques) + $OptionAntiBug | Select-Object -Unique); [void]$faits.Add($j) } catch { Write-Log "   $($_.Exception.Message)" 'Gold' }
        }
    }
    $script:SourceAction = $null
    Sauver-ChoixJeux
    Maj-PleinEcran
    Afficher-Toast $(if ($attente.Count) { "Anti-bug 2 ecrans active ($($attente -join ', ') : quand tu fermeras le jeu)." } else { 'Anti-bug 2 ecrans active pour tous les jeux.' })
}
function Desactiver-AntiBugTous {
    $script:SourceAction = 'Interrupteur Anti-bug 2 ecrans pour tous les jeux (page Jeux)'
    Invoke-Action 'Anti-bug 2 ecrans desactive' {
        Retirer-AntiBug (Jeux-AvecAntiBug)
        Write-Log '   Mode d''affichage des jeux remis comme avant.'
    }
    $script:SourceAction = $null
    Sauver-ChoixJeux
    Maj-PleinEcran
    Afficher-Toast 'Anti-bug 2 ecrans desactive.' 'info'
}

# ---------- Notifications Windows fiables : le raccourci du menu Demarrer porte l'identite d'OptiGame ----------
# (Windows n'affiche bien les notifications d'une appli que si un raccourci du menu Demarrer a son identite)
$IdAppli = 'OptiGame.Application'
$CodeIdRaccourci = @'
using System;
using System.Runtime.InteropServices;
public static class OGIdRaccourci {
    [StructLayout(LayoutKind.Sequential)] public struct PROPERTYKEY { public Guid fmtid; public uint pid; }
    [StructLayout(LayoutKind.Explicit, Size = 24)] public struct PROPVARIANT { [FieldOffset(0)] public ushort vt; [FieldOffset(8)] public IntPtr p; }
    [ComImport, Guid("886D8EEB-8CF2-4446-8D02-CDBA1DBDCF99"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    interface IPropertyStore {
        int GetCount(out uint n);
        int GetAt(uint i, out PROPERTYKEY k);
        int GetValue(ref PROPERTYKEY k, out PROPVARIANT v);
        int SetValue(ref PROPERTYKEY k, ref PROPVARIANT v);
        int Commit();
    }
    [DllImport("shell32.dll", CharSet = CharSet.Unicode)]
    static extern int SHGetPropertyStoreFromParsingName(string path, IntPtr bc, int flags, ref Guid iid, [MarshalAs(UnmanagedType.Interface)] out IPropertyStore store);

    // Ecrit l'identite (AppUserModelID) dans un raccourci .lnk : 0 = reussi
    public static int Definir(string lnk, string id) {
        Guid iid = new Guid("886D8EEB-8CF2-4446-8D02-CDBA1DBDCF99");
        IPropertyStore st;
        int hr = SHGetPropertyStoreFromParsingName(lnk, IntPtr.Zero, 2, ref iid, out st);
        if (hr != 0 || st == null) return hr == 0 ? -1 : hr;
        PROPERTYKEY k = new PROPERTYKEY(); k.fmtid = new Guid("9F4C2855-9F79-4B39-A8D0-E1D42DE1D5F3"); k.pid = 5;
        PROPVARIANT v = new PROPVARIANT(); v.vt = 31; v.p = Marshal.StringToCoTaskMemUni(id);
        try { hr = st.SetValue(ref k, ref v); if (hr == 0) hr = st.Commit(); }
        finally { Marshal.FreeCoTaskMem(v.p); Marshal.ReleaseComObject(st); }
        return hr;
    }
}
'@
function Assurer-IdentiteMenu {
    if ($TestAmi) { return }
    try {
        $lnk = Join-Path ([Environment]::GetFolderPath('Programs')) 'OptiGame.lnk'
        if (-not (Test-Path -LiteralPath $lnk)) {
            # Pas encore de raccourci OptiGame dans le menu Demarrer : on le cree (il ouvre la derniere version utilisee)
            Ecrire-ScriptLancement $ScriptOuvrir
            $ico = Join-Path $DossierData 'OptiGame.ico'
            try { Ecrire-Ico $ico } catch {}
            $sh = New-Object -ComObject WScript.Shell
            $s = $sh.CreateShortcut($lnk)
            $s.TargetPath = Join-Path $env:WINDIR 'System32\WindowsPowerShell\v1.0\powershell.exe'
            $s.Arguments = "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$ScriptOuvrir`""
            $s.WorkingDirectory = Split-Path $script:CheminScript
            if (Test-Path $ico) { $s.IconLocation = "$ico,0" }
            $s.WindowStyle = 7
            $s.Description = 'OptiGame (derniere version utilisee)'
            $s.Save()
        }
        Charger-Type 'OGIdRaccourci' $CodeIdRaccourci
        [void][OGIdRaccourci]::Definir($lnk, $IdAppli)
    } catch {}
}

# La barre des taches clignote (comme une appli qui demande ton attention)
$CodeClignote = @'
using System;
using System.Runtime.InteropServices;
public static class OGClignote {
    [StructLayout(LayoutKind.Sequential)] struct FLASHWINFO { public uint cbSize; public IntPtr hwnd; public uint dwFlags; public uint uCount; public uint dwTimeout; }
    [DllImport("user32.dll")] static extern bool FlashWindowEx(ref FLASHWINFO f);
    public static void Clignoter(IntPtr h) { FLASHWINFO f = new FLASHWINFO(); f.cbSize = (uint)Marshal.SizeOf(typeof(FLASHWINFO)); f.hwnd = h; f.dwFlags = 3 | 12; f.uCount = 0; f.dwTimeout = 0; FlashWindowEx(ref f); }
}
'@
function Clignoter-BarreTaches {
    try {
        Charger-Type 'OGClignote' $CodeClignote
        [OGClignote]::Clignoter((New-Object System.Windows.Interop.WindowInteropHelper($UI.Fenetre)).Handle)
    } catch {}
}

function Construire-Interface {
    # Identite propre a OptiGame : la barre des taches affiche son icone (et pas celle de PowerShell)
    try {
        Charger-Type 'OGAppId' 'using System; using System.Runtime.InteropServices; public static class OGAppId { [DllImport("shell32.dll", CharSet = CharSet.Unicode)] public static extern int SetCurrentProcessExplicitAppUserModelID(string id); }'
        [void][OGAppId]::SetCurrentProcessExplicitAppUserModelID($(if ($TestAmi) { 'OptiGame.TestAmi' } else { $IdAppli }))
    } catch {}
    $script:App = New-Object System.Windows.Application
    $script:App.ShutdownMode = 'OnExplicitShutdown'
    $script:App.Resources = Charger-Xaml $XamlStyles
    $script:App.Add_DispatcherUnhandledException({
        param($s, $e)
        $e.Handled = $true
        $ex = $e.Exception
        while ($ex.InnerException) { $ex = $ex.InnerException }
        # Ecran qui change de resolution (jeu en plein ecran) : Windows coupe l'affichage une fraction de seconde.
        # Sans gravite pour OptiGame : on ignore, et on redessine la fenetre.
        if ($ex.HResult -eq -2144980991 -or "$($ex.StackTrace)" -match 'DwmExtendFrameIntoClientArea|WindowChromeWorker') {
            try { $UI.Fenetre.InvalidateVisual() } catch {}
            return
        }
        Noter-Erreur 'Interface' ("$($ex.Message)`r`n$($e.Exception.GetType().FullName)`r`n$($ex.StackTrace)")
        try { Afficher-Toast 'Un probleme est survenu : detail dans Erreurs.' 'alerte' } catch {}
    })
    $f = Charger-Xaml $XamlMain
    $UI.Fenetre = $f
    foreach ($m in [regex]::Matches($XamlMain, 'x:Name="([^"]+)"')) { $UI[$m.Groups[1].Value] = $f.FindName($m.Groups[1].Value) }
    $f.Title = if ($TestAmi) { "OptiGame v$VersionApp - TEST (vue d'un ami)" } else { "OptiGame v$VersionApp" }
    try { $UI.TxtBtnNouveautes.Text = "Nouveautes de la v$VersionApp" } catch {}
    $UI.TxtVersion.Text = if ($TestAmi) { "Version $VersionApp - TEST AMI" } else { "Version $VersionApp" }

    # Icones (fenetre + zone de notification)
    $logo = Dessiner-Logo 64
    $script:IconeApp = [Drawing.Icon]::FromHandle($logo.GetHicon())
    $f.Icon = [System.Windows.Interop.Imaging]::CreateBitmapSourceFromHIcon($script:IconeApp.Handle, [System.Windows.Int32Rect]::Empty,
        [System.Windows.Media.Imaging.BitmapSizeOptions]::FromEmptyOptions())

    # Barre de titre
    $UI.BtnReduire.Add_Click({ $UI.Fenetre.WindowState = 'Minimized' })
    $UI.BtnRelancer.Add_Click({ Relancer-OptiGame })
    $UI.BtnAgrandir.Add_Click({
        $UI.Fenetre.WindowState = $(if ($UI.Fenetre.WindowState -eq 'Maximized') { 'Normal' } else { 'Maximized' })
    })
    $UI.BtnFermer.Add_Click({ $UI.Fenetre.Close() })
    $f.Add_StateChanged({
        if ($UI.Fenetre.WindowState -eq 'Minimized') { $script:EtaitReduite = $true; Annoncer-ArrierePlan; return }
        if ($script:EtaitReduite) { $script:EtaitReduite = $false; Apres-Retour }
        $max = ($UI.Fenetre.WindowState -eq 'Maximized')
        $UI.Racine.Margin = New-Object System.Windows.Thickness($(if ($max) { 7 } else { 0 }))
        $UI.BtnAgrandir.Content = [string][char]$(if ($max) { 0xE923 } else { 0xE922 })
        Maj-RectProg
    })
    $f.Add_LocationChanged({ Maj-RectProg })
    $f.Add_SizeChanged({ Maj-RectProg })

    # Navigation
    foreach ($k in $Pages.Keys) { $UI[$k].Add_Checked({ Show-Page $Pages[$this.Name] }) }

    # Accueil
    $UI.BtnToutFaire.Add_Click({ Executer-Action 'tout' })
    $UI.BtnToutFaire2.Add_Click({ Executer-Action 'tout' })
    $UI.BtnVoirConseils.Add_Click({ Aller-A 'NavConseils' })
    $UI.BtnQBoost.Add_Click({ Executer-Action 'boost' })
    $UI.BtnQMemoire.Add_Click({ Executer-Action 'memoire' })
    $UI.BtnRamLiberer.Add_Click({ Executer-Action 'memoire' })
    $UI.BtnQNettoyage.Add_Click({ Executer-Action 'nettoyage' })
    $UI.BtnQDiag.Add_Click({ Executer-Action 'diag' })
    $UI.BtnQCaptures.Add_Click({ Reparer-CapturesBouton })
    $UI.BtnQTest.Add_Click({ Aller-A 'NavTest'; Lancer-Test -Rapide })

    # Optimisation
    $UI.ListeActions.ItemsSource = Items-ActionsOptim
    $UI.ListeActions.AddHandler([System.Windows.Controls.Primitives.ButtonBase]::ClickEvent, [System.Windows.RoutedEventHandler]{
        param($s, $e)
        $b = $e.OriginalSource
        if ($b -is [System.Windows.Controls.Button] -and $b.Tag) { Executer-Action ([string]$b.Tag) }
    })

    # Jeux
    $UI.ChkAuto.IsChecked = (Auto-Active)
    $UI.ChkAuto.Add_Click({
        New-Item -ItemType Directory -Path (Split-Path $FichierAuto) -Force | Out-Null
        $(if ($UI.ChkAuto.IsChecked) { '1' } else { '0' }) | Out-File -FilePath $FichierAuto -Encoding ASCII
        Afficher-Toast $(if ($UI.ChkAuto.IsChecked) { 'Optimisation automatique activee.' } else { 'Optimisation automatique desactivee.' }) 'info'
    })
    foreach ($lb in @($UI.ListeJeux, $UI.ListeVersions, $UI.ListeErreurs)) {
        if (-not $lb) { continue }
        $lb.AddHandler([System.Windows.UIElement]::PreviewMouseLeftButtonUpEvent, [System.Windows.Input.MouseButtonEventHandler]{
            param($s, $e)
            $d = $e.OriginalSource -as [System.Windows.DependencyObject]
            while ($d -and -not ($d -is [System.Windows.Controls.ListBoxItem])) {
                $p = [System.Windows.Media.VisualTreeHelper]::GetParent($d)
                if (-not $p -and $d -is [System.Windows.FrameworkContentElement]) { $p = $d.Parent }
                $d = $p
            }
            if ($d -and -not $d.IsSelected) { $s.SelectedItem = $s.ItemContainerGenerator.ItemFromContainer($d) }
        }, $true)
    }
    $UI.ListeJeux.Add_SelectionChanged({
        if ($script:RemplissageJeux) { return }
        $it = $UI.ListeJeux.SelectedItem
        if (-not $it -or $it.Nom -eq $script:JeuSel) { return }
        $script:JeuSel = $it.Nom
        Remplir-OptionsJeu $it.Nom
    })
    $UI.ListeOptions.AddHandler([System.Windows.Controls.Primitives.ButtonBase]::ClickEvent, [System.Windows.RoutedEventHandler]{
        param($s, $e)
        $cb = $e.OriginalSource
        if (-not ($cb -is [System.Windows.Controls.CheckBox]) -or -not $script:JeuSel) { return }
        $c = Get-ChoixJeu $script:JeuSel
        $liste = @(@($c.Choix) | Where-Object { $_ -ne [string]$cb.Tag })
        if ($cb.IsChecked) { $liste += [string]$cb.Tag }
        $c.Choix = $liste
        Sauver-ChoixJeux
    })
    $UI.BtnJeuAppliquer.Add_Click({
        $nom = $script:JeuSel
        $def = $Jeux[$nom]
        if (-not $def) { return }
        $noms = @((Get-ChoixJeu $nom).Choix)
        $choix = @($def.Options | Where-Object { $noms -contains $_.Nom })
        if ($choix.Count -eq 0) { Show-Info 'Coche au moins une option.'; return }
        if (Jeu-EnCours $nom) {
            # Rien n'a ete applique : les cases reviennent a ce qui est vraiment applique
            $c = Get-ChoixJeu $nom
            $c.Choix = @(@($c.Appliques) | Where-Object { @($def.Options | ForEach-Object { $_.Nom }) -contains $_ })
            Sauver-ChoixJeux
            Remplir-OptionsJeu $nom
            Show-Info "$nom est ouvert : rien n'a ete applique, les cases ont ete remises comme avant.`r`nFerme le jeu completement, coche a nouveau puis Appliquer."
            return
        }
        Appliquer-Jeu $nom $choix
        Remplir-OptionsJeu $nom
        Remplir-ListeJeux -Force
        Afficher-Toast "$nom optimise."
    })
    $UI.BtnJeuRestaurer.Add_Click({
        $nom = $script:JeuSel
        if (-not $Jeux[$nom]) { return }
        if (Jeu-EnCours $nom) { Show-Info "Ferme $nom d'abord."; return }
        if (-not (Ask-YesNo "Remettre les reglages d'origine de $nom ?")) { return }
        Invoke-Action "Retour aux reglages d'origine : $nom" { Restaurer-Jeu $nom }
        (Get-ChoixJeu $nom).Appliques = @()
        Sauver-ChoixJeux
        Remplir-OptionsJeu $nom
        Remplir-ListeJeux -Force
    })
    $UI.BtnJeuDossier.Add_Click({
        $def = $Jeux[$script:JeuSel]
        if (-not $def) { return }
        $p = & $def.Config
        if (-not $p) {
            $e = @(& $def.Exe) | Select-Object -First 1
            if ($e) { $p = Split-Path $e } else { Show-Info 'Jeu pas encore trouve : lance-le une fois avec OptiGame ouvert.'; return }
        }
        if (-not (Test-Path $p -PathType Container)) { $p = Split-Path $p }
        if (Test-Path $p) { Start-Process explorer.exe $p } else { Show-Info 'Dossier introuvable : lance le jeu une fois.' }
    })
    $UI.BtnJeuConseils.Add_Click({
        $def = $Jeux[$script:JeuSel]
        if ($def) { [void](Show-Dialogue (Personnaliser $def.Conseils) "Reglages conseilles : $($script:JeuSel)" 'info') }
    })
    $UI.BtnJeuVideo.Add_Click({
        $def = $Jeux[$script:JeuSel]
        if ($def) { Start-Process ('https://www.youtube.com/results?search_query=' + [uri]::EscapeDataString($def.Video)) }
    })

    # Test
    $UI.BtnTestComplet.Add_Click({ Lancer-Test })
    $UI.BtnTestRapide.Add_Click({ Lancer-Test -Rapide })
    $UI.BtnTestStop.Add_Click({
        if (-not (Ask-YesNo 'Arreter le test et remettre les reglages comme avant ?')) { return }
        if ($script:TestEnCours) { $script:StopDemande = $true } else { Arreter-Test }
    })
    $UI.ListeResultats.AddHandler([System.Windows.Controls.Primitives.ButtonBase]::ClickEvent, [System.Windows.RoutedEventHandler]{
        param($s, $e)
        $cb = $e.OriginalSource
        if ($cb -is [System.Windows.Controls.CheckBox]) { $script:TestCoches[[string]$cb.Tag] = [bool]$cb.IsChecked }
    })
    $UI.BtnTestAppliquer.Add_Click({
        $ids = @($script:TestCoches.Keys | Where-Object { $script:TestCoches[$_] })
        if ($ids.Count -eq 0) { Show-Info 'Coche au moins une optimisation (ou lance d''abord un test).'; return }
        Invoke-Action 'Application des optimisations retenues' {
            Etape-PointRestauration
            foreach ($id in @('perf', 'perf2')) {
                if ($ids -contains $id) { Write-Log "--- $($Lots[$id].Nom) ---" 'White'; & $Lots[$id].Permanent }
            }
        }
        Actualiser-Infos
        Ask-Reboot
    })

    # Composants / conseils / historique
    $UI.BtnInfosActualiser.Add_Click({ Actualiser-Infos; Afficher-Toast 'Informations actualisees.' 'info' })
    $UI.BtnInfosCopier.Add_Click({ Copier-Infos })
    $UI.BtnConseilsActualiser.Add_Click({ Actualiser-Infos; Afficher-Toast 'Analyse refaite.' 'info' })
    $UI.BtnConseilsTout.Add_Click({
        Remove-Item (Join-Path $DossierData 'conseils_masques.json') -Force -ErrorAction SilentlyContinue
        if ($script:Infos) { Remplir-Conseils $script:Infos }
    })
    $UI.ListeConseils.AddHandler([System.Windows.Controls.Primitives.ButtonBase]::ClickEvent, [System.Windows.RoutedEventHandler]{
        param($s, $e)
        $b = $e.OriginalSource
        if ($b -is [System.Windows.Controls.Button] -and $b.Tag) {
            $cible = [string]$b.Tag
            Ouvrir-Lien $cible
            if ($cible -like 'masquer:*') { Afficher-Toast 'Conseil masque.' 'info' }
        }
    })
    $UI.BtnHistoEffacer.Add_Click({
        if (-not (Ask-YesNo 'Effacer l''historique des changements ? (Aucun reglage ne sera modifie.)')) { return }
        $script:Journal.Clear(); Sauver-Journal; Remplir-Changements
    })

    # Journal
    $UI.ListeJournal.ItemsSource = $script:LignesJournal
    $UI.BtnJournalCopier.Add_Click({
        [System.Windows.Clipboard]::SetText((($script:LignesJournal | ForEach-Object { $_.Texte }) -join "`r`n"))
        Afficher-Toast 'Journal copie.'
    })
    $UI.BtnJournalVider.Add_Click({ $script:LignesJournal.Clear() })

    # Erreurs
    $UI.ListeErreurs.Add_SelectionChanged({
        $it = $UI.ListeErreurs.SelectedItem
        if ($it) { Afficher-Erreur $script:Erreurs[[int]$it.Idx] }
    })
    $UI.BtnErrCopier.Add_Click({
        if (-not $UI.TxtDetail.Text) { return }
        [System.Windows.Clipboard]::SetText($UI.TxtDetail.Text)
        Afficher-Toast 'Erreur copiee : colle-la (Ctrl + V) dans la conversation.'
    })
    $UI.BtnErrCopierTout.Add_Click({
        if ($script:Erreurs.Count -eq 0) { return }
        [System.Windows.Clipboard]::SetText((($script:Erreurs | ForEach-Object { $_.Detail }) -join "`r`n----------`r`n"))
        Afficher-Toast 'Toutes les erreurs copiees.'
    })
    $UI.BtnErrEffacer.Add_Click({
        if (-not (Ask-YesNo 'Effacer toutes les erreurs enregistrees ?')) { return }
        $script:Erreurs.Clear(); Sauver-Erreurs; Remplir-Erreurs
    })
    $UI.BtnCorriger.Add_Click({ Corriger-Erreur ([string]$UI.BtnCorriger.Tag) })

    # Apparence
    Peindre-Pastilles
    $UI.PanThCouleurs.AddHandler([System.Windows.Controls.Primitives.ButtonBase]::ClickEvent, [System.Windows.RoutedEventHandler]{
        param($s, $e)
        $b = $e.OriginalSource -as [System.Windows.Controls.Button]
        if (-not $b -or -not $b.Tag) { return }
        $c = "$($b.Tag)".Split(',')
        $t = Lire-Theme; $t.Accent = $c[0]; $t.Accent2 = $c[1]; Sauver-Theme $t
        Relancer-PourTheme
    })
    $UI.PanThFonds.AddHandler([System.Windows.Controls.Primitives.ButtonBase]::ClickEvent, [System.Windows.RoutedEventHandler]{
        param($s, $e)
        $b = $e.OriginalSource -as [System.Windows.Controls.Button]
        if (-not $b -or -not $b.Tag) { return }
        $t = Lire-Theme; $t.Fond = "$($b.Tag)"; Sauver-Theme $t
        Relancer-PourTheme
    })
    $UI.BtnThPerso.Add_Click({
        $h = "$($UI.TxtThCouleur.Text)".Trim().TrimStart('#')
        if ($h -notmatch '^[0-9A-Fa-f]{6}$') { Show-Info "Code couleur invalide.`r`nIl faut 6 caracteres, par exemple FF4FA3 (copie-le depuis coolors.co)." 'Apparence'; return }
        $t = Lire-Theme; $t.Accent = $h.ToUpper(); $t.Accent2 = Melanger $h.ToUpper() 'FFFFFF' 0.3; Sauver-Theme $t
        Relancer-PourTheme
    })
    $UI.BtnThSiteCouleur.Add_Click({ Start-Process 'https://coolors.co/generate' })
    $UI.BtnThSiteImage.Add_Click({ Start-Process 'https://wallhaven.cc/search?categories=110&purity=100&atleast=1920x1080&sorting=toplist&order=desc' })
    $UI.BtnThImage.Add_Click({
        $d = New-Object Microsoft.Win32.OpenFileDialog
        $d.Title = 'Choisis une image de fond'
        $d.Filter = 'Images (*.jpg;*.jpeg;*.png;*.bmp)|*.jpg;*.jpeg;*.png;*.bmp'
        $d.InitialDirectory = [Environment]::GetFolderPath('MyPictures')
        if (-not $d.ShowDialog($UI.Fenetre)) { return }
        $dest = Join-Path $DossierData ('fond' + [IO.Path]::GetExtension($d.FileName).ToLower())
        try {
            New-Item -ItemType Directory -Path $DossierData -Force | Out-Null
            Get-ChildItem -LiteralPath $DossierData -Filter 'fond.*' -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
            Copy-Item -LiteralPath $d.FileName -Destination $dest -Force
        } catch { Show-Info "Impossible de copier l'image : $($_.Exception.Message)" 'Apparence'; return }
        $t = Lire-Theme; $t.Image = $dest; Sauver-Theme $t
        Relancer-PourTheme
    })
    $UI.BtnThSansImage.Add_Click({ $t = Lire-Theme; $t.Image = ''; Sauver-Theme $t; Relancer-PourTheme })
    $UI.SldThOpacite.Add_ValueChanged({
        $UI.TxtThOpacite.Text = "$([int]$UI.SldThOpacite.Value) %"
        if ($script:ImageFond) { $script:ImageFond.Opacity = $UI.SldThOpacite.Value / 100.0 }
    })
    $UI.SldThOpacite.Add_PreviewMouseLeftButtonUp({ $t = Lire-Theme; if ([int]$t.Opacite -ne [int]$UI.SldThOpacite.Value) { $t.Opacite = [int]$UI.SldThOpacite.Value; Sauver-Theme $t } })
    $UI.BtnThOpacite.Add_Click({ Relancer-Complet })
    $UI.BtnOledOn.Add_Click({ Activer-Oled })
    $UI.BtnOledOff.Add_Click({ Desactiver-Oled; try { Analyser-Ecrans } catch {} })
    $UI.ChkOledDoux.Add_Click({
        if ($script:MajEcranEnCours) { return }
        $r = Lire-ReglagesEcran
        $r.GammaDoux = [bool]$UI.ChkOledDoux.IsChecked
        Sauver-ReglagesEcran $r
        $script:SourceAction = 'Case Noirs plus doux (page Ecran)'
        Ajouter-Journal 'Noirs du mode OLED' $(if ($r.GammaDoux) { 'Profonds' } else { 'Doux' }) $(if ($r.GammaDoux) { 'Doux' } else { 'Profonds' }) 'Noirs doux : un peu moins profonds, mais beaucoup moins de marches dans les ombres et les fondus.'
        $script:SourceAction = $null
        Reappliquer-GammaOled
        try { Analyser-Ecrans } catch {}
        Afficher-Toast $(if ($r.GammaDoux) { 'Noirs doux actives.' } else { 'Noirs profonds actives.' })
    })
    $UI.BtnSpeedGo.Add_Click({ Lancer-SpeedTest })
    $UI.BtnNetActualiser.Add_Click({ Lancer-EtatReseau })
    $UI.BtnNetReparer.Add_Click({ Reparer-Connexion })
    $UI.BtnDnsTester.Add_Click({ Lancer-TestDns })
    $UI.BtnDnsRemettre.Add_Click({ Remettre-Dns })
    $UI.ListeDns.AddHandler([System.Windows.Controls.Primitives.ButtonBase]::ClickEvent, [System.Windows.RoutedEventHandler]{
        param($s, $e)
        $nom = "$($e.OriginalSource.Tag)"
        if ($nom) { Appliquer-Dns $nom; Lancer-TestDns }
    })
    $UI.ChkPleinEcran.Add_Click({
        if ($script:MajPEEnCours) { return }
        if ($UI.ChkPleinEcran.IsChecked) { Activer-VraiPleinEcran } else { Desactiver-VraiPleinEcran }
        if ($script:JeuSel) { try { Remplir-OptionsJeu $script:JeuSel } catch {} }
    })
    $UI.BtnVoirNouveautes.Add_Click({ Afficher-Nouveautes })
    $UI.ChkSourisJeu.Add_Click({ if ($script:MajPEEnCours) { return }; Regler-Souris ([bool]$UI.ChkSourisJeu.IsChecked) })
    $UI.ChkWinJeu.Add_Click({ if ($script:MajPEEnCours) { return }; Regler-WinJeu ([bool]$UI.ChkWinJeu.IsChecked) })
    $UI.ChkAntiBugTous.Add_Click({
        if ($script:MajPEEnCours) { return }
        if ($UI.ChkAntiBugTous.IsChecked) { Activer-AntiBugTous } else { Desactiver-AntiBugTous }
        if ($script:JeuSel) { try { Remplir-OptionsJeu $script:JeuSel } catch {} }
    })
    $UI.BtnSpeedSite.Add_Click({ if ($script:UrlSpeed) { Start-Process $script:UrlSpeed } else { Start-Process 'https://www.speedtest.net/fr' } })
    $UI.BtnQualiteMax.Add_Click({ try { Activer-QualiteMax } catch { Show-Info "Probleme : $($_.Exception.Message)" 'Bords ultra lisses' }; Maj-QualiteMax; if ($script:JeuSel) { try { Remplir-OptionsJeu $script:JeuSel } catch {} } })
    $UI.BtnQualiteMaxOff.Add_Click({ try { Desactiver-QualiteMax } catch {}; Maj-QualiteMax; if ($script:JeuSel) { try { Remplir-OptionsJeu $script:JeuSel } catch {} } })
    $UI.BtnQualiteAmd.Add_Click({ Ouvrir-AmdSoftware })
    $UI.BtnNetAnalyser.Add_Click({ Analyser-Nettete; Afficher-Toast 'Ecrans analyses.' 'info' })
    $UI.BtnNetMax.Add_Click({ try { Mettre-AuPlusNet } catch { Show-Info "Probleme : $($_.Exception.Message)" 'Ecran' } })
    $UI.BtnNetUfo.Add_Click({ Start-Process 'https://www.testufo.com/' })
    $UI.BtnNetAmd.Add_Click({ Ouvrir-AmdSoftware })
    $UI.BtnNetEdge.Add_Click({ Ouvrir-ReglagesEdge })
    $UI.BtnNetClearType.Add_Click({ try { Start-Process "$env:WINDIR\System32\cttune.exe" } catch { Show-Info 'Outil introuvable : tape ClearType dans la recherche Windows.' 'Ecran' } })
    $UI.ChkClearType.Add_Click({ if ($script:MajEcranEnCours) { return }; $on = [bool]$UI.ChkClearType.IsChecked; Regler-ClearType $on; Afficher-Toast $(if ($on) { 'Texte net (ClearType) active.' } else { 'Lissage standard remis.' }) })
    $UI.ChkDpiFlou.Add_Click({ if ($script:MajEcranEnCours) { return }; $on = [bool]$UI.ChkDpiFlou.IsChecked; Regler-DpiFlou $on; Afficher-Toast $(if ($on) { 'Applis floues corrigees (a leur prochaine ouverture).' } else { 'Correction des applis floues desactivee.' }) })
    $UI.BtnBandAnalyser.Add_Click({ Analyser-Ecrans; Afficher-Toast 'Ecrans analyses.' 'info' })
    $UI.BtnBandTest.Add_Click({ Tester-Degrades })
    $UI.BtnBandAmd.Add_Click({ Ouvrir-AmdSoftware })
    $UI.BtnBandMpv.Add_Click({ try { Activer-LissageMpv } catch { Show-Info "Impossible d'ecrire la configuration de mpv : $($_.Exception.Message)" 'Ecran' }; Maj-Lissage })
    $UI.BtnBandMpvOff.Add_Click({ try { Desactiver-LissageMpv } catch {}; Maj-Lissage })
    $UI.BtnBandMpvSite.Add_Click({ Start-Process 'https://mpv.io/installation/' })
    $UI.BtnThDefaut.Add_Click({ Remove-Item -LiteralPath $FichierTheme -Force -ErrorAction SilentlyContinue; Relancer-PourTheme })

    # Mises a jour en ligne
    $UI.BtnMajVerifier.Add_Click({ Demarrer-VerifMaj -Manuel })
    $UI.BtnMajTout.Add_Click({ Installer-VersionsEnLigne @(Etat-Maj | Where-Object { (-not $_.Present -and -not $_.Ignoree) -or $_.Modifie }) -ProposerUtiliser })
    $UI.ListeDistantes.AddHandler([System.Windows.Controls.Primitives.ButtonBase]::ClickEvent, [System.Windows.RoutedEventHandler]{
        param($s, $e)
        $t = "$(($e.OriginalSource -as [System.Windows.Controls.Button]).Tag)"
        if ($t -notmatch '^(inst|ign|rea):(.+)$') { return }
        $nom = $Matches[2]
        switch ($Matches[1]) {
            'inst' { Installer-VersionsEnLigne @(Etat-Maj | Where-Object { $_.Nom -eq $nom }) -ProposerUtiliser }
            'ign'  { Ignorer-Version $nom $true; Afficher-Toast "$nom mise de cote (tu peux l'installer plus tard)." 'info' }
            'rea'  { Ignorer-Version $nom $false }
        }
    })
    $UI.BtnMajSource.Add_Click({
        $u = "$($UI.TxtMajSource.Text)".Trim()
        if ($u -notmatch '^https://\S+$') { Show-Info "Lien invalide : il doit commencer par https://`r`n(l'operateur le copie avec le bouton Copier le lien pour tes amis)." 'Mises a jour'; return }
        $m = Lire-Maj; $m.Source = $u; Sauver-Maj $m
        Demarrer-VerifMaj -Manuel
    })
    $UI.BtnMajInstaller.Add_Click({
        if ("$($UI.BtnMajInstaller.Tag)" -eq 'modif') { Installer-VersionsEnLigne @(Etat-Maj | Where-Object { $_.Modifie -and $_.Nom -eq [IO.Path]::GetFileName($PSCommandPath) }) }
        else { Installer-VersionsEnLigne @(Etat-Maj | Where-Object { -not $_.Present -and -not $_.Ignoree -and $_.Nouvelle }) -ProposerUtiliser }
    })
    $UI.BtnMajVoir.Add_Click({ Aller-A 'NavVersions' })
    $UI.BtnMajPlusTard.Add_Click({
        # Cachee jusqu'a la prochaine nouvelle version (ou le prochain lancement d'OptiGame)
        $n = @(Etat-Maj | Where-Object { -not $_.Present -and -not $_.Ignoree -and $_.Nouvelle })
        if ($n.Count) { $script:PlusTardVersion = $n[0].Nom }
        $UI.BanniereMaj.Visibility = 'Collapsed'
    })
    $UI.BtnVerSupprimer.Add_Click({ $it = $UI.ListeVersions.SelectedItem; if ($it) { Supprimer-VersionLocale ([string]$it.Chemin) } })
    # Mode operateur
    $UI.BtnOpDevenir.Add_Click({ $UI.ZoneOpConfig.Visibility = 'Visible'; $UI.BtnOpDevenir.Visibility = 'Collapsed' })
    $UI.BtnOpEnregistrer.Add_Click({ Op-Enregistrer "$($UI.TxtOpDepot.Text)" "$($UI.PwdOpJeton.Password)"; $UI.PwdOpJeton.Password = '' })
    $UI.BtnOpAide.Add_Click({
        Show-Info ("Mise en place (une seule fois, environ 5 minutes) :`r`n`r`n" +
            "1. Cree un compte gratuit sur github.com.`r`n" +
            "2. Cree un depot PUBLIC (bouton New repository), par exemple optigame-maj.`r`n" +
            "3. Cree un jeton : Settings > Developer settings > Fine-grained tokens > Generate new token. Depot : seulement optigame-maj. Permission Contents : Read and write.`r`n" +
            "4. Ici : ecris pseudo/optigame-maj et colle le jeton, puis Enregistrer.`r`n" +
            "5. Selectionne ta version et clique Publier. Copie le lien pour tes amis et envoie-le leur une fois (ou envoie-leur une version deja publiee : le lien est dedans).`r`n`r`n" +
            "Ensuite, a chaque nouvelle version : Publier, c'est tout.") 'Mode operateur'
        Start-Process 'https://github.com/new'
    })
    $UI.BtnOpPublier.Add_Click({ $it = $UI.ListeVersions.SelectedItem; if ($it) { Op-Publier @(Get-Item -LiteralPath ([string]$it.Chemin)) } })
    $UI.BtnOpPublierTout.Add_Click({ if (Ask-YesNo 'Publier toutes les versions OptiGame_vX.X du dossier ?') { Op-Publier @(Lister-Versions) } })
    $UI.BtnOpRetirer.Add_Click({ $it = $UI.ListeVersions.SelectedItem; if ($it) { Op-Retirer ([IO.Path]::GetFileName([string]$it.Chemin)) } })
    $UI.BtnOpTestAmi.Add_Click({
        Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$($script:CheminScript)`" -TestAmi"
        Afficher-Toast 'Ouverture d''OptiGame en mode test ami (2e fenetre)...' 'info'
    })
    $UI.BtnOpLien.Add_Click({ $op = Lire-Op; if ($op) { [System.Windows.Clipboard]::SetText((Url-Manifest $op)); Afficher-Toast 'Lien copie : envoie-le a tes amis (une seule fois).' } })
    $UI.BtnOpQuitter.Add_Click({ if (Ask-YesNo 'Quitter le mode operateur sur ce PC ? (le jeton est efface, rien n''est supprime en ligne)') { Remove-Item -LiteralPath $FichierOp -Force -ErrorAction SilentlyContinue; Maj-ZoneMaj } })

    # Score : un clic sur un point ouvre les conseils
    $UI.ListeScore.Add_PreviewMouseLeftButtonUp({ Aller-A 'NavConseils' })

    # Antivirus
    $UI.BtnAvActualiser.Add_Click({ Maj-PageAntivirus; Afficher-Toast 'Etat de l''antivirus actualise.' 'info' })
    $UI.BtnAvSecurite.Add_Click({ try { Start-Process 'windowsdefender://threat' } catch { Start-Process 'ms-settings:windowsdefender' } })
    $UI.BtnAvRapide.Add_Click({ Lancer-AnalyseAv 'QuickScan' })
    $UI.BtnAvComplete.Add_Click({
        if (Ask-YesNo "L'analyse complete verifie tout le PC : souvent 30 min a plus d'une heure.`r`nTu peux continuer a utiliser ton PC (ou jouer) pendant. Lancer ?") { Lancer-AnalyseAv 'FullScan' }
    })
    $UI.BtnAvDossier.Add_Click({
        $d = New-Object System.Windows.Forms.FolderBrowserDialog
        $d.Description = 'Choisis le dossier a analyser (ex : Telechargements)'
        $d.SelectedPath = Join-Path $env:USERPROFILE 'Downloads'
        if ($d.ShowDialog() -eq 'OK') { Lancer-AnalyseAv 'CustomScan' $d.SelectedPath }
    })
    $UI.BtnAvFichier.Add_Click({
        $d = New-Object Microsoft.Win32.OpenFileDialog
        $d.Title = 'Choisis le fichier a analyser'
        $d.InitialDirectory = Join-Path $env:USERPROFILE 'Downloads'
        if ($d.ShowDialog($UI.Fenetre)) { Lancer-AnalyseAv 'CustomScan' $d.FileName }
    })
    $UI.BtnAvMaj.Add_Click({ Maj-DefinitionsAv })
    $UI.BtnAvStop.Add_Click({ Arreter-TacheAv })
    $UI.BtnAvRenforcer.Add_Click({ Renforcer-Antivirus })
    $UI.BtnAvSupprimer.Add_Click({ Supprimer-MenacesAv })
    $UI.BtnAvHorsLigne.Add_Click({
        if (-not (Ask-YesNo "L'analyse hors ligne redemarre le PC et cherche les virus caches avant le demarrage de Windows (environ 15 min).`r`nEnregistre ton travail. Lancer maintenant ?")) { return }
        try { Start-MpWDOScan -ErrorAction Stop } catch { Info-Av "Impossible de lancer l'analyse hors ligne : $($_.Exception.Message)" 'alerte' }
    })

    # Spicetify automatique
    $UI.ChkSpAuto.IsChecked = (SpAuto-Actif)
    $UI.ChkSpAuto.Add_Click({
        New-Item -ItemType Directory -Path $DossierData -Force | Out-Null
        $(if ($UI.ChkSpAuto.IsChecked) { '1' } else { '0' }) | Out-File -FilePath $FichierSpAuto -Encoding ASCII
        if ($UI.ChkSpAuto.IsChecked) { Afficher-Toast 'Spicetify automatique active.' 'info'; Verifier-SpicetifyAuto }
        else { Afficher-Toast 'Spicetify automatique desactive.' 'info' }
    })

    # Timer Resolution + demarrage du PC
    $UI.BtnTrMax.Add_Click({ Timer-Max; Afficher-Toast 'Timer Resolution au maximum.' })
    $UI.BtnTrTester.Add_Click({ Tester-TimerReel })
    $UI.BtnTrDefaut.Add_Click({ Timer-Defaut; Afficher-Toast 'Timer Resolution par defaut.' 'info' })
    $UI.BtnTrMemoire.Add_Click({ Timer-Max; Executer-Action 'memoire' })
    $UI.ChkTrAuto.IsChecked = (Timer-AutoActif)
    $UI.ChkTrAuto.Add_Click({
        New-Item -ItemType Directory -Path $DossierData -Force | Out-Null
        $(if ($UI.ChkTrAuto.IsChecked) { '1' } else { '0' }) | Out-File -FilePath $FichierTimerAuto -Encoding ASCII
        try {
            if ($UI.ChkTrAuto.IsChecked) {
                Timer-Max
                Demarrer-TimerFond
                Write-Log 'Timer Resolution : maximum en permanence (meme OptiGame ferme, a chaque demarrage du PC).'
                Afficher-Toast 'Timer toujours au maximum, meme OptiGame ferme.'
            } else {
                Arreter-TimerFond
                Write-Log 'Timer Resolution permanent arrete.'
                Afficher-Toast 'Timer permanent desactive.' 'info'
            }
        } catch { Show-Info "Impossible de regler le timer permanent : $($_.Exception.Message)" 'Timer Resolution' }
        $script:TimerVerifQuand = $null
        Maj-Timer
    })
    $script:DemActif = Demarrage-Actif
    $UI.ChkDemarrage.IsChecked = $script:DemActif
    if ($script:DemActif -and (Demarrage-Mode) -eq 'fenetre') { $UI.RbDemFenetre.IsChecked = $true } else { $UI.RbDemCache.IsChecked = $true }
    $UI.ZoneDemarrage.IsEnabled = $script:DemActif
    $script:ModeDem = { if ($UI.RbDemFenetre.IsChecked) { 'fenetre' } else { 'cache' } }
    $UI.ChkDemarrage.Add_Click({
        try {
            if ($UI.ChkDemarrage.IsChecked) { Activer-Demarrage (& $script:ModeDem); Afficher-Toast 'OptiGame se lancera au demarrage du PC.' }
            else { Desactiver-Demarrage; Afficher-Toast 'Lancement au demarrage desactive.' 'info' }
        } catch { Show-Info "Impossible de regler le lancement au demarrage : $($_.Exception.Message)"; $UI.ChkDemarrage.IsChecked = Demarrage-Actif }
        $UI.ZoneDemarrage.IsEnabled = [bool]$UI.ChkDemarrage.IsChecked
    })
    foreach ($rb in @($UI.RbDemCache, $UI.RbDemFenetre)) {
        $rb.Add_Click({ if ($UI.ChkDemarrage.IsChecked) { try { Activer-Demarrage (& $script:ModeDem); Afficher-Toast 'Mode de demarrage enregistre.' 'info' } catch {} } })
    }

    # Spicetify
    $UI.BtnSpActualiser.Add_Click({ Maj-PageSpicetify; Afficher-Toast 'Etat de Spicetify actualise.' 'info' })
    $UI.BtnSpInstaller.Add_Click({ Installer-Spicetify })
    $UI.BtnSpMarket.Add_Click({ Installer-Marketplace })
    $UI.BtnSpReappliquer.Add_Click({ Reappliquer-Spicetify })
    $UI.BtnSpReparer.Add_Click({ Reparer-Spicetify })
    $UI.BtnSpOrigine.Add_Click({ Origine-Spotify })
    $UI.BtnSpSpotify.Add_Click({ Installer-Spotify })
    $UI.BtnSpDesinstaller.Add_Click({ Desinstaller-Spicetify })
    $UI.BtnSpThemes.Add_Click({ $d = Join-Path $SpConfig 'Themes'; if (-not (Test-Path $d)) { $d = $SpConfig }; if (Test-Path $d) { Start-Process explorer.exe $d } })
    $UI.BtnSpSite.Add_Click({ Start-Process 'https://spicetify.app' })

    # Versions
    $UI.ListeVersions.Add_SelectionChanged({
        if ($UI.ListeVersions.SelectedItem) { $script:VersionChoisie = [string]$UI.ListeVersions.SelectedItem.Chemin }
        $it = $UI.ListeVersions.SelectedItem
        if ($it) { $UI.TxtNotes.Text = Notes-Version $it.Chemin }
    })
    $UI.BtnVerUtiliser.Add_Click({
        $it = $UI.ListeVersions.SelectedItem
        if (-not $it) { return }
        $cible = [string]$it.Chemin
        if ($cible -eq $PSCommandPath) { Show-Info 'Cette version est deja en cours.'; return }
        if ($script:TestEnCours -or (Test-Path $EtatFichier)) { Show-Info 'Un test de performance est en cours : termine-le ou arrete-le avant de changer de version.'; return }
        if (-not (Ask-YesNo "OptiGame va redemarrer avec $([IO.Path]::GetFileName($cible)).`r`nTes optimisations et reglages sont conserves.`r`n`r`nContinuer ?")) { return }
        if ([IO.Path]::GetFileName($cible) -match '^OptiGame_v\d+(\.\d+)*\.ps1$') {
            $e = Lire-EtatVersions
            Sauver-EtatVersions ([IO.Path]::GetFileName($cible)) (@($e.Vues) + @(Lister-Versions | ForEach-Object { $_.Name }))
        }
        $script:Relance = $cible
        $script:ForcerFermeture = $true
        $UI.Fenetre.Close()
    })
    $UI.BtnVerAjouter.Add_Click({
        $dlg = New-Object Microsoft.Win32.OpenFileDialog
        $dlg.Filter = 'Version OptiGame (*.ps1;*.bat)|*.ps1;*.bat;*.cmd'
        $dlg.Title = 'Choisir la nouvelle version d''OptiGame'
        if (-not $dlg.ShowDialog($UI.Fenetre)) { return }
        $src = $dlg.FileName
        $nom = [IO.Path]::GetFileName($src)
        if ($nom -notmatch '^OptiGame_v\d+(\.\d+)*\.ps1$') {
            $txt = (Get-Content -LiteralPath $src -TotalCount 40) -join "`n"
            if ($txt -match '(?m)^#\s*OptiGame version\s*:\s*(\d+(\.\d+)*)') { $nom = "OptiGame_v$($Matches[1]).ps1" }
        }
        $dest = Join-Path (Split-Path $PSCommandPath) $nom
        if ((Test-Path -LiteralPath $dest) -and -not (Ask-YesNo "$nom existe deja. Le remplacer ?")) { return }
        Copy-Item -LiteralPath $src -Destination $dest -Force
        Unblock-File -LiteralPath $dest -ErrorAction SilentlyContinue
        Remplir-Versions
        Afficher-Toast "$nom ajoutee. Selectionne-la puis Utiliser cette version."
    })
    $UI.BtnVerDossier.Add_Click({ Start-Process explorer.exe (Split-Path $PSCommandPath) })
    $UI.BtnRaccourcis.Add_Click({
        $faits = @(Creer-Raccourcis)
        if ($faits.Count) { Afficher-Toast 'Raccourcis crees sur le Bureau et dans le menu Demarrer.' }
        else { Show-Info 'Impossible de creer les raccourcis.' }
    })

    # Zone de notification
    $script:Notif = New-Object Windows.Forms.NotifyIcon
    $script:Notif.Icon = $script:IconeApp
    $script:Notif.Text = "OptiGame v$VersionApp"
    $script:Notif.Visible = $true
    $menu = New-Object Windows.Forms.ContextMenuStrip
    [void]$menu.Items.Add('Ouvrir OptiGame', $null, { Montrer-Fenetre })
    [void]$menu.Items.Add('Mode Boost (avant de jouer)', $null, {
        if ($script:Busy) { return }
        Invoke-Action 'Mode Boost' { Etape-Boost }
        Notifier 'OptiGame' 'Mode Boost applique. Lance ton jeu !'
    })
    [void]$menu.Items.Add('Liberer la memoire', $null, {
        if ($script:Busy) { return }
        Invoke-Action 'Liberation de la memoire' { Etape-Memoire }
        if ($script:ResultatMemoire) { Notifier 'OptiGame' ('Memoire : {0} % -> {1} % ({2:N1} Go liberes)' -f $script:ResultatMemoire.Avant, $script:ResultatMemoire.Apres, $script:ResultatMemoire.Libere) }
    })
    [void]$menu.Items.Add('Analyse antivirus rapide', $null, { Montrer-Fenetre; Aller-A 'NavAntivirus'; Lancer-AnalyseAv 'QuickScan' })
    [void]$menu.Items.Add('Relancer OptiGame', $null, { Montrer-Fenetre; Relancer-OptiGame })
    [void]$menu.Items.Add('-')
    [void]$menu.Items.Add('Quitter OptiGame', $null, { Montrer-Fenetre; $UI.Fenetre.Close() })
    $script:Notif.ContextMenuStrip = $menu
    $script:Notif.Add_MouseDoubleClick({ Montrer-Fenetre })
    $script:Notif.Add_BalloonTipClicked({ Montrer-Fenetre; if ($script:BulleMaj) { $script:BulleMaj = $false; try { Aller-A 'NavAccueil' } catch {} } })

    # Retour dans l'appli : on rafraichit les pages d'infos
    $f.Add_Activated({
        if ($script:Busy -or $script:TestEnCours) { return }
        if ($script:PageActive -notin 'PageInfos', 'PageConseils', 'PageAccueil') { return }
        if ($script:DerniereLecture -and ((Get-Date) - $script:DerniereLecture).TotalSeconds -lt 15) { return }
        Actualiser-Infos
    })

    $f.Add_Closing({
        param($s, $e)
        if ($script:TestEnCours) {
            $e.Cancel = $true
            if (Ask-YesNo "Un test est en cours.`r`n`r`nL'arreter et remettre les reglages comme avant ?") { $script:StopDemande = $true }
            return
        }
        if ($script:Busy -and -not $script:ForcerFermeture) {
            $e.Cancel = $true
            Show-Info 'Une optimisation est en cours : attends la fin avant de fermer OptiGame.'
        }
    })
    $f.Add_Closed({
        foreach ($t in @($script:Minuterie, $script:MinuterieStats, $script:MinuterieScore, $script:EvMontrer)) { try { $t.Stop() } catch {} }
        try { $script:Notif.Visible = $false; $script:Notif.Dispose() } catch {}
        try { if ($script:Prog) { $script:Prog.Quitter = $true } } catch {}
        if ($script:Relance) {
            try { $script:Mutex.ReleaseMutex(); $script:Mutex.Dispose() } catch {}
            Lancer-Fichier $script:Relance
        }
        $script:App.Shutdown()
    })

    # Demarrage
    $f.Add_ContentRendered({
        if ($script:Demarre) { return }
        $script:Demarre = $true
        $script:Prog.Owner = (New-Object System.Windows.Interop.WindowInteropHelper($UI.Fenetre)).Handle
        Maj-RectProg
        Write-Log "OptiGame v$VersionApp demarre." 'White'
        try { if (Reparer-Recherche) { Afficher-Toast 'Recherche Windows reparee.' } } catch {}
        try { if (Reparer-Captures) { Afficher-Toast 'Captures d''ecran reparees.' } } catch {}
        Charger-Journal
        Charger-Erreurs
        Charger-ChoixJeux
        try { Migrer-ReglagesJeux } catch {}
        try { Retirer-AltEntreeRoblox } catch {}
        Remplir-Erreurs
        Remplir-Changements
        Remplir-Versions
        Remplir-ListeJeux -Force
        if ($UI.ListeJeux.Items.Count -gt 0) { $UI.ListeJeux.SelectedIndex = 0 }

        $script:Minuterie = New-Object System.Windows.Threading.DispatcherTimer
        $script:Minuterie.Interval = [TimeSpan]::FromSeconds(4)
        $script:Minuterie.Add_Tick({
            if ($script:DansVerif) { return }
            $script:DansVerif = $true
            if (-not $TestAmi) {
                try { Verifier-Jeux } catch {}
                try { Surveiller-Roblox } catch {}
            }
            $script:Tours = 1 + [int]$script:Tours
            if ($script:Tours % 75 -eq 0 -and -not $TestAmi) { try { Garantir-ReglagesJeux -Discret } catch {} }
            if ($script:Tours % 150 -eq 0 -and -not $TestAmi) { try { Verifier-SpicetifyAuto -Silencieux } catch {} }
            # Nouvelles versions : verification toutes les 2 minutes (30 x 4 s)
            # (les nouvelles versions sont cherchees par une minuterie a part, toutes les 15 secondes)
            if ($script:Tours % 15 -eq 0) { try { Reappliquer-GammaOled } catch {} }
            try { Verifier-AlerteTemp } catch {}
            try { Maj-PidsSouris } catch {}
            if ($script:Tours % 10 -eq 5) { try { Ajuster-PleinEcranJeux } catch {} }
            $script:DansVerif = $false
        })
        $script:Minuterie.Start()
        $script:EvQuitter = New-Object System.Threading.EventWaitHandle($false, [System.Threading.EventResetMode]::ManualReset, "Global\OptiGame_Quitter$SuffixeInst")
        $script:EvMontrer = New-Object System.Windows.Threading.DispatcherTimer
        # Signal "montre-toi" : utilisable aussi sans droits admin (raccourci OptiGame clique alors qu'il est deja ouvert)
        try {
            $secu = New-Object System.Security.AccessControl.EventWaitHandleSecurity
            $secu.AddAccessRule((New-Object System.Security.AccessControl.EventWaitHandleAccessRule((New-Object System.Security.Principal.SecurityIdentifier('S-1-1-0')), [System.Security.AccessControl.EventWaitHandleRights]'Modify, Synchronize', 'Allow')))
            $secu.AddAccessRule((New-Object System.Security.AccessControl.EventWaitHandleAccessRule((New-Object System.Security.Principal.SecurityIdentifier('S-1-5-32-544')), [System.Security.AccessControl.EventWaitHandleRights]::FullControl, 'Allow')))
            $cree = $false
            $script:EvMontrerH = New-Object System.Threading.EventWaitHandle($false, [System.Threading.EventResetMode]::ManualReset, "Global\OptiGame_Montrer$SuffixeInst", [ref]$cree, $secu)
        } catch {
            $script:EvMontrerH = New-Object System.Threading.EventWaitHandle($false, [System.Threading.EventResetMode]::ManualReset, "Global\OptiGame_Montrer$SuffixeInst")
        }
        $script:EvMontrer.Interval = [TimeSpan]::FromMilliseconds(600)
        $script:EvMontrer.Add_Tick({
            if ($script:EvMontrerH.WaitOne(0) -and -not $script:DejaMontre) { $script:DejaMontre = $true; Montrer-Fenetre }
            elseif (-not $script:EvMontrerH.WaitOne(0)) { $script:DejaMontre = $false }
            if ($script:EvQuitter.WaitOne(0) -and -not $script:Busy -and -not $script:TestEnCours -and -not $script:Fermeture) {
                $script:Fermeture = $true
                Write-Log 'Une autre version d''OptiGame demande a prendre le relais : fermeture.' 'Gold'
                $UI.Fenetre.Close()
            }
        })
        $script:EvMontrer.Start()
        $script:MinuterieStats = New-Object System.Windows.Threading.DispatcherTimer
        $script:MinuterieStats.Interval = [TimeSpan]::FromMilliseconds(2500)
        $script:MinuterieStats.Add_Tick({ Maj-StatsDirect; Maj-Timer })
        $script:MinuterieStats.Start()

        if (Load-Etat) {
            Aller-A 'NavTest'
            Write-Log 'Reprise du test de performance...' 'Gold'
            Continue-Test
        } else {
            if ($Reprise) { Supprimer-Tache }
            # Demarrage par etapes : la fenetre s'affiche tout de suite et reste fluide pendant l'analyse
            $script:Etapes = New-Object System.Collections.Queue
            foreach ($b in @(
                { try { if (Timer-AutoActif) { Timer-Max -Discret; if (-not (TimerFond-Actif) -or -not (Get-ScheduledTask -TaskName $NomTacheTimer -ErrorAction SilentlyContinue)) { Demarrer-TimerFond }; Write-Log 'Timer Resolution au maximum (permanent).' 'Gray' } else { Maj-Timer } } catch {} },
                { if (Test-Path $ResultatFichier) { try { Afficher-Resultats (Get-Content $ResultatFichier -Raw | ConvertFrom-Json) } catch {} } },
                { Actualiser-Infos },
                { Maj-StatsDirect; Verifier-Jeux },
                { try { if (Reparer-AffichageFortnite) { Afficher-Toast 'Affichage de Fortnite repare.' 'info'; Sauver-ChoixJeux } } catch {} },
                { try { Appliquer-NouvellesOptions } catch {} },
                { try { Garantir-ReglagesJeux } catch {} },
                { try { if (Demarrage-Actif) { Ecrire-ScriptDemarrage } } catch {} },
                { try { Demarrer-VerifMaj } catch {} },
                { try { Migrer-Raccourcis } catch {} },
                { try { Assurer-IdentiteMenu } catch {} },
                {
                    # Nouvelles versions : verification toutes les 15 secondes
                    $script:MinuterieMajAuto = New-Object System.Windows.Threading.DispatcherTimer
                    $script:MinuterieMajAuto.Interval = [TimeSpan]::FromSeconds(15)
                    $script:MinuterieMajAuto.Add_Tick({ try { if (-not $script:Busy -and -not $script:TestEnCours) { Demarrer-VerifMaj } } catch {} })
                    $script:MinuterieMajAuto.Start()
                },
                { try { Demarrer-Temperatures } catch {} },
                { try { Proposer-Nouveautes } catch {} },
                { try { Migrer-PleinEcran } catch {} },
                { try { Maj-PleinEcran } catch {} },
                { try { Demarrer-Souris } catch {} },
                { try { Reappliquer-GammaOled } catch {} },
                { try { Verifier-SpicetifyAuto } catch {} },
                {
                    $drapeau = Join-Path $DossierData 'raccourcis_proposes.txt'
                    if (-not (Test-Path $drapeau) -and -not $Cache) {
                        New-Item -ItemType Directory -Path $DossierData -Force | Out-Null
                        'ok' | Out-File $drapeau
                        if (Ask-YesNo "Bienvenue dans OptiGame $VersionApp !`r`n`r`nAjouter OptiGame sur le Bureau et dans le menu Demarrer, avec son icone ?`r`n(Tu pourras le refaire dans Versions.)") {
                            if (@(Creer-Raccourcis).Count) { Afficher-Toast 'Raccourcis crees.' }
                        }
                    }
                }
            )) { $script:Etapes.Enqueue($b) }
            $script:MinuterieEtapes = New-Object System.Windows.Threading.DispatcherTimer
            $script:MinuterieEtapes.Interval = [TimeSpan]::FromMilliseconds(40)
            $script:MinuterieEtapes.Add_Tick({
                if ($script:Etapes.Count -eq 0) { $script:MinuterieEtapes.Stop(); return }
                $etape = $script:Etapes.Dequeue()
                $t0 = Get-Date
                try { & $etape } catch { Noter-Erreur 'Demarrage' $_ }
                $ms = [int]((Get-Date) - $t0).TotalMilliseconds
                try { "$((Get-Date).ToString('HH:mm:ss')) etape $(12 - $script:Etapes.Count) : $ms ms" | Out-File -FilePath (Join-Path $DossierData 'demarrage_log.txt') -Append -Encoding ASCII } catch {}
            })
            $script:MinuterieEtapes.Start()
        }
    })
}

# =====================================================================
#  LANCEMENT
# =====================================================================
try {
    try { Appliquer-ThemeXaml } catch {}
    Demarrer-Overlay
    Construire-Interface
    try { Appliquer-ImageFond } catch {}
    if ($Cache) {
        # Lance au demarrage du PC "en arriere-plan" : directement pres de l'horloge
        $UI.Fenetre.ShowActivated = $false
        $UI.Fenetre.WindowState = 'Minimized'
        $script:BulleMontree = $true
        $script:EtaitReduite = $true
    }
    [void]$script:App.Run($UI.Fenetre)
    try { if ($script:Prog) { $script:Prog.Quitter = $true }; Start-Sleep -Milliseconds 300 } catch {}
    [Environment]::Exit(0)
}
catch {
    $err = $_
    $detail = "$($err.Exception.Message)`r`n$($err.ScriptStackTrace)"
    try { Noter-Erreur "Demarrage de l'interface v$VersionApp" $err } catch {}
    try { if ($script:Prog) { $script:Prog.Quitter = $true } } catch {}
    try { [System.Windows.Forms.Clipboard]::SetText("OptiGame v$VersionApp - erreur au demarrage`r`n$detail") } catch {}
    $prec = Lister-Versions | Where-Object { (Version-DeNom $_.Name) -lt (Version-DeNom ([IO.Path]::GetFileName($PSCommandPath))) } | Select-Object -First 1
    $txt = "OptiGame v$VersionApp n'a pas pu s'ouvrir :`r`n`r`n$($err.Exception.Message)`r`n`r`nLe detail a ete copie : colle-le (Ctrl + V) dans la conversation avec Claude."
    if ($prec) {
        $txt += "`r`n`r`nRevenir a la version precedente ($($prec.Name)) ?"
        $r = [System.Windows.Forms.MessageBox]::Show($txt, 'OptiGame', 'YesNo', 'Error')
        if ($r -eq 'Yes') {
            $e = Lire-EtatVersions
            Sauver-EtatVersions $prec.Name (@($e.Vues) + @(Lister-Versions | ForEach-Object { $_.Name }))
            try { $script:Mutex.ReleaseMutex(); $script:Mutex.Dispose() } catch {}
            Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$($prec.FullName)`""
        }
    } else {
        [void][System.Windows.Forms.MessageBox]::Show($txt, 'OptiGame', 'OK', 'Error')
    }
}
