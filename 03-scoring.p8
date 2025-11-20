-- Scoring --
function init_score()
  score = 0
  health = 4
  difficulty = 1
end

function increase_score()
  score += 1
end

function decrease_score()
  score -= 1
  lose_health()
end

function lose_health()
  health = max(0, health - 1)
end

function no_health()
  return health <= 0
end

function increase_difficulty()
  difficulty += 1
end

function get_difficulty()
  return difficulty
end

function at_max_difficulty()
  return difficulty >= difficulty_max
end

function draw_score()
  print("Level:"..difficulty, 90, 3, color_white)
  draw_health_display(88, 12)
  draw_laser_meter(90, 20)
end

-- Draws heart icons
function draw_health_display(x, y)
  local heart_x = x + 2
  local heart_y = y - 1
  local remaining = health

  while remaining > 0 do
    spr(full_heart_sprite, heart_x, heart_y)
    heart_x += 8
    remaining -= 1
  end
end

-- Draw a horizontal indicator showing remaining laser charge
function draw_laser_meter(x, y)
  local meter_width = 30
  local meter_height = 4
  local max_frames = max(1, get_laser_max_active_frames())
  local depletion = clamp(laser_active_frames, 0, max_frames)
  local remaining

  if laser_cooldown_remaining > 0 then
    remaining = 0
  else
    remaining = max_frames - depletion
  end

  local fill_width = flr((remaining / max_frames) * meter_width)

  rectfill(x, y, x + meter_width - 1, y + meter_height - 1, color_dark_gray)

  if fill_width > 0 then
    rectfill(
      x,
      y,
      x + fill_width - 1,
      y + meter_height - 1,
      color_green)
  end
end

function show_win_message()
  print("You win! Score:"..score, 30, 100)
end

function show_lose_message()
  print("Game over! Score:"..score, 30, 100)
end
