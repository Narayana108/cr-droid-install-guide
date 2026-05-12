# 1 - Data Backup & ROM Recovery

## 1. Install tools
  `sudo apt update && sudo apt install adb fastboot -y`

### Good to know
POCO F5 (Marble) has two slots, Slot A and Slot B, these work like partitions. User Data is separated from the OS, Kernel and Firmware Data as it is stored on a separate Slot.

- Check for multiple slots:
  `fastboot getvar current-slot`

```
  fastboot getvar current-slot
  # Output:
  # current-slot: b
```

_Only A/B devices report `current-slot`, this shows the phone has 2 slots_
_This is only for educational purpose, it wont be used later._

## 2. Verify device

Your mobile should be:
- Switched on.
- Screen is unlocked.
- USB debugging allowed.

Now start the process:
- Verify device from your CLI on your computer:
  `adb devices`

## ROM Roll Back & Recovery
- My ROM roll back technique is to simply keep the current ROM version with its corresponding kernel and firmware versions stored on my computer.
- If anything go's wrong with the new update or installation, I just flash the backup ROM, etc from my computer.

## User Data Backup
1. Use [Neo-Backup](https://github.com/NeoApplications/Neo-Backup) to backup all of your apps. (requires root)
  Backup all your apps to `/sdcard/Neobackup`
2. Manually backup your contacts, 2FA, bookmarks, pipepipe, organic maps, etc to `/sdcard/Backups/`
3. Use the `backup.sh` script to do a full phone backup.

_Files in `/sdcard/` = `/` within the phone (root directly / highest level directly)._

### Examples 
#### How to pull data from phone to PC
```bash
adb pull /sdcard/DCIM/         ~/Phone/backups/media/DCIM/
adb pull /sdcard/Android/media/com.whatsapp/WhatsApp/Media/ ~/Phone/backups/Whatsapp-bkp/
```

#### How to push data from PC to phone
```bash
adb push ~/Phone/backups/media/DCIM/         /sdcard/
adb push ~/Phone/backups/media/Download/      /sdcard/
```

#### Save App List
```bash
adb shell "pm list packages -3" | awk -F: '{gsub(/\r$/,"",$2); print $2}' | sort > ~/Phone/backups/apps/installed_apps.txt
```

#### Verify
```bash
wc -l ~/Phone/backups/apps/installed_apps.txt    # → 86 (or your count)
head -n5 ~/Phone/backups/apps/installed_apps.txt
```

## Extra - OrangeFox Recovery ROM Backup
### I don't use OrangeFox Recovery backups as a primary means
As I don't understand exactly how it works.
But heres some info regarding it:

- User data (media, contacts, etc) cannot be backup'd from OrangeFox Recovery for POCO F5, as it requires an external storage (e.g SD card).

### Backup tips
Encrypted backups work with only with the same ROM and Major version.

This is crucial for understanding ROM installs and updates as well.
Extracts from the [Official OrangeFox backup guide](https://wiki.orangefox.tech/en/guides/backups):

* Creating backups of encrypted data is fraught with risks. If you want to backup the data partition of an encrypted device, _you would be very well advised to first delete the lockscreen password/pin in the ROM before booting to recovery to create the backup_. If you do not do this, you might have issues when trying to restore the data backup. ( - I am not sure how applicable this is, as mentioned above it should work, the ROM's encryption method and version should just match the backup's encryption format ). Always take a backup of your user data (to an external storage device or the cloud) every time you want to flash something (anything - ROMs, recovery, kernels, mods, OTA updates, or whatever else). `Ignore this advice at your own peril`.
* Do not try to restore a backed-up data partition from one ROM to another ROM. * Do not try to restore a backup of an encrypted device to a device that is not encrypted, or to a device that is encrypted with a different encryption protocol (eg, by a different ROM).
* Do not try to restore a backup of one ROM on top of another ROM. First flash the ROM zip of the ROM whose backup you want to restore (the _precise version_ that was backed up) before restoring its backup.
* Do not try to restore a backup of a partition that currently contains data which you want to retain. Restoring a backup of a partition necessarily involves automatic wiping of its current contents, and replacing them with the contents of the backup. So anything already there before restoring the backup will be _irretrievably_ lost.
* With Android 12 and higher there can be potential fscrypt policy problems that can make the system unbootable after restoring a data backup. Make sure that the ROM you are restoring the backup to is _exactly_ the same as the one that you took the backup from.

---
➡️ Next Guide: [2 - Install OrangeFox Recovery](https://github.com/Narayana108/cr-droid-install-guide/blob/main/2-flash-orangefox-recovery.md)
