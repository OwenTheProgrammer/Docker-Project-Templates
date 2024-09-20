CC		= gcc
CFLAGS	= -I$(INC_DIR)/ -Wall -Wextra -std=gnu17
BINARY	= $(BIN_DIR)/test

# Define non-file targets
.PHONY: buildfs clean debug release

# Code directories
SRC_DIR = src
INC_DIR = include

# Compilation directories
OBJ_DIR = obj
BIN_DIR = bin

# Find all .c and .h files in their respective directories
SRC_FILES = $(wildcard $(SRC_DIR)/*.c)
INC_FILES = $(wildcard $(INC_DIR)/*.h)

# Map all src/*.c to obj/*.o
OBJ_FILES = $(SRC_FILES:$(SRC_DIR)/%.c=$(OBJ_DIR)/%.o)

# Remove main from source list to compile last
MAIN_OBJ = $(OBJ_DIR)/main.o
OBJ_FILES := $(filter-out $(MAIN_OBJ), $(OBJ_FILES))

# Define debug/release specific build arguments
debug: CFLAGS += -O0 -ggdb -D DEBUG -Wno-unused-variable -Wno-unused-parameter -Wno-unused-function
debug: all

release: CFLAGS += -O3
release: all

# Do buildfs first, then do binary
all: buildfs | $(BINARY)

# Binary depends on all object files and main object
# https://www.gnu.org/software/make/manual/html_node/Automatic-Variables.html#Automatic-Variables
$(BINARY): $(OBJ_FILES) $(MAIN_OBJ)
	$(CC) $(CFLAGS) $^ -o $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	$(CC) $(CFLAGS) -c $< -o $@

# Sets a rule for all object files and include files to be up to date for main to compile
$(MAIN_OBJ): $(OBJ_FILES) $(INC_FILES)

buildfs:
	mkdir -p $(OBJ_DIR) $(BIN_DIR)

clean:
	rm -rf $(OBJ_DIR)
	rm $(BINARY)