require 'pry-byebug'

class Node # construct node to represent each box
  attr_accessor :val, :right, :left, :up, :down, :temp, :node
  def initialize(x,y)
    @val = []
    @val << x
    @val << y
  end
  def queue
    queue = []
    if @right.nil? == false then queue << @right end
    if @left.nil? == false then queue << @left end
    if @up.nil? == false then queue << @up end
    if @down.nil? == false then queue << @down end
    return queue
  end
end

class Maze
  attr_accessor :matrix, :m, :n, :x, :y, :solvable, :path, :count
  def initialize(x,y)
    @x, @y = x, y
    @n, @m = x*2+1, y*2+1
    @matrix = Array.new(@n) {|x| Array.new(@m) {|x| 0}}
    @solvable = false
    @path = []
    @count = 0
  end

  def valid_maze?(str)
    if str.length == @n * @m
      true
    else
      false
    end
  end

  def load(str)
    if valid_maze?(str)
      puts "Your string size is correct"
      for i in 0..@n-1 do
        for j in 0..@m-1 do
          num = i*@m + j
          @matrix[i][j] = str[num]
        end
      end
      @temp = @matrix
    else
      puts "Wrong size of the string"
    end
  end

  def display
    for n in 0..@matrix.length-1 do
      temp = ""
      @matrix[n].each {|num| temp += num.to_s}
      puts temp
    end
  end

  def solve?(bX=1,bY=1,eX=@x,eY=@y)
    to_tree(bX,bY,eX,eY)
    #binding.pry
    if @solvable then puts "Yes, there is a solution" else puts "No, no solution" end
  end

  def trace(bX=1,bY=1,eX=@x,eY=@y)
    if @solvable
      while @path.last != [eX,eY]
        @path.pop
      end
      #puts @path
      #binding.pry
      display_path(@path)
    else
      puts "No path"
    end
  end

  def display_path(path)
    path.each_with_index {|n,m| puts "step #{m}: (#{n[0]}, #{n[1]})"}
  end

  def to_tree(bX=1,bY=1,eX=@x,eY=@y) # create a tree of all possible routes
    node = Node.new(bX,bY)
    path = []
    recursive(node,eX,eY,path)
    @node = node
  end

  def recursive(node,eX,eY,path)
    if node.val != [eX,eY]
      if right?(node.val[0],node.val[1]) # check right, if movable set the right wall as 1
        node.right = Node.new(node.val[0],node.val[1]+1)
        @temp[matrix_index(node.val[0])][matrix_index(node.val[1])+1] = 1
      end
      if left?(node.val[0],node.val[1])
        node.left = Node.new(node.val[0],node.val[1]-1)
        @temp[matrix_index(node.val[0])][matrix_index(node.val[1])-1] = 1
      end
      if up?(node.val[0],node.val[1])
        node.up = Node.new(node.val[0]-1,node.val[1])
        @temp[matrix_index(node.val[0])-1][matrix_index(node.val[1])] = 1
      end
      if down?(node.val[0],node.val[1])
        node.down = Node.new(node.val[0]+1,node.val[1])
        @temp[matrix_index(node.val[0])+1][matrix_index(node.val[1])] = 1
      end
      #puts "#{node.val[0]}, #{node.val[1]}"
      path << node.val
      node.queue.each do |n|
        if n then recursive(n,eX,eY,path) end
      end
    else
      #puts "last one #{node.val[0]}, #{node.val[1]}"
      path << node.val
      @path = path # store all the routes in path
      @solvable = true # tag mark to see if this tree reaches the destination
    end
  end

  def right?(x,y) # check right wall of a cell
    n, m = matrix_index(x), matrix_index(y)
    if @temp[n][m+1]=="0" then true else false end
  end

  def left?(x,y)
    n, m = matrix_index(x), matrix_index(y)
    if @temp[n][m-1]=="0" then true else false end
  end

  def up?(x,y)
    n, m = matrix_index(x), matrix_index(y)
    if @temp[n-1][m]=="0" then true else false end
  end

  def down?(x,y)
    n, m = matrix_index(x), matrix_index(y)
    if @temp[n+1][m]=="0" then true else false end
  end

  def visitable?(x,y)
    x, y = matrix_index(x), matrix_index(y)
    if @matrix[x+1][y]=="0"||@matrix[x-1][y]=="0"||@matrix[x][y+1]=="0"||@matrix[x][y-1]=="0" then true else false end
  end

  def matrix_index(x)
    x*2-1
  end

end


initial_string = "111111111100010001111010101100010101101110101100000101111011101100000101111111111"
sample = Maze.new(4,4)
sample.valid_maze?(initial_string) # correct
sample.load(initial_string)
sample.display
sample.solve?(1,1,4,4)
sample.trace(1,1,4,4)
