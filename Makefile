BUILD_DIR=./build
SRC_DIR=./src

all: $(BUILD_DIR)/client.js $(BUILD_DIR)/main.js $(BUILD_DIR)/bots/RawBot.js $(BUILD_DIR)/bots/RandomBot.js

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/client.js: $(BUILD_DIR)
	coffee -o $(BUILD_DIR) -c $(SRC_DIR)/client.coffee

$(BUILD_DIR)/main.js: $(BUILD_DIR)
	coffee -o $(BUILD_DIR) -c $(SRC_DIR)/main.coffee

$(BUILD_DIR)/bots:
	mkdir -p $(BUILD_DIR)/bots

$(BUILD_DIR)/bots/RawBot.js: $(BUILD_DIR)/bots
	coffee -o $(BUILD_DIR)/bots -c $(SRC_DIR)/bots/RawBot.coffee


$(BUILD_DIR)/bots/RandomBot.js: $(BUILD_DIR)/bots
	coffee -o $(BUILD_DIR)/bots -c $(SRC_DIR)/bots/RandomBot.coffee


clean:
	rm -rf $(BUILD_DIR)