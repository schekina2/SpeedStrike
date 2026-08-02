extends Node

const GRID_SIZE = 32  # taille d'une case en pixels
const GRID_WIDTH = 24  # nombre de cases en largeur (960 / 32)
const GRID_HEIGHT = 16  # nombre de cases en hauteur (540 / 32)

const BASE_SPEED = 0.15  # secondes entre chaque déplacement (plus petit = plus rapide)
const DASH_SPEED = 0.04  # vitesse pendant le dash
const DASH_DURATION = 0.4  # durée du dash en secondes
const DASH_COOLDOWN = 2.0  # temps de recharge après un dash
