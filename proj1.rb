# dkuzmyk3
# Dmytro Kuzmyk

quit = false
commandBool = false
n = -1
h = 0

$classContainer = []             # container for all subclasses to tranverse back and forth
$classContainer.push(Object)     # contains root
$history = []                    # to contain history
$history.push(Object)             # history for root

def mergeSort(arr)
  if arr.count <= 1
    return arr
  end

  mid = arr.count/2
  arr1 = mergeSort (arr.slice(0, mid))
  arr2 = mergeSort (arr.slice(mid, arr.count-mid))

  result = []
  shift_left = 0;
  shift_right = 0;
  while shift_left < arr1.count && shift_right < arr2.count do
    one = arr1[shift_left]
    two = arr2[shift_right]

    if one <= two
      result << one
      shift_left +=1
    else
      result << two
      shift_right +=1
    end
  end

  while shift_left < arr1.count
    result<<arr1[shift_left]
    shift_left+=1
  end

  while shift_right < arr2.count
    result<<arr2[shift_right]
    shift_right+=1
  end
  return result

end



def alphaSort(o)
  count = 1
  $classContainer = []
  #classContainer = (ObjectSpace.each_object(Class).select{|klass| klass < o.class}).select{|k| k.inspect.include?("Class")}.to_s
  ObjectSpace.each_object(Class) do |klass|
    next unless klass < o.class && klass.superclass === o.class && !klass.to_s.include?("::") && !klass.to_s.include?("#") && !klass.to_s.include?(".")
    $classContainer.push(klass)
  end

  #$classContainer.sort_by {|k| k.to_s}

  #print classContainer.class
  #classContainer = [1,45,2,213,345,234,23,124,32423,2,4,5,77,7,83,5,234,62]  # debug test
  ret = mergeSort($classContainer)
  #print classContainer.reverse # for some reason it prints backwards
  #puts ""
  return ret
end

while (!quit)
  commandBool = false
  puts " "

  if n==-1 # starting point
    #obj = $classContainer[n].new # to be volatile
    obj = Object.new
    n+=1
  end

  #debug
  #puts "n: "+n.to_s
  #puts "h: "+h.to_s

  # print info
  puts "Class: " + obj.class.to_s
  puts "Superclass: "+obj.class.superclass.to_s
  puts "Subclasses: " + alphaSort(obj).reverse.to_s
  puts "Methods: " + mergeSort(obj.class.methods).to_s

  while(!commandBool)
    print '---> Enter your command: '
    command = gets.chomp

    if command == 'q'
      # quit the program by releasing the constraints
      puts "---> Exiting.."
      quit = true
      commandBool = true

    elsif command == 's'
      # prints the info again, it will quit the 2nd while loop and re-enter it again
      commandBool=true

    elsif command[0] == 'u'
      # numeric switch to subclass thro array
      command = command[2..]
      n = command.to_i
      #puts n #debug
      #puts $classContainer
      h=h+1
      obj = ($classContainer[n]).new
      $history.push($classContainer[n])
      commandBool = true

    elsif command == 'v'
      # print list of instance variables defined in class not inherited btw
      puts obj.instance_variables.inspect

    elsif command[0] == 'c'
      # name of a subclass becomes main class
      command = command[2..]
      obj = Kernel.const_get(command).new
      $history.push(Kernel.const_get(command))
      h+=1
      commandBool = true

    elsif command == 'b'
      # moves backwards
      if h>0
        h=h-1
        obj = $history[h].new
        commandBool = true
      else
        puts "---> Can't go that far back"
      end

    elsif command == 'f'
      # moves forwards
      if $history[h+1] != nil
        h=h+1
        obj = $history[h].new
        commandBool = true
      else
        puts "---> I don't know the future"
      end

    else
      puts "--> There's no such command."
    end
  end  # command while

end