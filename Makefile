# Define variables for source and build directories
SRC_DIR := src
BUILD_DIR := build

# Define the source file and target binary file
ASM_SRC := $(SRC_DIR)/main.asm
BIN_TARGET := $(BUILD_DIR)/main.bin
IMG_TARGET := $(BUILD_DIR)/main_floppy.img

# Rule to build the binary from the assembly source
$(BIN_TARGET): $(ASM_SRC)
	if not exist $(BUILD_DIR) mkdir $(BUILD_DIR)
	nasm -f bin -o $(BIN_TARGET) $(ASM_SRC)

# Rule to create a floppy image
$(IMG_TARGET): $(BIN_TARGET)
	@if not exist $(IMG_TARGET) fsutil file createnew $(IMG_TARGET) 1474560
	@python -c "with open('$(IMG_TARGET)', 'r+b') as img, open('$(BIN_TARGET)', 'rb') as bin: img.write(bin.read())"

# Default target to build the floppy image
all: $(IMG_TARGET)

# Clean rule to remove build artifacts
clean:
	-del /Q $(BUILD_DIR)\main.bin $(BUILD_DIR)\main_floppy.img

.PHONY: all clean
