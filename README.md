# HappyActionMirror - WoW Retail Addon

A World of Warcraft retail addon that displays a copy of your Action Bar 1 when you're flying, in a vehicle, or have an active pet UI. Perfect for quick access to your main abilities while flying.

## Features

- **Flying Display**: Shows Action Bar 1 when you're flying on a flying mount
- **Vehicle Support**: Displays the bar when you're in a vehicle (including special vehicle UIs)
- **Pet UI Support**: Shows the bar when your pet UI is active
- **Customizable Position**: Drag the frame to position it wherever you want on screen
- **Adjustable Settings**: Toggle which scenarios show the bar
- **Configurable**: Save your position and settings between sessions

## Installation

1. Download or extract the addon to your WoW addons folder:

    ```
    World of Warcraft\_retail_\Interface\AddOns\HappyActionMirror\
    ```

2. Restart WoW or reload UI with `/reload`

3. The addon will automatically load when you login

## Commands

- `/ham` or `/happyactionmirror` - Show help
- `/ham toggle` - Enable/disable the addon
- `/ham lock` - Lock/unlock the frame for positioning
- `/ham reset` - Reset frame position to center
- `/ham show` - Force show the bar
- `/ham hide` - Force hide the bar
- `/ham status` - Show current state
- `/ham help` - Show command help

## Usage

1. When you fly, the addon will automatically show your Action Bar 1
2. To reposition the bar, use `/ham lock` to unlock it, then drag the frame to move it
3. Use `/ham lock` again to lock it in place
4. Your position and settings are saved automatically

## Configuration

Settings are saved in a character-specific database. You can modify the following in `Config.lua`:

- `enabled` - Whether the addon is active
- `positionX` / `positionY` - Frame position on screen
- `scale` - Frame size (1.0 = normal)
- `alpha` - Frame transparency (1.0 = opaque)
- `showWhenFlying` - Show bar while flying
- `showWhenVehicle` - Show bar in vehicles
- `showWhenPet` - Show bar with active pet UI
- `locked` - Whether frame is locked from moving

## Troubleshooting

**The bar won't show when flying:**

- Check visibility options in the addon settings panel
- Make sure you're on a flying mount (not just elevated)
- Verify the addon is enabled with `/hf toggle`

**Action bar buttons aren't updating:**

- Try `/reload` to reload the UI
- Make sure Action Bar 1 is visible in your main UI

**Bar is off-screen:**

- Use `/ham reset` to reset the position to center

## Support

For issues or feature requests, please report them in the addon's GitHub repository.

## Version History

- **1.0.0** - Initial release
    - Basic flying/vehicle/pet detection
    - Customizable positioning
    - Configurable visibility conditions

