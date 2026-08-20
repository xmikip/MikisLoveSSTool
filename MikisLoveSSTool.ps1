# ==============================================================================
#  MikisLoveSSTool
#  Clean forensic toolkit launcher
#
#  Made by xmikip with ♥
#  Discord: xmikip  ♥  GitHub: xmikip
# ==============================================================================

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase
Add-Type -AssemblyName System.Xaml

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# ------------------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------------------

$AppName    = "MikisLoveSSTool"
$InstallDir = Join-Path $env:USERPROFILE "Downloads\MikisLoveSSTool"

if (-not (Test-Path $InstallDir)) {
    New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
}

# ------------------------------------------------------------------------------
# Tool Catalog
# ------------------------------------------------------------------------------

$Tools = @(
    @{
        Name="InjectDetector"
        Desc="All-in-one: JNI/JVMTI injections + suspicious DLLs"
        Group="xmikip"
        Type="Bundle"
        Items=@(
            @{ Name="InjGen"; URL="https://github.com/Orbdiff/InjGen/releases/latest" }
            @{ Name="ImportsChecker"; URL="https://github.com/MeowTonynoh/MeowImportsChecker/releases/latest" }
        )
    }

    @{
        Name="PrefetchView"
        Desc="Parses prefetch files and extracts execution information"
        Group="xmikip"
        Type="GitHub"
        URL="https://github.com/Orbdiff/PrefetchView/releases/latest"
    }

    @{
        Name="StringsParser"
        Desc="Strings + YARA + signatures scanner"
        Group="xmikip"
        Type="GitHub"
        URL="https://github.com/Orbdiff/StringsParser/releases/latest"
    }

    @{
        Name="Fileless"
        Desc="Detects fileless activity through event logs and memory dumps"
        Group="xmikip"
        Type="GitHub"
        URL="https://github.com/Orbdiff/Fileless/releases/latest"
    }

    @{
        Name="BAM-parser"
        Desc="Parses BAM entries for execution history"
        Group="xmikip"
        Type="GitHub"
        URL="https://github.com/spokwn/BAM-parser/releases/latest"
    }

    @{
        Name="PathsParser"
        Desc="Extracts and analyzes executable paths"
        Group="xmikip"
        Type="GitHub"
        URL="https://github.com/spokwn/PathsParser/releases/latest"
    }

    @{
        Name="JournalTrace"
        Desc="Traces file activity through the USN journal"
        Group="xmikip"
        Type="GitHub"
        URL="https://github.com/spokwn/JournalTrace/releases/latest"
    }

    @{
        Name="Espouken Tool"
        Desc="All-in-one screenshare forensics toolkit"
        Group="xmikip"
        Type="GitHub"
        URL="https://github.com/spokwn/Tool/releases/latest"
    }

    @{
        Name="ModAnalyzer"
        Desc="Analyzes Minecraft mod files for suspicious content"
        Group="xmikip"
        Type="Cmd"
        Command="Invoke-Expression (Invoke-RestMethod 'https://raw.githubusercontent.com/MeowTonynoh/MeowModAnalyzer/main/MeowModAnalyzer.ps1')"
    }

    @{
        Name="ClientsFucker"
        Desc="Detects known cheat client artifacts"
        Group="xmikip"
        Type="GitHub"
        URL="https://github.com/MeowTonynoh/MeowClientFucker/releases/latest"
    }

    @{
        Name="SystemInformer"
        Desc="Advanced process and system inspector"
        Group="Others"
        Type="Link"
        URL="https://www.systeminformer.com/canary"
    }

    @{
        Name="DIE-engine"
        Desc="Detects file type, packer and compiler information"
        Group="Others"
        Type="Web"
        URL="https://github.com/horsicq/DIE-engine/releases"
    }

    @{
        Name="MacroDetector"
        Desc="Detects macro and clicker software traces"
        Group="Others"
        Type="Cmd"
        Command="Invoke-Expression (Invoke-RestMethod 'https://raw.githubusercontent.com/NiccBlahh/MacroDetector/refs/heads/main/MacroDetector.ps1')"
    }

    @{
        Name="Jarabel"
        Desc="Locates .jar files with detailed checks"
        Group="Others"
        Type="GitHub"
        URL="https://github.com/nay-cat/Jarabel/releases/latest"
    }

    @{
        Name="Luyten"
        Desc="Open-source Java decompiler GUI"
        Group="Others"
        Type="GitHub"
        URL="https://github.com/deathmarine/Luyten/releases/latest"
    }

    @{
        Name="Everything"
        Desc="Instant filename search engine for Windows"
        Group="Others"
        Type="Link"
        URL="https://www.voidtools.com/downloads/"
    }

    @{
        Name="HxD"
        Desc="Fast hex editor with disk and RAM editing"
        Group="Others"
        Type="Link"
        URL="https://mh-nexus.de/en/hxd/"
    }

    @{
        Name="MFTECmd"
        Desc="Parses MFT, UsnJrnl, LogFile and Boot records"
        Group="xmikip"
        Type="Web"
        URL="https://download.ericzimmermanstools.com/net9/MFTECmd.zip"
    }

    @{
        Name="PECmd"
        Desc="Parses Windows prefetch files"
        Group="xmikip"
        Type="Web"
        URL="https://download.ericzimmermanstools.com/net9/PECmd.zip"
    }

    @{
        Name="RegistryExplorer"
        Desc="GUI explorer for Windows registry hives"
        Group="xmikip"
        Type="Web"
        URL="https://download.ericzimmermanstools.com/net9/RegistryExplorer.zip"
    }

    @{
        Name="TimelineExplorer"
        Desc="GUI viewer for CSV timeline output"
        Group="xmikip"
        Type="Web"
        URL="https://download.ericzimmermanstools.com/net9/TimelineExplorer.zip"
    }

    @{
        Name="FullEventLogView"
        Desc="Views Windows event log entries"
        Group="xmikip"
        Type="Web"
        URL="https://www.nirsoft.net/utils/fulleventlogview.zip"
    }

    @{
        Name="USBDeview"
        Desc="Lists USB devices previously connected"
        Group="xmikip"
        Type="Web"
        URL="https://www.nirsoft.net/utils/usbdeview.zip"
    }

    @{
        Name="ExecutedProgramsList"
        Desc="Lists programs executed from various sources"
        Group="xmikip"
        Type="Web"
        URL="https://www.nirsoft.net/utils/executedprogramslist.zip"
    }

    @{
        Name="NET 9.0"
        Desc="Microsoft .NET 9 SDK"
        Group="Dependencies"
        Type="Web"
        URL="https://download.visualstudio.microsoft.com/download/pr/92dba916-bc51-4e76-8b0e-d41d37ce5fa4/ab08f3e95bf7a3d3da336a7e8c8eca63/dotnet-sdk-9.0.203-win-x64.exe"
    }

    @{
        Name="VSRedist"
        Desc="Microsoft Visual C++ Redistributable x64"
        Group="Dependencies"
        Type="Web"
        URL="https://aka.ms/vs/17/release/vc_redist.x64.exe"
    }
)

# ------------------------------------------------------------------------------
# Disclaimer
# ------------------------------------------------------------------------------

[xml]$DisclaimerXaml = @'
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="MikisLoveSSTool"
    Width="560"
    Height="470"
    WindowStartupLocation="CenterScreen"
    ResizeMode="NoResize"
    WindowStyle="None"
    AllowsTransparency="True"
    Background="Transparent"
    FontFamily="Segoe UI"
    Opacity="0">

    <Window.Triggers>
        <EventTrigger RoutedEvent="Window.Loaded">
            <BeginStoryboard>
                <Storyboard>
                    <DoubleAnimation
                        Storyboard.TargetProperty="Opacity"
                        From="0"
                        To="1"
                        Duration="0:0:0.45"/>
                </Storyboard>
            </BeginStoryboard>
        </EventTrigger>
    </Window.Triggers>

    <Grid Margin="14">

        <Border
            Background="#1C0E17"
            BorderBrush="#5C2B47"
            BorderThickness="1"
            CornerRadius="18"
            Padding="30">

            <Border.Effect>
                <DropShadowEffect
                    Color="#FF4FA0"
                    BlurRadius="30"
                    ShadowDepth="0"
                    Opacity="0.35"/>
            </Border.Effect>

            <Grid>

                <Grid.RowDefinitions>
                    <RowDefinition Height="*"/>
                    <RowDefinition Height="55"/>
                </Grid.RowDefinitions>

                <StackPanel Grid.Row="0">

                    <StackPanel
                        Orientation="Horizontal"
                        Margin="0,0,0,18">

                        <Ellipse
                            Width="12"
                            Height="12"
                            VerticalAlignment="Center">

                            <Ellipse.Fill>
                                <LinearGradientBrush
                                    StartPoint="0,0"
                                    EndPoint="1,1">

                                    <GradientStop
                                        Color="#FF6FB5"
                                        Offset="0"/>

                                    <GradientStop
                                        Color="#FF9AD6"
                                        Offset="1"/>

                                </LinearGradientBrush>
                            </Ellipse.Fill>

                        </Ellipse>

                        <TextBlock
                            Text="  MikisLoveSSTool"
                            FontSize="21"
                            FontWeight="Bold"
                            Foreground="#FFE8F3"/>

                    </StackPanel>

                    <TextBlock
                        TextWrapping="Wrap"
                        Foreground="#F5C9DE"
                        FontSize="13"
                        Margin="0,0,0,14"
                        Text="All programs are downloaded automatically from their official repositories and saved in an organized folder. MikisLoveSSTool does not collect or modify your personal information."/>

                    <TextBlock
                        TextWrapping="Wrap"
                        Foreground="#F5C9DE"
                        FontSize="13"
                        Margin="0,0,0,18"
                        Text="Each tool is created and maintained by its respective author. MikisLoveSSTool is only a launcher and does not control third-party software."/>

                    <Border
                        Background="#241226"
                        BorderBrush="#5C2B47"
                        BorderThickness="1"
                        CornerRadius="10"
                        Padding="12"
                        Margin="0,0,0,10">

                        <TextBlock
                            TextWrapping="Wrap"
                            Foreground="#FF9AD6"
                            FontSize="12"
                            Text="Use these tools only on systems and files you are authorized to inspect."/>

                    </Border>

                    <TextBlock
                        TextWrapping="Wrap"
                        Foreground="#FFE8F3"
                        FontSize="13"
                        FontWeight="SemiBold"
                        Text="To continue, you must agree with the information above."/>

                </StackPanel>

                <Grid Grid.Row="1">

                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="*"/>
                        <ColumnDefinition Width="12"/>
                        <ColumnDefinition Width="*"/>
                    </Grid.ColumnDefinitions>

                    <Button
                        x:Name="DeclineBtn"
                        Grid.Column="0"
                        Content="Cancel"
                        Height="42"
                        Cursor="Hand"
                        FontSize="13">

                        <Button.Template>
                            <ControlTemplate TargetType="Button">

                                <Border
                                    x:Name="Bd"
                                    Background="#2A1420"
                                    BorderBrush="#5C2B47"
                                    BorderThickness="1"
                                    CornerRadius="10">

                                    <ContentPresenter
                                        HorizontalAlignment="Center"
                                        VerticalAlignment="Center"
                                        TextElement.Foreground="#F5C9DE"/>

                                </Border>

                                <ControlTemplate.Triggers>

                                    <Trigger
                                        Property="IsMouseOver"
                                        Value="True">

                                        <Setter
                                            TargetName="Bd"
                                            Property="Background"
                                            Value="#3A1B2C"/>

                                    </Trigger>

                                </ControlTemplate.Triggers>

                            </ControlTemplate>
                        </Button.Template>

                    </Button>

                    <Button
                        x:Name="AcceptBtn"
                        Grid.Column="2"
                        Content="Accept &amp; Continue"
                        Height="42"
                        Cursor="Hand"
                        FontSize="13"
                        FontWeight="SemiBold">

                        <Button.Template>
                            <ControlTemplate TargetType="Button">

                                <Border
                                    x:Name="Bd"
                                    CornerRadius="10">

                                    <Border.Background>
                                        <LinearGradientBrush
                                            StartPoint="0,0"
                                            EndPoint="1,1">

                                            <GradientStop
                                                Color="#FF6FB5"
                                                Offset="0"/>

                                            <GradientStop
                                                Color="#FF9AD6"
                                                Offset="1"/>

                                        </LinearGradientBrush>
                                    </Border.Background>

                                    <ContentPresenter
                                        HorizontalAlignment="Center"
                                        VerticalAlignment="Center"
                                        TextElement.Foreground="#FFFFFF"/>

                                </Border>

                                <ControlTemplate.Triggers>

                                    <Trigger
                                        Property="IsMouseOver"
                                        Value="True">

                                        <Setter
                                            TargetName="Bd"
                                            Property="Opacity"
                                            Value="0.82"/>

                                    </Trigger>

                                </ControlTemplate.Triggers>

                            </ControlTemplate>
                        </Button.Template>

                    </Button>

                </Grid>

            </Grid>

        </Border>

    </Grid>

</Window>
'@

# ------------------------------------------------------------------------------
# Main Window
# ------------------------------------------------------------------------------

[xml]$MainXaml = @'
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="MikisLoveSSTool"
    Width="1180"
    Height="760"
    MinWidth="1000"
    MinHeight="680"
    WindowStartupLocation="CenterScreen"
    ResizeMode="CanResize"
    WindowStyle="None"
    AllowsTransparency="True"
    Background="Transparent"
    FontFamily="Segoe UI"
    Opacity="0">

    <Window.Resources>

        <SolidColorBrush x:Key="WindowBg" Color="#1C0E17"/>
        <SolidColorBrush x:Key="PanelBg" Color="#241226"/>
        <SolidColorBrush x:Key="CardBg" Color="#301A30"/>
        <SolidColorBrush x:Key="ConsoleBg" Color="#150A12"/>
        <SolidColorBrush x:Key="Accent" Color="#FF6FB5"/>
        <SolidColorBrush x:Key="Accent2" Color="#FF9AD6"/>
        <SolidColorBrush x:Key="TextMain" Color="#FFE8F3"/>
        <SolidColorBrush x:Key="TextSoft" Color="#F5C9DE"/>
        <SolidColorBrush x:Key="TextMuted" Color="#B58AA0"/>
        <SolidColorBrush x:Key="Line" Color="#5C2B47"/>

        <!-- Scrollbar -->

        <Style TargetType="ScrollBar">

            <Setter Property="Width" Value="8"/>
            <Setter Property="Background" Value="Transparent"/>

            <Setter Property="Template">

                <Setter.Value>

                    <ControlTemplate TargetType="ScrollBar">

                        <Grid Background="Transparent">

                            <Track
                                x:Name="PART_Track"
                                IsDirectionReversed="True">

                                <Track.Thumb>

                                    <Thumb>

                                        <Thumb.Template>

                                            <ControlTemplate TargetType="Thumb">

                                                <Border
                                                    Background="#7A3F63"
                                                    CornerRadius="4"
                                                    Margin="2,0"/>

                                            </ControlTemplate>

                                        </Thumb.Template>

                                    </Thumb>

                                </Track.Thumb>

                            </Track>

                        </Grid>

                    </ControlTemplate>

                </Setter.Value>

            </Setter>

        </Style>

        <!-- Sidebar buttons -->

        <Style x:Key="ActionBtn" TargetType="Button">

            <Setter Property="Height" Value="38"/>
            <Setter Property="Margin" Value="0,0,0,8"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="FontSize" Value="12"/>
            <Setter Property="Foreground" Value="{StaticResource TextSoft}"/>
            <Setter Property="Background" Value="{StaticResource CardBg}"/>

            <Setter Property="Template">

                <Setter.Value>

                    <ControlTemplate TargetType="Button">

                        <Border
                            x:Name="Bd"
                            Background="{TemplateBinding Background}"
                            BorderBrush="#33FFFFFF"
                            BorderThickness="1"
                            CornerRadius="10">

                            <ContentPresenter
                                HorizontalAlignment="Left"
                                VerticalAlignment="Center"
                                Margin="14,0"/>

                        </Border>

                        <ControlTemplate.Triggers>

                            <Trigger
                                Property="IsMouseOver"
                                Value="True">

                                <Setter
                                    TargetName="Bd"
                                    Property="Background"
                                    Value="#3A1B2C"/>

                                <Setter
                                    Property="Foreground"
                                    Value="#FFFFFF"/>

                            </Trigger>

                            <Trigger
                                Property="IsPressed"
                                Value="True">

                                <Setter
                                    TargetName="Bd"
                                    Property="Background"
                                    Value="#FF6FB5"/>

                                <Setter
                                    Property="Foreground"
                                    Value="#FFFFFF"/>

                            </Trigger>

                        </ControlTemplate.Triggers>

                    </ControlTemplate>

                </Setter.Value>

            </Setter>

        </Style>

        <!-- Title buttons -->

        <Style x:Key="TitleBtn" TargetType="Button">

            <Setter Property="Width" Value="34"/>
            <Setter Property="Height" Value="30"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="FontSize" Value="12"/>
            <Setter Property="Foreground" Value="{StaticResource TextMuted}"/>
            <Setter Property="Background" Value="Transparent"/>

            <Setter Property="Template">

                <Setter.Value>

                    <ControlTemplate TargetType="Button">

                        <Border
                            x:Name="Bd"
                            Background="{TemplateBinding Background}"
                            CornerRadius="8">

                            <ContentPresenter
                                HorizontalAlignment="Center"
                                VerticalAlignment="Center"/>

                        </Border>

                        <ControlTemplate.Triggers>

                            <Trigger
                                Property="IsMouseOver"
                                Value="True">

                                <Setter
                                    TargetName="Bd"
                                    Property="Background"
                                    Value="#3A1B2C"/>

                                <Setter
                                    Property="Foreground"
                                    Value="#FFFFFF"/>

                            </Trigger>

                        </ControlTemplate.Triggers>

                    </ControlTemplate>

                </Setter.Value>

            </Setter>

        </Style>

    </Window.Resources>

    <!-- Animations -->

    <Window.Triggers>

        <EventTrigger RoutedEvent="Window.Loaded">

            <BeginStoryboard>

                <Storyboard>

                    <DoubleAnimation
                        Storyboard.TargetProperty="Opacity"
                        From="0"
                        To="1"
                        Duration="0:0:0.55"/>

                    <!-- Heart pulse -->

                    <DoubleAnimation
                        Storyboard.TargetName="HeartScale"
                        Storyboard.TargetProperty="ScaleX"
                        From="1"
                        To="1.12"
                        Duration="0:0:0.8"
                        AutoReverse="True"
                        RepeatBehavior="Forever"/>

                    <DoubleAnimation
                        Storyboard.TargetName="HeartScale"
                        Storyboard.TargetProperty="ScaleY"
                        From="1"
                        To="1.12"
                        Duration="0:0:0.8"
                        AutoReverse="True"
                        RepeatBehavior="Forever"/>

                    <!-- Glow pulse -->

                    <DoubleAnimation
                        Storyboard.TargetName="HeartGlow"
                        Storyboard.TargetProperty="Opacity"
                        From="0.35"
                        To="0.75"
                        Duration="0:0:0.8"
                        AutoReverse="True"
                        RepeatBehavior="Forever"/>

                    <!-- Ring pulse -->

                    <DoubleAnimation
                        Storyboard.TargetName="PulseRingScale"
                        Storyboard.TargetProperty="ScaleX"
                        From="1"
                        To="1.18"
                        Duration="0:0:1.4"
                        AutoReverse="True"
                        RepeatBehavior="Forever"/>

                    <DoubleAnimation
                        Storyboard.TargetName="PulseRingScale"
                        Storyboard.TargetProperty="ScaleY"
                        From="1"
                        To="1.18"
                        Duration="0:0:1.4"
                        AutoReverse="True"
                        RepeatBehavior="Forever"/>

                    <DoubleAnimation
                        Storyboard.TargetName="PulseRing"
                        Storyboard.TargetProperty="Opacity"
                        From="0.75"
                        To="0.15"
                        Duration="0:0:1.4"
                        AutoReverse="True"
                        RepeatBehavior="Forever"/>

                </Storyboard>

            </BeginStoryboard>

        </EventTrigger>

    </Window.Triggers>

    <Grid Margin="14">

        <Border
            Background="{StaticResource WindowBg}"
            BorderBrush="{StaticResource Line}"
            BorderThickness="1"
            CornerRadius="16">

            <Border.Effect>

                <DropShadowEffect
                    Color="#FF4FA0"
                    BlurRadius="30"
                    ShadowDepth="0"
                    Opacity="0.28"/>

            </Border.Effect>

            <Grid>

                <Grid.RowDefinitions>

                    <RowDefinition Height="52"/>
                    <RowDefinition Height="*"/>

                </Grid.RowDefinitions>

                <!-- TITLE BAR -->

                <Grid
                    Grid.Row="0"
                    Margin="20,0,14,0">

                    <StackPanel
                        Orientation="Horizontal"
                        VerticalAlignment="Center">

                        <Ellipse
                            Width="10"
                            Height="10"
                            VerticalAlignment="Center">

                            <Ellipse.Fill>

                                <LinearGradientBrush
                                    StartPoint="0,0"
                                    EndPoint="1,1">

                                    <GradientStop
                                        Color="#FF6FB5"
                                        Offset="0"/>

                                    <GradientStop
                                        Color="#FF9AD6"
                                        Offset="1"/>

                                </LinearGradientBrush>

                            </Ellipse.Fill>

                        </Ellipse>

                        <TextBlock
                            Text="  MikisLoveSSTool"
                            FontSize="14"
                            FontWeight="SemiBold"
                            Foreground="{StaticResource TextMain}"
                            VerticalAlignment="Center"/>

                        <TextBlock
                            Text="   cute forensic toolkit  ♡"
                            FontSize="11"
                            Foreground="{StaticResource TextMuted}"
                            VerticalAlignment="Center"/>

                    </StackPanel>

                    <StackPanel
                        Orientation="Horizontal"
                        HorizontalAlignment="Right"
                        VerticalAlignment="Center">

                        <Button
                            x:Name="MinBtn"
                            Style="{StaticResource TitleBtn}"
                            Content="&#x2500;"/>

                        <Button
                            x:Name="CloseBtn"
                            Style="{StaticResource TitleBtn}"
                            Content="&#x2715;"
                            Margin="4,0,0,0"/>

                    </StackPanel>

                </Grid>

                <!-- BODY -->

                <Grid Grid.Row="1">

                    <Grid.ColumnDefinitions>

                        <ColumnDefinition Width="240"/>
                        <ColumnDefinition Width="*"/>

                    </Grid.ColumnDefinitions>

                    <!-- SIDEBAR -->

                    <Border
                        Grid.Column="0"
                        Background="{StaticResource PanelBg}"
                        CornerRadius="0,0,0,16"
                        Padding="16,10,16,16">

                        <Grid>

                            <Grid.RowDefinitions>

                                <RowDefinition Height="Auto"/>
                                <RowDefinition Height="Auto"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="Auto"/>

                            </Grid.RowDefinitions>

                            <!-- HEART -->

                            <Grid
                                Grid.Row="0"
                                Width="120"
                                Height="120"
                                HorizontalAlignment="Center"
                                Margin="0,4,0,8">

                                <Ellipse
                                    x:Name="PulseRing"
                                    Width="105"
                                    Height="105"
                                    StrokeThickness="2"
                                    Opacity="0.7"
                                    RenderTransformOrigin="0.5,0.5">

                                    <Ellipse.Stroke>

                                        <LinearGradientBrush
                                            StartPoint="0,0"
                                            EndPoint="1,1">

                                            <GradientStop
                                                Color="#FF7FC0"
                                                Offset="0"/>

                                            <GradientStop
                                                Color="#FF9AD6"
                                                Offset="1"/>

                                        </LinearGradientBrush>

                                    </Ellipse.Stroke>

                                    <Ellipse.RenderTransform>

                                        <ScaleTransform
                                            x:Name="PulseRingScale"
                                            ScaleX="1"
                                            ScaleY="1"/>

                                    </Ellipse.RenderTransform>

                                </Ellipse>

                                <!-- Heart glow -->

                                <Path
                                    x:Name="HeartGlow"
                                    Width="72"
                                    Height="72"
                                    HorizontalAlignment="Center"
                                    VerticalAlignment="Center"
                                    Stretch="Fill"
                                    Fill="#FF4FA0"
                                    Opacity="0.45"
                                    Data="M 36,65 C 32,61 8,46 8,27 C 8,15 16,8 27,8 C 32,8 36,12 36,17 C 36,12 40,8 45,8 C 56,8 64,15 64,27 C 64,46 40,61 36,65 Z">

                                    <Path.Effect>

                                        <BlurEffect Radius="12"/>

                                    </Path.Effect>

                                </Path>

                                <!-- Main heart -->

                                <Path
                                    Width="68"
                                    Height="68"
                                    HorizontalAlignment="Center"
                                    VerticalAlignment="Center"
                                    Stretch="Fill"
                                    Data="M 36,65 C 32,61 8,46 8,27 C 8,15 16,8 27,8 C 32,8 36,12 36,17 C 36,12 40,8 45,8 C 56,8 64,15 64,27 C 64,46 40,61 36,65 Z"
                                    RenderTransformOrigin="0.5,0.5">

                                    <Path.Fill>

                                        <LinearGradientBrush
                                            StartPoint="0,0"
                                            EndPoint="1,1">

                                            <GradientStop
                                                Color="#FF6FB5"
                                                Offset="0"/>

                                            <GradientStop
                                                Color="#FF9AD6"
                                                Offset="1"/>

                                        </LinearGradientBrush>

                                    </Path.Fill>

                                    <Path.RenderTransform>

                                        <ScaleTransform
                                            x:Name="HeartScale"
                                            ScaleX="1"
                                            ScaleY="1"/>

                                    </Path.RenderTransform>

                                </Path>

                            </Grid>

                            <!-- CATEGORIES -->

                            <StackPanel
                                Grid.Row="1"
                                Margin="0,8,0,0">

                                <TextBlock
                                    Text="CATEGORIES"
                                    FontSize="11"
                                    FontWeight="Bold"
                                    Foreground="{StaticResource TextMuted}"
                                    Margin="4,0,0,10"/>

                                <Button
                                    x:Name="CatAllBtn"
                                    Style="{StaticResource ActionBtn}"
                                    Content="&#x25C8;   All Tools"/>

                                <Button
                                    x:Name="CatXmikipBtn"
                                    Style="{StaticResource ActionBtn}"
                                    Content="&#x2728;   xmikip Tools"/>

                                <Button
                                    x:Name="CatOthersBtn"
                                    Style="{StaticResource ActionBtn}"
                                    Content="&#x2699;   Other Authors"/>

                                <Button
                                    x:Name="CatDepsBtn"
                                    Style="{StaticResource ActionBtn}"
                                    Content="&#x1F4E6;   Dependencies"/>

                            </StackPanel>

                            <Border Grid.Row="2"/>

                            <!-- FOOTER -->

                            <StackPanel Grid.Row="3">

                                <Button
                                    x:Name="OpenFolderBtn"
                                    Style="{StaticResource ActionBtn}"
                                    Content="&#x1F4C2;   Downloads Folder"/>

                                <TextBlock
                                    Text="Made by xmikip with ♥"
                                    FontSize="11"
                                    Foreground="{StaticResource TextMuted}"
                                    HorizontalAlignment="Center"
                                    Margin="0,10,0,0"/>

                            </StackPanel>

                        </Grid>

                    </Border>

                    <!-- MAIN -->

                    <Grid
                        Grid.Column="1"
                        Margin="24,10,14,20">

                        <Grid.RowDefinitions>

                            <RowDefinition Height="Auto"/>
                            <RowDefinition Height="*"/>
                            <RowDefinition Height="Auto"/>

                        </Grid.RowDefinitions>

                        <StackPanel Grid.Row="0">

                            <TextBlock
                                Text="Select a tool"
                                FontSize="18"
                                FontWeight="SemiBold"
                                Foreground="{StaticResource TextMain}"/>

                            <TextBlock
                                Text="Download, inspect or launch a forensic utility."
                                FontSize="11"
                                Foreground="{StaticResource TextMuted}"
                                Margin="0,3,0,16"/>

                        </StackPanel>

                        <ScrollViewer
                            Grid.Row="1"
                            VerticalScrollBarVisibility="Auto"
                            HorizontalScrollBarVisibility="Disabled">

                            <WrapPanel
                                x:Name="ToolContainer"
                                Orientation="Horizontal"
                                ItemWidth="280"
                                Margin="0,0,0,10"/>

                        </ScrollViewer>

                        <Border
                            Grid.Row="2"
                            Background="{StaticResource ConsoleBg}"
                            CornerRadius="8"
                            Padding="14,12"
                            Margin="0,14,0,0">

                            <TextBlock
                                x:Name="StatusText"
                                Text="Waiting for action..."
                                FontSize="12"
                                Foreground="{StaticResource Accent2}"
                                FontFamily="Consolas"/>

                        </Border>

                    </Grid>

                </Grid>

            </Grid>

        </Border>

    </Grid>

</Window>
'@

# ------------------------------------------------------------------------------
# Disclaimer Loader
# ------------------------------------------------------------------------------

$DisclaimerReader = New-Object System.Xml.XmlNodeReader $DisclaimerXaml
$DisclaimerWindow = [Windows.Markup.XamlReader]::Load($DisclaimerReader)

$global:Accepted = $false

$DisclaimerWindow.FindName("AcceptBtn").add_Click({
    $global:Accepted = $true
    $DisclaimerWindow.Close()
})

$DisclaimerWindow.FindName("DeclineBtn").add_Click({
    $DisclaimerWindow.Close()
})

$DisclaimerWindow.ShowDialog() | Out-Null

if (-not $global:Accepted) {
    exit
}

# ------------------------------------------------------------------------------
# Main Window Loader
# ------------------------------------------------------------------------------

$MainReader = New-Object System.Xml.XmlNodeReader $MainXaml
$MainWindow = [Windows.Markup.XamlReader]::Load($MainReader)

$ToolContainer = $MainWindow.FindName("ToolContainer")
$StatusText    = $MainWindow.FindName("StatusText")

# ------------------------------------------------------------------------------
# Window Controls
# ------------------------------------------------------------------------------

$MainWindow.add_MouseLeftButtonDown({
    if ($_.ButtonState -eq "Pressed") {
        $MainWindow.DragMove()
    }
})

$MainWindow.FindName("CloseBtn").add_Click({
    $MainWindow.Close()
})

$MainWindow.FindName("MinBtn").add_Click({
    $MainWindow.WindowState = [Windows.WindowState]::Minimized
})

$MainWindow.FindName("OpenFolderBtn").add_Click({
    if (Test-Path $InstallDir) {
        Start-Process explorer.exe -ArgumentList "`"$InstallDir`""
    }
})

# ------------------------------------------------------------------------------
# Helpers
# ------------------------------------------------------------------------------

function Set-Status {
    param(
        [string]$Message
    )

    $StatusText.Text = $Message

    $MainWindow.Dispatcher.Invoke(
        [Action]{},
        [Windows.Threading.DispatcherPriority]::Render
    )
}

function Get-GitHubLatestAsset {
    param(
        [string]$ReleaseUrl
    )

    $RepoPath = $ReleaseUrl `
        -replace '^https://github\.com/', '' `
        -replace '/releases/latest/?$', ''

    $ApiUrl = "https://api.github.com/repos/$RepoPath/releases/latest"

    $Release = Invoke-RestMethod `
        -Uri $ApiUrl `
        -Headers @{
            "User-Agent" = "MikisLoveSSTool"
            "Accept"     = "application/vnd.github+json"
        } `
        -UseBasicParsing

    if (-not $Release.assets -or $Release.assets.Count -eq 0) {
        throw "No downloadable assets were found."
    }

    return $Release.assets[0]
}

function Download-GitHubTool {
    param(
        $Tool,
        [string]$Destination
    )

    Set-Status "> Fetching latest release: $($Tool.Name)..."

    $Asset = Get-GitHubLatestAsset $Tool.URL

    $FilePath = Join-Path $Destination $Asset.name

    Set-Status "> Downloading $($Asset.name)..."

    Invoke-WebRequest `
        -Uri $Asset.browser_download_url `
        -OutFile $FilePath `
        -UseBasicParsing

    return $FilePath
}

# ------------------------------------------------------------------------------
# Tool Runner
# ------------------------------------------------------------------------------

function Run-Tool {
    param(
        $Tool
    )

    try {

        Set-Status "> Processing $($Tool.Name)..."

        switch ($Tool.Type) {

            "Link" {

                Start-Process $Tool.URL

                Set-Status "> Opened $($Tool.Name)"

            }

            "Web" {

                # Direct web pages are opened rather than pretending they are
                # downloadable files.

                if ($Tool.URL -match '/releases/?$' -or
                    $Tool.URL -match '/downloads/?$' -or
                    $Tool.URL -match 'systeminformer\.com') {

                    Start-Process $Tool.URL

                    Set-Status "> Opened website for $($Tool.Name)"

                }
                else {

                    $FileName = Split-Path $Tool.URL -Leaf

                    if ([string]::IsNullOrWhiteSpace($FileName)) {
                        $FileName = "$($Tool.Name).download"
                    }

                    $Destination = Join-Path $InstallDir $FileName

                    Set-Status "> Downloading $FileName..."

                    Invoke-WebRequest `
                        -Uri $Tool.URL `
                        -OutFile $Destination `
                        -UseBasicParsing

                    Set-Status "> Downloaded $($Tool.Name)"
                }
            }

            "GitHub" {

                $ToolFolder = Join-Path $InstallDir $Tool.Name

                if (-not (Test-Path $ToolFolder)) {
                    New-Item `
                        -ItemType Directory `
                        -Force `
                        -Path $ToolFolder | Out-Null
                }

                $File = Download-GitHubTool `
                    -Tool $Tool `
                    -Destination $ToolFolder

                Set-Status "> Downloaded $($Tool.Name) → $File"

            }

            "Bundle" {

                $ToolFolder = Join-Path $InstallDir $Tool.Name

                if (-not (Test-Path $ToolFolder)) {
                    New-Item `
                        -ItemType Directory `
                        -Force `
                        -Path $ToolFolder | Out-Null
                }

                foreach ($Item in $Tool.Items) {

                    Set-Status "> Downloading $($Item.Name)..."

                    $Asset = Get-GitHubLatestAsset $Item.URL

                    $Destination = Join-Path $ToolFolder $Asset.name

                    Invoke-WebRequest `
                        -Uri $Asset.browser_download_url `
                        -OutFile $Destination `
                        -UseBasicParsing
                }

                Set-Status "> Successfully downloaded $($Tool.Name) bundle"

            }

            "Cmd" {

                Set-Status "> Launching $($Tool.Name)..."

                Start-Process `
                    powershell.exe `
                    -ArgumentList @(
                        "-NoProfile"
                        "-ExecutionPolicy"
                        "Bypass"
                        "-NoExit"
                        "-Command"
                        $Tool.Command
                    )

                Set-Status "> Launched $($Tool.Name)"

            }

            default {

                throw "Unknown tool type: $($Tool.Type)"

            }
        }

    }
    catch {

        Set-Status "> ERROR: $($Tool.Name) — $($_.Exception.Message)"

    }
}

# ------------------------------------------------------------------------------
# Tool Card
# ------------------------------------------------------------------------------

$CardTemplate = @'
<Border
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Background="#301A30"
    CornerRadius="12"
    Margin="0,0,16,16"
    Height="116"
    Width="260">

    <Border.Effect>

        <DropShadowEffect
            BlurRadius="10"
            ShadowDepth="0"
            Opacity="0.15"/>

    </Border.Effect>

    <Grid Margin="16">

        <Grid.RowDefinitions>

            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="Auto"/>

        </Grid.RowDefinitions>

        <TextBlock
            Text="{TITLE}"
            FontWeight="Bold"
            Foreground="#FFE8F3"
            FontSize="14"
            Grid.Row="0"/>

        <TextBlock
            Text="{DESC}"
            Foreground="#F5C9DE"
            FontSize="11"
            TextWrapping="Wrap"
            Grid.Row="1"
            Margin="0,4,0,0"/>

        <Button
            Name="ActionBtn"
            Content="{ACTION}"
            Height="27"
            FontSize="11"
            FontWeight="SemiBold"
            Grid.Row="2"
            Cursor="Hand"
            Foreground="White">

            <Button.Template>

                <ControlTemplate TargetType="Button">

                    <Border
                        x:Name="BtnBorder"
                        Background="#5C2B47"
                        CornerRadius="7">

                        <ContentPresenter
                            HorizontalAlignment="Center"
                            VerticalAlignment="Center"/>

                    </Border>

                    <ControlTemplate.Triggers>

                        <Trigger
                            Property="IsMouseOver"
                            Value="True">

                            <Setter
                                TargetName="BtnBorder"
                                Property="Background"
                                Value="#FF6FB5"/>

                        </Trigger>

                        <Trigger
                            Property="IsPressed"
                            Value="True">

                            <Setter
                                TargetName="BtnBorder"
                                Property="Background"
                                Value="#FF4FA0"/>

                        </Trigger>

                    </ControlTemplate.Triggers>

                </ControlTemplate>

            </Button.Template>

        </Button>

    </Grid>

</Border>
'@

# ------------------------------------------------------------------------------
# Card Rendering
# ------------------------------------------------------------------------------

function Render-Cards {
    param(
        [string]$GroupFilter
    )

    $ToolContainer.Children.Clear()

    foreach ($Tool in $Tools) {

        if (
            $GroupFilter -ne "All" -and
            $Tool.Group -ne $GroupFilter
        ) {
            continue
        }

        $ActionLabel = switch ($Tool.Type) {

            "Link"   { "Open Website" }
            "Cmd"    { "Run Tool" }
            "Web"    { "Download Tool" }
            "GitHub" { "Download Tool" }
            "Bundle" { "Download Bundle" }
            default  { "Open" }

        }

        $SafeTitle = $Tool.Name `
            -replace '&', '&amp;' `
            -replace '<', '&lt;' `
            -replace '>', '&gt;'

        $SafeDesc = $Tool.Desc `
            -replace '&', '&amp;' `
            -replace '<', '&lt;' `
            -replace '>', '&gt;'

        $CardString = $CardTemplate `
            .Replace("{TITLE}", $SafeTitle) `
            .Replace("{DESC}", $SafeDesc) `
            .Replace("{ACTION}", $ActionLabel)

        $CardUI = [Windows.Markup.XamlReader]::Parse($CardString)

        $ActionBtn = $CardUI.FindName("ActionBtn")

        $ClosureTool = $Tool

        $ActionBtn.add_Click({
            Run-Tool -Tool $ClosureTool
        })

        $ToolContainer.Children.Add($CardUI) | Out-Null
    }

    Set-Status "> Showing $GroupFilter tools..."
}

# ------------------------------------------------------------------------------
# Categories
# ------------------------------------------------------------------------------

$MainWindow.FindName("CatAllBtn").add_Click({
    Render-Cards "All"
})

$MainWindow.FindName("CatXmikipBtn").add_Click({
    Render-Cards "xmikip"
})

$MainWindow.FindName("CatOthersBtn").add_Click({
    Render-Cards "Others"
})

$MainWindow.FindName("CatDepsBtn").add_Click({
    Render-Cards "Dependencies"
})

# ------------------------------------------------------------------------------
# Start
# ------------------------------------------------------------------------------

Render-Cards "All"

$MainWindow.ShowDialog() | Out-Null