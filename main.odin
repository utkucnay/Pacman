package main

import "core:fmt"
import "app"

main :: proc() {
  if(!app.Init()) {
    fmt.println("Didn't Create Application")
    return
  }
  defer app.Destroy()

  app.Run()
}
