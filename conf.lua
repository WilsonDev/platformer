function love.conf(t)
  t.title = "2D Platformer"

  t.window.fullscreen = false
  t.window.width = 960
  t.window.height = 320
  t.modules.joystick = false
  t.modules.mouse = false
  t.modules.physics = false
  t.console = true

  io.stdout:setvbuf("no")
end
