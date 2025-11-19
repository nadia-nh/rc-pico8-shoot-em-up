-- Scoring --
function init_score()
  score = 0
  health = 6
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
  print("Level: "..difficulty, 85, 0, color_white)
  print("Score: "..score, 85, 7, color_white)
  draw_health_display(83, 16)
end

-- Draws heart icons (full = 2 health, half = 1) 
function draw_health_display(x, y)
  local heart_x = x + 2
  local heart_y = y - 1
  local remaining = health

  while remaining >= 2 do
    spr(full_heart_sprite, heart_x, heart_y)
    heart_x += 8
    remaining -= 2
  end

  if remaining == 1 then
    spr(half_heart_sprite, heart_x, heart_y)
  end
end
