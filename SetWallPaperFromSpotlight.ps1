# 将复制出来的缓存图片保存在下面的文件夹
add-type -AssemblyName System.Drawing
New-Item "$($env:USERPROFILE)\Pictures\Spotlight" -ItemType directory -Force;
New-Item "$($env:USERPROFILE)\Pictures\Spotlight\CopyAssets" -ItemType directory -Force;
New-Item "$($env:USERPROFILE)\Pictures\Spotlight\Horizontal" -ItemType directory -Force;
New-Item "$($env:USERPROFILE)\Pictures\Spotlight\Vertical" -ItemType directory -Force;
 
# 将横竖图片分别复制到对应的两个文件夹
foreach($file in (Get-Item "$($env:LOCALAPPDATA)\Packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\Assets\*"))
{
    if ((Get-Item $file).length -lt 100kb) { continue }
    Copy-Item $file.FullName "$($env:USERPROFILE)\Pictures\Spotlight\CopyAssets\$($file.Name).jpg";
}
 
foreach($newfile in (Get-Item "$($env:USERPROFILE)\Pictures\Spotlight\CopyAssets\*"))
{
    $image = New-Object -comObject WIA.ImageFile;
    $image.LoadFile($newfile.FullName);
    if($image.Width.ToString() -eq "1920"){ Move-Item $newfile.FullName "$($env:USERPROFILE)\Pictures\Spotlight\Horizontal" -Force; }
    elseif($image.Width.ToString() -eq "1080"){ Move-Item $newfile.FullName "$($env:USERPROFILE)\Pictures\Spotlight\Vertical" -Force; }
}
 
# 壁纸设置函数
function Set-Wallpaper
{
    param(
        [Parameter(Mandatory=$true)]
        $Path,
 
        [ValidateSet('Center', 'Stretch')]
        $Style = 'Center'
    )
 
    Add-Type @"
using System;
using System.Runtime.InteropServices;
using Microsoft.Win32;
namespace Wallpaper
{
public enum Style : int
{
Center, Stretch
}
public class Setter {
public const int SetDesktopWallpaper = 20;
public const int UpdateIniFile = 0x01;
public const int SendWinIniChange = 0x02;
[DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
private static extern int SystemParametersInfo (int uAction, int uParam, string lpvParam, int fuWinIni);
public static void SetWallpaper ( string path, Wallpaper.Style style ) {
SystemParametersInfo( SetDesktopWallpaper, 0, path, UpdateIniFile | SendWinIniChange );
RegistryKey key = Registry.CurrentUser.OpenSubKey("Control Panel\\Desktop", true);
switch( style )
{
case Style.Stretch :
key.SetValue(@"WallpaperStyle", "2") ;
key.SetValue(@"TileWallpaper", "0") ;
break;
case Style.Center :
key.SetValue(@"WallpaperStyle", "1") ;
key.SetValue(@"TileWallpaper", "0") ;
break;
}
key.Close();
}
}
}
"@
 
    [Wallpaper.Setter]::SetWallpaper( $Path, $Style )
}
 
 
$filePath = "$($env:USERPROFILE)\Pictures\Spotlight\Horizontal\*"
$file = Get-Item -Path $filePath | Sort-Object -Property LastWriteTime -Descending | Select-Object -First 1
Set-Wallpaper -Path $file.FullName  
# echo $file.FullName
 
Remove-Item "$($env:USERPROFILE)\Pictures\Spotlight\CopyAssets\*";
#pause