package bunnymark

import "core:fmt"
import rl "vendor:raylib"

MAX_BUNNIES :: 50000
MAX_BATCH_ELEMENTS :: 8192

Bunny :: struct {
    pos : rl.Vector2,
    speed : rl.Vector2,
    color : rl.Color
}

main :: proc() {

    WIDTH   :: 1024
    HEIGHT  :: 768
    FPS     :: 144
    TITLE : cstring : "Bnnuy mark - Odin"
    
    rl.InitWindow(WIDTH, HEIGHT, TITLE)

    bunny_tex := rl.LoadTexture("./res/wabbit_alpha.png")

    bunnies : [MAX_BUNNIES]Bunny

    bunnies_count : i32 = 0

    rl.SetTargetFPS(FPS)
    
    for !rl.WindowShouldClose() {

        if rl.IsMouseButtonDown(rl.MouseButton(0)) {
            for i in 0..<250{
                if bunnies_count < MAX_BUNNIES {
                    bunnies[bunnies_count].pos = rl.GetMousePosition()
                    bunnies[bunnies_count].speed.x = f32(rl.GetRandomValue(-250, 250))/60.0
                    bunnies[bunnies_count].speed.y = f32(rl.GetRandomValue(-250, 250))/60.0
                    bunnies[bunnies_count].color = rl.Color{u8(rl.GetRandomValue(50, 240)),
                                                            u8(rl.GetRandomValue(80, 240)),
                                                            u8(rl.GetRandomValue(100, 240)), 255 }
                    bunnies_count += 1
                }
            }
        }
        
        for i in 0..<bunnies_count {
            bunnies[i].pos += bunnies[i].speed

            if (((bunnies[i].pos.x + f32(bunny_tex.width/2)) > f32(rl.GetScreenWidth())) ||
                ((bunnies[i].pos.x + f32(bunny_tex.width/2)) < 0)) {
                    bunnies[i].speed.x *= -1
                }
            if (((bunnies[i].pos.y + f32(bunny_tex.height/2)) > f32(rl.GetScreenHeight())) ||
                ((bunnies[i].pos.y + f32(bunny_tex.height/2) - 40) < 0)) {
                    bunnies[i].speed.y *= -1
                }
        }
        
        rl.BeginDrawing()
        
            rl.ClearBackground(rl.RAYWHITE)

            for i in 0..<bunnies_count{
                rl.DrawTexture(bunny_tex, i32(bunnies[i].pos.x), i32(bunnies[i].pos.y), bunnies[i].color);
            }

            rl.DrawRectangle(0, 0, WIDTH, 40, rl.BLACK);
            rl.DrawText(rl.TextFormat("bunnies: %i", bunnies_count), 120, 10, 20, rl.GREEN);
            rl.DrawText(rl.TextFormat("batched draw calls: %i", 1 + bunnies_count/MAX_BATCH_ELEMENTS), 320, 10, 20, rl.MAROON);

            rl.DrawFPS(10, 10);
            
        rl.EndDrawing()
    }

    rl.CloseWindow()
}