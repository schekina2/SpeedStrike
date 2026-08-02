extends Node

const GRID_SIZE = 32
const GRID_WIDTH = 24
const GRID_HEIGHT = 16

const BASE_SPEED = 0.15
const DASH_SPEED = 0.04
const DASH_DURATION = 0.4
const DASH_COOLDOWN = 2.0

const LEVEL_2_SCORE = 5
const LEVEL_3_SCORE = 12
var last_score: int = 0

const LEVEL_CONFIG = {
	1: {"enemy_count": 2, "enemy_speed": 0.35},
	2: {"enemy_count": 4, "enemy_speed": 0.25},
	3: {"enemy_count": 6, "enemy_speed": 0.15}
}
