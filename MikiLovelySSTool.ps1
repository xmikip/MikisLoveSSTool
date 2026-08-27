# MikisLoveSSTool.ps1 — Integrated & Translated
# made by xmikip with love
# Save as UTF-8 (BOM recommended). Requires PowerShell 5.1+

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase
Add-Type -AssemblyName System.Xaml
Add-Type -AssemblyName System.Xml

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$installDir = Join-Path $env:USERPROFILE 'Downloads\MikisLoveSSTool'
$ErrorActionPreference = 'Stop'

# Safe characters (independent of file encoding)
$HEART = [string][char]0x2661   # heart
$SPARK = [string][char]0x2728   # sparkle
$STAR  = [string][char]0x22C6   # star

# Complete Integrated Tool Data
$ToolData = @(
    @{ Name='PrefetchView'; Desc='Parses prefetch, extracts file info'; Category='Orbdiff'; Type='GitHub'; URL='https://github.com/Orbdiff/PrefetchView/releases/latest' },
    @{ Name='BAMReveal'; Desc='Parses BAM forensic artefact'; Category='Orbdiff'; Type='GitHub'; URL='https://github.com/Orbdiff/BAMReveal/releases/latest' },
    @{ Name='StringsParser'; Desc='Strings + YARA + signatures scanner'; Category='Orbdiff'; Type='GitHub'; URL='https://github.com/Orbdiff/StringsParser/releases/latest' },
    @{ Name='Fileless'; Desc='Detects fileless via eventlog + memdump'; Category='Orbdiff'; Type='GitHub'; URL='https://github.com/Orbdiff/Fileless/releases/latest' },
    @{ Name='DPS-Analyzer'; Desc='Analyzes DPS memory'; Category='Orbdiff'; Type='GitHub'; URL='https://github.com/Orbdiff/DPS-Analyzer/releases/latest' },
    @{ Name='UserAssistView'; Desc='Parses UserAssist registry artifact'; Category='Orbdiff'; Type='GitHub'; URL='https://github.com/Orbdiff/UserAssistView/releases/latest' },
    @{ Name='JournalParser'; Desc='Parses NTFS USNJournal entries'; Category='Orbdiff'; Type='GitHub'; URL='https://github.com/Orbdiff/JournalParser/releases/latest' },
    @{ Name='InjGen'; Desc='Detects JNI/JVMTI memory injections'; Category='Orbdiff'; Type='GitHub'; URL='https://github.com/Orbdiff/InjGen/releases/latest' },
    @{ Name='USBDetector'; Desc='Detects USB device history'; Category='Orbdiff'; Type='GitHub'; URL='https://github.com/Orbdiff/USBDetector/releases/latest' },
    @{ Name='PFTrace'; Desc='Rundll32/Regsvr32 prefetch analysis'; Category='Orbdiff'; Type='GitHub'; URL='https://github.com/Orbdiff/PFTrace/releases/latest' },
    @{ Name='CheckDeletedUSN'; Desc='Compares USN timestamp vs boot time'; Category='Orbdiff'; Type='GitHub'; URL='https://github.com/Orbdiff/CheckDeletedUSN/releases/latest' },
    @{ Name='JARParser'; Desc='Parses JAR prefetch, DcomLaunch strings'; Category='Orbdiff'; Type='GitHub'; URL='https://github.com/Orbdiff/JARParser/releases/latest' },
    @{ Name='BAM-parser'; Desc='Parses BAM entries for execution history'; Category='Spokwn'; Type='GitHub'; URL='https://github.com/spokwn/BAM-parser/releases/latest' },
    @{ Name='PathsParser'; Desc='Extracts and analyzes executable paths'; Category='Spokwn'; Type='GitHub'; URL='https://github.com/spokwn/PathsParser/releases/latest' },
    @{ Name='JournalTrace'; Desc='Traces file activity via USN journal'; Category='Spokwn'; Type='GitHub'; URL='https://github.com/spokwn/JournalTrace/releases/latest' },
    @{ Name='KernelLiveDumpTool'; Desc='Captures live kernel memory dump'; Category='Spokwn'; Type='GitHub'; URL='https://github.com/spokwn/KernelLiveDumpTool/releases/latest' },
    @{ Name='BamDeletedKeys'; Desc='Finds deleted BAM registry keys'; Category='Spokwn'; Type='GitHub'; URL='https://github.com/spokwn/BamDeletedKeys/releases/latest' },
    @{ Name='Espouken Tool'; Desc='All-in-one SS forensics toolkit'; Category='Spokwn'; Type='GitHub'; URL='https://github.com/spokwn/Tool/releases/latest' },
    @{ Name='pcasvc-executed'; Desc='Extracts PCA service execution records'; Category='Spokwn'; Type='GitHub'; URL='https://github.com/spokwn/pcasvc-executed/releases/latest' },
    @{ Name='process-parser'; Desc='Parses process execution artefacts'; Category='Spokwn'; Type='GitHub'; URL='https://github.com/spokwn/process-parser/releases/latest' },
    @{ Name='prefetch-parser'; Desc='Parses Windows prefetch files'; Category='Spokwn'; Type='GitHub'; URL='https://github.com/spokwn/prefetch-parser/releases/latest' },
    @{ Name='ActivitiesCache'; Desc='Parses ActivitiesCache execution history'; Category='Spokwn'; Type='GitHub'; URL='https://github.com/spokwn/ActivitiesCache-execution/releases/latest' },
    @{ Name='MeowDoomsdayFucker'; Desc='Detects Doomsday cheat artefacts'; Category='Tonynoh'; Type='GitHub'; URL='https://github.com/MeowTonynoh/MeowDoomsdayFucker/releases/latest' },
    @{ Name='MeowModAnalyzer'; Desc='Analyzes mod files for suspicious content'; Category='Tonynoh'; Type='RawPS'; URL='https://raw.githubusercontent.com/MeowTonynoh/MeowModAnalyzer/main/MeowModAnalyzer.ps1' },
    @{ Name='MeowResolver'; Desc='Resolves obfuscated strings in binaries'; Category='Tonynoh'; Type='GitHub'; URL='https://github.com/MeowTonynoh/MeowResolver/releases/latest' },
    @{ Name='MeowNovowareFucker'; Desc='Detects Novoware cheat artefacts'; Category='Tonynoh'; Type='GitHub'; URL='https://github.com/MeowTonynoh/MeowNovowareFucker/releases/latest' },
    @{ Name='MeowImportsChecker'; Desc='Checks PE imports for suspicious DLLs'; Category='Tonynoh'; Type='GitHub'; URL='https://github.com/MeowTonynoh/MeowImportsChecker/releases/latest' },
    @{ Name='MeowClientsFucker'; Desc='Detects known cheat client artefacts'; Category='Tonynoh'; Type='GitHub'; URL='https://github.com/MeowTonynoh/MeowClientFucker/releases/latest' },
    @{ Name='PSHunter'; Desc='Hunts suspicious PowerShell activity'; Category='Praiselily'; Type='GitHub'; URL='https://github.com/praiselily/PSHunter/releases/latest' },
    @{ Name='AltDetector'; Desc='Detects alternate account artefacts'; Category='Praiselily'; Type='GitHub'; URL='https://github.com/praiselily/AltDetector/releases/latest' },
    @{ Name='WeHateFakers'; Desc='Checks hotspot / tethering logs'; Category='Praiselily'; Type='RawPS'; URL='https://raw.githubusercontent.com/praiselily/WeHateFakers/refs/heads/main/HotspotLogs.ps1' },
    @{ Name='CommonDirectories'; Desc='Lists files in common suspicious dirs'; Category='Praiselily'; Type='RawPS'; URL='https://raw.githubusercontent.com/praiselily/lilith-ps/refs/heads/main/CommonDirectories.ps1' },
    @{ Name='HarddiskConverter'; Desc='Converts harddisk identifiers for review'; Category='Praiselily'; Type='RawPS'; URL='https://raw.githubusercontent.com/praiselily/lilith-ps/refs/heads/main/HarddiskConverter.ps1' },
    @{ Name='Services'; Desc='Lists and analyzes running services'; Category='Praiselily'; Type='RawPS'; URL='https://raw.githubusercontent.com/praiselily/lilith-ps/refs/heads/main/Services.ps1' },
    @{ Name='SignedScheduledTasks'; Desc='Finds unsigned / suspicious scheduled tasks'; Category='Praiselily'; Type='RawPS'; URL='https://raw.githubusercontent.com/praiselily/lilith-ps/refs/heads/main/Signed-Scheduled-Tasks.ps1' },
    @{ Name='RL ModAnalyzer'; Desc='Analyzes mod files for cheat indicators'; Category='RedLotus'; Type='GitHub'; URL='https://github.com/ItzIceHere/RedLotus-Mod-Analyzer/releases/latest' },
    @{ Name='RL TaskSentinel'; Desc='Monitors scheduled tasks for anomalies'; Category='RedLotus'; Type='GitHub'; URL='https://github.com/ItzIceHere/RedLotus-Task-Sentinel/releases/latest' },
    @{ Name='RL AltChecker'; Desc='Checks for alternate account indicators'; Category='RedLotus'; Type='GitHub'; URL='https://github.com/ItzIceHere/RedLotusAltChecker/releases/latest' },
    @{ Name='ComputerActivityView'; Desc='Timeline of computer activity events'; Category='Others'; Type='Link'; URL='https://www.nirsoft.net/utils/computer_activity_view.html' },
    @{ Name='AmcacheParser'; Desc='Parses AMCache with YARA + signatures'; Category='Zimmerman'; Type='Direct'; URL='https://download.ericzimmermanstools.com/net9/AmcacheParser.zip' },
    @{ Name='SystemInformer'; Desc='Advanced process and kernel inspector'; Category='Others'; Type='Link'; URL='https://www.systeminformer.com/canary' },
    @{ Name='DIE-engine'; Desc='Detects file type, packer, compiler'; Category='Others'; Type='GitHub'; URL='https://github.com/horsicq/DIE-engine/releases' },
    @{ Name='DQRKIS-FUCKER'; Desc='Detects DQRKIS cheat artefacts'; Category='Others'; Type='RawPS'; URL='https://raw.githubusercontent.com/cheesecatlol/DQRKIS-FUCKER/refs/heads/main/DqrkisFucker.ps1' },
    @{ Name='MacroDetector'; Desc='Detects macro / clicker software traces'; Category='Others'; Type='RawPS'; URL='https://raw.githubusercontent.com/NiccBlahh/MacroDetector/refs/heads/main/MacroDetector.ps1' },
    @{ Name='Jarabel'; Desc='Locates .jar files with detailed checks'; Category='Others'; Type='GitHub'; URL='https://github.com/nay-cat/Jarabel/releases/latest' },
    @{ Name='Luyten'; Desc='Open source Java decompiler GUI (Procyon)'; Category='Others'; Type='GitHub'; URL='https://github.com/deathmarine/Luyten/releases/latest' },
    @{ Name='VMAware'; Desc='Advanced VM detection library and tool'; Category='Others'; Type='GitHub'; URL='https://github.com/kernelwernel/VMAware/releases/latest' },
    @{ Name='Velociraptor'; Desc='Endpoint DFIR and threat hunting agent'; Category='Others'; Type='GitHub'; URL='https://github.com/Velocidex/velociraptor/releases/latest' },
    @{ Name='NTFS Parser'; Desc='NTFS forensics: MFT, Bitlocker, USN'; Category='Others'; Type='GitHub'; URL='https://github.com/thewhiteninja/ntfstool/releases/latest' },
    @{ Name='Hayabusa'; Desc='Fast forensics timeline generator'; Category='Others'; Type='GitHub'; URL='https://github.com/Yamato-Security/hayabusa/releases/latest' },
    @{ Name='Everything'; Desc='Instant filename search engine for Windows'; Category='Others'; Type='Link'; URL='https://www.voidtools.com/downloads/' },
    @{ Name='HxD'; Desc='Fast hex editor with disk and RAM editing'; Category='Others'; Type='Link'; URL='https://mh-nexus.de/en/hxd/' },
    @{ Name='bstrings'; Desc='Searches strings with regex + YARA'; Category='Zimmerman'; Type='Direct'; URL='https://download.ericzimmermanstools.com/net9/bstrings.zip' },
    @{ Name='JLECmd'; Desc='Parses Jump List files (CLI)'; Category='Zimmerman'; Type='Direct'; URL='https://download.ericzimmermanstools.com/net9/JLECmd.zip' },
    @{ Name='JumpListExplorer'; Desc='GUI explorer for Jump List artefacts'; Category='Zimmerman'; Type='Direct'; URL='https://download.ericzimmermanstools.com/net9/JumpListExplorer.zip' },
    @{ Name='MFTECmd'; Desc='Parses MFT, UsnJrnl, LogFile, Boot'; Category='Zimmerman'; Type='Direct'; URL='https://download.ericzimmermanstools.com/net9/MFTECmd.zip' },
    @{ Name='PECmd'; Desc='Parses Windows prefetch files (CLI)'; Category='Zimmerman'; Type='Direct'; URL='https://download.ericzimmermanstools.com/net9/PECmd.zip' },
    @{ Name='RecentFileCacheParser'; Desc='Parses RecentFileCache.bcf artefact'; Category='Zimmerman'; Type='Direct'; URL='https://download.ericzimmermanstools.com/net9/RecentFileCacheParser.zip' },
    @{ Name='RegistryExplorer'; Desc='GUI explorer for registry hives'; Category='Zimmerman'; Type='Direct'; URL='https://download.ericzimmermanstools.com/net9/RegistryExplorer.zip' },
    @{ Name='ShellBagsExplorer'; Desc='GUI explorer for ShellBags artefacts'; Category='Zimmerman'; Type='Direct'; URL='https://download.ericzimmermanstools.com/net9/ShellBagsExplorer.zip' },
    @{ Name='SrumECmd'; Desc='Parses SRUM database for usage data'; Category='Zimmerman'; Type='Direct'; URL='https://download.ericzimmermanstools.com/net9/SrumECmd.zip' },
    @{ Name='TimelineExplorer'; Desc='GUI viewer for CSV timeline output'; Category='Zimmerman'; Type='Direct'; URL='https://download.ericzimmermanstools.com/net9/TimelineExplorer.zip' },
    @{ Name='FullEventLogView'; Desc='Views all Windows event log entries'; Category='NirSoft'; Type='Direct'; URL='https://www.nirsoft.net/utils/fulleventlogview.zip' },
    @{ Name='NetworkUsageView'; Desc='Shows network usage per process'; Category='NirSoft'; Type='Direct'; URL='https://www.nirsoft.net/utils/networkusageview.zip' },
    @{ Name='BrowserDownloadsView'; Desc='Lists all browser download history'; Category='NirSoft'; Type='Direct'; URL='https://www.nirsoft.net/utils/browserdownloadsview.zip' },
    @{ Name='AlternateStreamView'; Desc='Reveals hidden NTFS alternate streams'; Category='NirSoft'; Type='Direct'; URL='https://www.nirsoft.net/utils/alternatestreamview.zip' },
    @{ Name='USBDeview'; Desc='Lists all USB devices ever connected'; Category='NirSoft'; Type='Direct'; URL='https://www.nirsoft.net/utils/usbdeview.zip' },
    @{ Name='OpenSaveFilesView'; Desc='Shows files opened/saved via dialogs'; Category='NirSoft'; Type='Direct'; URL='https://www.nirsoft.net/utils/opensavefilesview.zip' },
    @{ Name='ExecutedProgramsList'; Desc='Lists programs run from various sources'; Category='NirSoft'; Type='Direct'; URL='https://www.nirsoft.net/utils/executedprogramslist.zip' },
    @{ Name='TaskSchedulerView'; Desc='Views all scheduled tasks and history'; Category='NirSoft'; Type='Direct'; URL='https://www.nirsoft.net/utils/taskschedulerview.zip' },
    @{ Name='JumpListsView'; Desc='Views Jump List recent/frequent files'; Category='NirSoft'; Type='Direct'; URL='https://www.nirsoft.net/utils/jumplistsview.zip' },
    @{ Name='WinPrefetchView'; Desc='Views Windows prefetch file details'; Category='NirSoft'; Type='Direct'; URL='https://www.nirsoft.net/utils/winprefetchview.zip' },
    @{ Name='RegScanner'; Desc='Scans registry for values / patterns'; Category='NirSoft'; Type='Direct'; URL='https://www.nirsoft.net/utils/regscanner.zip' },
    @{ Name='ShellBagsView'; Desc='Views ShellBags folder access history'; Category='NirSoft'; Type='Direct'; URL='https://www.nirsoft.net/utils/shellbagsview.zip' },
    @{ Name='NET 9.0'; Desc='Microsoft .NET 9 SDK runtime'; Category='Dependencies'; Type='Direct'; URL='https://download.visualstudio.microsoft.com/download/pr/92dba916-bc51-4e76-8b0e-d41d37ce5fa4/ab08f3e95bf7a3d3da336a7e8c8eca63/dotnet-sdk-9.0.203-win-x64.exe' },
    @{ Name='NET 10.0'; Desc='Microsoft .NET 10 runtime'; Category='Dependencies'; Type='Direct'; URL='https://download.visualstudio.microsoft.com/download/pr/b3f93f0e-9e5e-4b4c-a4c4-36db0c4b0e3e/dotnet-runtime-10.0.0-win-x64.exe' },
    @{ Name='VSRedist'; Desc='Visual C++ redistributable (x64)'; Category='Dependencies'; Type='Direct'; URL='https://aka.ms/vs/17/release/vc_redist.x64.exe' }
)

[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" Title="MikisLoveSSTool" Width="1200" Height="780" WindowStartupLocation="CenterScreen" ResizeMode="NoResize" WindowStyle="None" AllowsTransparency="True" Background="Transparent" FontFamily="Segoe UI">
<Window.Resources>
    <SolidColorBrush x:Key="Bg" Color="#1A1121"/>
    <SolidColorBrush x:Key="Side" Color="#23172C"/>
    <SolidColorBrush x:Key="Card" Color="#2B1D35"/>
    <SolidColorBrush x:Key="Pink" Color="#FF85C8"/>
    <SolidColorBrush x:Key="Pink2" Color="#FFC2E2"/>
    <SolidColorBrush x:Key="Text" Color="#FCF0F7"/>
    <SolidColorBrush x:Key="Muted" Color="#B895AD"/>
    <SolidColorBrush x:Key="ConsoleBg" Color="#130B17"/>

    <DropShadowEffect x:Key="SoftShadow" Color="#000000" Opacity="0.25" BlurRadius="15" ShadowDepth="4" Direction="270"/>

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
                        <ContentPresenter VerticalAlignment="Center" HorizontalAlignment="Center" ContentSource="Header" Margin="{TemplateBinding Padding}"/>
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

        <Border Grid.Row="0" Background="Transparent" CornerRadius="16,16,0,0">
            <Grid Margin="20,0">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition/>
                    <ColumnDefinition Width="Auto"/>
                </Grid.ColumnDefinitions>
                <StackPanel Orientation="Horizontal" VerticalAlignment="Center">
                    <TextBlock Text="&#10024;" FontSize="18" Foreground="{StaticResource Pink}" Margin="0,0,8,0"/>
                    <TextBlock Text="MikisLoveSSTool" FontSize="16" FontWeight="Bold" Foreground="{StaticResource Text}"/>
                    <TextBlock Text=" made by xmikip with love &#9825;" FontSize="11" Foreground="{StaticResource Muted}" VerticalAlignment="Center" Margin="8,2,0,0" FontStyle="Italic"/>
                </StackPanel>
                <StackPanel Grid.Column="1" Orientation="Horizontal">
                    <Button x:Name="MinBtn" Style="{StaticResource TopBtn}" Content="&#8212;" FontSize="14" FontWeight="Bold"/>
                    <Button x:Name="CloseBtn" Style="{StaticResource TopBtn}" Content="&#10005;" FontSize="14" FontWeight="Bold"/>
                </StackPanel>
            </Grid>
        </Border>

        <Grid Grid.Row="1">
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="240"/>
                <ColumnDefinition/>
            </Grid.ColumnDefinitions>

            <Border Background="{StaticResource Side}" CornerRadius="0,0,0,15" Margin="10,0,0,10" Effect="{StaticResource SoftShadow}">
                <StackPanel Margin="15,20">
                    <Border Background="{StaticResource Bg}" CornerRadius="12" Padding="0,15" Margin="0,0,0,25" BorderBrush="#352442" BorderThickness="1">
                        <TextBlock x:Name="CatBlock" FontFamily="Consolas" FontSize="12" FontWeight="Bold" Foreground="{StaticResource Pink}" HorizontalAlignment="Center" TextAlignment="Center" LineHeight="16"/>
                    </Border>

                    <TextBlock Text="TOOLS" FontSize="10" FontWeight="Bold" Foreground="{StaticResource Muted}" Margin="4,0,0,10"/>
                    <Button x:Name="OpenFolderBtn" Style="{StaticResource SideBtn}" Content="&#9825;  Open Tool Folder"/>
                    <Button x:Name="ClearCacheBtn" Style="{StaticResource SideBtn}" Content="&#10047;  Clear Tool Cache"/>
                    <Button x:Name="OpenCmdBtn" Style="{StaticResource SideBtn}" Content="&#10095;_  Open CMD"/>

                    <Separator Background="#4A2F5D" Margin="0,20"/>

                    <TextBlock Text="ABOUT" FontSize="10" FontWeight="Bold" Foreground="{StaticResource Muted}" Margin="4,0,0,10"/>
                    <TextBlock Text="Forensic analysis launcher for Minecraft and System Security" TextWrapping="Wrap" Foreground="{StaticResource Text}" FontSize="12" Margin="4,0,4,8" LineHeight="18"/>
                    <TextBlock Text="made by xmikip with love &#9825;" Foreground="{StaticResource Pink2}" FontSize="11" FontWeight="SemiBold" Margin="4,0"/>
                    <TextBlock x:Name="InstPathBlock" Foreground="#8B6B84" FontSize="10" TextWrapping="Wrap" Margin="4,20,4,0"/>
                </StackPanel>
            </Border>

            <Grid Grid.Column="1" Margin="20,0,20,15">
                <Grid.RowDefinitions>
                    <RowDefinition Height="90"/>
                    <RowDefinition Height="12"/>
                    <RowDefinition Height="44"/>
                    <RowDefinition Height="12"/>
                    <RowDefinition Height="*"/>
                    <RowDefinition Height="12"/>
                    <RowDefinition Height="160"/>
                </Grid.RowDefinitions>

                <Border Grid.Row="0" Background="{StaticResource Card}" CornerRadius="14" Padding="20,15" Effect="{StaticResource SoftShadow}">
                    <Grid>
                        <StackPanel VerticalAlignment="Center">
                            <TextBlock x:Name="StatusTitle" Text="Ready" FontSize="24" FontWeight="Bold" Foreground="{StaticResource Text}"/>
                            <TextBlock x:Name="StatusSub" Text="Choose a forensic tool to download or launch." FontSize="13" Foreground="{StaticResource Muted}" Margin="0,4,0,0"/>
                        </StackPanel>
                        <Border HorizontalAlignment="Right" VerticalAlignment="Center" Background="#4A2F5D" CornerRadius="12" Padding="14,6">
                            <TextBlock x:Name="StatusBadge" Text="IDLE" Foreground="{StaticResource Pink2}" FontWeight="Bold" FontSize="12"/>
                        </Border>
                    </Grid>
                </Border>

                <Border Grid.Row="2" Background="{StaticResource Card}" CornerRadius="12" Padding="14,0" Effect="{StaticResource SoftShadow}">
                    <Grid VerticalAlignment="Center">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="Auto"/>
                            <ColumnDefinition/>
                        </Grid.ColumnDefinitions>
                        <TextBlock Text="&#8981;" FontSize="15" Foreground="{StaticResource Pink}" Margin="0,0,10,0" VerticalAlignment="Center"/>
                        <Grid Grid.Column="1">
                            <TextBox x:Name="SearchBox" Background="Transparent" BorderThickness="0" Foreground="{StaticResource Text}" FontSize="13" VerticalAlignment="Center" CaretBrush="#FF85C8"/>
                            <TextBlock x:Name="SearchHint" Text="Search tool..." Foreground="#8B6B84" FontSize="13" VerticalAlignment="Center" IsHitTestVisible="False"/>
                        </Grid>
                    </Grid>
                </Border>

                <TabControl x:Name="ToolsTab" Grid.Row="4" Padding="0,10,0,0"/>

                <Border Grid.Row="6" Background="{StaticResource ConsoleBg}" CornerRadius="14" Padding="15,12" Effect="{StaticResource SoftShadow}">
                    <Grid>
                        <Grid.RowDefinitions>
                            <RowDefinition Height="Auto"/>
                            <RowDefinition/>
                        </Grid.RowDefinitions>
                        <TextBlock Text="&#9825; ACTIVITY CONSOLE" Foreground="#8B6B84" FontSize="10" FontWeight="Bold" FontFamily="Consolas" Margin="0,0,0,8"/>
                        <TextBox x:Name="LogBox" Grid.Row="1" Background="Transparent" Foreground="{StaticResource Pink2}" BorderThickness="0" FontFamily="Consolas" FontSize="12" IsReadOnly="True" VerticalScrollBarVisibility="Auto" TextWrapping="Wrap"/>
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
    <Border.Effect><DropShadowEffect Color="#000000" Opacity="0.4" BlurRadius="25" ShadowDepth="5"/></Border.Effect>
    <Grid>
        <Grid.RowDefinitions>
            <RowDefinition/>
            <RowDefinition Height="60"/>
        </Grid.RowDefinitions>
        <StackPanel VerticalAlignment="Center">
            <TextBlock Text="MikisLoveSSTool &#10024;" FontSize="26" FontWeight="Bold" Foreground="#FF85C8" Margin="0,0,0,20"/>
            <TextBlock TextWrapping="Wrap" Foreground="#FCF0F7" FontSize="14" LineHeight="22" Margin="0,0,0,15" Text="All tools are downloaded automatically from their public sources and stored locally for inspection."/>
            <TextBlock TextWrapping="Wrap" Foreground="#FCF0F7" FontSize="14" LineHeight="22" Margin="0,0,0,15" Text="Each program is developed and maintained by its respective author. Review and use each tool in accordance with its licensing terms."/>
            <TextBlock TextWrapping="Wrap" Foreground="#FFC2E2" FontSize="14" LineHeight="22" FontWeight="SemiBold" Text="Please ensure you use these tools strictly for legitimate moderation, threat hunting, and digital forensics purposes."/>
        </StackPanel>
        <Grid Grid.Row="1" Margin="0,15,0,0">
            <Grid.ColumnDefinitions>
                <ColumnDefinition/><ColumnDefinition Width="15"/><ColumnDefinition/>
            </Grid.ColumnDefinitions>
            <Button x:Name="CancelBtn" Content="Cancel" Grid.Column="0" Height="42" Background="Transparent" Foreground="#FCF0F7" BorderBrush="#4A2F5D" BorderThickness="1" Cursor="Hand">
                <Button.Resources><Style TargetType="Border"><Setter Property="CornerRadius" Value="10"/></Style></Button.Resources>
            </Button>
            <Button x:Name="AcceptBtn" Content="&#9825; Accept &amp; Continue" Grid.Column="2" Height="42" Background="#4A2F5D" Foreground="#FFC2E2" BorderThickness="0" FontWeight="Bold" Cursor="Hand">
                <Button.Resources><Style TargetType="Border"><Setter Property="CornerRadius" Value="10"/></Style></Button.Resources>
            </Button>
        </Grid>
    </Grid>
</Border>
</Window>
"@

function New-XamlWindow($xml){ 
    $r = New-Object System.Xml.XmlNodeReader $xml
    [System.Windows.Markup.XamlReader]::Load($r) 
}

function Fade-In($win){ 
    $win.Opacity = 0
    $a = [System.Windows.Media.Animation.DoubleAnimation]::new(0,1,[TimeSpan]::FromMilliseconds(400))
    $win.BeginAnimation([System.Windows.Window]::OpacityProperty,$a) 
}

# ---------------- Disclaimer ----------------
$dw = New-XamlWindow $disclaimerXaml
$script:ok = $false
$dw.Add_Loaded({ Fade-In $dw })
$dw.Add_MouseLeftButtonDown({ try{$dw.DragMove()}catch{} })
$dw.FindName('AcceptBtn').Add_Click({ $script:ok=$true; $dw.Close() })
$dw.FindName('CancelBtn').Add_Click({ $script:ok=$false; $dw.Close() })
$dw.ShowDialog() | Out-Null
if(-not $script:ok){ exit }

# ---------------- Main Window ----------------
$window = New-XamlWindow $xaml
foreach($n in 'MinBtn','CloseBtn','StatusTitle','StatusSub','StatusBadge','LogBox','ToolsTab','OpenFolderBtn','ClearCacheBtn','OpenCmdBtn','CatBlock','InstPathBlock','SearchBox','SearchHint'){
    Set-Variable -Name $n -Value $window.FindName($n)
}
$InstPathBlock.Text = "Cache: $installDir"
$StatusTitle.Text = "Ready $SPARK"

function Write-Log([string]$m){ $LogBox.AppendText("[$(Get-Date -Format HH:mm:ss)] $m`r`n"); $LogBox.ScrollToEnd() }
function Set-Status($t,$s,$b='IDLE'){ $StatusTitle.Text=$t; $StatusSub.Text=$s; $StatusBadge.Text=$b }
function Set-Busy([bool]$on){
    if($on){
        $p=[System.Windows.Media.Animation.DoubleAnimation]::new(1,0.35,[TimeSpan]::FromMilliseconds(600))
        $p.AutoReverse=$true; $p.RepeatBehavior=[System.Windows.Media.Animation.RepeatBehavior]::Forever
        $StatusBadge.BeginAnimation([System.Windows.Controls.TextBlock]::OpacityProperty,$p)
    } else {
        $StatusBadge.BeginAnimation([System.Windows.Controls.TextBlock]::OpacityProperty,$null)
        $StatusBadge.Opacity=1
    }
}

# ---------------- Shared State & Background Worker ----------------
$sync = [hashtable]::Synchronized(@{
    Log  = [System.Collections.Queue]::Synchronized([System.Collections.Queue]::new())
    Busy = $false; Err = $false; Name = ''
})
$script:Jobs = @()
$script:WasBusy = $false

$workerScript = {
    param($tool,$installDir,$sync)
    $ErrorActionPreference='Stop'
    [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
    function L($m){ $sync.Log.Enqueue($m) }
    function Download-File($Url,$OutFile){
        $tmp="$OutFile.download"; if(Test-Path $tmp){Remove-Item $tmp -Force}
        $wc=[Net.WebClient]::new(); $wc.Headers.Add('User-Agent','MikisLoveSSTool')
        try{ $wc.DownloadFile($Url,$tmp); Move-Item $tmp $OutFile -Force }
        finally{ $wc.Dispose(); if(Test-Path $tmp){Remove-Item $tmp -Force -ErrorAction SilentlyContinue} }
    }
    function Get-GitHubAsset($Url){
        if($Url -notmatch 'github\.com/([^/]+)/([^/]+)/releases/latest'){ return $null }
        $api="https://api.github.com/repos/$($Matches[1])/$($Matches[2])/releases/latest"
        $rel=Invoke-RestMethod $api -Headers @{'User-Agent'='MikisLoveSSTool'} -ErrorAction Stop
        $pref=@('.exe','.zip','.jar','.ps1','.cmd','.bat','.7z')
        $a=$rel.assets | Where-Object{ $_.name -match '\.(zip|exe|7z|cmd|bat|jar|ps1)$' } |
            Sort-Object { $pref.IndexOf([IO.Path]::GetExtension($_.name).ToLower()) } | Select-Object -First 1
        if($a){ return @{Url=$a.browser_download_url;Name=$a.name} }; return $null
    }
    function Launch-File($Path){
        $ext=[IO.Path]::GetExtension($Path).ToLowerInvariant()
        if($ext -in '.cmd','.bat'){ Start-Process cmd.exe -ArgumentList '/k',('"'+$Path+'"') }
        elseif($ext -eq '.ps1'){ Start-Process powershell.exe -ArgumentList '-NoExit','-ExecutionPolicy','Bypass','-File',('"'+$Path+'"') }
        else{ Start-Process $Path }
    }
    try{
        $name=$tool.Name
        $dir=Join-Path $installDir "$($tool.Category)\$name"
        New-Item $dir -ItemType Directory -Force | Out-Null

        if($tool.Type -eq 'Link'){ Start-Process $tool.URL; L "Opened $name in browser."; return }
        if($tool.Type -eq 'RawPS'){
            $file=Join-Path $dir "$name.ps1"
            if(-not(Test-Path $file)){ L 'Downloading script...'; Download-File $tool.URL $file } else { L 'Script loaded from cache.' }
            L "Launching $name in a new PowerShell context..."; Launch-File $file; return
        }
        if($tool.Type -eq 'GitHub'){
            $asset=Get-GitHubAsset $tool.URL
            if(-not $asset){ Start-Process $tool.URL; L 'No direct release file found; opened GitHub repository page.'; return }
            $file=Join-Path $dir $asset.Name; $url=$asset.Url
        } else {
            $url=$tool.URL; $file=Join-Path $dir ([IO.Path]::GetFileName(([Uri]$url).AbsolutePath))
        }
        if(-not(Test-Path $file)){ L "Downloading $(Split-Path $file -Leaf)..."; Download-File $url $file }
        else{ L "Found cached copy: $(Split-Path $file -Leaf)" }

        if($file -match '\.zip$'){
            L 'Extracting compressed archive...'
            Expand-Archive $file -DestinationPath $dir -Force
            $pref=@('.exe','.jar','.ps1','.cmd','.bat')
            $launch=Get-ChildItem $dir -Recurse -File | Where-Object{ $_.Extension.ToLower() -in $pref } |
                Sort-Object { $pref.IndexOf($_.Extension.ToLower()) },FullName | Select-Object -First 1
            if($launch){ L "Launching $($launch.Name)..."; Launch-File $launch.FullName }
            else{ Start-Process explorer.exe $dir; L 'No executable binary found; opened target folder.' }
        } else { Launch-File $file; L "Successfully launched $name." }
    } catch {
        L "ERROR: $($_.Exception.Message)"; $sync.Err=$true
    } finally {
        $sync.Busy=$false
    }
}

function Start-ToolJob($tool){
    $sync.Busy=$true; $sync.Err=$false; $sync.Name=$tool.Name
    $script:WasBusy=$true
    Set-Status 'Working...' "Preparing $($tool.Name)..." 'BUSY'; Set-Busy $true
    Write-Log "Preparing $($tool.Name)..."
    $ps=[powershell]::Create()
    $rs=[runspacefactory]::CreateRunspace(); $rs.Open(); $ps.Runspace=$rs
    $null=$ps.AddScript($workerScript).AddArgument($tool).AddArgument($installDir).AddArgument($sync)
    $script:Jobs += @{ PS=$ps; RS=$rs; Handle=$ps.BeginInvoke() }
}

# Timer to process log queue to UI
$poll=[System.Windows.Threading.DispatcherTimer]::new()
$poll.Interval=[TimeSpan]::FromMilliseconds(150)
$poll.Add_Tick({
    while($sync.Log.Count -gt 0){ Write-Log $sync.Log.Dequeue() }
    if($script:WasBusy -and -not $sync.Busy){
        $script:WasBusy=$false; Set-Busy $false
        if($sync.Err){ Set-Status 'Error' "Failed to start $($sync.Name)." 'ERR' }
        else{ Set-Status "Ready $SPARK" "$($sync.Name) is running or open." 'IDLE' }
    }
})
$poll.Start()

# ---------------- Dynamic Categories, Tabs and Cards ----------------
$categories = $ToolData.Category | Select-Object -Unique
$script:AllButtons = [System.Collections.Generic.List[object]]::new()

foreach($cat in $categories){
    $tab = [System.Windows.Controls.TabItem]::new()
    $tab.Header = $cat
    $scroll = [System.Windows.Controls.ScrollViewer]::new()
    $scroll.VerticalScrollBarVisibility = 'Auto'
    $panel = [System.Windows.Controls.WrapPanel]::new()
    $panel.Margin = '5'

    foreach($tool in ($ToolData | Where-Object { $_.Category -eq $cat })){
        $btn = [System.Windows.Controls.Button]::new()
        $btn.Width = 225
        $btn.Height = 95
        $btn.Margin = '8'
        $btn.Cursor = 'Hand'
        $btn.Foreground = '#FCF0F7'
        $btn.Background = '#2B1D35'
        $btn.BorderThickness = 0
        $btn.Tag = $tool
        $btn.RenderTransformOrigin = '0.5,0.5'
        $btn.RenderTransform = [System.Windows.Media.ScaleTransform]::new(1,1)
        $btn.Template = [System.Windows.Markup.XamlReader]::Parse("<ControlTemplate xmlns='http://schemas.microsoft.com/winfx/2006/xaml/presentation' TargetType='Button'><Border Background='{TemplateBinding Background}' CornerRadius='12'><ContentPresenter HorizontalAlignment='Left' VerticalAlignment='Center' Margin='15,0'/></Border></ControlTemplate>")

        $stack = [System.Windows.Controls.StackPanel]::new()
        $stack.Margin = '0,2'

        $n = [System.Windows.Controls.TextBlock]::new()
        $n.Text = $tool.Name
        $n.FontWeight = 'Bold'
        $n.FontSize = 13
        $n.TextWrapping = 'Wrap'
        $n.Foreground = '#FF85C8'

        $d = [System.Windows.Controls.TextBlock]::new()
        $d.Text = $tool.Desc
        $d.FontSize = 11
        $d.Foreground = '#B895AD'
        $d.TextWrapping = 'Wrap'
        $d.Margin = '0,6,0,0'
        $d.LineHeight = 16

        $stack.Children.Add($n) | Out-Null
        $stack.Children.Add($d) | Out-Null
        $btn.Content = $stack

        # Animated Hover Effects
        $btn.Add_MouseEnter({
            $this.Background = '#3E2A4C'
            $a = [System.Windows.Media.Animation.DoubleAnimation]::new(1.04, [TimeSpan]::FromMilliseconds(120))
            $this.RenderTransform.BeginAnimation([System.Windows.Media.ScaleTransform]::ScaleXProperty, $a)
            $this.RenderTransform.BeginAnimation([System.Windows.Media.ScaleTransform]::ScaleYProperty, $a)
        })
        $btn.Add_MouseLeave({
            $this.Background = '#2B1D35'
            $a = [System.Windows.Media.Animation.DoubleAnimation]::new(1.0, [TimeSpan]::FromMilliseconds(150))
            $this.RenderTransform.BeginAnimation([System.Windows.Media.ScaleTransform]::ScaleXProperty, $a)
            $this.RenderTransform.BeginAnimation([System.Windows.Media.ScaleTransform]::ScaleYProperty, $a)
        })
        $btn.Add_Click({
            if($sync.Busy){ Write-Log 'Please wait for the active operation to finish...'; return }
            Start-ToolJob $this.Tag
        })

        $script:AllButtons.Add($btn)
        $panel.Children.Add($btn) | Out-Null
    }

    $scroll.Content = $panel
    $tab.Content = $scroll
    $ToolsTab.Items.Add($tab) | Out-Null
}

# Tab transition animation
$ToolsTab.Add_SelectionChanged({
    if($ToolsTab.SelectedContent){
        $a=[System.Windows.Media.Animation.DoubleAnimation]::new(0,1,[TimeSpan]::FromMilliseconds(250))
        $ToolsTab.SelectedContent.BeginAnimation([System.Windows.UIElement]::OpacityProperty,$a)
    }
})

# Filter search bar logic
$SearchBox.Add_TextChanged({
    $SearchHint.Visibility = if($SearchBox.Text){'Collapsed'}else{'Visible'}
    $q=$SearchBox.Text.Trim()
    foreach($b in $script:AllButtons){
        $t=$b.Tag
        $b.Visibility = if(-not $q -or $t.Name -like "*$q*" -or $t.Desc -like "*$q*"){'Visible'}else{'Collapsed'}
    }
})

# Animated Cat ASCII
$frames=@(
    " /\_/\ `n( o . o )`n > ^ <`n  $HEART $STAR",
    " /\_/\ `n( o . o )`n > ^ <`n  $STAR $HEART",
    " /\_/\ `n( ^ w ^ )`n > $HEART <`n $SPARK$HEART$SPARK",
    " /\_/\ `n( - w - )`n > ^ <`n $STAR $SPARK $STAR"
)
$script:i=0
$ct=[System.Windows.Threading.DispatcherTimer]::new()
$ct.Interval=[TimeSpan]::FromMilliseconds(700)
$ct.Add_Tick({ $script:i=($script:i+1)%$frames.Count; $CatBlock.Text=$frames[$script:i] })
$CatBlock.Text=$frames[0]; $ct.Start()

# ---------------- Window Events ----------------
$window.Add_Loaded({ Fade-In $window })
$window.Add_MouseLeftButtonDown({ try{$window.DragMove()}catch{} })
$MinBtn.Add_Click({ $window.WindowState='Minimized' })
$CloseBtn.Add_Click({
    $ct.Stop(); $poll.Stop()
    $a=[System.Windows.Media.Animation.DoubleAnimation]::new(1,0,[TimeSpan]::FromMilliseconds(200))
    $a.Add_Completed({ $window.Close() })
    $window.BeginAnimation([System.Windows.Window]::OpacityProperty,$a)
})
$OpenFolderBtn.Add_Click({ New-Item $installDir -ItemType Directory -Force|Out-Null; Start-Process explorer.exe $installDir; Write-Log 'Opened local tools installation directory.' })
$ClearCacheBtn.Add_Click({
    if($sync.Busy){ Write-Log 'Cannot clear cache while a background action is active.'; return }
    if(Test-Path $installDir){ Remove-Item $installDir -Recurse -Force -ErrorAction SilentlyContinue; Write-Log 'Tool cache deleted.'; Set-Status "Clean $SPARK" 'Cache cleared.' 'IDLE' }
})
$OpenCmdBtn.Add_Click({ Start-Process cmd.exe; Write-Log 'Command Prompt started.' })

Write-Log "MikisLoveSSTool loaded $SPARK"
Write-Log "Cache folder: $installDir"
Set-Status "Ready $SPARK" 'Select a tool to begin.' 'IDLE'
$window.ShowDialog() | Out-Null
