--Enemy controls--

-- Fill upper third of the screen with enemies
function init_enemies()
  max_enemies = enemy_count * get_difficulty()
  remaining_enemies = max_enemies
  enemies = {}

  for i = 1, max_enemies do
    add(enemies, {
      x = rnd(screen_max_x - enemy_width),
      y = rnd(screen_max_y / 3),
      prev_x = 0,
      prev_y = 0,
      delta_x = 1 / (speed_min - flr(rnd(get_difficulty()))),
      delta_y = 1 / (speed_min - flr(rnd(get_difficulty()))),
      move_right = rnd(1) < 0.5,
      alive = true,
      })
  end
end

-- Move all enemies diagonally according to their speed
function move_enemies()
  for enemy in all(enemies) do
    enemy.prev_x = enemy.x
    enemy.prev_y = enemy.y

    enemy.y += enemy.delta_y
    detect_floor_collision(enemy)
    
    if enemy.move_right then
      enemy.x += enemy.delta_x
    else
      enemy.x -= enemy.delta_x
    end
  end
end

-- Draw enemies that are still alive
function draw_enemies()
  if no_health() then
    show_lose_message()
    return
  end

  if remaining_enemies == 0 then
    if at_max_difficulty() then
      show_win_message()
      return
    end

    increase_difficulty()
    init_enemies()
    return
  end

  detect_attacks()

  for enemy in all(enemies) do
    if enemy.alive then
      spr(enemy_sprite, enemy.x, enemy.y)
    end
  end
end

-- Clamp x coordinate and change direction
function bounce_on_wall(enemy)
  local max_value = screen_max_x - enemy_width - 1
  enemy.x = clamp(
    enemy.x,
    screen_min_x,
    max_value)

  if enemy.x == screen_min_x or enemy.y == max_value then
    enemy.move_right = not enemy.move_right
  end
end

---------- Private methods ----------

-- Check if the enemy has reached the bottom of the screen
function detect_floor_collision(enemy)
  if no_health() then
    return
  end

  if enemy.alive then
    if enemy.y >= (screen_max_y - enemy_height) then
      decrease_score()
      remaining_enemies -= 1
      del(enemies, enemy)
    end
  end
end

-- Checks if the laser hit any of the enemies
function detect_attacks()
  if is_shooting() then
    for enemy in all(enemies) do
      for laser in all(get_lasers()) do
        if enemy.alive and laser_covers_enemy(laser, enemy) then
          destroy_enemy(enemy)
        end
      end
    end
  end
end

-- Laser position should be below the enemy vertically and
-- within the enemy's whole sprite horizontally
function laser_covers_enemy(laser, enemy)
  local min_x = enemy.x - epsilon
  local max_x = enemy.x + enemy_width + epsilon
  local min_y = enemy.y + enemy_height + shooting_distance_min - epsilon
  local max_y = screen_max_y

  return in_range(laser.x, min_x, max_x) and in_range(laser.y, min_y, max_y)
end

-- Mark the enemy as not alive, does not destroy it
-- Swap the sprite to indicate destruction
function destroy_enemy(enemy)
  spr(dead_enemy_sprite, enemy.x, enemy.y)

  if not enemy.alive then
    error("destroy_enemy called on inactive enemy")
  end

  enemy.alive = false
  remaining_enemies -= 1
  increase_score()
end
