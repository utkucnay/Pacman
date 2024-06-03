package app

import "core:fmt"
import "core:math"
import "vendor:raylib"

GameState :: struct {
  pos: [2]f32,
  spriteSheet: raylib.Texture2D,
}

AppState :: struct {
  renderTexture: raylib.RenderTexture2D,
  nativeResulation: [2]i32,
  windowRes: [2]i32,
  scale: i32,
}

appState: AppState
gameState: GameState

Scene :: enum i8 {
  Main,
  Play,
  End,
}

Init :: proc() -> bool {
  appState.nativeResulation = {224, 288}
  appState.scale = 2

  appState.windowRes = appState.nativeResulation * { appState.scale, appState.scale }
  raylib.InitWindow(appState.windowRes.x, appState.windowRes.y, "Pacman")
  if(!raylib.IsWindowReady()) {
    fmt.println("Didn't Create Raylib Window")
    return false
  }

  gameState.spriteSheet = raylib.LoadTexture("asset/sprite-sheet.png")
  appState.renderTexture = raylib.LoadRenderTexture(appState.nativeResulation.x, appState.nativeResulation.y)
  raylib.SetTargetFPS(60)
  return true
}

Run :: proc() {
  for (!raylib.WindowShouldClose()) {

    raylib.BeginTextureMode(appState.renderTexture)

    raylib.ClearBackground(raylib.BLACK)

    for y: i32 = 0; y < gameState.spriteSheet.height / 2; y += 6 {
      for x: i32 = 0; x < gameState.spriteSheet.width / 2; x += 6 {
        raylib.DrawTextureRec(
          gameState.spriteSheet,
          {f32(x), f32(y), f32(x + 12), f32(y + 12)},
          {f32(x), f32(y)}, raylib.WHITE)
      }
    }

    if raylib.IsKeyDown(raylib.KeyboardKey.W) {
      gameState.pos.y -= 1
    }

    if raylib.IsKeyDown(raylib.KeyboardKey.S) {
      gameState.pos.y += 1
    }

    if raylib.IsKeyDown(raylib.KeyboardKey.A) {
      gameState.pos.x -= 1
    }

    if raylib.IsKeyDown(raylib.KeyboardKey.D) {
      gameState.pos.x += 1
    }

    raylib.DrawTextureRec(
      gameState.spriteSheet,
      {0, 0, 12, 12},
      gameState.pos, raylib.WHITE)

    raylib.EndTextureMode()

    raylib.BeginDrawing()

    raylib.ClearBackground(raylib.BLACK)

    raylib.DrawTexturePro(
      appState.renderTexture.texture,
      {0, 0, f32(appState.nativeResulation.x), f32(-appState.nativeResulation.y) },
      {0, 0, f32(appState.windowRes.x), f32(appState.windowRes.y) },
      {0, 0},
      0,
      raylib.WHITE)

    raylib.EndDrawing()
  }
}

Destroy :: proc() {
  raylib.CloseWindow()
}
