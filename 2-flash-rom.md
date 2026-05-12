# 2 - Flash ROM - CRDroid 12
## Installing a brand new Rom or upgrading an existing one

## Prerequisites
- [1 - Data Backup & ROM Recovery](https://github.com/Narayana108/cr-droid-install-guide/blob/main/1-data-backup-and-rom-recovery.md) Guide completed.

## Prerequisites
    - Phone model: POCO F5 Marble (India)
    - ROM: CR-Droid (Install or upgrade)
    - PC OS: Debian / Ubuntu
    - Phone:
      - Boot loader unlocked
      - Developer mode enabled
      - USB debugging enabled


⚠️ Before you start, make sure you’ve **deleted every Google account** from the device on a fresh install. This will prevent “Factory Reset Protection” (FRP) from kicking in during the setup steps.

⚠️ If you are installing a different ROM or upgrading a major version of the same ROM, you may need to wipe(format) your entire phone_
  - Example upgrading from CRDroid 11 to 12 is a major version upgrade and requires a full wipe. Upgrading from CRDroid 12.2 to 12.9 is a minor version upgrade and all data can be kept via upgrade, however things may not work so always backup !

⚠️ Many banking apps may not work on a custom rom, as it does certain security checks such as: Is phone unlocked, is phone rooted, etc. But these security verifications can be bypassed and you can get any app to work, follow: [4 - Get apps working](https://github.com/Narayana108/cr-droid-install-guide/blob/main/4-get-apps-working.md)

## 1. Download the required files
With correct versions for the specific device, as per the [cr-droids official site](https://crdroid.net/marble/12) or telegram groups instructions.

My directory structure is as follows with the required downloaded files:

```
…/Phone/cr-droid-12.9-2026-04-15 ❯ tree
.
├── 1.recovory
│   └── OFRP-R11.1_7_RECOVERY-Beta-marble.img
├── 2.firmware
│   └── fw_marble_marble_in_global-ota_full-OS3.0.1.0.VMRINXM-user-15.0-ad38ef40ea.zip
├── 3.kernal
│   └── LosKsuNxt_06_May_V3.2.0.zip
├── 4.rom
│   └── crDroidAndroid-16.0-20260415-marble-v12.9.zip
└── NikGapps-crdroid-official-arm64-16-20260223-signed.zip

5 directories, 5 files
```

## 2. Install tools
  `sudo apt update && sudo apt install adb fastboot -y`

## 3. Boot to fastboot

Your mobile should be:
- Switched on.
- Screen is unlocked.
- USB debugging allowed.

- Verify device from your CLI on your computer:
  `adb devices`

- Reboot to fastboot:
  `adb reboot bootloader`

_You should see OrangeFox recovery on your mobile phone now_

- Verify connection 
  `fastboot devices`

## 4. Flash OrangeFox Recovery

## What is OrangeFox Recovery?

- It is an isolated mini ROM that lives in its own partition and it can be booted into via Recovery Mode.
- If the custom ROM gets corrupt (i.e from installs, upgrades, etc), you have a method to Recover your ROM.
- It is used for: backups, recovery and flashing ROM's, kernels and firmware.
- It can also: remove installed apps, kernelsu modules, boot into various states, check active slot and other things.

You should now be booted into fastboot.
- Now flash the OrangeFox unto your phone.
 `fastboot flash recovery OFRP-R11.1_7_RECOVERY-Beta-marble.img`

## 3. Reboot into Recovery
  `fastboot reboot recovery`

Manually access Recover (bootloader) when phone is off:
- Press and hold: `power + volume up` to access Recovery Mode.

## 4. Flash Firmware, Kernel and Rom

If installing a different ROM or doing a major version upgrade please wipe the entire phone and then continue with the steps below.

If doing a minor version upgrade, only clearing the cache is required.

4.1 Allow ADB & Sideload

- In OrangeFox recovery(On the phone), Select: `Menu` -> `ADB & Sideload`
- Tick: `Wipe Dalvik Cache`, `Wipe Cache` and `Reflash OrangeFox after flashing a ROM`
- `Wipe to Start Sideload`
If you see:
_Starting Sideload_ a terminal and within the terminal _Starting ADB sideload feature..._
You can go ahead with the next step.

### Method 1: Sideload
Initially I used the CLI when I first installed CR Droid.

4.2 Flash firmware
```bash
adb sideload fw_marble_marble_in_global-ota_full-OS3.0.1.0.VMRINXM-user-15.0-ad38ef40ea.zip
```

4.3 Flash kernel
(Repeat step 4.1)
```bash
adb sideload LosKsuNxt_06_May_V3.2.0.zip
```

4.4 Flash rom
(Repeat step 4.1)
```bash
adb sideload crDroidAndroid-16.0-20260415-marble-v12.9.zip
```

4.5 Flash NikGapps
(Repeat step 4.1)
```bash
adb sideload NikGapps-crdroid-official-arm64-16-20260223-signed.zip
```

### Method 2: Push and OrangeFox Recovery

1. Copy the files to your phone
```bash
adb push 2.firmware /sdcard/rom/
adb push 3.kernel /sdcard/rom/
adb push 4.rom /sdcard/rom/
adb push NikGapps-crdroid-official-arm64-16-20260223-signed.zip /sdcard/rom/
```

2. Use the OrangeFox from the phone for flashing

2.1 Flash the Firmware
- In Files (First tab) navigate to '2.firmware'.
- Select the zip file.
- Make sure 'Reflash OrangeFox after flashing a ROM' is ticked
- Swipe to install
- Wipe Dalvik/Art Cache,cache, FRP, metadata
- Make sure no errors occurred, if not move on to the next step.

2.2 Flash the Kernel
- In Files (First tab) navigate to '3.kernel'
- Select the zip file
- Make sure 'Reflash OrangeFox after flashing a ROM' is ticked
- Swipe to install
- Make sure no errors occured, if not move on to the next step.

3.3 Flash the ROM
- In Files (First tab) navigate to '4.rom'
- Select the zip file
- Make sure 'Reflash OrangeFox after flashing a ROM' is ticked
- Swipe to install
- Make sure no errors occurred,
- Reboot to system  ! And you should be now booted into the newly installed CRDroid version !

3.4 Flash NickGapps (Optional: Need for Playstore and Play Services)

- Reboot to recovery
- Flash the Nikgapps
- Wipe Dalvik/ArtCache and Cache
- Make sure no errors occurred,
- Reboot to system !

✅ Done !
Reboot your phone and start using CR-Droid !


---
If you have backups, follow thes next guide.
➡️ [3 - Restore backups](https://github.com/Narayana108/cr-droid-install-guide/blob/main/3-restore-backups.md)

Or

➡️ [4 - Get apps working](https://github.com/Narayana108/cr-droid-install-guide/blob/main/4-get-apps-working.md)
