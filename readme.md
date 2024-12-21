## What is this project about?
This is modded version of AlternativaEditor (Tanks map editor)

**Main features**:
- **Hardware acceleration support** - this editor uses Alternativa3D 7.11 which provides much better performance because of GPU rendering

## Notice
This editor is still under development, and doesn't support some features that were in the original version. It mainly caused by 3D engine upgrade.
So here is the list of what is not supported yet:
- Selecting props on the map by clicking on them. (Selecting all props in area works).

## How to build
Project is configured to compile in VS Code with [ActionScript & MXML](https://marketplace.visualstudio.com/items?itemName=bowlerhatllc.vscode-as3mxml) Plugin.

You will need Flex 4.9 + AIR 51 SDK
Here are the steps how to make it:
1. Download Apache Flex SDK Installer from the [official website](https://flex.apache.org/installer.html). Open the installer, select version 4.9.1, and download it.
2. Download Adobe AIR+Flex SDK from [here](https://airsdk.harman.com/download). You need 'AIR SDK for Flex Developers - to be overlaid onto a Flex SDK'.
3. Copy all files from AIR SDK into Flex SDK.

Done. Now select this combined SDK in VSCode and compile the project.