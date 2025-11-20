--Player controls--

-- Initialize player position
function init_player()
  player = {
    x = screen_max_x / 2 - (player_width / 2),
    y = screen_max_y - (player_height / 2),
  }
  player.prev_x = player.x
  player.prev_y = player.y
  lasers = {
    {x = screen_min_x, y = screen_min_y},
    {x = screen_min_x, y = screen_min_y}
  }
  shooting = false
  laser_active_frames = 0
  laser_cooldown_remaining = 0
end

-- Check for left, right, up, and down inputs and update the player position
function move_player()
  player.prev_x = player.x
  player.prev_y = player.y

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

function handle_collisions()
  if not enemies then
    return false
  end

  local min_x = player.x
  local max_x = player.x + player_width
  local min_y = player.y
  local max_y = player.y + player_height

  for enemy in all(enemies) do
    if collides_with_enemy(enemy, min_x, max_x, min_y, max_y) then
      player.x = player.prev_x
      player.y = player.prev_y

      enemy.y = enemy.prev_y
      enemy.x = enemy.prev_x
      enemy.move_right = not enemy.move_right
    end

    bounce_on_wall(enemy)
  end
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

-- Returns true if the new player position overlaps a living enemy
function collides_with_enemy(enemy, min_x, max_x, min_y, max_y)
  if not enemy.alive then
    return false
  end

  local enemy_min_x = enemy.x - epsilon
  local enemy_max_x = enemy.x + enemy_width + epsilon
  local enemy_min_y = enemy.y - epsilon
  local enemy_max_y = enemy.y + enemy_height + epsilon

  local separated =
    max_x <= enemy_min_x or
    min_x >= enemy_max_x or
    max_y <= enemy_min_y or
    min_y >= enemy_max_y

  return not separated
end

-- Handles firing logic for the laser weapon.
function shoot()
  local wants_to_fire = btn(button_x)
  local max_frames = get_laser_max_active_frames()
  local beam_fired = false

  laser_active_frames = clamp(laser_active_frames, 0, max_frames)

  -- Cooldown hasn't finished yet
  if laser_cooldown_remaining > 0 then
    laser_cooldown_remaining = max(0, laser_cooldown_remaining - 1)
  else
    if wants_to_fire then
      if not shooting then
        start_shooting()
      end

      if laser_active_frames >= max_frames then
        begin_laser_cooldown()
        shooting = false
        return
      end

      laser_active_frames = min(max_frames, laser_active_frames + 1)
      draw_laser_beam()
      beam_fired = true
    else
      laser_active_frames = max(0, laser_active_frames - 1)
    end
  end

  shooting = beam_fired
end

function start_shooting()
  shooting = true
  laser_cooldown_remaining = 0
end

function begin_laser_cooldown()
  shooting = false
  laser_active_frames = get_laser_max_active_frames()
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

-- Compute max frames the laser may stay on (easy -> hard)
function get_laser_max_active_frames()
  local progress = get_difficulty_progress()
  local value = laser_duration_easy - (laser_duration_easy - laser_duration_hard) * progress
  return max(laser_duration_hard, flr(value)) -- clamp to at least 'hard'
end
