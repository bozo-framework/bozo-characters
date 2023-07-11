# bozo-characters

bozo-characters is a module for the BozoFramework that provides character management features for players. It enables players to create, edit, delete, and switch between multiple characters within the game. Additionally, it offers customization options for the player's character ped.

## Features

### Character Selection

- Allows players to select a character from their available characters.
- Displays character information such as name, age, gender, and appearance.
- Provides an intuitive interface for choosing the desired character.

### Create Characters

- Enables players to create new characters with customizable attributes.
- Allows customization of character name, age, gender, and appearance.
- Provides an intuitive character creation process.

### Edit Characters

- Allows players to modify existing characters.
- Provides options to change character name, age, gender, and appearance.
- Offers a seamless editing experience for character attributes.

### Delete Characters

- Enables players to delete unwanted characters.
- Provides a confirmation prompt to prevent accidental deletion.
- Ensures secure removal of characters from the database.

### Switch Character

- Allows players to switch between their created characters.
- Provides a seamless transition between characters without restarting the game.
- Preserves character data to ensure progress and continuity.

### Customize Ped

- Offers customization options for the player's character ped.
- Allows modification of clothing, hairstyles, accessories, and more.
- Provides an immersive and personalized character appearance.

## Usage

To use the bozo-characters module, follow these steps:

1. Ensure that the BozoFramework is properly installed and configured in your project.
2. Import the bozo-characters module into your project.
3. Use the provided functions and events to implement character management and customization features in your game.

## Examples

Selecting a Character:

TriggerEvent("bozo-characters:SelectCharacter")

This will trigger the character selection interface, allowing the player to choose a character from their available characters.

Creating a Character:

TriggerEvent("bozo-characters:CreateCharacter")

This will open the character creation interface, where the player can customize and create a new character.

Editing a Character:

TriggerEvent("bozo-characters:EditCharacter")

This will open the character editing interface, where the player can modify the attributes of an existing character.

Deleting a Character:

TriggerEvent("bozo-characters:DeleteCharacter")

This will prompt the player to confirm the deletion of a character. If confirmed, the character will be permanently removed.

Switching Characters:

TriggerEvent("bozo-characters:SwitchCharacter")

This will allow the player to switch between their created characters, preserving their progress and continuing the game as the selected character.

Customizing the Character Ped:

TriggerEvent("bozo-characters:CustomizePed")

This will open the character ped customization interface, where the player can modify the appearance of their character's ped, including clothing, hairstyles, accessories, and more.

## Acknowledgements

The bozo-characters module is a fictional component created for the BozoFramework and should not be used in a production environment. It is intended for entertainment purposes only.
