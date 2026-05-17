## What is this project about?
This is modded version of AlternativaEditor (Tanks map editor)

**New features**:
- **Hardware acceleration support** - this editor uses Alternativa3D 7.11 which provides much better performance because of GPU rendering.
- **Disabling collision for props** - you can easily disable collision of any prop on the scene, so tanks can go through it.
- **Exporting to HTML5 Tanki map format (.bin)** - test feature, still in development.
- **Localization** - editor has multi-language system. Currently, only English and Russian are implemented, but you can pull-request your own translations (see file [localization.json](https://github.com/tubixpvp/alternativa-editor-mod/blob/master/src/mod/locale/localization.json)).
- **Other quality-of-life features** - editor has many little but significant features. For example: saves recent libraries paths; shows information about selected prop.

## Notice
This editor still doesn't support all features that were in the original Editor, and may have some bugs. It mainly caused by 3D engine upgrade.

The editor itself was originally created by [AlternativaGames](https://github.com/AlternativaPlatform) and the sources are not officialy public, so use the code only in educational purposes; commercial use is not recommended.

## How to run
To run the editor you need to install [Adobe/Harman AIR](https://airsdk.harman.com/runtime) of version 51 or higher.
Install [AlternativaEditor.swc](https://github.com/tubixpvp/alternativa-editor-mod/releases/latest) and run as any other program.

## How to build
Project is configured to compile in VS Code with [ActionScript & MXML](https://marketplace.visualstudio.com/items?itemName=bowlerhatllc.vscode-as3mxml) Plugin.

You will need Flex 4.9 + AIR 51 SDK.
Here are the steps how to make it:
1. Download Apache Flex SDK Installer from the [official website](https://flex.apache.org/installer.html). Open the installer, select version 4.9.1 and download it.
2. Download AIR/Flex SDK from [here](https://airsdk.harman.com/download/51.1.3.10). You need 'AIR SDK for Flex Developers - to be overlaid onto a Flex SDK'.
3. Copy all files from AIR SDK into Flex SDK.

Done. Now select this combined SDK in VSCode and compile the project.