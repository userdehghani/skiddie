@echo off
setlocal enabledelayedexpansion

:: Check if the script has two arguments (IP and PORT)
if "%~3"=="" (
    cls
    echo Usage: %0 [KMS SERVER IP] [KMS SERVER PORT] [SERVICE 'windows or office']
    exit /b 1
)

:::  _  ____  ___ ___
::: | |/ /  \/  / ___| 
::: | ' /| |\/| \___ \ 
::: | . \| |  | |___) |
::: |_|\_\_|  |_|____/ 
                                                        
for /f "delims=: tokens=*" %%A in ('findstr /b ::: "%~f0"') do @echo(%%A
echo:
echo:

:route                                                           

:: Set IP and PORT and SERVICE based on provided arguments
set "IP=%~1"
set "PORT=%~2"
set "SERVICE=%~3"

:: REM Validate IP address
for /f "tokens=1-4 delims=." %%a in ("%IP%") do (
    if "%%a" geq 0 if "%%a" leq 255 ^
    if "%%b" geq 0 if "%%b" leq 255 ^
    if "%%c" geq 0 if "%%c" leq 255 ^
    if "%%d" geq 0 if "%%d" leq 255 (
        set vIP="true"
    )
)

:: Validate PORT number
echo %PORT%|findstr /r "^[0-9][0-9]*$" >nul
if %errorlevel% equ 0 (
    set vPORT="true"
)

if "%vIP%"=="" (
    echo "%IP% It's Not Valid IP!"
    exit /b 1
)

if "%vPORT%"=="" (
    echo "%PORT% It's Not Valid PORT!"
    exit /b 1
)

NET FILE 1>NUL 2>NUL
if "%errorlevel%" == "0" (
    :: Script is already running as administrator
    echo Running with administrator privileges

    if "%SERVICE%" == "windows" (
        goto :windows
    ) else if "%SERVICE%" == "office" (
        goto :office
    ) else (
        echo Enter Valid Server [windows, office]
        exit /b 1
    )
) else (
    :: Relaunch the script with administrator privileges
    echo Requesting administrator privileges...
    powershell -Command "Start-Process -Verb RunAs cmd -ArgumentList '/K cd /d %CD% && call %0 %*'"
    exit /b
)


:office

cd "C:\Program Files\Microsoft Office\Office16"
cscript //nologo ospp.vbs /sethst:%IP%
cscript //nologo ospp.vbs /act

pause
exit

:windows

:: Define GVLK keys for different Windows versions

:: Windows 11
set "Windows11Pro=W269N-WFGWX-YVC9B-4J6C9-T83GX"
set "Windows11ProN=MH37W-N47XK-V7XM9-C7227-GCQG9"
set "Windows11ProWorkstations=NRG8B-VKK3Q-CXVCJ-9G2XF-6Q84J"
set "Windows11ProWorkstationsN=9FNHH-K3HBT-3W4TD-6383H-6XYWF"
set "Windows11ProEducation=6TP4R-GNPTD-KYYHQ-7B7DP-J447Y"
set "Windows11ProEducationN=YVWGF-BXNMC-HTQYQ-CPQ99-66QFC"
set "Windows11Education=NW6C2-QMPVW-D7KKK-3GKT6-VCFB2"
set "Windows11EducationN=2WH4N-8QGBV-H22JP-CT43Q-MDWWJ"
set "Windows11Enterprise=NPPR9-FWDCX-D2C8J-H872K-2YT43"
set "Windows11EnterpriseN=DPH2V-TTNVB-4X9Q3-TJR4H-KHJW4"
set "Windows11EnterpriseG=YYVX9-NTFWV-6MDM3-9PT4T-4M68B"
set "Windows11EnterpriseGN=44RPN-FTY23-9VTTB-MP9BX-T84FV"

:: Windows 10
set "Windows10Core=TX9XD-98N7V-6WMQ6-BX7FG-H8Q99"
set "Windows10CoreN=3KHY7-WNT83-DGQKR-F7HPR-844BM"
set "Windows10CoreCountry=PVMJN-6DFY6-9CCP6-7BKTT-D3WVR"
set "Windows10CoreSingle=7HNRX-D7KGG-3K4RQ-4WPJ4-YTDFH"
set "Windows10Pro=W269N-WFGWX-YVC9B-4J6C9-T83GX"
set "Windows10ProN=MH37W-N47XK-V7XM9-C7227-GCQG9"
set "Windows10Enterprise=NPPR9-FWDCX-D2C8J-H872K-2YT43"
set "Windows10EnterpriseN=DPH2V-TTNVB-4X9Q3-TJR4H-KHJW4"
set "Windows10Education=NW6C2-QMPVW-D7KKK-3GKT6-VCFB2"
set "Windows10EducationN=2WH4N-8QGBV-H22JP-CT43Q-MDWWJ"
set "Windows10Enterprise2015LTSB=WNMTR-4C88C-JK8YV-HQ7T2-76DF9"
set "Windows10Enterprise2015LTSBN=2F77B-TNFGY-69QQF-B8YKP-D69TJ"
set "Windows10Enterprise2016LTSB=DCPHK-NFMTC-H88MJ-PFHPY-QJ4BJ"
set "Windows10Enterprise2016LTSBN=QFFDN-GRT3P-VKWWX-X7T3R-8B639"

set "Windows10EnterpriseLTSC=M7XTQ-FN8P6-TTKYV-9D4CC-J462D"
set "Windows10EnterpriseLTSCN=92NFX-8DJQP-P6BBQ-THF9C-7CG2H"

:: Windows 8 / 8.1
set "Windows8Pro=NG4HW-VH26C-733KW-K6F98-J8CK4"
set "Windows8ProN=XCVCF-2NXM9-723PB-MHCB7-2RYQQ"
set "Windows8Enterprise=32JNW-9KQ84-P47T8-D8GGY-CWCK7"
set "Windows8EnterpriseN=JMNMF-RHW7P-DMY6X-RF3DR-X2BQT"
set "Windows81Pro=GCRJD-8NW9H-F2CDX-CCM8D-9D6T9"
set "Windows81ProN=HMCNV-VVBFX-7HMBH-CTY9B-B4FXY"
set "Windows81Enterprise=MHF9N-XY6XB-WVXMC-BTDCT-MKKG7"
set "Windows81EnterpriseN=TT4HM-HN7YT-62K67-RGRQJ-JFFXW"

:: Windows 7
set "Windows7Pro=FJ82H-XT6CR-J8D7P-XQJJ2-GPDD4"
set "Windows7ProN=MRPKT-YTG23-K7D7T-X2JMM-QY7MG"
set "Windows7ProE=W82YF-2Q76Y-63HXB-FGJG9-GF7QX"
set "Windows7Enterprise=33PXH-7Y6KF-2VJC9-XBBR8-HVTHH"
set "Windows7EnterpriseN=YDRBP-3D83W-TY26F-D46B2-XCKRJ"
set "Windows7EnterpriseE=C29WB-22CC8-VJ326-GHFJW-H9DH4"

:: Windows Server 2022
set "WindowsServer2022Datacenter=WX4NM-KYWYW-QJJR4-XV3QB-6VM33"
set "WindowsServer2022Standard=VDYBN-27WPP-V4HQT-9VMD4-VMK7H"

:: Windows Server 2019
set "WindowsServer2019Datacenter=WMDGN-G9PQG-XVVXX-R3X43-63DFG"
set "WindowsServer2019Standard=N69G4-B89J2-4G8F4-WWYCC-J464C"
set "WindowsServer2019Essentials=WVDHN-86M7X-466P6-VHXV7-YY726"

:: Windows Server 2016
set "WindowsServer2016Datacenter=CB7KF-BWN84-R7R2Y-793K2-8XDDG"
set "WindowsServer2016Standard=WC2BQ-8NRM3-FDDYY-2BFGV-KHKQY"
set "WindowsServer2016Essentials=JCKRF-N37P4-C2D82-9YXRT-4M63B"

:: Windows Server 2012
set "WindowsServer2012=BN3D2-R7TKB-3YPBD-8DRP2-27GG4"
set "WindowsServer2012N=8N2M2-HWPGY-7PGT9-HGDD8-GVGGY"
set "WindowsServer2012SingleLanguage=2WN2H-YGCQR-KFX6K-CD6TF-84YXQ"
set "WindowsServer2012CountrySpecific=4K36P-JN4VD-GDC6V-KDT89-DYFKP"
set "WindowsServer2012Standard=XC9B7-NBPP2-83J2H-RHMBY-92BT4"
set "WindowsServer2012MultiPointStandard=HM7DN-YVMH3-46JC3-XYTG7-CYQJJ"
set "WindowsServer2012MultiPointPremium=XNH6W-2V9GX-RGJ4K-Y8X6F-QGJ2G"
set "WindowsServer2012Datacenter=48HP8-DN98B-MYWDG-T2DCC-8W83P"
set "WindowsServer2012R2Standard=D2N9P-3P6X9-2R39C-7RTCD-MDVJX"
set "WindowsServer2012R2Datacenter=W3GGN-FT8W3-Y4M27-J84CP-Q3VJ9"
set "WindowsServer2012R2Essentials=KNC87-3J2TX-XB4WP-VCPJV-M4FWM"

:: Windows Server 2008
set "WindowsServer2008Web=WYR28-R7TFJ-3X2YQ-YCY4H-M249D"
set "WindowsServer2008Standard=TM24T-X9RMF-VWXK6-X8JC9-BFGM2"
set "WindowsServer2008StandardNoHyperV=W7VD6-7JFBR-RX26B-YKQ3Y-6FFFJ"
set "WindowsServer2008Enterprise=YQGMW-MPWTJ-34KDK-48M3W-X4Q6V"
set "WindowsServer2008EnterpriseNoHyperV=39BXF-X8Q23-P2WWT-38T2F-G3FPG"
set "WindowsServer2008HPC=RCTX3-KWVHP-BR6TB-RB6DM-6X7HP"
set "WindowsServer2008Datacenter=7M67G-PC374-GR742-YH8V4-TCBY3"
set "WindowsServer2008DatacenterNoHyperV=22XQ2-VRXRG-P8D42-K34TD-G3QQC"
set "WindowsServer2008Itanium=4DWFP-JF3DJ-B7DTH-78FJB-PDRHK"
set "WindowsServer2008R2Web=6TPJF-RBVHG-WBW2R-86QPH-6RTM4"
set "WindowsServer2008R2HPCEdition=TT8MH-CG224-D3D7Q-498W2-9QCTX"
set "WindowsServer2008R2Standard=YC6KT-GKW9T-YTKYR-T4X34-R7VHC"
set "WindowsServer2008R2Enterprise=489J6-VHDMP-X63PK-3K798-CPX3Y"
set "WindowsServer2008R2Datacenter=74YFP-3QFB3-KQT8W-PMXWJ-7M648"
set "WindowsServer2008R2Itanium=GT63C-RJFQ3-4GMB6-BRFB9-CB83V"

:: Get the OS name using the systeminfo command
for /f "tokens=*" %%a in ('systeminfo ^| find "OS Name"') do (
    set osName=%%a
)

:: Find the matched GVLK based on osName

:: Windows 11
if "!osName!"=="OS Name:                   Microsoft Windows 11 Professional" (
    set "GVLK=!Windows11Pro!"
) else if "!osName!"=="OS Name:                   Microsoft Windows 11 Professional N" (
    set "GVLK=!Windows11ProN!"
) else if "!osName!"=="OS Name:                   Microsoft Windows 11 Pro For Workstations" (
    set "GVLK=!Windows11ProWorkstations!"
) else if "!osName!"=="OS Name:                   Microsoft Windows 11 Pro For Workstations N" (
    set "GVLK=!Windows11ProWorkstationsN!"
) else if "!osName!"=="OS Name:                   Microsoft Windows 11 Pro Education" (
    set "GVLK=!Windows11ProEducation!"
) else if "!osName!"=="OS Name:                   Microsoft Windows 11 Pro Education N" (
    set "GVLK=!Windows11ProEducationN!"
) else if "!osName!"=="OS Name:                   Microsoft Windows 11 Education" (
    set "GVLK=!Windows11Education!"
) else if "!osName!"=="OS Name:                   Microsoft Windows 11 Education N" (
    set "GVLK=!Windows11EducationN!"
) else if "!osName!"=="OS Name:                   Microsoft Windows 11 Enterprise" (
    set "GVLK=!Windows11Enterprise!"
) else if "!osName!"=="OS Name:                   Microsoft Windows 11 Enterprise N" (
    set "GVLK=!Windows11EnterpriseN!"
) else if "!osName!"=="OS Name:                   Microsoft Windows 11 Enterprise G" (
    set "GVLK=!Windows11EnterpriseG!"
) else if "!osName!"=="OS Name:                   Microsoft Windows 11 Enterprise G N" (
    set "GVLK=!Windows11EnterpriseGN!"
)

:: Windows 10
if "!osName!"=="OS Name:                   Microsoft Windows 10 Core" (
    set "GVLK=!Windows10Core!"
) else if "!osName!"=="OS Name:                   Microsoft Windows 10 Core N" (
    set "GVLK=!Windows10CoreN!"
) else if "!osName!"=="OS Name:                   Microsoft Windows 10 Core Country Specific" (
    set "GVLK=!Windows10CoreCountry!"
) else if "!osName!"=="OS Name:                   Microsoft Windows 10 Core Single Language" (
    set "GVLK=!Windows10CoreSingle!"
) else if "!osName!"=="OS Name:                   Microsoft Windows 10 Pro" (
    set "GVLK=!Windows10Pro!"
) else if "!osName!"=="OS Name:                   Microsoft Windows 10 Pro N" (
    set "GVLK=!Windows10proN!"
) else if "!osName!"=="OS Name:                   Microsoft Windows 10 Enterprise" (
    set "GVLK=!Windows10Enterprise!"
) else if "!osName!"=="OS Name:                   Microsoft Windows 10 Enterprise N" (
    set "GVLK=!Windows10EnterpriseN!"
) else if "!osName!"=="OS Name:                   Microsoft Windows 10 Education" (
    set "GVLK=!Windows10Education!"
) else if "!osName!"=="OS Name:                   Microsoft Windows 10 Education N" (
    set "GVLK=!Windows10EducationN!"
) else if "!osName!"=="OS Name:                   Microsoft Windows 10 Enterprise 2015 LTSB" (
    set "GVLK=!Windows10Enterprise2015LTSB!"
) else if "!osName!"=="OS Name:                   Microsoft Windows 10 Enterprise 2015 LTSB N" (
    set "GVLK=!Windows10Enterprise2015LTSBN!"
) else if "!osName!"=="OS Name:                   Microsoft Windows 10 Enterprise 2016 LTSB" (
    set "GVLK=!Windows10Enterprise2016LTSB!"
) else if "!osName!"=="OS Name:                   Microsoft Windows 10 Enterprise 2016 LTSB N" (
    set "GVLK=!Windows10Enterprise2016LTSBN!"
) else if "!osName!"=="OS Name:                   Microsoft Windows 10 Enterprise LTSC" (
    set "GVLK=!Windows10EnterpriseLTSC!"
) else if "!osName!"=="OS Name:                   Microsoft Windows 10 Enterprise LTSC N" (
    set "GVLK=!Windows10EnterpriseLTSCN!"
)

:: Windows 8
if "!osName!"=="OS Name:                   Microsoft Windows 8 Pro" (
    set "GVLK=!Windows8Pro!"
) else if "!osName!"=="OS Name:                   Microsoft Windows 8 Pro N" (
    set "GVLK=!Windows8ProN!"
) else if "!osName!"=="OS Name:                   Microsoft Windows 8 Enterprise" (
    set "GVLK=!Windows8Enterprise!"
) else if "!osName!"=="OS Name:                   Microsoft Windows 8 Enterprise N" (
    set "GVLK=!Windows8EnterpriseN!"
) else if "!osName!"=="OS Name:                   Microsoft Windows 8.1 Pro" (
    set "GVLK=!Windows81Pro!"
) else if "!osName!"=="OS Name:                   Microsoft Windows 8.1 Pro N" (
    set "GVLK=!Windows81ProN!"
) else if "!osName!"=="OS Name:                   Microsoft Windows 8.1 Enterprise" (
    set "GVLK=!windows81Enterprise!"
) else if "!osName!"=="OS Name:                   Microsoft Windows 8.1 Enterprise N" (
    set "GVLK=!Windows81EnterpriseN!"
) 

:: Windows 7
if "!osName!"=="OS Name:                   Microsoft Windows 7 Professional" (
    set "GVLK=!Windows7Pro!"
) else if "!osName!"=="OS Name:                   Microsoft Windows 7 Professional N" (
    set "GVLK=!Windows7ProN!"
) else if "!osName!"=="OS Name:                   Microsoft Windows 7 Professional E" (
    set "GVLK=!Windows7ProE!"
) else if "!osName!"=="OS Name:                   Microsoft Windows 7 Enterprise" (
    set "GVLK=!Windows7Enterprise!"
) else if "!osName!"=="OS Name:                   Microsoft Windows 7 Enterprise N" (
    set "GVLK=!Windows7EnterpriseN!"
) else if "!osName!"=="OS Name:                   Microsoft Windows 7 Enterprise E" (
    set "GVLK=!Windows7EnterpriseE!"
)

if "%GVLK%"=="" (
    set "GVLK=Unknown"
    echo Unknown OS
    exit /b 1
)

:: Display the results
echo Detected %osName%
echo IP: %IP%
echo PORT: %PORT%
echo GVLK Key: %GVLK%


:: cscript //nologo c:\windows\system32\slmgr.vbs /xpr >> %TEMP\kms.txt

for /f "tokens=3 delims=: " %%a in (
    'cscript //nologo "%systemroot%\system32\slmgr.vbs" /dli ^| find "License Status:"' 
) do set "licenseStatus=%%a"

if /i "%licenseStatus%"=="Licensed" (
    cscript //nologo c:\windows\system32\slmgr.vbs /skms %IP%:%PORT%
    cscript //nologo c:\windows\system32\slmgr.vbs /ato
) else (
    cscript //nologo c:\windows\system32\slmgr.vbs /ipk %GVLK%
    cscript //nologo c:\windows\system32\slmgr.vbs /skms %IP%:%PORT%
    cscript //nologo c:\windows\system32\slmgr.vbs /ato
)

pause
exit

endlocal
