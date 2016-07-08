# DBus 数据总线
require './Bus.rb'

class DBus < Bus

  def setData data # 传送数据
    data = decoder data
    @device[data[0]].getData data[1]
  end
end
# Ready

