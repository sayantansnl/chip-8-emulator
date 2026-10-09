# CHIP-8 Emulator in Odin

A CHIP-8 emulator written in Odin, built primarily as a hands-on project to learn the language.

The goal wasn't to build the most feature-complete CHIP-8 emulator out there. It was to learn Odin by building something
real, working through its language features, and figuring things out along the way.

## Test ROMs

- IBM Logo <img width="1270" height="636" alt="IBM-logo" src="https://github.com/user-attachments/assets/ef6fa2e9-6c34-4adf-96f5-5e9bb74d340c" />

---

- Keypad test <img width="1264" height="621" alt="Keypad-test" src="https://github.com/user-attachments/assets/881c5c30-0890-459b-988a-4f986df53442" />

---

- Opcode test <img width="1214" height="613" alt="Opcode-test" src="https://github.com/user-attachments/assets/4d671a17-7f43-4e4e-a02a-4b9ea4c45370" />

## Games Tested

- Tetris <img width="1256" height="629" alt="Tetris" src="https://github.com/user-attachments/assets/e11fea63-026b-4d46-b8e9-fcb7e34b5f57" />

---

- Tank <img width="1251" height="633" alt="Tank" src="https://github.com/user-attachments/assets/255f39cb-02c0-4340-8c74-7d4ddb040876" />

---

- Space Invaders <img width="1268" height="634" alt="Space-Invaders" src="https://github.com/user-attachments/assets/29b90abc-87dd-491b-acf7-b611742fd874" />

## Running the project

The ROM path is currently configured in the source code. Update `ROM_PATH` in the entry point to point to the ROM you want
to run.

Then run the project using the Odin compiler:
`odin run .`

Make sure Odin, SDL2, and the project's required SDL2 bindings are available in your environment.

## What's next?

Absolutely nothing.
