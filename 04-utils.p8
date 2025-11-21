-- Utils --

-- Values for buttons, sprites, sizes, and colors --
function init_constants()
  color_black = 0
  color_dark_blue = 1
  color_dark_purple = 2
  color_dark_green = 3
  color_brown = 4
  color_dark_gray = 5
  color_light_gray = 6
  color_white = 7
  color_red = 8
  color_orange = 9
  color_yellow = 10
  color_green = 11
  color_blue = 12
  color_indigo = 13
  color_pink = 14
  color_peach = 15

  player_sprite = 1
  enemy_sprite = 2
  full_heart_sprite = 3
  half_heart_sprite = 4
  dead_enemy_sprite = 5

  player_width = 8
  player_height = 8
  enemy_width = 8
  enemy_height = 8

  button_left = 0
  button_right = 1
  button_up = 2
  button_down = 3
  button_o = 4
  button_x = 5

  screen_min_x = 0.0
  screen_max_x = 128.0
  screen_min_y = 0.0
  screen_max_y = 128.0

  -- lower values equal more speed
  speed_min = 10
  difficulty_max = 10
  enemy_count = 3
  shooting_distance_min = 0.5

  laser_duration_easy = 70 -- frames at level 1
  laser_duration_hard = 30 -- frames at max difficulty
  laser_cooldown_duration = 30 -- frames needed to recharge

  -- value used to compare floats
  epsilon = 0.00001
end

-- Checks if val in [min, max)
function in_range(val, min, max)
  return greater_or_equal(val, min) and val < max
end

-- Clamps val to [min, max]
function clamp(val, min, max)
  if val < min then
    return min
  elseif val > max then
    return max
  end

  return val
end

-- Checks if two floats are approximately equal
function equals(a, b)
  return abs(a - b) < epsilon
end

-- Checks if a is less than or approximately equal to b
function less_or_equal(a, b)
  return a < b or equals(a, b)
end

-- Checks if a is greater than or approximately equal to b
function greater_or_equal(a, b)
  return a > b or equals(a, b)
end

-- Returns how far along the difficulty scale we are as a value between 0 and 1
-- (0 = easiest, 1 = hardest)
function get_difficulty_progress()
  local difficulty = get_difficulty()
  local max_step = max(1, difficulty_max - 1)
  local progress = clamp(difficulty - 1, 0, max_step)
  return (progress / max_step) ^ 0.75
end
