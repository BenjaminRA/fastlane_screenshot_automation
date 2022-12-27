function KillDevices {
  adb kill-server

  Get-Process | Where-Object { $_.Name -match "emulator|qemu" } | ForEach-Object { 
    taskkill /F /PID $_.Id
  }

  adb start-server
  (adb devices | Select-String -Pattern "emulator-\d*" -AllMatches).Matches | ForEach-Object {
    if ($_.Groups.Length -gt 0) {
      $emulator = ($_.Groups[0].Value)
      Write-Output "Killing $emulator"
      adb -s $emulator emu kill
    }
  }
}

function RunTestWithDevice {
  param (
    [Parameter(Mandatory = $true, Position = 0)] [string]$device,
    [Parameter(Mandatory = $true, Position = 1)] [string]$folder
  )

  Write-Output "Killing Devices"
  KillDevices

  Write-Output "Booting device $device"
  Start-Job -ScriptBlock { emulator -avd "$input" -no-audio -no-boot-anim -no-window -accel on -gpu off } -InputObject $device

  Write-Output "Waiting for device $device to boot"
  adb wait-for-device shell getprop sys.boot_completed

  $env:SCREENSHOT_PATH = "./android/fastlane/metadata/android/es-419/images/$folder"
  $env:PLATFORM = 'android'

  Write-Output "Running test on device $device"
  fvm flutter drive --driver=test_driver/screenshot_integration_test_driver.dart --target=integration_test/screenshot_test.dart

  Remove-Item Env:\SCREENSHOT_PATH
  Remove-Item Env:\PLATFORM
}

# # Check if we are in the android folder
# $path = (Get-Location).Path.Split("\")
# if ($path[$path.Length - 1] -ne 'android') {
#   Write-Error "You must run the script inside the android directory"
#   exit 1
# }


RunTestWithDevice "phone" "phoneScreenshots"
RunTestWithDevice "tablet_7_inch" "sevenInchScreenshots"
RunTestWithDevice "tablet_10_inch" "tenInchScreenshots"
KillDevices
