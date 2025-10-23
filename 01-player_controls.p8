--Player controls--

-- Initialize player position and size, also the colors we'll use
function init_player()
  player = {
    x = screen_max_x / 2 - (player_width / 2),
    y = screen_max_y - (player_height / 2)}
  lasers = {
    {x = screen_min_x, y = screen_min_y},
    {x = screen_min_x, y = screen_min_y}}
  shooting = false
  laser_active_frames = 0
  laser_cooldown_remaining = 0
end

-- Check for left, right, up, and down inputs and update the player position
function move_player()
  if btn(button_left) then
    player.x -= 1
  elseif btn(button_right) then
    player.x += 1
  elseif btn(button_up) then
    player.y -= 1
  elseif btn(button_down) then
    player.y += 1
  end

  clamp_coordinates()
end

function draw_player()
  spr(player_sprite, player.x, player.y)
  shoot()
end

function get_lasers()
  return lasers
end

function is_shooting()
  return shooting
end

---------- Private methods ----------

-- Make sure we stay within screen bounds
function clamp_coordinates()
  player.x = clamp(
    player.x,
    screen_min_x,
    screen_max_x - player_width - 1)
  player.y = clamp(
    player.y,
    screen_min_y,
    screen_max_y - player_height - 1)
end

-- TODO: Use a sprite, and add movement to that
-- Handles firing logic for the laser weapon.
function shoot()
  local wants_to_fire = btn(button_x)

  -- Laser duration has reached the maximum
  if laser_active_frames > laser_duration then
    begin_laser_cooldown()
    return
  end

  -- Cooldown hasn't finished yet
  if laser_cooldown_remaining > 0 then
    laser_cooldown_remaining = max(0, laser_cooldown_remaining - 1)
    return
  end

  if not shooting and wants_to_fire then
    start_shooting()
  end

  -- Check if we're already shooting
  if shooting then
    laser_active_frames += 1
    draw_laser_beam()
  end

  shooting = wants_to_fire
end

function start_shooting()
  shooting = true
  laser_active_frames = 0
  laser_cooldown_remaining = 0
end

function begin_laser_cooldown()
  shooting = false
  laser_active_frames = 0
  laser_cooldown_remaining = laser_cooldown_duration
end

-- Draw a vertical green beam from player upward
function draw_laser_beam()
  local line_x = player.x + player_width / 2

  lasers = {
    {x = line_x - 1, y = player.y},
    {x = line_x, y = player.y}
  }
  
  for laser in all(lasers) do
    line(laser.x, laser.y, laser.x, screen_min_y, color_green)
  end
end
