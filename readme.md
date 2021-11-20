# Winamp Modern++

This is a fork of the classic Winamp Modern that aims to update the base skin on a number of small things, such as weird visual blemishes, updating code where needed, etc.

There are no plans yet to make further modifications to the skin, as the current goal is to keep the original spirit of the skin alive as much as possible, whilst making the smallest of updates that keeps it tidy and modern.

## Compiling the maki scripts

Before compiling the maki scripts, they assume that you invoke the compiler directly in the scripts folder (hence ``#include "..\..\..\lib/std.mi"``) and that you have your WACUP install (where the "lib" folder resides) in your path environment, if that's not the case then it won't work.

## Testing the WACUP specific changes

If you want to test these changes, it's best to replace all the files of your Winamp Modern folder with these, as the skin references files from that folder, and running the WACUPchanges.zip by itself won't show the improvements done to the skin properly.

![Screenshot](https://raw.githubusercontent.com/0x5066/WinampModernForked/main/screenshot.png)

This makes use of version detection (only on the master branch), where it'll run a version check on skin load and disable a few features and changes the titles of most skinned windows, if Winamp 5.8 was detected.
The checks reside in:

``display.m @ line 33``

``titlebar.m @ line 34``

``visualizer.m @ line 58``

These can be safely removed and won't cause other hidden issues.