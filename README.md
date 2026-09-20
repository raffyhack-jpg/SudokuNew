# SudokuGame for iPhone

A native, dependency-free SwiftUI Sudoku game for iOS 16 and later.

## Features

- Easy, medium, and hard puzzles
- Notes mode with automatic note cleanup
- Mistake highlighting and counter
- Timer, hints, erase, and completion dialog
- Row, column, box, and matching-number highlighting
- Portrait iPhone layout

## Phone-only build

1. Open the **Actions** tab in this repository.
2. Select **Build unsigned IPA**.
3. Tap **Run workflow**, keep the branch set to `main`, and run it.
4. Open the completed run after it shows a green checkmark.
5. Download the **SudokuGame-unsigned-IPA** artifact.
6. Extract the artifact ZIP in Files to get `SudokuGame-unsigned.ipa`.
7. Import the IPA into MapleSign, choose your certificate and matching provisioning profile, sign, and install.

The bundle identifier is `com.example.SudokuGame`. If your profile does not support it, use MapleSign to change the bundle identifier to one allowed by your profile.

## Security

The workflow does not contain or upload signing certificates. MapleSign handles signing material locally on the iPhone.
