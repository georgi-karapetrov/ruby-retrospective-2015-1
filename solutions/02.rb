def move(snake, direction)
  grow(snake, direction).drop(1)
end

def grow(snake, direction)
  new_snake = Array.new(snake)
  new_snake_head = Array.new(new_snake[-1])
  new_snake_head[0] += direction[0]
  new_snake_head[1] += direction[1]
  new_snake.push(new_snake_head)
end

def generate_array_of_points(x, ys)
  ys.map { |y| [x, y] }
end

def create_board(dimensions)
  width = dimensions[:width] - 1
  height = dimensions[:height] - 1
  xs = *(0..width)
  ys = *(0..height)
  board = xs.map { |x| generate_array_of_points(x, ys) }
  board.flatten(1)
end

def new_food(food, snake, dimensions)
  board = create_board(dimensions)
  free_positions = board - (food + snake)
  free_positions.shuffle.shift
end

def obstacle_ahead?(snake, direction, dimensions)
  next_position = move(snake, direction).pop
  width = dimensions[:width]
  height = dimensions[:height]
  out_of_bounds_x = next_position[0] >= width or next_position[0] < 0
  out_of_bounds_y = next_position[1] >= height or next_position[1] < 0
  out_of_bounds_x or out_of_bounds_y or snake.include?(next_position)
end

def danger?(snake, direction, dimensions)
  future_snake = move(snake, direction)
  dies_in_one_turn = obstacle_ahead?(snake, direction, dimensions)
  dies_in_two_turns = obstacle_ahead?(future_snake, direction, dimensions)
  dies_in_two_turns or dies_in_one_turn
end
