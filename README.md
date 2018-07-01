# Munge Files
Simple script to create a reversible way to obfuscate file names.

## Usage:

```bash
$ mungefiles.sh $parent/$target > ./mungescript.txt
$ echo This creates the obfuscation
$ grep ^C: ./mungescript.txt | cut -d: -f 2- | sh
$ echo This removes the obfuscation
$ grep ^D: ./mungescript.txt | cut -d: -f 2- | sh
```

## How it works
This is a simple script that locates all the files in the given target,
calculates the md5 of the full path and file name, and then creates a script
that will both move the file to the name of the md5, but it will also perform
the reverse.

Order of steps:

1. Calculate the md5
2. Calculate a two tier directory structure for the file names using the first 4 characters of the md5 hash.
3. Writes out two create entries: (a) ensures the directory tier structure exists, (b) moves the file to the md5 name.
4. Writes out two restore entries : (a) ensures the original directory exists, (b) moves the md5 name to the original file name.

## Example:

```text
$ find tmp/Applications/ -type f | wc
     212     539   21518
$ ./mungefiles.sh tmp/Applications/ > tmp/script.txt
$ grep ^C: tmp/script.txt | cut -d: -f 2- | sh
tmp/Applications//.DS_Store -> tmp/2d/59/2d59ac36d680704846ced839271f878d
tmp/Applications//.localized -> tmp/c4/a1/c4a1cfb47ddb3cb2e2a27c5ac2ac2f7b
tmp/Applications//.WebMeetingLauncher.app/Contents/Info.plist -> tmp/d0/13/d013f267a4eda49f9df00f40d06a48e9
tmp/Applications//.WebMeetingLauncher.app/Contents/MacOS/applet -> tmp/20/ff/20ff3cf0970729f72260fcb14c139a43
tmp/Applications//.WebMeetingLauncher.app/Contents/PkgInfo -> tmp/3f/df/3fdfa69fd87f2526466a77de70981fec
tmp/Applications//.WebMeetingLauncher.app/Contents/Resources/applet.icns -> tmp/84/1c/841c05f3f79bc8f8a859b1ccf21ffc1f
tmp/Applications//.WebMeetingLauncher.app/Contents/Resources/applet.rsrc -> tmp/52/fb/52fbd26cea6bc6bc9075e475e88e6af7
tmp/Applications//.WebMeetingLauncher.app/Contents/Resources/launcher -> tmp/5d/61/5d61f261eb326616c55347f94754bfd9
tmp/Applications//.WebMeetingLauncher.app/Contents/Resources/Scripts/main.scpt -> tmp/82/2b/822b65c20723faa40a43911463e88b02
[ snip ]

$ ls -d tmp/*/* |  head
tmp/01/37
tmp/01/cd
tmp/04/a0
tmp/08/35
tmp/0a/8f
tmp/0d/4b
tmp/0f/33
tmp/10/e0
tmp/15/a2
tmp/16/d5

$ find tmp/Applications/ -type f | wc
       0       0       0

$ grep ^D: tmp/script.txt | cut -d: -f 2- | sh
tmp/2d/59/2d59ac36d680704846ced839271f878d -> tmp/Applications//.DS_Store
tmp/c4/a1/c4a1cfb47ddb3cb2e2a27c5ac2ac2f7b -> tmp/Applications//.localized
tmp/d0/13/d013f267a4eda49f9df00f40d06a48e9 -> tmp/Applications//.WebMeetingLauncher.app/Contents/Info.plist
tmp/20/ff/20ff3cf0970729f72260fcb14c139a43 -> tmp/Applications//.WebMeetingLauncher.app/Contents/MacOS/applet
tmp/3f/df/3fdfa69fd87f2526466a77de70981fec -> tmp/Applications//.WebMeetingLauncher.app/Contents/PkgInfo
tmp/84/1c/841c05f3f79bc8f8a859b1ccf21ffc1f -> tmp/Applications//.WebMeetingLauncher.app/Contents/Resources/applet.icns
tmp/52/fb/52fbd26cea6bc6bc9075e475e88e6af7 -> tmp/Applications//.WebMeetingLauncher.app/Contents/Resources/applet.rsrc
tmp/5d/61/5d61f261eb326616c55347f94754bfd9 -> tmp/Applications//.WebMeetingLauncher.app/Contents/Resources/launcher
tmp/82/2b/822b65c20723faa40a43911463e88b02 -> tmp/Applications//.WebMeetingLauncher.app/Contents/Resources/Scripts/main.scpt

$ find tmp/Applications/ -type f | wc
     212     539   21518
```

## TODO
1. Recreate this in python so we're not dropping out into individual subshells to calculate the md5.
