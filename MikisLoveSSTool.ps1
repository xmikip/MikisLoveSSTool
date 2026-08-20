Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase
Add-Type -AssemblyName System.Xaml

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$installDir = Join-Path $env:USERPROFILE 'Downloads\MikisLoveSSTool'
$ErrorActionPreference = 'Stop'

# ============================================================================
# TOOL CATALOG
# ============================================================================
$ToolData = @(
    @{ Name='MeowDoomsdayFucker'; Desc='Checks for Doomsday cheat artefacts'; Category='Minecraft'; Type='GitHub'; URL='https://github.com/MeowTonynoh/MeowDoomsdayFucker/releases/latest' },
    @{ Name='MeowModAnalyzer'; Desc='Analyzes Minecraft mods for suspicious indicators'; Category='Minecraft'; Type='RawPS'; URL='https://raw.githubusercontent.com/MeowTonynoh/MeowModAnalyzer/main/MeowModAnalyzer.ps1' },
    @{ Name='MeowResolver'; Desc='Resolves suspicious / obfuscated strings'; Category='Minecraft'; Type='GitHub'; URL='https://github.com/MeowTonynoh/MeowResolver/releases/latest' },
    @{ Name='MeowNovowareFucker'; Desc='Checks for Novoware-related artefacts'; Category='Minecraft'; Type='GitHub'; URL='https://github.com/MeowTonynoh/MeowNovowareFucker/releases/latest' },
    @{ Name='MeowImportsChecker'; Desc='Checks PE imports for suspicious DLL indicators'; Category='Minecraft'; Type='GitHub'; URL='https://github.com/MeowTonynoh/MeowImportsChecker/releases/latest' },
    @{ Name='MeowClientsFucker'; Desc='Checks for known cheat-client artefacts'; Category='Minecraft'; Type='GitHub'; URL='https://github.com/MeowTonynoh/MeowClientFucker/releases/latest' },
    @{ Name='PrefetchView'; Desc='Parses Windows Prefetch execution artefacts'; Category='Execution'; Type='GitHub'; URL='https://github.com/Orbdiff/PrefetchView/releases/latest' },
    @{ Name='BAMReveal'; Desc='Parses Background Activity Moderator artefacts'; Category='Execution'; Type='GitHub'; URL='https://github.com/Orbdiff/BAMReveal/releases/latest' },
    @{ Name='UserAssistView'; Desc='Parses UserAssist execution history'; Category='Execution'; Type='GitHub'; URL='https://github.com/Orbdiff/UserAssistView/releases/latest' },
    @{ Name='JournalParser'; Desc='Parses NTFS USN Journal entries'; Category='Execution'; Type='GitHub'; URL='https://github.com/Orbdiff/JournalParser/releases/latest' },
    @{ Name='ActivitiesCache'; Desc='Parses Windows ActivitiesCache execution history'; Category='Execution'; Type='GitHub'; URL='https://github.com/spokwn/ActivitiesCache-execution/releases/latest' },
    @{ Name='pcasvc-executed'; Desc='Extracts PCA service execution records'; Category='Execution'; Type='GitHub'; URL='https://github.com/spokwn/pcasvc-executed/releases/latest' },
    @{ Name='process-parser'; Desc='Parses process execution artefacts'; Category='Execution'; Type='GitHub'; URL='https://github.com/spokwn/process-parser/releases/latest' },
    @{ Name='prefetch-parser'; Desc='Parses Windows Prefetch files'; Category='Execution'; Type='GitHub'; URL='https://github.com/spokwn/prefetch-parser/releases/latest' },
    @{ Name='JARParser'; Desc='Parses JAR-related execution artefacts'; Category='Minecraft'; Type='GitHub'; URL='https://github.com/spokwn/JARParser/releases/latest' },
    @{ Name='BAM-parser'; Desc='Parses BAM entries for execution history'; Category='Execution'; Type='GitHub'; URL='https://github.com/spokwn/BAM-parser/releases/latest' },
    @{ Name='PathsParser'; Desc='Extracts and analyzes executable paths'; Category='Execution'; Type='GitHub'; URL='https://github.com/spokwn/PathsParser/releases/latest' },
    @{ Name='JournalTrace'; Desc='Traces file activity through the USN journal'; Category='Forensics'; Type='GitHub'; URL='https://github.com/spokwn/JournalTrace/releases/latest' },
    @{ Name='BamDeletedKeys'; Desc='Finds deleted BAM registry keys'; Category='Forensics'; Type='GitHub'; URL='https://github.com/spokwn/BamDeletedKeys/releases/latest' },
    @{ Name='CommonDirectories'; Desc='Lists files in common suspicious directories'; Category='Forensics'; Type='RawPS'; URL='https://raw.githubusercontent.com/praiselily/lilith-ps/refs/heads/main/CommonDirectories.ps1' },
    @{ Name='Services'; Desc='Lists and reviews Windows services'; Category='Forensics'; Type='RawPS'; URL='https://raw.githubusercontent.com/praiselily/lilith-ps/refs/heads/main/Services.ps1' },
    @{ Name='SignedScheduledTasks'; Desc='Reviews scheduled tasks and signatures'; Category='Forensics'; Type='RawPS'; URL='https://raw.githubusercontent.com/praiselily/lilith-ps/refs/heads/main/Signed-Scheduled-Tasks.ps1' },
    @{ Name='PSHunter'; Desc='Hunts suspicious PowerShell activity'; Category='Forensics'; Type='GitHub'; URL='https://github.com/praiselily/PSHunter/releases/latest' },
    @{ Name='DQRKIS-FUCKER'; Desc='Checks for DQRKIS-related artefacts'; Category='Minecraft'; Type='RawPS'; URL='https://raw.githubusercontent.com/cheesecatlol/DQRKIS-FUCKER/refs/heads/main/DqrkisFucker.ps1' },
    @{ Name='MacroDetector'; Desc='Checks for macro / clicker software traces'; Category='Minecraft'; Type='RawPS'; URL='https://raw.githubusercontent.com/NiccBlahh/MacroDetector/refs/heads/main/MacroDetector.ps1' },
    @{ Name='AmcacheParser'; Desc='Parses Windows Amcache artefacts'; Category='Forensics'; Type='Direct'; URL='https://download.ericzimmermanstools.com/net9/AmcacheParser.zip' },
    @{ Name='bstrings'; Desc='Extracts strings for forensic review'; Category='Forensics'; Type='Direct'; URL='https://download.ericzimmermanstools.com/net9/bstrings.zip' },
    @{ Name='JLECmd'; Desc='Parses Windows Jump Lists'; Category='Forensics'; Type='Direct'; URL='https://download.ericzimmermanstools.com/net9/JLECmd.zip' },
    @{ Name='MFTECmd'; Desc='Parses MFT, USN Journal and filesystem artefacts'; Category='Forensics'; Type='Direct'; URL='https://download.ericzimmermanstools.com/net9/MFTECmd.zip' },
    @{ Name='PECmd'; Desc='Parses Windows Prefetch files'; Category='Forensics'; Type='Direct'; URL='https://download.ericzimmermanstools.com/net9/PECmd.zip' },
    @{ Name='RegistryExplorer'; Desc='GUI explorer for Windows registry hives'; Category='Forensics'; Type='Direct'; URL='https://download.ericzimmermanstools.com/net9/RegistryExplorer.zip' },
    @{ Name='ShellBagsExplorer'; Desc='Reviews ShellBags filesystem history'; Category='Forensics'; Type='Direct'; URL='https://download.ericzimmermanstools.com/net9/ShellBagsExplorer.zip' },
    @{ Name='SrumECmd'; Desc='Parses SRUM usage artefacts'; Category='Forensics'; Type='Direct'; URL='https://download.ericzimmermanstools.com/net9/SrumECmd.zip' },
    @{ Name='TimelineExplorer'; Desc='Views forensic timeline CSV output'; Category='Forensics'; Type='Direct'; URL='https://download.ericzimmermanstools.com/net9/TimelineExplorer.zip' },
    @{ Name='FullEventLogView'; Desc='Reviews Windows Event Log entries'; Category='Forensics'; Type='Direct'; URL='https://www.nirsoft.net/utils/fulleventlogview.zip' },
    @{ Name='BrowserDownloadsView'; Desc='Reviews browser download history'; Category='Forensics'; Type='Direct'; URL='https://www.nirsoft.net/utils/browserdownloadsview.zip' },
    @{ Name='USBDeview'; Desc='Reviews connected USB device history'; Category='Forensics'; Type='Direct'; URL='https://www.nirsoft.net/utils/usbdeview.zip' },
    @{ Name='ExecutedProgramsList'; Desc='Reviews program execution history'; Category='Execution'; Type='Direct'; URL='https://www.nirsoft.net/utils/executedprogramslist.zip' },
    @{ Name='TaskSchedulerView'; Desc='Reviews scheduled tasks and history'; Category='Forensics'; Type='Direct'; URL='https://www.nirsoft.net/utils/taskschedulerview.zip' },
    @{ Name='WinPrefetchView'; Desc='Views Windows Prefetch details'; Category='Execution'; Type='Direct'; URL='https://www.nirsoft.net/utils/winprefetchview.zip' },
    @{ Name='RegScanner'; Desc='Searches registry values and patterns'; Category='Forensics'; Type='Direct'; URL='https://www.nirsoft.net/utils/regscanner.zip' },
    @{ Name='SystemInformer'; Desc='Advanced process and system inspection'; Category='Forensics'; Type='Link'; URL='https://www.systeminformer.com/canary' },
    @{ Name='DIE-engine'; Desc='Detects file type, packer and compiler'; Category='Minecraft'; Type='Link'; URL='https://github.com/horsicq/DIE-engine/releases' },
    @{ Name='Luyten'; Desc='Open-source Java decompiler for JAR inspection'; Category='Minecraft'; Type='GitHub'; URL='https://github.com/deathmarine/Luyten/releases/latest' },
    @{ Name='Jarabel'; Desc='Locates and reviews JAR files'; Category='Minecraft'; Type='GitHub'; URL='https://github.com/nay-cat/Jarabel/releases/latest' },
    @{ Name='Hayabusa'; Desc='Generates fast Windows forensic timelines'; Category='Forensics'; Type='GitHub'; URL='https://github.com/Yamato-Security/hayabusa/releases/latest' }
)

# ============================================================================
# XAML - ELEGANT REDESIGN
# ============================================================================

[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" Title="MikisLoveSSTool" Width="1200" Height="780" MinWidth="1100" MinHeight="700" WindowStartupLocation="CenterScreen" ResizeMode="NoResize" WindowStyle="None" AllowsTransparency="True" Background="Transparent" FontFamily="Segoe UI">
<Window.Resources>
    <!-- Soft Girlie Dark Palette -->
    <SolidColorBrush x:Key="Bg" Color="#1A1121"/>
    <SolidColorBrush x:Key="Side" Color="#23172C"/>
    <SolidColorBrush x:Key="Card" Color="#2B1D35"/>
    <SolidColorBrush x:Key="Pink" Color="#FF85C8"/>
    <SolidColorBrush x:Key="Pink2" Color="#FFC2E2"/>
    <SolidColorBrush x:Key="Text" Color="#FCF0F7"/>
    <SolidColorBrush x:Key="Muted" Color="#B895AD"/>
    <SolidColorBrush x:Key="ConsoleBg" Color="#130B17"/>
    
    <!-- Smooth Drop Shadow for Cards -->
    <DropShadowEffect x:Key="SoftShadow" Color="#000000" Opacity="0.25" BlurRadius="15" ShadowDepth="4" Direction="270"/>

    <!-- Styled Sidebar Buttons -->
    <Style x:Key="SideBtn" TargetType="Button">
        <Setter Property="Background" Value="Transparent"/>
        <Setter Property="Foreground" Value="{StaticResource Text}"/>
        <Setter Property="Height" Value="42"/>
        <Setter Property="Margin" Value="0,0,0,8"/>
        <Setter Property="Cursor" Value="Hand"/>
        <Setter Property="Template">
            <Setter.Value>
                <ControlTemplate TargetType="Button">
                    <Border Background="{TemplateBinding Background}" CornerRadius="10">
                        <ContentPresenter HorizontalAlignment="Left" VerticalAlignment="Center" Margin="16,0"/>
                    </Border>
                    <ControlTemplate.Triggers>
                        <Trigger Property="IsMouseOver" Value="True">
                            <Setter Property="Background" Value="#352442"/>
                            <Setter Property="Foreground" Value="{StaticResource Pink2}"/>
                        </Trigger>
                    </ControlTemplate.Triggers>
                </ControlTemplate>
            </Setter.Value>
        </Setter>
    </Style>

    <!-- Clean Top Buttons -->
    <Style x:Key="TopBtn" TargetType="Button">
        <Setter Property="Background" Value="Transparent"/>
        <Setter Property="Foreground" Value="{StaticResource Muted}"/>
        <Setter Property="Width" Value="46"/>
        <Setter Property="Height" Value="38"/>
        <Setter Property="Cursor" Value="Hand"/>
        <Setter Property="Template">
            <Setter.Value>
                <ControlTemplate TargetType="Button">
                    <Border Background="{TemplateBinding Background}" CornerRadius="8" Margin="4">
                        <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                    </Border>
                    <ControlTemplate.Triggers>
                        <Trigger Property="IsMouseOver" Value="True">
                            <Setter Property="Background" Value="#352442"/>
                            <Setter Property="Foreground" Value="{StaticResource Pink}"/>
                        </Trigger>
                    </ControlTemplate.Triggers>
                </ControlTemplate>
            </Setter.Value>
        </Setter>
    </Style>

    <!-- Custom TabControl to fix white background -->
    <Style TargetType="TabControl">
        <Setter Property="Background" Value="Transparent"/>
        <Setter Property="BorderThickness" Value="0"/>
    </Style>
    
    <Style TargetType="TabItem">
        <Setter Property="Background" Value="Transparent"/>
        <Setter Property="Foreground" Value="{StaticResource Muted}"/>
        <Setter Property="FontSize" Value="13"/>
        <Setter Property="FontWeight" Value="Medium"/>
        <Setter Property="Padding" Value="16,8,16,12"/>
        <Setter Property="Cursor" Value="Hand"/>
        <Setter Property="Template">
            <Setter.Value>
                <ControlTemplate TargetType="TabItem">
                    <Border Name="Border" Background="{TemplateBinding Background}" BorderBrush="Transparent" BorderThickness="0,0,0,2" Margin="0,0,10,0">
                        <ContentPresenter x:Name="ContentSite" VerticalAlignment="Center" HorizontalAlignment="Center" ContentSource="Header" Margin="{TemplateBinding Padding}"/>
                    </Border>
                    <ControlTemplate.Triggers>
                        <Trigger Property="IsSelected" Value="True">
                            <Setter Property="Foreground" Value="{StaticResource Pink}"/>
                            <Setter TargetName="Border" Property="BorderBrush" Value="{StaticResource Pink}"/>
                        </Trigger>
                        <Trigger Property="IsMouseOver" Value="True">
                            <Setter Property="Foreground" Value="{StaticResource Pink2}"/>
                        </Trigger>
                    </ControlTemplate.Triggers>
                </ControlTemplate>
            </Setter.Value>
        </Setter>
    </Style>
</Window.Resources>

<Border Background="{StaticResource Bg}" BorderBrush="#4A2F5D" BorderThickness="1" CornerRadius="16">
    <Grid>
        <Grid.RowDefinitions>
            <RowDefinition Height="54"/>
            <RowDefinition Height="*"/>
        </Grid.RowDefinitions>
        
        <!-- Top Bar -->
        <Border Grid.Row="0" Background="Transparent" CornerRadius="16,16,0,0">
            <Grid Margin="20,0">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition/>
                    <ColumnDefinition Width="Auto"/>
                </Grid.ColumnDefinitions>
                <StackPanel Orientation="Horizontal" VerticalAlignment="Center">
                    <TextBlock Text="✨" FontSize="18" Foreground="{StaticResource Pink}" FontWeight="Bold" Margin="0,0,8,0"/>
                    <TextBlock Text="MikisLoveSSTool" FontSize="16" FontWeight="Bold" Foreground="{StaticResource Text}"/>
                    <TextBlock Text=" made by xmikip with love ♡" FontSize="11" Foreground="{StaticResource Muted}" VerticalAlignment="Center" Margin="8,2,0,0" FontStyle="Italic"/>
                </StackPanel>
                <StackPanel Grid.Column="1" Orientation="Horizontal">
                    <Button x:Name="MinBtn" Style="{StaticResource TopBtn}" Content="—" FontSize="14" FontWeight="Bold"/>
                    <Button x:Name="CloseBtn" Style="{StaticResource TopBtn}" Content="✕" FontSize="14" FontWeight="Bold"/>
                </StackPanel>
            </Grid>
        </Border>

        <Grid Grid.Row="1">
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="240"/>
                <ColumnDefinition/>
            </Grid.ColumnDefinitions>
            
            <!-- Sidebar -->
            <Border Background="{StaticResource Side}" CornerRadius="0,0,0,15" Margin="10,0,0,10" Effect="{StaticResource SoftShadow}">
                <StackPanel Margin="15,20">
                    <!-- Kawaii Cat Box -->
                    <Border Background="{StaticResource Bg}" CornerRadius="12" Padding="0,15" Margin="0,0,0,25" BorderBrush="#352442" BorderThickness="1">
                        <TextBlock x:Name="CatBlock" FontFamily="Consolas" FontSize="12" FontWeight="Bold" Foreground="{StaticResource Pink}" HorizontalAlignment="Center" TextAlignment="Center" LineHeight="16"/>
                    </Border>
                    
                    <TextBlock Text="✧ TOOLS ✧" FontSize="10" FontWeight="Bold" Foreground="{StaticResource Muted}" Margin="4,0,0,10" LetterSpacing="1"/>
                    <Button x:Name="OpenFolderBtn" Style="{StaticResource SideBtn}" Content="♡  Open Tool Folder"/>
                    <Button x:Name="ClearCacheBtn" Style="{StaticResource SideBtn}" Content="ꕤ  Clear Tool Cache"/>
                    <Button x:Name="OpenCmdBtn" Style="{StaticResource SideBtn}" Content="⌁  Open CMD"/>
                    
                    <Separator Background="#4A2F5D" Margin="0,20"/>
                    
                    <TextBlock Text="✧ ABOUT ✧" FontSize="10" FontWeight="Bold" Foreground="{StaticResource Muted}" Margin="4,0,0,10" LetterSpacing="1"/>
                    <TextBlock Text="Minecraft cheat / forensic analysis launcher" TextWrapping="Wrap" Foreground="{StaticResource Text}" FontSize="12" Margin="4,0,4,8" LineHeight="18"/>
                    <TextBlock Text="made by xmikip with love ♡" Foreground="{StaticResource Pink2}" FontSize="11" FontWeight="SemiBold" Margin="4,0"/>
                    <TextBlock x:Name="InstPathBlock" Foreground="#8B6B84" FontSize="10" TextWrapping="Wrap" Margin="4,20,4,0"/>
                </StackPanel>
            </Border>

            <!-- Main Content Area -->
            <Grid Grid.Column="1" Margin="20,0,20,15">
                <Grid.RowDefinitions>
                    <RowDefinition Height="90"/>
                    <RowDefinition Height="15"/>
                    <RowDefinition Height="*"/>
                    <RowDefinition Height="15"/>
                    <RowDefinition Height="160"/>
                </Grid.RowDefinitions>

                <!-- Status Card -->
                <Border Grid.Row="0" Background="{StaticResource Card}" CornerRadius="14" Padding="20,15" Effect="{StaticResource SoftShadow}">
                    <Grid>
                        <StackPanel VerticalAlignment="Center">
                            <TextBlock x:Name="StatusTitle" Text="Ready ✨" FontSize="24" FontWeight="Bold" Foreground="{StaticResource Text}"/>
                            <TextBlock x:Name="StatusSub" Text="Choose a forensic tool to download or launch." FontSize="13" Foreground="{StaticResource Muted}" Margin="0,4,0,0"/>
                        </StackPanel>
                        <Border HorizontalAlignment="Right" VerticalAlignment="Center" Background="#4A2F5D" CornerRadius="12" Padding="14,6">
                            <TextBlock x:Name="StatusBadge" Text="IDLE" Foreground="{StaticResource Pink2}" FontWeight="Bold" FontSize="12" LetterSpacing="1"/>
                        </Border>
                    </Grid>
                </Border>

                <!-- Tools Tab Area -->
                <Border Grid.Row="2" Background="Transparent" CornerRadius="14">
                    <TabControl x:Name="ToolsTab" Padding="0,10,0,0"/>
                </Border>

                <!-- Console -->
                <Border Grid.Row="4" Background="{StaticResource ConsoleBg}" CornerRadius="14" Padding="15,12" Effect="{StaticResource SoftShadow}">
                    <Grid>
                        <Grid.RowDefinitions>
                            <RowDefinition Height="Auto"/>
                            <RowDefinition/>
                        </Grid.RowDefinitions>
                        <TextBlock Text="♡ ACTIVITY CONSOLE" Foreground="#8B6B84" FontSize="10" FontWeight="Bold" FontFamily="Consolas" Margin="0,0,0,8" LetterSpacing="1"/>
                        <TextBox x:Name="LogBox" Grid.Row="1" Background="Transparent" Foreground="{StaticResource Pink2}" BorderThickness="0" FontFamily="Consolas" FontSize="12" IsReadOnly="True" VerticalScrollBarVisibility="Auto" TextWrapping="Wrap" Margin="0,0,-5,0"/>
                    </Grid>
                </Border>
            </Grid>
        </Grid>
    </Grid>
</Border>
</Window>
"@

[xml]$disclaimerXaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" Title="MikisLoveSSTool" Width="580" Height="480" WindowStartupLocation="CenterScreen" ResizeMode="NoResize" WindowStyle="None" AllowsTransparency="True" Background="Transparent" FontFamily="Segoe UI">
<Border Background="#1A1121" BorderBrush="#4A2F5D" BorderThickness="1" CornerRadius="16" Padding="30">
    <Border.Effect>
        <DropShadowEffect Color="#000000" Opacity="0.4" BlurRadius="25" ShadowDepth="5"/>
    </Border.Effect>
    <Grid>
        <Grid.RowDefinitions>
            <RowDefinition/>
            <RowDefinition Height="60"/>
        </Grid.RowDefinitions>
        <StackPanel VerticalAlignment="Center">
            <TextBlock Text="MikisLoveSSTool ✨" FontSize="26" FontWeight="Bold" Foreground="#FF85C8" Margin="0,0,0,20"/>
            <TextBlock TextWrapping="Wrap" Foreground="#FCF0F7" FontSize="14" LineHeight="22" Margin="0,0,0,15" Text="This launcher downloads third-party forensic and analysis tools from their public repositories and stores them locally for review."/>
            <TextBlock TextWrapping="Wrap" Foreground="#FCF0F7" FontSize="14" LineHeight="22" Margin="0,0,0,15" Text="The tools are developed by their respective authors. Review and use each tool according to its own license and documentation."/>
            <TextBlock TextWrapping="Wrap" Foreground="#FFC2E2" FontSize="14" LineHeight="22" FontWeight="SemiBold" Text="Use this project for legitimate Minecraft moderation, cheat detection and forensic analysis. MikisLoveSSTool does not hide, remove or alter evidence."/>
        </StackPanel>
        <Grid Grid.Row="1" Margin="0,15,0,0">
            <Grid.ColumnDefinitions>
                <ColumnDefinition/>
                <ColumnDefinition Width="15"/>
                <ColumnDefinition/>
            </Grid.ColumnDefinitions>
            <Button x:Name="CancelBtn" Content="Cancel" Grid.Column="0" Height="42" Background="Transparent" Foreground="#FCF0F7" BorderBrush="#4A2F5D" BorderThickness="1" Cursor="Hand">
                <Button.Resources><Style TargetType="Border"><Setter Property="CornerRadius" Value="10"/></Style></Button.Resources>
            </Button>
            <Button x:Name="AcceptBtn" Content="♡ Accept &amp; Continue" Grid.Column="2" Height="42" Background="#4A2F5D" Foreground="#FFC2E2" BorderThickness="0" FontWeight="Bold" Cursor="Hand">
                <Button.Resources><Style TargetType="Border"><Setter Property="CornerRadius" Value="10"/></Style></Button.Resources>
            </Button>
        </Grid>
    </Grid>
</Border>
</Window>
"@

function New-XamlWindow($xml) { $r=New-Object System.Xml.XmlNodeReader $xml; [Windows.Markup.XamlReader]::Load($r) }

# Disclaimer
$dw=New-XamlWindow $disclaimerXaml
$ok=$false
$dw.Add_MouseLeftButtonDown({try{$dw.DragMove()}catch{}})
$dw.FindName('AcceptBtn').Add_Click({$script:ok=$true;$dw.Close()})
$dw.FindName('CancelBtn').Add_Click({$script:ok=$false;$dw.Close()})
$dw.ShowDialog()|Out-Null
if(-not $script:ok){exit}

$window=New-XamlWindow $xaml
$MinBtn=$window.FindName('MinBtn');$CloseBtn=$window.FindName('CloseBtn');$StatusTitle=$window.FindName('StatusTitle');$StatusSub=$window.FindName('StatusSub');$StatusBadge=$window.FindName('StatusBadge');$LogBox=$window.FindName('LogBox');$ToolsTab=$window.FindName('ToolsTab');$OpenFolderBtn=$window.FindName('OpenFolderBtn');$ClearCacheBtn=$window.FindName('ClearCacheBtn');$OpenCmdBtn=$window.FindName('OpenCmdBtn');$CatBlock=$window.FindName('CatBlock');$InstPathBlock=$window.FindName('InstPathBlock')
$InstPathBlock.Text="Cache: $installDir"

function Write-Log([string]$Message){$window.Dispatcher.Invoke([Action]{$LogBox.AppendText("[$(Get-Date -Format HH:mm:ss)] $Message`r`n");$LogBox.ScrollToEnd()})}
function Set-Status($Title,$Sub,$Badge='IDLE'){$window.Dispatcher.Invoke([Action]{$StatusTitle.Text=$Title;$StatusSub.Text=$Sub;$StatusBadge.Text=$Badge})}
function Download-File($Url,$OutFile){$tmp="$OutFile.download";if(Test-Path $tmp){Remove-Item $tmp -Force};$wc=[Net.WebClient]::new();$wc.Headers.Add('User-Agent','MikisLoveSSTool');try{$wc.DownloadFile($Url,$tmp);Move-Item $tmp $OutFile -Force}finally{$wc.Dispose();if(Test-Path $tmp){Remove-Item $tmp -Force -ErrorAction SilentlyContinue}}}
function Get-GitHubAsset($Url){if($Url -notmatch 'github\.com/([^/]+)/([^/]+)/releases/latest'){return $null};$api="https://api.github.com/repos/$($Matches[1])/$($Matches[2])/releases/latest";$rel=Invoke-RestMethod $api -Headers @{'User-Agent'='MikisLoveSSTool'} -ErrorAction Stop;$a=$rel.assets|Where-Object{$_.name -match '\.(zip|exe|7z|cmd|bat|jar|ps1)$'}|Select-Object -First 1;if($a){return @{Url=$a.browser_download_url;Name=$a.name}};return $null}
function Launch-File($Path){$ext=[IO.Path]::GetExtension($Path).ToLowerInvariant();if($ext -in '.cmd','.bat'){Start-Process cmd.exe -ArgumentList '/k',('"'+$Path+'"')}elseif($ext -eq '.ps1'){Start-Process powershell.exe -ArgumentList '-NoExit','-NoProfile','-ExecutionPolicy','Bypass','-File',('"'+$Path+'"')}else{Start-Process $Path}}

function Install-AndLaunch($tool){
 $name=$tool.Name;$cat=$tool.Category;$dir=Join-Path $installDir "$cat\$name";New-Item $dir -ItemType Directory -Force|Out-Null
 try{
   Set-Status 'Working...' "Preparing $name..." 'BUSY';Write-Log "Preparing $name"
   if($tool.Type -eq 'Link'){Start-Process $tool.URL;Write-Log "Opened $name in browser.";return}
   if($tool.Type -eq 'RawPS'){$file=Join-Path $dir "$name.ps1";if(-not(Test-Path $file)){Write-Log 'Downloading PowerShell script...';Download-File $tool.URL $file}else{Write-Log 'Cached script.'};Write-Log "Launching local script: $name";Launch-File $file;return}
   if($tool.Type -eq 'GitHub'){$asset=Get-GitHubAsset $tool.URL;if(-not $asset){Start-Process $tool.URL;Write-Log 'No compatible release asset found; opened repository.';return};$file=Join-Path $dir $asset.Name;$url=$asset.Url}else{$url=$tool.URL;$file=Join-Path $dir ([IO.Path]::GetFileName(([Uri]$url).AbsolutePath))}
   if(-not(Test-Path $file)){Write-Log "Downloading $(Split-Path $file -Leaf)...";Download-File $url $file}else{Write-Log "Cached: $(Split-Path $file -Leaf)"}
   if($file -match '\.zip$'){Write-Log 'Extracting archive...';Expand-Archive $file -DestinationPath $dir -Force; $launch=Get-ChildItem $dir -Recurse -File|Where-Object{$_.Extension -in '.exe','.cmd','.bat','.jar','.ps1'}|Sort-Object FullName|Select-Object -First 1;if($launch){Write-Log "Launching $($launch.Name)";Launch-File $launch.FullName}else{Start-Process explorer.exe $dir;Write-Log 'No launchable file found; opened folder.'}}else{Launch-File $file;Write-Log "Launched $name"}
   Set-Status 'Ready ✨' "$name launched successfully." 'IDLE'
 }catch{Write-Log "ERROR: $($_.Exception.Message)";Set-Status 'Error' "Could not launch $name." 'ERR'}
}

# Categories
$Categories=@('Minecraft','Execution','Forensics')
foreach($cat in $Categories){
 $tab=[Windows.Controls.TabItem]::new();$tab.Header=$cat;
 $scroll=[Windows.Controls.ScrollViewer]::new();$scroll.VerticalScrollBarVisibility='Auto';
 $panel=[Windows.Controls.WrapPanel]::new();$panel.Margin='5';
 
 foreach($tool in ($ToolData|Where-Object Category -eq $cat)){
   $btn=[Windows.Controls.Button]::new();$btn.Width=225;$btn.Height=95;$btn.Margin='8';$btn.Cursor='Hand';
   $btn.Foreground='#FCF0F7';$btn.Background='#2B1D35';$btn.BorderThickness=0;$btn.Tag=$tool
   
   # Botón de herramienta estilizado
   $btn.Template=[Windows.Markup.XamlReader]::Parse("<ControlTemplate xmlns='http://schemas.microsoft.com/winfx/2006/xaml/presentation' TargetType='Button'><Border Background='{TemplateBinding Background}' CornerRadius='12'><ContentPresenter HorizontalAlignment='Left' VerticalAlignment='Center' Margin='15,0'/></Border></ControlTemplate>")
   
   $stack=[Windows.Controls.StackPanel]::new();$stack.Margin='0,2';
   $n=[Windows.Controls.TextBlock]::new();$n.Text=$tool.Name;$n.FontWeight='Bold';$n.FontSize=13;$n.TextWrapping='Wrap';$n.Foreground='#FF85C8';
   $d=[Windows.Controls.TextBlock]::new();$d.Text=$tool.Desc;$d.FontSize=11;$d.Foreground='#B895AD';$d.TextWrapping='Wrap';$d.Margin='0,6,0,0';$d.LineHeight=16;
   
   $stack.Children.Add($n)|Out-Null;$stack.Children.Add($d)|Out-Null;$btn.Content=$stack
   
   $btn.Add_MouseEnter({$b=$_.Source;$b.Background='#3E2A4C';$b.RenderTransform=[Windows.Media.ScaleTransform]::new(1.03,1.03);$b.RenderTransformOrigin='0.5,0.5'})
   $btn.Add_MouseLeave({$b=$_.Source;$b.Background='#2B1D35';$b.RenderTransform=[Windows.Media.ScaleTransform]::new(1,1)})
   
   $btn.Add_Click({
     $b=$_.Source;
     $b.IsEnabled=$false;
     $tool=$b.Tag;
     $timer=[Windows.Threading.DispatcherTimer]::new();
     $timer.Interval=[TimeSpan]::FromMilliseconds(80);
     $timer.Tag=@($b,$tool);
     $timer.Add_Tick({
       $tm=$_.Source;
       $tm.Stop();
       $x=$tm.Tag;
       Install-AndLaunch $x[1];
       $x[0].IsEnabled=$true
     });
     $timer.Start()
   })
   $panel.Children.Add($btn)|Out-Null
 };
 $scroll.Content=$panel;$tab.Content=$scroll;$ToolsTab.Items.Add($tab)|Out-Null
}

# New Kawaii Cat Animation ✨
$frames = @(
"  /\_/\  `n ( ˘͈ ᵕ ˘͈ ) `n  > ^ <  `n   ♡ ⋆   ",
"  /\_/\  `n ( ˘͈ ᵕ ˘͈ ) `n  > ^ <  `n   ⋆ ♡   ",
"  /\_/\  `n ( ◕ ᴗ ◕ ) `n  > ❀ <  `n   ✨♡✨  ",
"  /\_/\  `n ( ˶ᵔ ᵕ ᵔ˶ ) `n  > ♡ <  `n   ⋆ ✨ ⋆  "
)
$i=0;$ct=[Windows.Threading.DispatcherTimer]::new();$ct.Interval=[TimeSpan]::FromMilliseconds(800);$ct.Add_Tick({$script:i=($script:i+1)%$frames.Count;$CatBlock.Text=$frames[$script:i]});$ct.Start()

$window.Add_MouseLeftButtonDown({try{$window.DragMove()}catch{}})
$CloseBtn.Add_Click({$ct.Stop();$window.Close()});$MinBtn.Add_Click({$window.WindowState='Minimized'})
$OpenFolderBtn.Add_Click({New-Item $installDir -ItemType Directory -Force|Out-Null;Start-Process explorer.exe $installDir;Write-Log 'Opened tool folder.'})
$ClearCacheBtn.Add_Click({if(Test-Path $installDir){Remove-Item $installDir -Recurse -Force -ErrorAction SilentlyContinue;Write-Log 'Cleared MikisLoveSSTool cache.';Set-Status 'Clean ✨' 'Tool cache cleared.' 'IDLE'}})
$OpenCmdBtn.Add_Click({Start-Process cmd.exe;Write-Log 'Opened CMD.'})
Write-Log "MikisLoveSSTool ready ✨";Write-Log "Cache: $installDir";Set-Status 'Ready ✨' 'Choose a forensic tool to begin.' 'IDLE'
$window.ShowDialog()|Out-Null
