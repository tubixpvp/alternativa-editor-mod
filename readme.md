## What is this project about?
This is a modded AlternativaEditor (Tanki map editor)

**New features**:
- **Hardware acceleration support** - this editor uses Alternativa3D 7.11 which provides much better performance because of GPU rendering.
- **Prop transformation panel** - new prop transform panel, where you can manually set position and rotation of the selected prop.
- **Disabling collision for props** - you can easily disable collision of any prop on the scene, so tanks can go through it.
- **Localization** - editor has multi-language system. Currently, only English and Russian are implemented, but you can pull-request your own translations (see file [localization.json](https://github.com/tubixpvp/alternativa-editor-mod/blob/master/src/mod/locale/localization.json)).
- **45-degree rotation** - with half-snapping enabled, you can rotate the selected group of props by 45 degrees.
- **Exporting to HTML5 Tanki map format (.bin)** - experimental feature; Update: these maps don't load in the game anymore.
- **Other quality-of-life features** - editor has many little but significant features. For example, it saves recent libraries paths.

## Notice
The editor was originally created by and belongs to [AlternativaGames](https://github.com/AlternativaPlatform). This mod uses decompiled and restored code of their editor. Even though it has been discontinued by the owners, I suggest to only use the contents of this respository in educational purposes. **I do not own it, use at your own risk.**

All code that is written by me as a part of modification is licensed under [MIT](LICENCE).

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
